Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaLGRVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 12:21:31 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65180 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaLGRV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 12:21:28 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Paul Walmsley <paul@pwsan.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: arm: mach-omap2: omap_hwmod.c:  Remove some unused functions
Date: Sun,  7 Dec 2014 18:24:07 +0100
Message-Id: <1417973047-12972-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
omap_hwmod_pad_route_irq() omap_hwmod_no_setup_reset()
omap_hwmod_read_hardreset() omap_hwmod_del_initiator_dep()
omap_hwmod_enable_clocks() omap_hwmod_reset() omap_hwmod_ocp_barrier()
omap_hwmod_disable_clocks() omap_hwmod_add_initiator_dep()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mach-omap2/omap_hwmod.c |  232 --------------------------------------
 arch/arm/mach-omap2/omap_hwmod.h |   16 ---
 2 files changed, 248 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 716247e..fbfcf74 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -3504,91 +3504,6 @@ int omap_hwmod_shutdown(struct omap_hwmod *oh)
 	return 0;
 }
 
-/**
- * omap_hwmod_enable_clocks - enable main_clk, all interface clocks
- * @oh: struct omap_hwmod *oh
- *
- * Intended to be called by the omap_device code.
- */
-int omap_hwmod_enable_clocks(struct omap_hwmod *oh)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&oh->_lock, flags);
-	_enable_clocks(oh);
-	spin_unlock_irqrestore(&oh->_lock, flags);
-
-	return 0;
-}
-
-/**
- * omap_hwmod_disable_clocks - disable main_clk, all interface clocks
- * @oh: struct omap_hwmod *oh
- *
- * Intended to be called by the omap_device code.
- */
-int omap_hwmod_disable_clocks(struct omap_hwmod *oh)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&oh->_lock, flags);
-	_disable_clocks(oh);
-	spin_unlock_irqrestore(&oh->_lock, flags);
-
-	return 0;
-}
-
-/**
- * omap_hwmod_ocp_barrier - wait for posted writes against the hwmod to complete
- * @oh: struct omap_hwmod *oh
- *
- * Intended to be called by drivers and core code when all posted
- * writes to a device must complete before continuing further
- * execution (for example, after clearing some device IRQSTATUS
- * register bits)
- *
- * XXX what about targets with multiple OCP threads?
- */
-void omap_hwmod_ocp_barrier(struct omap_hwmod *oh)
-{
-	BUG_ON(!oh);
-
-	if (!oh->class->sysc || !oh->class->sysc->sysc_flags) {
-		WARN(1, "omap_device: %s: OCP barrier impossible due to device configuration\n",
-			oh->name);
-		return;
-	}
-
-	/*
-	 * Forces posted writes to complete on the OCP thread handling
-	 * register writes
-	 */
-	omap_hwmod_read(oh, oh->class->sysc->sysc_offs);
-}
-
-/**
- * omap_hwmod_reset - reset the hwmod
- * @oh: struct omap_hwmod *
- *
- * Under some conditions, a driver may wish to reset the entire device.
- * Called from omap_device code.  Returns -EINVAL on error or passes along
- * the return value from _reset().
- */
-int omap_hwmod_reset(struct omap_hwmod *oh)
-{
-	int r;
-	unsigned long flags;
-
-	if (!oh)
-		return -EINVAL;
-
-	spin_lock_irqsave(&oh->_lock, flags);
-	r = _reset(oh);
-	spin_unlock_irqrestore(&oh->_lock, flags);
-
-	return r;
-}
-
 /*
  * IP block data retrieval functions
  */
@@ -3843,52 +3758,12 @@ void __iomem *omap_hwmod_get_mpu_rt_va(struct omap_hwmod *oh)
 	return oh->_mpu_rt_va;
 }
 
-/**
- * omap_hwmod_add_initiator_dep - add sleepdep from @init_oh to @oh
- * @oh: struct omap_hwmod *
- * @init_oh: struct omap_hwmod * (initiator)
- *
- * Add a sleep dependency between the initiator @init_oh and @oh.
- * Intended to be called by DSP/Bridge code via platform_data for the
- * DSP case; and by the DMA code in the sDMA case.  DMA code, *Bridge
- * code needs to add/del initiator dependencies dynamically
- * before/after accessing a device.  Returns the return value from
- * _add_initiator_dep().
- *
- * XXX Keep a usecount in the clockdomain code
- */
-int omap_hwmod_add_initiator_dep(struct omap_hwmod *oh,
-				 struct omap_hwmod *init_oh)
-{
-	return _add_initiator_dep(oh, init_oh);
-}
-
 /*
  * XXX what about functions for drivers to save/restore ocp_sysconfig
  * for context save/restore operations?
  */
 
 /**
- * omap_hwmod_del_initiator_dep - remove sleepdep from @init_oh to @oh
- * @oh: struct omap_hwmod *
- * @init_oh: struct omap_hwmod * (initiator)
- *
- * Remove a sleep dependency between the initiator @init_oh and @oh.
- * Intended to be called by DSP/Bridge code via platform_data for the
- * DSP case; and by the DMA code in the sDMA case.  DMA code, *Bridge
- * code needs to add/del initiator dependencies dynamically
- * before/after accessing a device.  Returns the return value from
- * _del_initiator_dep().
- *
- * XXX Keep a usecount in the clockdomain code
- */
-int omap_hwmod_del_initiator_dep(struct omap_hwmod *oh,
-				 struct omap_hwmod *init_oh)
-{
-	return _del_initiator_dep(oh, init_oh);
-}
-
-/**
  * omap_hwmod_enable_wakeup - allow device to wake up the system
  * @oh: struct omap_hwmod *
  *
@@ -4009,33 +3884,6 @@ int omap_hwmod_deassert_hardreset(struct omap_hwmod *oh, const char *name)
 }
 
 /**
- * omap_hwmod_read_hardreset - read the HW reset line state of submodules
- * contained in the hwmod module
- * @oh: struct omap_hwmod *
- * @name: name of the reset line to look up and read
- *
- * Return the current state of the hwmod @oh's reset line named @name:
- * returns -EINVAL upon parameter error or if this operation
- * is unsupported on the current OMAP; otherwise, passes along the return
- * value from _read_hardreset().
- */
-int omap_hwmod_read_hardreset(struct omap_hwmod *oh, const char *name)
-{
-	int ret;
-	unsigned long flags;
-
-	if (!oh)
-		return -EINVAL;
-
-	spin_lock_irqsave(&oh->_lock, flags);
-	ret = _read_hardreset(oh, name);
-	spin_unlock_irqrestore(&oh->_lock, flags);
-
-	return ret;
-}
-
-
-/**
  * omap_hwmod_for_each_by_class - call @fn for each hwmod of class @classname
  * @classname: struct omap_hwmod_class name to search for
  * @fn: callback function pointer to call for each hwmod in class @classname
@@ -4145,86 +3993,6 @@ int omap_hwmod_get_context_loss_count(struct omap_hwmod *oh)
 }
 
 /**
- * omap_hwmod_no_setup_reset - prevent a hwmod from being reset upon setup
- * @oh: struct omap_hwmod *
- *
- * Prevent the hwmod @oh from being reset during the setup process.
- * Intended for use by board-*.c files on boards with devices that
- * cannot tolerate being reset.  Must be called before the hwmod has
- * been set up.  Returns 0 upon success or negative error code upon
- * failure.
- */
-int omap_hwmod_no_setup_reset(struct omap_hwmod *oh)
-{
-	if (!oh)
-		return -EINVAL;
-
-	if (oh->_state != _HWMOD_STATE_REGISTERED) {
-		pr_err("omap_hwmod: %s: cannot prevent setup reset; in wrong state\n",
-			oh->name);
-		return -EINVAL;
-	}
-
-	oh->flags |= HWMOD_INIT_NO_RESET;
-
-	return 0;
-}
-
-/**
- * omap_hwmod_pad_route_irq - route an I/O pad wakeup to a particular MPU IRQ
- * @oh: struct omap_hwmod * containing hwmod mux entries
- * @pad_idx: array index in oh->mux of the hwmod mux entry to route wakeup
- * @irq_idx: the hwmod mpu_irqs array index of the IRQ to trigger on wakeup
- *
- * When an I/O pad wakeup arrives for the dynamic or wakeup hwmod mux
- * entry number @pad_idx for the hwmod @oh, trigger the interrupt
- * service routine for the hwmod's mpu_irqs array index @irq_idx.  If
- * this function is not called for a given pad_idx, then the ISR
- * associated with @oh's first MPU IRQ will be triggered when an I/O
- * pad wakeup occurs on that pad.  Note that @pad_idx is the index of
- * the _dynamic or wakeup_ entry: if there are other entries not
- * marked with OMAP_DEVICE_PAD_WAKEUP or OMAP_DEVICE_PAD_REMUX, these
- * entries are NOT COUNTED in the dynamic pad index.  This function
- * must be called separately for each pad that requires its interrupt
- * to be re-routed this way.  Returns -EINVAL if there is an argument
- * problem or if @oh does not have hwmod mux entries or MPU IRQs;
- * returns -ENOMEM if memory cannot be allocated; or 0 upon success.
- *
- * XXX This function interface is fragile.  Rather than using array
- * indexes, which are subject to unpredictable change, it should be
- * using hwmod IRQ names, and some other stable key for the hwmod mux
- * pad records.
- */
-int omap_hwmod_pad_route_irq(struct omap_hwmod *oh, int pad_idx, int irq_idx)
-{
-	int nr_irqs;
-
-	might_sleep();
-
-	if (!oh || !oh->mux || !oh->mpu_irqs || pad_idx < 0 ||
-	    pad_idx >= oh->mux->nr_pads_dynamic)
-		return -EINVAL;
-
-	/* Check the number of available mpu_irqs */
-	for (nr_irqs = 0; oh->mpu_irqs[nr_irqs].irq >= 0; nr_irqs++)
-		;
-
-	if (irq_idx >= nr_irqs)
-		return -EINVAL;
-
-	if (!oh->mux->irqs) {
-		/* XXX What frees this? */
-		oh->mux->irqs = kzalloc(sizeof(int) * oh->mux->nr_pads_dynamic,
-			GFP_KERNEL);
-		if (!oh->mux->irqs)
-			return -ENOMEM;
-	}
-	oh->mux->irqs[pad_idx] = irq_idx;
-
-	return 0;
-}
-
-/**
  * omap_hwmod_init - initialize the hwmod code
  *
  * Sets up some function pointers needed by the hwmod code to operate on the
diff --git a/arch/arm/mach-omap2/omap_hwmod.h b/arch/arm/mach-omap2/omap_hwmod.h
index 512f809..abfe56d 100644
--- a/arch/arm/mach-omap2/omap_hwmod.h
+++ b/arch/arm/mach-omap2/omap_hwmod.h
@@ -694,13 +694,6 @@ int omap_hwmod_shutdown(struct omap_hwmod *oh);
 
 int omap_hwmod_assert_hardreset(struct omap_hwmod *oh, const char *name);
 int omap_hwmod_deassert_hardreset(struct omap_hwmod *oh, const char *name);
-int omap_hwmod_read_hardreset(struct omap_hwmod *oh, const char *name);
-
-int omap_hwmod_enable_clocks(struct omap_hwmod *oh);
-int omap_hwmod_disable_clocks(struct omap_hwmod *oh);
-
-int omap_hwmod_reset(struct omap_hwmod *oh);
-void omap_hwmod_ocp_barrier(struct omap_hwmod *oh);
 
 void omap_hwmod_write(u32 v, struct omap_hwmod *oh, u16 reg_offs);
 u32 omap_hwmod_read(struct omap_hwmod *oh, u16 reg_offs);
@@ -715,11 +708,6 @@ int omap_hwmod_get_resource_byname(struct omap_hwmod *oh, unsigned int type,
 struct powerdomain *omap_hwmod_get_pwrdm(struct omap_hwmod *oh);
 void __iomem *omap_hwmod_get_mpu_rt_va(struct omap_hwmod *oh);
 
-int omap_hwmod_add_initiator_dep(struct omap_hwmod *oh,
-				 struct omap_hwmod *init_oh);
-int omap_hwmod_del_initiator_dep(struct omap_hwmod *oh,
-				 struct omap_hwmod *init_oh);
-
 int omap_hwmod_enable_wakeup(struct omap_hwmod *oh);
 int omap_hwmod_disable_wakeup(struct omap_hwmod *oh);
 
@@ -731,10 +719,6 @@ int omap_hwmod_for_each_by_class(const char *classname,
 int omap_hwmod_set_postsetup_state(struct omap_hwmod *oh, u8 state);
 int omap_hwmod_get_context_loss_count(struct omap_hwmod *oh);
 
-int omap_hwmod_no_setup_reset(struct omap_hwmod *oh);
-
-int omap_hwmod_pad_route_irq(struct omap_hwmod *oh, int pad_idx, int irq_idx);
-
 extern void __init omap_hwmod_init(void);
 
 const char *omap_hwmod_get_main_clk(struct omap_hwmod *oh);
-- 
1.7.10.4

