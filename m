Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbaELJPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:15:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46427 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067AbaELJPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:15:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.11.y.z extended stable] Linux 3.11.10.10
Date: Mon, 12 May 2014 10:15:23 +0100
Message-Id: <1399886123-7402-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399886123-7402-1-git-send-email-luis.henriques@canonical.com>
References: <1399886123-7402-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Documentation/i2c/busses/i2c-i801 b/Documentation/i2c/busses/i2c-i801
index d29dea0..babe2ef 100644
--- a/Documentation/i2c/busses/i2c-i801
+++ b/Documentation/i2c/busses/i2c-i801
@@ -25,6 +25,8 @@ Supported adapters:
   * Intel Avoton (SOC)
   * Intel Wellsburg (PCH)
   * Intel Coleto Creek (PCH)
+  * Intel Wildcat Point-LP (PCH)
+  * Intel BayTrail (SOC)
    Datasheets: Publicly available at the Intel website
 
 On Intel Patsburg and later chipsets, both the normal host SMBus controller
diff --git a/Makefile b/Makefile
index ec43bc8..ca84f45 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 11
 SUBLEVEL = 10
-EXTRAVERSION = .9
+EXTRAVERSION = .10
 NAME = Linux for Workgroups
 
 # *DOCUMENTATION*
diff --git a/arch/arc/include/asm/irqflags.h b/arch/arc/include/asm/irqflags.h
index d99f79b..b68b53f 100644
--- a/arch/arc/include/asm/irqflags.h
+++ b/arch/arc/include/asm/irqflags.h
@@ -157,13 +157,6 @@ static inline void arch_unmask_irq(unsigned int irq)
 	flag	\scratch
 .endm
 
-.macro IRQ_DISABLE_SAVE  scratch, save
-	lr	\scratch, [status32]
-	mov	\save, \scratch		/* Make a copy */
-	bic	\scratch, \scratch, (STATUS_E1_MASK | STATUS_E2_MASK)
-	flag	\scratch
-.endm
-
 .macro IRQ_ENABLE  scratch
 	lr	\scratch, [status32]
 	or	\scratch, \scratch, (STATUS_E1_MASK | STATUS_E2_MASK)
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index 1d71651..ca6e48b 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -640,6 +640,11 @@ resume_user_mode_begin:
 
 resume_kernel_mode:
 
+	; Disable Interrupts from this point on
+	; CONFIG_PREEMPT: This is a must for preempt_schedule_irq()
+	; !CONFIG_PREEMPT: To ensure restore_regs is intr safe
+	IRQ_DISABLE	r9
+
 #ifdef CONFIG_PREEMPT
 
 	; Can't preempt if preemption disabled
@@ -651,8 +656,6 @@ resume_kernel_mode:
 	ld  r9, [r10, THREAD_INFO_FLAGS]
 	bbit0  r9, TIF_NEED_RESCHED, restore_regs
 
-	IRQ_DISABLE	r9
-
 	; Invoke PREEMPTION
 	bl      preempt_schedule_irq
 
@@ -665,12 +668,11 @@ resume_kernel_mode:
 ;
 ; Restore the saved sys context (common exit-path for EXCPN/IRQ/Trap)
 ; IRQ shd definitely not happen between now and rtie
+; All 2 entry points to here already disable interrupts
 
 restore_regs :
 
-	; Disable Interrupts while restoring reg-file back
-	; XXX can this be optimised out
-	IRQ_DISABLE_SAVE    r9, r10	;@r10 has prisitine (pre-disable) copy
+	lr	r10, [status32]
 
 	; Restore REG File. In case multiple Events outstanding,
 	; use the same priorty as rtie: EXCPN, L2 IRQ, L1 IRQ, None
diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
index f384baf..6516c09 100644
--- a/arch/arm/boot/dts/armada-370-xp.dtsi
+++ b/arch/arm/boot/dts/armada-370-xp.dtsi
@@ -101,6 +101,7 @@
 				#size-cells = <0>;
 				compatible = "marvell,orion-mdio";
 				reg = <0x72004 0x4>;
+				clocks = <&gateclk 4>;
 			};
 
 			eth0: ethernet@70000 {
diff --git a/arch/arm/include/asm/div64.h b/arch/arm/include/asm/div64.h
index 191ada6..662c7bd 100644
--- a/arch/arm/include/asm/div64.h
+++ b/arch/arm/include/asm/div64.h
@@ -156,7 +156,7 @@
 		/* Select the best insn combination to perform the   */	\
 		/* actual __m * __n / (__p << 64) operation.         */	\
 		if (!__c) {						\
-			asm (	"umull	%Q0, %R0, %1, %Q2\n\t"		\
+			asm (	"umull	%Q0, %R0, %Q1, %Q2\n\t"		\
 				"mov	%Q0, #0"			\
 				: "=&r" (__res)				\
 				: "r" (__m), "r" (__n)			\
diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 141baa3..cbd6197 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -48,6 +48,5 @@
  */
 #define __IGNORE_fadvise64_64
 #define __IGNORE_migrate_pages
-#define __IGNORE_kcmp
 
 #endif /* __ASM_ARM_UNISTD_H */
diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
index 57221e3..faa3d4c 100644
--- a/arch/arm/kernel/machine_kexec.c
+++ b/arch/arm/kernel/machine_kexec.c
@@ -181,3 +181,10 @@ void machine_kexec(struct kimage *image)
 
 	soft_restart(reboot_code_buffer_phys);
 }
+
+void arch_crash_save_vmcoreinfo(void)
+{
+#ifdef CONFIG_ARM_LPAE
+	VMCOREINFO_CONFIG(ARM_LPAE);
+#endif
+}
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index b91a68b..df3e999 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -41,6 +41,8 @@ static unsigned long hyp_idmap_start;
 static unsigned long hyp_idmap_end;
 static phys_addr_t hyp_idmap_vector;
 
+#define pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
+
 static void kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
 	/*
@@ -172,14 +174,14 @@ void free_boot_hyp_pgd(void)
 	if (boot_hyp_pgd) {
 		unmap_range(NULL, boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
 		unmap_range(NULL, boot_hyp_pgd, TRAMPOLINE_VA, PAGE_SIZE);
-		kfree(boot_hyp_pgd);
+		free_pages((unsigned long)boot_hyp_pgd, pgd_order);
 		boot_hyp_pgd = NULL;
 	}
 
 	if (hyp_pgd)
 		unmap_range(NULL, hyp_pgd, TRAMPOLINE_VA, PAGE_SIZE);
 
-	kfree(init_bounce_page);
+	free_page((unsigned long)init_bounce_page);
 	init_bounce_page = NULL;
 
 	mutex_unlock(&kvm_hyp_pgd_mutex);
@@ -209,7 +211,7 @@ void free_hyp_pgds(void)
 		for (addr = VMALLOC_START; is_vmalloc_addr((void*)addr); addr += PGDIR_SIZE)
 			unmap_range(NULL, hyp_pgd, KERN_TO_HYP(addr), PGDIR_SIZE);
 
-		kfree(hyp_pgd);
+		free_pages((unsigned long)hyp_pgd, pgd_order);
 		hyp_pgd = NULL;
 	}
 
@@ -782,7 +784,7 @@ int kvm_mmu_init(void)
 		size_t len = __hyp_idmap_text_end - __hyp_idmap_text_start;
 		phys_addr_t phys_base;
 
-		init_bounce_page = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		init_bounce_page = (void *)__get_free_page(GFP_KERNEL);
 		if (!init_bounce_page) {
 			kvm_err("Couldn't allocate HYP init bounce page\n");
 			err = -ENOMEM;
@@ -808,8 +810,9 @@ int kvm_mmu_init(void)
 			 (unsigned long)phys_base);
 	}
 
-	hyp_pgd = kzalloc(PTRS_PER_PGD * sizeof(pgd_t), GFP_KERNEL);
-	boot_hyp_pgd = kzalloc(PTRS_PER_PGD * sizeof(pgd_t), GFP_KERNEL);
+	hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, pgd_order);
+	boot_hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, pgd_order);
+
 	if (!hyp_pgd || !boot_hyp_pgd) {
 		kvm_err("Hyp mode PGD not allocated\n");
 		err = -ENOMEM;
diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 60f2344..857e76c 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -1968,7 +1968,7 @@ static struct omap_hwmod_irq_info omap3xxx_usb_host_hs_irqs[] = {
 static struct omap_hwmod omap3xxx_usb_host_hs_hwmod = {
 	.name		= "usb_host_hs",
 	.class		= &omap3xxx_usb_host_hs_hwmod_class,
-	.clkdm_name	= "l3_init_clkdm",
+	.clkdm_name	= "usbhost_clkdm",
 	.mpu_irqs	= omap3xxx_usb_host_hs_irqs,
 	.main_clk	= "usbhost_48m_fck",
 	.prcm = {
@@ -2053,7 +2053,7 @@ static struct omap_hwmod_irq_info omap3xxx_usb_tll_hs_irqs[] = {
 static struct omap_hwmod omap3xxx_usb_tll_hs_hwmod = {
 	.name		= "usb_tll_hs",
 	.class		= &omap3xxx_usb_tll_hs_hwmod_class,
-	.clkdm_name	= "l3_init_clkdm",
+	.clkdm_name	= "core_l4_clkdm",
 	.mpu_irqs	= omap3xxx_usb_tll_hs_irqs,
 	.main_clk	= "usbtll_fck",
 	.prcm = {
diff --git a/arch/arm/mach-omap2/pm.h b/arch/arm/mach-omap2/pm.h
index 7bdd22a..d4d0fce 100644
--- a/arch/arm/mach-omap2/pm.h
+++ b/arch/arm/mach-omap2/pm.h
@@ -103,7 +103,7 @@ static inline void enable_omap3630_toggle_l2_on_restore(void) { }
 
 #define PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD	(1 << 0)
 
-#if defined(CONFIG_ARCH_OMAP4)
+#if defined(CONFIG_PM) && defined(CONFIG_ARCH_OMAP4)
 extern u16 pm44xx_errata;
 #define IS_PM44XX_ERRATUM(id)		(pm44xx_errata & (id))
 #else
diff --git a/arch/arm/mm/mmap.c b/arch/arm/mm/mmap.c
index 304661d..5e85ed3 100644
--- a/arch/arm/mm/mmap.c
+++ b/arch/arm/mm/mmap.c
@@ -202,13 +202,11 @@ int valid_phys_addr_range(phys_addr_t addr, size_t size)
 }
 
 /*
- * We don't use supersection mappings for mmap() on /dev/mem, which
- * means that we can't map the memory area above the 4G barrier into
- * userspace.
+ * Do not allow /dev/mem mappings beyond the supported physical range.
  */
 int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
 {
-	return !(pfn + (size >> PAGE_SHIFT) > 0x00100000);
+	return (pfn + (size >> PAGE_SHIFT)) <= (1 + (PHYS_MASK >> PAGE_SHIFT));
 }
 
 #ifdef CONFIG_STRICT_DEVMEM
diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
index 9d36774..011e704 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -635,7 +635,7 @@ static void octeon_irq_cpu_offline_ciu(struct irq_data *data)
 		cpumask_clear(&new_affinity);
 		cpumask_set_cpu(cpumask_first(cpu_online_mask), &new_affinity);
 	}
-	__irq_set_affinity_locked(data, &new_affinity);
+	irq_set_affinity_locked(data, &new_affinity, false);
 }
 
 static int octeon_irq_ciu_set_affinity(struct irq_data *data,
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 34c1c9a..e13e7af 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -781,7 +781,8 @@ rerun_vcpu:
 		if (rc)
 			break;
 		if (kvm_is_ucontrol(vcpu->kvm))
-			rc = -EOPNOTSUPP;
+			/* Don't exit for host interrupts. */
+			rc = vcpu->arch.sie_block->icptcode ? -EOPNOTSUPP : 0;
 		else
 			rc = kvm_handle_sie_intercept(vcpu);
 	} while (!signal_pending(current) && !rc);
diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 3d613b8..8ccd6a6 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -276,7 +276,6 @@ static void bpf_jit_noleaks(struct bpf_jit *jit, struct sock_filter *filter)
 	case BPF_S_LD_W_IND:
 	case BPF_S_LD_H_IND:
 	case BPF_S_LD_B_IND:
-	case BPF_S_LDX_B_MSH:
 	case BPF_S_LD_IMM:
 	case BPF_S_LD_MEM:
 	case BPF_S_MISC_TXA:
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index e625319..1ffc32d 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -659,8 +659,8 @@ ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
 		ret = -EPERM;
 		goto out;
 	}
-	run_sync();
  out:
+	run_sync();
 	return ret;
 
  fail_update:
diff --git a/crypto/crypto_wq.c b/crypto/crypto_wq.c
index adad92a..2f1b8d1 100644
--- a/crypto/crypto_wq.c
+++ b/crypto/crypto_wq.c
@@ -33,7 +33,7 @@ static void __exit crypto_wq_exit(void)
 	destroy_workqueue(kcrypto_wq);
 }
 
-module_init(crypto_wq_init);
+subsys_initcall(crypto_wq_init);
 module_exit(crypto_wq_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 75979cd..9d13ab1 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1169,18 +1169,18 @@ int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis)
 		return rc;
 
 	for (i = 0; i < host->n_ports; i++) {
-		const char* desc;
 		struct ahci_port_priv *pp = host->ports[i]->private_data;
 
-		/* pp is NULL for dummy ports */
-		if (pp)
-			desc = pp->irq_desc;
-		else
-			desc = dev_driver_string(host->dev);
+		/* Do not receive interrupts sent by dummy ports */
+		if (!pp) {
+			disable_irq(irq + i);
+			continue;
+		}
 
-		rc = devm_request_threaded_irq(host->dev,
-			irq + i, ahci_hw_interrupt, ahci_thread_fn, IRQF_SHARED,
-			desc, host->ports[i]);
+		rc = devm_request_threaded_irq(host->dev, irq + i,
+					       ahci_hw_interrupt,
+					       ahci_thread_fn, IRQF_SHARED,
+					       pp->irq_desc, host->ports[i]);
 		if (rc)
 			goto out_free_irqs;
 	}
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ac04311..908c07c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4765,21 +4765,26 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
 static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
 {
 	struct ata_queued_cmd *qc = NULL;
-	unsigned int i;
+	unsigned int i, tag;
 
 	/* no command while frozen */
 	if (unlikely(ap->pflags & ATA_PFLAG_FROZEN))
 		return NULL;
 
-	/* the last tag is reserved for internal command. */
-	for (i = 0; i < ATA_MAX_QUEUE - 1; i++)
-		if (!test_and_set_bit(i, &ap->qc_allocated)) {
-			qc = __ata_qc_from_tag(ap, i);
+	for (i = 0; i < ATA_MAX_QUEUE; i++) {
+		tag = (i + ap->last_tag + 1) % ATA_MAX_QUEUE;
+
+		/* the last tag is reserved for internal command. */
+		if (tag == ATA_TAG_INTERNAL)
+			continue;
+
+		if (!test_and_set_bit(tag, &ap->qc_allocated)) {
+			qc = __ata_qc_from_tag(ap, tag);
+			qc->tag = tag;
+			ap->last_tag = tag;
 			break;
 		}
-
-	if (qc)
-		qc->tag = i;
+	}
 
 	return qc;
 }
diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index 5364f97..43a4ed9 100644
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -408,12 +408,13 @@ static int pata_at91_probe(struct platform_device *pdev)
 
 	host->private_data = info;
 
-	return ata_host_activate(host, gpio_is_valid(irq) ? gpio_to_irq(irq) : 0,
-			gpio_is_valid(irq) ? ata_sff_interrupt : NULL,
-			irq_flags, &pata_at91_sht);
+	ret = ata_host_activate(host, gpio_is_valid(irq) ? gpio_to_irq(irq) : 0,
+				gpio_is_valid(irq) ? ata_sff_interrupt : NULL,
+				irq_flags, &pata_at91_sht);
+	if (ret)
+		goto err_put;
 
-	if (!ret)
-		return 0;
+	return 0;
 
 err_put:
 	clk_put(info->mck);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 0605176..8a8d611 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -52,6 +52,7 @@ static DEFINE_MUTEX(deferred_probe_mutex);
 static LIST_HEAD(deferred_probe_pending_list);
 static LIST_HEAD(deferred_probe_active_list);
 static struct workqueue_struct *deferred_wq;
+static atomic_t deferred_trigger_count = ATOMIC_INIT(0);
 
 /**
  * deferred_probe_work_func() - Retry probing devices in the active list.
@@ -135,6 +136,17 @@ static bool driver_deferred_probe_enable = false;
  * This functions moves all devices from the pending list to the active
  * list and schedules the deferred probe workqueue to process them.  It
  * should be called anytime a driver is successfully bound to a device.
+ *
+ * Note, there is a race condition in multi-threaded probe. In the case where
+ * more than one device is probing at the same time, it is possible for one
+ * probe to complete successfully while another is about to defer. If the second
+ * depends on the first, then it will get put on the pending list after the
+ * trigger event has already occured and will be stuck there.
+ *
+ * The atomic 'deferred_trigger_count' is used to determine if a successful
+ * trigger has occurred in the midst of probing a driver. If the trigger count
+ * changes in the midst of a probe, then deferred processing should be triggered
+ * again.
  */
 static void driver_deferred_probe_trigger(void)
 {
@@ -147,6 +159,7 @@ static void driver_deferred_probe_trigger(void)
 	 * into the active list so they can be retried by the workqueue
 	 */
 	mutex_lock(&deferred_probe_mutex);
+	atomic_inc(&deferred_trigger_count);
 	list_splice_tail_init(&deferred_probe_pending_list,
 			      &deferred_probe_active_list);
 	mutex_unlock(&deferred_probe_mutex);
@@ -265,6 +278,7 @@ static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
 static int really_probe(struct device *dev, struct device_driver *drv)
 {
 	int ret = 0;
+	int local_trigger_count = atomic_read(&deferred_trigger_count);
 
 	atomic_inc(&probe_count);
 	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
@@ -310,6 +324,9 @@ probe_failed:
 		/* Driver requested deferred probing */
 		dev_info(dev, "Driver %s requests probe deferral\n", drv->name);
 		driver_deferred_probe_add(dev);
+		/* Did a trigger occur while probing? Need to re-trigger if yes */
+		if (local_trigger_count != atomic_read(&deferred_trigger_count))
+			driver_deferred_probe_trigger();
 	} else if (ret != -ENODEV && ret != -ENXIO) {
 		/* driver matched but the probe failed */
 		printk(KERN_WARNING
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 04ceb7e..eb3575b 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3053,7 +3053,10 @@ static int raw_cmd_copyout(int cmd, void __user *param,
 	int ret;
 
 	while (ptr) {
-		ret = copy_to_user(param, ptr, sizeof(*ptr));
+		struct floppy_raw_cmd cmd = *ptr;
+		cmd.next = NULL;
+		cmd.kernel_data = NULL;
+		ret = copy_to_user(param, &cmd, sizeof(cmd));
 		if (ret)
 			return -EFAULT;
 		param += sizeof(struct floppy_raw_cmd);
@@ -3107,10 +3110,11 @@ loop:
 		return -ENOMEM;
 	*rcmd = ptr;
 	ret = copy_from_user(ptr, param, sizeof(*ptr));
-	if (ret)
-		return -EFAULT;
 	ptr->next = NULL;
 	ptr->buffer_length = 0;
+	ptr->kernel_data = NULL;
+	if (ret)
+		return -EFAULT;
 	param += sizeof(struct floppy_raw_cmd);
 	if (ptr->cmd_count > 33)
 			/* the command may now also take up the space
@@ -3126,7 +3130,6 @@ loop:
 	for (i = 0; i < 16; i++)
 		ptr->reply[i] = 0;
 	ptr->resultcode = 0;
-	ptr->kernel_data = NULL;
 
 	if (ptr->flags & (FD_RAW_READ | FD_RAW_WRITE)) {
 		if (ptr->length <= 0)
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 58491f1..44d31a7 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -220,6 +220,7 @@ static struct usb_device_id blacklist_table[] = {
 
 	/* Intel Bluetooth device */
 	{ USB_DEVICE(0x8087, 0x07dc), .driver_info = BTUSB_INTEL },
+	{ USB_DEVICE(0x8087, 0x0a2a), .driver_info = BTUSB_INTEL },
 
 	{ }	/* Terminating entry */
 };
diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index b2bbc41..14bc622 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -417,8 +417,6 @@ static int exynos4_local_timer_setup(struct clock_event_device *evt)
 	evt->set_mode = exynos4_tick_set_mode;
 	evt->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
 	evt->rating = 450;
-	clockevents_config_and_register(evt, clk_rate / (TICK_BASE_CNT + 1),
-					0xf, 0x7fffffff);
 
 	exynos4_mct_write(TICK_BASE_CNT, mevt->base + MCT_L_TCNTB_OFFSET);
 
@@ -435,6 +433,8 @@ static int exynos4_local_timer_setup(struct clock_event_device *evt)
 	} else {
 		enable_percpu_irq(mct_irqs[MCT_L0_IRQ], 0);
 	}
+	clockevents_config_and_register(evt, clk_rate / (TICK_BASE_CNT + 1),
+					0xf, 0x7fffffff);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index a61290e..91cbf6f 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8184,11 +8184,22 @@ intel_pipe_config_compare(struct drm_device *dev,
 	PIPE_CONF_CHECK_I(requested_mode.hdisplay);
 	PIPE_CONF_CHECK_I(requested_mode.vdisplay);
 
-	PIPE_CONF_CHECK_I(gmch_pfit.control);
-	/* pfit ratios are autocomputed by the hw on gen4+ */
-	if (INTEL_INFO(dev)->gen < 4)
-		PIPE_CONF_CHECK_I(gmch_pfit.pgm_ratios);
-	PIPE_CONF_CHECK_I(gmch_pfit.lvds_border_bits);
+	/*
+	 * FIXME: BIOS likes to set up a cloned config with lvds+external
+	 * screen. Since we don't yet re-compute the pipe config when moving
+	 * just the lvds port away to another pipe the sw tracking won't match.
+	 *
+	 * Proper atomic modesets with recomputed global state will fix this.
+	 * Until then just don't check gmch state for inherited modes.
+	 */
+	if (!PIPE_CONF_QUIRK(PIPE_CONFIG_QUIRK_INHERITED_MODE)) {
+		PIPE_CONF_CHECK_I(gmch_pfit.control);
+		/* pfit ratios are autocomputed by the hw on gen4+ */
+		if (INTEL_INFO(dev)->gen < 4)
+			PIPE_CONF_CHECK_I(gmch_pfit.pgm_ratios);
+		PIPE_CONF_CHECK_I(gmch_pfit.lvds_border_bits);
+	}
+
 	PIPE_CONF_CHECK_I(pch_pfit.pos);
 	PIPE_CONF_CHECK_I(pch_pfit.size);
 
@@ -9875,6 +9886,8 @@ static void intel_modeset_readout_hw_state(struct drm_device *dev)
 			    base.head) {
 		memset(&crtc->config, 0, sizeof(crtc->config));
 
+		crtc->config.quirks |= PIPE_CONFIG_QUIRK_INHERITED_MODE;
+
 		crtc->active = dev_priv->display.get_pipe_config(crtc,
 								 &crtc->config);
 
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index ddf7e2f..54e6a2f 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -203,7 +203,8 @@ struct intel_crtc_config {
 	 * tracked with quirk flags so that fastboot and state checker can act
 	 * accordingly.
 	 */
-#define PIPE_CONFIG_QUIRK_MODE_SYNC_FLAGS (1<<0) /* unreliable sync mode.flags */
+#define PIPE_CONFIG_QUIRK_MODE_SYNC_FLAGS	(1<<0) /* unreliable sync mode.flags */
+#define PIPE_CONFIG_QUIRK_INHERITED_MODE	(1<<1) /* mode inherited from firmware */
 	unsigned long quirks;
 
 	struct drm_display_mode requested_mode;
diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index bf96acf..986537b 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -3690,7 +3690,7 @@ int cik_sdma_ring_test(struct radeon_device *rdev,
 	tmp = 0xCAFEDEAD;
 	writel(tmp, ptr);
 
-	r = radeon_ring_lock(rdev, ring, 4);
+	r = radeon_ring_lock(rdev, ring, 5);
 	if (r) {
 		DRM_ERROR("radeon: dma failed to lock ring %d (%d).\n", ring->idx, r);
 		return r;
diff --git a/drivers/gpu/drm/radeon/r600_dpm.c b/drivers/gpu/drm/radeon/r600_dpm.c
index e5c860f..23db5bd 100644
--- a/drivers/gpu/drm/radeon/r600_dpm.c
+++ b/drivers/gpu/drm/radeon/r600_dpm.c
@@ -158,16 +158,18 @@ u32 r600_dpm_get_vblank_time(struct radeon_device *rdev)
 	u32 line_time_us, vblank_lines;
 	u32 vblank_time_us = 0xffffffff; /* if the displays are off, vblank time is max */
 
-	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
-		radeon_crtc = to_radeon_crtc(crtc);
-		if (crtc->enabled && radeon_crtc->enabled && radeon_crtc->hw_mode.clock) {
-			line_time_us = (radeon_crtc->hw_mode.crtc_htotal * 1000) /
-				radeon_crtc->hw_mode.clock;
-			vblank_lines = radeon_crtc->hw_mode.crtc_vblank_end -
-				radeon_crtc->hw_mode.crtc_vdisplay +
-				(radeon_crtc->v_border * 2);
-			vblank_time_us = vblank_lines * line_time_us;
-			break;
+	if (rdev->num_crtc && rdev->mode_info.mode_config_initialized) {
+		list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
+			radeon_crtc = to_radeon_crtc(crtc);
+			if (crtc->enabled && radeon_crtc->enabled && radeon_crtc->hw_mode.clock) {
+				line_time_us = (radeon_crtc->hw_mode.crtc_htotal * 1000) /
+					radeon_crtc->hw_mode.clock;
+				vblank_lines = radeon_crtc->hw_mode.crtc_vblank_end -
+					radeon_crtc->hw_mode.crtc_vdisplay +
+					(radeon_crtc->v_border * 2);
+				vblank_time_us = vblank_lines * line_time_us;
+				break;
+			}
 		}
 	}
 
diff --git a/drivers/gpu/drm/radeon/radeon_atpx_handler.c b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
index cbb06d7..8c44ef5 100644
--- a/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -523,6 +523,13 @@ static bool radeon_atpx_detect(void)
 		has_atpx |= (radeon_atpx_pci_probe_handle(pdev) == true);
 	}
 
+	/* some newer PX laptops mark the dGPU as a non-VGA display device */
+	while ((pdev = pci_get_class(PCI_CLASS_DISPLAY_OTHER << 8, pdev)) != NULL) {
+		vga_count++;
+
+		has_atpx |= (radeon_atpx_pci_probe_handle(pdev) == true);
+	}
+
 	if (has_atpx && vga_count == 2) {
 		acpi_get_name(radeon_atpx_priv.atpx.handle, ACPI_FULL_PATHNAME, &buffer);
 		printk(KERN_INFO "VGA switcheroo: detected switching method %s handle\n",
diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index 418ca53..04b94ae 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -1272,12 +1272,14 @@ static void radeon_pm_compute_clocks_old(struct radeon_device *rdev)
 
 	rdev->pm.active_crtcs = 0;
 	rdev->pm.active_crtc_count = 0;
-	list_for_each_entry(crtc,
-		&ddev->mode_config.crtc_list, head) {
-		radeon_crtc = to_radeon_crtc(crtc);
-		if (radeon_crtc->enabled) {
-			rdev->pm.active_crtcs |= (1 << radeon_crtc->crtc_id);
-			rdev->pm.active_crtc_count++;
+	if (rdev->num_crtc && rdev->mode_info.mode_config_initialized) {
+		list_for_each_entry(crtc,
+				    &ddev->mode_config.crtc_list, head) {
+			radeon_crtc = to_radeon_crtc(crtc);
+			if (radeon_crtc->enabled) {
+				rdev->pm.active_crtcs |= (1 << radeon_crtc->crtc_id);
+				rdev->pm.active_crtc_count++;
+			}
 		}
 	}
 
@@ -1341,12 +1343,14 @@ static void radeon_pm_compute_clocks_dpm(struct radeon_device *rdev)
 	/* update active crtc counts */
 	rdev->pm.dpm.new_active_crtcs = 0;
 	rdev->pm.dpm.new_active_crtc_count = 0;
-	list_for_each_entry(crtc,
-		&ddev->mode_config.crtc_list, head) {
-		radeon_crtc = to_radeon_crtc(crtc);
-		if (crtc->enabled) {
-			rdev->pm.dpm.new_active_crtcs |= (1 << radeon_crtc->crtc_id);
-			rdev->pm.dpm.new_active_crtc_count++;
+	if (rdev->num_crtc && rdev->mode_info.mode_config_initialized) {
+		list_for_each_entry(crtc,
+				    &ddev->mode_config.crtc_list, head) {
+			radeon_crtc = to_radeon_crtc(crtc);
+			if (crtc->enabled) {
+				rdev->pm.dpm.new_active_crtcs |= (1 << radeon_crtc->crtc_id);
+				rdev->pm.dpm.new_active_crtc_count++;
+			}
 		}
 	}
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 8b059eb..1b9aa98 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -834,14 +834,36 @@ static int vmw_cmd_dma(struct vmw_private *dev_priv,
 		SVGA3dCmdSurfaceDMA dma;
 	} *cmd;
 	int ret;
+	SVGA3dCmdSurfaceDMASuffix *suffix;
+	uint32_t bo_size;
 
 	cmd = container_of(header, struct vmw_dma_cmd, header);
+	suffix = (SVGA3dCmdSurfaceDMASuffix *)((unsigned long) &cmd->dma +
+					       header->size - sizeof(*suffix));
+
+	/* Make sure device and verifier stays in sync. */
+	if (unlikely(suffix->suffixSize != sizeof(*suffix))) {
+		DRM_ERROR("Invalid DMA suffix size.\n");
+		return -EINVAL;
+	}
+
 	ret = vmw_translate_guest_ptr(dev_priv, sw_context,
 				      &cmd->dma.guest.ptr,
 				      &vmw_bo);
 	if (unlikely(ret != 0))
 		return ret;
 
+	/* Make sure DMA doesn't cross BO boundaries. */
+	bo_size = vmw_bo->base.num_pages * PAGE_SIZE;
+	if (unlikely(cmd->dma.guest.ptr.offset > bo_size)) {
+		DRM_ERROR("Invalid DMA offset.\n");
+		return -EINVAL;
+	}
+
+	bo_size -= cmd->dma.guest.ptr.offset;
+	if (unlikely(suffix->maximumOffset > bo_size))
+		suffix->maximumOffset = bo_size;
+
 	ret = vmw_cmd_res_check(dev_priv, sw_context, vmw_res_surface,
 				user_surface_converter, &cmd->dma.host.sid,
 				NULL);
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 556a42b..0f7df9d 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -109,6 +109,8 @@ config I2C_I801
 	    Avoton (SOC)
 	    Wellsburg (PCH)
 	    Coleto Creek (PCH)
+	    Wildcat Point-LP (PCH)
+	    BayTrail (SOC)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 4ebceed..783fa75 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -59,6 +59,8 @@
   Wellsburg (PCH) MS    0x8d7e     32     hard     yes     yes     yes
   Wellsburg (PCH) MS    0x8d7f     32     hard     yes     yes     yes
   Coleto Creek (PCH)    0x23b0     32     hard     yes     yes     yes
+  Wildcat Point-LP (PCH)   0x9ca2     32     hard     yes     yes     yes
+  BayTrail (SOC)        0x0f12     32     hard     yes     yes     yes
 
   Features supported by this driver:
   Software PEC                     no
@@ -161,6 +163,7 @@
 				 STATUS_ERROR_FLAGS)
 
 /* Older devices have their ID defined in <linux/pci_ids.h> */
+#define PCI_DEVICE_ID_INTEL_BAYTRAIL_SMBUS	0x0f12
 #define PCI_DEVICE_ID_INTEL_COUGARPOINT_SMBUS	0x1c22
 #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS	0x1d22
 /* Patsburg also has three 'Integrated Device Function' SMBus controllers */
@@ -178,6 +181,7 @@
 #define PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS_MS1	0x8d7e
 #define PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS_MS2	0x8d7f
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS	0x9c22
+#define PCI_DEVICE_ID_INTEL_WILDCATPOINT_LP_SMBUS	0x9ca2
 
 struct i801_mux_config {
 	char *gpio_chip;
@@ -820,6 +824,8 @@ static DEFINE_PCI_DEVICE_TABLE(i801_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS_MS1) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS_MS2) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_COLETOCREEK_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_WILDCATPOINT_LP_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BAYTRAIL_SMBUS) },
 	{ 0, }
 };
 
diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index e73033f..54adea8 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -119,7 +119,8 @@ static ssize_t iio_scan_el_show(struct device *dev,
 	int ret;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 
-	ret = test_bit(to_iio_dev_attr(attr)->address,
+	/* Ensure ret is 0 or 1. */
+	ret = !!test_bit(to_iio_dev_attr(attr)->address,
 		       indio_dev->buffer->scan_mask);
 
 	return sprintf(buf, "%d\n", ret);
@@ -760,7 +761,8 @@ int iio_scan_mask_query(struct iio_dev *indio_dev,
 	if (!buffer->scan_mask)
 		return 0;
 
-	return test_bit(bit, buffer->scan_mask);
+	/* Ensure return value is 0 or 1. */
+	return !!test_bit(bit, buffer->scan_mask);
 };
 EXPORT_SYMBOL_GPL(iio_scan_mask_query);
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 5430b4a..0e28266 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1266,7 +1266,7 @@ isert_unmap_cmd(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
 }
 
 static void
-isert_put_cmd(struct isert_cmd *isert_cmd)
+isert_put_cmd(struct isert_cmd *isert_cmd, bool comp_err)
 {
 	struct iscsi_cmd *cmd = &isert_cmd->iscsi_cmd;
 	struct isert_conn *isert_conn = isert_cmd->conn;
@@ -1281,8 +1281,21 @@ isert_put_cmd(struct isert_cmd *isert_cmd)
 			list_del_init(&cmd->i_conn_node);
 		spin_unlock_bh(&conn->cmd_lock);
 
-		if (cmd->data_direction == DMA_TO_DEVICE)
+		if (cmd->data_direction == DMA_TO_DEVICE) {
 			iscsit_stop_dataout_timer(cmd);
+			/*
+			 * Check for special case during comp_err where
+			 * WRITE_PENDING has been handed off from core,
+			 * but requires an extra target_put_sess_cmd()
+			 * before transport_generic_free_cmd() below.
+			 */
+			if (comp_err &&
+			    cmd->se_cmd.t_state == TRANSPORT_WRITE_PENDING) {
+				struct se_cmd *se_cmd = &cmd->se_cmd;
+
+				target_put_sess_cmd(se_cmd->se_sess, se_cmd);
+			}
+		}
 
 		isert_unmap_cmd(isert_cmd, isert_conn);
 		transport_generic_free_cmd(&cmd->se_cmd, 0);
@@ -1337,7 +1350,7 @@ isert_unmap_tx_desc(struct iser_tx_desc *tx_desc, struct ib_device *ib_dev)
 
 static void
 isert_completion_put(struct iser_tx_desc *tx_desc, struct isert_cmd *isert_cmd,
-		     struct ib_device *ib_dev)
+		     struct ib_device *ib_dev, bool comp_err)
 {
 	if (isert_cmd->pdu_buf_dma != 0) {
 		pr_debug("Calling ib_dma_unmap_single for isert_cmd->pdu_buf_dma\n");
@@ -1347,7 +1360,7 @@ isert_completion_put(struct iser_tx_desc *tx_desc, struct isert_cmd *isert_cmd,
 	}
 
 	isert_unmap_tx_desc(tx_desc, ib_dev);
-	isert_put_cmd(isert_cmd);
+	isert_put_cmd(isert_cmd, comp_err);
 }
 
 static void
@@ -1402,14 +1415,14 @@ isert_do_control_comp(struct work_struct *work)
 		iscsit_tmr_post_handler(cmd, cmd->conn);
 
 		cmd->i_state = ISTATE_SENT_STATUS;
-		isert_completion_put(&isert_cmd->tx_desc, isert_cmd, ib_dev);
+		isert_completion_put(&isert_cmd->tx_desc, isert_cmd, ib_dev, false);
 		break;
 	case ISTATE_SEND_REJECT:
 		pr_debug("Got isert_do_control_comp ISTATE_SEND_REJECT: >>>\n");
 		atomic_dec(&isert_conn->post_send_buf_count);
 
 		cmd->i_state = ISTATE_SENT_STATUS;
-		isert_completion_put(&isert_cmd->tx_desc, isert_cmd, ib_dev);
+		isert_completion_put(&isert_cmd->tx_desc, isert_cmd, ib_dev, false);
 		break;
 	case ISTATE_SEND_LOGOUTRSP:
 		pr_debug("Calling iscsit_logout_post_handler >>>>>>>>>>>>>>\n");
@@ -1423,7 +1436,7 @@ isert_do_control_comp(struct work_struct *work)
 	case ISTATE_SEND_TEXTRSP:
 		atomic_dec(&isert_conn->post_send_buf_count);
 		cmd->i_state = ISTATE_SENT_STATUS;
-		isert_completion_put(&isert_cmd->tx_desc, isert_cmd, ib_dev);
+		isert_completion_put(&isert_cmd->tx_desc, isert_cmd, ib_dev, false);
 		break;
 	default:
 		pr_err("Unknown do_control_comp i_state %d\n", cmd->i_state);
@@ -1454,7 +1467,7 @@ isert_response_completion(struct iser_tx_desc *tx_desc,
 	atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
 
 	cmd->i_state = ISTATE_SENT_STATUS;
-	isert_completion_put(tx_desc, isert_cmd, ib_dev);
+	isert_completion_put(tx_desc, isert_cmd, ib_dev, false);
 }
 
 static void
@@ -1508,7 +1521,7 @@ isert_cq_tx_comp_err(struct iser_tx_desc *tx_desc, struct isert_conn *isert_conn
 	if (!isert_cmd)
 		isert_unmap_tx_desc(tx_desc, ib_dev);
 	else
-		isert_completion_put(tx_desc, isert_cmd, ib_dev);
+		isert_completion_put(tx_desc, isert_cmd, ib_dev, true);
 }
 
 static void
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index c69c816..d0da3c2 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1515,6 +1515,14 @@ static const struct dmi_system_id min_max_dmi_table[] __initconst = {
 		.driver_data = (int []){1232, 5710, 1156, 4696},
 	},
 	{
+		/* Lenovo ThinkPad T431s */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T431"),
+		},
+		.driver_data = (int []){1024, 5112, 2024, 4832},
+	},
+	{
 		/* Lenovo ThinkPad T440s */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
@@ -1523,6 +1531,14 @@ static const struct dmi_system_id min_max_dmi_table[] __initconst = {
 		.driver_data = (int []){1024, 5112, 2024, 4832},
 	},
 	{
+		/* Lenovo ThinkPad L440 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad L440"),
+		},
+		.driver_data = (int []){1024, 5112, 2024, 4832},
+	},
+	{
 		/* Lenovo ThinkPad T540p */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
@@ -1530,6 +1546,32 @@ static const struct dmi_system_id min_max_dmi_table[] __initconst = {
 		},
 		.driver_data = (int []){1024, 5056, 2058, 4832},
 	},
+	{
+		/* Lenovo ThinkPad L540 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad L540"),
+		},
+		.driver_data = (int []){1024, 5112, 2024, 4832},
+	},
+	{
+		/* Lenovo Yoga S1 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION,
+					"ThinkPad S1 Yoga"),
+		},
+		.driver_data = (int []){1232, 5710, 1156, 4696},
+	},
+	{
+		/* Lenovo ThinkPad X1 Carbon Haswell (3rd generation) */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION,
+					"ThinkPad X1 Carbon 2nd"),
+		},
+		.driver_data = (int []){1024, 5112, 2024, 4832},
+	},
 #endif
 	{ }
 };
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index ee7c503..0ebd24d 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -246,10 +246,14 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 			    bool force)
 {
 	void __iomem *reg = gic_dist_base(d) + GIC_DIST_TARGET + (gic_irq(d) & ~3);
-	unsigned int shift = (gic_irq(d) % 4) * 8;
-	unsigned int cpu = cpumask_any_and(mask_val, cpu_online_mask);
+	unsigned int cpu, shift = (gic_irq(d) % 4) * 8;
 	u32 val, mask, bit;
 
+	if (!force)
+		cpu = cpumask_any_and(mask_val, cpu_online_mask);
+	else
+		cpu = cpumask_first(mask_val);
+
 	if (cpu >= NR_GIC_CPU_IF || cpu >= nr_cpu_ids)
 		return -EINVAL;
 
diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 13299f9..ec0951a 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -560,18 +560,27 @@ static void chsc_process_sei_nt0(struct chsc_sei_nt0_area *sei_area)
 
 static void chsc_process_event_information(struct chsc_sei *sei, u64 ntsm)
 {
-	do {
+	static int ntsm_unsupported;
+
+	while (true) {
 		memset(sei, 0, sizeof(*sei));
 		sei->request.length = 0x0010;
 		sei->request.code = 0x000e;
-		sei->ntsm = ntsm;
+		if (!ntsm_unsupported)
+			sei->ntsm = ntsm;
 
 		if (chsc(sei))
 			break;
 
 		if (sei->response.code != 0x0001) {
-			CIO_CRW_EVENT(2, "chsc: sei failed (rc=%04x)\n",
-				      sei->response.code);
+			CIO_CRW_EVENT(2, "chsc: sei failed (rc=%04x, ntsm=%llx)\n",
+				      sei->response.code, sei->ntsm);
+
+			if (sei->response.code == 3 && sei->ntsm) {
+				/* Fallback for old firmware. */
+				ntsm_unsupported = 1;
+				continue;
+			}
 			break;
 		}
 
@@ -587,7 +596,10 @@ static void chsc_process_event_information(struct chsc_sei *sei, u64 ntsm)
 			CIO_CRW_EVENT(2, "chsc: unhandled nt: %d\n", sei->nt);
 			break;
 		}
-	} while (sei->u.nt0_area.flags & 0x80);
+
+		if (!(sei->u.nt0_area.flags & 0x80))
+			break;
+	}
 }
 
 /*
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 278c9fa..1822cb9 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2501,16 +2501,15 @@ static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 {
 	uint32_t cdb_phyaddr, cdb_phyaddr_hi32;
-	dma_addr_t dma_coherent_handle;
+
 	/*
 	********************************************************************
 	** here we need to tell iop 331 our freeccb.HighPart
 	** if freeccb.HighPart is not zero
 	********************************************************************
 	*/
-	dma_coherent_handle = acb->dma_coherent_handle;
-	cdb_phyaddr = (uint32_t)(dma_coherent_handle);
-	cdb_phyaddr_hi32 = (uint32_t)((cdb_phyaddr >> 16) >> 16);
+	cdb_phyaddr = lower_32_bits(acb->dma_coherent_handle);
+	cdb_phyaddr_hi32 = upper_32_bits(acb->dma_coherent_handle);
 	acb->cdb_phyaddr_hi32 = cdb_phyaddr_hi32;
 	/*
 	***********************************************************************
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 5100476..029dbbb 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -8287,7 +8287,6 @@ _scsih_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	mpt2sas_base_free_resources(ioc);
 	pci_save_state(pdev);
-	pci_disable_device(pdev);
 	pci_set_power_state(pdev, device_state);
 	return 0;
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3e21e9f..f441a40 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2552,7 +2552,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    ha->flags.enable_64bit_addressing ? "enable" :
 	    "disable");
 	ret = qla2x00_mem_alloc(ha, req_length, rsp_length, &req, &rsp);
-	if (!ret) {
+	if (ret) {
 		ql_log_pci(ql_log_fatal, pdev, 0x0031,
 		    "Failed to allocate memory for adapter, aborting.\n");
 
@@ -3454,10 +3454,10 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	else {
 		qla2x00_set_reserved_loop_ids(ha);
 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0123,
-		    "loop_id_map=%p. \n", ha->loop_id_map);
+		    "loop_id_map=%p.\n", ha->loop_id_map);
 	}
 
-	return 1;
+	return 0;
 
 fail_async_pd:
 	dma_pool_free(ha->s_dma_pool, ha->ex_init_cb, ha->ex_init_cb_dma);
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index b26f1a5..95a5d73 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -751,8 +751,12 @@ static void __virtscsi_set_affinity(struct virtio_scsi *vscsi, bool affinity)
 
 		vscsi->affinity_hint_set = true;
 	} else {
-		for (i = 0; i < vscsi->num_queues; i++)
+		for (i = 0; i < vscsi->num_queues; i++) {
+			if (!vscsi->req_vqs[i].vq)
+				continue;
+
 			virtqueue_set_affinity(vscsi->req_vqs[i].vq, -1);
+		}
 
 		vscsi->affinity_hint_set = false;
 	}
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 4bf0fc0..10354a8 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2066,8 +2066,12 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 			if (tty->ops->flush_chars)
 				tty->ops->flush_chars(tty);
 		} else {
+			struct n_tty_data *ldata = tty->disc_data;
+
 			while (nr > 0) {
+				mutex_lock(&ldata->output_lock);
 				c = tty->ops->write(tty, b, nr);
+				mutex_unlock(&ldata->output_lock);
 				if (c < 0) {
 					retval = c;
 					goto break_out;
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index d28d7af..9d5c661 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1520,7 +1520,7 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 			status = serial8250_rx_chars(up, status);
 	}
 	serial8250_modem_status(up);
-	if (status & UART_LSR_THRE)
+	if (!up->dma && (status & UART_LSR_THRE))
 		serial8250_tx_chars(up);
 
 	spin_unlock_irqrestore(&port->lock, flags);
diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 7046769..ab9096d 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -20,12 +20,15 @@ static void __dma_tx_complete(void *param)
 	struct uart_8250_port	*p = param;
 	struct uart_8250_dma	*dma = p->dma;
 	struct circ_buf		*xmit = &p->port.state->xmit;
-
-	dma->tx_running = 0;
+	unsigned long	flags;
 
 	dma_sync_single_for_cpu(dma->txchan->device->dev, dma->tx_addr,
 				UART_XMIT_SIZE, DMA_TO_DEVICE);
 
+	spin_lock_irqsave(&p->port.lock, flags);
+
+	dma->tx_running = 0;
+
 	xmit->tail += dma->tx_size;
 	xmit->tail &= UART_XMIT_SIZE - 1;
 	p->port.icount.tx += dma->tx_size;
@@ -35,6 +38,8 @@ static void __dma_tx_complete(void *param)
 
 	if (!uart_circ_empty(xmit) && !uart_tx_stopped(&p->port))
 		serial8250_tx_dma(p);
+
+	spin_unlock_irqrestore(&p->port.lock, flags);
 }
 
 static void __dma_rx_complete(void *param)
diff --git a/drivers/usb/gadget/zero.c b/drivers/usb/gadget/zero.c
index 0deb9d6..d31814c 100644
--- a/drivers/usb/gadget/zero.c
+++ b/drivers/usb/gadget/zero.c
@@ -280,7 +280,7 @@ static int __init zero_bind(struct usb_composite_dev *cdev)
 	ss_opts->isoc_interval = gzero_options.isoc_interval;
 	ss_opts->isoc_maxpacket = gzero_options.isoc_maxpacket;
 	ss_opts->isoc_mult = gzero_options.isoc_mult;
-	ss_opts->isoc_maxburst = gzero_options.isoc_maxpacket;
+	ss_opts->isoc_maxburst = gzero_options.isoc_maxburst;
 	ss_opts->bulk_buflen = gzero_options.bulk_buflen;
 
 	func_ss = usb_get_function(func_inst_ss);
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 9b9fa3e..8d5f45e 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -130,6 +130,8 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		 */
 		if (pdev->subsystem_vendor == PCI_VENDOR_ID_HP)
 			xhci->quirks |= XHCI_SPURIOUS_WAKEUP;
+
+		xhci->quirks |= XHCI_SPURIOUS_REBOOT;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
 			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
@@ -138,9 +140,7 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_RENESAS &&
-			pdev->device == 0x0015 &&
-			pdev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG &&
-			pdev->subsystem_device == 0xc0cd)
+			pdev->device == 0x0015)
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 	if (pdev->vendor == PCI_VENDOR_ID_VIA)
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 289e481..1cef7b3 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -555,6 +555,7 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 	struct xhci_generic_trb *trb;
 	struct xhci_ep_ctx *ep_ctx;
 	dma_addr_t addr;
+	u64 hw_dequeue;
 
 	ep_ring = xhci_triad_to_transfer_ring(xhci, slot_id,
 			ep_index, stream_id);
@@ -564,52 +565,54 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 				stream_id);
 		return;
 	}
-	state->new_cycle_state = 0;
-	xhci_dbg(xhci, "Finding segment containing stopped TRB.\n");
-	state->new_deq_seg = find_trb_seg(cur_td->start_seg,
-			dev->eps[ep_index].stopped_trb,
-			&state->new_cycle_state);
-	if (!state->new_deq_seg) {
-		WARN_ON(1);
-		return;
-	}
 
 	/* Dig out the cycle state saved by the xHC during the stop ep cmd */
 	xhci_dbg(xhci, "Finding endpoint context\n");
 	ep_ctx = xhci_get_ep_ctx(xhci, dev->out_ctx, ep_index);
-	state->new_cycle_state = 0x1 & le64_to_cpu(ep_ctx->deq);
+	hw_dequeue = le64_to_cpu(ep_ctx->deq);
+
+	/* Find virtual address and segment of hardware dequeue pointer */
+	state->new_deq_seg = ep_ring->deq_seg;
+	state->new_deq_ptr = ep_ring->dequeue;
+	while (xhci_trb_virt_to_dma(state->new_deq_seg, state->new_deq_ptr)
+			!= (dma_addr_t)(hw_dequeue & ~0xf)) {
+		next_trb(xhci, ep_ring, &state->new_deq_seg,
+					&state->new_deq_ptr);
+		if (state->new_deq_ptr == ep_ring->dequeue) {
+			WARN_ON(1);
+			return;
+		}
+	}
+	/*
+	 * Find cycle state for last_trb, starting at old cycle state of
+	 * hw_dequeue. If there is only one segment ring, find_trb_seg() will
+	 * return immediately and cannot toggle the cycle state if this search
+	 * wraps around, so add one more toggle manually in that case.
+	 */
+	state->new_cycle_state = hw_dequeue & 0x1;
+	if (ep_ring->first_seg == ep_ring->first_seg->next &&
+			cur_td->last_trb < state->new_deq_ptr)
+		state->new_cycle_state ^= 0x1;
 
 	state->new_deq_ptr = cur_td->last_trb;
 	xhci_dbg(xhci, "Finding segment containing last TRB in TD.\n");
 	state->new_deq_seg = find_trb_seg(state->new_deq_seg,
-			state->new_deq_ptr,
-			&state->new_cycle_state);
+			state->new_deq_ptr, &state->new_cycle_state);
 	if (!state->new_deq_seg) {
 		WARN_ON(1);
 		return;
 	}
 
+	/* Increment to find next TRB after last_trb. Cycle if appropriate. */
 	trb = &state->new_deq_ptr->generic;
 	if (TRB_TYPE_LINK_LE32(trb->field[3]) &&
 	    (trb->field[3] & cpu_to_le32(LINK_TOGGLE)))
 		state->new_cycle_state ^= 0x1;
 	next_trb(xhci, ep_ring, &state->new_deq_seg, &state->new_deq_ptr);
 
-	/*
-	 * If there is only one segment in a ring, find_trb_seg()'s while loop
-	 * will not run, and it will return before it has a chance to see if it
-	 * needs to toggle the cycle bit.  It can't tell if the stalled transfer
-	 * ended just before the link TRB on a one-segment ring, or if the TD
-	 * wrapped around the top of the ring, because it doesn't have the TD in
-	 * question.  Look for the one-segment case where stalled TRB's address
-	 * is greater than the new dequeue pointer address.
-	 */
-	if (ep_ring->first_seg == ep_ring->first_seg->next &&
-			state->new_deq_ptr < dev->eps[ep_index].stopped_trb)
-		state->new_cycle_state ^= 0x1;
+	/* Don't update the ring cycle state for the producer (us). */
 	xhci_dbg(xhci, "Cycle state = 0x%x\n", state->new_cycle_state);
 
-	/* Don't update the ring cycle state for the producer (us). */
 	xhci_dbg(xhci, "New dequeue segment = %p (virtual)\n",
 			state->new_deq_seg);
 	addr = xhci_trb_virt_to_dma(state->new_deq_seg, state->new_deq_ptr);
@@ -791,7 +794,6 @@ static void handle_stopped_endpoint(struct xhci_hcd *xhci,
 	if (list_empty(&ep->cancelled_td_list)) {
 		xhci_stop_watchdog_timer_in_irq(xhci, ep);
 		ep->stopped_td = NULL;
-		ep->stopped_trb = NULL;
 		ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
 		return;
 	}
@@ -858,11 +860,9 @@ remove_finished_td:
 		ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
 	}
 
-	/* Clear stopped_td and stopped_trb if endpoint is not halted */
-	if (!(ep->ep_state & EP_HALTED)) {
+	/* Clear stopped_td if endpoint is not halted */
+	if (!(ep->ep_state & EP_HALTED))
 		ep->stopped_td = NULL;
-		ep->stopped_trb = NULL;
-	}
 
 	/*
 	 * Drop the lock and complete the URBs in the cancelled TD list.
@@ -1830,14 +1830,12 @@ static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
 	struct xhci_virt_ep *ep = &xhci->devs[slot_id]->eps[ep_index];
 	ep->ep_state |= EP_HALTED;
 	ep->stopped_td = td;
-	ep->stopped_trb = event_trb;
 	ep->stopped_stream = stream_id;
 
 	xhci_queue_reset_ep(xhci, slot_id, ep_index);
 	xhci_cleanup_stalled_ring(xhci, td->urb->dev, ep_index);
 
 	ep->stopped_td = NULL;
-	ep->stopped_trb = NULL;
 	ep->stopped_stream = 0;
 
 	xhci_ring_cmd_db(xhci);
@@ -1919,7 +1917,6 @@ static int finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		 * the ring dequeue pointer or take this TD off any lists yet.
 		 */
 		ep->stopped_td = td;
-		ep->stopped_trb = event_trb;
 		return 0;
 	} else {
 		if (trb_comp_code == COMP_STALL) {
@@ -1931,7 +1928,6 @@ static int finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
 			 * USB class driver clear the stall later.
 			 */
 			ep->stopped_td = td;
-			ep->stopped_trb = event_trb;
 			ep->stopped_stream = ep_ring->stream_id;
 		} else if (xhci_requires_manual_halt_cleanup(xhci,
 					ep_ctx, trb_comp_code)) {
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 920e14b..0411eb9 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -395,16 +395,16 @@ static int xhci_try_enable_msi(struct usb_hcd *hcd)
 
 #else
 
-static int xhci_try_enable_msi(struct usb_hcd *hcd)
+static inline int xhci_try_enable_msi(struct usb_hcd *hcd)
 {
 	return 0;
 }
 
-static void xhci_cleanup_msix(struct xhci_hcd *xhci)
+static inline void xhci_cleanup_msix(struct xhci_hcd *xhci)
 {
 }
 
-static void xhci_msix_sync_irqs(struct xhci_hcd *xhci)
+static inline void xhci_msix_sync_irqs(struct xhci_hcd *xhci)
 {
 }
 
@@ -2962,7 +2962,6 @@ void xhci_endpoint_reset(struct usb_hcd *hcd,
 		xhci_ring_cmd_db(xhci);
 	}
 	virt_ep->stopped_td = NULL;
-	virt_ep->stopped_trb = NULL;
 	virt_ep->stopped_stream = 0;
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index a2bc934..d47a045 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -864,8 +864,6 @@ struct xhci_virt_ep {
 #define EP_GETTING_NO_STREAMS	(1 << 5)
 	/* ----  Related to URB cancellation ---- */
 	struct list_head	cancelled_td_list;
-	/* The TRB that was last reported in a stopped endpoint ring */
-	union xhci_trb		*stopped_trb;
 	struct xhci_td		*stopped_td;
 	unsigned int		stopped_stream;
 	/* Watchdog timer for stop endpoint command to cancel URBs */
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 60054e7..95dd149 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -29,6 +29,7 @@
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/serial.h>
+#include <linux/swab.h>
 #include <linux/kfifo.h>
 #include <linux/ioctl.h>
 #include <linux/firmware.h>
@@ -284,7 +285,7 @@ static int read_download_mem(struct usb_device *dev, int start_address,
 {
 	int status = 0;
 	__u8 read_length;
-	__be16 be_start_address;
+	u16 be_start_address;
 
 	dev_dbg(&dev->dev, "%s - @ %x for %d\n", __func__, start_address, length);
 
@@ -300,10 +301,14 @@ static int read_download_mem(struct usb_device *dev, int start_address,
 		if (read_length > 1) {
 			dev_dbg(&dev->dev, "%s - @ %x for %d\n", __func__, start_address, read_length);
 		}
-		be_start_address = cpu_to_be16(start_address);
+		/*
+		 * NOTE: Must use swab as wIndex is sent in little-endian
+		 *       byte order regardless of host byte order.
+		 */
+		be_start_address = swab16((u16)start_address);
 		status = ti_vread_sync(dev, UMPC_MEMORY_READ,
 					(__u16)address_type,
-					(__force __u16)be_start_address,
+					be_start_address,
 					buffer, read_length);
 
 		if (status) {
@@ -400,7 +405,7 @@ static int write_i2c_mem(struct edgeport_serial *serial,
 	struct device *dev = &serial->serial->dev->dev;
 	int status = 0;
 	int write_length;
-	__be16 be_start_address;
+	u16 be_start_address;
 
 	/* We can only send a maximum of 1 aligned byte page at a time */
 
@@ -415,11 +420,16 @@ static int write_i2c_mem(struct edgeport_serial *serial,
 		__func__, start_address, write_length);
 	usb_serial_debug_data(dev, __func__, write_length, buffer);
 
-	/* Write first page */
-	be_start_address = cpu_to_be16(start_address);
+	/*
+	 * Write first page.
+	 *
+	 * NOTE: Must use swab as wIndex is sent in little-endian byte order
+	 *       regardless of host byte order.
+	 */
+	be_start_address = swab16((u16)start_address);
 	status = ti_vsend_sync(serial->serial->dev,
 				UMPC_MEMORY_WRITE, (__u16)address_type,
-				(__force __u16)be_start_address,
+				be_start_address,
 				buffer,	write_length);
 	if (status) {
 		dev_dbg(dev, "%s - ERROR %d\n", __func__, status);
@@ -442,11 +452,16 @@ static int write_i2c_mem(struct edgeport_serial *serial,
 			__func__, start_address, write_length);
 		usb_serial_debug_data(dev, __func__, write_length, buffer);
 
-		/* Write next page */
-		be_start_address = cpu_to_be16(start_address);
+		/*
+		 * Write next page.
+		 *
+		 * NOTE: Must use swab as wIndex is sent in little-endian byte
+		 *       order regardless of host byte order.
+		 */
+		be_start_address = swab16((u16)start_address);
 		status = ti_vsend_sync(serial->serial->dev, UMPC_MEMORY_WRITE,
 				(__u16)address_type,
-				(__force __u16)be_start_address,
+				be_start_address,
 				buffer, write_length);
 		if (status) {
 			dev_err(dev, "%s - ERROR %d\n", __func__, status);
@@ -593,8 +608,8 @@ static int get_descriptor_addr(struct edgeport_serial *serial,
 		if (rom_desc->Type == desc_type)
 			return start_address;
 
-		start_address = start_address + sizeof(struct ti_i2c_desc)
-							+ rom_desc->Size;
+		start_address = start_address + sizeof(struct ti_i2c_desc) +
+						le16_to_cpu(rom_desc->Size);
 
 	} while ((start_address < TI_MAX_I2C_SIZE) && rom_desc->Type);
 
@@ -607,7 +622,7 @@ static int valid_csum(struct ti_i2c_desc *rom_desc, __u8 *buffer)
 	__u16 i;
 	__u8 cs = 0;
 
-	for (i = 0; i < rom_desc->Size; i++)
+	for (i = 0; i < le16_to_cpu(rom_desc->Size); i++)
 		cs = (__u8)(cs + buffer[i]);
 
 	if (cs != rom_desc->CheckSum) {
@@ -661,7 +676,7 @@ static int check_i2c_image(struct edgeport_serial *serial)
 			break;
 
 		if ((start_address + sizeof(struct ti_i2c_desc) +
-					rom_desc->Size) > TI_MAX_I2C_SIZE) {
+			le16_to_cpu(rom_desc->Size)) > TI_MAX_I2C_SIZE) {
 			status = -ENODEV;
 			dev_dbg(dev, "%s - structure too big, erroring out.\n", __func__);
 			break;
@@ -676,7 +691,8 @@ static int check_i2c_image(struct edgeport_serial *serial)
 			/* Read the descriptor data */
 			status = read_rom(serial, start_address +
 						sizeof(struct ti_i2c_desc),
-						rom_desc->Size, buffer);
+						le16_to_cpu(rom_desc->Size),
+						buffer);
 			if (status)
 				break;
 
@@ -685,7 +701,7 @@ static int check_i2c_image(struct edgeport_serial *serial)
 				break;
 		}
 		start_address = start_address + sizeof(struct ti_i2c_desc) +
-								rom_desc->Size;
+						le16_to_cpu(rom_desc->Size);
 
 	} while ((rom_desc->Type != I2C_DESC_TYPE_ION) &&
 				(start_address < TI_MAX_I2C_SIZE));
@@ -724,7 +740,7 @@ static int get_manuf_info(struct edgeport_serial *serial, __u8 *buffer)
 
 	/* Read the descriptor data */
 	status = read_rom(serial, start_address+sizeof(struct ti_i2c_desc),
-						rom_desc->Size, buffer);
+					le16_to_cpu(rom_desc->Size), buffer);
 	if (status)
 		goto exit;
 
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 367c7f0..f213ee9 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -234,8 +234,31 @@ static void option_instat_callback(struct urb *urb);
 #define QUALCOMM_VENDOR_ID			0x05C6
 
 #define CMOTECH_VENDOR_ID			0x16d8
-#define CMOTECH_PRODUCT_6008			0x6008
-#define CMOTECH_PRODUCT_6280			0x6280
+#define CMOTECH_PRODUCT_6001			0x6001
+#define CMOTECH_PRODUCT_CMU_300			0x6002
+#define CMOTECH_PRODUCT_6003			0x6003
+#define CMOTECH_PRODUCT_6004			0x6004
+#define CMOTECH_PRODUCT_6005			0x6005
+#define CMOTECH_PRODUCT_CGU_628A		0x6006
+#define CMOTECH_PRODUCT_CHE_628S		0x6007
+#define CMOTECH_PRODUCT_CMU_301			0x6008
+#define CMOTECH_PRODUCT_CHU_628			0x6280
+#define CMOTECH_PRODUCT_CHU_628S		0x6281
+#define CMOTECH_PRODUCT_CDU_680			0x6803
+#define CMOTECH_PRODUCT_CDU_685A		0x6804
+#define CMOTECH_PRODUCT_CHU_720S		0x7001
+#define CMOTECH_PRODUCT_7002			0x7002
+#define CMOTECH_PRODUCT_CHU_629K		0x7003
+#define CMOTECH_PRODUCT_7004			0x7004
+#define CMOTECH_PRODUCT_7005			0x7005
+#define CMOTECH_PRODUCT_CGU_629			0x7006
+#define CMOTECH_PRODUCT_CHU_629S		0x700a
+#define CMOTECH_PRODUCT_CHU_720I		0x7211
+#define CMOTECH_PRODUCT_7212			0x7212
+#define CMOTECH_PRODUCT_7213			0x7213
+#define CMOTECH_PRODUCT_7251			0x7251
+#define CMOTECH_PRODUCT_7252			0x7252
+#define CMOTECH_PRODUCT_7253			0x7253
 
 #define TELIT_VENDOR_ID				0x1bc7
 #define TELIT_PRODUCT_UC864E			0x1003
@@ -287,6 +310,7 @@ static void option_instat_callback(struct urb *urb);
 #define ALCATEL_PRODUCT_X060S_X200		0x0000
 #define ALCATEL_PRODUCT_X220_X500D		0x0017
 #define ALCATEL_PRODUCT_L100V			0x011e
+#define ALCATEL_PRODUCT_L800MA			0x0203
 
 #define PIRELLI_VENDOR_ID			0x1266
 #define PIRELLI_PRODUCT_C100_1			0x1002
@@ -349,6 +373,7 @@ static void option_instat_callback(struct urb *urb);
 #define OLIVETTI_PRODUCT_OLICARD100		0xc000
 #define OLIVETTI_PRODUCT_OLICARD145		0xc003
 #define OLIVETTI_PRODUCT_OLICARD200		0xc005
+#define OLIVETTI_PRODUCT_OLICARD500		0xc00b
 
 /* Celot products */
 #define CELOT_VENDOR_ID				0x211f
@@ -502,6 +527,10 @@ static const struct option_blacklist_info huawei_cdc12_blacklist = {
 	.reserved = BIT(1) | BIT(2),
 };
 
+static const struct option_blacklist_info net_intf0_blacklist = {
+	.reserved = BIT(0),
+};
+
 static const struct option_blacklist_info net_intf1_blacklist = {
 	.reserved = BIT(1),
 };
@@ -1035,8 +1064,47 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x0023)}, /* ONYX 3G device */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x9000)}, /* SIMCom SIM5218 */
-	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6280) }, /* BP3-USB & BP3-EXT HSDPA */
-	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6008) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6001) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CMU_300) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6003),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6004) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6005) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CGU_628A) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CHE_628S),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CMU_301),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CHU_628),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CHU_628S) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CDU_680) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CDU_685A) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CHU_720S),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_7002),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CHU_629K),
+	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_7004),
+	  .driver_info = (kernel_ulong_t)&net_intf3_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_7005) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CGU_629),
+	  .driver_info = (kernel_ulong_t)&net_intf5_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CHU_629S),
+	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CHU_720I),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_7212),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_7213),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_7251),
+	  .driver_info = (kernel_ulong_t)&net_intf1_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_7252),
+	  .driver_info = (kernel_ulong_t)&net_intf1_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_7253),
+	  .driver_info = (kernel_ulong_t)&net_intf1_blacklist },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864G) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_DUAL) },
@@ -1500,6 +1568,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = (kernel_ulong_t)&net_intf5_blacklist },
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_L100V),
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_L800MA),
+	  .driver_info = (kernel_ulong_t)&net_intf2_blacklist },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),
@@ -1545,6 +1615,9 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD200),
 		.driver_info = (kernel_ulong_t)&net_intf6_blacklist
 	},
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD500),
+		.driver_info = (kernel_ulong_t)&net_intf4_blacklist
+	},
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730 LTE USB modem.*/
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM600) },
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 968a402..7ed681a 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -136,9 +136,18 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68a2, 0)},	/* Sierra Wireless MC7710 Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68a2, 2)},	/* Sierra Wireless MC7710 NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68a2, 3)},	/* Sierra Wireless MC7710 Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68c0, 0)},	/* Sierra Wireless MC73xx Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68c0, 2)},	/* Sierra Wireless MC73xx NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68c0, 3)},	/* Sierra Wireless MC73xx Modem */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 0)},	/* Sierra Wireless EM7700 Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 2)},	/* Sierra Wireless EM7700 NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 3)},	/* Sierra Wireless EM7700 Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901f, 0)},	/* Sierra Wireless EM7355 Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901f, 2)},	/* Sierra Wireless EM7355 NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901f, 3)},	/* Sierra Wireless EM7355 Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9041, 0)},	/* Sierra Wireless MC7305/MC7355 Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9041, 2)},	/* Sierra Wireless MC7305/MC7355 NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9041, 3)},	/* Sierra Wireless MC7305/MC7355 Modem */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 0)},	/* Netgear AirCard 340U Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 2)},	/* Netgear AirCard 340U NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 3)},	/* Netgear AirCard 340U Modem */
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index cb27fcb..2b6bdf3 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1358,10 +1358,12 @@ static int usb_serial_register(struct usb_serial_driver *driver)
 static void usb_serial_deregister(struct usb_serial_driver *device)
 {
 	pr_info("USB Serial deregistering driver %s\n", device->description);
+
 	mutex_lock(&table_lock);
 	list_del(&device->driver_list);
-	usb_serial_bus_deregister(device);
 	mutex_unlock(&table_lock);
+
+	usb_serial_bus_deregister(device);
 }
 
 /**
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 2c66ddb..37990a1 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -207,24 +207,14 @@ again:
 
 void btrfs_return_ino(struct btrfs_root *root, u64 objectid)
 {
-	struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
 	struct btrfs_free_space_ctl *pinned = root->free_ino_pinned;
 
 	if (!btrfs_test_opt(root, INODE_MAP_CACHE))
 		return;
-
 again:
 	if (root->cached == BTRFS_CACHE_FINISHED) {
-		__btrfs_add_free_space(ctl, objectid, 1);
+		__btrfs_add_free_space(pinned, objectid, 1);
 	} else {
-		/*
-		 * If we are in the process of caching free ino chunks,
-		 * to avoid adding the same inode number to the free_ino
-		 * tree twice due to cross transaction, we'll leave it
-		 * in the pinned tree until a transaction is committed
-		 * or the caching work is done.
-		 */
-
 		mutex_lock(&root->fs_commit_mutex);
 		spin_lock(&root->cache_lock);
 		if (root->cached == BTRFS_CACHE_FINISHED) {
@@ -236,11 +226,7 @@ again:
 
 		start_caching(root);
 
-		if (objectid <= root->cache_progress ||
-		    objectid > root->highest_objectid)
-			__btrfs_add_free_space(ctl, objectid, 1);
-		else
-			__btrfs_add_free_space(pinned, objectid, 1);
+		__btrfs_add_free_space(pinned, objectid, 1);
 
 		mutex_unlock(&root->fs_commit_mutex);
 	}
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 319c9d2..eb48bea 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -82,7 +82,7 @@ ext4_unaligned_aio(struct inode *inode, const struct iovec *iov,
 	size_t count = iov_length(iov, nr_segs);
 	loff_t final_size = pos + count;
 
-	if (pos >= inode->i_size)
+	if (pos >= i_size_read(inode))
 		return 0;
 
 	if ((pos & blockmask) || (final_size & blockmask))
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 6625d21..3ec6f74 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -323,13 +323,14 @@ static void ext4_end_bio(struct bio *bio, int error)
 	if (error) {
 		struct inode *inode = io_end->inode;
 
-		ext4_warning(inode->i_sb, "I/O error writing to inode %lu "
+		ext4_warning(inode->i_sb, "I/O error %d writing to inode %lu "
 			     "(offset %llu size %ld starting block %llu)",
-			     inode->i_ino,
+			     error, inode->i_ino,
 			     (unsigned long long) io_end->offset,
 			     (long) io_end->size,
 			     (unsigned long long)
 			     bi_sector >> (inode->i_blkbits - 9));
+		mapping_set_error(inode->i_mapping, error);
 	}
 
 	if (io_end->flag & EXT4_IO_END_UNWRITTEN) {
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 1423c48..298e9c8 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -517,8 +517,8 @@ static void ext4_xattr_update_super_block(handle_t *handle,
 }
 
 /*
- * Release the xattr block BH: If the reference count is > 1, decrement
- * it; otherwise free the block.
+ * Release the xattr block BH: If the reference count is > 1, decrement it;
+ * otherwise free the block.
  */
 static void
 ext4_xattr_release_block(handle_t *handle, struct inode *inode,
@@ -538,16 +538,31 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 		if (ce)
 			mb_cache_entry_free(ce);
 		get_bh(bh);
+		unlock_buffer(bh);
 		ext4_free_blocks(handle, inode, bh, 0, 1,
 				 EXT4_FREE_BLOCKS_METADATA |
 				 EXT4_FREE_BLOCKS_FORGET);
-		unlock_buffer(bh);
 	} else {
 		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
 		if (ce)
 			mb_cache_entry_release(ce);
+		/*
+		 * Beware of this ugliness: Releasing of xattr block references
+		 * from different inodes can race and so we have to protect
+		 * from a race where someone else frees the block (and releases
+		 * its journal_head) before we are done dirtying the buffer. In
+		 * nojournal mode this race is harmless and we actually cannot
+		 * call ext4_handle_dirty_xattr_block() with locked buffer as
+		 * that function can call sync_dirty_buffer() so for that case
+		 * we handle the dirtying after unlocking the buffer.
+		 */
+		if (ext4_handle_valid(handle))
+			error = ext4_handle_dirty_xattr_block(handle, inode,
+							      bh);
 		unlock_buffer(bh);
-		error = ext4_handle_dirty_xattr_block(handle, inode, bh);
+		if (!ext4_handle_valid(handle))
+			error = ext4_handle_dirty_xattr_block(handle, inode,
+							      bh);
 		if (IS_SYNC(inode))
 			ext4_handle_sync(handle);
 		dquot_free_block(inode, EXT4_C2B(EXT4_SB(inode->i_sb), 1));
diff --git a/fs/locks.c b/fs/locks.c
index b27a300..ad95fbd 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1359,11 +1359,10 @@ int __break_lease(struct inode *inode, unsigned int mode)
 
 restart:
 	break_time = flock->fl_break_time;
-	if (break_time != 0) {
+	if (break_time != 0)
 		break_time -= jiffies;
-		if (break_time == 0)
-			break_time++;
-	}
+	if (break_time == 0)
+		break_time++;
 	locks_insert_block(flock, new_fl);
 	spin_unlock(&inode->i_lock);
 	error = wait_event_interruptible_timeout(new_fl->fl_wait,
diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 7f05cd1..3eaa6e3 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -637,9 +637,11 @@ static struct rpc_cred *get_backchannel_cred(struct nfs4_client *clp, struct rpc
 
 static int setup_callback_client(struct nfs4_client *clp, struct nfs4_cb_conn *conn, struct nfsd4_session *ses)
 {
+	int maxtime = max_cb_time(clp->net);
 	struct rpc_timeout	timeparms = {
-		.to_initval	= max_cb_time(clp->net),
+		.to_initval	= maxtime,
 		.to_retries	= 0,
+		.to_maxval	= maxtime,
 	};
 	struct rpc_create_args args = {
 		.net		= clp->net,
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9f15c00..e68db4d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -524,6 +524,7 @@ static inline int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_a
 extern int ftrace_arch_read_dyn_info(char *buf, int size);
 
 extern int skip_trace(unsigned long ip);
+extern void ftrace_module_init(struct module *mod);
 
 extern void ftrace_disable_daemon(void);
 extern void ftrace_enable_daemon(void);
@@ -533,6 +534,7 @@ static inline int ftrace_force_update(void) { return 0; }
 static inline void ftrace_disable_daemon(void) { }
 static inline void ftrace_enable_daemon(void) { }
 static inline void ftrace_release_mod(struct module *mod) {}
+static inline void ftrace_module_init(struct module *mod) {}
 static inline int register_ftrace_command(struct ftrace_func_command *cmd)
 {
 	return -EINVAL;
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5fa5afe..e8401d0 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -239,7 +239,40 @@ static inline int check_wakeup_irqs(void) { return 0; }
 
 extern cpumask_var_t irq_default_affinity;
 
-extern int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask);
+/* Internal implementation. Use the helpers below */
+extern int __irq_set_affinity(unsigned int irq, const struct cpumask *cpumask,
+			      bool force);
+
+/**
+ * irq_set_affinity - Set the irq affinity of a given irq
+ * @irq:	Interrupt to set affinity
+ * @mask:	cpumask
+ *
+ * Fails if cpumask does not contain an online CPU
+ */
+static inline int
+irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
+{
+	return __irq_set_affinity(irq, cpumask, false);
+}
+
+/**
+ * irq_force_affinity - Force the irq affinity of a given irq
+ * @irq:	Interrupt to set affinity
+ * @mask:	cpumask
+ *
+ * Same as irq_set_affinity, but without checking the mask against
+ * online cpus.
+ *
+ * Solely for low level cpu hotplug code, where we need to make per
+ * cpu interrupts affine before the cpu becomes online.
+ */
+static inline int
+irq_force_affinity(unsigned int irq, const struct cpumask *cpumask)
+{
+	return __irq_set_affinity(irq, cpumask, true);
+}
+
 extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index f04d3ba..04b979c 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -380,7 +380,8 @@ extern void remove_percpu_irq(unsigned int irq, struct irqaction *act);
 
 extern void irq_cpu_online(void);
 extern void irq_cpu_offline(void);
-extern int __irq_set_affinity_locked(struct irq_data *data,  const struct cpumask *cpumask);
+extern int irq_set_affinity_locked(struct irq_data *data,
+				   const struct cpumask *cpumask, bool force);
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 611d733..d0c64ab 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -773,6 +773,7 @@ struct ata_port {
 	unsigned long		qc_allocated;
 	unsigned int		qc_active;
 	int			nr_active_links; /* #links with active qcs */
+	unsigned int		last_tag;	/* track next tag hw expects */
 
 	struct ata_link		link;		/* host default link */
 	struct ata_link		*slave_link;	/* see ata_slave_link_init() */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 383319b..6de65d8 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -246,6 +246,11 @@ again:
 			goto again;
 		}
 		timer->base = new_base;
+	} else {
+		if (cpu != this_cpu && hrtimer_check_target(timer, new_base)) {
+			cpu = this_cpu;
+			goto again;
+		}
 	}
 	return new_base;
 }
@@ -581,6 +586,23 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 
 	cpu_base->expires_next.tv64 = expires_next.tv64;
 
+	/*
+	 * If a hang was detected in the last timer interrupt then we
+	 * leave the hang delay active in the hardware. We want the
+	 * system to make progress. That also prevents the following
+	 * scenario:
+	 * T1 expires 50ms from now
+	 * T2 expires 5s from now
+	 *
+	 * T1 is removed, so this code is called and would reprogram
+	 * the hardware to 5s from now. Any hrtimer_start after that
+	 * will not reprogram the hardware due to hang_detected being
+	 * set. So we'd effectivly block all timers until the T2 event
+	 * fires.
+	 */
+	if (cpu_base->hang_detected)
+		return;
+
 	if (cpu_base->expires_next.tv64 != KTIME_MAX)
 		tick_program_event(cpu_base->expires_next, 1);
 }
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 4c84746..9e31fa7 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -150,7 +150,7 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	int ret;
 
-	ret = chip->irq_set_affinity(data, mask, false);
+	ret = chip->irq_set_affinity(data, mask, force);
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
 		cpumask_copy(data->affinity, mask);
@@ -162,7 +162,8 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return ret;
 }
 
-int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
+int irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
+			    bool force)
 {
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	struct irq_desc *desc = irq_data_to_desc(data);
@@ -172,7 +173,7 @@ int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 		return -EINVAL;
 
 	if (irq_can_move_pcntxt(data)) {
-		ret = irq_do_set_affinity(data, mask, false);
+		ret = irq_do_set_affinity(data, mask, force);
 	} else {
 		irqd_set_move_pending(data);
 		irq_copy_pending(desc, mask);
@@ -187,13 +188,7 @@ int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 	return ret;
 }
 
-/**
- *	irq_set_affinity - Set the irq affinity of a given irq
- *	@irq:		Interrupt to set affinity
- *	@mask:		cpumask
- *
- */
-int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
+int __irq_set_affinity(unsigned int irq, const struct cpumask *mask, bool force)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -203,7 +198,7 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	ret =  __irq_set_affinity_locked(irq_desc_get_irq_data(desc), mask);
+	ret = irq_set_affinity_locked(irq_desc_get_irq_data(desc), mask, force);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
diff --git a/kernel/module.c b/kernel/module.c
index 2069158..0b162ec 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3288,6 +3288,9 @@ static int load_module(struct load_info *info, const char __user *uargs,
 
 	dynamic_debug_setup(info->debug, info->num_debug);
 
+	/* Ftrace init must be called in the MODULE_STATE_UNFORMED state */
+	ftrace_module_init(mod);
+
 	/* Finally it's fully formed, ready to start executing. */
 	err = complete_formation(mod, info);
 	if (err)
diff --git a/kernel/timer.c b/kernel/timer.c
index 4296d13..4addfa2 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -822,7 +822,7 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
 
 	bit = find_last_bit(&mask, BITS_PER_LONG);
 
-	mask = (1 << bit) - 1;
+	mask = (1UL << bit) - 1;
 
 	expires_limit = expires_limit & ~(mask);
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 63b236f..df6bbd3 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4237,16 +4237,11 @@ static void ftrace_init_module(struct module *mod,
 	ftrace_process_locs(mod, start, end);
 }
 
-static int ftrace_module_notify_enter(struct notifier_block *self,
-				      unsigned long val, void *data)
+void ftrace_module_init(struct module *mod)
 {
-	struct module *mod = data;
-
-	if (val == MODULE_STATE_COMING)
-		ftrace_init_module(mod, mod->ftrace_callsites,
-				   mod->ftrace_callsites +
-				   mod->num_ftrace_callsites);
-	return 0;
+	ftrace_init_module(mod, mod->ftrace_callsites,
+			   mod->ftrace_callsites +
+			   mod->num_ftrace_callsites);
 }
 
 static int ftrace_module_notify_exit(struct notifier_block *self,
@@ -4260,11 +4255,6 @@ static int ftrace_module_notify_exit(struct notifier_block *self,
 	return 0;
 }
 #else
-static int ftrace_module_notify_enter(struct notifier_block *self,
-				      unsigned long val, void *data)
-{
-	return 0;
-}
 static int ftrace_module_notify_exit(struct notifier_block *self,
 				     unsigned long val, void *data)
 {
@@ -4272,11 +4262,6 @@ static int ftrace_module_notify_exit(struct notifier_block *self,
 }
 #endif /* CONFIG_MODULES */
 
-struct notifier_block ftrace_module_enter_nb = {
-	.notifier_call = ftrace_module_notify_enter,
-	.priority = INT_MAX,	/* Run before anything that can use kprobes */
-};
-
 struct notifier_block ftrace_module_exit_nb = {
 	.notifier_call = ftrace_module_notify_exit,
 	.priority = INT_MIN,	/* Run after anything that can remove kprobes */
@@ -4313,10 +4298,6 @@ void __init ftrace_init(void)
 				  __start_mcount_loc,
 				  __stop_mcount_loc);
 
-	ret = register_module_notifier(&ftrace_module_enter_nb);
-	if (ret)
-		pr_warning("Failed to register trace ftrace module enter notifier\n");
-
 	ret = register_module_notifier(&ftrace_module_exit_nb);
 	if (ret)
 		pr_warning("Failed to register trace ftrace module exit notifier\n");
diff --git a/mm/memory.c b/mm/memory.c
index 168a090..3d64ffa 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1940,12 +1940,17 @@ int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long address, unsigned int fault_flags)
 {
 	struct vm_area_struct *vma;
+	vm_flags_t vm_flags;
 	int ret;
 
 	vma = find_extend_vma(mm, address);
 	if (!vma || address < vma->vm_start)
 		return -EFAULT;
 
+	vm_flags = (fault_flags & FAULT_FLAG_WRITE) ? VM_WRITE : VM_READ;
+	if (!(vm_flags & vma->vm_flags))
+		return -EFAULT;
+
 	ret = handle_mm_fault(mm, vma, address, fault_flags);
 	if (ret & VM_FAULT_ERROR) {
 		if (ret & VM_FAULT_OOM)
diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 8a703c3..39e8935 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -235,22 +235,23 @@ nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 	spin_unlock_bh(&queue->lock);
 }
 
-static void
-nfqnl_zcopy(struct sk_buff *to, const struct sk_buff *from, int len, int hlen)
+static int
+nfqnl_zcopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
 {
 	int i, j = 0;
 	int plen = 0; /* length of skb->head fragment */
+	int ret;
 	struct page *page;
 	unsigned int offset;
 
 	/* dont bother with small payloads */
-	if (len <= skb_tailroom(to)) {
-		skb_copy_bits(from, 0, skb_put(to, len), len);
-		return;
-	}
+	if (len <= skb_tailroom(to))
+		return skb_copy_bits(from, 0, skb_put(to, len), len);
 
 	if (hlen) {
-		skb_copy_bits(from, 0, skb_put(to, hlen), hlen);
+		ret = skb_copy_bits(from, 0, skb_put(to, hlen), hlen);
+		if (unlikely(ret))
+			return ret;
 		len -= hlen;
 	} else {
 		plen = min_t(int, skb_headlen(from), len);
@@ -268,6 +269,11 @@ nfqnl_zcopy(struct sk_buff *to, const struct sk_buff *from, int len, int hlen)
 	to->len += len + plen;
 	to->data_len += len + plen;
 
+	if (unlikely(skb_orphan_frags(from, GFP_ATOMIC))) {
+		skb_tx_error(from);
+		return -ENOMEM;
+	}
+
 	for (i = 0; i < skb_shinfo(from)->nr_frags; i++) {
 		if (!len)
 			break;
@@ -278,6 +284,8 @@ nfqnl_zcopy(struct sk_buff *to, const struct sk_buff *from, int len, int hlen)
 		j++;
 	}
 	skb_shinfo(to)->nr_frags = j;
+
+	return 0;
 }
 
 static int
@@ -374,13 +382,16 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 
 	skb = nfnetlink_alloc_skb(&init_net, size, queue->peer_portid,
 				  GFP_ATOMIC);
-	if (!skb)
+	if (!skb) {
+		skb_tx_error(entskb);
 		return NULL;
+	}
 
 	nlh = nlmsg_put(skb, 0, 0,
 			NFNL_SUBSYS_QUEUE << 8 | NFQNL_MSG_PACKET,
 			sizeof(struct nfgenmsg), 0);
 	if (!nlh) {
+		skb_tx_error(entskb);
 		kfree_skb(skb);
 		return NULL;
 	}
@@ -504,13 +515,15 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 		nla->nla_type = NFQA_PAYLOAD;
 		nla->nla_len = nla_attr_size(data_len);
 
-		nfqnl_zcopy(skb, entskb, data_len, hlen);
+		if (nfqnl_zcopy(skb, entskb, data_len, hlen))
+			goto nla_put_failure;
 	}
 
 	nlh->nlmsg_len = skb->len;
 	return skb;
 
 nla_put_failure:
+	skb_tx_error(entskb);
 	kfree_skb(skb);
 	net_err_ratelimited("nf_queue: error creating packet message\n");
 	return NULL;
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 17c5ac7..0e8b10d 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -753,6 +753,7 @@ static void vgic_dispatch_sgi(struct kvm_vcpu *vcpu, u32 reg)
 	case 0:
 		if (!target_cpus)
 			return;
+		break;
 
 	case 1:
 		target_cpus = ((1 << nrcpus) - 1) & ~(1 << vcpu_id) & 0xff;
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 2d68297..39dc5bc 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -306,7 +306,7 @@ static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq, bool line_status)
 		BUG_ON(ioapic->rtc_status.pending_eoi != 0);
 		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe,
 				ioapic->rtc_status.dest_map);
-		ioapic->rtc_status.pending_eoi = ret;
+		ioapic->rtc_status.pending_eoi = (ret < 0 ? 0 : ret);
 	} else
 		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe, NULL);
 
