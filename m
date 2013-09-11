Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab3IKXKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 19:10:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15055 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab3IKXKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 19:10:43 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=VF7dqGJyqkkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=9X23uQxbAoYA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=saDzm_MoSTlAY2t1-XoA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=IOg8bgcf99sfnX3y:21 a=HV7KrVFm9ykUnRZ6:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042901.990340930@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [057/251] macvtap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0057-macvtap-do-not-zerocopy-if-iov-needs-more-pages-than.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit ece793fcfc417b3925844be88a6a6dc82ae8f7c6 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/macvtap.c |   62 +++++++++++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 25 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 28c8ad9..43d3ed8 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -642,6 +642,28 @@ static int macvtap_skb_to_vnet_hdr(const struct sk_buff *skb,
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
@@ -688,31 +710,15 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
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
@@ -724,9 +730,15 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
 
 	if (zerocopy)
 		err = zerocopy_sg_from_iovec(skb, iv, vnet_hdr_len, count);
-	else
+	else {
 		err = skb_copy_datagram_from_iovec(skb, 0, iv, vnet_hdr_len,
 						   len);
+		if (!err && m && m->msg_control) {
+			struct ubuf_info *uarg = m->msg_control;
+			uarg->callback(uarg, false);
+		}
+	}
+
 	if (err)
 		goto err_kfree;
 
-- 
1.7.10.4


