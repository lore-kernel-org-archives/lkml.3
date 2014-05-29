Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934485AbaE2F2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:28:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367AbaE2EfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Mason <clm@fb.com>, Amir Vadai <amirv@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 052/140] mlx4_en: dont use napi_synchronize inside mlx4_en_netpoll
Date: Wed, 28 May 2014 21:33:11 -0700
Message-Id: <20140529043056.121896578@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/en_cq.c     |    1 -
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    6 +-----
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |    1 -
 3 files changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
@@ -66,7 +66,6 @@ int mlx4_en_create_cq(struct mlx4_en_pri
 
 	cq->ring = ring;
 	cq->is_tx = mode;
-	spin_lock_init(&cq->lock);
 
 	/* Allocate HW buffers on provided NUMA node.
 	 * dev->numa_node is used in mtt range allocation flow.
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1315,15 +1315,11 @@ static void mlx4_en_netpoll(struct net_d
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	struct mlx4_en_cq *cq;
-	unsigned long flags;
 	int i;
 
 	for (i = 0; i < priv->rx_ring_num; i++) {
 		cq = priv->rx_cq[i];
-		spin_lock_irqsave(&cq->lock, flags);
-		napi_synchronize(&cq->napi);
-		mlx4_en_process_rx_cq(dev, cq, 0);
-		spin_unlock_irqrestore(&cq->lock, flags);
+		napi_schedule(&cq->napi);
 	}
 }
 #endif
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -309,7 +309,6 @@ struct mlx4_en_cq {
 	struct mlx4_cq          mcq;
 	struct mlx4_hwq_resources wqres;
 	int                     ring;
-	spinlock_t              lock;
 	struct net_device      *dev;
 	struct napi_struct	napi;
 	int size;


