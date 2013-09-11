Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab3IKXKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 19:10:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13083 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab3IKXKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 19:10:43 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=uLSofCuKDt8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=bgfgPL1M8IsA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=saDzm_MoSTlAY2t1-XoA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=lUh7PYw152IVQFY1:21 a=WMVv_67GUrhPhmKV:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042901.689864786@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [056/251] tuntap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0056-tuntap-do-not-zerocopy-if-iov-needs-more-pages-than-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/tun.c |   63 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index ad08dee..9ab7b34 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -685,6 +685,30 @@ static int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
 	return 0;
 }
 
+
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
 static ssize_t tun_get_user(struct tun_struct *tun, void *msg_control,
 			    const struct iovec *iv, size_t total_len,
@@ -731,32 +755,18 @@ static ssize_t tun_get_user(struct tun_struct *tun, void *msg_control,
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
@@ -771,8 +781,13 @@ static ssize_t tun_get_user(struct tun_struct *tun, void *msg_control,
 
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
-- 
1.7.10.4


