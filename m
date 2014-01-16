Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaAPJzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:55:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44473 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaAPJzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:55:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.29
Date: Thu, 16 Jan 2014 09:55:04 +0000
Message-Id: <1389866104-12234-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389866104-12234-1-git-send-email-luis.henriques@canonical.com>
References: <1389866104-12234-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b5576c6..546de15 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1364,6 +1364,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 			* dump_id: dump IDENTIFY data.
 
+
+			* disable: Disable this device.
+
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
diff --git a/Makefile b/Makefile
index 6b37b43..e3d51be 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .28
+EXTRAVERSION = .29
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 7f227f7..39db4f4 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -37,7 +37,13 @@
 
 #include "signal.h"
 
-static const char *handler[]= { "prefetch abort", "data abort", "address exception", "interrupt" };
+static const char *handler[]= {
+	"prefetch abort",
+	"data abort",
+	"address exception",
+	"interrupt",
+	"undefined instruction",
+};
 
 void *vectors_page;
 
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 2d710f5..69a58c7 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -360,7 +360,7 @@ static int _set_clockactivity(struct omap_hwmod *oh, u8 clockact, u32 *v)
 }
 
 /**
- * _set_softreset: set OCP_SYSCONFIG.CLOCKACTIVITY bits in @v
+ * _set_softreset: set OCP_SYSCONFIG.SOFTRESET bit in @v
  * @oh: struct omap_hwmod *
  * @v: pointer to register contents to modify
  *
@@ -388,6 +388,36 @@ static int _set_softreset(struct omap_hwmod *oh, u32 *v)
 }
 
 /**
+ * _clear_softreset: clear OCP_SYSCONFIG.SOFTRESET bit in @v
+ * @oh: struct omap_hwmod *
+ * @v: pointer to register contents to modify
+ *
+ * Clear the SOFTRESET bit in @v for hwmod @oh.  Returns -EINVAL upon
+ * error or 0 upon success.
+ */
+static int _clear_softreset(struct omap_hwmod *oh, u32 *v)
+{
+	u32 softrst_mask;
+
+	if (!oh->class->sysc ||
+	    !(oh->class->sysc->sysc_flags & SYSC_HAS_SOFTRESET))
+		return -EINVAL;
+
+	if (!oh->class->sysc->sysc_fields) {
+		WARN(1,
+		     "omap_hwmod: %s: sysc_fields absent for sysconfig class\n",
+		     oh->name);
+		return -EINVAL;
+	}
+
+	softrst_mask = (0x1 << oh->class->sysc->sysc_fields->srst_shift);
+
+	*v &= ~softrst_mask;
+
+	return 0;
+}
+
+/**
  * _set_module_autoidle: set the OCP_SYSCONFIG AUTOIDLE field in @v
  * @oh: struct omap_hwmod *
  * @autoidle: desired AUTOIDLE bitfield value (0 or 1)
@@ -1655,6 +1685,12 @@ static int _ocp_softreset(struct omap_hwmod *oh)
 	ret = _set_softreset(oh, &v);
 	if (ret)
 		goto dis_opt_clks;
+
+	_write_sysconfig(v, oh);
+	ret = _clear_softreset(oh, &v);
+	if (ret)
+		goto dis_opt_clks;
+
 	_write_sysconfig(v, oh);
 
 	if (oh->class->sysc->srst_udelay)
@@ -2488,6 +2524,11 @@ int omap_hwmod_softreset(struct omap_hwmod *oh)
 		goto error;
 	_write_sysconfig(v, oh);
 
+	ret = _clear_softreset(oh, &v);
+	if (ret)
+		goto error;
+	_write_sysconfig(v, oh);
+
 error:
 	return ret;
 }
diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index b26d3c9..43058d4 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -1850,7 +1850,8 @@ static struct omap_hwmod_class_sysconfig omap3xxx_usb_host_hs_sysc = {
 	.syss_offs	= 0x0014,
 	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_CLOCKACTIVITY |
 			   SYSC_HAS_SIDLEMODE | SYSC_HAS_ENAWAKEUP |
-			   SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE),
+			   SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE |
+			   SYSS_HAS_RESET_STATUS),
 	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
 			   MSTANDBY_FORCE | MSTANDBY_NO | MSTANDBY_SMART),
 	.sysc_fields	= &omap_hwmod_sysc_type1,
@@ -1928,15 +1929,7 @@ static struct omap_hwmod omap3xxx_usb_host_hs_hwmod = {
 	 * hence HWMOD_SWSUP_MSTANDBY
 	 */
 
-	/*
-	 * During system boot; If the hwmod framework resets the module
-	 * the module will have smart idle settings; which can lead to deadlock
-	 * (above Errata Id:i660); so, dont reset the module during boot;
-	 * Use HWMOD_INIT_NO_RESET.
-	 */
-
-	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY |
-			  HWMOD_INIT_NO_RESET,
+	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
 };
 
 /*
diff --git a/arch/arm/mach-pxa/reset.c b/arch/arm/mach-pxa/reset.c
index b452889..7f8cda4 100644
--- a/arch/arm/mach-pxa/reset.c
+++ b/arch/arm/mach-pxa/reset.c
@@ -13,6 +13,7 @@
 
 #include <mach/regs-ost.h>
 #include <mach/reset.h>
+#include <mach/smemc.h>
 
 unsigned int reset_status;
 EXPORT_SYMBOL(reset_status);
@@ -80,6 +81,12 @@ static void do_hw_reset(void)
 	OWER = OWER_WME;
 	OSSR = OSSR_M3;
 	OSMR3 = OSCR + 368640;	/* ... in 100 ms */
+	/*
+	 * SDRAM hangs on watchdog reset on Marvell PXA270 (erratum 71)
+	 * we put SDRAM into self-refresh to prevent that
+	 */
+	while (1)
+		writel_relaxed(MDREFR_SLFRSH, MDREFR);
 }
 
 void pxa_restart(char mode, const char *cmd)
@@ -103,4 +110,3 @@ void pxa_restart(char mode, const char *cmd)
 		break;
 	}
 }
-
diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/include/asm/exception-64s.h
index 6afb13a..241d2f3 100644
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -163,7 +163,7 @@ do_kvm_##n:								\
 	subi	r1,r1,INT_FRAME_SIZE;	/* alloc frame on kernel stack	*/ \
 	beq-	1f;							   \
 	ld	r1,PACAKSAVE(r13);	/* kernel stack to use		*/ \
-1:	cmpdi	cr1,r1,0;		/* check if r1 is in userspace	*/ \
+1:	cmpdi	cr1,r1,-INT_FRAME_SIZE;	/* check if r1 is in userspace	*/ \
 	blt+	cr1,3f;			/* abort if it is		*/ \
 	li	r1,(n);			/* will be reloaded later	*/ \
 	sth	r1,PACA_TRAP_SAVE(r13);					   \
diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 1a3607b..1a5b687 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -447,6 +447,7 @@ _STATIC(__after_prom_start)
 	mtctr	r8
 	bctr
 
+.balign 8
 p_end:	.llong	_end - _stext
 
 4:	/* Now copy the rest of the kernel up to _end */
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 80a5775..a8df79d 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -387,11 +387,14 @@ static int kvmppc_mmu_book3s_64_hv_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
 		slb_v = vcpu->kvm->arch.vrma_slb_v;
 	}
 
+	preempt_disable();
 	/* Find the HPTE in the hash table */
 	index = kvmppc_hv_find_lock_hpte(kvm, eaddr, slb_v,
 					 HPTE_V_VALID | HPTE_V_ABSENT);
-	if (index < 0)
+	if (index < 0) {
+		preempt_enable();
 		return -ENOENT;
+	}
 	hptep = (unsigned long *)(kvm->arch.hpt_virt + (index << 4));
 	v = hptep[0] & ~HPTE_V_HVLOCK;
 	gr = kvm->arch.revmap[index].guest_rpte;
@@ -399,6 +402,7 @@ static int kvmppc_mmu_book3s_64_hv_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
 	/* Unlock the HPTE */
 	asm volatile("lwsync" : : : "memory");
 	hptep[0] = v;
+	preempt_enable();
 
 	gpte->eaddr = eaddr;
 	gpte->vpage = ((v & HPTE_V_AVPN) << 4) | ((eaddr >> 12) & 0xfff);
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index cec4dad..eacf164 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -649,6 +649,10 @@ static int slb_base_page_shift[4] = {
 	20,	/* 1M, unsupported */
 };
 
+/* When called from virtmode, this func should be protected by
+ * preempt_disable(), otherwise, the holding of HPTE_V_HVLOCK
+ * can trigger deadlock issue.
+ */
 long kvmppc_hv_find_lock_hpte(struct kvm *kvm, gva_t eaddr, unsigned long slb_v,
 			      unsigned long valid)
 {
diff --git a/arch/sh/lib/Makefile b/arch/sh/lib/Makefile
index 7b95f29..3baff31 100644
--- a/arch/sh/lib/Makefile
+++ b/arch/sh/lib/Makefile
@@ -6,7 +6,7 @@ lib-y  = delay.o memmove.o memchr.o \
 	 checksum.o strlen.o div64.o div64-generic.o
 
 # Extracted from libgcc
-lib-y += movmem.o ashldi3.o ashrdi3.o lshrdi3.o \
+obj-y += movmem.o ashldi3.o ashrdi3.o lshrdi3.o \
 	 ashlsi3.o ashrsi3.o ashiftrt.o lshrsi3.o \
 	 udiv_qrnnd.o
 
diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 04cb0f8..786f56a 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -266,12 +266,13 @@ static inline int restore_fpu_checking(struct task_struct *tsk)
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. "m" is a random variable that should be in L1 */
-	alternative_input(
-		ASM_NOP8 ASM_NOP2,
-		"emms\n\t"		/* clear stack tags */
-		"fildl %P[addr]",	/* set F?P to defined value */
-		X86_FEATURE_FXSAVE_LEAK,
-		[addr] "m" (tsk->thread.fpu.has_fpu));
+	if (unlikely(static_cpu_has(X86_FEATURE_FXSAVE_LEAK))) {
+		asm volatile(
+			"fnclex\n\t"
+			"emms\n\t"
+			"fildl %P[addr]"	/* set F?P to defined value */
+			: : [addr] "m" (tsk->thread.fpu.has_fpu));
+	}
 
 	return fpu_restore_checking(&tsk->thread.fpu);
 }
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 705658d..f1e3b76 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4105,6 +4105,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "ST3320[68]13AS",	"SD1[5-9]",	ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
 
+	/* Seagate Momentus SpinPoint M8 seem to have FPMDA_AA issues */
+	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
+
 	/* Blacklist entries taken from Silicon Image 3124/3132
 	   Windows driver .inf file - also several Linux problem reports */
 	{ "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },
@@ -6399,6 +6402,7 @@ static int __init ata_parse_force_one(char **cur,
 		{ "nohrst",	.lflags		= ATA_LFLAG_NO_HRST },
 		{ "nosrst",	.lflags		= ATA_LFLAG_NO_SRST },
 		{ "norst",	.lflags		= ATA_LFLAG_NO_HRST | ATA_LFLAG_NO_SRST },
+		{ "disable",	.horkage_on	= ATA_HORKAGE_DISABLE },
 	};
 	char *start = *cur, *p = *cur;
 	char *id, *val, *endp;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 15863a4..970c6ad 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3636,6 +3636,27 @@ void ata_scsi_hotplug(struct work_struct *work)
 		return;
 	}
 
+	/*
+	 * XXX - UGLY HACK
+	 *
+	 * The block layer suspend/resume path is fundamentally broken due
+	 * to freezable kthreads and workqueue and may deadlock if a block
+	 * device gets removed while resume is in progress.  I don't know
+	 * what the solution is short of removing freezable kthreads and
+	 * workqueues altogether.
+	 *
+	 * The following is an ugly hack to avoid kicking off device
+	 * removal while freezer is active.  This is a joke but does avoid
+	 * this particular deadlock scenario.
+	 *
+	 * https://bugzilla.kernel.org/show_bug.cgi?id=62801
+	 * http://marc.info/?l=linux-kernel&m=138695698516487
+	 */
+#ifdef CONFIG_FREEZER
+	while (pm_freezing)
+		msleep(10);
+#endif
+
 	DPRINTK("ENTER\n");
 	mutex_lock(&ap->scsi_scan_mutex);
 
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index aadeb5b..ff6c108 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -270,6 +270,7 @@ config NET_DMA
 	bool "Network: TCP receive copy offload"
 	depends on DMA_ENGINE && NET
 	default (INTEL_IOATDMA || FSL_DMA)
+	depends on BROKEN
 	help
 	  This enables the use of DMA engines in the network stack to
 	  offload receive copy-to-user operations, freeing CPU cycles.
diff --git a/drivers/gpio/gpio-msm-v2.c b/drivers/gpio/gpio-msm-v2.c
index 5cb1227..3104502 100644
--- a/drivers/gpio/gpio-msm-v2.c
+++ b/drivers/gpio/gpio-msm-v2.c
@@ -249,7 +249,7 @@ static void msm_gpio_irq_mask(struct irq_data *d)
 
 	spin_lock_irqsave(&tlmm_lock, irq_flags);
 	writel(TARGET_PROC_NONE, GPIO_INTR_CFG_SU(gpio));
-	clear_gpio_bits(INTR_RAW_STATUS_EN | INTR_ENABLE, GPIO_INTR_CFG(gpio));
+	clear_gpio_bits(BIT(INTR_RAW_STATUS_EN) | BIT(INTR_ENABLE), GPIO_INTR_CFG(gpio));
 	__clear_bit(gpio, msm_gpio.enabled_irqs);
 	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
 }
@@ -261,7 +261,7 @@ static void msm_gpio_irq_unmask(struct irq_data *d)
 
 	spin_lock_irqsave(&tlmm_lock, irq_flags);
 	__set_bit(gpio, msm_gpio.enabled_irqs);
-	set_gpio_bits(INTR_RAW_STATUS_EN | INTR_ENABLE, GPIO_INTR_CFG(gpio));
+	set_gpio_bits(BIT(INTR_RAW_STATUS_EN) | BIT(INTR_ENABLE), GPIO_INTR_CFG(gpio));
 	writel(TARGET_PROC_SCORPION, GPIO_INTR_CFG_SU(gpio));
 	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
 }
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index bdbc6a2..92735dd 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -68,6 +68,8 @@
 #define EDID_QUIRK_DETAILED_SYNC_PP		(1 << 6)
 /* Force reduced-blanking timings for detailed modes */
 #define EDID_QUIRK_FORCE_REDUCED_BLANKING	(1 << 7)
+/* Force 8bpc */
+#define EDID_QUIRK_FORCE_8BPC			(1 << 8)
 
 struct detailed_mode_closure {
 	struct drm_connector *connector;
@@ -128,6 +130,9 @@ static struct edid_quirk {
 
 	/* Medion MD 30217 PG */
 	{ "MED", 0x7b8, EDID_QUIRK_PREFER_LARGE_75 },
+
+	/* Panel in Samsung NP700G7A-S01PL notebook reports 6bpc */
+	{ "SEC", 0xd033, EDID_QUIRK_FORCE_8BPC },
 };
 
 /*** DDC fetch and block validation ***/
@@ -1934,6 +1939,9 @@ int drm_add_edid_modes(struct drm_connector *connector, struct edid *edid)
 
 	drm_add_display_info(edid, &connector->display_info);
 
+	if (quirks & EDID_QUIRK_FORCE_8BPC)
+		connector->display_info.bpc = 8;
+
 	return num_modes;
 }
 EXPORT_SYMBOL(drm_add_edid_modes);
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 36822b9..e676408 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -85,6 +85,14 @@ void i915_update_dri1_breadcrumb(struct drm_device *dev)
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct drm_i915_master_private *master_priv;
 
+	/*
+	 * The dri breadcrumb update races against the drm master disappearing.
+	 * Instead of trying to fix this (this is by far not the only ums issue)
+	 * just don't do the update in kms mode.
+	 */
+	if (drm_core_check_feature(dev, DRIVER_MODESET))
+		return;
+
 	if (dev->primary->master) {
 		master_priv = dev->primary->master->driver_priv;
 		if (master_priv->sarea_priv)
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index fcd7335..768baf7 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -475,6 +475,10 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 		    (rdev->pdev->device == 0x999C)) {
 			rdev->config.cayman.max_simds_per_se = 6;
 			rdev->config.cayman.max_backends_per_se = 2;
+			rdev->config.cayman.max_hw_contexts = 8;
+			rdev->config.cayman.sx_max_export_size = 256;
+			rdev->config.cayman.sx_max_export_pos_size = 64;
+			rdev->config.cayman.sx_max_export_smx_size = 192;
 		} else if ((rdev->pdev->device == 0x9903) ||
 			   (rdev->pdev->device == 0x9904) ||
 			   (rdev->pdev->device == 0x990A) ||
@@ -485,6 +489,10 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 			   (rdev->pdev->device == 0x999D)) {
 			rdev->config.cayman.max_simds_per_se = 4;
 			rdev->config.cayman.max_backends_per_se = 2;
+			rdev->config.cayman.max_hw_contexts = 8;
+			rdev->config.cayman.sx_max_export_size = 256;
+			rdev->config.cayman.sx_max_export_pos_size = 64;
+			rdev->config.cayman.sx_max_export_smx_size = 192;
 		} else if ((rdev->pdev->device == 0x9919) ||
 			   (rdev->pdev->device == 0x9990) ||
 			   (rdev->pdev->device == 0x9991) ||
@@ -495,9 +503,17 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 			   (rdev->pdev->device == 0x99A0)) {
 			rdev->config.cayman.max_simds_per_se = 3;
 			rdev->config.cayman.max_backends_per_se = 1;
+			rdev->config.cayman.max_hw_contexts = 4;
+			rdev->config.cayman.sx_max_export_size = 128;
+			rdev->config.cayman.sx_max_export_pos_size = 32;
+			rdev->config.cayman.sx_max_export_smx_size = 96;
 		} else {
 			rdev->config.cayman.max_simds_per_se = 2;
 			rdev->config.cayman.max_backends_per_se = 1;
+			rdev->config.cayman.max_hw_contexts = 4;
+			rdev->config.cayman.sx_max_export_size = 128;
+			rdev->config.cayman.sx_max_export_pos_size = 32;
+			rdev->config.cayman.sx_max_export_smx_size = 96;
 		}
 		rdev->config.cayman.max_texture_channel_caches = 2;
 		rdev->config.cayman.max_gprs = 256;
@@ -505,10 +521,6 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 		rdev->config.cayman.max_gs_threads = 32;
 		rdev->config.cayman.max_stack_entries = 512;
 		rdev->config.cayman.sx_num_of_sets = 8;
-		rdev->config.cayman.sx_max_export_size = 256;
-		rdev->config.cayman.sx_max_export_pos_size = 64;
-		rdev->config.cayman.sx_max_export_smx_size = 192;
-		rdev->config.cayman.max_hw_contexts = 8;
 		rdev->config.cayman.sq_num_cf_insts = 2;
 
 		rdev->config.cayman.sc_prim_fifo_size = 0x40;
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index bcfb0a3..024ceeb 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -160,6 +160,17 @@ void rs690_mc_init(struct radeon_device *rdev)
 	base = RREG32_MC(R_000100_MCCFG_FB_LOCATION);
 	base = G_000100_MC_FB_START(base) << 16;
 	rdev->mc.igp_sideport_enabled = radeon_atombios_sideport_present(rdev);
+	/* Some boards seem to be configured for 128MB of sideport memory,
+	 * but really only have 64MB.  Just skip the sideport and use
+	 * UMA memory.
+	 */
+	if (rdev->mc.igp_sideport_enabled &&
+	    (rdev->mc.real_vram_size == (384 * 1024 * 1024))) {
+		base += 128 * 1024 * 1024;
+		rdev->mc.real_vram_size -= 128 * 1024 * 1024;
+		rdev->mc.mc_vram_size = rdev->mc.real_vram_size;
+	}
+
 	rs690_pm_info(rdev);
 	radeon_vram_location(rdev, &rdev->mc, base);
 	rdev->mc.gtt_base_align = rdev->mc.gtt_size - 1;
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 509d119..abc1fcd 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -382,7 +382,7 @@ static int hid_parser_global(struct hid_parser *parser, struct hid_item *item)
 
 	case HID_GLOBAL_ITEM_TAG_REPORT_SIZE:
 		parser->global.report_size = item_udata(item);
-		if (parser->global.report_size > 96) {
+		if (parser->global.report_size > 128) {
 			hid_err(parser->device, "invalid report_size %d\n",
 					parser->global.report_size);
 			return -1;
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 04eced7..674e352 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -169,6 +169,38 @@ static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.enter = &intel_idle },
 };
 
+static struct cpuidle_state ivb_cstates[MWAIT_MAX_NUM_CSTATES] = {
+	{ /* MWAIT C0 */ },
+	{ /* MWAIT C1 */
+		.name = "C1-IVB",
+		.desc = "MWAIT 0x00",
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 1,
+		.target_residency = 1,
+		.enter = &intel_idle },
+	{ /* MWAIT C2 */
+		.name = "C3-IVB",
+		.desc = "MWAIT 0x10",
+		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 59,
+		.target_residency = 156,
+		.enter = &intel_idle },
+	{ /* MWAIT C3 */
+		.name = "C6-IVB",
+		.desc = "MWAIT 0x20",
+		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 80,
+		.target_residency = 300,
+		.enter = &intel_idle },
+	{ /* MWAIT C4 */
+		.name = "C7-IVB",
+		.desc = "MWAIT 0x30",
+		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 87,
+		.target_residency = 300,
+		.enter = &intel_idle },
+};
+
 static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C0 */ },
 	{ /* MWAIT C1 */
@@ -347,6 +379,10 @@ static const struct idle_cpu idle_cpu_snb = {
 	.state_table = snb_cstates,
 };
 
+static const struct idle_cpu idle_cpu_ivb = {
+	.state_table = ivb_cstates,
+};
+
 #define ICPU(model, cpu) \
 	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_MWAIT, (unsigned long)&cpu }
 
@@ -362,6 +398,8 @@ static const struct x86_cpu_id intel_idle_ids[] = {
 	ICPU(0x2f, idle_cpu_nehalem),
 	ICPU(0x2a, idle_cpu_snb),
 	ICPU(0x2d, idle_cpu_snb),
+	ICPU(0x3a, idle_cpu_ivb),
+	ICPU(0x3e, idle_cpu_ivb),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_idle_ids);
diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index 8244208..573b460 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -284,8 +284,7 @@ static int qib_user_sdma_pin_pages(const struct qib_devdata *dd,
 	int j;
 	int ret;
 
-	ret = get_user_pages(current, current->mm, addr,
-			     npages, 0, 1, pages, NULL);
+	ret = get_user_pages_fast(addr, npages, 0, pages);
 
 	if (ret != npages) {
 		int i;
@@ -830,10 +829,7 @@ int qib_user_sdma_writev(struct qib_ctxtdata *rcd,
 	while (dim) {
 		const int mxp = 8;
 
-		down_write(&current->mm->mmap_sem);
 		ret = qib_user_sdma_queue_pkts(dd, pq, &list, iov, dim, mxp);
-		up_write(&current->mm->mmap_sem);
-
 		if (ret <= 0)
 			goto done_unlock;
 		else {
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 8921c61..d56c407 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1707,6 +1707,10 @@ void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int
 		break;
 
 	case EV_ABS:
+		input_alloc_absinfo(dev);
+		if (!dev->absinfo)
+			return;
+
 		__set_bit(code, dev->absbit);
 		break;
 
diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index e32709e..da159bc 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -106,6 +106,7 @@ struct usbtouch_device_info {
 struct usbtouch_usb {
 	unsigned char *data;
 	dma_addr_t data_dma;
+	int data_size;
 	unsigned char *buffer;
 	int buf_len;
 	struct urb *irq;
@@ -1483,7 +1484,7 @@ static int usbtouch_reset_resume(struct usb_interface *intf)
 static void usbtouch_free_buffers(struct usb_device *udev,
 				  struct usbtouch_usb *usbtouch)
 {
-	usb_free_coherent(udev, usbtouch->type->rept_size,
+	usb_free_coherent(udev, usbtouch->data_size,
 			  usbtouch->data, usbtouch->data_dma);
 	kfree(usbtouch->buffer);
 }
@@ -1528,7 +1529,20 @@ static int usbtouch_probe(struct usb_interface *intf,
 	if (!type->process_pkt)
 		type->process_pkt = usbtouch_process_pkt;
 
-	usbtouch->data = usb_alloc_coherent(udev, type->rept_size,
+	usbtouch->data_size = type->rept_size;
+	if (type->get_pkt_len) {
+		/*
+		 * When dealing with variable-length packets we should
+		 * not request more than wMaxPacketSize bytes at once
+		 * as we do not know if there is more data coming or
+		 * we filled exactly wMaxPacketSize bytes and there is
+		 * nothing else.
+		 */
+		usbtouch->data_size = min(usbtouch->data_size,
+					  usb_endpoint_maxp(endpoint));
+	}
+
+	usbtouch->data = usb_alloc_coherent(udev, usbtouch->data_size,
 					    GFP_KERNEL, &usbtouch->data_dma);
 	if (!usbtouch->data)
 		goto out_free;
@@ -1588,12 +1602,12 @@ static int usbtouch_probe(struct usb_interface *intf,
 	if (usb_endpoint_type(endpoint) == USB_ENDPOINT_XFER_INT)
 		usb_fill_int_urb(usbtouch->irq, udev,
 			 usb_rcvintpipe(udev, endpoint->bEndpointAddress),
-			 usbtouch->data, type->rept_size,
+			 usbtouch->data, usbtouch->data_size,
 			 usbtouch_irq, usbtouch, endpoint->bInterval);
 	else
 		usb_fill_bulk_urb(usbtouch->irq, udev,
 			 usb_rcvbulkpipe(udev, endpoint->bEndpointAddress),
-			 usbtouch->data, type->rept_size,
+			 usbtouch->data, usbtouch->data_size,
 			 usbtouch_irq, usbtouch);
 
 	usbtouch->irq->dev = udev;
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 86a56d8..274354d 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -85,6 +85,7 @@ struct multipath {
 	unsigned queue_io:1;		/* Must we queue all I/O? */
 	unsigned queue_if_no_path:1;	/* Queue I/O if last path fails? */
 	unsigned saved_queue_if_no_path:1; /* Saved state during suspension */
+	unsigned pg_init_disabled:1;	/* pg_init is not currently allowed */
 
 	unsigned pg_init_retries;	/* Number of times to retry pg_init */
 	unsigned pg_init_count;		/* Number of times pg_init called */
@@ -496,7 +497,8 @@ static void process_queued_ios(struct work_struct *work)
 	    (!pgpath && !m->queue_if_no_path))
 		must_queue = 0;
 
-	if (m->pg_init_required && !m->pg_init_in_progress && pgpath)
+	if (m->pg_init_required && !m->pg_init_in_progress && pgpath &&
+	    !m->pg_init_disabled)
 		__pg_init_all_paths(m);
 
 	spin_unlock_irqrestore(&m->lock, flags);
@@ -909,10 +911,20 @@ static void multipath_wait_for_pg_init_completion(struct multipath *m)
 
 static void flush_multipath_work(struct multipath *m)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&m->lock, flags);
+	m->pg_init_disabled = 1;
+	spin_unlock_irqrestore(&m->lock, flags);
+
 	flush_workqueue(kmpath_handlerd);
 	multipath_wait_for_pg_init_completion(m);
 	flush_workqueue(kmultipathd);
 	flush_work_sync(&m->trigger_event);
+
+	spin_lock_irqsave(&m->lock, flags);
+	m->pg_init_disabled = 0;
+	spin_unlock_irqrestore(&m->lock, flags);
 }
 
 static void multipath_dtr(struct dm_target *ti)
@@ -1131,7 +1143,7 @@ static int pg_init_limit_reached(struct multipath *m, struct pgpath *pgpath)
 
 	spin_lock_irqsave(&m->lock, flags);
 
-	if (m->pg_init_count <= m->pg_init_retries)
+	if (m->pg_init_count <= m->pg_init_retries && !m->pg_init_disabled)
 		m->pg_init_required = 1;
 	else
 		limit_reached = 1;
@@ -1653,7 +1665,7 @@ out:
  *---------------------------------------------------------------*/
 static struct target_type multipath_target = {
 	.name = "multipath",
-	.version = {1, 4, 0},
+	.version = {1, 4, 1},
 	.module = THIS_MODULE,
 	.ctr = multipath_ctr,
 	.dtr = multipath_dtr,
diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
index 3bba37d..2ff04b1 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -35,7 +35,7 @@ static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 		{
 			.addr = i2c,
 			.flags = 0,
-			.len = sizeof(buf),
+			.len = len + 1,
 			.buf = buf,
 		}
 	};
@@ -68,7 +68,7 @@ static int cxd2820r_rd_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 		}, {
 			.addr = i2c,
 			.flags = I2C_M_RD,
-			.len = sizeof(buf),
+			.len = len,
 			.buf = buf,
 		}
 	};
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 18657a9..3390b69 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -14813,6 +14813,9 @@ static int __devinit tg3_get_invariants(struct tg3 *tp)
 	/* Clear this out for sanity. */
 	tw32(TG3PCI_MEM_WIN_BASE_ADDR, 0);
 
+	/* Clear TG3PCI_REG_BASE_ADDR to prevent hangs. */
+	tw32(TG3PCI_REG_BASE_ADDR, 0);
+
 	pci_read_config_dword(tp->pdev, TG3PCI_PCISTATE,
 			      &pci_state_reg);
 	if ((pci_state_reg & PCISTATE_CONV_PCI_MODE) == 0 &&
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 8a3cd87..e59baaf 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1761,7 +1761,7 @@ static int xgmac_probe(struct platform_device *pdev)
 	if (device_can_wakeup(priv->device))
 		priv->wolopts = WAKE_MAGIC;	/* Magic Frame as default */
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA;
+	ndev->hw_features = NETIF_F_SG | NETIF_F_HIGHDMA;
 	if (readl(priv->base + XGMAC_DMA_HW_FEATURE) & DMA_HW_FEAT_TXCOESEL)
 		ndev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				     NETIF_F_RXCSUM;
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index f4d2da0..8b3da6e 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -3029,7 +3029,7 @@ static struct ehea_port *ehea_setup_single_port(struct ehea_adapter *adapter,
 
 	dev->hw_features = NETIF_F_SG | NETIF_F_TSO
 		      | NETIF_F_IP_CSUM | NETIF_F_HW_VLAN_TX | NETIF_F_LRO;
-	dev->features = NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_TSO
+	dev->features = NETIF_F_SG | NETIF_F_TSO
 		      | NETIF_F_HIGHDMA | NETIF_F_IP_CSUM | NETIF_F_HW_VLAN_TX
 		      | NETIF_F_HW_VLAN_RX | NETIF_F_HW_VLAN_FILTER
 		      | NETIF_F_RXCSUM;
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index 447a693..4446992 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -1991,7 +1991,6 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		ndev->features = NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO
 		    | NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX |
 		    NETIF_F_HW_VLAN_FILTER | NETIF_F_RXCSUM
-		    /*| NETIF_F_FRAGLIST */
 		    ;
 		ndev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
 			NETIF_F_TSO | NETIF_F_HW_VLAN_TX;
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 26e487b..3ddbecf 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1027,7 +1027,7 @@ static int __devinit temac_of_probe(struct platform_device *op)
 	dev_set_drvdata(&op->dev, ndev);
 	SET_NETDEV_DEV(ndev, &op->dev);
 	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
-	ndev->features = NETIF_F_SG | NETIF_F_FRAGLIST;
+	ndev->features = NETIF_F_SG;
 	ndev->netdev_ops = &temac_netdev_ops;
 	ndev->ethtool_ops = &temac_ethtool_ops;
 #if 0
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 9c365e1..fde716d 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1494,7 +1494,7 @@ static int __devinit axienet_of_probe(struct platform_device *op)
 
 	SET_NETDEV_DEV(ndev, &op->dev);
 	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
-	ndev->features = NETIF_F_SG | NETIF_F_FRAGLIST;
+	ndev->features = NETIF_F_SG;
 	ndev->netdev_ops = &axienet_netdev_ops;
 	ndev->ethtool_ops = &axienet_ethtool_ops;
 
diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
index a4a3516..3b3a7e0 100644
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -571,6 +571,8 @@ static int hdlcdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case HDLCDRVCTL_CALIBRATE:
 		if(!capable(CAP_SYS_RAWIO))
 			return -EPERM;
+		if (bi.data.calibrate > INT_MAX / s->par.bitrate)
+			return -EINVAL;
 		s->hdlctx.calibrate = bi.data.calibrate * s->par.bitrate / 16;
 		return 0;
 
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 5a6412e..d8faeb6 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -1058,6 +1058,7 @@ static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		break;
 
 	case SIOCYAMGCFG:
+		memset(&yi, 0, sizeof(yi));
 		yi.cfg.mask = 0xffffffff;
 		yi.cfg.iobase = yp->iobase;
 		yi.cfg.irq = yp->irq;
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 8f8ed33..219a04b 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -325,7 +325,6 @@ static int netvsc_change_mtu(struct net_device *ndev, int mtu)
 		return -EINVAL;
 
 	nvdev->start_remove = true;
-	cancel_delayed_work_sync(&ndevctx->dwork);
 	cancel_work_sync(&ndevctx->work);
 	netif_tx_disable(ndev);
 	rndis_filter_device_remove(hdev);
diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 8b7c4f2..eec890e 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -798,11 +798,10 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 				const struct sk_buff *skb,
 				const struct iovec *iv, int len)
 {
-	struct macvlan_dev *vlan;
 	int ret;
 	int vnet_hdr_len = 0;
 	int vlan_offset = 0;
-	int copied;
+	int copied, total;
 
 	if (q->flags & IFF_VNET_HDR) {
 		struct virtio_net_hdr vnet_hdr;
@@ -817,7 +816,8 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 		if (memcpy_toiovecend(iv, (void *)&vnet_hdr, 0, sizeof(vnet_hdr)))
 			return -EFAULT;
 	}
-	copied = vnet_hdr_len;
+	total = copied = vnet_hdr_len;
+	total += skb->len;
 
 	if (!vlan_tx_tag_present(skb))
 		len = min_t(int, skb->len, len);
@@ -832,6 +832,7 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 
 		vlan_offset = offsetof(struct vlan_ethhdr, h_vlan_proto);
 		len = min_t(int, skb->len + VLAN_HLEN, len);
+		total += VLAN_HLEN;
 
 		copy = min_t(int, vlan_offset, len);
 		ret = skb_copy_datagram_const_iovec(skb, 0, iv, copied, copy);
@@ -849,16 +850,9 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 	}
 
 	ret = skb_copy_datagram_const_iovec(skb, vlan_offset, iv, copied, len);
-	copied += len;
 
 done:
-	rcu_read_lock_bh();
-	vlan = rcu_dereference_bh(q->vlan);
-	if (vlan)
-		macvlan_count_rx(vlan, copied - vnet_hdr_len, ret == 0, 0);
-	rcu_read_unlock_bh();
-
-	return ret ? ret : copied;
+	return ret ? ret : total;
 }
 
 static ssize_t macvtap_do_read(struct macvtap_queue *q, struct kiocb *iocb,
@@ -912,7 +906,9 @@ static ssize_t macvtap_aio_read(struct kiocb *iocb, const struct iovec *iv,
 	}
 
 	ret = macvtap_do_read(q, iocb, iv, len, file->f_flags & O_NONBLOCK);
-	ret = min_t(ssize_t, ret, len); /* XXX copied from tun.c. Why? */
+	ret = min_t(ssize_t, ret, len);
+	if (ret > 0)
+		iocb->ki_pos = ret;
 out:
 	return ret;
 }
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index f21bcef..8e5e73b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -903,6 +903,8 @@ static ssize_t tun_chr_aio_read(struct kiocb *iocb, const struct iovec *iv,
 
 	ret = tun_do_read(tun, iocb, iv, len, file->f_flags & O_NONBLOCK);
 	ret = min_t(ssize_t, ret, len);
+	if (ret > 0)
+		iocb->ki_pos = ret;
 out:
 	tun_put(tun);
 	return ret;
diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
index e55db3a..65ec48a 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -445,7 +445,12 @@ static int dm9601_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->ethtool_ops = &dm9601_ethtool_ops;
 	dev->net->hard_header_len += DM_TX_OVERHEAD;
 	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
-	dev->rx_urb_size = dev->net->mtu + ETH_HLEN + DM_RX_OVERHEAD;
+
+	/* dm9620/21a require room for 4 byte padding, even in dm9601
+	 * mode, so we need +1 to be able to receive full size
+	 * ethernet frames.
+	 */
+	dev->rx_urb_size = dev->net->mtu + ETH_HLEN + DM_RX_OVERHEAD + 1;
 
 	dev->mii.dev = dev->net;
 	dev->mii.mdio_read = dm9601_mdio_read;
@@ -531,7 +536,7 @@ static int dm9601_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 static struct sk_buff *dm9601_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 				       gfp_t flags)
 {
-	int len;
+	int len, pad;
 
 	/* format:
 	   b1: packet length low
@@ -539,12 +544,23 @@ static struct sk_buff *dm9601_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 	   b3..n: packet data
 	*/
 
-	len = skb->len;
+	len = skb->len + DM_TX_OVERHEAD;
 
-	if (skb_headroom(skb) < DM_TX_OVERHEAD) {
+	/* workaround for dm962x errata with tx fifo getting out of
+	 * sync if a USB bulk transfer retry happens right after a
+	 * packet with odd / maxpacket length by adding up to 3 bytes
+	 * padding.
+	 */
+	while ((len & 1) || !(len % dev->maxpacket))
+		len++;
+
+	len -= DM_TX_OVERHEAD; /* hw header doesn't count as part of length */
+	pad = len - skb->len;
+
+	if (skb_headroom(skb) < DM_TX_OVERHEAD || skb_tailroom(skb) < pad) {
 		struct sk_buff *skb2;
 
-		skb2 = skb_copy_expand(skb, DM_TX_OVERHEAD, 0, flags);
+		skb2 = skb_copy_expand(skb, DM_TX_OVERHEAD, pad, flags);
 		dev_kfree_skb_any(skb);
 		skb = skb2;
 		if (!skb)
@@ -553,10 +569,10 @@ static struct sk_buff *dm9601_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 
 	__skb_push(skb, DM_TX_OVERHEAD);
 
-	/* usbnet adds padding if length is a multiple of packet size
-	   if so, adjust length value in header */
-	if ((skb->len % dev->maxpacket) == 0)
-		len++;
+	if (pad) {
+		memset(skb->data + skb->len, 0, pad);
+		__skb_put(skb, pad);
+	}
 
 	skb->data[0] = len;
 	skb->data[1] = len >> 8;
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 8d78253..a366d6b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -76,9 +76,16 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 				mask2 |= ATH9K_INT_CST;
 			if (isr2 & AR_ISR_S2_TSFOOR)
 				mask2 |= ATH9K_INT_TSFOOR;
+
+			if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
+				REG_WRITE(ah, AR_ISR_S2, isr2);
+				isr &= ~AR_ISR_BCNMISC;
+			}
 		}
 
-		isr = REG_READ(ah, AR_ISR_RAC);
+		if (pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)
+			isr = REG_READ(ah, AR_ISR_RAC);
+
 		if (isr == 0xffffffff) {
 			*masked = 0;
 			return false;
@@ -97,11 +104,23 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 
 			*masked |= ATH9K_INT_TX;
 
-			s0_s = REG_READ(ah, AR_ISR_S0_S);
+			if (pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED) {
+				s0_s = REG_READ(ah, AR_ISR_S0_S);
+				s1_s = REG_READ(ah, AR_ISR_S1_S);
+			} else {
+				s0_s = REG_READ(ah, AR_ISR_S0);
+				REG_WRITE(ah, AR_ISR_S0, s0_s);
+				s1_s = REG_READ(ah, AR_ISR_S1);
+				REG_WRITE(ah, AR_ISR_S1, s1_s);
+
+				isr &= ~(AR_ISR_TXOK |
+					 AR_ISR_TXDESC |
+					 AR_ISR_TXERR |
+					 AR_ISR_TXEOL);
+			}
+
 			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXOK);
 			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXDESC);
-
-			s1_s = REG_READ(ah, AR_ISR_S1_S);
 			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXERR);
 			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXEOL);
 		}
@@ -114,13 +133,15 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 		*masked |= mask2;
 	}
 
-	if (AR_SREV_9100(ah))
-		return true;
-
-	if (isr & AR_ISR_GENTMR) {
+	if (!AR_SREV_9100(ah) && (isr & AR_ISR_GENTMR)) {
 		u32 s5_s;
 
-		s5_s = REG_READ(ah, AR_ISR_S5_S);
+		if (pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED) {
+			s5_s = REG_READ(ah, AR_ISR_S5_S);
+		} else {
+			s5_s = REG_READ(ah, AR_ISR_S5);
+		}
+
 		ah->intr_gen_timer_trigger =
 				MS(s5_s, AR_ISR_S5_GENTIMER_TRIG);
 
@@ -133,8 +154,21 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 		if ((s5_s & AR_ISR_S5_TIM_TIMER) &&
 		    !(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
 			*masked |= ATH9K_INT_TIM_TIMER;
+
+		if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
+			REG_WRITE(ah, AR_ISR_S5, s5_s);
+			isr &= ~AR_ISR_GENTMR;
+		}
 	}
 
+	if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
+		REG_WRITE(ah, AR_ISR, isr);
+		REG_READ(ah, AR_ISR);
+	}
+
+	if (AR_SREV_9100(ah))
+		return true;
+
 	if (sync_cause) {
 		ath9k_debug_sync_cause(common, sync_cause);
 		fatal_int =
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index abbd6ef..204619e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -139,21 +139,26 @@ static void ath9k_htc_bssid_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	struct ath9k_vif_iter_data *iter_data = data;
 	int i;
 
-	for (i = 0; i < ETH_ALEN; i++)
-		iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
+	if (iter_data->hw_macaddr != NULL) {
+		for (i = 0; i < ETH_ALEN; i++)
+			iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
+	} else {
+		iter_data->hw_macaddr = mac;
+	}
 }
 
-static void ath9k_htc_set_bssid_mask(struct ath9k_htc_priv *priv,
+static void ath9k_htc_set_mac_bssid_mask(struct ath9k_htc_priv *priv,
 				     struct ieee80211_vif *vif)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath9k_vif_iter_data iter_data;
 
 	/*
-	 * Use the hardware MAC address as reference, the hardware uses it
-	 * together with the BSSID mask when matching addresses.
+	 * Pick the MAC address of the first interface as the new hardware
+	 * MAC address. The hardware will use it together with the BSSID mask
+	 * when matching addresses.
 	 */
-	iter_data.hw_macaddr = common->macaddr;
+	iter_data.hw_macaddr = NULL;
 	memset(&iter_data.mask, 0xff, ETH_ALEN);
 
 	if (vif)
@@ -164,6 +169,10 @@ static void ath9k_htc_set_bssid_mask(struct ath9k_htc_priv *priv,
 						   &iter_data);
 
 	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
+
+	if (iter_data.hw_macaddr)
+		memcpy(common->macaddr, iter_data.hw_macaddr, ETH_ALEN);
+
 	ath_hw_setbssidmask(common);
 }
 
@@ -1091,7 +1100,7 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	ath9k_htc_set_bssid_mask(priv, vif);
+	ath9k_htc_set_mac_bssid_mask(priv, vif);
 
 	priv->vif_slot |= (1 << avp->index);
 	priv->nvifs++;
@@ -1154,7 +1163,7 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 
 	ath9k_htc_set_opmode(priv);
 
-	ath9k_htc_set_bssid_mask(priv, vif);
+	ath9k_htc_set_mac_bssid_mask(priv, vif);
 
 	/*
 	 * Stop ANI only if there are no associated station interfaces.
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 278ce3d..2b9207e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1297,8 +1297,9 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	/*
-	 * Use the hardware MAC address as reference, the hardware uses it
-	 * together with the BSSID mask when matching addresses.
+	 * Pick the MAC address of the first interface as the new hardware
+	 * MAC address. The hardware will use it together with the BSSID mask
+	 * when matching addresses.
 	 */
 	memset(iter_data, 0, sizeof(*iter_data));
 	iter_data->hw_macaddr = common->macaddr;
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 2062ea1..4c4226f 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -679,6 +679,8 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 	};
 	int index = rtlpci->rx_ring[rx_queue_idx].idx;
 
+	if (rtlpci->driver_is_goingto_unload)
+		return;
 	/*RX NORMAL PKT */
 	while (count--) {
 		/*rx descriptor */
@@ -1555,6 +1557,7 @@ static void rtl_pci_stop(struct ieee80211_hw *hw)
 	 */
 	set_hal_stop(rtlhal);
 
+	rtlpci->driver_is_goingto_unload = true;
 	rtlpriv->cfg->ops->disable_interrupt(hw);
 	cancel_work_sync(&rtlpriv->works.lps_leave_work);
 
@@ -1572,7 +1575,6 @@ static void rtl_pci_stop(struct ieee80211_hw *hw)
 	ppsc->rfchange_inprogress = true;
 	spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flags);
 
-	rtlpci->driver_is_goingto_unload = true;
 	rtlpriv->cfg->ops->hw_disable(hw);
 	/* some things are not needed if firmware not available */
 	if (!rtlpriv->max_fw_size)
diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 623381d..d49c873 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -914,12 +914,13 @@ static void pcmuio_detach(struct comedi_device *dev)
 
 	if (dev->iobase)
 		release_region(dev->iobase, ASIC_IOSIZE * thisboard->num_asics);
-	for (i = 0; i < MAX_ASICS; ++i) {
-		if (devpriv->asics[i].irq)
-			free_irq(devpriv->asics[i].irq, dev);
-	}
-	if (devpriv && devpriv->sprivs)
+	if (devpriv) {
+		for (i = 0; i < MAX_ASICS; ++i) {
+			if (devpriv->asics[i].irq)
+				free_irq(devpriv->asics[i].irq, dev);
+		}
 		kfree(devpriv->sprivs);
+	}
 }
 
 static const struct pcmuio_board pcmuio_boards[] = {
diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index 16c4f5a..7f8a37e 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -111,11 +111,11 @@ static int dnp_dio_insn_bits(struct comedi_device *dev,
 
 	/* on return, data[1] contains the value of the digital input lines. */
 	outb(PADR, CSCIR);
-	data[0] = inb(CSCDR);
+	data[1] = inb(CSCDR);
 	outb(PBDR, CSCIR);
-	data[0] += inb(CSCDR) << 8;
+	data[1] += inb(CSCDR) << 8;
 	outb(PCDR, CSCIR);
-	data[0] += ((inb(CSCDR) & 0xF0) << 12);
+	data[1] += ((inb(CSCDR) & 0xF0) << 12);
 
 	return 2;
 
diff --git a/drivers/staging/iio/adc/ad7887_core.c b/drivers/staging/iio/adc/ad7887_core.c
index 7186074..2b7fc8b 100644
--- a/drivers/staging/iio/adc/ad7887_core.c
+++ b/drivers/staging/iio/adc/ad7887_core.c
@@ -79,7 +79,13 @@ static const struct ad7887_chip_info ad7887_chip_info_tbl[] = {
 			IIO_CHAN_INFO_SCALE_SHARED_BIT,
 			.address = 1,
 			.scan_index = 1,
-			.scan_type = IIO_ST('u', 12, 16, 0),
+			.scan_type = {
+				.sign = 'u',
+				.realbits = 12,
+				.storagebits = 16,
+				.shift = 0,
+				.endianness = IIO_BE,
+			},
 		},
 		.channel[1] = {
 			.type = IIO_VOLTAGE,
@@ -89,7 +95,13 @@ static const struct ad7887_chip_info ad7887_chip_info_tbl[] = {
 			IIO_CHAN_INFO_SCALE_SHARED_BIT,
 			.address = 0,
 			.scan_index = 0,
-			.scan_type = IIO_ST('u', 12, 16, 0),
+			.scan_type = {
+				.sign = 'u',
+				.realbits = 12,
+				.storagebits = 16,
+				.shift = 0,
+				.endianness = IIO_BE,
+			},
 		},
 		.channel[2] = IIO_CHAN_SOFT_TIMESTAMP(2),
 		.int_vref_mv = 2500,
diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index dbe8907..aafcf03 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -95,20 +95,27 @@ static ssize_t reset_store(struct device *dev,
 	zram = dev_to_zram(dev);
 	bdev = bdget_disk(zram->disk, 0);
 
+	if (!bdev)
+		return -ENOMEM;
+
 	/* Do not reset an active device! */
-	if (bdev->bd_holders)
-		return -EBUSY;
+	if (bdev->bd_holders) {
+		ret = -EBUSY;
+		goto out;
+	}
 
 	ret = kstrtou16(buf, 10, &do_reset);
 	if (ret)
-		return ret;
+		goto out;
 
-	if (!do_reset)
-		return -EINVAL;
+	if (!do_reset) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	/* Make sure all pending I/O is finished */
-	if (bdev)
-		fsync_bdev(bdev);
+	fsync_bdev(bdev);
+	bdput(bdev);
 
 	down_write(&zram->init_lock);
 	if (zram->init_done)
@@ -116,6 +123,10 @@ static ssize_t reset_store(struct device *dev,
 	up_write(&zram->init_lock);
 
 	return len;
+
+out:
+	bdput(bdev);
+	return ret;
 }
 
 static ssize_t num_reads_show(struct device *dev,
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 3e7ac0c..955392e 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -803,24 +803,22 @@ static int iscsit_handle_scsi_cmd(
 	if (((hdr->flags & ISCSI_FLAG_CMD_READ) ||
 	     (hdr->flags & ISCSI_FLAG_CMD_WRITE)) && !hdr->data_length) {
 		/*
-		 * Vmware ESX v3.0 uses a modified Cisco Initiator (v3.4.2)
-		 * that adds support for RESERVE/RELEASE.  There is a bug
-		 * add with this new functionality that sets R/W bits when
-		 * neither CDB carries any READ or WRITE datapayloads.
+		 * From RFC-3720 Section 10.3.1:
+		 *
+		 * "Either or both of R and W MAY be 1 when either the
+		 *  Expected Data Transfer Length and/or Bidirectional Read
+		 *  Expected Data Transfer Length are 0"
+		 *
+		 * For this case, go ahead and clear the unnecssary bits
+		 * to avoid any confusion with ->data_direction.
 		 */
-		if ((hdr->cdb[0] == 0x16) || (hdr->cdb[0] == 0x17)) {
-			hdr->flags &= ~ISCSI_FLAG_CMD_READ;
-			hdr->flags &= ~ISCSI_FLAG_CMD_WRITE;
-			goto done;
-		}
+		hdr->flags &= ~ISCSI_FLAG_CMD_READ;
+		hdr->flags &= ~ISCSI_FLAG_CMD_WRITE;
 
-		pr_err("ISCSI_FLAG_CMD_READ or ISCSI_FLAG_CMD_WRITE"
+		pr_warn("ISCSI_FLAG_CMD_READ or ISCSI_FLAG_CMD_WRITE"
 			" set when Expected Data Transfer Length is 0 for"
-			" CDB: 0x%02x. Bad iSCSI Initiator.\n", hdr->cdb[0]);
-		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
-				buf, conn);
+			" CDB: 0x%02x, Fixing up flags\n", hdr->cdb[0]);
 	}
-done:
 
 	if (!(hdr->flags & ISCSI_FLAG_CMD_READ) &&
 	    !(hdr->flags & ISCSI_FLAG_CMD_WRITE) && (hdr->data_length != 0)) {
diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index 333c8d0..3f93c47 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -2051,6 +2051,9 @@ static int __init pmz_console_init(void)
 	/* Probe ports */
 	pmz_probe();
 
+	if (pmz_ports_count == 0)
+		return -ENODEV;
+
 	/* TODO: Autoprobe console based on OF */
 	/* pmz_console.index = i; */
 	register_console(&pmz_console);
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 7c25710..e13be3d 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -826,13 +826,11 @@ static int wdm_manage_power(struct usb_interface *intf, int on)
 {
 	/* need autopm_get/put here to ensure the usbcore sees the new value */
 	int rv = usb_autopm_get_interface(intf);
-	if (rv < 0)
-		goto err;
 
 	intf->needs_remote_wakeup = on;
-	usb_autopm_put_interface(intf);
-err:
-	return rv;
+	if (!rv)
+		usb_autopm_put_interface(intf);
+	return 0;
 }
 
 static int wdm_probe(struct usb_interface *intf, const struct usb_device_id *id)
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 085d018..a8c59c1 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -125,7 +125,12 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		 * any other sleep) on Haswell machines with LPT and LPT-LP
 		 * with the new Intel BIOS
 		 */
-		xhci->quirks |= XHCI_SPURIOUS_WAKEUP;
+		/* Limit the quirk to only known vendors, as this triggers
+		 * yet another BIOS bug on some other machines
+		 * https://bugzilla.kernel.org/show_bug.cgi?id=66171
+		 */
+		if (pdev->subsystem_vendor == PCI_VENDOR_ID_HP)
+			xhci->quirks |= XHCI_SPURIOUS_WAKEUP;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
 			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
diff --git a/drivers/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
index 3fb83b0..ab6d3f5 100644
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -409,8 +409,9 @@ static int __init sc1200wdt_init(void)
 #if defined CONFIG_PNP
 	/* now that the user has specified an IO port and we haven't detected
 	 * any devices, disable pnp support */
+	if (isapnp)
+		pnp_unregister_driver(&scl200wdt_pnp_driver);
 	isapnp = 0;
-	pnp_unregister_driver(&scl200wdt_pnp_driver);
 #endif
 
 	if (!request_region(io, io_len, SC1200_MODULE_NAME)) {
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 32ee086..95f0bef 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -213,9 +213,13 @@ static int readpage_nounlock(struct file *filp, struct page *page)
 	if (err < 0) {
 		SetPageError(page);
 		goto out;
-	} else if (err < PAGE_CACHE_SIZE) {
+	} else {
+		if (err < PAGE_CACHE_SIZE) {
 		/* zero fill remainder of page */
-		zero_user_segment(page, err, PAGE_CACHE_SIZE);
+			zero_user_segment(page, err, PAGE_CACHE_SIZE);
+		} else {
+			flush_dcache_page(page);
+		}
 	}
 	SetPageUptodate(page);
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0b26ea8..35ee099 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -609,6 +609,8 @@ static void __unregister_request(struct ceph_mds_client *mdsc,
 		req->r_unsafe_dir = NULL;
 	}
 
+	complete_all(&req->r_safe_completion);
+
 	ceph_mdsc_put_request(req);
 }
 
@@ -1815,8 +1817,11 @@ static int __do_request(struct ceph_mds_client *mdsc,
 	int mds = -1;
 	int err = -EAGAIN;
 
-	if (req->r_err || req->r_got_result)
+	if (req->r_err || req->r_got_result) {
+		if (req->r_aborted)
+			__unregister_request(mdsc, req);
 		goto out;
+	}
 
 	if (req->r_timeout &&
 	    time_after_eq(jiffies, req->r_started + req->r_timeout)) {
@@ -2124,7 +2129,6 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	if (head->safe) {
 		req->r_got_safe = true;
 		__unregister_request(mdsc, req);
-		complete_all(&req->r_safe_completion);
 
 		if (req->r_got_unsafe) {
 			/*
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index b3621cb..74f4688 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1449,6 +1449,7 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
 				sb->s_blocksize - offset : towrite;
 
 		tmp_bh.b_state = 0;
+		tmp_bh.b_size = sb->s_blocksize;
 		err = ext2_get_block(inode, blk, &tmp_bh, 1);
 		if (err < 0)
 			goto out;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d929a80..6a83398 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -286,6 +286,16 @@ struct ext4_io_submit {
 /* Translate # of blks to # of clusters */
 #define EXT4_NUM_B2C(sbi, blks)	(((blks) + (sbi)->s_cluster_ratio - 1) >> \
 				 (sbi)->s_cluster_bits)
+/* Mask out the low bits to get the starting block of the cluster */
+#define EXT4_PBLK_CMASK(s, pblk) ((pblk) &				\
+				  ~((ext4_fsblk_t) (s)->s_cluster_ratio - 1))
+#define EXT4_LBLK_CMASK(s, lblk) ((lblk) &				\
+				  ~((ext4_lblk_t) (s)->s_cluster_ratio - 1))
+/* Get the cluster offset */
+#define EXT4_PBLK_COFF(s, pblk) ((pblk) &				\
+				 ((ext4_fsblk_t) (s)->s_cluster_ratio - 1))
+#define EXT4_LBLK_COFF(s, lblk) ((lblk) &				\
+				 ((ext4_lblk_t) (s)->s_cluster_ratio - 1))
 
 /*
  * Structure of a blocks group descriptor
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 177f655..73de30a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -358,8 +358,10 @@ static int ext4_valid_extent(struct inode *inode, struct ext4_extent *ext)
 {
 	ext4_fsblk_t block = ext4_ext_pblock(ext);
 	int len = ext4_ext_get_actual_len(ext);
+	ext4_lblk_t lblock = le32_to_cpu(ext->ee_block);
+	ext4_lblk_t last = lblock + len - 1;
 
-	if (len == 0)
+	if (lblock > last)
 		return 0;
 	return ext4_data_block_valid(EXT4_SB(inode->i_sb), block, len);
 }
@@ -385,11 +387,26 @@ static int ext4_valid_extent_entries(struct inode *inode,
 	if (depth == 0) {
 		/* leaf entries */
 		struct ext4_extent *ext = EXT_FIRST_EXTENT(eh);
+		struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
+		ext4_fsblk_t pblock = 0;
+		ext4_lblk_t lblock = 0;
+		ext4_lblk_t prev = 0;
+		int len = 0;
 		while (entries) {
 			if (!ext4_valid_extent(inode, ext))
 				return 0;
+
+			/* Check for overlapping extents */
+			lblock = le32_to_cpu(ext->ee_block);
+			len = ext4_ext_get_actual_len(ext);
+			if ((lblock <= prev) && prev) {
+				pblock = ext4_ext_pblock(ext);
+				es->s_last_error_block = cpu_to_le64(pblock);
+				return 0;
+			}
 			ext++;
 			entries--;
+			prev = lblock + len - 1;
 		}
 	} else {
 		struct ext4_extent_idx *ext_idx = EXT_FIRST_INDEX(eh);
@@ -1708,8 +1725,7 @@ static unsigned int ext4_ext_check_overlap(struct ext4_sb_info *sbi,
 	depth = ext_depth(inode);
 	if (!path[depth].p_ext)
 		goto out;
-	b2 = le32_to_cpu(path[depth].p_ext->ee_block);
-	b2 &= ~(sbi->s_cluster_ratio - 1);
+	b2 = EXT4_LBLK_CMASK(sbi, le32_to_cpu(path[depth].p_ext->ee_block));
 
 	/*
 	 * get the next allocated block if the extent in the path
@@ -1719,7 +1735,7 @@ static unsigned int ext4_ext_check_overlap(struct ext4_sb_info *sbi,
 		b2 = ext4_ext_next_allocated_block(path);
 		if (b2 == EXT_MAX_BLOCKS)
 			goto out;
-		b2 &= ~(sbi->s_cluster_ratio - 1);
+		b2 = EXT4_LBLK_CMASK(sbi, b2);
 	}
 
 	/* check for wrap through zero on extent logical start block*/
@@ -2354,7 +2370,7 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 		 * truncate operation has removed all of the blocks in
 		 * the cluster.
 		 */
-		if (pblk & (sbi->s_cluster_ratio - 1) &&
+		if (EXT4_PBLK_COFF(sbi, pblk) &&
 		    (ee_len == num))
 			*partial_cluster = EXT4_B2C(sbi, pblk);
 		else
@@ -3566,7 +3582,7 @@ int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk,
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_lblk_t lblk_start, lblk_end;
-	lblk_start = lblk & (~(sbi->s_cluster_ratio - 1));
+	lblk_start = EXT4_LBLK_CMASK(sbi, lblk);
 	lblk_end = lblk_start + sbi->s_cluster_ratio - 1;
 
 	return ext4_find_delalloc_range(inode, lblk_start, lblk_end,
@@ -3626,9 +3642,9 @@ get_reserved_cluster_alloc(struct inode *inode, ext4_lblk_t lblk_start,
 	trace_ext4_get_reserved_cluster_alloc(inode, lblk_start, num_blks);
 
 	/* Check towards left side */
-	c_offset = lblk_start & (sbi->s_cluster_ratio - 1);
+	c_offset = EXT4_LBLK_COFF(sbi, lblk_start);
 	if (c_offset) {
-		lblk_from = lblk_start & (~(sbi->s_cluster_ratio - 1));
+		lblk_from = EXT4_LBLK_CMASK(sbi, lblk_start);
 		lblk_to = lblk_from + c_offset - 1;
 
 		if (ext4_find_delalloc_range(inode, lblk_from, lblk_to, 0))
@@ -3636,7 +3652,7 @@ get_reserved_cluster_alloc(struct inode *inode, ext4_lblk_t lblk_start,
 	}
 
 	/* Now check towards right. */
-	c_offset = (lblk_start + num_blks) & (sbi->s_cluster_ratio - 1);
+	c_offset = EXT4_LBLK_COFF(sbi, lblk_start + num_blks);
 	if (allocated_clusters && c_offset) {
 		lblk_from = lblk_start + num_blks;
 		lblk_to = lblk_from + (sbi->s_cluster_ratio - c_offset) - 1;
@@ -3829,7 +3845,7 @@ static int get_implied_cluster_alloc(struct super_block *sb,
 				     struct ext4_ext_path *path)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	ext4_lblk_t c_offset = map->m_lblk & (sbi->s_cluster_ratio-1);
+	ext4_lblk_t c_offset = EXT4_LBLK_COFF(sbi, map->m_lblk);
 	ext4_lblk_t ex_cluster_start, ex_cluster_end;
 	ext4_lblk_t rr_cluster_start;
 	ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
@@ -3847,8 +3863,7 @@ static int get_implied_cluster_alloc(struct super_block *sb,
 	    (rr_cluster_start == ex_cluster_start)) {
 		if (rr_cluster_start == ex_cluster_end)
 			ee_start += ee_len - 1;
-		map->m_pblk = (ee_start & ~(sbi->s_cluster_ratio - 1)) +
-			c_offset;
+		map->m_pblk = EXT4_PBLK_CMASK(sbi, ee_start) + c_offset;
 		map->m_len = min(map->m_len,
 				 (unsigned) sbi->s_cluster_ratio - c_offset);
 		/*
@@ -4035,7 +4050,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	 */
 	map->m_flags &= ~EXT4_MAP_FROM_CLUSTER;
 	newex.ee_block = cpu_to_le32(map->m_lblk);
-	cluster_offset = map->m_lblk & (sbi->s_cluster_ratio-1);
+	cluster_offset = EXT4_LBLK_CMASK(sbi, map->m_lblk);
 
 	/*
 	 * If we are doing bigalloc, check to see if the extent returned
@@ -4103,7 +4118,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	 * needed so that future calls to get_implied_cluster_alloc()
 	 * work correctly.
 	 */
-	offset = map->m_lblk & (sbi->s_cluster_ratio - 1);
+	offset = EXT4_LBLK_COFF(sbi, map->m_lblk);
 	ar.len = EXT4_NUM_B2C(sbi, offset+allocated);
 	ar.goal -= offset;
 	ar.logical -= offset;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index aaece99..6f6926a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3323,6 +3323,9 @@ static void ext4_mb_pa_callback(struct rcu_head *head)
 {
 	struct ext4_prealloc_space *pa;
 	pa = container_of(head, struct ext4_prealloc_space, u.pa_rcu);
+
+	BUG_ON(atomic_read(&pa->pa_count));
+	BUG_ON(pa->pa_deleted == 0);
 	kmem_cache_free(ext4_pspace_cachep, pa);
 }
 
@@ -3336,11 +3339,13 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 	ext4_group_t grp;
 	ext4_fsblk_t grp_blk;
 
-	if (!atomic_dec_and_test(&pa->pa_count) || pa->pa_free != 0)
-		return;
-
 	/* in this short window concurrent discard can set pa_deleted */
 	spin_lock(&pa->pa_lock);
+	if (!atomic_dec_and_test(&pa->pa_count) || pa->pa_free != 0) {
+		spin_unlock(&pa->pa_lock);
+		return;
+	}
+
 	if (pa->pa_deleted == 1) {
 		spin_unlock(&pa->pa_lock);
 		return;
@@ -4007,7 +4012,7 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 
 	/* set up allocation goals */
 	memset(ac, 0, sizeof(struct ext4_allocation_context));
-	ac->ac_b_ex.fe_logical = ar->logical & ~(sbi->s_cluster_ratio - 1);
+	ac->ac_b_ex.fe_logical = EXT4_LBLK_CMASK(sbi, ar->logical);
 	ac->ac_status = AC_STATUS_CONTINUE;
 	ac->ac_sb = sb;
 	ac->ac_inode = ar->inode;
@@ -4540,7 +4545,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	 * blocks at the beginning or the end unless we are explicitly
 	 * requested to avoid doing so.
 	 */
-	overflow = block & (sbi->s_cluster_ratio - 1);
+	overflow = EXT4_PBLK_COFF(sbi, block);
 	if (overflow) {
 		if (flags & EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER) {
 			overflow = sbi->s_cluster_ratio - overflow;
@@ -4554,7 +4559,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 			count += overflow;
 		}
 	}
-	overflow = count & (sbi->s_cluster_ratio - 1);
+	overflow = EXT4_LBLK_COFF(sbi, count);
 	if (overflow) {
 		if (flags & EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER) {
 			if (count > overflow)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0581e45..b2ae1e8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -890,7 +890,7 @@ static void ext4_put_super(struct super_block *sb)
 			ext4_abort(sb, "Couldn't clean up the journal");
 	}
 
-	del_timer(&sbi->s_err_report);
+	del_timer_sync(&sbi->s_err_report);
 	ext4_release_system_zone(sb);
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);
@@ -3999,7 +3999,7 @@ failed_mount_wq:
 		sbi->s_journal = NULL;
 	}
 failed_mount3:
-	del_timer(&sbi->s_err_report);
+	del_timer_sync(&sbi->s_err_report);
 	if (sbi->s_flex_groups)
 		ext4_kvfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeclusters_counter);
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index e80a464..0111060 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1011,6 +1011,7 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
+	struct address_space *mapping = inode->i_mapping;
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_holder gh;
 	int rv;
@@ -1031,6 +1032,35 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 	if (rv != 1)
 		goto out; /* dio not valid, fall back to buffered i/o */
 
+	/*
+	 * Now since we are holding a deferred (CW) lock at this point, you
+	 * might be wondering why this is ever needed. There is a case however
+	 * where we've granted a deferred local lock against a cached exclusive
+	 * glock. That is ok provided all granted local locks are deferred, but
+	 * it also means that it is possible to encounter pages which are
+	 * cached and possibly also mapped. So here we check for that and sort
+	 * them out ahead of the dio. The glock state machine will take care of
+	 * everything else.
+	 *
+	 * If in fact the cached glock state (gl->gl_state) is deferred (CW) in
+	 * the first place, mapping->nr_pages will always be zero.
+	 */
+	if (mapping->nrpages) {
+		loff_t lstart = offset & (PAGE_CACHE_SIZE - 1);
+		loff_t len = iov_length(iov, nr_segs);
+		loff_t end = PAGE_ALIGN(offset + len) - 1;
+
+		rv = 0;
+		if (len == 0)
+			goto out;
+		if (test_and_clear_bit(GIF_SW_PAGED, &ip->i_flags))
+			unmap_shared_mapping_range(ip->i_inode.i_mapping, offset, len);
+		rv = filemap_write_and_wait_range(mapping, lstart, end);
+		if (rv)
+			return rv;
+		truncate_inode_pages_range(mapping, lstart, end);
+	}
+
 	rv = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
 				  offset, nr_segs, gfs2_get_block_direct,
 				  NULL, NULL, 0);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index b8c250f..0e690dc 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1292,8 +1292,18 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
 	if (IS_ERR(s))
 		goto error_bdev;
 
-	if (s->s_root)
+	if (s->s_root) {
+		/*
+		 * s_umount nests inside bd_mutex during
+		 * __invalidate_device().  blkdev_put() acquires
+		 * bd_mutex and can't be called under s_umount.  Drop
+		 * s_umount temporarily.  This is safe as we're
+		 * holding an active reference.
+		 */
+		up_write(&s->s_umount);
 		blkdev_put(bdev, mode);
+		down_write(&s->s_umount);
+	}
 
 	memset(&args, 0, sizeof(args));
 	args.ar_quota = GFS2_QUOTA_DEFAULT;
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 81203d1..edfb1ec 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1126,7 +1126,10 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 		 * once a transaction -bzzz
 		 */
 		jh->b_modified = 1;
-		J_ASSERT_JH(jh, handle->h_buffer_credits > 0);
+		if (handle->h_buffer_credits <= 0) {
+			ret = -ENOSPC;
+			goto out_unlock_bh;
+		}
 		handle->h_buffer_credits--;
 	}
 
@@ -1209,7 +1212,6 @@ out_unlock_bh:
 	jbd2_journal_put_journal_head(jh);
 out:
 	JBUFFER_TRACE(jh, "exit");
-	WARN_ON(ret);	/* All errors are bugs, so dump the stack */
 	return ret;
 }
 
diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index 56650b7..0522998 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -540,7 +540,7 @@
 	{0x1002, 0x9645, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO2|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x9647, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
 	{0x1002, 0x9648, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
-	{0x1002, 0x9649, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
+	{0x1002, 0x9649, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO2|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
 	{0x1002, 0x964a, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x964b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x964c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
diff --git a/include/linux/net.h b/include/linux/net.h
index f150cdf..2ece444 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -215,7 +215,7 @@ struct proto_ops {
 				      int offset, size_t size, int flags);
 	ssize_t 	(*splice_read)(struct socket *sock,  loff_t *ppos,
 				       struct pipe_inode_info *pipe, size_t len, unsigned int flags);
-	void		(*set_peek_off)(struct sock *sk, int val);
+	int		(*set_peek_off)(struct sock *sk, int val);
 };
 
 #define DECLARE_SOCKADDR(type, dst, src)	\
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 735cb59..e80df17 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1726,6 +1726,15 @@ static inline int dev_parse_header(const struct sk_buff *skb,
 	return dev->header_ops->parse(skb, haddr);
 }
 
+static inline int dev_rebuild_header(struct sk_buff *skb)
+{
+	const struct net_device *dev = skb->dev;
+
+	if (!dev->header_ops || !dev->header_ops->rebuild)
+		return 0;
+	return dev->header_ops->rebuild(skb);
+}
+
 typedef int gifconf_func_t(struct net_device * dev, char __user * bufptr, int len);
 extern int		register_gifconf(unsigned int family, gifconf_func_t * gifconf);
 static inline int unregister_gifconf(unsigned int family)
diff --git a/kernel/freezer.c b/kernel/freezer.c
index 11f82a4..be34be8 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -19,6 +19,12 @@ EXPORT_SYMBOL(system_freezing_cnt);
 bool pm_freezing;
 bool pm_nosig_freezing;
 
+/*
+ * Temporary export for the deadlock workaround in ata_scsi_hotplug().
+ * Remove once the hack becomes unnecessary.
+ */
+EXPORT_SYMBOL_GPL(pm_freezing);
+
 /* protects freezing and frozen transitions */
 static DEFINE_SPINLOCK(freezer_lock);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 89e8c2c..281f186 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8084,7 +8084,12 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 
 	runtime_enabled = quota != RUNTIME_INF;
 	runtime_was_enabled = cfs_b->quota != RUNTIME_INF;
-	account_cfs_bandwidth_used(runtime_enabled, runtime_was_enabled);
+	/*
+	 * If we need to toggle cfs_bandwidth_used, off->on must occur
+	 * before making related changes, and on->off must occur afterwards
+	 */
+	if (runtime_enabled && !runtime_was_enabled)
+		cfs_bandwidth_usage_inc();
 	raw_spin_lock_irq(&cfs_b->lock);
 	cfs_b->period = ns_to_ktime(period);
 	cfs_b->quota = quota;
@@ -8110,6 +8115,8 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 			unthrottle_cfs_rq(cfs_rq);
 		raw_spin_unlock_irq(&rq->lock);
 	}
+	if (runtime_was_enabled && !runtime_enabled)
+		cfs_bandwidth_usage_dec();
 out_unlock:
 	mutex_unlock(&cfs_constraints_mutex);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 97ecdafd..9e2fe1b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1393,13 +1393,14 @@ static inline bool cfs_bandwidth_used(void)
 	return static_key_false(&__cfs_bandwidth_used);
 }
 
-void account_cfs_bandwidth_used(int enabled, int was_enabled)
+void cfs_bandwidth_usage_inc(void)
 {
-	/* only need to count groups transitioning between enabled/!enabled */
-	if (enabled && !was_enabled)
-		static_key_slow_inc(&__cfs_bandwidth_used);
-	else if (!enabled && was_enabled)
-		static_key_slow_dec(&__cfs_bandwidth_used);
+	static_key_slow_inc(&__cfs_bandwidth_used);
+}
+
+void cfs_bandwidth_usage_dec(void)
+{
+	static_key_slow_dec(&__cfs_bandwidth_used);
 }
 #else /* HAVE_JUMP_LABEL */
 static bool cfs_bandwidth_used(void)
@@ -1407,7 +1408,8 @@ static bool cfs_bandwidth_used(void)
 	return true;
 }
 
-void account_cfs_bandwidth_used(int enabled, int was_enabled) {}
+void cfs_bandwidth_usage_inc(void) {}
+void cfs_bandwidth_usage_dec(void) {}
 #endif /* HAVE_JUMP_LABEL */
 
 /*
@@ -1769,6 +1771,13 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 	if (idle)
 		goto out_unlock;
 
+	/*
+	 * if we have relooped after returning idle once, we need to update our
+	 * status as actually running, so that other cpus doing
+	 * __start_cfs_bandwidth will stop trying to cancel us.
+	 */
+	cfs_b->timer_active = 1;
+
 	__refill_cfs_bandwidth_runtime(cfs_b);
 
 	if (!throttled) {
@@ -1829,7 +1838,13 @@ static const u64 min_bandwidth_expiration = 2 * NSEC_PER_MSEC;
 /* how long we wait to gather additional slack before distributing */
 static const u64 cfs_bandwidth_slack_period = 5 * NSEC_PER_MSEC;
 
-/* are we near the end of the current quota period? */
+/*
+ * Are we near the end of the current quota period?
+ *
+ * Requires cfs_b->lock for hrtimer_expires_remaining to be safe against the
+ * hrtimer base being cleared by __hrtimer_start_range_ns. In the case of
+ * migrate_hrtimers, base is never cleared, so we are fine.
+ */
 static int runtime_refresh_within(struct cfs_bandwidth *cfs_b, u64 min_expire)
 {
 	struct hrtimer *refresh_timer = &cfs_b->period_timer;
@@ -1905,10 +1920,12 @@ static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
 	u64 expires;
 
 	/* confirm we're still not at a refresh boundary */
-	if (runtime_refresh_within(cfs_b, min_bandwidth_expiration))
+	raw_spin_lock(&cfs_b->lock);
+	if (runtime_refresh_within(cfs_b, min_bandwidth_expiration)) {
+		raw_spin_unlock(&cfs_b->lock);
 		return;
+	}
 
-	raw_spin_lock(&cfs_b->lock);
 	if (cfs_b->quota != RUNTIME_INF && cfs_b->runtime > slice) {
 		runtime = cfs_b->runtime;
 		cfs_b->runtime = 0;
@@ -2033,11 +2050,11 @@ void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	 * (timer_active==0 becomes visible before the hrtimer call-back
 	 * terminates).  In either case we ensure that it's re-programmed
 	 */
-	while (unlikely(hrtimer_active(&cfs_b->period_timer))) {
+	while (unlikely(hrtimer_active(&cfs_b->period_timer)) &&
+	       hrtimer_try_to_cancel(&cfs_b->period_timer) < 0) {
+		/* bounce the lock to allow do_sched_cfs_period_timer to run */
 		raw_spin_unlock(&cfs_b->lock);
-		/* ensure cfs_b->lock is available while we wait */
-		hrtimer_cancel(&cfs_b->period_timer);
-
+		cpu_relax();
 		raw_spin_lock(&cfs_b->lock);
 		/* if someone else restarted the timer then we're done */
 		if (cfs_b->timer_active)
@@ -5192,7 +5209,8 @@ void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 		se->cfs_rq = parent->my_q;
 
 	se->my_q = cfs_rq;
-	update_load_set(&se->load, 0);
+	/* guarantee group entities always have weight */
+	update_load_set(&se->load, NICE_0_LOAD);
 	se->parent = parent;
 }
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 2a05e56..8480912 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -948,6 +948,13 @@ inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * Change rq's cpupri only if rt_rq is the top queue.
+	 */
+	if (&rq->rt != rt_rq)
+		return;
+#endif
 	if (rq->online && prio < prev_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
 }
@@ -957,6 +964,13 @@ dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * Change rq's cpupri only if rt_rq is the top queue.
+	 */
+	if (&rq->rt != rt_rq)
+		return;
+#endif
 	if (rq->online && rt_rq->highest_prio.curr != prev_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 749f712..65bd8a8 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1142,7 +1142,8 @@ extern void init_cfs_rq(struct cfs_rq *cfs_rq);
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
 extern void unthrottle_offline_cfs_rqs(struct rq *rq);
 
-extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
+extern void cfs_bandwidth_usage_inc(void);
+extern void cfs_bandwidth_usage_dec(void);
 
 #ifdef CONFIG_NO_HZ
 enum rq_nohz_flag_bits {
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9d7ae0c..524243e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -688,7 +688,7 @@ static int ftrace_profile_init(void)
 	int cpu;
 	int ret = 0;
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		ret = ftrace_profile_init_cpu(cpu);
 		if (ret)
 			break;
@@ -2031,12 +2031,57 @@ static cycle_t		ftrace_update_time;
 static unsigned long	ftrace_update_cnt;
 unsigned long		ftrace_update_tot_cnt;
 
-static int ops_traces_mod(struct ftrace_ops *ops)
+static inline int ops_traces_mod(struct ftrace_ops *ops)
 {
-	struct ftrace_hash *hash;
+	/*
+	 * Filter_hash being empty will default to trace module.
+	 * But notrace hash requires a test of individual module functions.
+	 */
+	return ftrace_hash_empty(ops->filter_hash) &&
+		ftrace_hash_empty(ops->notrace_hash);
+}
+
+/*
+ * Check if the current ops references the record.
+ *
+ * If the ops traces all functions, then it was already accounted for.
+ * If the ops does not trace the current record function, skip it.
+ * If the ops ignores the function via notrace filter, skip it.
+ */
+static inline bool
+ops_references_rec(struct ftrace_ops *ops, struct dyn_ftrace *rec)
+{
+	/* If ops isn't enabled, ignore it */
+	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
+		return 0;
+
+	/* If ops traces all mods, we already accounted for it */
+	if (ops_traces_mod(ops))
+		return 0;
 
-	hash = ops->filter_hash;
-	return ftrace_hash_empty(hash);
+	/* The function must be in the filter */
+	if (!ftrace_hash_empty(ops->filter_hash) &&
+	    !ftrace_lookup_ip(ops->filter_hash, rec->ip))
+		return 0;
+
+	/* If in notrace hash, we ignore it too */
+	if (ftrace_lookup_ip(ops->notrace_hash, rec->ip))
+		return 0;
+
+	return 1;
+}
+
+static int referenced_filters(struct dyn_ftrace *rec)
+{
+	struct ftrace_ops *ops;
+	int cnt = 0;
+
+	for (ops = ftrace_ops_list; ops != &ftrace_list_end; ops = ops->next) {
+		if (ops_references_rec(ops, rec))
+		    cnt++;
+	}
+
+	return cnt;
 }
 
 static int ftrace_update_code(struct module *mod)
@@ -2045,6 +2090,7 @@ static int ftrace_update_code(struct module *mod)
 	struct dyn_ftrace *p;
 	cycle_t start, stop;
 	unsigned long ref = 0;
+	bool test = false;
 	int i;
 
 	/*
@@ -2058,9 +2104,12 @@ static int ftrace_update_code(struct module *mod)
 
 		for (ops = ftrace_ops_list;
 		     ops != &ftrace_list_end; ops = ops->next) {
-			if (ops->flags & FTRACE_OPS_FL_ENABLED &&
-			    ops_traces_mod(ops))
-				ref++;
+			if (ops->flags & FTRACE_OPS_FL_ENABLED) {
+				if (ops_traces_mod(ops))
+					ref++;
+				else
+					test = true;
+			}
 		}
 	}
 
@@ -2070,12 +2119,16 @@ static int ftrace_update_code(struct module *mod)
 	for (pg = ftrace_new_pgs; pg; pg = pg->next) {
 
 		for (i = 0; i < pg->index; i++) {
+			int cnt = ref;
+
 			/* If something went wrong, bail without enabling anything */
 			if (unlikely(ftrace_disabled))
 				return -1;
 
 			p = &pg->records[i];
-			p->flags = ref;
+			if (test)
+				cnt += referenced_filters(p);
+			p->flags = cnt;
 
 			/*
 			 * Do the initial record conversion from mcount jump
@@ -2095,7 +2148,7 @@ static int ftrace_update_code(struct module *mod)
 			 * conversion puts the module to the correct state, thus
 			 * passing the ftrace_make_call check.
 			 */
-			if (ftrace_start_up && ref) {
+			if (ftrace_start_up && cnt) {
 				int failed = __ftrace_replace_code(p, 1);
 				if (failed)
 					ftrace_bug(failed, p->ip);
diff --git a/mm/mmap.c b/mm/mmap.c
index 758ff55..529f72c 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1515,6 +1515,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 	unsigned long addr = addr0, start_addr;
+	unsigned long low_limit = max(PAGE_SIZE, mmap_min_addr);
 
 	/* requested length too big for entire address space */
 	if (len > TASK_SIZE - mmap_min_addr)
@@ -1542,7 +1543,7 @@ try_again:
 	/* either no address requested or can't fit in requested address hole */
 	start_addr = addr = mm->free_area_cache;
 
-	if (addr < len)
+	if (addr < low_limit + len)
 		goto fail;
 
 	addr -= len;
@@ -1563,7 +1564,7 @@ try_again:
 
 		/* try just below the current vma->vm_start */
 		addr = vma->vm_start-len;
-	} while (len < vma->vm_start);
+	} while (vma->vm_start >= low_limit + len);
 
 fail:
 	/*
diff --git a/mm/rmap.c b/mm/rmap.c
index aa95e59..2b03b31 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -623,7 +623,11 @@ pte_t *__page_check_address(struct page *page, struct mm_struct *mm,
 	spinlock_t *ptl;
 
 	if (unlikely(PageHuge(page))) {
+		/* when pud is not present, pte will be NULL */
 		pte = huge_pte_offset(mm, address);
+		if (!pte)
+			return NULL;
+
 		ptl = &mm->page_table_lock;
 		goto check;
 	}
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index b8cf84e..ce40df8 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -525,6 +525,23 @@ static const struct header_ops vlan_header_ops = {
 	.parse	 = eth_header_parse,
 };
 
+static int vlan_passthru_hard_header(struct sk_buff *skb, struct net_device *dev,
+				     unsigned short type,
+				     const void *daddr, const void *saddr,
+				     unsigned int len)
+{
+	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
+	struct net_device *real_dev = vlan->real_dev;
+
+	return dev_hard_header(skb, real_dev, type, daddr, saddr, len);
+}
+
+static const struct header_ops vlan_passthru_header_ops = {
+	.create	 = vlan_passthru_hard_header,
+	.rebuild = dev_rebuild_header,
+	.parse	 = eth_header_parse,
+};
+
 static const struct net_device_ops vlan_netdev_ops;
 
 static int vlan_dev_init(struct net_device *dev)
@@ -564,7 +581,7 @@ static int vlan_dev_init(struct net_device *dev)
 
 	dev->needed_headroom = real_dev->needed_headroom;
 	if (real_dev->features & NETIF_F_HW_VLAN_TX) {
-		dev->header_ops      = real_dev->header_ops;
+		dev->header_ops      = &vlan_passthru_header_ops;
 		dev->hard_header_len = real_dev->hard_header_len;
 	} else {
 		dev->header_ops      = &vlan_header_ops;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index e881f7f..f15a12f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1787,7 +1787,7 @@ int br_multicast_set_hash_max(struct net_bridge *br, unsigned long val)
 	u32 old;
 	struct net_bridge_mdb_htable *mdb;
 
-	spin_lock(&br->multicast_lock);
+	spin_lock_bh(&br->multicast_lock);
 	if (!netif_running(br->dev))
 		goto unlock;
 
@@ -1819,7 +1819,7 @@ rollback:
 	}
 
 unlock:
-	spin_unlock(&br->multicast_lock);
+	spin_unlock_bh(&br->multicast_lock);
 
 	return err;
 }
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index d23b668..a974dfe 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -64,7 +64,6 @@ static struct genl_family net_drop_monitor_family = {
 	.hdrsize        = 0,
 	.name           = "NET_DM",
 	.version        = 2,
-	.maxattr        = NET_DM_CMD_MAX,
 };
 
 static DEFINE_PER_CPU(struct per_cpu_dm_data, dm_cpu_data);
diff --git a/net/core/sock.c b/net/core/sock.c
index 457ae99..5057305 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -787,7 +787,7 @@ set_rcvbuf:
 
 	case SO_PEEK_OFF:
 		if (sock->ops->set_peek_off)
-			sock->ops->set_peek_off(sk, val);
+			ret = sock->ops->set_peek_off(sk, val);
 		else
 			ret = -EOPNOTSUPP;
 		break;
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 232560a..e530c31 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -110,6 +110,10 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 
 	r->id.idiag_sport = inet->inet_sport;
 	r->id.idiag_dport = inet->inet_dport;
+
+	memset(&r->id.idiag_src, 0, sizeof(r->id.idiag_src));
+	memset(&r->id.idiag_dst, 0, sizeof(r->id.idiag_dst));
+
 	r->id.idiag_src[0] = inet->inet_rcv_saddr;
 	r->id.idiag_dst[0] = inet->inet_daddr;
 
@@ -227,12 +231,19 @@ static int inet_twsk_diag_fill(struct inet_timewait_sock *tw,
 
 	r->idiag_family	      = tw->tw_family;
 	r->idiag_retrans      = 0;
+
 	r->id.idiag_if	      = tw->tw_bound_dev_if;
 	sock_diag_save_cookie(tw, r->id.idiag_cookie);
+
 	r->id.idiag_sport     = tw->tw_sport;
 	r->id.idiag_dport     = tw->tw_dport;
+
+	memset(&r->id.idiag_src, 0, sizeof(r->id.idiag_src));
+	memset(&r->id.idiag_dst, 0, sizeof(r->id.idiag_dst));
+
 	r->id.idiag_src[0]    = tw->tw_rcv_saddr;
 	r->id.idiag_dst[0]    = tw->tw_daddr;
+
 	r->idiag_state	      = tw->tw_substate;
 	r->idiag_timer	      = 3;
 	r->idiag_expires      = DIV_ROUND_UP(tmo * 1000, HZ);
@@ -714,8 +725,13 @@ static int inet_diag_fill_req(struct sk_buff *skb, struct sock *sk,
 
 	r->id.idiag_sport = inet->inet_sport;
 	r->id.idiag_dport = ireq->rmt_port;
+
+	memset(&r->id.idiag_src, 0, sizeof(r->id.idiag_src));
+	memset(&r->id.idiag_dst, 0, sizeof(r->id.idiag_dst));
+
 	r->id.idiag_src[0] = ireq->loc_addr;
 	r->id.idiag_dst[0] = ireq->rmt_addr;
+
 	r->idiag_expires = jiffies_to_msecs(tmo);
 	r->idiag_rqueue = 0;
 	r->idiag_wqueue = 0;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 2367444..5b8eac8 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2112,13 +2112,11 @@ struct rt6_info *addrconf_dst_alloc(struct inet6_dev *idev,
 {
 	struct net *net = dev_net(idev->dev);
 	struct rt6_info *rt = ip6_dst_alloc(&net->ipv6.ip6_dst_ops,
-					    net->loopback_dev, 0);
+					    net->loopback_dev, DST_NOCOUNT);
 	int err;
 
-	if (!rt) {
-		net_warn_ratelimited("Maximum number of routes reached, consider increasing route/max_size\n");
+	if (!rt)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	in6_dev_hold(idev);
 
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index a13c3e2..1895833 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -715,7 +715,7 @@ static int llc_ui_recvmsg(struct kiocb *iocb, struct socket *sock,
 	unsigned long cpu_flags;
 	size_t copied = 0;
 	u32 peek_seq = 0;
-	u32 *seq;
+	u32 *seq, skb_len;
 	unsigned long used;
 	int target;	/* Read at least this many bytes */
 	long timeo;
@@ -812,6 +812,7 @@ static int llc_ui_recvmsg(struct kiocb *iocb, struct socket *sock,
 		}
 		continue;
 	found_ok_skb:
+		skb_len = skb->len;
 		/* Ok so how much can we use? */
 		used = skb->len - offset;
 		if (len < used)
@@ -844,7 +845,7 @@ static int llc_ui_recvmsg(struct kiocb *iocb, struct socket *sock,
 		}
 
 		/* Partial read */
-		if (used + offset < skb->len)
+		if (used + offset < skb_len)
 			continue;
 	} while (len > 0);
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 83755a5..79cfca3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -446,7 +446,6 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 {
 	struct sta_info *sta = tx->sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 	struct ieee80211_local *local = tx->local;
 
 	if (unlikely(!sta))
@@ -457,15 +456,6 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 		     !(info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER))) {
 		int ac = skb_get_queue_mapping(tx->skb);
 
-		/* only deauth, disassoc and action are bufferable MMPDUs */
-		if (ieee80211_is_mgmt(hdr->frame_control) &&
-		    !ieee80211_is_deauth(hdr->frame_control) &&
-		    !ieee80211_is_disassoc(hdr->frame_control) &&
-		    !ieee80211_is_action(hdr->frame_control)) {
-			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
-			return TX_CONTINUE;
-		}
-
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "STA %pM aid %d: PS buffer for AC %d\n",
 		       sta->sta.addr, sta->sta.aid, ac);
@@ -514,9 +504,22 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_ps_buf(struct ieee80211_tx_data *tx)
 {
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
+
 	if (unlikely(tx->flags & IEEE80211_TX_PS_BUFFERED))
 		return TX_CONTINUE;
 
+	/* only deauth, disassoc and action are bufferable MMPDUs */
+	if (ieee80211_is_mgmt(hdr->frame_control) &&
+	    !ieee80211_is_deauth(hdr->frame_control) &&
+	    !ieee80211_is_disassoc(hdr->frame_control) &&
+	    !ieee80211_is_action(hdr->frame_control)) {
+		if (tx->flags & IEEE80211_TX_UNICAST)
+			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
+		return TX_CONTINUE;
+	}
+
 	if (tx->flags & IEEE80211_TX_UNICAST)
 		return ieee80211_tx_h_unicast_ps_buf(tx);
 	else
diff --git a/net/rds/ib.c b/net/rds/ib.c
index b4c8b00..ba2dffe 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -338,7 +338,8 @@ static int rds_ib_laddr_check(__be32 addr)
 	ret = rdma_bind_addr(cm_id, (struct sockaddr *)&sin);
 	/* due to this, we will claim to support iWARP devices unless we
 	   check node_type. */
-	if (ret || cm_id->device->node_type != RDMA_NODE_IB_CA)
+	if (ret || !cm_id->device ||
+	    cm_id->device->node_type != RDMA_NODE_IB_CA)
 		ret = -EADDRNOTAVAIL;
 
 	rdsdebug("addr %pI4 ret %d node type %d\n",
diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index e590949..37be6e2 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -552,9 +552,8 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
 	    && rm->m_inc.i_hdr.h_flags & RDS_FLAG_CONG_BITMAP) {
 		rds_cong_map_updated(conn->c_fcong, ~(u64) 0);
 		scat = &rm->data.op_sg[sg];
-		ret = sizeof(struct rds_header) + RDS_CONG_MAP_BYTES;
-		ret = min_t(int, ret, scat->length - conn->c_xmit_data_off);
-		return ret;
+		ret = max_t(int, RDS_CONG_MAP_BYTES, scat->length);
+		return sizeof(struct rds_header) + ret;
 	}
 
 	/* FIXME we may overallocate here */
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index ce5f5b9..bde7d69 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1257,6 +1257,7 @@ static int rose_recvmsg(struct kiocb *iocb, struct socket *sock,
 
 	if (msg->msg_name) {
 		struct sockaddr_rose *srose;
+		struct full_sockaddr_rose *full_srose = msg->msg_name;
 
 		memset(msg->msg_name, 0, sizeof(struct full_sockaddr_rose));
 		srose = msg->msg_name;
@@ -1264,18 +1265,9 @@ static int rose_recvmsg(struct kiocb *iocb, struct socket *sock,
 		srose->srose_addr   = rose->dest_addr;
 		srose->srose_call   = rose->dest_call;
 		srose->srose_ndigis = rose->dest_ndigis;
-		if (msg->msg_namelen >= sizeof(struct full_sockaddr_rose)) {
-			struct full_sockaddr_rose *full_srose = (struct full_sockaddr_rose *)msg->msg_name;
-			for (n = 0 ; n < rose->dest_ndigis ; n++)
-				full_srose->srose_digis[n] = rose->dest_digis[n];
-			msg->msg_namelen = sizeof(struct full_sockaddr_rose);
-		} else {
-			if (rose->dest_ndigis >= 1) {
-				srose->srose_ndigis = 1;
-				srose->srose_digi = rose->dest_digis[0];
-			}
-			msg->msg_namelen = sizeof(struct sockaddr_rose);
-		}
+		for (n = 0 ; n < rose->dest_ndigis ; n++)
+			full_srose->srose_digis[n] = rose->dest_digis[n];
+		msg->msg_namelen = sizeof(struct full_sockaddr_rose);
 	}
 
 	skb_free_datagram(sk, skb);
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index a0df32b..5959b80 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -525,13 +525,17 @@ static int unix_seqpacket_sendmsg(struct kiocb *, struct socket *,
 static int unix_seqpacket_recvmsg(struct kiocb *, struct socket *,
 				  struct msghdr *, size_t, int);
 
-static void unix_set_peek_off(struct sock *sk, int val)
+static int unix_set_peek_off(struct sock *sk, int val)
 {
 	struct unix_sock *u = unix_sk(sk);
 
-	mutex_lock(&u->readlock);
+	if (mutex_lock_interruptible(&u->readlock))
+		return -EINTR;
+
 	sk->sk_peek_off = val;
 	mutex_unlock(&u->readlock);
+
+	return 0;
 }
 
 
@@ -709,7 +713,9 @@ static int unix_autobind(struct socket *sock)
 	int err;
 	unsigned int retries = 0;
 
-	mutex_lock(&u->readlock);
+	err = mutex_lock_interruptible(&u->readlock);
+	if (err)
+		return err;
 
 	err = 0;
 	if (u->addr)
@@ -842,7 +848,9 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		goto out;
 	addr_len = err;
 
-	mutex_lock(&u->readlock);
+	err = mutex_lock_interruptible(&u->readlock);
+	if (err)
+		goto out;
 
 	err = -EINVAL;
 	if (u->addr)
diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index 617a310..60549a4 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -122,6 +122,10 @@ int ieee80211_radiotap_iterator_init(
 	/* find payload start allowing for extended bitmap(s) */
 
 	if (iterator->_bitmap_shifter & (1<<IEEE80211_RADIOTAP_EXT)) {
+		if ((unsigned long)iterator->_arg -
+		    (unsigned long)iterator->_rtheader + sizeof(uint32_t) >
+		    (unsigned long)iterator->_max_length)
+			return -EINVAL;
 		while (get_unaligned_le32(iterator->_arg) &
 					(1 << IEEE80211_RADIOTAP_EXT)) {
 			iterator->_arg += sizeof(uint32_t);
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 7a9f7f9..304c9f1 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -78,7 +78,9 @@ kallsyms()
 		kallsymopt=--all-symbols
 	fi
 
-	kallsymopt="${kallsymopt} --page-offset=$CONFIG_PAGE_OFFSET"
+	if [ -n "${CONFIG_ARM}" ] && [ -n "${CONFIG_PAGE_OFFSET}" ]; then
+		kallsymopt="${kallsymopt} --page-offset=$CONFIG_PAGE_OFFSET"
+	fi
 
 	local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
 		      ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 7b40d22..0189046 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -218,6 +218,14 @@ static int inode_alloc_security(struct inode *inode)
 	return 0;
 }
 
+static void inode_free_rcu(struct rcu_head *head)
+{
+	struct inode_security_struct *isec;
+
+	isec = container_of(head, struct inode_security_struct, rcu);
+	kmem_cache_free(sel_inode_cache, isec);
+}
+
 static void inode_free_security(struct inode *inode)
 {
 	struct inode_security_struct *isec = inode->i_security;
@@ -228,8 +236,16 @@ static void inode_free_security(struct inode *inode)
 		list_del_init(&isec->list);
 	spin_unlock(&sbsec->isec_lock);
 
-	inode->i_security = NULL;
-	kmem_cache_free(sel_inode_cache, isec);
+	/*
+	 * The inode may still be referenced in a path walk and
+	 * a call to selinux_inode_permission() can be made
+	 * after inode_free_security() is called. Ideally, the VFS
+	 * wouldn't do this, but fixing that is a much harder
+	 * job. For now, simply free the i_security via RCU, and
+	 * leave the current inode->i_security pointer intact.
+	 * The inode will be freed after the RCU grace period too.
+	 */
+	call_rcu(&isec->rcu, inode_free_rcu);
 }
 
 static int file_alloc_security(struct file *file)
@@ -3735,7 +3751,7 @@ static int selinux_skb_peerlbl_sid(struct sk_buff *skb, u16 family, u32 *sid)
 	u32 nlbl_sid;
 	u32 nlbl_type;
 
-	selinux_skb_xfrm_sid(skb, &xfrm_sid);
+	selinux_xfrm_skb_sid(skb, &xfrm_sid);
 	selinux_netlbl_skbuff_getsid(skb, family, &nlbl_type, &nlbl_sid);
 
 	err = security_net_peersid_resolve(nlbl_sid, nlbl_type, xfrm_sid, sid);
@@ -4240,8 +4256,10 @@ static int selinux_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		}
 		err = avc_has_perm(sk_sid, peer_sid, SECCLASS_PEER,
 				   PEER__RECV, &ad);
-		if (err)
+		if (err) {
 			selinux_netlbl_err(skb, err, 0);
+			return err;
+		}
 	}
 
 	if (secmark_active) {
@@ -4722,22 +4740,32 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
 	 * as fast and as clean as possible. */
 	if (!selinux_policycap_netpeer)
 		return selinux_ip_postroute_compat(skb, ifindex, family);
+
+	secmark_active = selinux_secmark_enabled();
+	peerlbl_active = netlbl_enabled() || selinux_xfrm_enabled();
+	if (!secmark_active && !peerlbl_active)
+		return NF_ACCEPT;
+
+	sk = skb->sk;
+
 #ifdef CONFIG_XFRM
 	/* If skb->dst->xfrm is non-NULL then the packet is undergoing an IPsec
 	 * packet transformation so allow the packet to pass without any checks
 	 * since we'll have another chance to perform access control checks
 	 * when the packet is on it's final way out.
 	 * NOTE: there appear to be some IPv6 multicast cases where skb->dst
-	 *       is NULL, in this case go ahead and apply access control. */
-	if (skb_dst(skb) != NULL && skb_dst(skb)->xfrm != NULL)
+	 *       is NULL, in this case go ahead and apply access control.
+	 *       is NULL, in this case go ahead and apply access control.
+	 * NOTE: if this is a local socket (skb->sk != NULL) that is in the
+	 *       TCP listening state we cannot wait until the XFRM processing
+	 *       is done as we will miss out on the SA label if we do;
+	 *       unfortunately, this means more work, but it is only once per
+	 *       connection. */
+	if (skb_dst(skb) != NULL && skb_dst(skb)->xfrm != NULL &&
+	    !(sk != NULL && sk->sk_state == TCP_LISTEN))
 		return NF_ACCEPT;
 #endif
-	secmark_active = selinux_secmark_enabled();
-	peerlbl_active = netlbl_enabled() || selinux_xfrm_enabled();
-	if (!secmark_active && !peerlbl_active)
-		return NF_ACCEPT;
 
-	sk = skb->sk;
 	if (sk == NULL) {
 		/* Without an associated socket the packet is either coming
 		 * from the kernel or it is being forwarded; check the packet
@@ -4765,6 +4793,25 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
 		struct sk_security_struct *sksec = sk->sk_security;
 		if (selinux_skb_peerlbl_sid(skb, family, &skb_sid))
 			return NF_DROP;
+		/* At this point, if the returned skb peerlbl is SECSID_NULL
+		 * and the packet has been through at least one XFRM
+		 * transformation then we must be dealing with the "final"
+		 * form of labeled IPsec packet; since we've already applied
+		 * all of our access controls on this packet we can safely
+		 * pass the packet. */
+		if (skb_sid == SECSID_NULL) {
+			switch (family) {
+			case PF_INET:
+				if (IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED)
+					return NF_ACCEPT;
+				break;
+			case PF_INET6:
+				if (IP6CB(skb)->flags & IP6SKB_XFRM_TRANSFORMED)
+					return NF_ACCEPT;
+			default:
+				return NF_DROP_ERR(-ECONNREFUSED);
+			}
+		}
 		if (selinux_conn_sid(sksec->sid, skb_sid, &peer_sid))
 			return NF_DROP;
 		secmark_perm = PACKET__SEND;
@@ -5434,11 +5481,11 @@ static int selinux_setprocattr(struct task_struct *p,
 		/* Check for ptracing, and update the task SID if ok.
 		   Otherwise, leave SID unchanged and fail. */
 		ptsid = 0;
-		task_lock(p);
+		rcu_read_lock();
 		tracer = ptrace_parent(p);
 		if (tracer)
 			ptsid = task_sid(tracer);
-		task_unlock(p);
+		rcu_read_unlock();
 
 		if (tracer) {
 			error = avc_has_perm(ptsid, sid, SECCLASS_PROCESS,
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 26c7eee..7b1830b 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -38,7 +38,10 @@ struct task_security_struct {
 
 struct inode_security_struct {
 	struct inode *inode;	/* back pointer to inode object */
-	struct list_head list;	/* list of inode_security_struct */
+	union {
+		struct list_head list;	/* list of inode_security_struct */
+		struct rcu_head rcu;	/* for freeing the inode_security_struct */
+	};
 	u32 task_sid;		/* SID of creating task */
 	u32 sid;		/* SID of this object */
 	u16 sclass;		/* security class of this object */
diff --git a/security/selinux/include/xfrm.h b/security/selinux/include/xfrm.h
index c220f31..d1c980c 100644
--- a/security/selinux/include/xfrm.h
+++ b/security/selinux/include/xfrm.h
@@ -47,6 +47,7 @@ int selinux_xfrm_sock_rcv_skb(u32 sid, struct sk_buff *skb,
 int selinux_xfrm_postroute_last(u32 isec_sid, struct sk_buff *skb,
 			struct common_audit_data *ad, u8 proto);
 int selinux_xfrm_decode_session(struct sk_buff *skb, u32 *sid, int ckall);
+int selinux_xfrm_skb_sid(struct sk_buff *skb, u32 *sid);
 
 static inline void selinux_xfrm_notify_policyload(void)
 {
@@ -79,12 +80,12 @@ static inline int selinux_xfrm_decode_session(struct sk_buff *skb, u32 *sid, int
 static inline void selinux_xfrm_notify_policyload(void)
 {
 }
-#endif
 
-static inline void selinux_skb_xfrm_sid(struct sk_buff *skb, u32 *sid)
+static inline int selinux_xfrm_skb_sid(struct sk_buff *skb, u32 *sid)
 {
-	int err = selinux_xfrm_decode_session(skb, sid, 0);
-	BUG_ON(err);
+	*sid = SECSID_NULL;
+	return 0;
 }
+#endif
 
 #endif /* _SELINUX_XFRM_H_ */
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 8ab2951..1552b91 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -152,21 +152,13 @@ int selinux_xfrm_state_pol_flow_match(struct xfrm_state *x, struct xfrm_policy *
 	return rc;
 }
 
-/*
- * LSM hook implementation that checks and/or returns the xfrm sid for the
- * incoming packet.
- */
-
-int selinux_xfrm_decode_session(struct sk_buff *skb, u32 *sid, int ckall)
+static int selinux_xfrm_skb_sid_ingress(struct sk_buff *skb,
+					u32 *sid, int ckall)
 {
-	struct sec_path *sp;
+	struct sec_path *sp = skb->sp;
 
 	*sid = SECSID_NULL;
 
-	if (skb == NULL)
-		return 0;
-
-	sp = skb->sp;
 	if (sp) {
 		int i, sid_set = 0;
 
@@ -190,6 +182,45 @@ int selinux_xfrm_decode_session(struct sk_buff *skb, u32 *sid, int ckall)
 	return 0;
 }
 
+static u32 selinux_xfrm_skb_sid_egress(struct sk_buff *skb)
+{
+	struct dst_entry *dst = skb_dst(skb);
+	struct xfrm_state *x;
+
+	if (dst == NULL)
+		return SECSID_NULL;
+	x = dst->xfrm;
+	if (x == NULL || !selinux_authorizable_xfrm(x))
+		return SECSID_NULL;
+
+	return x->security->ctx_sid;
+}
+
+/*
+ * LSM hook implementation that checks and/or returns the xfrm sid for the
+ * incoming packet.
+ */
+
+int selinux_xfrm_decode_session(struct sk_buff *skb, u32 *sid, int ckall)
+{
+	if (skb == NULL) {
+		*sid = SECSID_NULL;
+		return 0;
+	}
+	return selinux_xfrm_skb_sid_ingress(skb, sid, ckall);
+}
+
+int selinux_xfrm_skb_sid(struct sk_buff *skb, u32 *sid)
+{
+	int rc;
+
+	rc = selinux_xfrm_skb_sid_ingress(skb, sid, 0);
+	if (rc == 0 && *sid == SECSID_NULL)
+		*sid = selinux_xfrm_skb_sid_egress(skb);
+
+	return rc;
+}
+
 /*
  * Security blob allocation for xfrm_policy and xfrm_state
  * CTX does not have a meaningful value on input
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 8f312fa..d8b6c81 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1860,6 +1860,8 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
 		case SNDRV_PCM_STATE_DISCONNECTED:
 			err = -EBADFD;
 			goto _endloop;
+		case SNDRV_PCM_STATE_PAUSED:
+			continue;
 		}
 		if (!tout) {
 			snd_printd("%s write error (DMA or IRQ trouble?)\n",
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index c4b29d4..d13662f 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2809,6 +2809,10 @@ static void __devinit check_probe_mask(struct azx *chip, int dev)
  * white/black-list for enable_msi
  */
 static struct snd_pci_quirk msi_black_list[] __devinitdata = {
+	SND_PCI_QUIRK(0x103c, 0x2191, "HP", 0), /* AMD Hudson */
+	SND_PCI_QUIRK(0x103c, 0x2192, "HP", 0), /* AMD Hudson */
+	SND_PCI_QUIRK(0x103c, 0x21f7, "HP", 0), /* AMD Hudson */
+	SND_PCI_QUIRK(0x103c, 0x21fa, "HP", 0), /* AMD Hudson */
 	SND_PCI_QUIRK(0x1043, 0x81f2, "ASUS", 0), /* Athlon64 X2 + nvidia */
 	SND_PCI_QUIRK(0x1043, 0x81f6, "ASUS", 0), /* nvidia */
 	SND_PCI_QUIRK(0x1043, 0x822d, "ASUS", 0), /* Athlon64 X2 + nvidia MCP55 */
diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index 812acd8..dce77c5 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -1456,7 +1456,7 @@ static int wm8904_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_DSP_B:
-		aif1 |= WM8904_AIF_LRCLK_INV;
+		aif1 |= 0x3 | WM8904_AIF_LRCLK_INV;
 	case SND_SOC_DAIFMT_DSP_A:
 		aif1 |= 0x3;
 		break;
diff --git a/tools/power/cpupower/utils/cpupower-set.c b/tools/power/cpupower/utils/cpupower-set.c
index dc4de37..bcf1d2f 100644
--- a/tools/power/cpupower/utils/cpupower-set.c
+++ b/tools/power/cpupower/utils/cpupower-set.c
@@ -18,9 +18,9 @@
 #include "helpers/bitmask.h"
 
 static struct option set_opts[] = {
-	{ .name = "perf-bias",	.has_arg = optional_argument,	.flag = NULL,	.val = 'b'},
-	{ .name = "sched-mc",	.has_arg = optional_argument,	.flag = NULL,	.val = 'm'},
-	{ .name = "sched-smt",	.has_arg = optional_argument,	.flag = NULL,	.val = 's'},
+	{ .name = "perf-bias",	.has_arg = required_argument,	.flag = NULL,	.val = 'b'},
+	{ .name = "sched-mc",	.has_arg = required_argument,	.flag = NULL,	.val = 'm'},
+	{ .name = "sched-smt",	.has_arg = required_argument,	.flag = NULL,	.val = 's'},
 	{ },
 };
 
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index e9fff98..53d34f6 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -101,6 +101,10 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 		while ((gfn << PAGE_SHIFT) & (page_size - 1))
 			page_size >>= 1;
 
+		/* Make sure hva is aligned to the page size we want to map */
+		while (gfn_to_hva_memslot(slot, gfn) & (page_size - 1))
+			page_size >>= 1;
+
 		/*
 		 * Pin all pages we are about to map in memory. This is
 		 * important because we unmap and unpin in 4kb steps later.
