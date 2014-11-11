Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbaKKLra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:47:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57508 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbaKKLKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 081/170] net/mlx4_en: Don't attempt to TX offload the outer UDP checksum for VXLAN
Date: Tue, 11 Nov 2014 11:07:20 +0000
Message-Id: <1415704129-12709-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Gerlitz <ogerlitz@mellanox.com>

commit a4f2dacbf2a5045e34b98a35d9a3857800f25a7b upstream.

For VXLAN/NVGRE encapsulation, the current HW doesn't support offloading
both the outer UDP TX checksum and the inner TCP/UDP TX checksum.

The driver doesn't advertize SKB_GSO_UDP_TUNNEL_CSUM, however we are wrongly
telling the HW to offload the outer UDP checksum for encapsulated packets,
fix that.

Fixes: 837052d0ccc5 ('net/mlx4_en: Add netdev support for TCP/IP
		     offloads of vxlan tunneling')
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 5045bab59633..0610c85d4371 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -803,8 +803,11 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_desc->ctrl.fence_size = (real_size / 16) & 0x3f;
 	tx_desc->ctrl.srcrb_flags = priv->ctrl_flags;
 	if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
-		tx_desc->ctrl.srcrb_flags |= cpu_to_be32(MLX4_WQE_CTRL_IP_CSUM |
-							 MLX4_WQE_CTRL_TCP_UDP_CSUM);
+		if (!skb->encapsulation)
+			tx_desc->ctrl.srcrb_flags |= cpu_to_be32(MLX4_WQE_CTRL_IP_CSUM |
+								 MLX4_WQE_CTRL_TCP_UDP_CSUM);
+		else
+			tx_desc->ctrl.srcrb_flags |= cpu_to_be32(MLX4_WQE_CTRL_IP_CSUM);
 		ring->tx_csum++;
 	}
 
-- 
2.1.0

