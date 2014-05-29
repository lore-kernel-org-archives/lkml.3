Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935016AbaE2OPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:15:51 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59362 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933222AbaE2Ntb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 050/103] mlx4_en: don't use napi_synchronize inside mlx4_en_netpoll
Date: Thu, 29 May 2014 15:48:35 +0200
Message-Id: <0610ae43cefde18c9270e7c791faa629382200f1.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Mason <clm@fb.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/mellanox/mlx4/en_cq.c     | 1 -
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 6 +-----
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   | 1 -
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_cq.c b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
index 3e2d5047cdb3..d9303d8d9280 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
@@ -55,7 +55,6 @@ int mlx4_en_create_cq(struct mlx4_en_priv *priv,
 
 	cq->ring = ring;
 	cq->is_tx = mode;
-	spin_lock_init(&cq->lock);
 
 	err = mlx4_alloc_hwq_res(mdev->dev, &cq->wqres,
 				cq->buf_size, 2 * PAGE_SIZE);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index fa37b7a61213..35d3821bed50 100644
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
index bf06e3610d27..a47455fcfb56 100644
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
1.9.3

