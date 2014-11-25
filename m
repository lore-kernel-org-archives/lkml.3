Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbaKYLLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:11:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58852 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbaKYKml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 168/254] tun: Fix csum_start with VLAN acceleration
Date: Tue, 25 Nov 2014 10:38:38 +0000
Message-Id: <1416912004-5928-169-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit a8f9bfdf982e2b1fb9f094e4de9ab08c57f3d2fd upstream.

When VLAN acceleration is in use on the xmit path, we end up
setting csum_start to the wrong place.  The result is that the
whoever ends up doing the checksum setting will corrupt the packet
instead of writing the checksum to the expected location, usually
this means writing the checksum with an offset of -4.

This patch fixes this by adjusting csum_start when VLAN acceleration
is detected.

Fixes: 6680ec68eff4 ("tuntap: hardware vlan tx support")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/tun.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 98bad1fb1bfb..6c48ae7b1faa 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1221,6 +1221,10 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 	struct tun_pi pi = { 0, skb->protocol };
 	ssize_t total = 0;
 	int vlan_offset = 0, copied;
+	int vlan_hlen = 0;
+
+	if (vlan_tx_tag_present(skb))
+		vlan_hlen = VLAN_HLEN;
 
 	if (!(tun->flags & TUN_NO_PI)) {
 		if ((len -= sizeof(pi)) < 0)
@@ -1272,7 +1276,8 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 
 		if (skb->ip_summed == CHECKSUM_PARTIAL) {
 			gso.flags = VIRTIO_NET_HDR_F_NEEDS_CSUM;
-			gso.csum_start = skb_checksum_start_offset(skb);
+			gso.csum_start = skb_checksum_start_offset(skb) +
+					 vlan_hlen;
 			gso.csum_offset = skb->csum_offset;
 		} else if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
 			gso.flags = VIRTIO_NET_HDR_F_DATA_VALID;
@@ -1285,10 +1290,9 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 	}
 
 	copied = total;
-	total += skb->len;
-	if (!vlan_tx_tag_present(skb)) {
-		len = min_t(int, skb->len, len);
-	} else {
+	len = min_t(int, skb->len + vlan_hlen, len);
+	total += skb->len + vlan_hlen;
+	if (vlan_hlen) {
 		int copy, ret;
 		struct {
 			__be16 h_vlan_proto;
@@ -1299,8 +1303,6 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 		veth.h_vlan_TCI = htons(vlan_tx_tag_get(skb));
 
 		vlan_offset = offsetof(struct vlan_ethhdr, h_vlan_proto);
-		len = min_t(int, skb->len + VLAN_HLEN, len);
-		total += VLAN_HLEN;
 
 		copy = min_t(int, vlan_offset, len);
 		ret = skb_copy_datagram_const_iovec(skb, 0, iv, copied, copy);
-- 
2.1.0

