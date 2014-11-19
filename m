Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbaKSWVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:21:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568AbaKSUyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 042/141] tun: Fix csum_start with VLAN acceleration
Date: Wed, 19 Nov 2014 12:51:05 -0800
Message-Id: <20141119205152.045115160@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/tun.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1225,6 +1225,10 @@ static ssize_t tun_put_user(struct tun_s
 	struct tun_pi pi = { 0, skb->protocol };
 	ssize_t total = 0;
 	int vlan_offset = 0, copied;
+	int vlan_hlen = 0;
+
+	if (vlan_tx_tag_present(skb))
+		vlan_hlen = VLAN_HLEN;
 
 	if (!(tun->flags & TUN_NO_PI)) {
 		if ((len -= sizeof(pi)) < 0)
@@ -1276,7 +1280,8 @@ static ssize_t tun_put_user(struct tun_s
 
 		if (skb->ip_summed == CHECKSUM_PARTIAL) {
 			gso.flags = VIRTIO_NET_HDR_F_NEEDS_CSUM;
-			gso.csum_start = skb_checksum_start_offset(skb);
+			gso.csum_start = skb_checksum_start_offset(skb) +
+					 vlan_hlen;
 			gso.csum_offset = skb->csum_offset;
 		} else if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
 			gso.flags = VIRTIO_NET_HDR_F_DATA_VALID;
@@ -1289,10 +1294,9 @@ static ssize_t tun_put_user(struct tun_s
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
@@ -1303,8 +1307,6 @@ static ssize_t tun_put_user(struct tun_s
 		veth.h_vlan_TCI = htons(vlan_tx_tag_get(skb));
 
 		vlan_offset = offsetof(struct vlan_ethhdr, h_vlan_proto);
-		len = min_t(int, skb->len + VLAN_HLEN, len);
-		total += VLAN_HLEN;
 
 		copy = min_t(int, vlan_offset, len);
 		ret = skb_copy_datagram_const_iovec(skb, 0, iv, copied, copy);


