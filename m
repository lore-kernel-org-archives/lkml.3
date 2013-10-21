Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3JUIxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:53:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39842 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754393Ab3JUIxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jason Wang" <jasowang@redhat.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.983974510@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 129/149] macvtap: do not zerocopy if iov needs more
 pages than MAX_SKB_FRAGS
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit ece793fcfc417b3925844be88a6a6dc82ae8f7c6 upstream.

We try to linearize part of the skb when the number of iov is greater than
MAX_SKB_FRAGS. This is not enough since each single vector may occupy more than
one pages, so zerocopy_sg_fromiovec() may still fail and may break the guest
network.

Solve this problem by calculate the pages needed for iov before trying to do
zerocopy and switch to use copy instead of zerocopy if it needs more than
MAX_SKB_FRAGS.

This is done through introducing a new helper to count the pages for iov, and
call uarg->callback() manually when switching from zerocopy to copy to notify
vhost.

We can do further optimization on top.

This bug were introduced from b92946e2919134ebe2a4083e4302236295ea2a73
(macvtap: zerocopy: validate vectors before building skb).

Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.2: callback only takes one argument]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/macvtap.c | 62 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 25 deletions(-)

--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -641,6 +641,28 @@ static int macvtap_skb_to_vnet_hdr(const
 	return 0;
 }
 
+static unsigned long iov_pages(const struct iovec *iv, int offset,
+			       unsigned long nr_segs)
+{
+	unsigned long seg, base;
+	int pages = 0, len, size;
+
+	while (nr_segs && (offset >= iv->iov_len)) {
+		offset -= iv->iov_len;
+		++iv;
+		--nr_segs;
+	}
+
+	for (seg = 0; seg < nr_segs; seg++) {
+		base = (unsigned long)iv[seg].iov_base + offset;
+		len = iv[seg].iov_len - offset;
+		size = ((base & ~PAGE_MASK) + len + ~PAGE_MASK) >> PAGE_SHIFT;
+		pages += size;
+		offset = 0;
+	}
+
+	return pages;
+}
 
 /* Get packet from user space buffer */
 static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
@@ -687,31 +709,15 @@ static ssize_t macvtap_get_user(struct m
 	if (unlikely(count > UIO_MAXIOV))
 		goto err;
 
-	if (m && m->msg_control && sock_flag(&q->sk, SOCK_ZEROCOPY))
-		zerocopy = true;
-
-	if (zerocopy) {
-		/* Userspace may produce vectors with count greater than
-		 * MAX_SKB_FRAGS, so we need to linearize parts of the skb
-		 * to let the rest of data to be fit in the frags.
-		 */
-		if (count > MAX_SKB_FRAGS) {
-			copylen = iov_length(iv, count - MAX_SKB_FRAGS);
-			if (copylen < vnet_hdr_len)
-				copylen = 0;
-			else
-				copylen -= vnet_hdr_len;
-		}
-		/* There are 256 bytes to be copied in skb, so there is enough
-		 * room for skb expand head in case it is used.
-		 * The rest buffer is mapped from userspace.
-		 */
-		if (copylen < vnet_hdr.hdr_len)
-			copylen = vnet_hdr.hdr_len;
-		if (!copylen)
-			copylen = GOODCOPY_LEN;
+	if (m && m->msg_control && sock_flag(&q->sk, SOCK_ZEROCOPY)) {
+		copylen = vnet_hdr.hdr_len ? vnet_hdr.hdr_len : GOODCOPY_LEN;
 		linear = copylen;
-	} else {
+		if (iov_pages(iv, vnet_hdr_len + copylen, count)
+		    <= MAX_SKB_FRAGS)
+			zerocopy = true;
+	}
+
+	if (!zerocopy) {
 		copylen = len;
 		linear = vnet_hdr.hdr_len;
 	}
@@ -723,9 +729,15 @@ static ssize_t macvtap_get_user(struct m
 
 	if (zerocopy)
 		err = zerocopy_sg_from_iovec(skb, iv, vnet_hdr_len, count);
-	else
+	else {
 		err = skb_copy_datagram_from_iovec(skb, 0, iv, vnet_hdr_len,
 						   len);
+		if (!err && m && m->msg_control) {
+			struct ubuf_info *uarg = m->msg_control;
+			uarg->callback(uarg);
+		}
+	}
+
 	if (err)
 		goto err_kfree;
 

