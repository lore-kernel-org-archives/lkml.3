Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaDDJnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 05:43:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34452 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaDDJmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:42:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.33
Date: Fri,  4 Apr 2014 10:42:19 +0100
Message-Id: <1396604539-13632-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396604539-13632-1-git-send-email-luis.henriques@canonical.com>
References: <1396604539-13632-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index d484732..75b3eb6e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .32
+EXTRAVERSION = .33
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/arm/mach-sa1100/include/mach/collie.h b/arch/arm/mach-sa1100/include/mach/collie.h
index f33679d..50e1d85 100644
--- a/arch/arm/mach-sa1100/include/mach/collie.h
+++ b/arch/arm/mach-sa1100/include/mach/collie.h
@@ -13,6 +13,8 @@
 #ifndef __ASM_ARCH_COLLIE_H
 #define __ASM_ARCH_COLLIE_H
 
+#include "hardware.h" /* Gives GPIO_MAX */
+
 extern void locomolcd_power(int on);
 
 #define COLLIE_SCOOP_GPIO_BASE	(GPIO_MAX + 1)
diff --git a/arch/powerpc/kernel/reloc_64.S b/arch/powerpc/kernel/reloc_64.S
index b47a0e1..c712ece 100644
--- a/arch/powerpc/kernel/reloc_64.S
+++ b/arch/powerpc/kernel/reloc_64.S
@@ -81,6 +81,7 @@ _GLOBAL(relocate)
 
 6:	blr
 
+.balign 8
 p_dyn:	.llong	__dynamic_start - 0b
 p_rela:	.llong	__rela_dyn_start - 0b
 p_st:	.llong	_stext - 0b
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 095b215..60bd274 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -119,9 +119,10 @@ static inline void setup_node_to_cpumask_map(void) { }
 
 extern const struct cpumask *cpu_coregroup_mask(int cpu);
 
-#ifdef ENABLE_TOPO_DEFINES
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
+
+#ifdef ENABLE_TOPO_DEFINES
 #define topology_core_cpumask(cpu)		(per_cpu(cpu_core_map, cpu))
 #define topology_thread_cpumask(cpu)		(per_cpu(cpu_sibling_map, cpu))
 
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index d42ab17..84146d6 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -552,6 +552,10 @@ ENDPROC(early_idt_handlers)
 	/* This is global to keep gas from relaxing the jumps */
 ENTRY(early_idt_handler)
 	cld
+
+	cmpl $2,(%esp)		# X86_TRAP_NMI
+	je is_nmi		# Ignore NMI
+
 	cmpl $2,%ss:early_recursion_flag
 	je hlt_loop
 	incl %ss:early_recursion_flag
@@ -602,8 +606,9 @@ ex_entry:
 	pop %edx
 	pop %ecx
 	pop %eax
-	addl $8,%esp		/* drop vector number and error code */
 	decl %ss:early_recursion_flag
+is_nmi:
+	addl $8,%esp		/* drop vector number and error code */
 	iret
 ENDPROC(early_idt_handler)
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 94bf9cc..5680603 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -290,6 +290,9 @@ early_idt_handlers:
 ENTRY(early_idt_handler)
 	cld
 
+	cmpl $2,(%rsp)		# X86_TRAP_NMI
+	je is_nmi		# Ignore NMI
+
 	cmpl $2,early_recursion_flag(%rip)
 	jz  1f
 	incl early_recursion_flag(%rip)
@@ -344,8 +347,9 @@ ENTRY(early_idt_handler)
 	popq %rdx
 	popq %rcx
 	popq %rax
-	addq $16,%rsp		# drop vector number and error code
 	decl early_recursion_flag(%rip)
+is_nmi:
+	addq $16,%rsp		# drop vector number and error code
 	INTERRUPT_RETURN
 
 	.balign 4
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 03920a1..28a3e62 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -525,7 +525,7 @@ static void __init quirk_amd_nb_node(struct pci_dev *dev)
 		return;
 
 	pci_read_config_dword(nb_ht, 0x60, &val);
-	node = val & 7;
+	node = pcibus_to_node(dev->bus) | (val & 7);
 	/*
 	 * Some hardware may return an invalid node ID,
 	 * so check it first:
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f75af40..1e7020a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3014,10 +3014,8 @@ static int cr8_write_interception(struct vcpu_svm *svm)
 	u8 cr8_prev = kvm_get_cr8(&svm->vcpu);
 	/* instruction emulation calls kvm_set_cr8() */
 	r = cr_interception(svm);
-	if (irqchip_in_kernel(svm->vcpu.kvm)) {
-		clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+	if (irqchip_in_kernel(svm->vcpu.kvm))
 		return r;
-	}
 	if (cr8_prev <= kvm_get_cr8(&svm->vcpu))
 		return r;
 	kvm_run->exit_reason = KVM_EXIT_SET_TPR;
@@ -3573,6 +3571,8 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 	if (is_guest_mode(vcpu) && (vcpu->arch.hflags & HF_VINTR_MASK))
 		return;
 
+	clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+
 	if (irr == -1)
 		return;
 
diff --git a/arch/x86/net/bpf_jit.S b/arch/x86/net/bpf_jit.S
index 877b9a1..0149575 100644
--- a/arch/x86/net/bpf_jit.S
+++ b/arch/x86/net/bpf_jit.S
@@ -140,7 +140,7 @@ bpf_slow_path_byte_msh:
 	push	%r9;						\
 	push	SKBDATA;					\
 /* rsi already has offset */					\
-	mov	$SIZE,%ecx;	/* size */			\
+	mov	$SIZE,%edx;	/* size */			\
 	call	bpf_internal_load_pointer_neg_helper;		\
 	test	%rax,%rax;					\
 	pop	SKBDATA;					\
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f1e3b76..f268c54 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2195,6 +2195,16 @@ int ata_dev_configure(struct ata_device *dev)
 	if (rc)
 		return rc;
 
+	/* some WD SATA-1 drives have issues with LPM, turn on NOLPM for them */
+	if ((dev->horkage & ATA_HORKAGE_WD_BROKEN_LPM) &&
+	    (id[76] & 0xe) == 0x2)
+		dev->horkage |= ATA_HORKAGE_NOLPM;
+
+	if (dev->horkage & ATA_HORKAGE_NOLPM) {
+		ata_dev_warn(dev, "LPM support broken, forcing max_power\n");
+		dev->link->ap->target_lpm_policy = ATA_LPM_MAX_POWER;
+	}
+
 	/* let ACPI work its magic */
 	rc = ata_acpi_on_devcfg(dev);
 	if (rc)
@@ -4107,6 +4117,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 
 	/* Seagate Momentus SpinPoint M8 seem to have FPMDA_AA issues */
 	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
+	{ "ST1000LM024 HN-M101MBB", "2BA30001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
 
 	/* Blacklist entries taken from Silicon Image 3124/3132
 	   Windows driver .inf file - also several Linux problem reports */
@@ -4153,6 +4164,23 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "PIONEER DVD-RW  DVR-212D",	NULL,	ATA_HORKAGE_NOSETXFER },
 	{ "PIONEER DVD-RW  DVR-216D",	NULL,	ATA_HORKAGE_NOSETXFER },
 
+	/*
+	 * Some WD SATA-I drives spin up and down erratically when the link
+	 * is put into the slumber mode.  We don't have full list of the
+	 * affected devices.  Disable LPM if the device matches one of the
+	 * known prefixes and is SATA-1.  As a side effect LPM partial is
+	 * lost too.
+	 *
+	 * https://bugzilla.kernel.org/show_bug.cgi?id=57211
+	 */
+	{ "WDC WD800JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
+	{ "WDC WD1200JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
+	{ "WDC WD1600JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
+	{ "WDC WD2000JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
+	{ "WDC WD2500JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
+	{ "WDC WD3000JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
+	{ "WDC WD3200JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
+
 	/* End Marker */
 	{ }
 };
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 970c6ad..8a0e07a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -111,12 +111,14 @@ static const char *ata_lpm_policy_names[] = {
 	[ATA_LPM_MIN_POWER]	= "min_power",
 };
 
-static ssize_t ata_scsi_lpm_store(struct device *dev,
+static ssize_t ata_scsi_lpm_store(struct device *device,
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
 {
-	struct Scsi_Host *shost = class_to_shost(dev);
+	struct Scsi_Host *shost = class_to_shost(device);
 	struct ata_port *ap = ata_shost_to_port(shost);
+	struct ata_link *link;
+	struct ata_device *dev;
 	enum ata_lpm_policy policy;
 	unsigned long flags;
 
@@ -132,10 +134,20 @@ static ssize_t ata_scsi_lpm_store(struct device *dev,
 		return -EINVAL;
 
 	spin_lock_irqsave(ap->lock, flags);
+
+	ata_for_each_link(link, ap, EDGE) {
+		ata_for_each_dev(dev, &ap->link, ENABLED) {
+			if (dev->horkage & ATA_HORKAGE_NOLPM) {
+				count = -EOPNOTSUPP;
+				goto out_unlock;
+			}
+		}
+	}
+
 	ap->target_lpm_policy = policy;
 	ata_port_schedule_eh(ap);
+out_unlock:
 	spin_unlock_irqrestore(ap->lock, flags);
-
 	return count;
 }
 
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 56c6c6b..227a316 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -215,7 +215,7 @@ static u32 get_cur_val(const struct cpumask *mask)
 	switch (per_cpu(acfreq_data, cpumask_first(mask))->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
 		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
-		cmd.addr.msr.reg = MSR_IA32_PERF_STATUS;
+		cmd.addr.msr.reg = MSR_IA32_PERF_CTL;
 		break;
 	case SYSTEM_IO_CAPABLE:
 		cmd.type = SYSTEM_IO_CAPABLE;
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 73b2b65..662bec1 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -77,7 +77,8 @@ static irqreturn_t ioat_dma_do_interrupt(int irq, void *data)
 	attnstatus = readl(instance->reg_base + IOAT_ATTNSTATUS_OFFSET);
 	for_each_set_bit(bit, &attnstatus, BITS_PER_LONG) {
 		chan = ioat_chan_by_index(instance, bit);
-		tasklet_schedule(&chan->cleanup_task);
+		if (test_bit(IOAT_RUN, &chan->state))
+			tasklet_schedule(&chan->cleanup_task);
 	}
 
 	writeb(intrctrl, instance->reg_base + IOAT_INTRCTRL_OFFSET);
@@ -93,7 +94,8 @@ static irqreturn_t ioat_dma_do_interrupt_msix(int irq, void *data)
 {
 	struct ioat_chan_common *chan = data;
 
-	tasklet_schedule(&chan->cleanup_task);
+	if (test_bit(IOAT_RUN, &chan->state))
+		tasklet_schedule(&chan->cleanup_task);
 
 	return IRQ_HANDLED;
 }
@@ -116,7 +118,6 @@ void ioat_init_channel(struct ioatdma_device *device, struct ioat_chan_common *c
 	chan->timer.function = device->timer_fn;
 	chan->timer.data = data;
 	tasklet_init(&chan->cleanup_task, device->cleanup_fn, data);
-	tasklet_disable(&chan->cleanup_task);
 }
 
 /**
@@ -354,13 +355,43 @@ static int ioat1_dma_alloc_chan_resources(struct dma_chan *c)
 	writel(((u64) chan->completion_dma) >> 32,
 	       chan->reg_base + IOAT_CHANCMP_OFFSET_HIGH);
 
-	tasklet_enable(&chan->cleanup_task);
+	set_bit(IOAT_RUN, &chan->state);
 	ioat1_dma_start_null_desc(ioat);  /* give chain to dma device */
 	dev_dbg(to_dev(chan), "%s: allocated %d descriptors\n",
 		__func__, ioat->desccount);
 	return ioat->desccount;
 }
 
+void ioat_stop(struct ioat_chan_common *chan)
+{
+	struct ioatdma_device *device = chan->device;
+	struct pci_dev *pdev = device->pdev;
+	int chan_id = chan_num(chan);
+
+	/* 1/ stop irq from firing tasklets
+	 * 2/ stop the tasklet from re-arming irqs
+	 */
+	clear_bit(IOAT_RUN, &chan->state);
+
+	/* flush inflight interrupts */
+#ifdef CONFIG_PCI_MSI
+	if (pdev->msix_enabled) {
+		struct msix_entry *msix = &device->msix_entries[chan_id];
+		synchronize_irq(msix->vector);
+	} else
+#endif
+		synchronize_irq(pdev->irq);
+
+	/* flush inflight timers */
+	del_timer_sync(&chan->timer);
+
+	/* flush inflight tasklet runs */
+	tasklet_kill(&chan->cleanup_task);
+
+	/* final cleanup now that everything is quiesced and can't re-arm */
+	device->cleanup_fn((unsigned long) &chan->common);
+}
+
 /**
  * ioat1_dma_free_chan_resources - release all the descriptors
  * @chan: the channel to be cleaned
@@ -379,9 +410,7 @@ static void ioat1_dma_free_chan_resources(struct dma_chan *c)
 	if (ioat->desccount == 0)
 		return;
 
-	tasklet_disable(&chan->cleanup_task);
-	del_timer_sync(&chan->timer);
-	ioat1_cleanup(ioat);
+	ioat_stop(chan);
 
 	/* Delay 100ms after reset to allow internal DMA logic to quiesce
 	 * before removing DMA descriptor resources.
@@ -526,8 +555,11 @@ ioat1_dma_prep_memcpy(struct dma_chan *c, dma_addr_t dma_dest,
 static void ioat1_cleanup_event(unsigned long data)
 {
 	struct ioat_dma_chan *ioat = to_ioat_chan((void *) data);
+	struct ioat_chan_common *chan = &ioat->base;
 
 	ioat1_cleanup(ioat);
+	if (!test_bit(IOAT_RUN, &chan->state))
+		return;
 	writew(IOAT_CHANCTRL_RUN, ioat->base.reg_base + IOAT_CHANCTRL_OFFSET);
 }
 
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 5e8fe01..ee17c80 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -321,6 +321,7 @@ bool ioat_cleanup_preamble(struct ioat_chan_common *chan,
 			   dma_addr_t *phys_complete);
 void ioat_kobject_add(struct ioatdma_device *device, struct kobj_type *type);
 void ioat_kobject_del(struct ioatdma_device *device);
+void ioat_stop(struct ioat_chan_common *chan);
 extern const struct sysfs_ops ioat_sysfs_ops;
 extern struct ioat_sysfs_entry ioat_version_attr;
 extern struct ioat_sysfs_entry ioat_cap_attr;
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 8689576..ae39935 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -190,8 +190,11 @@ static void ioat2_cleanup(struct ioat2_dma_chan *ioat)
 void ioat2_cleanup_event(unsigned long data)
 {
 	struct ioat2_dma_chan *ioat = to_ioat2_chan((void *) data);
+	struct ioat_chan_common *chan = &ioat->base;
 
 	ioat2_cleanup(ioat);
+	if (!test_bit(IOAT_RUN, &chan->state))
+		return;
 	writew(IOAT_CHANCTRL_RUN, ioat->base.reg_base + IOAT_CHANCTRL_OFFSET);
 }
 
@@ -539,10 +542,10 @@ int ioat2_alloc_chan_resources(struct dma_chan *c)
 	ioat->issued = 0;
 	ioat->tail = 0;
 	ioat->alloc_order = order;
+	set_bit(IOAT_RUN, &chan->state);
 	spin_unlock_bh(&ioat->prep_lock);
 	spin_unlock_bh(&chan->cleanup_lock);
 
-	tasklet_enable(&chan->cleanup_task);
 	ioat2_start_null_desc(ioat);
 
 	/* check that we got off the ground */
@@ -552,7 +555,6 @@ int ioat2_alloc_chan_resources(struct dma_chan *c)
 	} while (i++ < 20 && !is_ioat_active(status) && !is_ioat_idle(status));
 
 	if (is_ioat_active(status) || is_ioat_idle(status)) {
-		set_bit(IOAT_RUN, &chan->state);
 		return 1 << ioat->alloc_order;
 	} else {
 		u32 chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
@@ -795,11 +797,8 @@ void ioat2_free_chan_resources(struct dma_chan *c)
 	if (!ioat->ring)
 		return;
 
-	tasklet_disable(&chan->cleanup_task);
-	del_timer_sync(&chan->timer);
-	device->cleanup_fn((unsigned long) c);
+	ioat_stop(chan);
 	device->reset_hw(chan);
-	clear_bit(IOAT_RUN, &chan->state);
 
 	spin_lock_bh(&chan->cleanup_lock);
 	spin_lock_bh(&ioat->prep_lock);
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index ed0e8b7..178d199 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -325,8 +325,11 @@ static void ioat3_cleanup(struct ioat2_dma_chan *ioat)
 static void ioat3_cleanup_event(unsigned long data)
 {
 	struct ioat2_dma_chan *ioat = to_ioat2_chan((void *) data);
+	struct ioat_chan_common *chan = &ioat->base;
 
 	ioat3_cleanup(ioat);
+	if (!test_bit(IOAT_RUN, &chan->state))
+		return;
 	writew(IOAT_CHANCTRL_RUN, ioat->base.reg_base + IOAT_CHANCTRL_OFFSET);
 }
 
diff --git a/drivers/firewire/core-device.c b/drivers/firewire/core-device.c
index ee901e2..05cf73b 100644
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -887,7 +887,7 @@ static int lookup_existing_device(struct device *dev, void *data)
 		old->config_rom_retries = 0;
 		fw_notice(card, "rediscovered device %s\n", dev_name(dev));
 
-		PREPARE_DELAYED_WORK(&old->work, fw_device_update);
+		old->workfn = fw_device_update;
 		fw_schedule_device_work(old, 0);
 
 		if (current_node == card->root_node)
@@ -1051,7 +1051,7 @@ static void fw_device_init(struct work_struct *work)
 	if (atomic_cmpxchg(&device->state,
 			   FW_DEVICE_INITIALIZING,
 			   FW_DEVICE_RUNNING) == FW_DEVICE_GONE) {
-		PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
+		device->workfn = fw_device_shutdown;
 		fw_schedule_device_work(device, SHUTDOWN_DELAY);
 	} else {
 		fw_notice(card, "created device %s: GUID %08x%08x, S%d00\n",
@@ -1170,13 +1170,20 @@ static void fw_device_refresh(struct work_struct *work)
 		  dev_name(&device->device), fw_rcode_string(ret));
  gone:
 	atomic_set(&device->state, FW_DEVICE_GONE);
-	PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
+	device->workfn = fw_device_shutdown;
 	fw_schedule_device_work(device, SHUTDOWN_DELAY);
  out:
 	if (node_id == card->root_node->node_id)
 		fw_schedule_bm_work(card, 0);
 }
 
+static void fw_device_workfn(struct work_struct *work)
+{
+	struct fw_device *device = container_of(to_delayed_work(work),
+						struct fw_device, work);
+	device->workfn(work);
+}
+
 void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
 {
 	struct fw_device *device;
@@ -1226,7 +1233,8 @@ void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
 		 * power-up after getting plugged in.  We schedule the
 		 * first config rom scan half a second after bus reset.
 		 */
-		INIT_DELAYED_WORK(&device->work, fw_device_init);
+		device->workfn = fw_device_init;
+		INIT_DELAYED_WORK(&device->work, fw_device_workfn);
 		fw_schedule_device_work(device, INITIAL_DELAY);
 		break;
 
@@ -1242,7 +1250,7 @@ void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
 		if (atomic_cmpxchg(&device->state,
 			    FW_DEVICE_RUNNING,
 			    FW_DEVICE_INITIALIZING) == FW_DEVICE_RUNNING) {
-			PREPARE_DELAYED_WORK(&device->work, fw_device_refresh);
+			device->workfn = fw_device_refresh;
 			fw_schedule_device_work(device,
 				device->is_local ? 0 : INITIAL_DELAY);
 		}
@@ -1257,7 +1265,7 @@ void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
 		smp_wmb();  /* update node_id before generation */
 		device->generation = card->generation;
 		if (atomic_read(&device->state) == FW_DEVICE_RUNNING) {
-			PREPARE_DELAYED_WORK(&device->work, fw_device_update);
+			device->workfn = fw_device_update;
 			fw_schedule_device_work(device, 0);
 		}
 		break;
@@ -1282,7 +1290,7 @@ void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
 		device = node->data;
 		if (atomic_xchg(&device->state,
 				FW_DEVICE_GONE) == FW_DEVICE_RUNNING) {
-			PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
+			device->workfn = fw_device_shutdown;
 			fw_schedule_device_work(device,
 				list_empty(&card->link) ? 0 : SHUTDOWN_DELAY);
 		}
diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index 638e1f7..7cff7f7 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -1014,8 +1014,6 @@ static void fwnet_write_complete(struct fw_card *card, int rcode,
 	if (rcode == RCODE_COMPLETE) {
 		fwnet_transmit_packet_done(ptask);
 	} else {
-		fwnet_transmit_packet_failed(ptask);
-
 		if (printk_timed_ratelimit(&j,  1000) || rcode != last_rcode) {
 			dev_err(&ptask->dev->netdev->dev,
 				"fwnet_write_complete failed: %x (skipped %d)\n",
@@ -1023,8 +1021,10 @@ static void fwnet_write_complete(struct fw_card *card, int rcode,
 
 			errors_skipped = 0;
 			last_rcode = rcode;
-		} else
+		} else {
 			errors_skipped++;
+		}
+		fwnet_transmit_packet_failed(ptask);
 	}
 }
 
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 1162d6b..7d4eba0 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -146,6 +146,7 @@ struct sbp2_logical_unit {
 	 */
 	int generation;
 	int retries;
+	work_func_t workfn;
 	struct delayed_work work;
 	bool has_sdev;
 	bool blocked;
@@ -864,7 +865,7 @@ static void sbp2_login(struct work_struct *work)
 	/* set appropriate retry limit(s) in BUSY_TIMEOUT register */
 	sbp2_set_busy_timeout(lu);
 
-	PREPARE_DELAYED_WORK(&lu->work, sbp2_reconnect);
+	lu->workfn = sbp2_reconnect;
 	sbp2_agent_reset(lu);
 
 	/* This was a re-login. */
@@ -918,7 +919,7 @@ static void sbp2_login(struct work_struct *work)
 	 * If a bus reset happened, sbp2_update will have requeued
 	 * lu->work already.  Reset the work from reconnect to login.
 	 */
-	PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
+	lu->workfn = sbp2_login;
 }
 
 static void sbp2_reconnect(struct work_struct *work)
@@ -952,7 +953,7 @@ static void sbp2_reconnect(struct work_struct *work)
 		    lu->retries++ >= 5) {
 			dev_err(tgt_dev(tgt), "failed to reconnect\n");
 			lu->retries = 0;
-			PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
+			lu->workfn = sbp2_login;
 		}
 		sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
 
@@ -972,6 +973,13 @@ static void sbp2_reconnect(struct work_struct *work)
 	sbp2_conditionally_unblock(lu);
 }
 
+static void sbp2_lu_workfn(struct work_struct *work)
+{
+	struct sbp2_logical_unit *lu = container_of(to_delayed_work(work),
+						struct sbp2_logical_unit, work);
+	lu->workfn(work);
+}
+
 static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
 {
 	struct sbp2_logical_unit *lu;
@@ -998,7 +1006,8 @@ static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
 	lu->blocked  = false;
 	++tgt->dont_block;
 	INIT_LIST_HEAD(&lu->orb_list);
-	INIT_DELAYED_WORK(&lu->work, sbp2_login);
+	lu->workfn = sbp2_login;
+	INIT_DELAYED_WORK(&lu->work, sbp2_lu_workfn);
 
 	list_add_tail(&lu->link, &tgt->lu_list);
 	return 0;
diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 3c4138f..9b45cef 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1048,7 +1048,7 @@ atombios_dig_transmitter_setup(struct drm_encoder *encoder, int action, uint8_t
 			}
 			if (is_dp)
 				args.v5.ucLaneNum = dp_lane_count;
-			else if (radeon_encoder->pixel_clock > 165000)
+			else if (radeon_dig_monitor_is_duallink(encoder, radeon_encoder->pixel_clock))
 				args.v5.ucLaneNum = 8;
 			else
 				args.v5.ucLaneNum = 4;
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 7296b56..743a217 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -737,6 +737,9 @@ int radeon_ttm_init(struct radeon_device *rdev)
 		DRM_ERROR("Failed initializing VRAM heap.\n");
 		return r;
 	}
+	/* Change the size here instead of the init above so only lpfn is affected */
+	radeon_ttm_set_active_vram_size(rdev, rdev->mc.visible_vram_size);
+
 	r = radeon_bo_create(rdev, 256 * 1024, PAGE_SIZE, true,
 			     RADEON_GEM_DOMAIN_VRAM,
 			     NULL, &rdev->stollen_vga_memory);
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index a414452..53de5f5 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -440,9 +440,11 @@ static int ttm_bo_handle_move_mem(struct ttm_buffer_object *bo,
 
 moved:
 	if (bo->evicted) {
-		ret = bdev->driver->invalidate_caches(bdev, bo->mem.placement);
-		if (ret)
-			pr_err("Can not flush read caches\n");
+		if (bdev->driver->invalidate_caches) {
+			ret = bdev->driver->invalidate_caches(bdev, bo->mem.placement);
+			if (ret)
+				pr_err("Can not flush read caches\n");
+		}
 		bo->evicted = false;
 	}
 
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 674e352..9b09185 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -592,8 +592,9 @@ static int __init intel_idle_init(void)
 	intel_idle_cpuidle_driver_init();
 	retval = cpuidle_register_driver(&intel_idle_driver);
 	if (retval) {
+		struct cpuidle_driver *drv = cpuidle_get_driver();
 		printk(KERN_DEBUG PREFIX "intel_idle yielding to %s",
-			cpuidle_get_driver()->name);
+			drv ? drv->name : "none");
 		return retval;
 	}
 
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 4dc7136..b0f2e9c 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -231,11 +231,22 @@ static int synaptics_identify(struct psmouse *psmouse)
  * Read touchpad resolution and maximum reported coordinates
  * Resolution is left zero if touchpad does not support the query
  */
+
+static const int *quirk_min_max;
+
 static int synaptics_resolution(struct psmouse *psmouse)
 {
 	struct synaptics_data *priv = psmouse->private;
 	unsigned char resp[3];
 
+	if (quirk_min_max) {
+		priv->x_min = quirk_min_max[0];
+		priv->x_max = quirk_min_max[1];
+		priv->y_min = quirk_min_max[2];
+		priv->y_max = quirk_min_max[3];
+		return 0;
+	}
+
 	if (SYN_ID_MAJOR(priv->identity) < 4)
 		return 0;
 
@@ -1411,10 +1422,54 @@ static const struct dmi_system_id __initconst olpc_dmi_table[] = {
 	{ }
 };
 
+static const struct dmi_system_id min_max_dmi_table[] __initconst = {
+#if defined(CONFIG_DMI)
+	{
+		/* Lenovo ThinkPad Helix */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad Helix"),
+		},
+		.driver_data = (int []){1024, 5052, 2258, 4832},
+	},
+	{
+		/* Lenovo ThinkPad X240 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X240"),
+		},
+		.driver_data = (int []){1232, 5710, 1156, 4696},
+	},
+	{
+		/* Lenovo ThinkPad T440s */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T440"),
+		},
+		.driver_data = (int []){1024, 5112, 2024, 4832},
+	},
+	{
+		/* Lenovo ThinkPad T540p */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T540"),
+		},
+		.driver_data = (int []){1024, 5056, 2058, 4832},
+	},
+#endif
+	{ }
+};
+
 void __init synaptics_module_init(void)
 {
+	const struct dmi_system_id *min_max_dmi;
+
 	impaired_toshiba_kbc = dmi_check_system(toshiba_dmi_table);
 	broken_olpc_ec = dmi_check_system(olpc_dmi_table);
+
+	min_max_dmi = dmi_first_match(min_max_dmi_table);
+	if (min_max_dmi)
+		quirk_min_max = min_max_dmi->driver_data;
 }
 
 static int __synaptics_init(struct psmouse *psmouse, bool absolute_mode)
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 732ab1a..d4c97f7 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1709,12 +1709,12 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	unsigned long timeout;
 	int err = 0;
 	bool requires_tuning_nonuhs = false;
+	unsigned long flags;
 
 	host = mmc_priv(mmc);
 
 	sdhci_runtime_pm_get(host);
-	disable_irq(host->irq);
-	spin_lock(&host->lock);
+	spin_lock_irqsave(&host->lock, flags);
 
 	ctrl = sdhci_readw(host, SDHCI_HOST_CONTROL2);
 
@@ -1734,8 +1734,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	    requires_tuning_nonuhs)
 		ctrl |= SDHCI_CTRL_EXEC_TUNING;
 	else {
-		spin_unlock(&host->lock);
-		enable_irq(host->irq);
+		spin_unlock_irqrestore(&host->lock, flags);
 		sdhci_runtime_pm_put(host);
 		return 0;
 	}
@@ -1807,15 +1806,12 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 		host->cmd = NULL;
 		host->mrq = NULL;
 
-		spin_unlock(&host->lock);
-		enable_irq(host->irq);
-
+		spin_unlock_irqrestore(&host->lock, flags);
 		/* Wait for Buffer Read Ready interrupt */
 		wait_event_interruptible_timeout(host->buf_ready_int,
 					(host->tuning_done == 1),
 					msecs_to_jiffies(50));
-		disable_irq(host->irq);
-		spin_lock(&host->lock);
+		spin_lock_irqsave(&host->lock, flags);
 
 		if (!host->tuning_done) {
 			pr_info(DRIVER_NAME ": Timeout waiting for "
@@ -1888,8 +1884,7 @@ out:
 		err = 0;
 
 	sdhci_clear_set_irqs(host, SDHCI_INT_DATA_AVAIL, ier);
-	spin_unlock(&host->lock);
-	enable_irq(host->irq);
+	spin_unlock_irqrestore(&host->lock, flags);
 	sdhci_runtime_pm_put(host);
 
 	return err;
diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 2bf507b..8a5911f 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -779,14 +779,16 @@ static void flexcan_chip_stop(struct net_device *dev)
 	struct flexcan_regs __iomem *regs = priv->base;
 	u32 reg;
 
-	/* Disable all interrupts */
-	flexcan_write(0, &regs->imask1);
-
 	/* Disable + halt module */
 	reg = flexcan_read(&regs->mcr);
 	reg |= FLEXCAN_MCR_MDIS | FLEXCAN_MCR_HALT;
 	flexcan_write(reg, &regs->mcr);
 
+	/* Disable all interrupts */
+	flexcan_write(0, &regs->imask1);
+	flexcan_write(priv->reg_ctrl_default & ~FLEXCAN_CTRL_ERR_ALL,
+		      &regs->ctrl);
+
 	flexcan_transceiver_switch(priv, 0);
 	priv->can.state = CAN_STATE_STOPPED;
 
@@ -811,12 +813,15 @@ static int flexcan_open(struct net_device *dev)
 	/* start chip and queuing */
 	err = flexcan_chip_start(dev);
 	if (err)
-		goto out_close;
+		goto out_free_irq;
+
 	napi_enable(&priv->napi);
 	netif_start_queue(dev);
 
 	return 0;
 
+ out_free_irq:
+	free_irq(dev->irq, dev);
  out_close:
 	close_candev(dev);
  out:
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 6dcd72a..8cdd91b 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -5923,8 +5923,7 @@ static int tg3_rx(struct tg3_napi *tnapi, int budget)
 
 		work_mask |= opaque_key;
 
-		if ((desc->err_vlan & RXD_ERR_MASK) != 0 &&
-		    (desc->err_vlan != RXD_ERR_ODD_NIBBLE_RCVD_MII)) {
+		if (desc->err_vlan & RXD_ERR_MASK) {
 		drop_it:
 			tg3_recycle_rx(tnapi, tpr, opaque_key,
 				       desc_idx, *post_ptr);
diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index 622bbaf..6639a63 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -2489,7 +2489,11 @@ struct tg3_rx_buffer_desc {
 #define RXD_ERR_TOO_SMALL		0x00400000
 #define RXD_ERR_NO_RESOURCES		0x00800000
 #define RXD_ERR_HUGE_FRAME		0x01000000
-#define RXD_ERR_MASK			0xffff0000
+
+#define RXD_ERR_MASK	(RXD_ERR_BAD_CRC | RXD_ERR_COLLISION |		\
+			 RXD_ERR_LINK_LOST | RXD_ERR_PHY_DECODE |	\
+			 RXD_ERR_MAC_ABRT | RXD_ERR_TOO_SMALL |		\
+			 RXD_ERR_NO_RESOURCES | RXD_ERR_HUGE_FRAME)
 
 	u32				reserved;
 	u32				opaque;
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 33a1760..62dbb0b 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -523,10 +523,21 @@ retry:
 	return rc;
 }
 
+static u64 ibmveth_encode_mac_addr(u8 *mac)
+{
+	int i;
+	u64 encoded = 0;
+
+	for (i = 0; i < ETH_ALEN; i++)
+		encoded = (encoded << 8) | mac[i];
+
+	return encoded;
+}
+
 static int ibmveth_open(struct net_device *netdev)
 {
 	struct ibmveth_adapter *adapter = netdev_priv(netdev);
-	u64 mac_address = 0;
+	u64 mac_address;
 	int rxq_entries = 1;
 	unsigned long lpar_rc;
 	int rc;
@@ -582,8 +593,7 @@ static int ibmveth_open(struct net_device *netdev)
 	adapter->rx_queue.num_slots = rxq_entries;
 	adapter->rx_queue.toggle = 1;
 
-	memcpy(&mac_address, netdev->dev_addr, netdev->addr_len);
-	mac_address = mac_address >> 16;
+	mac_address = ibmveth_encode_mac_addr(netdev->dev_addr);
 
 	rxq_desc.fields.flags_len = IBMVETH_BUF_VALID |
 					adapter->rx_queue.queue_len;
@@ -1188,8 +1198,8 @@ static void ibmveth_set_multicast_list(struct net_device *netdev)
 		/* add the addresses to the filter table */
 		netdev_for_each_mc_addr(ha, netdev) {
 			/* add the multicast address to the filter table */
-			unsigned long mcast_addr = 0;
-			memcpy(((char *)&mcast_addr)+2, ha->addr, 6);
+			u64 mcast_addr;
+			mcast_addr = ibmveth_encode_mac_addr(ha->addr);
 			lpar_rc = h_multicast_ctrl(adapter->vdev->unit_address,
 						   IbmVethMcastAddFilter,
 						   mcast_addr);
@@ -1374,9 +1384,6 @@ static int __devinit ibmveth_probe(struct vio_dev *dev,
 
 	netif_napi_add(netdev, &adapter->napi, ibmveth_poll, 16);
 
-	adapter->mac_addr = 0;
-	memcpy(&adapter->mac_addr, mac_addr_p, 6);
-
 	netdev->irq = dev->irq;
 	netdev->netdev_ops = &ibmveth_netdev_ops;
 	netdev->ethtool_ops = &netdev_ethtool_ops;
@@ -1385,7 +1392,7 @@ static int __devinit ibmveth_probe(struct vio_dev *dev,
 		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 	netdev->features |= netdev->hw_features;
 
-	memcpy(netdev->dev_addr, &adapter->mac_addr, netdev->addr_len);
+	memcpy(netdev->dev_addr, mac_addr_p, ETH_ALEN);
 
 	for (i = 0; i < IBMVETH_NUM_BUFF_POOLS; i++) {
 		struct kobject *kobj = &adapter->rx_buff_pool[i].kobj;
diff --git a/drivers/net/ethernet/ibm/ibmveth.h b/drivers/net/ethernet/ibm/ibmveth.h
index 43a794f..48639ba 100644
--- a/drivers/net/ethernet/ibm/ibmveth.h
+++ b/drivers/net/ethernet/ibm/ibmveth.h
@@ -139,7 +139,6 @@ struct ibmveth_adapter {
     struct napi_struct napi;
     struct net_device_stats stats;
     unsigned int mcastFilterSize;
-    unsigned long mac_addr;
     void * buffer_list_addr;
     void * filter_list_addr;
     dma_addr_t buffer_list_dma;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 858a8da..af3411f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1124,7 +1124,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 	/* If we can receive ANY GSO packets, we must allocate large ones. */
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
 	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6) ||
-	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_ECN))
+	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_ECN) ||
+	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_UFO))
 		vi->big_packets = true;
 
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 3f04ba0..d43df93 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1729,11 +1729,20 @@ vmxnet3_netpoll(struct net_device *netdev)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
-	if (adapter->intr.mask_mode == VMXNET3_IMM_ACTIVE)
-		vmxnet3_disable_all_intrs(adapter);
-
-	vmxnet3_do_poll(adapter, adapter->rx_queue[0].rx_ring[0].size);
-	vmxnet3_enable_all_intrs(adapter);
+	switch (adapter->intr.type) {
+#ifdef CONFIG_PCI_MSI
+	case VMXNET3_IT_MSIX: {
+		int i;
+		for (i = 0; i < adapter->num_rx_queues; i++)
+			vmxnet3_msix_rx(0, &adapter->rx_queue[i]);
+		break;
+	}
+#endif
+	case VMXNET3_IT_MSI:
+	default:
+		vmxnet3_intr(0, adapter->netdev);
+		break;
+	}
 
 }
 #endif	/* CONFIG_NET_POLL_CONTROLLER */
diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index 1d6658e..9c7eaa6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -55,7 +55,7 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3376605e, 0x33795d5e},
 	{0x00009e18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
-	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
+	{0x00009e20, 0x000003a5, 0x000003a5, 0x000003a5, 0x000003a5},
 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
 	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcfd5c782, 0xcfd5c282},
 	{0x00009e44, 0x62321e27, 0x62321e27, 0xfe291e27, 0xfe291e27},
@@ -94,7 +94,7 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	{0x0000ae04, 0x001c0000, 0x001c0000, 0x001c0000, 0x00100000},
 	{0x0000ae18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000ae1c, 0x0000019c, 0x0000019c, 0x0000019c, 0x0000019c},
-	{0x0000ae20, 0x000001b5, 0x000001b5, 0x000001ce, 0x000001ce},
+	{0x0000ae20, 0x000001a6, 0x000001a6, 0x000001aa, 0x000001aa},
 	{0x0000b284, 0x00000000, 0x00000000, 0x00000550, 0x00000550},
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 63ce4cf..1f5a5d0 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1242,14 +1242,16 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 	for (tidno = 0, tid = &an->tid[tidno];
 	     tidno < WME_NUM_TID; tidno++, tid++) {
 
-		if (!tid->sched)
-			continue;
-
 		ac = tid->ac;
 		txq = ac->txq;
 
 		ath_txq_lock(sc, txq);
 
+		if (!tid->sched) {
+			ath_txq_unlock(sc, txq);
+			continue;
+		}
+
 		buffered = !skb_queue_empty(&tid->buf_q);
 
 		tid->sched = false;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index dff75ea..f896ca6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -618,6 +618,7 @@ void iwl_deactivate_station(struct iwl_priv *priv, const u8 sta_id,
 			sizeof(priv->tid_data[sta_id][tid]));
 
 	priv->stations[sta_id].used &= ~IWL_STA_DRIVER_ACTIVE;
+	priv->stations[sta_id].used &= ~IWL_STA_UCODE_INPROGRESS;
 
 	priv->num_stations--;
 
diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index fe8ebfe..d5ad81d 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -340,8 +340,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 		ht_cap->header.len =
 				cpu_to_le16(sizeof(struct ieee80211_ht_cap));
 		memcpy((u8 *) ht_cap + sizeof(struct mwifiex_ie_types_header),
-		       (u8 *) bss_desc->bcn_ht_cap +
-		       sizeof(struct ieee_types_header),
+		       (u8 *)bss_desc->bcn_ht_cap,
 		       le16_to_cpu(ht_cap->header.len));
 
 		mwifiex_fill_cap_info(priv, radio_type, ht_cap);
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 7fda0ab..11c3db1 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -511,13 +511,6 @@ static int mwifiex_usb_resume(struct usb_interface *intf)
 						   MWIFIEX_BSS_ROLE_ANY),
 				  MWIFIEX_ASYNC_CMD);
 
-#ifdef CONFIG_PM
-	/* Resume handler may be called due to remote wakeup,
-	 * force to exit suspend anyway
-	 */
-	usb_disable_autosuspend(card->udev);
-#endif /* CONFIG_PM */
-
 	return 0;
 }
 
@@ -576,7 +569,6 @@ static struct usb_driver mwifiex_usb_driver = {
 	.id_table = mwifiex_usb_table,
 	.suspend = mwifiex_usb_suspend,
 	.resume = mwifiex_usb_resume,
-	.supports_autosuspend = 1,
 };
 
 static int mwifiex_usb_tx_init(struct mwifiex_adapter *adapter)
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 82a1cac..5de755b 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -583,7 +583,7 @@ static void p54_rx_stats(struct p54_common *priv, struct sk_buff *skb)
 	chan = priv->curchan;
 	if (chan) {
 		struct survey_info *survey = &priv->survey[chan->hw_value];
-		survey->noise = clamp_t(s8, priv->noise, -128, 127);
+		survey->noise = clamp(priv->noise, -128, 127);
 		survey->channel_time = priv->survey_raw.active;
 		survey->channel_time_tx = priv->survey_raw.tx;
 		survey->channel_time_busy = priv->survey_raw.tx +
diff --git a/drivers/of/address.c b/drivers/of/address.c
index 7e262a6..3edc6dd 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -98,8 +98,13 @@ static unsigned int of_bus_default_get_flags(const __be32 *addr)
 
 static int of_bus_pci_match(struct device_node *np)
 {
-	/* "vci" is for the /chaos bridge on 1st-gen PCI powermacs */
-	return !strcmp(np->type, "pci") || !strcmp(np->type, "vci");
+	/*
+ 	 * "pciex" is PCI Express
+	 * "vci" is for the /chaos bridge on 1st-gen PCI powermacs
+	 * "ht" is hypertransport
+	 */
+	return !strcmp(np->type, "pci") || !strcmp(np->type, "pciex") ||
+		!strcmp(np->type, "vci") || !strcmp(np->type, "ht");
 }
 
 static void of_bus_pci_count_cells(struct device_node *np,
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 42b9983..bf0df20 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1145,6 +1145,9 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
 		return err;
 	pci_fixup_device(pci_fixup_enable, dev);
 
+	if (dev->msi_enabled || dev->msix_enabled)
+		return 0;
+
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (pin) {
 		pci_read_config_word(dev, PCI_COMMAND, &cmd);
diff --git a/drivers/rapidio/devices/tsi721.h b/drivers/rapidio/devices/tsi721.h
index 59de9d7..36147ee 100644
--- a/drivers/rapidio/devices/tsi721.h
+++ b/drivers/rapidio/devices/tsi721.h
@@ -669,6 +669,7 @@ struct tsi721_bdma_chan {
 	struct list_head	free_list;
 	dma_cookie_t		completed_cookie;
 	struct tasklet_struct	tasklet;
+	bool			active;
 };
 
 #endif /* CONFIG_RAPIDIO_DMA_ENGINE */
diff --git a/drivers/rapidio/devices/tsi721_dma.c b/drivers/rapidio/devices/tsi721_dma.c
index 92e06a5..96f77a6 100644
--- a/drivers/rapidio/devices/tsi721_dma.c
+++ b/drivers/rapidio/devices/tsi721_dma.c
@@ -206,8 +206,8 @@ void tsi721_bdma_handler(struct tsi721_bdma_chan *bdma_chan)
 {
 	/* Disable BDMA channel interrupts */
 	iowrite32(0, bdma_chan->regs + TSI721_DMAC_INTE);
-
-	tasklet_schedule(&bdma_chan->tasklet);
+	if (bdma_chan->active)
+		tasklet_schedule(&bdma_chan->tasklet);
 }
 
 #ifdef CONFIG_PCI_MSI
@@ -562,7 +562,7 @@ static int tsi721_alloc_chan_resources(struct dma_chan *dchan)
 	}
 #endif /* CONFIG_PCI_MSI */
 
-	tasklet_enable(&bdma_chan->tasklet);
+	bdma_chan->active = true;
 	tsi721_bdma_interrupt_enable(bdma_chan, 1);
 
 	return bdma_chan->bd_num - 1;
@@ -576,9 +576,7 @@ err_out:
 static void tsi721_free_chan_resources(struct dma_chan *dchan)
 {
 	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
-#ifdef CONFIG_PCI_MSI
 	struct tsi721_device *priv = to_tsi721(dchan->device);
-#endif
 	LIST_HEAD(list);
 
 	dev_dbg(dchan->device->dev, "%s: Entry\n", __func__);
@@ -589,14 +587,25 @@ static void tsi721_free_chan_resources(struct dma_chan *dchan)
 	BUG_ON(!list_empty(&bdma_chan->active_list));
 	BUG_ON(!list_empty(&bdma_chan->queue));
 
-	tasklet_disable(&bdma_chan->tasklet);
+	tsi721_bdma_interrupt_enable(bdma_chan, 0);
+	bdma_chan->active = false;
+
+#ifdef CONFIG_PCI_MSI
+	if (priv->flags & TSI721_USING_MSIX) {
+		synchronize_irq(priv->msix[TSI721_VECT_DMA0_DONE +
+					   bdma_chan->id].vector);
+		synchronize_irq(priv->msix[TSI721_VECT_DMA0_INT +
+					   bdma_chan->id].vector);
+	} else
+#endif
+	synchronize_irq(priv->pdev->irq);
+
+	tasklet_kill(&bdma_chan->tasklet);
 
 	spin_lock_bh(&bdma_chan->lock);
 	list_splice_init(&bdma_chan->free_list, &list);
 	spin_unlock_bh(&bdma_chan->lock);
 
-	tsi721_bdma_interrupt_enable(bdma_chan, 0);
-
 #ifdef CONFIG_PCI_MSI
 	if (priv->flags & TSI721_USING_MSIX) {
 		free_irq(priv->msix[TSI721_VECT_DMA0_DONE +
@@ -790,6 +799,7 @@ int __devinit tsi721_register_dma(struct tsi721_device *priv)
 		bdma_chan->dchan.cookie = 1;
 		bdma_chan->dchan.chan_id = i;
 		bdma_chan->id = i;
+		bdma_chan->active = false;
 
 		spin_lock_init(&bdma_chan->lock);
 
@@ -799,7 +809,6 @@ int __devinit tsi721_register_dma(struct tsi721_device *priv)
 
 		tasklet_init(&bdma_chan->tasklet, tsi721_dma_tasklet,
 			     (unsigned long)bdma_chan);
-		tasklet_disable(&bdma_chan->tasklet);
 		list_add_tail(&bdma_chan->dchan.device_node,
 			      &mport->dma.channels);
 	}
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 9ab58e0..35de7e6 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -311,9 +311,8 @@ static inline struct Scsi_Host *to_shost(struct isci_host *ihost)
 }
 
 #define for_each_isci_host(id, ihost, pdev) \
-	for (id = 0, ihost = to_pci_info(pdev)->hosts[id]; \
-	     id < ARRAY_SIZE(to_pci_info(pdev)->hosts) && ihost; \
-	     ihost = to_pci_info(pdev)->hosts[++id])
+	for (id = 0; id < SCI_MAX_CONTROLLERS && \
+	     (ihost = to_pci_info(pdev)->hosts[id]); id++)
 
 static inline void wait_for_start(struct isci_host *ihost)
 {
diff --git a/drivers/scsi/isci/port_config.c b/drivers/scsi/isci/port_config.c
index cd962da..5017bde 100644
--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -615,13 +615,6 @@ static void sci_apc_agent_link_up(struct isci_host *ihost,
 					  SCIC_SDS_APC_WAIT_LINK_UP_NOTIFICATION);
 	} else {
 		/* the phy is already the part of the port */
-		u32 port_state = iport->sm.current_state_id;
-
-		/* if the PORT'S state is resetting then the link up is from
-		 * port hard reset in this case, we need to tell the port
-		 * that link up is recieved
-		 */
-		BUG_ON(port_state != SCI_PORT_RESETTING);
 		port_agent->phy_ready_mask |= 1 << phy_index;
 		sci_port_link_up(iport, iphy);
 	}
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index efd9e9e..5aaa914 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -801,7 +801,7 @@ int isci_task_I_T_nexus_reset(struct domain_device *dev)
 		/* XXX: need to cleanup any ireqs targeting this
 		 * domain_device
 		 */
-		ret = TMF_RESP_FUNC_COMPLETE;
+		ret = -ENODEV;
 		goto out;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 39007f5..46ebff2 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2656,8 +2656,7 @@ struct qla_hw_data {
 				IS_QLA25XX(ha) || IS_QLA81XX(ha) || \
 				IS_QLA82XX(ha) || IS_QLA83XX(ha))
 #define IS_MSIX_NACK_CAPABLE(ha) (IS_QLA81XX(ha) || IS_QLA83XX(ha))
-#define IS_NOPOLLING_TYPE(ha)	((IS_QLA25XX(ha) || IS_QLA81XX(ha) || \
-			IS_QLA83XX(ha)) && (ha)->flags.msix_enabled)
+#define IS_NOPOLLING_TYPE(ha)	(IS_QLA81XX(ha) && (ha)->flags.msix_enabled)
 #define IS_FAC_REQUIRED(ha)	(IS_QLA81XX(ha) || IS_QLA83XX(ha))
 #define IS_NOCACHE_VPD_TYPE(ha)	(IS_QLA81XX(ha) || IS_QLA83XX(ha))
 #define IS_ALOGIO_CAPABLE(ha)	(IS_QLA23XX(ha) || IS_FWI2_CAPABLE(ha))
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 9f4e560..65f566b 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1141,6 +1141,9 @@ static void storvsc_device_destroy(struct scsi_device *sdevice)
 {
 	struct stor_mem_pools *memp = sdevice->hostdata;
 
+	if (!memp)
+		return;
+
 	mempool_destroy(memp->request_mempool);
 	kmem_cache_destroy(memp->request_pool);
 	kfree(memp);
diff --git a/drivers/staging/speakup/i18n.c b/drivers/staging/speakup/i18n.c
index c211943..7656014 100644
--- a/drivers/staging/speakup/i18n.c
+++ b/drivers/staging/speakup/i18n.c
@@ -390,7 +390,7 @@ static struct msg_group_t all_groups[] = {
 
 static const  int num_groups = sizeof(all_groups) / sizeof(struct msg_group_t);
 
-char *msg_get(enum msg_index_t index)
+char *spk_msg_get(enum msg_index_t index)
 {
 	char *ch;
 
@@ -540,7 +540,7 @@ static int fmt_validate(char *template, char *user)
  * -EINVAL -  Invalid format specifiers in formatted message or illegal index.
  * -ENOMEM -  Unable to allocate memory.
 */
-ssize_t msg_set(enum msg_index_t index, char *text, size_t length)
+ssize_t spk_msg_set(enum msg_index_t index, char *text, size_t length)
 {
 	int rc = 0;
 	char *newstr = NULL;
@@ -575,7 +575,7 @@ ssize_t msg_set(enum msg_index_t index, char *text, size_t length)
  * Find a message group, given its name.  Return a pointer to the structure
  * if found, or NULL otherwise.
 */
-struct msg_group_t *find_msg_group(const char *group_name)
+struct msg_group_t *spk_find_msg_group(const char *group_name)
 {
 	struct msg_group_t *group = NULL;
 	int i;
@@ -589,7 +589,7 @@ struct msg_group_t *find_msg_group(const char *group_name)
 	return group;
 }
 
-void reset_msg_group(struct msg_group_t *group)
+void spk_reset_msg_group(struct msg_group_t *group)
 {
 	unsigned long flags;
 	enum msg_index_t i;
@@ -605,14 +605,14 @@ void reset_msg_group(struct msg_group_t *group)
 }
 
 /* Called at initialization time, to establish default messages. */
-void initialize_msgs(void)
+void spk_initialize_msgs(void)
 {
 	memcpy(speakup_msgs, speakup_default_msgs,
 		sizeof(speakup_default_msgs));
 }
 
 /* Free user-supplied strings when module is unloaded: */
-void free_user_msgs(void)
+void spk_free_user_msgs(void)
 {
 	enum msg_index_t index;
 	unsigned long flags;
diff --git a/drivers/staging/speakup/i18n.h b/drivers/staging/speakup/i18n.h
index 65caa80..dd338f4 100644
--- a/drivers/staging/speakup/i18n.h
+++ b/drivers/staging/speakup/i18n.h
@@ -218,11 +218,11 @@ struct msg_group_t {
 	enum msg_index_t end;
 };
 
-extern char *msg_get(enum msg_index_t index);
-extern ssize_t msg_set(enum msg_index_t index, char *text, size_t length);
-extern struct msg_group_t *find_msg_group(const char *group_name);
-extern void reset_msg_group(struct msg_group_t *group);
-extern void initialize_msgs(void);
-extern void free_user_msgs(void);
+extern char *spk_msg_get(enum msg_index_t index);
+extern ssize_t spk_msg_set(enum msg_index_t index, char *text, size_t length);
+extern struct msg_group_t *spk_find_msg_group(const char *group_name);
+extern void spk_reset_msg_group(struct msg_group_t *group);
+extern void spk_initialize_msgs(void);
+extern void spk_free_user_msgs(void);
 
 #endif
diff --git a/drivers/staging/speakup/keyhelp.c b/drivers/staging/speakup/keyhelp.c
index 170f388..4c584ec 100644
--- a/drivers/staging/speakup/keyhelp.c
+++ b/drivers/staging/speakup/keyhelp.c
@@ -115,10 +115,10 @@ static void say_key(int key)
 	key &= 0xff;
 	for (i = 0; i < 6; i++) {
 		if (state & masks[i])
-			synth_printf(" %s", msg_get(MSG_STATES_START + i));
+			synth_printf(" %s", spk_msg_get(MSG_STATES_START + i));
 	}
 	if ((key > 0) && (key <= num_key_names))
-		synth_printf(" %s\n", msg_get(MSG_KEYNAMES_START + (key - 1)));
+		synth_printf(" %s\n", spk_msg_get(MSG_KEYNAMES_START + (key - 1)));
 }
 
 static int help_init(void)
@@ -126,9 +126,9 @@ static int help_init(void)
 	char start = SPACE;
 	int i;
 	int num_funcs = MSG_FUNCNAMES_END - MSG_FUNCNAMES_START + 1;
-state_tbl = our_keys[0]+SHIFT_TBL_SIZE+2;
+state_tbl = spk_our_keys[0]+SHIFT_TBL_SIZE+2;
 	for (i = 0; i < num_funcs; i++) {
-		char *cur_funcname = msg_get(MSG_FUNCNAMES_START + i);
+		char *cur_funcname = spk_msg_get(MSG_FUNCNAMES_START + i);
 		if (start == *cur_funcname)
 			continue;
 		start = *cur_funcname;
@@ -137,7 +137,7 @@ state_tbl = our_keys[0]+SHIFT_TBL_SIZE+2;
 	return 0;
 }
 
-int handle_help(struct vc_data *vc, u_char type, u_char ch, u_short key)
+int spk_handle_help(struct vc_data *vc, u_char type, u_char ch, u_short key)
 {
 	int i, n;
 	char *name;
@@ -147,15 +147,15 @@ int handle_help(struct vc_data *vc, u_char type, u_char ch, u_short key)
 		help_init();
 	if (type == KT_LATIN) {
 		if (ch == SPACE) {
-			special_handler = NULL;
-			synth_printf("%s\n", msg_get(MSG_LEAVING_HELP));
+			spk_special_handler = NULL;
+			synth_printf("%s\n", spk_msg_get(MSG_LEAVING_HELP));
 			return 1;
 		}
 		ch |= 32; /* lower case */
 		if (ch < 'a' || ch > 'z')
 			return -1;
 		if (letter_offsets[ch-'a'] == -1) {
-			synth_printf(msg_get(MSG_NO_COMMAND), ch);
+			synth_printf(spk_msg_get(MSG_NO_COMMAND), ch);
 			synth_printf("\n");
 			return 1;
 		}
@@ -169,47 +169,47 @@ int handle_help(struct vc_data *vc, u_char type, u_char ch, u_short key)
 			cur_item--;
 		else
 			return -1;
-	} else if (type == KT_SPKUP && ch == SPEAKUP_HELP && !special_handler) {
-		special_handler = handle_help;
-		synth_printf("%s\n", msg_get(MSG_HELP_INFO));
+	} else if (type == KT_SPKUP && ch == SPEAKUP_HELP && !spk_special_handler) {
+		spk_special_handler = spk_handle_help;
+		synth_printf("%s\n", spk_msg_get(MSG_HELP_INFO));
 		build_key_data(); /* rebuild each time in case new mapping */
 		return 1;
 	} else {
 		name = NULL;
 		if ((type != KT_SPKUP) && (key > 0) && (key <= num_key_names)) {
 			synth_printf("%s\n",
-				msg_get(MSG_KEYNAMES_START + key-1));
+				spk_msg_get(MSG_KEYNAMES_START + key-1));
 			return 1;
 		}
 		for (i = 0; funcvals[i] != 0 && !name; i++) {
 			if (ch == funcvals[i])
-				name = msg_get(MSG_FUNCNAMES_START + i);
+				name = spk_msg_get(MSG_FUNCNAMES_START + i);
 		}
 		if (!name)
 			return -1;
-		kp = our_keys[key]+1;
+		kp = spk_our_keys[key]+1;
 		for (i = 0; i < nstates; i++) {
 			if (ch == kp[i])
 				break;
 		}
 		key += (state_tbl[i] << 8);
 		say_key(key);
-		synth_printf(msg_get(MSG_KEYDESC), name);
+		synth_printf(spk_msg_get(MSG_KEYDESC), name);
 		synth_printf("\n");
 		return 1;
 	}
-	name = msg_get(MSG_FUNCNAMES_START + cur_item);
+	name = spk_msg_get(MSG_FUNCNAMES_START + cur_item);
 	func = funcvals[cur_item];
 	synth_printf("%s", name);
 	if (key_offsets[func] == 0) {
-		synth_printf(" %s\n", msg_get(MSG_IS_UNASSIGNED));
+		synth_printf(" %s\n", spk_msg_get(MSG_IS_UNASSIGNED));
 		return 1;
 	}
 	p_keys = key_data + key_offsets[func];
 	for (n = 0; p_keys[n]; n++) {
 		val = p_keys[n];
 		if (n > 0)
-			synth_printf("%s ", msg_get(MSG_DISJUNCTION));
+			synth_printf("%s ", spk_msg_get(MSG_DISJUNCTION));
 		say_key(val);
 	}
 	return 1;
diff --git a/drivers/staging/speakup/kobjects.c b/drivers/staging/speakup/kobjects.c
index 2093896..86387f4 100644
--- a/drivers/staging/speakup/kobjects.c
+++ b/drivers/staging/speakup/kobjects.c
@@ -41,7 +41,7 @@ static ssize_t chars_chartab_show(struct kobject *kobj,
 			break;
 		if (strcmp("characters", attr->attr.name) == 0) {
 			len = scnprintf(buf_pointer, bufsize, "%d\t%s\n",
-					i, characters[i]);
+					i, spk_characters[i]);
 		} else {	/* show chartab entry */
 			if (IS_TYPE(i, B_CTL))
 				cp = "B_CTL";
@@ -185,12 +185,12 @@ static ssize_t chars_chartab_store(struct kobject *kobj,
 		outptr[desc_length] = '\0';
 
 		if (do_characters) {
-			if (characters[index] != default_chars[index])
-				kfree(characters[index]);
-			characters[index] = desc;
+			if (spk_characters[index] != spk_default_chars[index])
+				kfree(spk_characters[index]);
+			spk_characters[index] = desc;
 			used++;
 		} else {
-			charclass = chartab_get_value(keyword);
+			charclass = spk_chartab_get_value(keyword);
 			if (charclass == 0) {
 				rejected++;
 				cp = linefeed + 1;
@@ -206,9 +206,9 @@ static ssize_t chars_chartab_store(struct kobject *kobj,
 
 	if (reset) {
 		if (do_characters)
-			reset_default_chars();
+			spk_reset_default_chars();
 		else
-			reset_default_chartab();
+			spk_reset_default_chartab();
 	}
 
 	spk_unlock(flags);
@@ -232,7 +232,7 @@ static ssize_t keymap_show(struct kobject *kobj, struct kobj_attribute *attr,
 	u_char ch;
 	unsigned long flags;
 	spk_lock(flags);
-	cp1 = key_buf + SHIFT_TBL_SIZE;
+	cp1 = spk_key_buf + SHIFT_TBL_SIZE;
 	num_keys = (int)(*cp1);
 	nstates = (int)cp1[1];
 	cp += sprintf(cp, "%d, %d, %d,\n", KEY_MAP_VER, num_keys, nstates);
@@ -271,7 +271,7 @@ static ssize_t keymap_store(struct kobject *kobj, struct kobj_attribute *attr,
 		return -ENOMEM;
 	}
 	if (strchr("dDrR", *in_buff)) {
-		set_key_info(key_defaults, key_buf);
+		spk_set_key_info(spk_key_defaults, spk_key_buf);
 		pr_info("keymap set to default values\n");
 		kfree(in_buff);
 		spk_unlock(flags);
@@ -282,14 +282,14 @@ static ssize_t keymap_store(struct kobject *kobj, struct kobj_attribute *attr,
 	cp = in_buff;
 	cp1 = (u_char *)in_buff;
 	for (i = 0; i < 3; i++) {
-		cp = s2uchar(cp, cp1);
+		cp = spk_s2uchar(cp, cp1);
 		cp1++;
 	}
 	i = (int)cp1[-2]+1;
 	i *= (int)cp1[-1]+1;
 	i += 2; /* 0 and last map ver */
 	if (cp1[-3] != KEY_MAP_VER || cp1[-1] > 10 ||
-			i+SHIFT_TBL_SIZE+4 >= sizeof(key_buf)) {
+			i+SHIFT_TBL_SIZE+4 >= sizeof(spk_key_buf)) {
 		pr_warn("i %d %d %d %d\n", i,
 				(int)cp1[-3], (int)cp1[-2], (int)cp1[-1]);
 		kfree(in_buff);
@@ -297,7 +297,7 @@ static ssize_t keymap_store(struct kobject *kobj, struct kobj_attribute *attr,
 		return -EINVAL;
 	}
 	while (--i >= 0) {
-		cp = s2uchar(cp, cp1);
+		cp = spk_s2uchar(cp, cp1);
 		cp1++;
 		if (!(*cp))
 			break;
@@ -307,8 +307,8 @@ static ssize_t keymap_store(struct kobject *kobj, struct kobj_attribute *attr,
 		pr_warn("end %d %d %d %d\n", i,
 				(int)cp1[-3], (int)cp1[-2], (int)cp1[-1]);
 	} else {
-		if (set_key_info(in_buff, key_buf)) {
-			set_key_info(key_defaults, key_buf);
+		if (spk_set_key_info(in_buff, spk_key_buf)) {
+			spk_set_key_info(spk_key_defaults, spk_key_buf);
 			ret = -EINVAL;
 			pr_warn("set key failed\n");
 		}
@@ -343,7 +343,7 @@ static ssize_t silent_store(struct kobject *kobj, struct kobj_attribute *attr,
 	spk_lock(flags);
 	if (ch&2) {
 		shut = 1;
-		do_flush();
+		spk_do_flush();
 	} else {
 		shut = 0;
 	}
@@ -388,7 +388,7 @@ static ssize_t synth_store(struct kobject *kobj, struct kobj_attribute *attr,
 	if (new_synth_name[len - 1] == '\n')
 		len--;
 	new_synth_name[len] = '\0';
-	strlwr(new_synth_name);
+	spk_strlwr(new_synth_name);
 	if ((synth != NULL) && (!strcmp(new_synth_name, synth->name))) {
 		pr_warn("%s already in use\n", new_synth_name);
 	} else if (synth_init(new_synth_name) != 0) {
@@ -417,7 +417,7 @@ static ssize_t synth_direct_store(struct kobject *kobj,
 		bytes = min_t(size_t, len, 250);
 		strncpy(tmp, ptr, bytes);
 		tmp[bytes] = '\0';
-		xlate(tmp);
+		spk_xlate(tmp);
 		synth_printf("%s", tmp);
 		ptr += bytes;
 		len -= bytes;
@@ -455,14 +455,14 @@ static ssize_t punc_show(struct kobject *kobj, struct kobj_attribute *attr,
 	short mask;
 	unsigned long flags;
 
-	p_header = var_header_by_name(attr->attr.name);
+	p_header = spk_var_header_by_name(attr->attr.name);
 	if (p_header == NULL) {
 		pr_warn("p_header is null, attr->attr.name is %s\n",
 			attr->attr.name);
 		return -EINVAL;
 	}
 
-	var = get_punc_var(p_header->var_id);
+	var = spk_get_punc_var(p_header->var_id);
 	if (var == NULL) {
 		pr_warn("var is null, p_header->var_id is %i\n",
 				p_header->var_id);
@@ -470,7 +470,7 @@ static ssize_t punc_show(struct kobject *kobj, struct kobj_attribute *attr,
 	}
 
 	spk_lock(flags);
-	pb = (struct st_bits_data *) &punc_info[var->value];
+	pb = (struct st_bits_data *) &spk_punc_info[var->value];
 	mask = pb->mask;
 	for (i = 33; i < 128; i++) {
 		if (!(spk_chartab[i]&mask))
@@ -497,14 +497,14 @@ static ssize_t punc_store(struct kobject *kobj, struct kobj_attribute *attr,
 	if (x < 1 || x > 99)
 		return -EINVAL;
 
-	p_header = var_header_by_name(attr->attr.name);
+	p_header = spk_var_header_by_name(attr->attr.name);
 	if (p_header == NULL) {
 		pr_warn("p_header is null, attr->attr.name is %s\n",
 			attr->attr.name);
 		return -EINVAL;
 	}
 
-	var = get_punc_var(p_header->var_id);
+	var = spk_get_punc_var(p_header->var_id);
 	if (var == NULL) {
 		pr_warn("var is null, p_header->var_id is %i\n",
 				p_header->var_id);
@@ -520,9 +520,9 @@ static ssize_t punc_store(struct kobject *kobj, struct kobj_attribute *attr,
 	spk_lock(flags);
 
 	if (*punc_buf == 'd' || *punc_buf == 'r')
-		x = set_mask_bits(0, var->value, 3);
+		x = spk_set_mask_bits(0, var->value, 3);
 	else
-		x = set_mask_bits(punc_buf, var->value, 3);
+		x = spk_set_mask_bits(punc_buf, var->value, 3);
 
 	spk_unlock(flags);
 	return count;
@@ -542,7 +542,7 @@ ssize_t spk_var_show(struct kobject *kobj, struct kobj_attribute *attr,
 	char ch;
 	unsigned long flags;
 
-	param = var_header_by_name(attr->attr.name);
+	param = spk_var_header_by_name(attr->attr.name);
 	if (param == NULL)
 		return -EINVAL;
 
@@ -599,13 +599,13 @@ ssize_t spk_var_store(struct kobject *kobj, struct kobj_attribute *attr,
 	int value;
 	unsigned long flags;
 
-	param = var_header_by_name(attr->attr.name);
+	param = spk_var_header_by_name(attr->attr.name);
 	if (param == NULL)
 		return -EINVAL;
 	if (param->data == NULL)
 		return 0;
 	ret = 0;
-	cp = xlate((char *) buf);
+	cp = spk_xlate((char *) buf);
 
 	spk_lock(flags);
 	switch (param->var_type) {
@@ -618,7 +618,7 @@ ssize_t spk_var_store(struct kobject *kobj, struct kobj_attribute *attr,
 		else
 			len = E_SET;
 		speakup_s2i(cp, &value);
-		ret = set_num_var(value, param, len);
+		ret = spk_set_num_var(value, param, len);
 		if (ret == E_RANGE) {
 			var_data = param->data;
 			pr_warn("value for %s out of range, expect %d to %d\n",
@@ -636,7 +636,7 @@ ssize_t spk_var_store(struct kobject *kobj, struct kobj_attribute *attr,
 		}
 		cp = (char *) buf;
 		cp[len] = '\0';
-		ret = set_string_var(buf, param, len);
+		ret = spk_set_string_var(buf, param, len);
 		if (ret == E_TOOLONG)
 			pr_warn("value too long for %s\n",
 					attr->attr.name);
@@ -652,19 +652,19 @@ ssize_t spk_var_store(struct kobject *kobj, struct kobj_attribute *attr,
 	 */
 	if (strcmp(attr->attr.name, "voice") == 0) {
 		if (synth && synth->default_pitch) {
-			param = var_header_by_name("pitch");
+			param = spk_var_header_by_name("pitch");
 			if (param)  {
-				set_num_var(synth->default_pitch[value], param,
+				spk_set_num_var(synth->default_pitch[value], param,
 					E_NEW_DEFAULT);
-				set_num_var(0, param, E_DEFAULT);
+				spk_set_num_var(0, param, E_DEFAULT);
 			}
 		}
 		if (synth && synth->default_vol) {
-			param = var_header_by_name("vol");
+			param = spk_var_header_by_name("vol");
 			if (param)  {
-				set_num_var(synth->default_vol[value], param,
+				spk_set_num_var(synth->default_vol[value], param,
 					E_NEW_DEFAULT);
-				set_num_var(0, param, E_DEFAULT);
+				spk_set_num_var(0, param, E_DEFAULT);
 			}
 		}
 	}
@@ -694,7 +694,7 @@ static ssize_t message_show_helper(char *buf, enum msg_index_t first,
 		if (bufsize <= 1)
 			break;
 		printed = scnprintf(buf_pointer, bufsize, "%d\t%s\n",
-			index, msg_get(cursor));
+			index, spk_msg_get(cursor));
 		buf_pointer += printed;
 		bufsize -= printed;
 	}
@@ -788,7 +788,7 @@ static ssize_t message_store_helper(const char *buf, size_t count,
 			continue;
 		}
 
-		msg_stored = msg_set(curmessage, temp, desc_length);
+		msg_stored = spk_msg_set(curmessage, temp, desc_length);
 		if (msg_stored < 0) {
 			retval = msg_stored;
 			if (msg_stored == -ENOMEM)
@@ -802,7 +802,7 @@ static ssize_t message_store_helper(const char *buf, size_t count,
 	}
 
 	if (reset)
-		reset_msg_group(group);
+		spk_reset_msg_group(group);
 
 	report_msg_status(reset, received, used, rejected, group->name);
 	return retval;
@@ -812,7 +812,7 @@ static ssize_t message_show(struct kobject *kobj,
 	struct kobj_attribute *attr, char *buf)
 {
 	ssize_t retval = 0;
-	struct msg_group_t *group = find_msg_group(attr->attr.name);
+	struct msg_group_t *group = spk_find_msg_group(attr->attr.name);
 	unsigned long flags;
 
 	BUG_ON(!group);
@@ -826,7 +826,7 @@ static ssize_t message_store(struct kobject *kobj, struct kobj_attribute *attr,
 	const char *buf, size_t count)
 {
 	ssize_t retval = 0;
-	struct msg_group_t *group = find_msg_group(attr->attr.name);
+	struct msg_group_t *group = spk_find_msg_group(attr->attr.name);
 
 	BUG_ON(!group);
 	retval = message_store_helper(buf, count, group);
diff --git a/drivers/staging/speakup/main.c b/drivers/staging/speakup/main.c
index 40e2488..463d125 100644
--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -65,23 +65,23 @@ MODULE_VERSION(SPEAKUP_VERSION);
 
 char *synth_name;
 module_param_named(synth, synth_name, charp, S_IRUGO);
-module_param_named(quiet, quiet_boot, bool, S_IRUGO);
+module_param_named(quiet, spk_quiet_boot, bool, S_IRUGO);
 
 MODULE_PARM_DESC(synth, "Synth to start if speakup is built in.");
 MODULE_PARM_DESC(quiet, "Do not announce when the synthesizer is found.");
 
-special_func special_handler;
+special_func spk_special_handler;
 
-short pitch_shift, synth_flags;
+short spk_pitch_shift, synth_flags;
 static char buf[256];
-int attrib_bleep, bleeps, bleep_time = 10;
-int no_intr, spell_delay;
-int key_echo, say_word_ctl;
-int say_ctrl, bell_pos;
-short punc_mask;
-int punc_level, reading_punc;
-char str_caps_start[MAXVARLEN + 1] = "\0", str_caps_stop[MAXVARLEN + 1] = "\0";
-const struct st_bits_data punc_info[] = {
+int spk_attrib_bleep, spk_bleeps, spk_bleep_time = 10;
+int spk_no_intr, spk_spell_delay;
+int spk_key_echo, spk_say_word_ctl;
+int spk_say_ctrl, spk_bell_pos;
+short spk_punc_mask;
+int spk_punc_level, spk_reading_punc;
+char spk_str_caps_start[MAXVARLEN + 1] = "\0", spk_str_caps_stop[MAXVARLEN + 1] = "\0";
+const struct st_bits_data spk_punc_info[] = {
 	{"none", "", 0},
 	{"some", "/$%&@", SOME},
 	{"most", "$%&#()=+*/@^<>|\\", MOST},
@@ -95,9 +95,9 @@ const struct st_bits_data punc_info[] = {
 
 static char mark_cut_flag;
 #define MAX_KEY 160
-u_char *our_keys[MAX_KEY], *shift_table;
-u_char key_buf[600];
-const u_char key_defaults[] = {
+u_char *spk_our_keys[MAX_KEY], *spk_shift_table;
+u_char spk_key_buf[600];
+const u_char spk_key_defaults[] = {
 #include "speakupmap.h"
 };
 
@@ -129,9 +129,9 @@ static char *phonetic[] = {
 /* array of 256 char pointers (one for each character description)
  * initialized to default_chars and user selectable via
  * /proc/speakup/characters */
-char *characters[256];
+char *spk_characters[256];
 
-char *default_chars[256] = {
+char *spk_default_chars[256] = {
 /*000*/ "null", "^a", "^b", "^c", "^d", "^e", "^f", "^g",
 /*008*/ "^h", "^i", "^j", "^k", "^l", "^m", "^n", "^o",
 /*016*/ "^p", "^q", "^r", "^s", "^t", "^u", "^v", "^w",
@@ -238,7 +238,7 @@ static u_short default_chartab[256] = {
 };
 
 struct task_struct *speakup_task;
-struct bleep unprocessed_sound;
+struct bleep spk_unprocessed_sound;
 static int spk_keydown;
 static u_char spk_lastkey, spk_close_press, keymap_flags;
 static u_char last_keycode, this_speakup_key;
@@ -282,13 +282,13 @@ static void bleep(u_short val)
 		350, 370, 392, 414, 440, 466, 491, 523, 554, 587, 619, 659
 	};
 	short freq;
-	int time = bleep_time;
+	int time = spk_bleep_time;
 	freq = vals[val % 12];
 	if (val > 11)
 		freq *= (1 << (val / 12));
-	unprocessed_sound.freq = freq;
-	unprocessed_sound.jiffies = msecs_to_jiffies(time);
-	unprocessed_sound.active = 1;
+	spk_unprocessed_sound.freq = freq;
+	spk_unprocessed_sound.jiffies = msecs_to_jiffies(time);
+	spk_unprocessed_sound.active = 1;
 	/* We can only have 1 active sound at a time. */
 }
 
@@ -300,7 +300,7 @@ static void speakup_shut_up(struct vc_data *vc)
 	spk_parked &= 0xfe;
 	speakup_date(vc);
 	if (synth != NULL)
-		do_flush();
+		spk_do_flush();
 }
 
 static void speech_kill(struct vc_data *vc)
@@ -313,9 +313,9 @@ static void speech_kill(struct vc_data *vc)
 	if (val == 2 || spk_killed) {
 		/* dead */
 		spk_shut_up &= ~0x40;
-		synth_printf("%s\n", msg_get(MSG_IAM_ALIVE));
+		synth_printf("%s\n", spk_msg_get(MSG_IAM_ALIVE));
 	} else {
-		synth_printf("%s\n", msg_get(MSG_YOU_KILLED_SPEAKUP));
+		synth_printf("%s\n", spk_msg_get(MSG_YOU_KILLED_SPEAKUP));
 		spk_shut_up |= 0x40;
 	}
 }
@@ -324,10 +324,10 @@ static void speakup_off(struct vc_data *vc)
 {
 	if (spk_shut_up & 0x80) {
 		spk_shut_up &= 0x7f;
-		synth_printf("%s\n", msg_get(MSG_HEY_THATS_BETTER));
+		synth_printf("%s\n", spk_msg_get(MSG_HEY_THATS_BETTER));
 	} else {
 		spk_shut_up |= 0x80;
-		synth_printf("%s\n", msg_get(MSG_YOU_TURNED_ME_OFF));
+		synth_printf("%s\n", spk_msg_get(MSG_YOU_TURNED_ME_OFF));
 	}
 	speakup_date(vc);
 }
@@ -336,10 +336,10 @@ static void speakup_parked(struct vc_data *vc)
 {
 	if (spk_parked & 0x80) {
 		spk_parked = 0;
-		synth_printf("%s\n", msg_get(MSG_UNPARKED));
+		synth_printf("%s\n", spk_msg_get(MSG_UNPARKED));
 	} else {
 		spk_parked |= 0x80;
-		synth_printf("%s\n", msg_get(MSG_PARKED));
+		synth_printf("%s\n", spk_msg_get(MSG_PARKED));
 	}
 }
 
@@ -350,16 +350,16 @@ static void speakup_cut(struct vc_data *vc)
 
 	if (!mark_cut_flag) {
 		mark_cut_flag = 1;
-		xs = (u_short) spk_x;
-		ys = (u_short) spk_y;
+		spk_xs = (u_short) spk_x;
+		spk_ys = (u_short) spk_y;
 		spk_sel_cons = vc;
-		synth_printf("%s\n", msg_get(MSG_MARK));
+		synth_printf("%s\n", spk_msg_get(MSG_MARK));
 		return;
 	}
-	xe = (u_short) spk_x;
-	ye = (u_short) spk_y;
+	spk_xe = (u_short) spk_x;
+	spk_ye = (u_short) spk_y;
 	mark_cut_flag = 0;
-	synth_printf("%s\n", msg_get(MSG_CUT));
+	synth_printf("%s\n", spk_msg_get(MSG_CUT));
 
 	speakup_clear_selection();
 	ret = speakup_set_selection(tty);
@@ -383,9 +383,9 @@ static void speakup_paste(struct vc_data *vc)
 {
 	if (mark_cut_flag) {
 		mark_cut_flag = 0;
-		synth_printf("%s\n", msg_get(MSG_MARK_CLEARED));
+		synth_printf("%s\n", spk_msg_get(MSG_MARK_CLEARED));
 	} else {
-		synth_printf("%s\n", msg_get(MSG_PASTE));
+		synth_printf("%s\n", spk_msg_get(MSG_PASTE));
 		speakup_paste_selection(tty);
 	}
 }
@@ -395,16 +395,16 @@ static void say_attributes(struct vc_data *vc)
 	int fg = spk_attr & 0x0f;
 	int bg = spk_attr >> 4;
 	if (fg > 8) {
-		synth_printf("%s ", msg_get(MSG_BRIGHT));
+		synth_printf("%s ", spk_msg_get(MSG_BRIGHT));
 		fg -= 8;
 	}
-	synth_printf("%s", msg_get(MSG_COLORS_START + fg));
+	synth_printf("%s", spk_msg_get(MSG_COLORS_START + fg));
 	if (bg > 7) {
-		synth_printf(" %s ", msg_get(MSG_ON_BLINKING));
+		synth_printf(" %s ", spk_msg_get(MSG_ON_BLINKING));
 		bg -= 8;
 	} else
-		synth_printf(" %s ", msg_get(MSG_ON));
-	synth_printf("%s\n", msg_get(MSG_COLORS_START + bg));
+		synth_printf(" %s ", spk_msg_get(MSG_ON));
+	synth_printf("%s\n", spk_msg_get(MSG_COLORS_START + bg));
 }
 
 enum {
@@ -417,24 +417,24 @@ enum {
 
 static void announce_edge(struct vc_data *vc, int msg_id)
 {
-	if (bleeps & 1)
+	if (spk_bleeps & 1)
 		bleep(spk_y);
-	if ((bleeps & 2) && (msg_id < edge_quiet))
-		synth_printf("%s\n", msg_get(MSG_EDGE_MSGS_START + msg_id - 1));
+	if ((spk_bleeps & 2) && (msg_id < edge_quiet))
+		synth_printf("%s\n", spk_msg_get(MSG_EDGE_MSGS_START + msg_id - 1));
 }
 
 static void speak_char(u_char ch)
 {
-	char *cp = characters[ch];
-	struct var_t *direct = get_var(DIRECT);
+	char *cp = spk_characters[ch];
+	struct var_t *direct = spk_get_var(DIRECT);
 	if (direct && direct->u.n.value) {
 		if (IS_CHAR(ch, B_CAP)) {
-			pitch_shift++;
-			synth_printf("%s", str_caps_start);
+			spk_pitch_shift++;
+			synth_printf("%s", spk_str_caps_start);
 		}
 		synth_printf("%c", ch);
 		if (IS_CHAR(ch, B_CAP))
-			synth_printf("%s", str_caps_stop);
+			synth_printf("%s", spk_str_caps_stop);
 		return;
 	}
 	if (cp == NULL) {
@@ -443,13 +443,13 @@ static void speak_char(u_char ch)
 	}
 	synth_buffer_add(SPACE);
 	if (IS_CHAR(ch, B_CAP)) {
-		pitch_shift++;
-		synth_printf("%s", str_caps_start);
+		spk_pitch_shift++;
+		synth_printf("%s", spk_str_caps_start);
 		synth_printf("%s", cp);
-		synth_printf("%s", str_caps_stop);
+		synth_printf("%s", spk_str_caps_stop);
 	} else {
 		if (*cp == '^') {
-			synth_printf("%s", msg_get(MSG_CTRL));
+			synth_printf("%s", spk_msg_get(MSG_CTRL));
 			cp++;
 		}
 		synth_printf("%s", cp);
@@ -479,9 +479,9 @@ static void say_char(struct vc_data *vc)
 	spk_old_attr = spk_attr;
 	ch = get_char(vc, (u_short *) spk_pos, &spk_attr);
 	if (spk_attr != spk_old_attr) {
-		if (attrib_bleep & 1)
+		if (spk_attrib_bleep & 1)
 			bleep(spk_y);
-		if (attrib_bleep & 2)
+		if (spk_attrib_bleep & 2)
 			say_attributes(vc);
 	}
 	speak_char(ch & 0xff);
@@ -497,7 +497,7 @@ static void say_phonetic_char(struct vc_data *vc)
 		synth_printf("%s\n", phonetic[--ch]);
 	} else {
 		if (IS_CHAR(ch, B_NUM))
-			synth_printf("%s ", msg_get(MSG_NUMBER));
+			synth_printf("%s ", spk_msg_get(MSG_NUMBER));
 		speak_char(ch);
 	}
 }
@@ -527,8 +527,8 @@ static void say_next_char(struct vc_data *vc)
 }
 
 /* get_word - will first check to see if the character under the
- * reading cursor is a space and if say_word_ctl is true it will
- * return the word space.  If say_word_ctl is not set it will check to
+ * reading cursor is a space and if spk_say_word_ctl is true it will
+ * return the word space.  If spk_say_word_ctl is not set it will check to
  * see if there is a word starting on the next position to the right
  * and return that word if it exists.  If it does not exist it will
  * move left to the beginning of any previous word on the line or the
@@ -544,9 +544,9 @@ static u_long get_word(struct vc_data *vc)
 	ch = (char)get_char(vc, (u_short *) tmp_pos, &temp);
 
 /* decided to take out the sayword if on a space (mis-information */
-	if (say_word_ctl && ch == SPACE) {
+	if (spk_say_word_ctl && ch == SPACE) {
 		*buf = '\0';
-		synth_printf("%s\n", msg_get(MSG_SPACE));
+		synth_printf("%s\n", spk_msg_get(MSG_SPACE));
 		return 0;
 	} else if ((tmpx < vc->vc_cols - 2)
 		   && (ch == SPACE || ch == 0 || IS_WDLM(ch))
@@ -582,13 +582,13 @@ static u_long get_word(struct vc_data *vc)
 static void say_word(struct vc_data *vc)
 {
 	u_long cnt = get_word(vc);
-	u_short saved_punc_mask = punc_mask;
+	u_short saved_punc_mask = spk_punc_mask;
 	if (cnt == 0)
 		return;
-	punc_mask = PUNC;
+	spk_punc_mask = PUNC;
 	buf[cnt++] = SPACE;
 	spkup_write(buf, cnt);
-	punc_mask = saved_punc_mask;
+	spk_punc_mask = saved_punc_mask;
 }
 
 static void say_prev_word(struct vc_data *vc)
@@ -686,22 +686,22 @@ static void say_next_word(struct vc_data *vc)
 static void spell_word(struct vc_data *vc)
 {
 	static char *delay_str[] = { "", ",", ".", ". .", ". . ." };
-	char *cp = buf, *str_cap = str_caps_stop;
-	char *cp1, *last_cap = str_caps_stop;
+	char *cp = buf, *str_cap = spk_str_caps_stop;
+	char *cp1, *last_cap = spk_str_caps_stop;
 	u_char ch;
 	if (!get_word(vc))
 		return;
 	while ((ch = (u_char) *cp)) {
 		if (cp != buf)
-			synth_printf(" %s ", delay_str[spell_delay]);
+			synth_printf(" %s ", delay_str[spk_spell_delay]);
 		if (IS_CHAR(ch, B_CAP)) {
-			str_cap = str_caps_start;
-			if (*str_caps_stop)
-				pitch_shift++;
+			str_cap = spk_str_caps_start;
+			if (*spk_str_caps_stop)
+				spk_pitch_shift++;
 			else	/* synth has no pitch */
-				last_cap = str_caps_stop;
+				last_cap = spk_str_caps_stop;
 		} else
-			str_cap = str_caps_stop;
+			str_cap = spk_str_caps_stop;
 		if (str_cap != last_cap) {
 			synth_printf("%s", str_cap);
 			last_cap = str_cap;
@@ -711,17 +711,17 @@ static void spell_word(struct vc_data *vc)
 			ch &= 31;
 			cp1 = phonetic[--ch];
 		} else {
-			cp1 = characters[ch];
+			cp1 = spk_characters[ch];
 			if (*cp1 == '^') {
-				synth_printf("%s", msg_get(MSG_CTRL));
+				synth_printf("%s", spk_msg_get(MSG_CTRL));
 				cp1++;
 			}
 		}
 		synth_printf("%s", cp1);
 		cp++;
 	}
-	if (str_cap != str_caps_stop)
-		synth_printf("%s", str_caps_stop);
+	if (str_cap != spk_str_caps_stop)
+		synth_printf("%s", spk_str_caps_stop);
 }
 
 static int get_line(struct vc_data *vc)
@@ -746,9 +746,9 @@ static void say_line(struct vc_data *vc)
 {
 	int i = get_line(vc);
 	char *cp;
-	u_short saved_punc_mask = punc_mask;
+	u_short saved_punc_mask = spk_punc_mask;
 	if (i == 0) {
-		synth_printf("%s\n", msg_get(MSG_BLANK));
+		synth_printf("%s\n", spk_msg_get(MSG_BLANK));
 		return;
 	}
 	buf[i++] = '\n';
@@ -758,9 +758,9 @@ static void say_line(struct vc_data *vc)
 			cp++;
 		synth_printf("%d, ", (cp - buf) + 1);
 	}
-	punc_mask = punc_masks[reading_punc];
+	spk_punc_mask = spk_punc_masks[spk_reading_punc];
 	spkup_write(buf, i);
-	punc_mask = saved_punc_mask;
+	spk_punc_mask = saved_punc_mask;
 }
 
 static void say_prev_line(struct vc_data *vc)
@@ -792,7 +792,7 @@ static int say_from_to(struct vc_data *vc, u_long from, u_long to,
 {
 	int i = 0;
 	u_char tmp;
-	u_short saved_punc_mask = punc_mask;
+	u_short saved_punc_mask = spk_punc_mask;
 	spk_old_attr = spk_attr;
 	spk_attr = get_attributes((u_short *) from);
 	while (from < to) {
@@ -809,10 +809,10 @@ static int say_from_to(struct vc_data *vc, u_long from, u_long to,
 	if (i < 1)
 		return i;
 	if (read_punc)
-		punc_mask = punc_info[reading_punc].mask;
+		spk_punc_mask = spk_punc_info[spk_reading_punc].mask;
 	spkup_write(buf, i);
 	if (read_punc)
-		punc_mask = saved_punc_mask;
+		spk_punc_mask = saved_punc_mask;
 	return i - 1;
 }
 
@@ -824,7 +824,7 @@ static void say_line_from_to(struct vc_data *vc, u_long from, u_long to,
 	start += from * 2;
 	if (say_from_to(vc, start, end, read_punc) <= 0)
 		if (cursor_track != read_all_mode)
-			synth_printf("%s\n", msg_get(MSG_BLANK));
+			synth_printf("%s\n", spk_msg_get(MSG_BLANK));
 }
 
 /* Sentence Reading Commands */
@@ -924,7 +924,7 @@ static void speakup_win_say(struct vc_data *vc)
 {
 	u_long start, end, from, to;
 	if (win_start < 2) {
-		synth_printf("%s\n", msg_get(MSG_NO_WINDOW));
+		synth_printf("%s\n", spk_msg_get(MSG_NO_WINDOW));
 		return;
 	}
 	start = vc->vc_origin + (win_top * vc->vc_size_row);
@@ -975,7 +975,7 @@ static void say_first_char(struct vc_data *vc)
 	u_char ch;
 	spk_parked |= 0x01;
 	if (len == 0) {
-		synth_printf("%s\n", msg_get(MSG_BLANK));
+		synth_printf("%s\n", spk_msg_get(MSG_BLANK));
 		return;
 	}
 	for (i = 0; i < len; i++)
@@ -994,7 +994,7 @@ static void say_last_char(struct vc_data *vc)
 	u_char ch;
 	spk_parked |= 0x01;
 	if (len == 0) {
-		synth_printf("%s\n", msg_get(MSG_BLANK));
+		synth_printf("%s\n", spk_msg_get(MSG_BLANK));
 		return;
 	}
 	ch = buf[--len];
@@ -1006,7 +1006,7 @@ static void say_last_char(struct vc_data *vc)
 
 static void say_position(struct vc_data *vc)
 {
-	synth_printf(msg_get(MSG_POS_INFO), spk_y + 1, spk_x + 1,
+	synth_printf(spk_msg_get(MSG_POS_INFO), spk_y + 1, spk_x + 1,
 		     vc->vc_num + 1);
 	synth_printf("\n");
 }
@@ -1017,7 +1017,7 @@ static void say_char_num(struct vc_data *vc)
 	u_char tmp;
 	u_short ch = get_char(vc, (u_short *) spk_pos, &tmp);
 	ch &= 0xff;
-	synth_printf(msg_get(MSG_CHAR_INFO), ch, ch);
+	synth_printf(spk_msg_get(MSG_CHAR_INFO), ch, ch);
 }
 
 /* these are stub functions to keep keyboard.c happy. */
@@ -1066,7 +1066,7 @@ static void spkup_write(const char *in_buf, int count)
 		} else {
 			if ((last_type & CH_RPT) && rep_count > 2) {
 				synth_printf(" ");
-				synth_printf(msg_get(MSG_REPEAT_DESC),
+				synth_printf(spk_msg_get(MSG_REPEAT_DESC),
 					     ++rep_count);
 				synth_printf(" ");
 			}
@@ -1074,7 +1074,7 @@ static void spkup_write(const char *in_buf, int count)
 		}
 		if (ch == spk_lastkey) {
 			rep_count = 0;
-			if (key_echo == 1 && ch >= MINECHOCHAR)
+			if (spk_key_echo == 1 && ch >= MINECHOCHAR)
 				speak_char(ch);
 		} else if (char_type & B_ALPHA) {
 			if ((synth_flags & SF_DEC) && (last_type & PUNC))
@@ -1083,7 +1083,7 @@ static void spkup_write(const char *in_buf, int count)
 		} else if (char_type & B_NUM) {
 			rep_count = 0;
 			synth_printf("%c", ch);
-		} else if (char_type & punc_mask) {
+		} else if (char_type & spk_punc_mask) {
 			speak_char(ch);
 			char_type &= ~PUNC;	/* for dec nospell processing */
 		} else if (char_type & SYNTH_OK) {
@@ -1111,7 +1111,7 @@ static void spkup_write(const char *in_buf, int count)
 	if (in_count > 2 && rep_count > 2) {
 		if (last_type & CH_RPT) {
 			synth_printf(" ");
-			synth_printf(msg_get(MSG_REPEAT_DESC2), ++rep_count);
+			synth_printf(spk_msg_get(MSG_REPEAT_DESC2), ++rep_count);
 			synth_printf(" ");
 		}
 		rep_count = 0;
@@ -1135,22 +1135,22 @@ static void do_handle_shift(struct vc_data *vc, u_char value, char up_flag)
 		case KVAL(K_SHIFT):
 			del_timer(&cursor_timer);
 			spk_shut_up &= 0xfe;
-			do_flush();
+			spk_do_flush();
 			read_all_doc(vc);
 			break;
 		case KVAL(K_CTRL):
 			del_timer(&cursor_timer);
 			cursor_track = prev_cursor_track;
 			spk_shut_up &= 0xfe;
-			do_flush();
+			spk_do_flush();
 			break;
 		}
 	} else {
 		spk_shut_up &= 0xfe;
-		do_flush();
+		spk_do_flush();
 	}
-	if (say_ctrl && value < NUM_CTL_LABELS)
-		synth_printf("%s", msg_get(MSG_CTL_START + value));
+	if (spk_say_ctrl && value < NUM_CTL_LABELS)
+		synth_printf("%s", spk_msg_get(MSG_CTL_START + value));
 	spk_unlock(flags);
 }
 
@@ -1171,12 +1171,12 @@ static void do_handle_latin(struct vc_data *vc, u_char value, char up_flag)
 	spk_lastkey = value;
 	spk_keydown++;
 	spk_parked &= 0xfe;
-	if (key_echo == 2 && value >= MINECHOCHAR)
+	if (spk_key_echo == 2 && value >= MINECHOCHAR)
 		speak_char(value);
 	spk_unlock(flags);
 }
 
-int set_key_info(const u_char *key_info, u_char *k_buffer)
+int spk_set_key_info(const u_char *key_info, u_char *k_buffer)
 {
 	int i = 0, states, key_data_len;
 	const u_char *cp = key_info;
@@ -1188,12 +1188,12 @@ int set_key_info(const u_char *key_info, u_char *k_buffer)
 	num_keys = *cp;
 	states = (int)cp[1];
 	key_data_len = (states + 1) * (num_keys + 1);
-	if (key_data_len + SHIFT_TBL_SIZE + 4 >= sizeof(key_buf))
+	if (key_data_len + SHIFT_TBL_SIZE + 4 >= sizeof(spk_key_buf))
 		return -2;
 	memset(k_buffer, 0, SHIFT_TBL_SIZE);
-	memset(our_keys, 0, sizeof(our_keys));
-	shift_table = k_buffer;
-	our_keys[0] = shift_table;
+	memset(spk_our_keys, 0, sizeof(spk_our_keys));
+	spk_shift_table = k_buffer;
+	spk_our_keys[0] = spk_shift_table;
 	cp1 += SHIFT_TBL_SIZE;
 	memcpy(cp1, cp, key_data_len + 3);
 	/* get num_keys, states and data */
@@ -1202,13 +1202,13 @@ int set_key_info(const u_char *key_info, u_char *k_buffer)
 		ch = *cp1++;
 		if (ch >= SHIFT_TBL_SIZE)
 			return -3;
-		shift_table[ch] = i;
+		spk_shift_table[ch] = i;
 	}
 	keymap_flags = *cp1++;
 	while ((ch = *cp1)) {
 		if (ch >= MAX_KEY)
 			return -4;
-		our_keys[ch] = cp1;
+		spk_our_keys[ch] = cp1;
 		cp1 += states + 1;
 	}
 	return 0;
@@ -1237,24 +1237,24 @@ static void toggle_cursoring(struct vc_data *vc)
 		cursor_track = prev_cursor_track;
 	if (++cursor_track >= CT_Max)
 		cursor_track = 0;
-	synth_printf("%s\n", msg_get(MSG_CURSOR_MSGS_START + cursor_track));
+	synth_printf("%s\n", spk_msg_get(MSG_CURSOR_MSGS_START + cursor_track));
 }
 
-void reset_default_chars(void)
+void spk_reset_default_chars(void)
 {
 	int i;
 
 	/* First, free any non-default */
 	for (i = 0; i < 256; i++) {
-		if ((characters[i] != NULL)
-		    && (characters[i] != default_chars[i]))
-			kfree(characters[i]);
+		if ((spk_characters[i] != NULL)
+		    && (spk_characters[i] != spk_default_chars[i]))
+			kfree(spk_characters[i]);
 	}
 
-	memcpy(characters, default_chars, sizeof(default_chars));
+	memcpy(spk_characters, spk_default_chars, sizeof(spk_default_chars));
 }
 
-void reset_default_chartab(void)
+void spk_reset_default_chartab(void)
 {
 	memcpy(spk_chartab, default_chartab, sizeof(default_chartab));
 }
@@ -1267,8 +1267,8 @@ static int edit_bits(struct vc_data *vc, u_char type, u_char ch, u_short key)
 	if (type != KT_LATIN || (ch_type & B_NUM) || ch < SPACE)
 		return -1;
 	if (ch == SPACE) {
-		synth_printf("%s\n", msg_get(MSG_EDIT_DONE));
-		special_handler = NULL;
+		synth_printf("%s\n", spk_msg_get(MSG_EDIT_DONE));
+		spk_special_handler = NULL;
 		return 1;
 	}
 	if (mask < PUNC && !(ch_type & PUNC))
@@ -1276,8 +1276,8 @@ static int edit_bits(struct vc_data *vc, u_char type, u_char ch, u_short key)
 	spk_chartab[ch] ^= mask;
 	speak_char(ch);
 	synth_printf(" %s\n",
-		     (spk_chartab[ch] & mask) ? msg_get(MSG_ON) :
-		     msg_get(MSG_OFF));
+		     (spk_chartab[ch] & mask) ? spk_msg_get(MSG_ON) :
+		     spk_msg_get(MSG_OFF));
 	return 1;
 }
 
@@ -1346,7 +1346,7 @@ static void read_all_doc(struct vc_data *vc)
 	if (cursor_track != read_all_mode)
 		prev_cursor_track = cursor_track;
 	cursor_track = read_all_mode;
-	reset_index_count(0);
+	spk_reset_index_count(0);
 	if (get_sentence_buf(vc, 0) == -1)
 		kbd_fakekey2(vc, RA_DOWN_ARROW);
 	else {
@@ -1361,7 +1361,7 @@ static void stop_read_all(struct vc_data *vc)
 	del_timer(&cursor_timer);
 	cursor_track = prev_cursor_track;
 	spk_shut_up &= 0xfe;
-	do_flush();
+	spk_do_flush();
 }
 
 static void start_read_all_timer(struct vc_data *vc, int command)
@@ -1370,7 +1370,7 @@ static void start_read_all_timer(struct vc_data *vc, int command)
 
 	cursor_con = vc->vc_num;
 	read_all_key = command;
-	cursor_timeout = get_var(CURSOR_TIME);
+	cursor_timeout = spk_get_var(CURSOR_TIME);
 	mod_timer(&cursor_timer,
 		  jiffies + msecs_to_jiffies(cursor_timeout->u.n.value));
 }
@@ -1382,9 +1382,9 @@ static void handle_cursor_read_all(struct vc_data *vc, int command)
 	switch (command) {
 	case RA_NEXT_SENT:
 		/* Get Current Sentence */
-		get_index_count(&indcount, &sentcount);
+		spk_get_index_count(&indcount, &sentcount);
 		/*printk("%d %d  ", indcount, sentcount); */
-		reset_index_count(sentcount + 1);
+		spk_reset_index_count(sentcount + 1);
 		if (indcount == 1) {
 			if (!say_sentence_num(sentcount + 1, 0)) {
 				kbd_fakekey2(vc, RA_FIND_NEXT_SENT);
@@ -1395,7 +1395,7 @@ static void handle_cursor_read_all(struct vc_data *vc, int command)
 			sn = 0;
 			if (!say_sentence_num(sentcount + 1, 1)) {
 				sn = 1;
-				reset_index_count(sn);
+				spk_reset_index_count(sn);
 			} else
 				synth_insert_next_index(0);
 			if (!say_sentence_num(sn, 0)) {
@@ -1437,7 +1437,7 @@ static void handle_cursor_read_all(struct vc_data *vc, int command)
 	case RA_FIND_PREV_SENT:
 		break;
 	case RA_TIMER:
-		get_index_count(&indcount, &sentcount);
+		spk_get_index_count(&indcount, &sentcount);
 		if (indcount < 2)
 			kbd_fakekey2(vc, RA_DOWN_ARROW);
 		else
@@ -1458,7 +1458,7 @@ static int pre_handle_cursor(struct vc_data *vc, u_char value, char up_flag)
 		}
 		del_timer(&cursor_timer);
 		spk_shut_up &= 0xfe;
-		do_flush();
+		spk_do_flush();
 		start_read_all_timer(vc, value + 1);
 		spk_unlock(flags);
 		return NOTIFY_STOP;
@@ -1479,8 +1479,8 @@ static void do_handle_cursor(struct vc_data *vc, u_char value, char up_flag)
 		return;
 	}
 	spk_shut_up &= 0xfe;
-	if (no_intr)
-		do_flush();
+	if (spk_no_intr)
+		spk_do_flush();
 /* the key press flushes if !no_inter but we want to flush on cursor
  * moves regardless of no_inter state */
 	is_cursor = value + 1;
@@ -1491,7 +1491,7 @@ static void do_handle_cursor(struct vc_data *vc, u_char value, char up_flag)
 	cursor_con = vc->vc_num;
 	if (cursor_track == CT_Highlight)
 		reset_highlight_buffers(vc);
-	cursor_timeout = get_var(CURSOR_TIME);
+	cursor_timeout = spk_get_var(CURSOR_TIME);
 	mod_timer(&cursor_timer,
 		  jiffies + msecs_to_jiffies(cursor_timeout->u.n.value));
 	spk_unlock(flags);
@@ -1603,7 +1603,7 @@ static int speak_highlight(struct vc_data *vc)
 			if (speakup_console[vc_num]->ht.ry[hc] != vc->vc_y)
 				return 0;
 		spk_parked |= 0x01;
-		do_flush();
+		spk_do_flush();
 		spkup_write(speakup_console[vc_num]->ht.highbuf[hc],
 			    speakup_console[vc_num]->ht.highsize[hc]);
 		spk_pos = spk_cp = speakup_console[vc_num]->ht.rpos[hc];
@@ -1685,7 +1685,7 @@ static void speakup_con_write(struct vc_data *vc, const char *str, int len)
 	if (!spk_trylock(flags))
 		/* Speakup output, discard */
 		return;
-	if (bell_pos && spk_keydown && (vc->vc_x == bell_pos - 1))
+	if (spk_bell_pos && spk_keydown && (vc->vc_x == spk_bell_pos - 1))
 		bleep(3);
 	if ((is_cursor) || (cursor_track == read_all_mode)) {
 		if (cursor_track == CT_Highlight)
@@ -1726,19 +1726,19 @@ static void do_handle_spec(struct vc_data *vc, u_char value, char up_flag)
 		return;
 	spk_lock(flags);
 	spk_shut_up &= 0xfe;
-	if (no_intr)
-		do_flush();
+	if (spk_no_intr)
+		spk_do_flush();
 	switch (value) {
 	case KVAL(K_CAPS):
-		label = msg_get(MSG_KEYNAME_CAPSLOCK);
+		label = spk_msg_get(MSG_KEYNAME_CAPSLOCK);
 		on_off = vt_get_leds(fg_console, VC_CAPSLOCK);
 		break;
 	case KVAL(K_NUM):
-		label = msg_get(MSG_KEYNAME_NUMLOCK);
+		label = spk_msg_get(MSG_KEYNAME_NUMLOCK);
 		on_off = vt_get_leds(fg_console, VC_NUMLOCK);
 		break;
 	case KVAL(K_HOLD):
-		label = msg_get(MSG_KEYNAME_SCROLLLOCK);
+		label = spk_msg_get(MSG_KEYNAME_SCROLLLOCK);
 		on_off = vt_get_leds(fg_console, VC_SCROLLOCK);
 		if (speakup_console[vc->vc_num])
 			speakup_console[vc->vc_num]->tty_stopped = on_off;
@@ -1750,7 +1750,7 @@ static void do_handle_spec(struct vc_data *vc, u_char value, char up_flag)
 	}
 	if (on_off < 2)
 		synth_printf("%s %s\n",
-			     label, msg_get(MSG_STATUS_START + on_off));
+			     label, spk_msg_get(MSG_STATUS_START + on_off));
 	spk_unlock(flags);
 }
 
@@ -1764,13 +1764,13 @@ static int inc_dec_var(u_char value)
 	int var_id = (int)value - VAR_START;
 	int how = (var_id & 1) ? E_INC : E_DEC;
 	var_id = var_id / 2 + FIRST_SET_VAR;
-	p_header = get_var_header(var_id);
+	p_header = spk_get_var_header(var_id);
 	if (p_header == NULL)
 		return -1;
 	if (p_header->var_type != VAR_NUM)
 		return -1;
 	var_data = p_header->data;
-	if (set_num_var(1, p_header, how) != 0)
+	if (spk_set_num_var(1, p_header, how) != 0)
 		return -1;
 	if (!spk_close_press) {
 		for (pn = p_header->name; *pn; pn++) {
@@ -1790,18 +1790,18 @@ static void speakup_win_set(struct vc_data *vc)
 {
 	char info[40];
 	if (win_start > 1) {
-		synth_printf("%s\n", msg_get(MSG_WINDOW_ALREADY_SET));
+		synth_printf("%s\n", spk_msg_get(MSG_WINDOW_ALREADY_SET));
 		return;
 	}
 	if (spk_x < win_left || spk_y < win_top) {
-		synth_printf("%s\n", msg_get(MSG_END_BEFORE_START));
+		synth_printf("%s\n", spk_msg_get(MSG_END_BEFORE_START));
 		return;
 	}
 	if (win_start && spk_x == win_left && spk_y == win_top) {
 		win_left = 0;
 		win_right = vc->vc_cols - 1;
 		win_bottom = spk_y;
-		snprintf(info, sizeof(info), msg_get(MSG_WINDOW_LINE),
+		snprintf(info, sizeof(info), spk_msg_get(MSG_WINDOW_LINE),
 			 (int)win_top + 1);
 	} else {
 		if (!win_start) {
@@ -1811,8 +1811,8 @@ static void speakup_win_set(struct vc_data *vc)
 			win_bottom = spk_y;
 			win_right = spk_x;
 		}
-		snprintf(info, sizeof(info), msg_get(MSG_WINDOW_BOUNDARY),
-			 (win_start) ? msg_get(MSG_END) : msg_get(MSG_START),
+		snprintf(info, sizeof(info), spk_msg_get(MSG_WINDOW_BOUNDARY),
+			 (win_start) ? spk_msg_get(MSG_END) : spk_msg_get(MSG_START),
 			 (int)spk_y + 1, (int)spk_x + 1);
 	}
 	synth_printf("%s\n", info);
@@ -1824,32 +1824,32 @@ static void speakup_win_clear(struct vc_data *vc)
 	win_top = win_bottom = 0;
 	win_left = win_right = 0;
 	win_start = 0;
-	synth_printf("%s\n", msg_get(MSG_WINDOW_CLEARED));
+	synth_printf("%s\n", spk_msg_get(MSG_WINDOW_CLEARED));
 }
 
 static void speakup_win_enable(struct vc_data *vc)
 {
 	if (win_start < 2) {
-		synth_printf("%s\n", msg_get(MSG_NO_WINDOW));
+		synth_printf("%s\n", spk_msg_get(MSG_NO_WINDOW));
 		return;
 	}
 	win_enabled ^= 1;
 	if (win_enabled)
-		synth_printf("%s\n", msg_get(MSG_WINDOW_SILENCED));
+		synth_printf("%s\n", spk_msg_get(MSG_WINDOW_SILENCED));
 	else
-		synth_printf("%s\n", msg_get(MSG_WINDOW_SILENCE_DISABLED));
+		synth_printf("%s\n", spk_msg_get(MSG_WINDOW_SILENCE_DISABLED));
 }
 
 static void speakup_bits(struct vc_data *vc)
 {
 	int val = this_speakup_key - (FIRST_EDIT_BITS - 1);
-	if (special_handler != NULL || val < 1 || val > 6) {
-		synth_printf("%s\n", msg_get(MSG_ERROR));
+	if (spk_special_handler != NULL || val < 1 || val > 6) {
+		synth_printf("%s\n", spk_msg_get(MSG_ERROR));
 		return;
 	}
-	pb_edit = &punc_info[val];
-	synth_printf(msg_get(MSG_EDIT_PROMPT), pb_edit->name);
-	special_handler = edit_bits;
+	pb_edit = &spk_punc_info[val];
+	synth_printf(spk_msg_get(MSG_EDIT_PROMPT), pb_edit->name);
+	spk_special_handler = edit_bits;
 }
 
 static int handle_goto(struct vc_data *vc, u_char type, u_char ch, u_short key)
@@ -1887,9 +1887,9 @@ static int handle_goto(struct vc_data *vc, u_char type, u_char ch, u_short key)
 	if (ch < 'x' || ch > 'y') {
 oops:
 		if (!spk_killed)
-			synth_printf(" %s\n", msg_get(MSG_GOTO_CANCELED));
+			synth_printf(" %s\n", spk_msg_get(MSG_GOTO_CANCELED));
 		goto_buf[num = 0] = '\0';
-		special_handler = NULL;
+		spk_special_handler = NULL;
 		return 1;
 	}
 	cp = speakup_s2i(goto_buf, &go_pos);
@@ -1917,7 +1917,7 @@ oops:
 	}
 	goto_buf[num = 0] = '\0';
 do_goto:
-	special_handler = NULL;
+	spk_special_handler = NULL;
 	spk_parked |= 0x01;
 	if (goto_x) {
 		spk_pos -= spk_x * 2;
@@ -1934,18 +1934,18 @@ do_goto:
 
 static void speakup_goto(struct vc_data *vc)
 {
-	if (special_handler != NULL) {
-		synth_printf("%s\n", msg_get(MSG_ERROR));
+	if (spk_special_handler != NULL) {
+		synth_printf("%s\n", spk_msg_get(MSG_ERROR));
 		return;
 	}
-	synth_printf("%s\n", msg_get(MSG_GOTO));
-	special_handler = handle_goto;
+	synth_printf("%s\n", spk_msg_get(MSG_GOTO));
+	spk_special_handler = handle_goto;
 	return;
 }
 
 static void speakup_help(struct vc_data *vc)
 {
-	handle_help(vc, KT_SPKUP, SPEAKUP_HELP, 0);
+	spk_handle_help(vc, KT_SPKUP, SPEAKUP_HELP, 0);
 }
 
 static void do_nothing(struct vc_data *vc)
@@ -1992,7 +1992,7 @@ static void do_spkup(struct vc_data *vc, u_char value)
 	spk_shut_up &= 0xfe;
 	this_speakup_key = value;
 	if (value < SPKUP_MAX_FUNC && spkup_handler[value]) {
-		do_flush();
+		spk_do_flush();
 		(*spkup_handler[value]) (vc);
 	} else {
 		if (inc_dec_var(value) < 0)
@@ -2032,7 +2032,7 @@ speakup_key(struct vc_data *vc, int shift_state, int keycode, u_short keysym,
 	}
 	if (keycode >= MAX_KEY)
 		goto no_map;
-	key_info = our_keys[keycode];
+	key_info = spk_our_keys[keycode];
 	if (key_info == 0)
 		goto no_map;
 	/* Check valid read all mode keys */
@@ -2051,7 +2051,7 @@ speakup_key(struct vc_data *vc, int shift_state, int keycode, u_short keysym,
 		}
 	}
 	shift_info = (shift_state & 0x0f) + key_speakup;
-	offset = shift_table[shift_info];
+	offset = spk_shift_table[shift_info];
 	if (offset) {
 		new_key = key_info[offset];
 		if (new_key) {
@@ -2062,7 +2062,7 @@ speakup_key(struct vc_data *vc, int shift_state, int keycode, u_short keysym,
 				if (up_flag || spk_killed)
 					goto out;
 				spk_shut_up &= 0xfe;
-				do_flush();
+				spk_do_flush();
 				goto out;
 			}
 			if (up_flag)
@@ -2070,7 +2070,7 @@ speakup_key(struct vc_data *vc, int shift_state, int keycode, u_short keysym,
 			if (last_keycode == keycode &&
 			    last_spk_jiffy + MAX_DELAY > jiffies) {
 				spk_close_press = 1;
-				offset = shift_table[shift_info + 32];
+				offset = spk_shift_table[shift_info + 32];
 				/* double press? */
 				if (offset && key_info[offset])
 					new_key = key_info[offset];
@@ -2082,7 +2082,7 @@ speakup_key(struct vc_data *vc, int shift_state, int keycode, u_short keysym,
 		}
 	}
 no_map:
-	if (type == KT_SPKUP && special_handler == NULL) {
+	if (type == KT_SPKUP && spk_special_handler == NULL) {
 		do_spkup(vc, new_key);
 		spk_close_press = 0;
 		ret = 1;
@@ -2096,9 +2096,9 @@ no_map:
 	    || (value == KVAL(K_LEFT))
 	    || (value == KVAL(K_RIGHT));
 	if ((cursor_track != read_all_mode) || !kh)
-		if (!no_intr)
-			do_flush();
-	if (special_handler) {
+		if (!spk_no_intr)
+			spk_do_flush();
+	if (spk_special_handler) {
 		if (type == KT_SPEC && value == 1) {
 			value = '\n';
 			type = KT_LATIN;
@@ -2106,7 +2106,7 @@ no_map:
 			type = KT_LATIN;
 		else if (value == 0x7f)
 			value = 8;	/* make del = backspace */
-		ret = (*special_handler) (vc, type, value, keycode);
+		ret = (*spk_special_handler) (vc, type, value, keycode);
 		spk_close_press = 0;
 		if (ret < 0)
 			bleep(9);
@@ -2237,11 +2237,11 @@ static void __exit speakup_exit(void)
 		speakup_unregister_var(i);
 
 	for (i = 0; i < 256; i++) {
-		if (characters[i] != default_chars[i])
-			kfree(characters[i]);
+		if (spk_characters[i] != spk_default_chars[i])
+			kfree(spk_characters[i]);
 	}
 
-	free_user_msgs();
+	spk_free_user_msgs();
 }
 
 /* call by: module_init() */
@@ -2254,20 +2254,20 @@ static int __init speakup_init(void)
 	struct var_t *var;
 
 	/* These first few initializations cannot fail. */
-	initialize_msgs();	/* Initialize arrays for i18n. */
-	reset_default_chars();
-	reset_default_chartab();
-	strlwr(synth_name);
+	spk_initialize_msgs();	/* Initialize arrays for i18n. */
+	spk_reset_default_chars();
+	spk_reset_default_chartab();
+	spk_strlwr(synth_name);
 	spk_vars[0].u.n.high = vc->vc_cols;
 	for (var = spk_vars; var->var_id != MAXVARS; var++)
 		speakup_register_var(var);
 	for (var = synth_time_vars;
 	     (var->var_id >= 0) && (var->var_id < MAXVARS); var++)
 		speakup_register_var(var);
-	for (i = 1; punc_info[i].mask != 0; i++)
-		set_mask_bits(0, i, 2);
+	for (i = 1; spk_punc_info[i].mask != 0; i++)
+		spk_set_mask_bits(0, i, 2);
 
-	set_key_info(key_defaults, key_buf);
+	spk_set_key_info(spk_key_defaults, spk_key_buf);
 
 	/* From here on out, initializations can fail. */
 	err = speakup_add_virtual_keyboard();
@@ -2290,7 +2290,7 @@ static int __init speakup_init(void)
 				goto error_kobjects;
 		}
 
-	if (quiet_boot)
+	if (spk_quiet_boot)
 		spk_shut_up |= 0x01;
 
 	err = speakup_kobj_init();
@@ -2352,11 +2352,11 @@ error_virtkeyboard:
 		speakup_unregister_var(i);
 
 	for (i = 0; i < 256; i++) {
-		if (characters[i] != default_chars[i])
-			kfree(characters[i]);
+		if (spk_characters[i] != spk_default_chars[i])
+			kfree(spk_characters[i]);
 	}
 
-	free_user_msgs();
+	spk_free_user_msgs();
 
 out:
 	return err;
diff --git a/drivers/staging/speakup/selection.c b/drivers/staging/speakup/selection.c
index fe1f405..1217c79 100644
--- a/drivers/staging/speakup/selection.c
+++ b/drivers/staging/speakup/selection.c
@@ -10,7 +10,7 @@
 /* Don't take this from <ctype.h>: 011-015 on the screen aren't spaces */
 #define ishardspace(c)      ((c) == ' ')
 
-unsigned short xs, ys, xe, ye; /* our region points */
+unsigned short spk_xs, spk_ys, spk_xe, spk_ye; /* our region points */
 
 /* Variables for selection control. */
 /* must not be disallocated */
@@ -51,12 +51,12 @@ int speakup_set_selection(struct tty_struct *tty)
 	int i, ps, pe;
 	struct vc_data *vc = vc_cons[fg_console].d;
 
-	xs = limit(xs, vc->vc_cols - 1);
-	ys = limit(ys, vc->vc_rows - 1);
-	xe = limit(xe, vc->vc_cols - 1);
-	ye = limit(ye, vc->vc_rows - 1);
-	ps = ys * vc->vc_size_row + (xs << 1);
-	pe = ye * vc->vc_size_row + (xe << 1);
+	spk_xs = limit(spk_xs, vc->vc_cols - 1);
+	spk_ys = limit(spk_ys, vc->vc_rows - 1);
+	spk_xe = limit(spk_xe, vc->vc_cols - 1);
+	spk_ye = limit(spk_ye, vc->vc_rows - 1);
+	ps = spk_ys * vc->vc_size_row + (spk_xs << 1);
+	pe = spk_ye * vc->vc_size_row + (spk_xe << 1);
 
 	if (ps > pe) {
 		/* make sel_start <= sel_end */
diff --git a/drivers/staging/speakup/serialio.c b/drivers/staging/speakup/serialio.c
index a97d3d5..e4d27aa 100644
--- a/drivers/staging/speakup/serialio.c
+++ b/drivers/staging/speakup/serialio.c
@@ -116,7 +116,7 @@ static void start_serial_interrupt(int irq)
 	outb(1, speakup_info.port_tts + UART_FCR);	/* Turn FIFO On */
 }
 
-void stop_serial_interrupt(void)
+void spk_stop_serial_interrupt(void)
 {
 	if (speakup_info.port_tts == 0)
 		return;
@@ -130,7 +130,7 @@ void stop_serial_interrupt(void)
 	free_irq(serstate->irq, (void *) synth_readbuf_handler);
 }
 
-int wait_for_xmitr(void)
+int spk_wait_for_xmitr(void)
 {
 	int tmout = SPK_XMITR_TIMEOUT;
 	if ((synth->alive) && (timeouts >= NUM_DISABLE_TIMEOUTS)) {
@@ -195,7 +195,7 @@ EXPORT_SYMBOL_GPL(spk_serial_in_nowait);
 
 int spk_serial_out(const char ch)
 {
-	if (synth->alive && wait_for_xmitr()) {
+	if (synth->alive && spk_wait_for_xmitr()) {
 		outb_p(ch, speakup_info.port_tts);
 		return 1;
 	}
diff --git a/drivers/staging/speakup/speakup.h b/drivers/staging/speakup/speakup.h
index e66579e..22f0fbb 100644
--- a/drivers/staging/speakup/speakup.h
+++ b/drivers/staging/speakup/speakup.h
@@ -50,34 +50,34 @@
 #define E_UNDEF -1
 
 extern int speakup_thread(void *data);
-extern void reset_default_chars(void);
-extern void reset_default_chartab(void);
+extern void spk_reset_default_chars(void);
+extern void spk_reset_default_chartab(void);
 extern void synth_start(void);
 void synth_insert_next_index(int sent_num);
-void reset_index_count(int sc);
-void get_index_count(int *linecount, int *sentcount);
-extern int set_key_info(const u_char *key_info, u_char *k_buffer);
-extern char *strlwr(char *s);
+void spk_reset_index_count(int sc);
+void spk_get_index_count(int *linecount, int *sentcount);
+extern int spk_set_key_info(const u_char *key_info, u_char *k_buffer);
+extern char *spk_strlwr(char *s);
 extern char *speakup_s2i(char *start, int *dest);
-extern char *s2uchar(char *start, char *dest);
-extern char *xlate(char *s);
+extern char *spk_s2uchar(char *start, char *dest);
+extern char *spk_xlate(char *s);
 extern int speakup_kobj_init(void);
 extern void speakup_kobj_exit(void);
-extern int chartab_get_value(char *keyword);
+extern int spk_chartab_get_value(char *keyword);
 extern void speakup_register_var(struct var_t *var);
 extern void speakup_unregister_var(enum var_id_t var_id);
-extern struct st_var_header *get_var_header(enum var_id_t var_id);
-extern struct st_var_header *var_header_by_name(const char *name);
-extern struct punc_var_t *get_punc_var(enum var_id_t var_id);
-extern int set_num_var(int val, struct st_var_header *var, int how);
-extern int set_string_var(const char *page, struct st_var_header *var, int len);
-extern int set_mask_bits(const char *input, const int which, const int how);
-extern special_func special_handler;
-extern int handle_help(struct vc_data *vc, u_char type, u_char ch, u_short key);
+extern struct st_var_header *spk_get_var_header(enum var_id_t var_id);
+extern struct st_var_header *spk_var_header_by_name(const char *name);
+extern struct punc_var_t *spk_get_punc_var(enum var_id_t var_id);
+extern int spk_set_num_var(int val, struct st_var_header *var, int how);
+extern int spk_set_string_var(const char *page, struct st_var_header *var, int len);
+extern int spk_set_mask_bits(const char *input, const int which, const int how);
+extern special_func spk_special_handler;
+extern int spk_handle_help(struct vc_data *vc, u_char type, u_char ch, u_short key);
 extern int synth_init(char *name);
 extern void synth_release(void);
 
-extern void do_flush(void);
+extern void spk_do_flush(void);
 extern void speakup_start_ttys(void);
 extern void synth_buffer_add(char ch);
 extern void synth_buffer_clear(void);
@@ -90,35 +90,35 @@ extern void synth_write(const char *buf, size_t count);
 extern int synth_supports_indexing(void);
 
 extern struct vc_data *spk_sel_cons;
-extern unsigned short xs, ys, xe, ye; /* our region points */
+extern unsigned short spk_xs, spk_ys, spk_xe, spk_ye; /* our region points */
 
 extern wait_queue_head_t speakup_event;
 extern struct kobject *speakup_kobj;
 extern struct task_struct *speakup_task;
-extern const u_char key_defaults[];
+extern const u_char spk_key_defaults[];
 
 /* Protect speakup synthesizer list */
 extern struct mutex spk_mutex;
 extern struct st_spk_t *speakup_console[];
 extern struct spk_synth *synth;
-extern char pitch_buff[];
-extern u_char *our_keys[];
-extern short punc_masks[];
-extern char str_caps_start[], str_caps_stop[];
-extern const struct st_bits_data punc_info[];
-extern u_char key_buf[600];
-extern char *characters[];
-extern char *default_chars[];
+extern char spk_pitch_buff[];
+extern u_char *spk_our_keys[];
+extern short spk_punc_masks[];
+extern char spk_str_caps_start[], spk_str_caps_stop[];
+extern const struct st_bits_data spk_punc_info[];
+extern u_char spk_key_buf[600];
+extern char *spk_characters[];
+extern char *spk_default_chars[];
 extern u_short spk_chartab[];
-extern int no_intr, say_ctrl, say_word_ctl, punc_level;
-extern int reading_punc, attrib_bleep, bleeps;
-extern int bleep_time, bell_pos;
-extern int spell_delay, key_echo;
-extern short punc_mask;
-extern short pitch_shift, synth_flags;
-extern bool quiet_boot;
+extern int spk_no_intr, spk_say_ctrl, spk_say_word_ctl, spk_punc_level;
+extern int spk_reading_punc, spk_attrib_bleep, spk_bleeps;
+extern int spk_bleep_time, spk_bell_pos;
+extern int spk_spell_delay, spk_key_echo;
+extern short spk_punc_mask;
+extern short spk_pitch_shift, synth_flags;
+extern bool spk_quiet_boot;
 extern char *synth_name;
-extern struct bleep unprocessed_sound;
+extern struct bleep spk_unprocessed_sound;
 
 /* Prototypes from fakekey.c. */
 int speakup_add_virtual_keyboard(void);
diff --git a/drivers/staging/speakup/speakup_acntpc.c b/drivers/staging/speakup/speakup_acntpc.c
index bbe28b6..1c1f0d5 100644
--- a/drivers/staging/speakup/speakup_acntpc.c
+++ b/drivers/staging/speakup/speakup_acntpc.c
@@ -182,9 +182,9 @@ static void do_catch_up(struct spk_synth *synth)
 	struct var_t *full_time;
 	struct var_t *jiffy_delta;
 
-	jiffy_delta = get_var(JIFFY);
-	delay_time = get_var(DELAY);
-	full_time = get_var(FULL);
+	jiffy_delta = spk_get_var(JIFFY);
+	delay_time = spk_get_var(DELAY);
+	full_time = spk_get_var(FULL);
 
 	spk_lock(flags);
 	jiffy_delta_val = jiffy_delta->u.n.value;
diff --git a/drivers/staging/speakup/speakup_acntsa.c b/drivers/staging/speakup/speakup_acntsa.c
index 590fa6b..22a8b72 100644
--- a/drivers/staging/speakup/speakup_acntsa.c
+++ b/drivers/staging/speakup/speakup_acntsa.c
@@ -128,7 +128,7 @@ static int synth_probe(struct spk_synth *synth)
 {
 	int failed;
 
-	failed = serial_synth_probe(synth);
+	failed = spk_serial_synth_probe(synth);
 	if (failed == 0) {
 		spk_synth_immediate(synth, "\033=R\r");
 		mdelay(100);
diff --git a/drivers/staging/speakup/speakup_apollo.c b/drivers/staging/speakup/speakup_apollo.c
index 00d5ced..3e450cc 100644
--- a/drivers/staging/speakup/speakup_apollo.c
+++ b/drivers/staging/speakup/speakup_apollo.c
@@ -112,7 +112,7 @@ static struct spk_synth synth_apollo = {
 	.startup = SYNTH_START,
 	.checkval = SYNTH_CHECK,
 	.vars = vars,
-	.probe = serial_synth_probe,
+	.probe = spk_serial_synth_probe,
 	.release = spk_serial_release,
 	.synth_immediate = spk_synth_immediate,
 	.catch_up = do_catch_up,
@@ -145,9 +145,9 @@ static void do_catch_up(struct spk_synth *synth)
 	int delay_time_val = 0;
 	int jiffy_delta_val = 0;
 
-	jiffy_delta = get_var(JIFFY);
-	delay_time = get_var(DELAY);
-	full_time = get_var(FULL);
+	jiffy_delta = spk_get_var(JIFFY);
+	delay_time = spk_get_var(DELAY);
+	full_time = spk_get_var(FULL);
 	spk_lock(flags);
 	jiffy_delta_val = jiffy_delta->u.n.value;
 	spk_unlock(flags);
diff --git a/drivers/staging/speakup/speakup_audptr.c b/drivers/staging/speakup/speakup_audptr.c
index 94e5099..3508aee 100644
--- a/drivers/staging/speakup/speakup_audptr.c
+++ b/drivers/staging/speakup/speakup_audptr.c
@@ -162,7 +162,7 @@ static int synth_probe(struct spk_synth *synth)
 {
 	int failed = 0;
 
-	failed = serial_synth_probe(synth);
+	failed = spk_serial_synth_probe(synth);
 	if (failed == 0)
 		synth_version(synth);
 	synth->alive = !failed;
diff --git a/drivers/staging/speakup/speakup_bns.c b/drivers/staging/speakup/speakup_bns.c
index 43e5b54..4bfe3d4 100644
--- a/drivers/staging/speakup/speakup_bns.c
+++ b/drivers/staging/speakup/speakup_bns.c
@@ -100,7 +100,7 @@ static struct spk_synth synth_bns = {
 	.startup = SYNTH_START,
 	.checkval = SYNTH_CHECK,
 	.vars = vars,
-	.probe = serial_synth_probe,
+	.probe = spk_serial_synth_probe,
 	.release = spk_serial_release,
 	.synth_immediate = spk_synth_immediate,
 	.catch_up = spk_do_catch_up,
diff --git a/drivers/staging/speakup/speakup_decext.c b/drivers/staging/speakup/speakup_decext.c
index b4ef915..d39a0de 100644
--- a/drivers/staging/speakup/speakup_decext.c
+++ b/drivers/staging/speakup/speakup_decext.c
@@ -130,7 +130,7 @@ static struct spk_synth synth_decext = {
 	.startup = SYNTH_START,
 	.checkval = SYNTH_CHECK,
 	.vars = vars,
-	.probe = serial_synth_probe,
+	.probe = spk_serial_synth_probe,
 	.release = spk_serial_release,
 	.synth_immediate = spk_synth_immediate,
 	.catch_up = do_catch_up,
@@ -162,8 +162,8 @@ static void do_catch_up(struct spk_synth *synth)
 	int jiffy_delta_val = 0;
 	int delay_time_val = 0;
 
-	jiffy_delta = get_var(JIFFY);
-	delay_time = get_var(DELAY);
+	jiffy_delta = spk_get_var(JIFFY);
+	delay_time = spk_get_var(DELAY);
 
 	spk_lock(flags);
 	jiffy_delta_val = jiffy_delta->u.n.value;
diff --git a/drivers/staging/speakup/speakup_decpc.c b/drivers/staging/speakup/speakup_decpc.c
index de25527..cda6b0f 100644
--- a/drivers/staging/speakup/speakup_decpc.c
+++ b/drivers/staging/speakup/speakup_decpc.c
@@ -375,8 +375,8 @@ static void do_catch_up(struct spk_synth *synth)
 	int jiffy_delta_val;
 	int delay_time_val;
 
-	jiffy_delta = get_var(JIFFY);
-	delay_time = get_var(DELAY);
+	jiffy_delta = spk_get_var(JIFFY);
+	delay_time = spk_get_var(DELAY);
 	spk_lock(flags);
 	jiffy_delta_val = jiffy_delta->u.n.value;
 	spk_unlock(flags);
diff --git a/drivers/staging/speakup/speakup_dectlk.c b/drivers/staging/speakup/speakup_dectlk.c
index daff3b9..0dd2eb9 100644
--- a/drivers/staging/speakup/speakup_dectlk.c
+++ b/drivers/staging/speakup/speakup_dectlk.c
@@ -134,7 +134,7 @@ static struct spk_synth synth_dectlk = {
 	.vars = vars,
 	.default_pitch = ap_defaults,
 	.default_vol = g5_defaults,
-	.probe = serial_synth_probe,
+	.probe = spk_serial_synth_probe,
 	.release = spk_serial_release,
 	.synth_immediate = spk_synth_immediate,
 	.catch_up = do_catch_up,
@@ -214,8 +214,8 @@ static void do_catch_up(struct spk_synth *synth)
 	int jiffy_delta_val;
 	int delay_time_val;
 
-	jiffy_delta = get_var(JIFFY);
-	delay_time = get_var(DELAY);
+	jiffy_delta = spk_get_var(JIFFY);
+	delay_time = spk_get_var(DELAY);
 	spk_lock(flags);
 	jiffy_delta_val = jiffy_delta->u.n.value;
 	spk_unlock(flags);
diff --git a/drivers/staging/speakup/speakup_dtlk.c b/drivers/staging/speakup/speakup_dtlk.c
index 97bc476..a9cefbd 100644
--- a/drivers/staging/speakup/speakup_dtlk.c
+++ b/drivers/staging/speakup/speakup_dtlk.c
@@ -198,8 +198,8 @@ static void do_catch_up(struct spk_synth *synth)
 	int jiffy_delta_val;
 	int delay_time_val;
 
-	jiffy_delta = get_var(JIFFY);
-	delay_time = get_var(DELAY);
+	jiffy_delta = spk_get_var(JIFFY);
+	delay_time = spk_get_var(DELAY);
 	spk_lock(flags);
 	jiffy_delta_val = jiffy_delta->u.n.value;
 	spk_unlock(flags);
diff --git a/drivers/staging/speakup/speakup_dummy.c b/drivers/staging/speakup/speakup_dummy.c
index c20f411..4a24b9c 100644
--- a/drivers/staging/speakup/speakup_dummy.c
+++ b/drivers/staging/speakup/speakup_dummy.c
@@ -102,7 +102,7 @@ static struct spk_synth synth_dummy = {
 	.startup = SYNTH_START,
 	.checkval = SYNTH_CHECK,
 	.vars = vars,
-	.probe = serial_synth_probe,
+	.probe = spk_serial_synth_probe,
 	.release = spk_serial_release,
 	.synth_immediate = spk_synth_immediate,
 	.catch_up = spk_do_catch_up,
diff --git a/drivers/staging/speakup/speakup_keypc.c b/drivers/staging/speakup/speakup_keypc.c
index 496e014..feb5f22 100644
--- a/drivers/staging/speakup/speakup_keypc.c
+++ b/drivers/staging/speakup/speakup_keypc.c
@@ -184,9 +184,9 @@ static void do_catch_up(struct spk_synth *synth)
 	int full_time_val;
 	int jiffy_delta_val;
 
-	jiffy_delta = get_var(JIFFY);
-	delay_time = get_var(DELAY);
-	full_time = get_var(FULL);
+	jiffy_delta = spk_get_var(JIFFY);
+	delay_time = spk_get_var(DELAY);
+	full_time = spk_get_var(FULL);
 spk_lock(flags);
 	jiffy_delta_val = jiffy_delta->u.n.value;
 	spk_unlock(flags);
diff --git a/drivers/staging/speakup/speakup_ltlk.c b/drivers/staging/speakup/speakup_ltlk.c
index 971de1a..326f94d 100644
--- a/drivers/staging/speakup/speakup_ltlk.c
+++ b/drivers/staging/speakup/speakup_ltlk.c
@@ -161,7 +161,7 @@ static int synth_probe(struct spk_synth *synth)
 {
 	int failed = 0;
 
-	failed = serial_synth_probe(synth);
+	failed = spk_serial_synth_probe(synth);
 	if (failed == 0)
 		synth_interrogate(synth);
 	synth->alive = !failed;
diff --git a/drivers/staging/speakup/speakup_spkout.c b/drivers/staging/speakup/speakup_spkout.c
index 9a3a80d..e74f856 100644
--- a/drivers/staging/speakup/speakup_spkout.c
+++ b/drivers/staging/speakup/speakup_spkout.c
@@ -107,7 +107,7 @@ static struct spk_synth synth_spkout = {
 	.startup = SYNTH_START,
 	.checkval = SYNTH_CHECK,
 	.vars = vars,
-	.probe = serial_synth_probe,
+	.probe = spk_serial_synth_probe,
 	.release = spk_serial_release,
 	.synth_immediate = spk_synth_immediate,
 	.catch_up = spk_do_catch_up,
diff --git a/drivers/staging/speakup/speakup_txprt.c b/drivers/staging/speakup/speakup_txprt.c
index 5d5bf7c..5a29b9f 100644
--- a/drivers/staging/speakup/speakup_txprt.c
+++ b/drivers/staging/speakup/speakup_txprt.c
@@ -100,7 +100,7 @@ static struct spk_synth synth_txprt = {
 	.startup = SYNTH_START,
 	.checkval = SYNTH_CHECK,
 	.vars = vars,
-	.probe = serial_synth_probe,
+	.probe = spk_serial_synth_probe,
 	.release = spk_serial_release,
 	.synth_immediate = spk_synth_immediate,
 	.catch_up = spk_do_catch_up,
diff --git a/drivers/staging/speakup/spk_priv.h b/drivers/staging/speakup/spk_priv.h
index a47c5b7..303105b 100644
--- a/drivers/staging/speakup/spk_priv.h
+++ b/drivers/staging/speakup/spk_priv.h
@@ -45,8 +45,8 @@
 #define KT_SPKUP 15
 
 extern const struct old_serial_port *spk_serial_init(int index);
-extern void stop_serial_interrupt(void);
-extern int wait_for_xmitr(void);
+extern void spk_stop_serial_interrupt(void);
+extern int spk_wait_for_xmitr(void);
 extern unsigned char spk_serial_in(void);
 extern unsigned char spk_serial_in_nowait(void);
 extern int spk_serial_out(const char ch);
@@ -55,13 +55,13 @@ extern void spk_serial_release(void);
 extern char synth_buffer_getc(void);
 extern char synth_buffer_peek(void);
 extern int synth_buffer_empty(void);
-extern struct var_t *get_var(enum var_id_t var_id);
+extern struct var_t *spk_get_var(enum var_id_t var_id);
 extern ssize_t spk_var_show(struct kobject *kobj, struct kobj_attribute *attr,
 	char *buf);
 extern ssize_t spk_var_store(struct kobject *kobj, struct kobj_attribute *attr,
 	const char *buf, size_t count);
 
-extern int serial_synth_probe(struct spk_synth *synth);
+extern int spk_serial_synth_probe(struct spk_synth *synth);
 extern const char *spk_synth_immediate(struct spk_synth *synth, const char *buff);
 extern void spk_do_catch_up(struct spk_synth *synth);
 extern void spk_synth_flush(struct spk_synth *synth);
diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/synth.c
index 5710fc5..33efbd3 100644
--- a/drivers/staging/speakup/synth.c
+++ b/drivers/staging/speakup/synth.c
@@ -20,9 +20,9 @@
 #define MAXSYNTHS       16      /* Max number of synths in array. */
 static struct spk_synth *synths[MAXSYNTHS];
 struct spk_synth *synth;
-char pitch_buff[32] = "";
+char spk_pitch_buff[32] = "";
 static int module_status;
-bool quiet_boot;
+bool spk_quiet_boot;
 
 struct speakup_info_t speakup_info = {
 	.spinlock = __SPIN_LOCK_UNLOCKED(speakup_info.spinlock),
@@ -32,7 +32,7 @@ EXPORT_SYMBOL_GPL(speakup_info);
 
 static int do_synth_init(struct spk_synth *in_synth);
 
-int serial_synth_probe(struct spk_synth *synth)
+int spk_serial_synth_probe(struct spk_synth *synth)
 {
 	const struct old_serial_port *ser;
 	int failed = 0;
@@ -59,7 +59,7 @@ int serial_synth_probe(struct spk_synth *synth)
 	synth->alive = 1;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(serial_synth_probe);
+EXPORT_SYMBOL_GPL(spk_serial_synth_probe);
 
 /* Main loop of the progression thread: keep eating from the buffer
  * and push to the serial port, waiting as needed
@@ -79,9 +79,9 @@ void spk_do_catch_up(struct spk_synth *synth)
 	int delay_time_val;
 	int full_time_val;
 
-	jiffy_delta = get_var(JIFFY);
-	full_time = get_var(FULL);
-	delay_time = get_var(DELAY);
+	jiffy_delta = spk_get_var(JIFFY);
+	full_time = spk_get_var(FULL);
+	delay_time = spk_get_var(DELAY);
 
 	spk_lock(flags);
 	jiffy_delta_val = jiffy_delta->u.n.value;
@@ -139,7 +139,7 @@ const char *spk_synth_immediate(struct spk_synth *synth, const char *buff)
 	while ((ch = *buff)) {
 		if (ch == '\n')
 			ch = synth->procspeech;
-		if (wait_for_xmitr())
+		if (spk_wait_for_xmitr())
 			outb(ch, speakup_info.port_tts);
 		else
 			return buff;
@@ -166,7 +166,7 @@ int spk_synth_is_alive_restart(struct spk_synth *synth)
 {
 	if (synth->alive)
 		return 1;
-	if (!synth->alive && wait_for_xmitr() > 0) {
+	if (!synth->alive && spk_wait_for_xmitr() > 0) {
 		/* restart */
 		synth->alive = 1;
 		synth_printf("%s", synth->init);
@@ -192,20 +192,20 @@ void synth_start(void)
 		synth_buffer_clear();
 		return;
 	}
-	trigger_time = get_var(TRIGGER);
+	trigger_time = spk_get_var(TRIGGER);
 	if (!timer_pending(&thread_timer))
 		mod_timer(&thread_timer, jiffies +
 			msecs_to_jiffies(trigger_time->u.n.value));
 }
 
-void do_flush(void)
+void spk_do_flush(void)
 {
 	speakup_info.flushing = 1;
 	synth_buffer_clear();
 	if (synth->alive) {
-		if (pitch_shift) {
-			synth_printf("%s", pitch_buff);
-			pitch_shift = 0;
+		if (spk_pitch_shift) {
+			synth_printf("%s", spk_pitch_buff);
+			spk_pitch_shift = 0;
 		}
 	}
 	wake_up_interruptible_all(&speakup_event);
@@ -241,7 +241,7 @@ EXPORT_SYMBOL_GPL(synth_printf);
 static int index_count;
 static int sentence_count;
 
-void reset_index_count(int sc)
+void spk_reset_index_count(int sc)
 {
 	static int first = 1;
 	if (first)
@@ -277,7 +277,7 @@ void synth_insert_next_index(int sent_num)
 	}
 }
 
-void get_index_count(int *linecount, int *sentcount)
+void spk_get_index_count(int *linecount, int *sentcount)
 {
 	int ind = synth->get_index();
 	if (ind) {
@@ -384,7 +384,7 @@ static int do_synth_init(struct spk_synth *in_synth)
 	for (var = synth->vars;
 		(var->var_id >= 0) && (var->var_id < MAXVARS); var++)
 		speakup_register_var(var);
-	if (!quiet_boot)
+	if (!spk_quiet_boot)
 		synth_printf("%s found\n", synth->long_name);
 	if (synth->attributes.name
 	&& sysfs_create_group(speakup_kobj, &(synth->attributes)) < 0)
@@ -412,7 +412,7 @@ void synth_release(void)
 		sysfs_remove_group(speakup_kobj, &(synth->attributes));
 	for (var = synth->vars; var->var_id != MAXVARS; var++)
 		speakup_unregister_var(var->var_id);
-	stop_serial_interrupt();
+	spk_stop_serial_interrupt();
 	synth->release();
 	synth = NULL;
 }
@@ -460,4 +460,4 @@ void synth_remove(struct spk_synth *in_synth)
 }
 EXPORT_SYMBOL_GPL(synth_remove);
 
-short punc_masks[] = { 0, SOME, MOST, PUNC, PUNC|B_SYM };
+short spk_punc_masks[] = { 0, SOME, MOST, PUNC, PUNC|B_SYM };
diff --git a/drivers/staging/speakup/thread.c b/drivers/staging/speakup/thread.c
index 103c5c8..42fa660 100644
--- a/drivers/staging/speakup/thread.c
+++ b/drivers/staging/speakup/thread.c
@@ -23,8 +23,8 @@ int speakup_thread(void *data)
 		DEFINE_WAIT(wait);
 		while (1) {
 			spk_lock(flags);
-			our_sound = unprocessed_sound;
-			unprocessed_sound.active = 0;
+			our_sound = spk_unprocessed_sound;
+			spk_unprocessed_sound.active = 0;
 			prepare_to_wait(&speakup_event, &wait,
 				TASK_INTERRUPTIBLE);
 			should_break = kthread_should_stop() ||
diff --git a/drivers/staging/speakup/varhandlers.c b/drivers/staging/speakup/varhandlers.c
index ab7de93..f8c1e45 100644
--- a/drivers/staging/speakup/varhandlers.c
+++ b/drivers/staging/speakup/varhandlers.c
@@ -16,24 +16,24 @@ static struct st_var_header var_headers[] = {
 	{ "ex_num", EXNUMBER, VAR_PROC, NULL, NULL },
 	{ "characters", CHARS, VAR_PROC, NULL, NULL },
 	{ "synth_direct", SYNTH_DIRECT, VAR_PROC, NULL, NULL },
-	{ "caps_start", CAPS_START, VAR_STRING, str_caps_start, NULL },
-	{ "caps_stop", CAPS_STOP, VAR_STRING, str_caps_stop, NULL },
+	{ "caps_start", CAPS_START, VAR_STRING, spk_str_caps_start, NULL },
+	{ "caps_stop", CAPS_STOP, VAR_STRING, spk_str_caps_stop, NULL },
 	{ "delay_time", DELAY, VAR_TIME, NULL, NULL },
 	{ "trigger_time", TRIGGER, VAR_TIME, NULL, NULL },
 	{ "jiffy_delta", JIFFY, VAR_TIME, NULL, NULL },
 	{ "full_time", FULL, VAR_TIME, NULL, NULL },
-	{ "spell_delay", SPELL_DELAY, VAR_NUM, &spell_delay, NULL },
-	{ "bleeps", BLEEPS, VAR_NUM, &bleeps, NULL },
-	{ "attrib_bleep", ATTRIB_BLEEP, VAR_NUM, &attrib_bleep, NULL },
-	{ "bleep_time", BLEEP_TIME, VAR_TIME, &bleep_time, NULL },
+	{ "spell_delay", SPELL_DELAY, VAR_NUM, &spk_spell_delay, NULL },
+	{ "bleeps", BLEEPS, VAR_NUM, &spk_bleeps, NULL },
+	{ "attrib_bleep", ATTRIB_BLEEP, VAR_NUM, &spk_attrib_bleep, NULL },
+	{ "bleep_time", BLEEP_TIME, VAR_TIME, &spk_bleep_time, NULL },
 	{ "cursor_time", CURSOR_TIME, VAR_TIME, NULL, NULL },
-	{ "punc_level", PUNC_LEVEL, VAR_NUM, &punc_level, NULL },
-	{ "reading_punc", READING_PUNC, VAR_NUM, &reading_punc, NULL },
-	{ "say_control", SAY_CONTROL, VAR_NUM, &say_ctrl, NULL },
-	{ "say_word_ctl", SAY_WORD_CTL, VAR_NUM, &say_word_ctl, NULL },
-	{ "no_interrupt", NO_INTERRUPT, VAR_NUM, &no_intr, NULL },
-	{ "key_echo", KEY_ECHO, VAR_NUM, &key_echo, NULL },
-	{ "bell_pos", BELL_POS, VAR_NUM, &bell_pos, NULL },
+	{ "punc_level", PUNC_LEVEL, VAR_NUM, &spk_punc_level, NULL },
+	{ "reading_punc", READING_PUNC, VAR_NUM, &spk_reading_punc, NULL },
+	{ "say_control", SAY_CONTROL, VAR_NUM, &spk_say_ctrl, NULL },
+	{ "say_word_ctl", SAY_WORD_CTL, VAR_NUM, &spk_say_word_ctl, NULL },
+	{ "no_interrupt", NO_INTERRUPT, VAR_NUM, &spk_no_intr, NULL },
+	{ "key_echo", KEY_ECHO, VAR_NUM, &spk_key_echo, NULL },
+	{ "bell_pos", BELL_POS, VAR_NUM, &spk_bell_pos, NULL },
 	{ "rate", RATE, VAR_NUM, NULL, NULL },
 	{ "pitch", PITCH, VAR_NUM, NULL, NULL },
 	{ "vol", VOL, VAR_NUM, NULL, NULL },
@@ -58,7 +58,7 @@ static struct punc_var_t punc_vars[] = {
 	{ -1, -1 },
 };
 
-int chartab_get_value(char *keyword)
+int spk_chartab_get_value(char *keyword)
 {
 	int value = 0;
 
@@ -103,11 +103,11 @@ void speakup_register_var(struct var_t *var)
 	p_header->data = var;
 	switch (p_header->var_type) {
 	case VAR_STRING:
-		set_string_var(nothing, p_header, 0);
+		spk_set_string_var(nothing, p_header, 0);
 		break;
 	case VAR_NUM:
 	case VAR_TIME:
-		set_num_var(0, p_header, E_DEFAULT);
+		spk_set_num_var(0, p_header, E_DEFAULT);
 		break;
 	default:
 		break;
@@ -123,7 +123,7 @@ void speakup_unregister_var(enum var_id_t var_id)
 	p_header->data = NULL;
 }
 
-struct st_var_header *get_var_header(enum var_id_t var_id)
+struct st_var_header *spk_get_var_header(enum var_id_t var_id)
 {
 	struct st_var_header *p_header;
 	if (var_id < 0 || var_id >= MAXVARS)
@@ -134,7 +134,7 @@ struct st_var_header *get_var_header(enum var_id_t var_id)
 	return p_header;
 }
 
-struct st_var_header *var_header_by_name(const char *name)
+struct st_var_header *spk_var_header_by_name(const char *name)
 {
 	int i;
 	struct st_var_header *where = NULL;
@@ -151,15 +151,15 @@ struct st_var_header *var_header_by_name(const char *name)
 	return where;
 }
 
-struct var_t *get_var(enum var_id_t var_id)
+struct var_t *spk_get_var(enum var_id_t var_id)
 {
 	BUG_ON(var_id < 0 || var_id >= MAXVARS);
 	BUG_ON(!var_ptrs[var_id]);
 	return var_ptrs[var_id]->data;
 }
-EXPORT_SYMBOL_GPL(get_var);
+EXPORT_SYMBOL_GPL(spk_get_var);
 
-struct punc_var_t *get_punc_var(enum var_id_t var_id)
+struct punc_var_t *spk_get_punc_var(enum var_id_t var_id)
 {
 	struct punc_var_t *rv = NULL;
 	struct punc_var_t *where;
@@ -175,7 +175,7 @@ struct punc_var_t *get_punc_var(enum var_id_t var_id)
 }
 
 /* handlers for setting vars */
-int set_num_var(int input, struct st_var_header *var, int how)
+int spk_set_num_var(int input, struct st_var_header *var, int how)
 {
 	int val;
 	short ret = 0;
@@ -217,7 +217,7 @@ int set_num_var(int input, struct st_var_header *var, int how)
 	if (p_val != NULL)
 		*p_val = val;
 	if (var->var_id == PUNC_LEVEL) {
-		punc_mask = punc_masks[val];
+		spk_punc_mask = spk_punc_masks[val];
 		return ret;
 	}
 	if (var_data->u.n.multiplier != 0)
@@ -232,7 +232,7 @@ int set_num_var(int input, struct st_var_header *var, int how)
 	if (!var_data->u.n.synth_fmt)
 		return ret;
 	if (var->var_id == PITCH)
-		cp = pitch_buff;
+		cp = spk_pitch_buff;
 	else
 		cp = buf;
 	if (!var_data->u.n.out_str)
@@ -244,7 +244,7 @@ int set_num_var(int input, struct st_var_header *var, int how)
 	return ret;
 }
 
-int set_string_var(const char *page, struct st_var_header *var, int len)
+int spk_set_string_var(const char *page, struct st_var_header *var, int len)
 {
 	int ret = 0;
 	struct var_t *var_data = var->data;
@@ -267,21 +267,21 @@ int set_string_var(const char *page, struct st_var_header *var, int len)
 	return ret;
 }
 
-/* set_mask_bits sets or clears the punc/delim/repeat bits,
+/* spk_set_mask_bits sets or clears the punc/delim/repeat bits,
  * if input is null uses the defaults.
  * values for how: 0 clears bits of chars supplied,
  * 1 clears allk, 2 sets bits for chars */
-int set_mask_bits(const char *input, const int which, const int how)
+int spk_set_mask_bits(const char *input, const int which, const int how)
 {
 	u_char *cp;
-	short mask = punc_info[which].mask;
+	short mask = spk_punc_info[which].mask;
 	if (how&1) {
-		for (cp = (u_char *)punc_info[3].value; *cp; cp++)
+		for (cp = (u_char *)spk_punc_info[3].value; *cp; cp++)
 			spk_chartab[*cp] &= ~mask;
 	}
 	cp = (u_char *)input;
 	if (cp == 0)
-		cp = punc_info[which].value;
+		cp = spk_punc_info[which].value;
 	else {
 		for ( ; *cp; cp++) {
 			if (*cp < SPACE)
@@ -308,7 +308,7 @@ int set_mask_bits(const char *input, const int which, const int how)
 	return 0;
 }
 
-char *strlwr(char *s)
+char *spk_strlwr(char *s)
 {
 	char *p;
 	if (s == NULL)
@@ -341,7 +341,7 @@ char *speakup_s2i(char *start, int *dest)
 	return start;
 }
 
-char *s2uchar(char *start, char *dest)
+char *spk_s2uchar(char *start, char *dest)
 {
 	int val = 0;
 	while (*start && *start <= SPACE)
@@ -357,7 +357,7 @@ char *s2uchar(char *start, char *dest)
 	return start;
 }
 
-char *xlate(char *s)
+char *spk_xlate(char *s)
 {
 	static const char finds[] = "nrtvafe";
 	static const char subs[] = "\n\r\t\013\001\014\033";
diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 6ed7e7c..c120b6f 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -716,6 +716,10 @@ int usb_get_configuration(struct usb_device *dev)
 			result = -ENOMEM;
 			goto err;
 		}
+
+		if (dev->quirks & USB_QUIRK_DELAY_INIT)
+			msleep(100);
+
 		result = usb_get_descriptor(dev, USB_DT_CONFIG, cfgno,
 		    bigbuffer, length);
 		if (result < 0) {
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 987d3ef..a5545de 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -41,6 +41,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Microsoft LifeCam-VX700 v2.0 */
 	{ USB_DEVICE(0x045e, 0x0770), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Logitech HD Pro Webcams C920 and C930e */
+	{ USB_DEVICE(0x046d, 0x082d), .driver_info = USB_QUIRK_DELAY_INIT },
+	{ USB_DEVICE(0x046d, 0x0843), .driver_info = USB_QUIRK_DELAY_INIT },
+
 	/* Logitech Webcam C200 */
 	{ USB_DEVICE(0x046d, 0x0802), .driver_info = USB_QUIRK_RESET_RESUME },
 
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 5699bc4..4f31fcb 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -48,6 +48,7 @@
 #define PCI_VENDOR_ID_SYNOPSYS		0x16c3
 #define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3	0xabcd
 #define PCI_DEVICE_ID_INTEL_BYT		0x0f37
+#define PCI_DEVICE_ID_INTEL_MRFLD	0x119e
 
 struct dwc3_pci {
 	struct device		*dev;
@@ -157,6 +158,7 @@ static DEFINE_PCI_DEVICE_TABLE(dwc3_pci_id_table) = {
 				PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3),
 	},
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BYT), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRFLD), },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, dwc3_pci_id_table);
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index 2694ed6..b272634 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -149,6 +149,7 @@ struct ehci_hcd {			/* one per controller */
 	unsigned		use_dummy_qh:1;	/* AMD Frame List table quirk*/
 	unsigned		has_synopsys_hc_bug:1; /* Synopsys HC */
 	unsigned		frame_index_bug:1; /* MosChip (AKA NetMos) */
+	unsigned		imx28_write_fix:1; /* For Freescale i.MX28 */
 
 	/* required for usb32 quirk */
 	#define OHCI_CTRL_HCFS          (3 << 6)
@@ -656,6 +657,18 @@ static inline unsigned int ehci_readl(const struct ehci_hcd *ehci,
 #endif
 }
 
+#ifdef CONFIG_SOC_IMX28
+static inline void imx28_ehci_writel(const unsigned int val,
+		volatile __u32 __iomem *addr)
+{
+	__asm__ ("swp %0, %0, [%1]" : : "r"(val), "r"(addr));
+}
+#else
+static inline void imx28_ehci_writel(const unsigned int val,
+		volatile __u32 __iomem *addr)
+{
+}
+#endif
 static inline void ehci_writel(const struct ehci_hcd *ehci,
 		const unsigned int val, __u32 __iomem *regs)
 {
@@ -664,7 +677,10 @@ static inline void ehci_writel(const struct ehci_hcd *ehci,
 		writel_be(val, regs) :
 		writel(val, regs);
 #else
-	writel(val, regs);
+	if (ehci->imx28_write_fix)
+		imx28_ehci_writel(val, regs);
+	else
+		writel(val, regs);
 #endif
 }
 
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index dd2c8c3..640905e 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -140,6 +140,8 @@ struct pl2303_private {
 	u8 line_control;
 	u8 line_status;
 	enum pl2303_type type;
+
+	u8 line_settings[7];
 };
 
 static int pl2303_vendor_read(__u16 value, __u16 index,
@@ -254,10 +256,6 @@ static void pl2303_set_termios(struct tty_struct *tty,
 	int baud_floor, baud_ceil;
 	int k;
 
-	/* The PL2303 is reported to lose bytes if you change
-	   serial settings even to the same values as before. Thus
-	   we actually need to filter in this specific case */
-
 	if (old_termios && !tty_termios_hw_change(tty->termios, old_termios))
 		return;
 
@@ -395,10 +393,29 @@ static void pl2303_set_termios(struct tty_struct *tty,
 		dev_dbg(&port->dev, "parity = none\n");
 	}
 
-	i = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			    SET_LINE_REQUEST, SET_LINE_REQUEST_TYPE,
-			    0, 0, buf, 7, 100);
-	dev_dbg(&port->dev, "0x21:0x20:0:0  %d\n", i);
+	/*
+	 * Some PL2303 are known to lose bytes if you change serial settings
+	 * even to the same values as before. Thus we actually need to filter
+	 * in this specific case.
+	 *
+	 * Note that the tty_termios_hw_change check above is not sufficient
+	 * as a previously requested baud rate may differ from the one
+	 * actually used (and stored in old_termios).
+	 *
+	 * NOTE: No additional locking needed for line_settings as it is
+	 *       only used in set_termios, which is serialised against itself.
+	 */
+	if (!old_termios || memcmp(buf, priv->line_settings, 7)) {
+		i = usb_control_msg(serial->dev,
+				    usb_sndctrlpipe(serial->dev, 0),
+				    SET_LINE_REQUEST, SET_LINE_REQUEST_TYPE,
+				    0, 0, buf, 7, 100);
+
+		dev_dbg(&port->dev, "0x21:0x20:0:0  %d\n", i);
+
+		if (i == 7)
+			memcpy(priv->line_settings, buf, 7);
+	}
 
 	/* change control lines if we are switching to or from B0 */
 	spin_lock_irqsave(&priv->lock, flags);
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 86eff48..503a6bd 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -995,6 +995,8 @@ int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
 		bytes = min(bytes, working_bytes);
 		kaddr = kmap_atomic(page_out);
 		memcpy(kaddr + *pg_offset, buf + buf_offset, bytes);
+		if (*pg_index == (vcnt - 1) && *pg_offset == 0)
+			memset(kaddr + bytes, 0, PAGE_CACHE_SIZE - bytes);
 		kunmap_atomic(kaddr);
 		flush_dcache_page(page_out);
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index efecfb7..070bdbb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -37,6 +37,7 @@
 #include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
+#include <linux/bitops.h>
 
 #include "ext4_jbd2.h"
 #include "xattr.h"
@@ -3640,18 +3641,20 @@ int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *iloc)
 void ext4_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = EXT4_I(inode)->i_flags;
+	unsigned int new_fl = 0;
 
-	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
 	if (flags & EXT4_SYNC_FL)
-		inode->i_flags |= S_SYNC;
+		new_fl |= S_SYNC;
 	if (flags & EXT4_APPEND_FL)
-		inode->i_flags |= S_APPEND;
+		new_fl |= S_APPEND;
 	if (flags & EXT4_IMMUTABLE_FL)
-		inode->i_flags |= S_IMMUTABLE;
+		new_fl |= S_IMMUTABLE;
 	if (flags & EXT4_NOATIME_FL)
-		inode->i_flags |= S_NOATIME;
+		new_fl |= S_NOATIME;
 	if (flags & EXT4_DIRSYNC_FL)
-		inode->i_flags |= S_DIRSYNC;
+		new_fl |= S_DIRSYNC;
+	set_mask_bits(&inode->i_flags,
+		      S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC, new_fl);
 }
 
 /* Propagate flags from i_flags to EXT4_I(inode)->i_flags */
diff --git a/fs/hpfs/dir.c b/fs/hpfs/dir.c
index b8472f8..ea2b23c5 100644
--- a/fs/hpfs/dir.c
+++ b/fs/hpfs/dir.c
@@ -33,25 +33,27 @@ static loff_t hpfs_dir_lseek(struct file *filp, loff_t off, int whence)
 	if (whence == SEEK_DATA || whence == SEEK_HOLE)
 		return -EINVAL;
 
+	mutex_lock(&i->i_mutex);
 	hpfs_lock(s);
 
 	/*printk("dir lseek\n");*/
 	if (new_off == 0 || new_off == 1 || new_off == 11 || new_off == 12 || new_off == 13) goto ok;
-	mutex_lock(&i->i_mutex);
 	pos = ((loff_t) hpfs_de_as_down_as_possible(s, hpfs_inode->i_dno) << 4) + 1;
 	while (pos != new_off) {
 		if (map_pos_dirent(i, &pos, &qbh)) hpfs_brelse4(&qbh);
 		else goto fail;
 		if (pos == 12) goto fail;
 	}
-	mutex_unlock(&i->i_mutex);
+	hpfs_add_pos(i, &filp->f_pos);
 ok:
+	filp->f_pos = new_off;
 	hpfs_unlock(s);
-	return filp->f_pos = new_off;
-fail:
 	mutex_unlock(&i->i_mutex);
+	return new_off;
+fail:
 	/*printk("illegal lseek: %016llx\n", new_off);*/
 	hpfs_unlock(s);
+	mutex_unlock(&i->i_mutex);
 	return -ESPIPE;
 }
 
diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index bd3a960..04cae5c 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -548,16 +548,19 @@ int nfs_async_inode_return_delegation(struct inode *inode,
 
 	rcu_read_lock();
 	delegation = rcu_dereference(NFS_I(inode)->delegation);
+	if (delegation == NULL)
+		goto out_enoent;
 
-	if (!clp->cl_mvops->match_stateid(&delegation->stateid, stateid)) {
-		rcu_read_unlock();
-		return -ENOENT;
-	}
+	if (!clp->cl_mvops->match_stateid(&delegation->stateid, stateid))
+		goto out_enoent;
 	nfs_mark_return_delegation(server, delegation);
 	rcu_read_unlock();
 
 	nfs_delegation_run_state_manager(clp);
 	return 0;
+out_enoent:
+	rcu_read_unlock();
+	return -ENOENT;
 }
 
 static struct inode *
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 7602783..8021098 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2389,8 +2389,8 @@ out_dio:
 
 	if (((file->f_flags & O_DSYNC) && !direct_io) || IS_SYNC(inode) ||
 	    ((file->f_flags & O_DIRECT) && !direct_io)) {
-		ret = filemap_fdatawrite_range(file->f_mapping, pos,
-					       pos + count - 1);
+		ret = filemap_fdatawrite_range(file->f_mapping, *ppos,
+					       *ppos + count - 1);
 		if (ret < 0)
 			written = ret;
 
@@ -2403,8 +2403,8 @@ out_dio:
 		}
 
 		if (!ret)
-			ret = filemap_fdatawait_range(file->f_mapping, pos,
-						      pos + count - 1);
+			ret = filemap_fdatawait_range(file->f_mapping, *ppos,
+						      *ppos + count - 1);
 	}
 
 	/*
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 0a86e30..c8f6801 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -710,6 +710,12 @@ static int ocfs2_release_dquot(struct dquot *dquot)
 	 */
 	if (status < 0)
 		mlog_errno(status);
+	/*
+	 * Clear dq_off so that we search for the structure in quota file next
+	 * time we acquire it. The structure might be deleted and reallocated
+	 * elsewhere by another node while our dquot structure is on freelist.
+	 */
+	dquot->dq_off = 0;
 	clear_bit(DQ_ACTIVE_B, &dquot->dq_flags);
 out_trans:
 	ocfs2_commit_trans(osb, handle);
@@ -748,16 +754,17 @@ static int ocfs2_acquire_dquot(struct dquot *dquot)
 	status = ocfs2_lock_global_qf(info, 1);
 	if (status < 0)
 		goto out;
-	if (!test_bit(DQ_READ_B, &dquot->dq_flags)) {
-		status = ocfs2_qinfo_lock(info, 0);
-		if (status < 0)
-			goto out_dq;
-		status = qtree_read_dquot(&info->dqi_gi, dquot);
-		ocfs2_qinfo_unlock(info, 0);
-		if (status < 0)
-			goto out_dq;
-	}
-	set_bit(DQ_READ_B, &dquot->dq_flags);
+	status = ocfs2_qinfo_lock(info, 0);
+	if (status < 0)
+		goto out_dq;
+	/*
+	 * We always want to read dquot structure from disk because we don't
+	 * know what happened with it while it was on freelist.
+	 */
+	status = qtree_read_dquot(&info->dqi_gi, dquot);
+	ocfs2_qinfo_unlock(info, 0);
+	if (status < 0)
+		goto out_dq;
 
 	OCFS2_DQUOT(dquot)->dq_use_count++;
 	OCFS2_DQUOT(dquot)->dq_origspace = dquot->dq_dqb.dqb_curspace;
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index f100bf7..b6cfcf2 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -1300,10 +1300,6 @@ int ocfs2_local_release_dquot(handle_t *handle, struct dquot *dquot)
 	ocfs2_journal_dirty(handle, od->dq_chunk->qc_headerbh);
 
 out:
-	/* Clear the read bit so that next time someone uses this
-	 * dquot he reads fresh info from disk and allocates local
-	 * dquot structure */
-	clear_bit(DQ_READ_B, &dquot->dq_flags);
 	return status;
 }
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 437195f..78050f9 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2090,6 +2090,7 @@ static int proc_map_files_get_link(struct dentry *dentry, struct path *path)
 	if (rc)
 		goto out_mmput;
 
+	rc = -ENOENT;
 	down_read(&mm->mmap_sem);
 	vma = find_exact_vma(mm, vm_start, vm_end);
 	if (vma && vma->vm_file) {
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index a3b6b82..c1dde8e 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -185,6 +185,21 @@ static inline unsigned long __ffs64(u64 word)
 
 #ifdef __KERNEL__
 
+#ifndef set_mask_bits
+#define set_mask_bits(ptr, _mask, _bits)	\
+({								\
+	const typeof(*ptr) mask = (_mask), bits = (_bits);	\
+	typeof(*ptr) old, new;					\
+								\
+	do {							\
+		old = ACCESS_ONCE(*ptr);			\
+		new = (old & ~mask) | bits;			\
+	} while (cmpxchg(ptr, old, new) != old);		\
+								\
+	new;							\
+})
+#endif
+
 #ifndef find_last_bit
 /**
  * find_last_bit - find the last set bit in a memory region
diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index babdb98..4eaa633 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -200,6 +200,7 @@ struct fw_device {
 	unsigned irmc:1;
 	unsigned bc_implemented:2;
 
+	work_func_t workfn;
 	struct delayed_work work;
 	struct fw_attribute_group attribute_group;
 };
diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 265e2c3..f5df3dc 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -106,13 +106,13 @@ static inline u64 get_jiffies_64(void)
 #define time_after(a,b)		\
 	(typecheck(unsigned long, a) && \
 	 typecheck(unsigned long, b) && \
-	 ((long)(b) - (long)(a) < 0))
+	 ((long)((b) - (a)) < 0))
 #define time_before(a,b)	time_after(b,a)
 
 #define time_after_eq(a,b)	\
 	(typecheck(unsigned long, a) && \
 	 typecheck(unsigned long, b) && \
-	 ((long)(a) - (long)(b) >= 0))
+	 ((long)((a) - (b)) >= 0))
 #define time_before_eq(a,b)	time_after_eq(b,a)
 
 /*
@@ -135,13 +135,13 @@ static inline u64 get_jiffies_64(void)
 #define time_after64(a,b)	\
 	(typecheck(__u64, a) &&	\
 	 typecheck(__u64, b) && \
-	 ((__s64)(b) - (__s64)(a) < 0))
+	 ((__s64)((b) - (a)) < 0))
 #define time_before64(a,b)	time_after64(b,a)
 
 #define time_after_eq64(a,b)	\
 	(typecheck(__u64, a) && \
 	 typecheck(__u64, b) && \
-	 ((__s64)(a) - (__s64)(b) >= 0))
+	 ((__s64)((a) - (b)) >= 0))
 #define time_before_eq64(a,b)	time_after_eq64(b,a)
 
 /*
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 7e13eb4..c6fa0eb 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -394,6 +394,8 @@ enum {
 	ATA_HORKAGE_BROKEN_FPDMA_AA	= (1 << 15),	/* skip AA */
 	ATA_HORKAGE_DUMP_ID	= (1 << 16),	/* dump IDENTIFY data */
 	ATA_HORKAGE_MAX_SEC_LBA48 = (1 << 17),	/* Set max sects to 65535 */
+	ATA_HORKAGE_NOLPM	= (1 << 20),	/* don't use LPM */
+	ATA_HORKAGE_WD_BROKEN_LPM = (1 << 21),	/* some WDs have broken LPM */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index bd96ecd..c49c363 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -60,6 +60,12 @@ struct tp_module {
 	unsigned int num_tracepoints;
 	struct tracepoint * const *tracepoints_ptrs;
 };
+bool trace_module_has_bad_taint(struct module *mod);
+#else
+static inline bool trace_module_has_bad_taint(struct module *mod)
+{
+	return false;
+}
 #endif /* CONFIG_MODULES */
 
 struct tracepoint_iter {
diff --git a/ipc/msg.c b/ipc/msg.c
index 7385de2..25f1a61 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -296,7 +296,9 @@ static void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	}
 	atomic_sub(msq->q_cbytes, &ns->msg_bytes);
 	security_msg_queue_free(msq);
+	ipc_lock_by_ptr(&msq->q_perm);
 	ipc_rcu_putref(msq);
+	ipc_unlock(&msq->q_perm);
 }
 
 /*
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 2627f0d0..f1dec4b 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2327,9 +2327,9 @@ int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
 
 	task_lock(current);
 	cs = nearest_hardwall_ancestor(task_cs(current));
+	allowed = node_isset(node, cs->mems_allowed);
 	task_unlock(current);
 
-	allowed = node_isset(node, cs->mems_allowed);
 	mutex_unlock(&callback_mutex);
 	return allowed;
 }
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index a561ed3..91baa12 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -785,8 +785,7 @@ static irqreturn_t irq_thread_fn(struct irq_desc *desc,
 
 static void wake_threads_waitq(struct irq_desc *desc)
 {
-	if (atomic_dec_and_test(&desc->threads_active) &&
-	    waitqueue_active(&desc->wait_for_threads))
+	if (atomic_dec_and_test(&desc->threads_active))
 		wake_up(&desc->wait_for_threads);
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7963693..847287c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5009,15 +5009,15 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
 	/*
-	 * Ensure the task's vruntime is normalized, so that when its
+	 * Ensure the task's vruntime is normalized, so that when it's
 	 * switched back to the fair class the enqueue_entity(.flags=0) will
 	 * do the right thing.
 	 *
-	 * If it was on_rq, then the dequeue_entity(.flags=0) will already
-	 * have normalized the vruntime, if it was !on_rq, then only when
+	 * If it's on_rq, then the dequeue_entity(.flags=0) will already
+	 * have normalized the vruntime, if it's !on_rq, then only when
 	 * the task is sleeping will it still have non-normalized vruntime.
 	 */
-	if (!se->on_rq && p->state != TASK_RUNNING) {
+	if (!p->on_rq && p->state != TASK_RUNNING) {
 		/*
 		 * Fix up our vruntime so that the current sleep doesn't
 		 * cause 'unlimited' sleep bonus.
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 29111da..2f737f5 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1354,6 +1354,16 @@ static void trace_module_add_events(struct module *mod)
 	struct ftrace_module_file_ops *file_ops = NULL;
 	struct ftrace_event_call **call, **start, **end;
 
+	if (!mod->num_trace_events)
+		return;
+
+	/* Don't add infrastructure for mods without tracepoints */
+	if (trace_module_has_bad_taint(mod)) {
+		pr_err("%s: module has bad taint, not creating trace events\n",
+		       mod->name);
+		return;
+	}
+
 	start = mod->trace_events;
 	end = mod->trace_events + mod->num_trace_events;
 
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index d96ba22..23d8560 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -628,6 +628,11 @@ void tracepoint_iter_reset(struct tracepoint_iter *iter)
 EXPORT_SYMBOL_GPL(tracepoint_iter_reset);
 
 #ifdef CONFIG_MODULES
+bool trace_module_has_bad_taint(struct module *mod)
+{
+	return mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP));
+}
+
 static int tracepoint_module_coming(struct module *mod)
 {
 	struct tp_module *tp_mod, *iter;
@@ -638,7 +643,7 @@ static int tracepoint_module_coming(struct module *mod)
 	 * module headers (for forced load), to make sure we don't cause a crash.
 	 * Staging and out-of-tree GPL modules are fine.
 	 */
-	if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)))
+	if (trace_module_has_bad_taint(mod))
 		return 0;
 	mutex_lock(&tracepoints_mutex);
 	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 91eb0c5..15162a0 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -242,6 +242,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 		return NULL;
 
 	spin_lock_init(&sta->lock);
+	spin_lock_init(&sta->ps_lock);
 	INIT_WORK(&sta->drv_unblock_wk, sta_unblock);
 	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
 	mutex_init(&sta->ampdu_mlme.mtx);
@@ -979,6 +980,8 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 
 	skb_queue_head_init(&pending);
 
+	/* sync with ieee80211_tx_h_unicast_ps_buf */
+	spin_lock(&sta->ps_lock);
 	/* Send all buffered frames to the station */
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		int count = skb_queue_len(&pending), tmp;
@@ -998,6 +1001,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	}
 
 	ieee80211_add_pending_skbs_fn(local, &pending, clear_sta_ps_flags, sta);
+	spin_unlock(&sta->ps_lock);
 
 	local->total_ps_buffered -= buffered;
 
@@ -1045,6 +1049,7 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 	memcpy(nullfunc->addr1, sta->sta.addr, ETH_ALEN);
 	memcpy(nullfunc->addr2, sdata->vif.addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, sdata->vif.addr, ETH_ALEN);
+	nullfunc->seq_ctrl = 0;
 
 	skb->priority = tid;
 	skb_set_queue_mapping(skb, ieee802_1d_to_ac[tid]);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index a470e11..4223a28 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -233,6 +233,7 @@ struct sta_ampdu_mlme {
  * @drv_unblock_wk: used for driver PS unblocking
  * @listen_interval: listen interval of this station, when we're acting as AP
  * @_flags: STA flags, see &enum ieee80211_sta_info_flags, do not use directly
+ * @ps_lock: used for powersave (when mac80211 is the AP) related locking
  * @ps_tx_buf: buffers (per AC) of frames to transmit to this station
  *	when it leaves power saving state or polls
  * @tx_filtered: buffers (per AC) of frames we already tried to
@@ -309,10 +310,8 @@ struct sta_info {
 	/* use the accessors defined below */
 	unsigned long _flags;
 
-	/*
-	 * STA powersave frame queues, no more than the internal
-	 * locking required.
-	 */
+	/* STA powersave lock and frame queues */
+	spinlock_t ps_lock;
 	struct sk_buff_head ps_tx_buf[IEEE80211_NUM_ACS];
 	struct sk_buff_head tx_filtered[IEEE80211_NUM_ACS];
 	unsigned long driver_buffered_tids;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index df9e376..2be46b1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -462,6 +462,20 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 		if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
 			purge_old_ps_buffers(tx->local);
+
+		/* sync with ieee80211_sta_ps_deliver_wakeup */
+		spin_lock(&sta->ps_lock);
+		/*
+		 * STA woke up the meantime and all the frames on ps_tx_buf have
+		 * been queued to pending queue. No reordering can happen, go
+		 * ahead and Tx the packet.
+		 */
+		if (!test_sta_flag(sta, WLAN_STA_PS_STA) &&
+		    !test_sta_flag(sta, WLAN_STA_PS_DRIVER)) {
+			spin_unlock(&sta->ps_lock);
+			return TX_CONTINUE;
+		}
+
 		if (skb_queue_len(&sta->ps_tx_buf[ac]) >= STA_MAX_TX_BUFFER) {
 			struct sk_buff *old = skb_dequeue(&sta->ps_tx_buf[ac]);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
@@ -476,6 +490,7 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 		info->control.vif = &tx->sdata->vif;
 		info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 		skb_queue_tail(&sta->ps_tx_buf[ac], tx->skb);
+		spin_unlock(&sta->ps_lock);
 
 		if (!timer_pending(&local->sta_cleanup))
 			mod_timer(&local->sta_cleanup,
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 469ef67..18bacd3 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -747,6 +747,13 @@ sctp_disposition_t sctp_sf_do_5_1D_ce(const struct sctp_endpoint *ep,
 		struct sctp_chunk auth;
 		sctp_ierror_t ret;
 
+		/* Make sure that we and the peer are AUTH capable */
+		if (!sctp_auth_enable || !new_asoc->peer.auth_capable) {
+			kfree_skb(chunk->auth_chunk);
+			sctp_association_free(new_asoc);
+			return sctp_sf_pdiscard(ep, asoc, type, arg, commands);
+		}
+
 		/* set-up our fake chunk so that we can process it */
 		auth.skb = chunk->auth_chunk;
 		auth.asoc = chunk->asoc;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 5959b80..079005a 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -151,9 +151,8 @@ static inline void unix_set_secdata(struct scm_cookie *scm, struct sk_buff *skb)
 
 static inline unsigned int unix_hash_fold(__wsum n)
 {
-	unsigned int hash = (__force unsigned int)n;
+	unsigned int hash = (__force unsigned int)csum_fold(n);
 
-	hash ^= hash>>16;
 	hash ^= hash>>8;
 	return hash&(UNIX_HASH_SIZE-1);
 }
diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index c95fdda..ca29f92 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -62,7 +62,7 @@ create_package() {
 	fi
 
 	# Create the package
-	dpkg-gencontrol -isp $forcearch -p$pname -P"$pdir"
+	dpkg-gencontrol -isp $forcearch -Vkernel:debarch="${debarch:-$(dpkg --print-architecture)}" -p$pname -P"$pdir"
 	dpkg --build "$pdir" ..
 }
 
@@ -252,15 +252,14 @@ mkdir -p "$destdir"
 (cd $objtree; tar -c -f - -T "$objtree/debian/hdrobjfiles") | (cd $destdir; tar -xf -)
 ln -sf "/usr/src/linux-headers-$version" "$kernel_headers_dir/lib/modules/$version/build"
 rm -f "$objtree/debian/hdrsrcfiles" "$objtree/debian/hdrobjfiles"
-arch=$(dpkg --print-architecture)
 
 cat <<EOF >> debian/control
 
 Package: $kernel_headers_packagename
 Provides: linux-headers, linux-headers-2.6
-Architecture: $arch
-Description: Linux kernel headers for $KERNELRELEASE on $arch
- This package provides kernel header files for $KERNELRELEASE on $arch
+Architecture: any
+Description: Linux kernel headers for $KERNELRELEASE on \${kernel:debarch}
+ This package provides kernel header files for $KERNELRELEASE on \${kernel:debarch}
  .
  This is useful for people who need to build external modules
 EOF
diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 794f37a..d38a2a9 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -133,7 +133,7 @@ static int snd_compr_open(struct inode *inode, struct file *f)
 		kfree(data);
 	}
 	snd_card_unref(compr->card);
-	return 0;
+	return ret;
 }
 
 static int snd_compr_free(struct inode *inode, struct file *f)
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9df1421..21bc6d6 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6164,6 +6164,9 @@ static void alc269_fill_coef(struct hda_codec *codec)
 
 	if (spec->codec_variant != ALC269_TYPE_ALC269VB)
 		return;
+	/* ALC271X doesn't seem to support these COEFs (bko#52181) */
+	if (!strcmp(codec->chip_name, "ALC271X"))
+		return;
 
 	if ((alc_get_coef0(codec) & 0x00ff) < 0x015) {
 		alc_write_coef_idx(codec, 0xf, 0x960b);
diff --git a/sound/pci/oxygen/xonar_dg.c b/sound/pci/oxygen/xonar_dg.c
index 77acd79..eb7ad77 100644
--- a/sound/pci/oxygen/xonar_dg.c
+++ b/sound/pci/oxygen/xonar_dg.c
@@ -294,6 +294,16 @@ static int output_switch_put(struct snd_kcontrol *ctl,
 		oxygen_write16_masked(chip, OXYGEN_GPIO_DATA,
 				      data->output_sel == 1 ? GPIO_HP_REAR : 0,
 				      GPIO_HP_REAR);
+		oxygen_write8_masked(chip, OXYGEN_PLAY_ROUTING,
+				     data->output_sel == 0 ?
+				     OXYGEN_PLAY_MUTE01 :
+				     OXYGEN_PLAY_MUTE23 |
+				     OXYGEN_PLAY_MUTE45 |
+				     OXYGEN_PLAY_MUTE67,
+				     OXYGEN_PLAY_MUTE01 |
+				     OXYGEN_PLAY_MUTE23 |
+				     OXYGEN_PLAY_MUTE45 |
+				     OXYGEN_PLAY_MUTE67);
 	}
 	mutex_unlock(&chip->mutex);
 	return changed;
@@ -596,7 +606,7 @@ struct oxygen_model model_xonar_dg = {
 	.model_data_size = sizeof(struct dg),
 	.device_config = PLAYBACK_0_TO_I2S |
 			 PLAYBACK_1_TO_SPDIF |
-			 CAPTURE_0_FROM_I2S_2 |
+			 CAPTURE_0_FROM_I2S_1 |
 			 CAPTURE_1_FROM_SPDIF,
 	.dac_channels_pcm = 6,
 	.dac_channels_mixer = 0,
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 9c6a7fe..497cfb4 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -842,6 +842,7 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
 		}
 		break;
 
+	case USB_ID(0x046d, 0x0807): /* Logitech Webcam C500 */
 	case USB_ID(0x046d, 0x0808):
 	case USB_ID(0x046d, 0x0809):
 	case USB_ID(0x046d, 0x081b): /* HD Webcam c310 */
