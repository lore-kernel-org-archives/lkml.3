Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab3HLQeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:34:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:45044 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658Ab3HLQeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:34:16 -0400
Date: Mon, 12 Aug 2013 18:34:13 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.10.6-rt3
Message-ID: <20130812163413.GI23040@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.10.6-rt3 patch set.

Changes since v3.10.6-rt2
- the queue can be imported with git quiltimport
- powerpc compiles again. Thanks to Paul Gortmaker for the patch.
- added three patches from v3.8 which fall the wagon on their way to
  3.10. One of them enables RT-FULL on ARM :)
- removed all cpsw patches from the queue. They made it upstream. My
  nfsboot setup seems not to work, lets look at this later.
- make arm/spear compile. Thanks to Felipe Balbi for the patch.
- Add a patch from Corey Minyard to no longer use deprecated
  CONFIG_NO_HZ.
- add the one patch which I added to the last 3.8-rt to get get list_bl
  work again on !SMP && !DEBUG_SPINLOCK
- Spell "preemptible" properly in "Preemptible Kernel (Basic RT)" menu
  item. Thanks to Uwe Kleine-König for the patch.
- a patch from John Kacur to avoid a warning in the hpsa.
- a patch for the ppc5200 where the compiler thinks a variable isn't
  initialized and stops compililing due to -Werror

Known issues:

      - SLAB support not working

      - The cpsw network driver shows some issues.

      - ARM & PPC don't fall apart once booted. More testing doesn't
        hurt.

      - bcache with CONFIG_DEBUG_LOCK_ALLOC enabled does not compile.

The delta patch against v3.10.6-rt2 is appended below and can be found
here:
  https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/incr/patch-3.10.6-rt2-rt3.patch.xz

The RT patch against 3.10.6 can be found here:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patch-3.10.6-rt3.patch.xz

The split quilt queue is available at:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patches-3.10.6-rt3.tar.xz

Sebastian

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2ef0b69..b34ff02 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -19,6 +19,7 @@ config ARM
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HARDIRQS_SW_RESEND
+	select IRQ_FORCED_THREADING
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_SECCOMP_FILTER
diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index 1f2740e..b32b043 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -118,7 +118,8 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 			continue;
 		}
 
-		err = request_irq(irq, handler, IRQF_NOBALANCING, "arm-pmu",
+		err = request_irq(irq, handler,
+				  IRQF_NOBALANCING | IRQF_NO_THREAD, "arm-pmu",
 				  cpu_pmu);
 		if (err) {
 			pr_err("unable to request IRQ%d for ARM PMU counters\n",
diff --git a/arch/arm/mach-spear/platsmp.c b/arch/arm/mach-spear/platsmp.c
index 382eef6..ec5437d 100644
--- a/arch/arm/mach-spear/platsmp.c
+++ b/arch/arm/mach-spear/platsmp.c
@@ -20,7 +20,7 @@
 #include <mach/spear.h>
 #include "generic.h"
 
-static DEFINE_SPINLOCK(boot_lock);
+static DEFINE_RAW_SPINLOCK(boot_lock);
 
 static void __iomem *scu_base = IOMEM(VA_SCU_BASE);
 
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index 2469444..f50711f 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -92,8 +92,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
-#define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
-					   TIF_NEED_RESCHED */
+#define TIF_NEED_RESCHED_LAZY	3	/* lazy rescheduling necessary */
 #define TIF_32BIT		4	/* 32 bit binary */
 #define TIF_PERFMON_WORK	5	/* work for pfm_handle_work() */
 #define TIF_PERFMON_CTXSW	6	/* perfmon needs ctxsw calls */
@@ -109,7 +108,8 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_EMULATE_STACK_STORE	16	/* Is an instruction emulation
 						for stack store? */
 #define TIF_MEMDIE		17	/* is terminating due to OOM killer */
-#define TIF_NEED_RESCHED_LAZY	18	/* lazy rescheduling necessary */
+#define TIF_POLLING_NRFLAG	18	/* true if poll_idle() is polling
+					   TIF_NEED_RESCHED */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pic.c b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
index b89ef65..b69221b 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pic.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
@@ -373,8 +373,9 @@ static int mpc52xx_irqhost_map(struct irq_domain *h, unsigned int virq,
 	case MPC52xx_IRQ_L1_PERP: irqchip = &mpc52xx_periph_irqchip; break;
 	case MPC52xx_IRQ_L1_SDMA: irqchip = &mpc52xx_sdma_irqchip; break;
 	case MPC52xx_IRQ_L1_CRIT:
+	default:
 		pr_warn("%s: Critical IRQ #%d is unsupported! Nopping it.\n",
-			__func__, l2irq);
+			__func__, l1irq);
 		irq_set_chip(virq, &no_irq_chip);
 		return 0;
 	}
diff --git a/arch/powerpc/platforms/8xx/m8xx_setup.c b/arch/powerpc/platforms/8xx/m8xx_setup.c
index 1e12108..806cbbd 100644
--- a/arch/powerpc/platforms/8xx/m8xx_setup.c
+++ b/arch/powerpc/platforms/8xx/m8xx_setup.c
@@ -43,6 +43,7 @@ static irqreturn_t timebase_interrupt(int irq, void *dev)
 
 static struct irqaction tbint_irqaction = {
 	.handler = timebase_interrupt,
+	.flags = IRQF_NO_THREAD,
 	.name = "tbint",
 };
 
diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
index d4fa03f..5e6ff38 100644
--- a/arch/powerpc/sysdev/cpm1.c
+++ b/arch/powerpc/sysdev/cpm1.c
@@ -120,6 +120,7 @@ static irqreturn_t cpm_error_interrupt(int irq, void *dev)
 
 static struct irqaction cpm_error_irqaction = {
 	.handler = cpm_error_interrupt,
+	.flags = IRQF_NO_THREAD,
 	.name = "error",
 };
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 469eb6c..aaf4b9b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1408,7 +1408,7 @@ static inline int mce_notify_work_init(void) { return 0; }
  */
 int mce_notify_irq(void)
 {
- 	if (test_and_clear_bit(0, &mce_need_notify)) {
+	if (test_and_clear_bit(0, &mce_need_notify)) {
 		mce_notify_work();
 		return 1;
 	}
diff --git a/drivers/net/ethernet/ti/cpmac.c b/drivers/net/ethernet/ti/cpmac.c
index 70d1920..31bbbca 100644
--- a/drivers/net/ethernet/ti/cpmac.c
+++ b/drivers/net/ethernet/ti/cpmac.c
@@ -1172,8 +1172,8 @@ static int cpmac_probe(struct platform_device *pdev)
 	snprintf(priv->phy_name, MII_BUS_ID_SIZE, PHY_ID_FMT,
 						mdio_bus_id, phy_id);
 
-	priv->phy = phy_connect(dev, priv->phy_name, cpmac_adjust_link, 0,
-						PHY_INTERFACE_MODE_MII);
+	priv->phy = phy_connect(dev, priv->phy_name, cpmac_adjust_link,
+				PHY_INTERFACE_MODE_MII);
 
 	if (IS_ERR(priv->phy)) {
 		if (netif_msg_drv(priv))
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index c0dea7c..d1a769f 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -490,7 +490,7 @@ void cpsw_rx_handler(void *token, int len, int status)
 		skb_put(skb, len);
 		cpts_rx_timestamp(priv->cpts, skb);
 		skb->protocol = eth_type_trans(skb, ndev);
-		netif_rx(skb);
+		netif_receive_skb(skb);
 		priv->stats.rx_bytes += len;
 		priv->stats.rx_packets++;
 	} else {
@@ -507,24 +507,19 @@ void cpsw_rx_handler(void *token, int len, int status)
 static irqreturn_t cpsw_interrupt(int irq, void *dev_id)
 {
 	struct cpsw_priv *priv = dev_id;
-	unsigned long flags;
 	u32 rx, tx, rx_thresh;
 
-	spin_lock_irqsave(&priv->lock, flags);
 	rx_thresh = __raw_readl(&priv->wr_regs->rx_thresh_stat);
 	rx = __raw_readl(&priv->wr_regs->rx_stat);
 	tx = __raw_readl(&priv->wr_regs->tx_stat);
-	if (!rx_thresh && !rx && !tx) {
-		spin_unlock_irqrestore(&priv->lock, flags);
+	if (!rx_thresh && !rx && !tx)
 		return IRQ_NONE;
-	}
 
 	cpsw_intr_disable(priv);
 	if (priv->irq_enabled == true) {
 		cpsw_disable_irq(priv);
 		priv->irq_enabled = false;
 	}
-	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (netif_running(priv->ndev)) {
 		napi_schedule(&priv->napi);
@@ -546,9 +541,7 @@ static int cpsw_poll(struct napi_struct *napi, int budget)
 {
 	struct cpsw_priv	*priv = napi_to_priv(napi);
 	int			num_tx, num_rx;
-	unsigned long		flags;
 
-	spin_lock_irqsave(&priv->lock, flags);
 	num_tx = cpdma_chan_process(priv->txch, 128);
 	if (num_tx)
 		cpdma_ctlr_eoi(priv->dma, CPDMA_EOI_TX);
@@ -824,7 +817,7 @@ static void cpsw_slave_open(struct cpsw_slave *slave, struct cpsw_priv *priv)
 				   1 << slave_port, 0, 0, ALE_MCAST_FWD_2);
 
 	slave->phy = phy_connect(priv->ndev, slave->data->phy_id,
-				 &cpsw_adjust_link, 0, slave->data->phy_if);
+				 &cpsw_adjust_link, slave->data->phy_if);
 	if (IS_ERR(slave->phy)) {
 		dev_err(priv->dev, "phy %s not found on slave %d\n",
 			slave->data->phy_id, slave->slave_num);
@@ -1293,7 +1286,7 @@ static inline int cpsw_add_vlan_ale_entry(struct cpsw_priv *priv,
 }
 
 static int cpsw_ndo_vlan_rx_add_vid(struct net_device *ndev,
-		unsigned short vid)
+				    __be16 proto, u16 vid)
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
 
@@ -1305,7 +1298,7 @@ static int cpsw_ndo_vlan_rx_add_vid(struct net_device *ndev,
 }
 
 static int cpsw_ndo_vlan_rx_kill_vid(struct net_device *ndev,
-		unsigned short vid)
+				     __be16 proto, u16 vid)
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	int ret;
@@ -1466,12 +1459,8 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 
 	if (of_property_read_u32(node, "active_slave", &prop)) {
 		pr_err("Missing active_slave property in the DT.\n");
-		if (of_property_read_u32(node, "cpts_active_slave", &prop)) {
-			ret = -EINVAL;
-			goto error_ret;
-		} else {
-			pr_err("Using old cpts_active_slave as fallback.\n");
-		}
+		ret = -EINVAL;
+		goto error_ret;
 	}
 	data->active_slave = prop;
 
@@ -1644,7 +1633,7 @@ static int cpsw_probe_dual_emac(struct platform_device *pdev,
 		priv_sl2->irqs_table[i] = priv->irqs_table[i];
 		priv_sl2->num_irqs = priv->num_irqs;
 	}
-	ndev->features |= NETIF_F_HW_VLAN_FILTER;
+	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	SET_ETHTOOL_OPS(ndev, &cpsw_ethtool_ops);
@@ -1883,7 +1872,7 @@ static int cpsw_probe(struct platform_device *pdev)
 		k++;
 	}
 
-	ndev->features |= NETIF_F_HW_VLAN_FILTER;
+	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	SET_ETHTOOL_OPS(ndev, &cpsw_ethtool_ops);
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 5aa9e4d..860e15d 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1600,7 +1600,7 @@ static int emac_dev_open(struct net_device *ndev)
 
 	if (priv->phy_id && *priv->phy_id) {
 		priv->phydev = phy_connect(ndev, priv->phy_id,
-					   &emac_adjust_link, 0,
+					   &emac_adjust_link,
 					   PHY_INTERFACE_MODE_MII);
 
 		if (IS_ERR(priv->phydev)) {
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7f4f790..4e19267 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -583,7 +583,7 @@ static void set_performant_mode(struct ctlr_info *h, struct CommandList *c)
 		c->busaddr |= 1 | (h->blockFetchTable[c->Header.SGList] << 1);
 		if (likely(h->msix_vector))
 			c->Header.ReplyQueue =
-				smp_processor_id() % h->nreply_queues;
+				raw_smp_processor_id() % h->nreply_queues;
 	}
 }
 
diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index 0ab40b6..d8876a0 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -131,8 +131,10 @@ static inline void hlist_bl_lock(struct hlist_bl_head *b)
 	bit_spin_lock(0, (unsigned long *)b);
 #else
 	raw_spin_lock(&b->lock);
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 	__set_bit(0, (unsigned long *)b);
 #endif
+#endif
 }
 
 static inline void hlist_bl_unlock(struct hlist_bl_head *b)
@@ -140,7 +142,9 @@ static inline void hlist_bl_unlock(struct hlist_bl_head *b)
 #ifndef CONFIG_PREEMPT_RT_BASE
 	__bit_spin_unlock(0, (unsigned long *)b);
 #else
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 	__clear_bit(0, (unsigned long *)b);
+#endif
 	raw_spin_unlock(&b->lock);
 #endif
 }
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 38cecfe..11dbe26 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -70,7 +70,7 @@ config PREEMPT_RTB
 	select PREEMPT_RT_BASE
 	help
 	  This option is basically the same as (Low-Latency Desktop) but
-	  enables changes which are preliminary for the full preemptiple
+	  enables changes which are preliminary for the full preemptible
 	  RT kernel.
 
 config PREEMPT_RT_FULL
diff --git a/kernel/softirq.c b/kernel/softirq.c
index db2fe2b..3298e55 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -64,7 +64,7 @@ char *softirq_to_name[NR_SOFTIRQS] = {
 	"TASKLET", "SCHED", "HRTIMER", "RCU"
 };
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 # ifdef CONFIG_PREEMPT_RT_FULL
 
 struct softirq_runner {
@@ -151,7 +151,7 @@ void softirq_check_pending_idle(void)
 }
 # endif
 
-#else /* !NO_HZ */
+#else /* !CONFIG_NO_HZ_COMMON */
 static inline void softirq_set_runner(unsigned int sirq) { }
 static inline void softirq_clr_runner(unsigned int sirq) { }
 #endif
diff --git a/localversion-rt b/localversion-rt
index c3054d0..1445cd6 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt2
+-rt3
