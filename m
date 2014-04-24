Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbaDXJSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:18:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47046 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbaDXI4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:56:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Mason <clm@fb.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 157/182] mlx4_en: don't use napi_synchronize inside mlx4_en_netpoll
Date: Thu, 24 Apr 2014 09:51:22 +0100
Message-Id: <1398329507-5911-158-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@fb.com>

commit c98235cb8584a72e95786e17d695a8e5fafcd766 upstream.

The mlx4 driver is triggering schedules while atomic inside
mlx4_en_netpoll:

	spin_lock_irqsave(&cq->lock, flags);
	napi_synchronize(&cq->napi);
		^^^^^ msleep here
	mlx4_en_process_rx_cq(dev, cq, 0);
	spin_unlock_irqrestore(&cq->lock, flags);

This was part of a patch by Alexander Guller from Mellanox in 2011,
but it still isn't upstream.

Signed-off-by: Chris Mason <clm@fb.com>
Acked-By: Amir Vadai <amirv@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_cq.c     | 1 -
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 6 +-----
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   | 1 -
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_cq.c b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
index 3e2d504..d9303d8 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
@@ -55,7 +55,6 @@ int mlx4_en_create_cq(struct mlx4_en_priv *priv,
 
 	cq->ring = ring;
 	cq->is_tx = mode;
-	spin_lock_init(&cq->lock);
 
 	err = mlx4_alloc_hwq_res(mdev->dev, &cq->wqres,
 				cq->buf_size, 2 * PAGE_SIZE);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index fa37b7a..35d3821 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1219,15 +1219,11 @@ static void mlx4_en_netpoll(struct net_device *dev)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	struct mlx4_en_cq *cq;
-	unsigned long flags;
 	int i;
 
 	for (i = 0; i < priv->rx_ring_num; i++) {
 		cq = &priv->rx_cq[i];
-		spin_lock_irqsave(&cq->lock, flags);
-		napi_synchronize(&cq->napi);
-		mlx4_en_process_rx_cq(dev, cq, 0);
-		spin_unlock_irqrestore(&cq->lock, flags);
+		napi_schedule(&cq->napi);
 	}
 }
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index bf06e36..a47455f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -306,7 +306,6 @@ struct mlx4_en_cq {
 	struct mlx4_cq          mcq;
 	struct mlx4_hwq_resources wqres;
 	int                     ring;
-	spinlock_t              lock;
 	struct net_device      *dev;
 	struct napi_struct	napi;
 	int size;
-- 
1.9.1

