Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaGZTUl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:20:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbaGZTNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 033/109] net/mlx4_en: Dont configure the HW vxlan parser when vxlan offloading isnt set
Date: Sat, 26 Jul 2014 12:01:55 -0700
Message-Id: <20140726190224.821996017@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Gerlitz <ogerlitz@mellanox.com>

[ Upstream commit e326f2f13b209d56782609e833b87cb497e64b3b ]

The add_vxlan_port ndo driver code was wrongly testing whether HW vxlan offloads
are supported by the device instead of checking if they are currently enabled.

This causes the driver to configure the HW parser to conduct matching for vxlan
packets but since no steering rules were set, vxlan packets are dropped on RX.

Fix that by doing the right test, as done in the del_vxlan_port ndo handler.

Fixes: 1b136de ('net/mlx4: Implement vxlan ndo calls')
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2303,7 +2303,7 @@ static void mlx4_en_add_vxlan_port(struc
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	__be16 current_port;
 
-	if (!(priv->mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_VXLAN_OFFLOADS))
+	if (priv->mdev->dev->caps.tunnel_offload_mode != MLX4_TUNNEL_OFFLOAD_MODE_VXLAN)
 		return;
 
 	if (sa_family == AF_INET6)


