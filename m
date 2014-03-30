Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaC3SqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 14:46:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:56393 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaC3SqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 14:46:18 -0400
Date: Sun, 30 Mar 2014 20:46:15 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.12.15-rt25
Message-ID: <20140330184615.GA5940@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.12.15-rt25 patch set.

Changes since v3.12.15-rt24
- Two patches for the gianfar network driver. One fixes a deadlock /
  lockup which is only available on -RT and probably since v3.10. The
  other is the removal of local_irq_save() statemens which should not be
  used on -RT.

- A small optimization from Nicholas Mc Guire where cpumask_weight() can
  be avoided because the outcome is known.

Known issues:

      - bcache is disabled.

The delta patch against v3.12.15-rt24 is appended below and can be found
here:
   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.15-rt24-rt25.patch.xz

The RT patch against 3.12.15 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.15-rt25.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patches-3.12.15-rt25.tar.xz

Sebastian

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index de10ff3..091945c 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -134,7 +134,6 @@ static int gfar_poll_sq(struct napi_struct *napi, int budget);
 static void gfar_netpoll(struct net_device *dev);
 #endif
 int gfar_clean_rx_ring(struct gfar_priv_rx_q *rx_queue, int rx_work_limit);
-static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue);
 static void gfar_process_frame(struct net_device *dev, struct sk_buff *skb,
 			       int amount_pull, struct napi_struct *napi);
 void gfar_halt(struct net_device *dev);
@@ -1301,7 +1300,7 @@ static int gfar_suspend(struct device *dev)
 
 	if (netif_running(ndev)) {
 
-		local_irq_save(flags);
+		local_irq_save_nort(flags);
 		lock_tx_qs(priv);
 		lock_rx_qs(priv);
 
@@ -1319,7 +1318,7 @@ static int gfar_suspend(struct device *dev)
 
 		unlock_rx_qs(priv);
 		unlock_tx_qs(priv);
-		local_irq_restore(flags);
+		local_irq_restore_nort(flags);
 
 		disable_napi(priv);
 
@@ -1361,7 +1360,7 @@ static int gfar_resume(struct device *dev)
 	/* Disable Magic Packet mode, in case something
 	 * else woke us up.
 	 */
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	lock_tx_qs(priv);
 	lock_rx_qs(priv);
 
@@ -1373,7 +1372,7 @@ static int gfar_resume(struct device *dev)
 
 	unlock_rx_qs(priv);
 	unlock_tx_qs(priv);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 
 	netif_device_attach(ndev);
 
@@ -2387,7 +2386,7 @@ void gfar_vlan_mode(struct net_device *dev, netdev_features_t features)
 	u32 tempval;
 
 	regs = priv->gfargrp[0].regs;
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	lock_rx_qs(priv);
 
 	if (features & NETIF_F_HW_VLAN_CTAG_TX) {
@@ -2420,7 +2419,7 @@ void gfar_vlan_mode(struct net_device *dev, netdev_features_t features)
 	gfar_change_mtu(dev, dev->mtu);
 
 	unlock_rx_qs(priv);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 }
 
 static int gfar_change_mtu(struct net_device *dev, int new_mtu)
@@ -2516,7 +2515,7 @@ static void gfar_align_skb(struct sk_buff *skb)
 }
 
 /* Interrupt Handler for Transmit complete */
-static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
+static int gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 {
 	struct net_device *dev = tx_queue->dev;
 	struct netdev_queue *txq;
@@ -2939,10 +2938,14 @@ static int gfar_poll(struct napi_struct *napi, int budget)
 			tx_queue = priv->tx_queue[i];
 			/* run Tx cleanup to completion */
 			if (tx_queue->tx_skbuff[tx_queue->skb_dirtytx]) {
-				gfar_clean_tx_ring(tx_queue);
-				has_tx_work = 1;
+				int ret;
+
+				ret = gfar_clean_tx_ring(tx_queue);
+				if (ret)
+					has_tx_work++;
 			}
 		}
+		work_done += has_tx_work;
 
 		for_each_set_bit(i, &gfargrp->rx_bit_map, priv->num_rx_queues) {
 			/* skip queue if not active */
@@ -3381,14 +3384,14 @@ static irqreturn_t gfar_error(int irq, void *grp_id)
 			dev->stats.tx_dropped++;
 			atomic64_inc(&priv->extra_stats.tx_underrun);
 
-			local_irq_save(flags);
+			local_irq_save_nort(flags);
 			lock_tx_qs(priv);
 
 			/* Reactivate the Tx Queues */
 			gfar_write(&regs->tstat, gfargrp->tstat);
 
 			unlock_tx_qs(priv);
-			local_irq_restore(flags);
+			local_irq_restore_nort(flags);
 		}
 		netif_dbg(priv, tx_err, dev, "Transmit Error\n");
 	}
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index d3d7ede..95a1f62 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -501,7 +501,7 @@ static int gfar_sringparam(struct net_device *dev,
 		/* Halt TX and RX, and process the frames which
 		 * have already been received
 		 */
-		local_irq_save(flags);
+		local_irq_save_nort(flags);
 		lock_tx_qs(priv);
 		lock_rx_qs(priv);
 
@@ -509,7 +509,7 @@ static int gfar_sringparam(struct net_device *dev,
 
 		unlock_rx_qs(priv);
 		unlock_tx_qs(priv);
-		local_irq_restore(flags);
+		local_irq_restore_nort(flags);
 
 		for (i = 0; i < priv->num_rx_queues; i++)
 			gfar_clean_rx_ring(priv->rx_queue[i],
@@ -624,7 +624,7 @@ int gfar_set_features(struct net_device *dev, netdev_features_t features)
 		/* Halt TX and RX, and process the frames which
 		 * have already been received
 		 */
-		local_irq_save(flags);
+		local_irq_save_nort(flags);
 		lock_tx_qs(priv);
 		lock_rx_qs(priv);
 
@@ -632,7 +632,7 @@ int gfar_set_features(struct net_device *dev, netdev_features_t features)
 
 		unlock_tx_qs(priv);
 		unlock_rx_qs(priv);
-		local_irq_restore(flags);
+		local_irq_restore_nort(flags);
 
 		for (i = 0; i < priv->num_rx_queues; i++)
 			gfar_clean_rx_ring(priv->rx_queue[i],
diff --git a/drivers/net/ethernet/freescale/gianfar_sysfs.c b/drivers/net/ethernet/freescale/gianfar_sysfs.c
index acb55af..f0160e67 100644
--- a/drivers/net/ethernet/freescale/gianfar_sysfs.c
+++ b/drivers/net/ethernet/freescale/gianfar_sysfs.c
@@ -68,7 +68,7 @@ static ssize_t gfar_set_bd_stash(struct device *dev,
 		return count;
 
 
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	lock_rx_qs(priv);
 
 	/* Set the new stashing value */
@@ -84,7 +84,7 @@ static ssize_t gfar_set_bd_stash(struct device *dev,
 	gfar_write(&regs->attr, temp);
 
 	unlock_rx_qs(priv);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 
 	return count;
 }
@@ -112,7 +112,7 @@ static ssize_t gfar_set_rx_stash_size(struct device *dev,
 	if (!(priv->device_flags & FSL_GIANFAR_DEV_HAS_BUF_STASHING))
 		return count;
 
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	lock_rx_qs(priv);
 
 	if (length > priv->rx_buffer_size)
@@ -140,7 +140,7 @@ static ssize_t gfar_set_rx_stash_size(struct device *dev,
 
 out:
 	unlock_rx_qs(priv);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 
 	return count;
 }
@@ -171,7 +171,7 @@ static ssize_t gfar_set_rx_stash_index(struct device *dev,
 	if (!(priv->device_flags & FSL_GIANFAR_DEV_HAS_BUF_STASHING))
 		return count;
 
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	lock_rx_qs(priv);
 
 	if (index > priv->rx_stash_size)
@@ -189,7 +189,7 @@ static ssize_t gfar_set_rx_stash_index(struct device *dev,
 
 out:
 	unlock_rx_qs(priv);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 
 	return count;
 }
@@ -219,7 +219,7 @@ static ssize_t gfar_set_fifo_threshold(struct device *dev,
 	if (length > GFAR_MAX_FIFO_THRESHOLD)
 		return count;
 
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	lock_tx_qs(priv);
 
 	priv->fifo_threshold = length;
@@ -230,7 +230,7 @@ static ssize_t gfar_set_fifo_threshold(struct device *dev,
 	gfar_write(&regs->fifo_tx_thr, temp);
 
 	unlock_tx_qs(priv);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 
 	return count;
 }
@@ -259,7 +259,7 @@ static ssize_t gfar_set_fifo_starve(struct device *dev,
 	if (num > GFAR_MAX_FIFO_STARVE)
 		return count;
 
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	lock_tx_qs(priv);
 
 	priv->fifo_starve = num;
@@ -270,7 +270,7 @@ static ssize_t gfar_set_fifo_starve(struct device *dev,
 	gfar_write(&regs->fifo_tx_starve, temp);
 
 	unlock_tx_qs(priv);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 
 	return count;
 }
@@ -300,7 +300,7 @@ static ssize_t gfar_set_fifo_starve_off(struct device *dev,
 	if (num > GFAR_MAX_FIFO_STARVE_OFF)
 		return count;
 
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	lock_tx_qs(priv);
 
 	priv->fifo_starve_off = num;
@@ -311,7 +311,7 @@ static ssize_t gfar_set_fifo_starve_off(struct device *dev,
 	gfar_write(&regs->fifo_tx_starve_shutoff, temp);
 
 	unlock_tx_qs(priv);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 
 	return count;
 }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2aa8abf..8749d20 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2405,7 +2405,8 @@ static inline void update_migrate_disable(struct task_struct *p)
 
 	if (p->sched_class->set_cpus_allowed)
 		p->sched_class->set_cpus_allowed(p, mask);
-	p->nr_cpus_allowed = cpumask_weight(mask);
+	/* mask==cpumask_of(task_cpu(p)) which has a cpumask_weight==1 */
+	p->nr_cpus_allowed = 1;
 
 	/* Let migrate_enable know to fix things back up */
 	p->migrate_disable |= MIGRATE_DISABLE_SET_AFFIN;
diff --git a/localversion-rt b/localversion-rt
index b2111a2..c5b71f9 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt24
+-rt25
