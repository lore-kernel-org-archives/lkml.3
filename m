Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945994AbaD3Qdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:33:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:22598 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1945979AbaD3Qdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:33:41 -0400
Date: Wed, 30 Apr 2014 12:33:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.10.37-rt38
Message-ID: <20140430123339.6519f265@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.10.37-rt38 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.10-rt
  Head SHA1: e76c85361a356b46260fe121cd8ddc57512bdfda


Or to build 3.10.37-rt38 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.10.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.10.37.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patch-3.10.37-rt38.patch.xz



You can also build from 3.10.37-rt37 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.10/incr/patch-3.10.37-rt37-rt38.patch.xz



Enjoy,

-- Steve


Changes from v3.10.37-rt37:

---

Sebastian Andrzej Siewior (3):
      net: gianfar: do not disable interrupts
      net: gianfar: do not try to cleanup TX packets if they are not done
      rcu: make RCU_BOOST default on RT

Steven Rostedt (Red Hat) (1):
      Linux 3.10.37-rt38

----
 drivers/net/ethernet/freescale/gianfar.c         | 28 ++++++++++++++----------
 drivers/net/ethernet/freescale/gianfar_ethtool.c |  8 +++----
 drivers/net/ethernet/freescale/gianfar_sysfs.c   | 24 ++++++++++----------
 init/Kconfig                                     |  2 +-
 localversion-rt                                  |  2 +-
 5 files changed, 34 insertions(+), 30 deletions(-)
---------------------------
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 0343a14..b87a8c9 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -132,7 +132,6 @@ static int gfar_poll(struct napi_struct *napi, int budget);
 static void gfar_netpoll(struct net_device *dev);
 #endif
 int gfar_clean_rx_ring(struct gfar_priv_rx_q *rx_queue, int rx_work_limit);
-static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue);
 static void gfar_process_frame(struct net_device *dev, struct sk_buff *skb,
 			       int amount_pull, struct napi_struct *napi);
 void gfar_halt(struct net_device *dev);
@@ -1274,7 +1273,7 @@ static int gfar_suspend(struct device *dev)
 
 	if (netif_running(ndev)) {
 
-		local_irq_save(flags);
+		local_irq_save_nort(flags);
 		lock_tx_qs(priv);
 		lock_rx_qs(priv);
 
@@ -1292,7 +1291,7 @@ static int gfar_suspend(struct device *dev)
 
 		unlock_rx_qs(priv);
 		unlock_tx_qs(priv);
-		local_irq_restore(flags);
+		local_irq_restore_nort(flags);
 
 		disable_napi(priv);
 
@@ -1334,7 +1333,7 @@ static int gfar_resume(struct device *dev)
 	/* Disable Magic Packet mode, in case something
 	 * else woke us up.
 	 */
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	lock_tx_qs(priv);
 	lock_rx_qs(priv);
 
@@ -1346,7 +1345,7 @@ static int gfar_resume(struct device *dev)
 
 	unlock_rx_qs(priv);
 	unlock_tx_qs(priv);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 
 	netif_device_attach(ndev);
 
@@ -2346,7 +2345,7 @@ void gfar_vlan_mode(struct net_device *dev, netdev_features_t features)
 	u32 tempval;
 
 	regs = priv->gfargrp[0].regs;
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	lock_rx_qs(priv);
 
 	if (features & NETIF_F_HW_VLAN_CTAG_TX) {
@@ -2379,7 +2378,7 @@ void gfar_vlan_mode(struct net_device *dev, netdev_features_t features)
 	gfar_change_mtu(dev, dev->mtu);
 
 	unlock_rx_qs(priv);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 }
 
 static int gfar_change_mtu(struct net_device *dev, int new_mtu)
@@ -2475,7 +2474,7 @@ static void gfar_align_skb(struct sk_buff *skb)
 }
 
 /* Interrupt Handler for Transmit complete */
-static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
+static int gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 {
 	struct net_device *dev = tx_queue->dev;
 	struct netdev_queue *txq;
@@ -2575,6 +2574,7 @@ static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 	tx_queue->dirty_tx = bdp;
 
 	netdev_tx_completed_queue(txq, howmany, bytes_sent);
+	return howmany;
 }
 
 static void gfar_schedule_cleanup(struct gfar_priv_grp *gfargrp)
@@ -2856,10 +2856,14 @@ static int gfar_poll(struct napi_struct *napi, int budget)
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
@@ -3258,14 +3262,14 @@ static irqreturn_t gfar_error(int irq, void *grp_id)
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
index 21cd881..c965c0a 100644
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
@@ -552,7 +552,7 @@ int gfar_set_features(struct net_device *dev, netdev_features_t features)
 		/* Halt TX and RX, and process the frames which
 		 * have already been received
 		 */
-		local_irq_save(flags);
+		local_irq_save_nort(flags);
 		lock_tx_qs(priv);
 		lock_rx_qs(priv);
 
@@ -560,7 +560,7 @@ int gfar_set_features(struct net_device *dev, netdev_features_t features)
 
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
diff --git a/init/Kconfig b/init/Kconfig
index 6c3a4fd..bd3612d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -604,7 +604,7 @@ config TREE_RCU_TRACE
 config RCU_BOOST
 	bool "Enable RCU priority boosting"
 	depends on RT_MUTEXES && PREEMPT_RCU
-	default n
+	default y if PREEMPT_RT_FULL
 	help
 	  This option boosts the priority of preempted RCU readers that
 	  block the current preemptible RCU grace period for too long.
diff --git a/localversion-rt b/localversion-rt
index a3b2408..49bae8d 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt37
+-rt38
