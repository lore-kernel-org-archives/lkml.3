Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab3I3KMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:12:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43555 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab3I3KMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 045/104] macvtap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS
Date: Mon, 30 Sep 2013 11:10:22 +0100
Message-Id: <1380535881-9239-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5:
  - struct ubuf_info callback takes only one argument ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/macvtap.c | 62 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 25 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index cc5b48d..8b7c4f2 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -643,6 +643,28 @@ static int macvtap_skb_to_vnet_hdr(const struct sk_buff *skb,
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
@@ -689,31 +711,15 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
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
@@ -725,9 +731,15 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
 
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
 
-- 
1.8.3.2

