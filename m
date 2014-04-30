Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945968AbaD3Qe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:34:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:23312 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1945934AbaD3Qez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:34:55 -0400
Date: Wed, 30 Apr 2014 12:34:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.2.57-rt84
Message-ID: <20140430123453.703be0eb@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.2.57-rt84 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.2-rt
  Head SHA1: 8cf02110a4ba9f6347d86ebbca28ffe19449afac


Or to build 3.2.57-rt84 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.57.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.57-rt84.patch.xz



You can also build from 3.2.57-rt83 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.57-rt83-rt84.patch.xz



Enjoy,

-- Steve


Changes from v3.2.57-rt83:

---

Sebastian Andrzej Siewior (2):
      net: gianfar: do not disable interrupts
      rcu: make RCU_BOOST default on RT

Steven Rostedt (Red Hat) (1):
      Linux 3.2.57-rt84

----
 drivers/net/ethernet/freescale/gianfar.c         | 16 ++++++++--------
 drivers/net/ethernet/freescale/gianfar_ethtool.c |  8 ++++----
 drivers/net/ethernet/freescale/gianfar_sysfs.c   | 24 ++++++++++++------------
 init/Kconfig                                     |  2 +-
 localversion-rt                                  |  2 +-
 5 files changed, 26 insertions(+), 26 deletions(-)
---------------------------
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 7048ed8..5c35b28 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -1285,7 +1285,7 @@ static int gfar_suspend(struct device *dev)
 
 	if (netif_running(ndev)) {
 
-		local_irq_save(flags);
+		local_irq_save_nort(flags);
 		lock_tx_qs(priv);
 		lock_rx_qs(priv);
 
@@ -1303,7 +1303,7 @@ static int gfar_suspend(struct device *dev)
 
 		unlock_rx_qs(priv);
 		unlock_tx_qs(priv);
-		local_irq_restore(flags);
+		local_irq_restore_nort(flags);
 
 		disable_napi(priv);
 
@@ -1344,7 +1344,7 @@ static int gfar_resume(struct device *dev)
 	/* Disable Magic Packet mode, in case something
 	 * else woke us up.
 	 */
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	lock_tx_qs(priv);
 	lock_rx_qs(priv);
 
@@ -1356,7 +1356,7 @@ static int gfar_resume(struct device *dev)
 
 	unlock_rx_qs(priv);
 	unlock_tx_qs(priv);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 
 	netif_device_attach(ndev);
 
@@ -2323,7 +2323,7 @@ void gfar_vlan_mode(struct net_device *dev, u32 features)
 	u32 tempval;
 
 	regs = priv->gfargrp[0].regs;
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	lock_rx_qs(priv);
 
 	if (features & NETIF_F_HW_VLAN_TX) {
@@ -2355,7 +2355,7 @@ void gfar_vlan_mode(struct net_device *dev, u32 features)
 	gfar_change_mtu(dev, dev->mtu);
 
 	unlock_rx_qs(priv);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 }
 
 static int gfar_change_mtu(struct net_device *dev, int new_mtu)
@@ -3225,14 +3225,14 @@ static irqreturn_t gfar_error(int irq, void *grp_id)
 			dev->stats.tx_dropped++;
 			priv->extra_stats.tx_underrun++;
 
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
index 212736b..1fe331f 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -486,7 +486,7 @@ static int gfar_sringparam(struct net_device *dev, struct ethtool_ringparam *rva
 
 		/* Halt TX and RX, and process the frames which
 		 * have already been received */
-		local_irq_save(flags);
+		local_irq_save_nort(flags);
 		lock_tx_qs(priv);
 		lock_rx_qs(priv);
 
@@ -494,7 +494,7 @@ static int gfar_sringparam(struct net_device *dev, struct ethtool_ringparam *rva
 
 		unlock_rx_qs(priv);
 		unlock_tx_qs(priv);
-		local_irq_restore(flags);
+		local_irq_restore_nort(flags);
 
 		for (i = 0; i < priv->num_rx_queues; i++)
 			gfar_clean_rx_ring(priv->rx_queue[i],
@@ -535,7 +535,7 @@ int gfar_set_features(struct net_device *dev, u32 features)
 	if (dev->flags & IFF_UP) {
 		/* Halt TX and RX, and process the frames which
 		 * have already been received */
-		local_irq_save(flags);
+		local_irq_save_nort(flags);
 		lock_tx_qs(priv);
 		lock_rx_qs(priv);
 
@@ -543,7 +543,7 @@ int gfar_set_features(struct net_device *dev, u32 features)
 
 		unlock_tx_qs(priv);
 		unlock_rx_qs(priv);
-		local_irq_restore(flags);
+		local_irq_restore_nort(flags);
 
 		for (i = 0; i < priv->num_rx_queues; i++)
 			gfar_clean_rx_ring(priv->rx_queue[i],
diff --git a/drivers/net/ethernet/freescale/gianfar_sysfs.c b/drivers/net/ethernet/freescale/gianfar_sysfs.c
index 64f4094..9f6fb3a 100644
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
index aa6545f..c16e1f3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -494,7 +494,7 @@ config TREE_RCU_TRACE
 config RCU_BOOST
 	bool "Enable RCU priority boosting"
 	depends on RT_MUTEXES && PREEMPT_RCU
-	default n
+	default y if PREEMPT_RT_FULL
 	help
 	  This option boosts the priority of preempted RCU readers that
 	  block the current preemptible RCU grace period for too long.
diff --git a/localversion-rt b/localversion-rt
index 6a72c0f..fc6ea32 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt83
+-rt84
