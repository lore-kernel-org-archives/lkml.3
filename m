Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaEYOr5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 10:47:57 -0400
Received: from mailp.voltaire.com ([193.47.165.129]:37317 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751387AbaEYOry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 10:47:54 -0400
From: Amir Vadai <amirv@mellanox.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Amir Vadai <amirv@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        netdev@vger.kernel.org, Yevgeny Petrilin <yevgenyp@mellanox.com>,
        Yuval Atias <yuvala@mellanox.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next V6 2/2] net/mlx4_en: Use affinity hint
Date: Sun, 25 May 2014 17:47:27 +0300
Message-Id: <1401029247-15196-3-git-send-email-amirv@mellanox.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1401029247-15196-1-git-send-email-amirv@mellanox.com>
References: <1401029247-15196-1-git-send-email-amirv@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuval Atias <yuvala@mellanox.com>

The “affinity hint” mechanism is used by the user space
daemon, irqbalancer, to indicate a preferred CPU mask for irqs.
Irqbalancer can use this hint to balance the irqs between the
cpus indicated by the mask.

We wish the HCA to preferentially map the IRQs it uses to numa cores
close to it.  To accomplish this, we use cpumask_set_cpu_local_first(), that
sets the affinity hint according the following policy:
First it maps IRQs to “close” numa cores.  If these are exhausted, the
remaining IRQs are mapped to “far” numa cores.

Signed-off-by: Yuval Atias <yuvala@mellanox.com>
Signed-off-by: Amir Vadai <amirv@mellanox.com>
---
 drivers/infiniband/hw/mlx4/main.c              |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_cq.c     |  6 +++++-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 30 ++++++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx4/eq.c        | 13 ++++++++++-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |  1 +
 include/linux/mlx4/device.h                    |  2 +-
 6 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index a9638ae..8c88960 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1837,7 +1837,7 @@ static void mlx4_ib_alloc_eqs(struct mlx4_dev *dev, struct mlx4_ib_dev *ibdev)
 				 i, j, dev->pdev->bus->name);
 			/* Set IRQ for specific name (per ring) */
 			if (mlx4_assign_eq(dev, name, NULL,
-					   &ibdev->eq_table[eq])) {
+					   &ibdev->eq_table[eq], NULL)) {
 				/* Use legacy (same as mlx4_en driver) */
 				pr_warn("Can't allocate EQ %d; reverting to legacy\n", eq);
 				ibdev->eq_table[eq] =
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_cq.c b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
index 636963d..ea2cd72 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
@@ -118,11 +118,15 @@ int mlx4_en_activate_cq(struct mlx4_en_priv *priv, struct mlx4_en_cq *cq,
 	if (cq->is_tx == RX) {
 		if (mdev->dev->caps.comp_pool) {
 			if (!cq->vector) {
+				struct mlx4_en_rx_ring *ring =
+					priv->rx_ring[cq->ring];
+
 				sprintf(name, "%s-%d", priv->dev->name,
 					cq->ring);
 				/* Set IRQ for specific name (per ring) */
 				if (mlx4_assign_eq(mdev->dev, name, rmap,
-						   &cq->vector)) {
+						   &cq->vector,
+						   ring->affinity_mask)) {
 					cq->vector = (cq->ring + 1 + priv->port)
 					    % mdev->dev->caps.num_comp_vectors;
 					mlx4_warn(mdev, "Failed assigning an EQ to %s, falling back to legacy EQ's\n",
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 5bb7eda..826d150 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1531,6 +1531,32 @@ static void mlx4_en_linkstate(struct work_struct *work)
 	mutex_unlock(&mdev->state_lock);
 }
 
+static void mlx4_en_init_affinity_hint(struct mlx4_en_priv *priv, int ring_idx)
+{
+	struct mlx4_en_rx_ring *ring = priv->rx_ring[ring_idx];
+	int numa_node = priv->mdev->dev->numa_node;
+
+	if (numa_node == -1)
+		return;
+
+	if (!zalloc_cpumask_var(&ring->affinity_mask, GFP_KERNEL)) {
+		en_err(priv, "Failed to allocate core mask\n");
+		return;
+	}
+
+	if (cpumask_set_cpu_local_first(ring_idx, numa_node,
+					ring->affinity_mask)) {
+		en_err(priv, "Failed setting affinity hint\n");
+		free_cpumask_var(ring->affinity_mask);
+		ring->affinity_mask = NULL;
+	}
+}
+
+static void mlx4_en_free_affinity_hint(struct mlx4_en_priv *priv, int ring_idx)
+{
+	free_cpumask_var(priv->rx_ring[ring_idx]->affinity_mask);
+	priv->rx_ring[ring_idx]->affinity_mask = NULL;
+}
 
 int mlx4_en_start_port(struct net_device *dev)
 {
@@ -1572,6 +1598,8 @@ int mlx4_en_start_port(struct net_device *dev)
 
 		mlx4_en_cq_init_lock(cq);
 
+		mlx4_en_init_affinity_hint(priv, i);
+
 		err = mlx4_en_activate_cq(priv, cq, i);
 		if (err) {
 			en_err(priv, "Failed activating Rx CQ\n");
@@ -1852,6 +1880,8 @@ void mlx4_en_stop_port(struct net_device *dev, int detach)
 			msleep(1);
 		mlx4_en_deactivate_rx_ring(priv, priv->rx_ring[i]);
 		mlx4_en_deactivate_cq(priv, cq);
+
+		mlx4_en_free_affinity_hint(priv, i);
 	}
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index 947364d..02cf97d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -1376,7 +1376,7 @@ int mlx4_test_interrupts(struct mlx4_dev *dev)
 EXPORT_SYMBOL(mlx4_test_interrupts);
 
 int mlx4_assign_eq(struct mlx4_dev *dev, char *name, struct cpu_rmap *rmap,
-		   int *vector)
+		   int *vector, cpumask_var_t cpu_hint_mask)
 {
 
 	struct mlx4_priv *priv = mlx4_priv(dev);
@@ -1411,6 +1411,15 @@ int mlx4_assign_eq(struct mlx4_dev *dev, char *name, struct cpu_rmap *rmap,
 			}
 			mlx4_assign_irq_notifier(priv, dev,
 						 priv->eq_table.eq[vec].irq);
+			if (cpu_hint_mask) {
+				err = irq_set_affinity_hint(
+						priv->eq_table.eq[vec].irq,
+						cpu_hint_mask);
+				if (err) {
+					mlx4_warn(dev, "Failed setting affinity hint\n");
+					/*we dont want to break here*/
+				}
+			}
 
 			eq_set_ci(&priv->eq_table.eq[vec], 1);
 		}
@@ -1441,6 +1450,8 @@ void mlx4_release_eq(struct mlx4_dev *dev, int vec)
 			irq_set_affinity_notifier(
 				priv->eq_table.eq[vec].irq,
 				NULL);
+			irq_set_affinity_hint(priv->eq_table.eq[vec].irq,
+					      NULL);
 			free_irq(priv->eq_table.eq[vec].irq,
 				 &priv->eq_table.eq[vec]);
 			priv->msix_ctl.pool_bm &= ~(1ULL << i);
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index 88d5cf6..61d7c36 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -313,6 +313,7 @@ struct mlx4_en_rx_ring {
 	unsigned long csum_ok;
 	unsigned long csum_none;
 	int hwtstamp_rx_filter;
+	cpumask_var_t affinity_mask;
 };
 
 struct mlx4_en_cq {
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 74f5aa8..8b194aa 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -1161,7 +1161,7 @@ int mlx4_fmr_free(struct mlx4_dev *dev, struct mlx4_fmr *fmr);
 int mlx4_SYNC_TPT(struct mlx4_dev *dev);
 int mlx4_test_interrupts(struct mlx4_dev *dev);
 int mlx4_assign_eq(struct mlx4_dev *dev, char *name, struct cpu_rmap *rmap,
-		   int *vector);
+		   int *vector, cpumask_t *cpu_hint_mask);
 void mlx4_release_eq(struct mlx4_dev *dev, int vec);
 
 int mlx4_get_phys_port_id(struct mlx4_dev *dev);
-- 
1.8.3.4

