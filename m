Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbaLOPTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:19:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38192 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaLOO1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 011/168] net/mlx4_en: Advertize encapsulation offloads features only when VXLAN tunnel is set
Date: Mon, 15 Dec 2014 14:24:25 +0000
Message-Id: <1418653622-21105-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Gerlitz <ogerlitz@mellanox.com>

commit f4a1edd56120249198073aa4a373b77e3700ac8f upstream.

Currenly we only support Large-Send and TX checksum offloads for
encapsulated traffic of type VXLAN. We must make sure to advertize
these offloads up to the stack only when VXLAN tunnel is set.

Failing to do so, would mislead the the networking stack to assume
that the driver can offload the internal TX checksum for GRE packets
and other buggy schemes.

Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 128f0728d97d..04b2d8e117cb 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2312,8 +2312,16 @@ static void mlx4_en_add_vxlan_offloads(struct work_struct *work)
 	ret = mlx4_SET_PORT_VXLAN(priv->mdev->dev, priv->port,
 				  VXLAN_STEER_BY_OUTER_MAC, 1);
 out:
-	if (ret)
+	if (ret) {
 		en_err(priv, "failed setting L2 tunnel configuration ret %d\n", ret);
+		return;
+	}
+
+	/* set offloads */
+	priv->dev->hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
+				      NETIF_F_TSO | NETIF_F_GSO_UDP_TUNNEL;
+	priv->dev->hw_features |= NETIF_F_GSO_UDP_TUNNEL;
+	priv->dev->features    |= NETIF_F_GSO_UDP_TUNNEL;
 }
 
 static void mlx4_en_del_vxlan_offloads(struct work_struct *work)
@@ -2321,6 +2329,11 @@ static void mlx4_en_del_vxlan_offloads(struct work_struct *work)
 	int ret;
 	struct mlx4_en_priv *priv = container_of(work, struct mlx4_en_priv,
 						 vxlan_del_task);
+	/* unset offloads */
+	priv->dev->hw_enc_features &= ~(NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
+				      NETIF_F_TSO | NETIF_F_GSO_UDP_TUNNEL);
+	priv->dev->hw_features &= ~NETIF_F_GSO_UDP_TUNNEL;
+	priv->dev->features    &= ~NETIF_F_GSO_UDP_TUNNEL;
 
 	ret = mlx4_SET_PORT_VXLAN(priv->mdev->dev, priv->port,
 				  VXLAN_STEER_BY_OUTER_MAC, 0);
@@ -2601,13 +2614,6 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	if (mdev->dev->caps.steering_mode != MLX4_STEERING_MODE_A0)
 		dev->priv_flags |= IFF_UNICAST_FLT;
 
-	if (mdev->dev->caps.tunnel_offload_mode == MLX4_TUNNEL_OFFLOAD_MODE_VXLAN) {
-		dev->hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
-					NETIF_F_TSO | NETIF_F_GSO_UDP_TUNNEL;
-		dev->hw_features |= NETIF_F_GSO_UDP_TUNNEL;
-		dev->features    |= NETIF_F_GSO_UDP_TUNNEL;
-	}
-
 	mdev->pndev[port] = dev;
 
 	netif_carrier_off(dev);
-- 
2.1.3

