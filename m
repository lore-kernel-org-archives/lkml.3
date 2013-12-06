Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162211Ab3LFWWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:22:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759202Ab3LFVxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Amir Vadai <amirv@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 02/58] net/mlx4_en: Fixed crash when port type is changed
Date: Fri,  6 Dec 2013 13:51:33 -0800
Message-Id: <20131206214845.148593497@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Vadai <amirv@mellanox.com>

[ Upstream commit 1ec4864b10171b0691ee196d7006ae56d2c153f2 ]

timecounter_init() was was called only after first potential
timecounter_read().
Moved mlx4_en_init_timestamp() before mlx4_en_init_netdev()

Signed-off-by: Amir Vadai <amirv@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_main.c
@@ -264,6 +264,10 @@ static void *mlx4_en_add(struct mlx4_dev
 	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_ETH)
 		mdev->port_cnt++;
 
+	/* Initialize time stamp mechanism */
+	if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_TS)
+		mlx4_en_init_timestamp(mdev);
+
 	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_ETH) {
 		if (!dev->caps.comp_pool) {
 			mdev->profile.prof[i].rx_ring_num =
@@ -301,10 +305,6 @@ static void *mlx4_en_add(struct mlx4_dev
 			mdev->pndev[i] = NULL;
 	}
 
-	/* Initialize time stamp mechanism */
-	if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_TS)
-		mlx4_en_init_timestamp(mdev);
-
 	return mdev;
 
 err_mr:


