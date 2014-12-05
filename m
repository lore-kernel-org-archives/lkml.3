Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaLEWqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:46:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbaLEWqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 028/122] net/mlx4_en: Advertize encapsulation offloads features only when VXLAN tunnel is set
Date: Fri,  5 Dec 2014 14:43:22 -0800
Message-Id: <20141205223309.678375104@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Gerlitz <ogerlitz@mellanox.com>

[ Upstream commit f4a1edd56120249198073aa4a373b77e3700ac8f ]

Currenly we only support Large-Send and TX checksum offloads for
encapsulated traffic of type VXLAN. We must make sure to advertize
these offloads up to the stack only when VXLAN tunnel is set.

Failing to do so, would mislead the the networking stack to assume
that the driver can offload the internal TX checksum for GRE packets
and other buggy schemes.

Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2281,8 +2281,16 @@ static void mlx4_en_add_vxlan_offloads(s
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
@@ -2290,6 +2298,11 @@ static void mlx4_en_del_vxlan_offloads(s
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
@@ -2571,13 +2584,6 @@ int mlx4_en_init_netdev(struct mlx4_en_d
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


