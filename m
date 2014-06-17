Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965705AbaFQQ7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:59:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50412 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090AbaFQQPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:15:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Mason <clm@fb.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 008/121] mlx4_en: don't use napi_synchronize inside mlx4_en_netpoll
Date: Tue, 17 Jun 2014 09:13:21 -0700
Message-Id: <1403021714-16320-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021714-16320-1-git-send-email-kamal@canonical.com>
References: <1403021714-16320-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_cq.c     | 1 -
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 6 +-----
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   | 1 -
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_cq.c b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
index b8d0854..20a0fae 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
@@ -55,7 +55,6 @@ int mlx4_en_create_cq(struct mlx4_en_priv *priv,
 
 	cq->ring = ring;
 	cq->is_tx = mode;
-	spin_lock_init(&cq->lock);
 
 	err = mlx4_alloc_hwq_res(mdev->dev, &cq->wqres,
 				cq->buf_size, 2 * PAGE_SIZE);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index bf3f4bc..29c8ce3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -823,15 +823,11 @@ static void mlx4_en_netpoll(struct net_device *dev)
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
index 8d54412..b226e76 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -295,7 +295,6 @@ struct mlx4_en_cq {
 	struct mlx4_cq          mcq;
 	struct mlx4_hwq_resources wqres;
 	int                     ring;
-	spinlock_t              lock;
 	struct net_device      *dev;
 	struct napi_struct	napi;
 	int size;
-- 
1.9.1

