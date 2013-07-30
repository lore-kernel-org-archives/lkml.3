Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab3G3SsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:48:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56618 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757730Ab3G3SsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:48:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 73/75] tuntap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS
Date: Tue, 30 Jul 2013 11:45:17 -0700
Message-Id: <1375209919-1768-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/tun.c | 62 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 24 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 0ebfa18..340cee2 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1038,6 +1038,29 @@ static int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
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
@@ -1085,32 +1108,18 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
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
@@ -1124,8 +1133,13 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
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
1.8.1.2

