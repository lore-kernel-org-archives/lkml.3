Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981Ab3GZUsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:48:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759926Ab3GZUsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 39/79] tuntap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS
Date: Fri, 26 Jul 2013 13:47:29 -0700
Message-Id: <20130726204726.024472887@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 885291761dba2bfe04df4c0f7bb75e4c920ab82e ]

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

The bug were introduced from commit 0690899b4d4501b3505be069b9a687e68ccbe15b
(tun: experimental zero copy tx support)

Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |   62 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 24 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1037,6 +1037,29 @@ static int zerocopy_sg_from_iovec(struct
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
+
 /* Get packet from user space buffer */
 static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 			    void *msg_control, const struct iovec *iv,
@@ -1084,32 +1107,18 @@ static ssize_t tun_get_user(struct tun_s
 			return -EINVAL;
 	}
 
-	if (msg_control)
-		zerocopy = true;
-
-	if (zerocopy) {
-		/* Userspace may produce vectors with count greater than
-		 * MAX_SKB_FRAGS, so we need to linearize parts of the skb
-		 * to let the rest of data to be fit in the frags.
-		 */
-		if (count > MAX_SKB_FRAGS) {
-			copylen = iov_length(iv, count - MAX_SKB_FRAGS);
-			if (copylen < offset)
-				copylen = 0;
-			else
-				copylen -= offset;
-		} else
-				copylen = 0;
-		/* There are 256 bytes to be copied in skb, so there is enough
-		 * room for skb expand head in case it is used.
+	if (msg_control) {
+		/* There are 256 bytes to be copied in skb, so there is
+		 * enough room for skb expand head in case it is used.
 		 * The rest of the buffer is mapped from userspace.
 		 */
-		if (copylen < gso.hdr_len)
-			copylen = gso.hdr_len;
-		if (!copylen)
-			copylen = GOODCOPY_LEN;
+		copylen = gso.hdr_len ? gso.hdr_len : GOODCOPY_LEN;
 		linear = copylen;
-	} else {
+		if (iov_pages(iv, offset + copylen, count) <= MAX_SKB_FRAGS)
+			zerocopy = true;
+	}
+
+	if (!zerocopy) {
 		copylen = len;
 		linear = gso.hdr_len;
 	}
@@ -1123,8 +1132,13 @@ static ssize_t tun_get_user(struct tun_s
 
 	if (zerocopy)
 		err = zerocopy_sg_from_iovec(skb, iv, offset, count);
-	else
+	else {
 		err = skb_copy_datagram_from_iovec(skb, 0, iv, offset, len);
+		if (!err && msg_control) {
+			struct ubuf_info *uarg = msg_control;
+			uarg->callback(uarg, false);
+		}
+	}
 
 	if (err) {
 		tun->dev->stats.rx_dropped++;


