Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaLCLqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:46:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbaLCL13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 021/101] tun: Fix csum_start with VLAN acceleration
Date: Wed,  3 Dec 2014 12:25:43 +0100
Message-Id: <c150584886e5542df2a9fb4d0189f492d9d69b35.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/tun.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 495830a8ee28..d72d06301642 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1189,6 +1189,10 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 	struct tun_pi pi = { 0, skb->protocol };
 	ssize_t total = 0;
 	int vlan_offset = 0, copied;
+	int vlan_hlen = 0;
+
+	if (vlan_tx_tag_present(skb))
+		vlan_hlen = VLAN_HLEN;
 
 	if (!(tun->flags & TUN_NO_PI)) {
 		if ((len -= sizeof(pi)) < 0)
@@ -1240,7 +1244,8 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 
 		if (skb->ip_summed == CHECKSUM_PARTIAL) {
 			gso.flags = VIRTIO_NET_HDR_F_NEEDS_CSUM;
-			gso.csum_start = skb_checksum_start_offset(skb);
+			gso.csum_start = skb_checksum_start_offset(skb) +
+					 vlan_hlen;
 			gso.csum_offset = skb->csum_offset;
 		} else if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
 			gso.flags = VIRTIO_NET_HDR_F_DATA_VALID;
@@ -1253,10 +1258,9 @@ static ssize_t tun_put_user(struct tun_struct *tun,
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
@@ -1267,8 +1271,6 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 		veth.h_vlan_TCI = htons(vlan_tx_tag_get(skb));
 
 		vlan_offset = offsetof(struct vlan_ethhdr, h_vlan_proto);
-		len = min_t(int, skb->len + VLAN_HLEN, len);
-		total += VLAN_HLEN;
 
 		copy = min_t(int, vlan_offset, len);
 		ret = skb_copy_datagram_const_iovec(skb, 0, iv, copied, copy);
-- 
2.1.3

