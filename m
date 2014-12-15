Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbaLOPTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:19:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38190 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaLOO1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 010/168] net/mlx4_en: Add VXLAN ndo calls to the PF net device ops too
Date: Mon, 15 Dec 2014 14:24:24 +0000
Message-Id: <1418653622-21105-11-git-send-email-luis.henriques@canonical.com>
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

commit 9737c6ab7afbc950e997ef80cba2c40dbbd16ea4 upstream.

This is currently missing, which results in a crash when one attempts
to set VXLAN tunnel over the mlx4_en when acting as PF.

	[ 2408.785472] BUG: unable to handle kernel NULL pointer dereference at (null)
	[...]
	[ 2408.994104] Call Trace:
	[ 2408.996584]  [<ffffffffa021f7f5>] ? vxlan_get_rx_port+0xd6/0x103 [vxlan]
	[ 2409.003316]  [<ffffffffa021f71f>] ? vxlan_lowerdev_event+0xf2/0xf2 [vxlan]
	[ 2409.010225]  [<ffffffffa0630358>] mlx4_en_start_port+0x862/0x96a [mlx4_en]
	[ 2409.017132]  [<ffffffffa063070f>] mlx4_en_open+0x17f/0x1b8 [mlx4_en]

While here, make sure to invoke vxlan_get_rx_port() only when VXLAN
offloads are actually enabled and not when they are only supported.

Reported-by: Ido Shamay <idos@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.16: used davem's backport to 3.17 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 7345c43b019e..128f0728d97d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1724,7 +1724,7 @@ int mlx4_en_start_port(struct net_device *dev)
 	mlx4_set_stats_bitmap(mdev->dev, &priv->stats_bitmap);
 
 #ifdef CONFIG_MLX4_EN_VXLAN
-	if (priv->mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_VXLAN_OFFLOADS)
+	if (priv->mdev->dev->caps.tunnel_offload_mode == MLX4_TUNNEL_OFFLOAD_MODE_VXLAN)
 		vxlan_get_rx_port(dev);
 #endif
 	priv->port_up = true;
@@ -2434,6 +2434,10 @@ static const struct net_device_ops mlx4_netdev_ops_master = {
 	.ndo_rx_flow_steer	= mlx4_en_filter_rfs,
 #endif
 	.ndo_get_phys_port_id	= mlx4_en_get_phys_port_id,
+#ifdef CONFIG_MLX4_EN_VXLAN
+	.ndo_add_vxlan_port	= mlx4_en_add_vxlan_port,
+	.ndo_del_vxlan_port	= mlx4_en_del_vxlan_port,
+#endif
 };
 
 int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
-- 
2.1.3

