Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab3LSNMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:12:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44372 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3LSLzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:55:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amir Vadai <amirv@mellanox.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 005/208] net/mlx4_en: Fixed crash when port type is changed
Date: Thu, 19 Dec 2013 11:51:43 +0000
Message-Id: <1387454106-19326-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Vadai <amirv@mellanox.com>

commit 1ec4864b10171b0691ee196d7006ae56d2c153f2 upstream.

timecounter_init() was was called only after first potential
timecounter_read().
Moved mlx4_en_init_timestamp() before mlx4_en_init_netdev()

Signed-off-by: Amir Vadai <amirv@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_main.c b/drivers/net/ethernet/mellanox/mlx4/en_main.c
index a071cda..0d087b0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_main.c
@@ -264,6 +264,10 @@ static void *mlx4_en_add(struct mlx4_dev *dev)
 	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_ETH)
 		mdev->port_cnt++;
 
+	/* Initialize time stamp mechanism */
+	if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_TS)
+		mlx4_en_init_timestamp(mdev);
+
 	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_ETH) {
 		if (!dev->caps.comp_pool) {
 			mdev->profile.prof[i].rx_ring_num =
@@ -301,10 +305,6 @@ static void *mlx4_en_add(struct mlx4_dev *dev)
 			mdev->pndev[i] = NULL;
 	}
 
-	/* Initialize time stamp mechanism */
-	if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_TS)
-		mlx4_en_init_timestamp(mdev);
-
 	return mdev;
 
 err_mr:
-- 
1.8.3.2

