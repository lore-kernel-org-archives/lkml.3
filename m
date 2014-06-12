Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaFLXVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:21:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaFLXTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:19:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Mason <clm@fb.com>, Amir Vadai <amirv@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>,
        Masoud Sharbiani <msharbiani@twitter.com>
Subject: [PATCH 3.4 1/8] mlx4_en: dont use napi_synchronize inside mlx4_en_netpoll
Date: Thu, 12 Jun 2014 16:22:48 -0700
Message-Id: <20140612232238.514216131@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140612232238.396722659@linuxfoundation.org>
References: <20140612232238.396722659@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Masoud Sharbiani <msharbiani@twitter.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/en_cq.c     |    1 -
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    6 +-----
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |    1 -
 3 files changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
@@ -55,7 +55,6 @@ int mlx4_en_create_cq(struct mlx4_en_pri
 
 	cq->ring = ring;
 	cq->is_tx = mode;
-	spin_lock_init(&cq->lock);
 
 	err = mlx4_alloc_hwq_res(mdev->dev, &cq->wqres,
 				cq->buf_size, 2 * PAGE_SIZE);
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -370,15 +370,11 @@ static void mlx4_en_netpoll(struct net_d
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
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -301,7 +301,6 @@ struct mlx4_en_cq {
 	struct mlx4_cq          mcq;
 	struct mlx4_hwq_resources wqres;
 	int                     ring;
-	spinlock_t              lock;
 	struct net_device      *dev;
 	struct napi_struct	napi;
 	/* Per-core Tx cq processing support */


