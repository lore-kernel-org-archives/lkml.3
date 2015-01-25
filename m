Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbbAYSIv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:08:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbbAYSIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:08:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>, Thomas Graf <tgraf@suug.ch>
Subject: [PATCH 3.10 01/50] netlink: Always copy on mmap TX.
Date: Sun, 25 Jan 2015 10:06:51 -0800
Message-Id: <20150125180702.677130456@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180702.521559311@linuxfoundation.org>
References: <20150125180702.521559311@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Miller <davem@davemloft.net>

[ Upstream commit 4682a0358639b29cf69437ed909c6221f8c89847 ]

Checking the file f_count and the nlk->mapped count is not completely
sufficient to prevent the mmap'd area contents from changing from
under us during netlink mmap sendmsg() operations.

Be careful to sample the header's length field only once, because this
could change from under us as well.

Fixes: 5fd96123ee19 ("netlink: implement memory mapped sendmsg()")
Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/af_netlink.c |   52 ++++++++++++++---------------------------------
 1 file changed, 16 insertions(+), 36 deletions(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -374,14 +374,14 @@ out:
 	return err;
 }
 
-static void netlink_frame_flush_dcache(const struct nl_mmap_hdr *hdr)
+static void netlink_frame_flush_dcache(const struct nl_mmap_hdr *hdr, unsigned int nm_len)
 {
 #if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE == 1
 	struct page *p_start, *p_end;
 
 	/* First page is flushed through netlink_{get,set}_status */
 	p_start = pgvec_to_page(hdr + PAGE_SIZE);
-	p_end   = pgvec_to_page((void *)hdr + NL_MMAP_HDRLEN + hdr->nm_len - 1);
+	p_end   = pgvec_to_page((void *)hdr + NL_MMAP_HDRLEN + nm_len - 1);
 	while (p_start <= p_end) {
 		flush_dcache_page(p_start);
 		p_start++;
@@ -563,24 +563,16 @@ static int netlink_mmap_sendmsg(struct s
 	struct nl_mmap_hdr *hdr;
 	struct sk_buff *skb;
 	unsigned int maxlen;
-	bool excl = true;
 	int err = 0, len = 0;
 
-	/* Netlink messages are validated by the receiver before processing.
-	 * In order to avoid userspace changing the contents of the message
-	 * after validation, the socket and the ring may only be used by a
-	 * single process, otherwise we fall back to copying.
-	 */
-	if (atomic_long_read(&sk->sk_socket->file->f_count) > 1 ||
-	    atomic_read(&nlk->mapped) > 1)
-		excl = false;
-
 	mutex_lock(&nlk->pg_vec_lock);
 
 	ring   = &nlk->tx_ring;
 	maxlen = ring->frame_size - NL_MMAP_HDRLEN;
 
 	do {
+		unsigned int nm_len;
+
 		hdr = netlink_current_frame(ring, NL_MMAP_STATUS_VALID);
 		if (hdr == NULL) {
 			if (!(msg->msg_flags & MSG_DONTWAIT) &&
@@ -588,35 +580,23 @@ static int netlink_mmap_sendmsg(struct s
 				schedule();
 			continue;
 		}
-		if (hdr->nm_len > maxlen) {
+
+		nm_len = ACCESS_ONCE(hdr->nm_len);
+		if (nm_len > maxlen) {
 			err = -EINVAL;
 			goto out;
 		}
 
-		netlink_frame_flush_dcache(hdr);
+		netlink_frame_flush_dcache(hdr, nm_len);
 
-		if (likely(dst_portid == 0 && dst_group == 0 && excl)) {
-			skb = alloc_skb_head(GFP_KERNEL);
-			if (skb == NULL) {
-				err = -ENOBUFS;
-				goto out;
-			}
-			sock_hold(sk);
-			netlink_ring_setup_skb(skb, sk, ring, hdr);
-			NETLINK_CB(skb).flags |= NETLINK_SKB_TX;
-			__skb_put(skb, hdr->nm_len);
-			netlink_set_status(hdr, NL_MMAP_STATUS_RESERVED);
-			atomic_inc(&ring->pending);
-		} else {
-			skb = alloc_skb(hdr->nm_len, GFP_KERNEL);
-			if (skb == NULL) {
-				err = -ENOBUFS;
-				goto out;
-			}
-			__skb_put(skb, hdr->nm_len);
-			memcpy(skb->data, (void *)hdr + NL_MMAP_HDRLEN, hdr->nm_len);
-			netlink_set_status(hdr, NL_MMAP_STATUS_UNUSED);
+		skb = alloc_skb(nm_len, GFP_KERNEL);
+		if (skb == NULL) {
+			err = -ENOBUFS;
+			goto out;
 		}
+		__skb_put(skb, nm_len);
+		memcpy(skb->data, (void *)hdr + NL_MMAP_HDRLEN, nm_len);
+		netlink_set_status(hdr, NL_MMAP_STATUS_UNUSED);
 
 		netlink_increment_head(ring);
 
@@ -662,7 +642,7 @@ static void netlink_queue_mmaped_skb(str
 	hdr->nm_pid	= NETLINK_CB(skb).creds.pid;
 	hdr->nm_uid	= from_kuid(sk_user_ns(sk), NETLINK_CB(skb).creds.uid);
 	hdr->nm_gid	= from_kgid(sk_user_ns(sk), NETLINK_CB(skb).creds.gid);
-	netlink_frame_flush_dcache(hdr);
+	netlink_frame_flush_dcache(hdr, hdr->nm_len);
 	netlink_set_status(hdr, NL_MMAP_STATUS_VALID);
 
 	NETLINK_CB(skb).flags |= NETLINK_SKB_DELIVERED;


