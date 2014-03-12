Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaCLKav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:30:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57077 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbaCLKao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:30:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.32
Date: Wed, 12 Mar 2014 10:30:36 +0000
Message-Id: <1394620236-4486-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394620236-4486-1-git-send-email-luis.henriques@canonical.com>
References: <1394620236-4486-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 615517f..d484732 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .31
+EXTRAVERSION = .32
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index 76d7f24..5ff9726 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -202,6 +202,7 @@ extern void copy_to_user_page(struct vm_area_struct *, struct page *,
 static inline void __flush_icache_all(void)
 {
 	__flush_icache_preferred();
+	dsb();
 }
 
 #define flush_cache_all()		__cpuc_flush_kern_all()
diff --git a/arch/arm/mm/proc-v6.S b/arch/arm/mm/proc-v6.S
index 897486c..4d2e447 100644
--- a/arch/arm/mm/proc-v6.S
+++ b/arch/arm/mm/proc-v6.S
@@ -202,7 +202,6 @@ __v6_setup:
 	mcr	p15, 0, r0, c7, c14, 0		@ clean+invalidate D cache
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
 	mcr	p15, 0, r0, c7, c15, 0		@ clean+invalidate cache
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 #ifdef CONFIG_MMU
 	mcr	p15, 0, r0, c8, c7, 0		@ invalidate I + D TLBs
 	mcr	p15, 0, r0, c2, c0, 2		@ TTB control register
@@ -212,6 +211,8 @@ __v6_setup:
 	ALT_UP(orr	r8, r8, #TTB_FLAGS_UP)
 	mcr	p15, 0, r8, c2, c0, 1		@ load TTB1
 #endif /* CONFIG_MMU */
+	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer and
+						@ complete invalidations
 	adr	r5, v6_crval
 	ldmia	r5, {r5, r6}
 #ifdef CONFIG_CPU_ENDIAN_BE8
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index c2e2b66..fb489cc 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -246,7 +246,6 @@ __v7_setup:
 
 3:	mov	r10, #0
 	mcr	p15, 0, r10, c7, c5, 0		@ I+BTB cache invalidate
-	dsb
 #ifdef CONFIG_MMU
 	mcr	p15, 0, r10, c8, c7, 0		@ invalidate I + D TLBs
 	v7_ttb_setup r10, r4, r8, r5		@ TTBCR, TTBRx setup
@@ -255,6 +254,7 @@ __v7_setup:
 	mcr	p15, 0, r5, c10, c2, 0		@ write PRRR
 	mcr	p15, 0, r6, c10, c2, 1		@ write NMRR
 #endif
+	dsb					@ Complete invalidations
 #ifndef CONFIG_ARM_THUMBEE
 	mrc	p15, 0, r0, c0, c1, 0		@ read ID_PFR0 for ThumbEE
 	and	r0, r0, #(0xf << 12)		@ ThumbEE enabled field
diff --git a/arch/avr32/Makefile b/arch/avr32/Makefile
index 22fb665..dba48a5 100644
--- a/arch/avr32/Makefile
+++ b/arch/avr32/Makefile
@@ -11,7 +11,7 @@ all: uImage vmlinux.elf
 
 KBUILD_DEFCONFIG	:= atstk1002_defconfig
 
-KBUILD_CFLAGS	+= -pipe -fno-builtin -mno-pic
+KBUILD_CFLAGS	+= -pipe -fno-builtin -mno-pic -D__linux__
 KBUILD_AFLAGS	+= -mrelax -mno-pic
 KBUILD_CFLAGS_MODULE += -mno-relax
 LDFLAGS_vmlinux	+= --relax
diff --git a/arch/avr32/boards/mimc200/fram.c b/arch/avr32/boards/mimc200/fram.c
index 9764a1a..c1466a8 100644
--- a/arch/avr32/boards/mimc200/fram.c
+++ b/arch/avr32/boards/mimc200/fram.c
@@ -11,6 +11,7 @@
 #define FRAM_VERSION	"1.0"
 
 #include <linux/miscdevice.h>
+#include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/mm.h>
 #include <linux/io.h>
diff --git a/arch/powerpc/kernel/crash_dump.c b/arch/powerpc/kernel/crash_dump.c
index b3ba516..9d6a4a4 100644
--- a/arch/powerpc/kernel/crash_dump.c
+++ b/arch/powerpc/kernel/crash_dump.c
@@ -108,17 +108,19 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 			size_t csize, unsigned long offset, int userbuf)
 {
 	void  *vaddr;
+	phys_addr_t paddr;
 
 	if (!csize)
 		return 0;
 
 	csize = min_t(size_t, csize, PAGE_SIZE);
+	paddr = pfn << PAGE_SHIFT;
 
-	if ((min_low_pfn < pfn) && (pfn < max_pfn)) {
-		vaddr = __va(pfn << PAGE_SHIFT);
+	if (memblock_is_region_memory(paddr, csize)) {
+		vaddr = __va(paddr);
 		csize = copy_oldmem_vaddr(vaddr, buf, csize, offset, userbuf);
 	} else {
-		vaddr = __ioremap(pfn << PAGE_SHIFT, PAGE_SIZE, 0);
+		vaddr = __ioremap(paddr, PAGE_SIZE, 0);
 		csize = copy_oldmem_vaddr(vaddr, buf, csize, offset, userbuf);
 		iounmap(vaddr);
 	}
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c4706cf..3396fc4 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1162,6 +1162,9 @@ static void x86_pmu_del(struct perf_event *event, int flags)
 	for (i = 0; i < cpuc->n_events; i++) {
 		if (event == cpuc->event_list[i]) {
 
+			if (i >= cpuc->n_events - cpuc->n_added)
+				--cpuc->n_added;
+
 			if (x86_pmu.put_event_constraints)
 				x86_pmu.put_event_constraints(cpuc, event);
 
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index c0f420f..4baa8ff 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -109,8 +109,10 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 	flag |= __GFP_ZERO;
 again:
 	page = NULL;
-	if (!(flag & GFP_ATOMIC))
+	/* CMA can be used only in the context which permits sleeping */
+	if (flag & __GFP_WAIT)
 		page = dma_alloc_from_contiguous(dev, count, get_order(size));
+	/* fallback */
 	if (!page)
 		page = alloc_pages_node(dev_to_node(dev), flag, get_order(size));
 	if (!page)
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 57e168e..d6c365f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2500,6 +2500,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 	int emulate = 0;
 	gfn_t pseudo_gfn;
 
+	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
+		return 0;
+
 	for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
 		if (iterator.level == level) {
 			unsigned pte_access = ACC_ALL;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index eed06fc..732cf6c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6324,8 +6324,8 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	free_vpid(vmx);
-	free_nested(vmx);
 	free_loaded_vmcs(vmx->loaded_vmcs);
+	free_nested(vmx);
 	kfree(vmx->guest_msrs);
 	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, vmx);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 494817e..122ee5f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5469,7 +5469,7 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
 		frag = &vcpu->mmio_fragments[vcpu->mmio_cur_fragment++];
 		if (!vcpu->mmio_is_write)
 			memcpy(frag->data, run->mmio.data, frag->len);
-		if (vcpu->mmio_cur_fragment == vcpu->mmio_nr_fragments) {
+		if (vcpu->mmio_cur_fragment >= vcpu->mmio_nr_fragments) {
 			vcpu->mmio_needed = 0;
 			if (vcpu->mmio_is_write)
 				return 1;
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index 1d02b7b..c653cc2 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -59,6 +59,12 @@ struct throttling_tstate {
 	int target_state;		/* target T-state */
 };
 
+struct acpi_processor_throttling_arg {
+	struct acpi_processor *pr;
+	int target_state;
+	bool force;
+};
+
 #define THROTTLING_PRECHANGE       (1)
 #define THROTTLING_POSTCHANGE      (2)
 
@@ -1062,16 +1068,24 @@ static int acpi_processor_set_throttling_ptc(struct acpi_processor *pr,
 	return 0;
 }
 
+static long acpi_processor_throttling_fn(void *data)
+{
+	struct acpi_processor_throttling_arg *arg = data;
+	struct acpi_processor *pr = arg->pr;
+
+	return pr->throttling.acpi_processor_set_throttling(pr,
+			arg->target_state, arg->force);
+}
+
 int acpi_processor_set_throttling(struct acpi_processor *pr,
 						int state, bool force)
 {
-	cpumask_var_t saved_mask;
 	int ret = 0;
 	unsigned int i;
 	struct acpi_processor *match_pr;
 	struct acpi_processor_throttling *p_throttling;
+	struct acpi_processor_throttling_arg arg;
 	struct throttling_tstate t_state;
-	cpumask_var_t online_throttling_cpus;
 
 	if (!pr)
 		return -EINVAL;
@@ -1082,14 +1096,6 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
 	if ((state < 0) || (state > (pr->throttling.state_count - 1)))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&saved_mask, GFP_KERNEL))
-		return -ENOMEM;
-
-	if (!alloc_cpumask_var(&online_throttling_cpus, GFP_KERNEL)) {
-		free_cpumask_var(saved_mask);
-		return -ENOMEM;
-	}
-
 	if (cpu_is_offline(pr->id)) {
 		/*
 		 * the cpu pointed by pr->id is offline. Unnecessary to change
@@ -1098,17 +1104,15 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
 		return -ENODEV;
 	}
 
-	cpumask_copy(saved_mask, &current->cpus_allowed);
 	t_state.target_state = state;
 	p_throttling = &(pr->throttling);
-	cpumask_and(online_throttling_cpus, cpu_online_mask,
-		    p_throttling->shared_cpu_map);
+
 	/*
 	 * The throttling notifier will be called for every
 	 * affected cpu in order to get one proper T-state.
 	 * The notifier event is THROTTLING_PRECHANGE.
 	 */
-	for_each_cpu(i, online_throttling_cpus) {
+	for_each_cpu_and(i, cpu_online_mask, p_throttling->shared_cpu_map) {
 		t_state.cpu = i;
 		acpi_processor_throttling_notifier(THROTTLING_PRECHANGE,
 							&t_state);
@@ -1120,21 +1124,18 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
 	 * it can be called only for the cpu pointed by pr.
 	 */
 	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
-		/* FIXME: use work_on_cpu() */
-		if (set_cpus_allowed_ptr(current, cpumask_of(pr->id))) {
-			/* Can't migrate to the pr->id CPU. Exit */
-			ret = -ENODEV;
-			goto exit;
-		}
-		ret = p_throttling->acpi_processor_set_throttling(pr,
-						t_state.target_state, force);
+		arg.pr = pr;
+		arg.target_state = state;
+		arg.force = force;
+		ret = work_on_cpu(pr->id, acpi_processor_throttling_fn, &arg);
 	} else {
 		/*
 		 * When the T-state coordination is SW_ALL or HW_ALL,
 		 * it is necessary to set T-state for every affected
 		 * cpus.
 		 */
-		for_each_cpu(i, online_throttling_cpus) {
+		for_each_cpu_and(i, cpu_online_mask,
+		    p_throttling->shared_cpu_map) {
 			match_pr = per_cpu(processors, i);
 			/*
 			 * If the pointer is invalid, we will report the
@@ -1155,13 +1156,12 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
 					"on CPU %d\n", i));
 				continue;
 			}
-			t_state.cpu = i;
-			/* FIXME: use work_on_cpu() */
-			if (set_cpus_allowed_ptr(current, cpumask_of(i)))
-				continue;
-			ret = match_pr->throttling.
-				acpi_processor_set_throttling(
-				match_pr, t_state.target_state, force);
+
+			arg.pr = match_pr;
+			arg.target_state = state;
+			arg.force = force;
+			ret = work_on_cpu(pr->id, acpi_processor_throttling_fn,
+				&arg);
 		}
 	}
 	/*
@@ -1170,17 +1170,12 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
 	 * affected cpu to update the T-states.
 	 * The notifier event is THROTTLING_POSTCHANGE
 	 */
-	for_each_cpu(i, online_throttling_cpus) {
+	for_each_cpu_and(i, cpu_online_mask, p_throttling->shared_cpu_map) {
 		t_state.cpu = i;
 		acpi_processor_throttling_notifier(THROTTLING_POSTCHANGE,
 							&t_state);
 	}
-	/* restore the previous state */
-	/* FIXME: use work_on_cpu() */
-	set_cpus_allowed_ptr(current, saved_mask);
-exit:
-	free_cpumask_var(online_throttling_cpus);
-	free_cpumask_var(saved_mask);
+
 	return ret;
 }
 
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 403283d..ba46775 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -648,6 +648,7 @@ acpi_video_init_brightness(struct acpi_video_device *device)
 	union acpi_object *o;
 	struct acpi_video_device_brightness *br = NULL;
 	int result = -EINVAL;
+	u32 value;
 
 	if (!ACPI_SUCCESS(acpi_video_device_lcd_query_levels(device, &obj))) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Could not query available "
@@ -678,7 +679,12 @@ acpi_video_init_brightness(struct acpi_video_device *device)
 			printk(KERN_ERR PREFIX "Invalid data\n");
 			continue;
 		}
-		br->levels[count] = (u32) o->integer.value;
+		value = (u32) o->integer.value;
+		/* Skip duplicate entries */
+		if (count > 2 && br->levels[count - 1] == value)
+			continue;
+
+		br->levels[count] = value;
 
 		if (br->levels[count] > max_level)
 			max_level = br->levels[count];
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 5630e99..a444c11 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -61,6 +61,7 @@ enum board_ids {
 	/* board IDs by feature in alphabetical order */
 	board_ahci,
 	board_ahci_ign_iferr,
+	board_ahci_noncq,
 	board_ahci_nosntf,
 	board_ahci_yes_fbs,
 
@@ -121,6 +122,13 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
+	[board_ahci_noncq] = {
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 	[board_ahci_nosntf] =
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_SNTF),
@@ -453,6 +461,12 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(ASMEDIA, 0x0611), board_ahci },	/* ASM1061 */
 	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1062 */
 
+	/*
+	 * Samsung SSDs found on some macbooks.  NCQ times out.
+	 * https://bugzilla.kernel.org/show_bug.cgi?id=60731
+	 */
+	{ PCI_VDEVICE(SAMSUNG, 0x1600), board_ahci_noncq },
+
 	/* Enmotus */
 	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },
 
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index f5c35be..0ba32fe 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -447,8 +447,11 @@ static void sata_pmp_quirks(struct ata_port *ap)
 		 * otherwise.  Don't try hard to recover it.
 		 */
 		ap->pmp_link[ap->nr_pmp_links - 1].flags |= ATA_LFLAG_NO_RETRY;
-	} else if (vendor == 0x197b && devid == 0x2352) {
-		/* chip found in Thermaltake BlackX Duet, jmicron JMB350? */
+	} else if (vendor == 0x197b && (devid == 0x2352 || devid == 0x0325)) {
+		/*
+		 * 0x2352: found in Thermaltake BlackX Duet, jmicron JMB350?
+		 * 0x0325: jmicron JMB394.
+		 */
 		ata_for_each_link(link, ap, EDGE) {
 			/* SRST breaks detection and disks get misclassified
 			 * LPM disabled to avoid potential problems
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 9dfb40b..0c4ed89 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -157,6 +157,7 @@ static const struct sil_drivelist {
 	{ "ST380011ASL",	SIL_QUIRK_MOD15WRITE },
 	{ "ST3120022ASL",	SIL_QUIRK_MOD15WRITE },
 	{ "ST3160021ASL",	SIL_QUIRK_MOD15WRITE },
+	{ "TOSHIBA MK2561GSYN",	SIL_QUIRK_MOD15WRITE },
 	{ "Maxtor 4D060H3",	SIL_QUIRK_UDMA5MAX },
 	{ }
 };
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index c671369..3d26001 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1271,7 +1271,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 		FW_BUG PFX "Try again with latest BIOS.\n";
 	struct powernow_k8_data *data;
 	struct init_on_cpu init_on_cpu;
-	int rc;
+	int rc, cpu;
 	struct cpuinfo_x86 *c = &cpu_data(pol->cpu);
 
 	if (!cpu_online(pol->cpu))
@@ -1360,7 +1360,9 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 		pr_debug("cpu_init done, current fid 0x%x, vid 0x%x\n",
 			data->currfid, data->currvid);
 
-	per_cpu(powernow_data, pol->cpu) = data;
+	/* Point all the CPUs in this policy to the same data */
+	for_each_cpu(cpu, pol->cpus)
+		per_cpu(powernow_data, cpu) = data;
 
 	return 0;
 
@@ -1375,6 +1377,7 @@ err_out:
 static int __devexit powernowk8_cpu_exit(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
+	int cpu;
 
 	if (!data)
 		return -EINVAL;
@@ -1385,7 +1388,8 @@ static int __devexit powernowk8_cpu_exit(struct cpufreq_policy *pol)
 
 	kfree(data->powernow_table);
 	kfree(data);
-	per_cpu(powernow_data, pol->cpu) = NULL;
+	for_each_cpu(cpu, pol->cpus)
+		per_cpu(powernow_data, cpu) = NULL;
 
 	return 0;
 }
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index aec952f..b138bc4 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1412,6 +1412,7 @@ static void dma_tasklet(unsigned long data)
 	struct d40_chan *d40c = (struct d40_chan *) data;
 	struct d40_desc *d40d;
 	unsigned long flags;
+	bool callback_active;
 	dma_async_tx_callback callback;
 	void *callback_param;
 
@@ -1435,6 +1436,7 @@ static void dma_tasklet(unsigned long data)
 	}
 
 	/* Callback to client */
+	callback_active = !!(d40d->txd.flags & DMA_PREP_INTERRUPT);
 	callback = d40d->txd.callback;
 	callback_param = d40d->txd.callback_param;
 
@@ -1459,7 +1461,7 @@ static void dma_tasklet(unsigned long data)
 
 	spin_unlock_irqrestore(&d40c->lock, flags);
 
-	if (callback && (d40d->txd.flags & DMA_PREP_INTERRUPT))
+	if (callback_active && callback)
 		callback(callback_param);
 
 	return;
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 856a250..3fa8c20 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -943,33 +943,35 @@ static int __devinit i7300_get_devices(struct mem_ctl_info *mci)
 
 	/* Attempt to 'get' the MCH register we want */
 	pdev = NULL;
-	while (!pvt->pci_dev_16_1_fsb_addr_map ||
-	       !pvt->pci_dev_16_2_fsb_err_regs) {
-		pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
-				      PCI_DEVICE_ID_INTEL_I7300_MCH_ERR, pdev);
-		if (!pdev) {
-			/* End of list, leave */
-			i7300_printk(KERN_ERR,
-				"'system address,Process Bus' "
-				"device not found:"
-				"vendor 0x%x device 0x%x ERR funcs "
-				"(broken BIOS?)\n",
-				PCI_VENDOR_ID_INTEL,
-				PCI_DEVICE_ID_INTEL_I7300_MCH_ERR);
-			goto error;
-		}
-
+	while ((pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
+				      PCI_DEVICE_ID_INTEL_I7300_MCH_ERR,
+				      pdev))) {
 		/* Store device 16 funcs 1 and 2 */
 		switch (PCI_FUNC(pdev->devfn)) {
 		case 1:
-			pvt->pci_dev_16_1_fsb_addr_map = pdev;
+			if (!pvt->pci_dev_16_1_fsb_addr_map)
+				pvt->pci_dev_16_1_fsb_addr_map =
+							pci_dev_get(pdev);
 			break;
 		case 2:
-			pvt->pci_dev_16_2_fsb_err_regs = pdev;
+			if (!pvt->pci_dev_16_2_fsb_err_regs)
+				pvt->pci_dev_16_2_fsb_err_regs =
+							pci_dev_get(pdev);
 			break;
 		}
 	}
 
+	if (!pvt->pci_dev_16_1_fsb_addr_map ||
+	    !pvt->pci_dev_16_2_fsb_err_regs) {
+		/* At least one device was not found */
+		i7300_printk(KERN_ERR,
+			"'system address,Process Bus' device not found:"
+			"vendor 0x%x device 0x%x ERR funcs (broken BIOS?)\n",
+			PCI_VENDOR_ID_INTEL,
+			PCI_DEVICE_ID_INTEL_I7300_MCH_ERR);
+		goto error;
+	}
+
 	debugf1("System Address, processor bus- PCI Bus ID: %s  %x:%x\n",
 		pci_name(pvt->pci_dev_16_0_fsb_ctlr),
 		pvt->pci_dev_16_0_fsb_ctlr->vendor,
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index a499c7e..36ec0ef 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1250,14 +1250,19 @@ static int i7core_get_onedevice(struct pci_dev **prev,
 	 * is at addr 8086:2c40, instead of 8086:2c41. So, we need
 	 * to probe for the alternate address in case of failure
 	 */
-	if (dev_descr->dev_id == PCI_DEVICE_ID_INTEL_I7_NONCORE && !pdev)
+	if (dev_descr->dev_id == PCI_DEVICE_ID_INTEL_I7_NONCORE && !pdev) {
+		pci_dev_get(*prev);	/* pci_get_device will put it */
 		pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
 				      PCI_DEVICE_ID_INTEL_I7_NONCORE_ALT, *prev);
+	}
 
-	if (dev_descr->dev_id == PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE && !pdev)
+	if (dev_descr->dev_id == PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE &&
+	    !pdev) {
+		pci_dev_get(*prev);	/* pci_get_device will put it */
 		pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
 				      PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE_ALT,
 				      *prev);
+	}
 
 	if (!pdev) {
 		if (*prev) {
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 0224d43..7632aa0 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -493,6 +493,7 @@ intel_dp_aux_native_write(struct intel_dp *intel_dp,
 	uint8_t	msg[20];
 	int msg_bytes;
 	uint8_t	ack;
+	int retry;
 
 	intel_dp_check_edp(intel_dp);
 	if (send_bytes > 16)
@@ -503,18 +504,20 @@ intel_dp_aux_native_write(struct intel_dp *intel_dp,
 	msg[3] = send_bytes - 1;
 	memcpy(&msg[4], send, send_bytes);
 	msg_bytes = send_bytes + 4;
-	for (;;) {
+	for (retry = 0; retry < 7; retry++) {
 		ret = intel_dp_aux_ch(intel_dp, msg, msg_bytes, &ack, 1);
 		if (ret < 0)
 			return ret;
 		if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_ACK)
-			break;
+			return send_bytes;
 		else if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_DEFER)
-			udelay(100);
+			usleep_range(400, 500);
 		else
 			return -EIO;
 	}
-	return send_bytes;
+
+	DRM_ERROR("too many retries, giving up\n");
+	return -EIO;
 }
 
 /* Write a single byte to the aux channel in native mode */
@@ -536,6 +539,7 @@ intel_dp_aux_native_read(struct intel_dp *intel_dp,
 	int reply_bytes;
 	uint8_t ack;
 	int ret;
+	int retry;
 
 	intel_dp_check_edp(intel_dp);
 	msg[0] = AUX_NATIVE_READ << 4;
@@ -546,7 +550,7 @@ intel_dp_aux_native_read(struct intel_dp *intel_dp,
 	msg_bytes = 4;
 	reply_bytes = recv_bytes + 1;
 
-	for (;;) {
+	for (retry = 0; retry < 7; retry++) {
 		ret = intel_dp_aux_ch(intel_dp, msg, msg_bytes,
 				      reply, reply_bytes);
 		if (ret == 0)
@@ -559,10 +563,13 @@ intel_dp_aux_native_read(struct intel_dp *intel_dp,
 			return ret - 1;
 		}
 		else if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_DEFER)
-			udelay(100);
+			usleep_range(400, 500);
 		else
 			return -EIO;
 	}
+
+	DRM_ERROR("too many retries, giving up\n");
+	return -EIO;
 }
 
 static int
diff --git a/drivers/hwmon/max1668.c b/drivers/hwmon/max1668.c
index 335b183..f058886 100644
--- a/drivers/hwmon/max1668.c
+++ b/drivers/hwmon/max1668.c
@@ -243,7 +243,7 @@ static ssize_t set_temp_min(struct device *dev,
 	data->temp_min[index] = SENSORS_LIMIT(temp/1000, -128, 127);
 	if (i2c_smbus_write_byte_data(client,
 					MAX1668_REG_LIML_WR(index),
-					data->temp_max[index]))
+					data->temp_min[index]))
 		count = -EIO;
 	mutex_unlock(&data->update_lock);
 
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 9e47774..868a381 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -486,6 +486,7 @@ static void elantech_input_sync_v4(struct psmouse *psmouse)
 	unsigned char *packet = psmouse->packet;
 
 	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
+	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
 	input_mt_report_pointer_emulation(dev, true);
 	input_sync(dev);
 }
@@ -954,6 +955,44 @@ static int elantech_get_resolution_v4(struct psmouse *psmouse,
 }
 
 /*
+ * Advertise INPUT_PROP_BUTTONPAD for clickpads. The testing of bit 12 in
+ * fw_version for this is based on the following fw_version & caps table:
+ *
+ * Laptop-model:           fw_version:     caps:           buttons:
+ * Acer S3                 0x461f00        10, 13, 0e      clickpad
+ * Acer S7-392             0x581f01        50, 17, 0d      clickpad
+ * Acer V5-131             0x461f02        01, 16, 0c      clickpad
+ * Acer V5-551             0x461f00        ?               clickpad
+ * Asus K53SV              0x450f01        78, 15, 0c      2 hw buttons
+ * Asus G46VW              0x460f02        00, 18, 0c      2 hw buttons
+ * Asus G750JX             0x360f00        00, 16, 0c      2 hw buttons
+ * Asus UX31               0x361f00        20, 15, 0e      clickpad
+ * Asus UX32VD             0x361f02        00, 15, 0e      clickpad
+ * Avatar AVIU-145A2       0x361f00        ?               clickpad
+ * Gigabyte U2442          0x450f01        58, 17, 0c      2 hw buttons
+ * Lenovo L430             0x350f02        b9, 15, 0c      2 hw buttons (*)
+ * Samsung NF210           0x150b00        78, 14, 0a      2 hw buttons
+ * Samsung NP770Z5E        0x575f01        10, 15, 0f      clickpad
+ * Samsung NP700Z5B        0x361f06        21, 15, 0f      clickpad
+ * Samsung NP900X3E-A02    0x575f03        ?               clickpad
+ * Samsung NP-QX410        0x851b00        19, 14, 0c      clickpad
+ * Samsung RC512           0x450f00        08, 15, 0c      2 hw buttons
+ * Samsung RF710           0x450f00        ?               2 hw buttons
+ * System76 Pangolin       0x250f01        ?               2 hw buttons
+ * (*) + 3 trackpoint buttons
+ */
+static void elantech_set_buttonpad_prop(struct psmouse *psmouse)
+{
+	struct input_dev *dev = psmouse->dev;
+	struct elantech_data *etd = psmouse->private;
+
+	if (etd->fw_version & 0x001000) {
+		__set_bit(INPUT_PROP_BUTTONPAD, dev->propbit);
+		__clear_bit(BTN_RIGHT, dev->keybit);
+	}
+}
+
+/*
  * Set the appropriate event bits for the input subsystem
  */
 static int elantech_set_input_params(struct psmouse *psmouse)
@@ -996,6 +1035,8 @@ static int elantech_set_input_params(struct psmouse *psmouse)
 		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
 		/* fall through */
 	case 3:
+		if (etd->hw_version == 3)
+			elantech_set_buttonpad_prop(psmouse);
 		input_set_abs_params(dev, ABS_X, x_min, x_max, 0, 0);
 		input_set_abs_params(dev, ABS_Y, y_min, y_max, 0, 0);
 		if (etd->reports_pressure) {
@@ -1017,9 +1058,7 @@ static int elantech_set_input_params(struct psmouse *psmouse)
 			 */
 			psmouse_warn(psmouse, "couldn't query resolution data.\n");
 		}
-		/* v4 is clickpad, with only one button. */
-		__set_bit(INPUT_PROP_BUTTONPAD, dev->propbit);
-		__clear_bit(BTN_RIGHT, dev->keybit);
+		elantech_set_buttonpad_prop(psmouse);
 		__set_bit(BTN_TOOL_QUADTAP, dev->keybit);
 		/* For X to recognize me as touchpad. */
 		input_set_abs_params(dev, ABS_X, x_min, x_max, 0, 0);
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 274354d..72398e5 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1562,8 +1562,11 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 	/*
 	 * Only pass ioctls through if the device sizes match exactly.
 	 */
-	if (!r && ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
-		r = scsi_verify_blk_ioctl(NULL, cmd);
+	if (!bdev || ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT) {
+		int err = scsi_verify_blk_ioctl(NULL, cmd);
+		if (err)
+			r = err;
+	}
 
 	if (r == -ENOTCONN && !fatal_signal_pending(current))
 		queue_work(kmultipathd, &m->process_queued_ios);
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 3463b46..184be29 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1854,8 +1854,6 @@ void bond_3ad_initiate_agg_selection(struct bonding *bond, int timeout)
 	BOND_AD_INFO(bond).agg_select_timer = timeout;
 }
 
-static u16 aggregator_identifier;
-
 /**
  * bond_3ad_initialize - initialize a bond's 802.3ad parameters and structures
  * @bond: bonding struct to work on
@@ -1869,7 +1867,7 @@ void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
 	if (MAC_ADDRESS_COMPARE(&(BOND_AD_INFO(bond).system.sys_mac_addr),
 				bond->dev->dev_addr)) {
 
-		aggregator_identifier = 0;
+		BOND_AD_INFO(bond).aggregator_identifier = 0;
 
 		BOND_AD_INFO(bond).system.sys_priority = 0xFFFF;
 		BOND_AD_INFO(bond).system.sys_mac_addr = *((struct mac_addr *)bond->dev->dev_addr);
@@ -1941,7 +1939,7 @@ int bond_3ad_bind_slave(struct slave *slave)
 		ad_initialize_agg(aggregator);
 
 		aggregator->aggregator_mac_address = *((struct mac_addr *)bond->dev->dev_addr);
-		aggregator->aggregator_identifier = (++aggregator_identifier);
+		aggregator->aggregator_identifier = ++BOND_AD_INFO(bond).aggregator_identifier;
 		aggregator->slave = slave;
 		aggregator->is_active = 0;
 		aggregator->num_of_ports = 0;
diff --git a/drivers/net/bonding/bond_3ad.h b/drivers/net/bonding/bond_3ad.h
index 5ee7e3c..656b2f5 100644
--- a/drivers/net/bonding/bond_3ad.h
+++ b/drivers/net/bonding/bond_3ad.h
@@ -253,6 +253,7 @@ struct ad_system {
 struct ad_bond_info {
 	struct ad_system system;	    /* 802.3ad system structure */
 	u32 agg_select_timer;	    // Timer to select aggregator after all adapter's hand shakes
+	u16 aggregator_identifier;
 };
 
 struct ad_slave_info {
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 3390b69..6dcd72a 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12485,12 +12485,12 @@ static int tg3_change_mtu(struct net_device *dev, int new_mtu)
 
 	tg3_netif_stop(tp);
 
+	tg3_set_mtu(dev, tp, new_mtu);
+
 	tg3_full_lock(tp, 1);
 
 	tg3_halt(tp, RESET_KIND_SHUTDOWN, 1);
 
-	tg3_set_mtu(dev, tp, new_mtu);
-
 	/* Reset PHY, otherwise the read DMA engine will be in a mode that
 	 * breaks all requests to 256 bytes.
 	 */
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index ada720b..5107b12 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -3005,7 +3005,7 @@ static void __e100_shutdown(struct pci_dev *pdev, bool *enable_wake)
 		*enable_wake = false;
 	}
 
-	pci_disable_device(pdev);
+	pci_clear_master(pdev);
 }
 
 static int __e100_power_off(struct pci_dev *pdev, bool wake)
diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index ebcb7d4..fa0327c 100644
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -183,6 +183,17 @@ struct ax88172_int_data {
 	__le16 res3;
 } __packed;
 
+struct asix_rx_fixup_info {
+	struct sk_buff *ax_skb;
+	u32 header;
+	u16 size;
+	bool split_head;
+};
+
+struct asix_common_private {
+	struct asix_rx_fixup_info rx_fixup_info;
+};
+
 static int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 			    u16 size, void *data)
 {
@@ -304,49 +315,89 @@ asix_write_cmd_async(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 	}
 }
 
-static int asix_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
+static int asix_rx_fixup_internal(struct usbnet *dev, struct sk_buff *skb,
+				  struct asix_rx_fixup_info *rx)
 {
 	int offset = 0;
 
-	while (offset + sizeof(u32) < skb->len) {
-		struct sk_buff *ax_skb;
-		u16 size;
-		u32 header = get_unaligned_le32(skb->data + offset);
-
-		offset += sizeof(u32);
-
-		/* get the packet length */
-		size = (u16) (header & 0x7ff);
-		if (size != ((~header >> 16) & 0x07ff)) {
-			netdev_err(dev->net, "asix_rx_fixup() Bad Header Length\n");
-			return 0;
+	while (offset + sizeof(u16) <= skb->len) {
+		u16 remaining = 0;
+		unsigned char *data;
+
+		if (!rx->size) {
+			if ((skb->len - offset == sizeof(u16)) ||
+			    rx->split_head) {
+				if (!rx->split_head) {
+					rx->header = get_unaligned_le16(
+							skb->data + offset);
+					rx->split_head = true;
+					offset += sizeof(u16);
+					break;
+				} else {
+					rx->header |= (get_unaligned_le16(
+							skb->data + offset)
+							<< 16);
+					rx->split_head = false;
+					offset += sizeof(u16);
+				}
+			} else {
+				rx->header = get_unaligned_le32(skb->data +
+								offset);
+				offset += sizeof(u32);
+			}
+
+			/* get the packet length */
+			rx->size = (u16) (rx->header & 0x7ff);
+			if (rx->size != ((~rx->header >> 16) & 0x7ff)) {
+				netdev_err(dev->net, "asix_rx_fixup() Bad Header Length 0x%x, offset %d\n",
+					   rx->header, offset);
+				rx->size = 0;
+				return 0;
+			}
+			rx->ax_skb = netdev_alloc_skb_ip_align(dev->net,
+							       rx->size);
+			if (!rx->ax_skb)
+				return 0;
 		}
 
-		if ((size > dev->net->mtu + ETH_HLEN + VLAN_HLEN) ||
-		    (size + offset > skb->len)) {
+		if (rx->size > dev->net->mtu + ETH_HLEN + VLAN_HLEN) {
 			netdev_err(dev->net, "asix_rx_fixup() Bad RX Length %d\n",
-				   size);
+				   rx->size);
+			kfree_skb(rx->ax_skb);
 			return 0;
 		}
-		ax_skb = netdev_alloc_skb_ip_align(dev->net, size);
-		if (!ax_skb)
-			return 0;
 
-		skb_put(ax_skb, size);
-		memcpy(ax_skb->data, skb->data + offset, size);
-		usbnet_skb_return(dev, ax_skb);
+		if (rx->size > skb->len - offset) {
+			remaining = rx->size - (skb->len - offset);
+			rx->size = skb->len - offset;
+		}
+
+		data = skb_put(rx->ax_skb, rx->size);
+		memcpy(data, skb->data + offset, rx->size);
+		if (!remaining)
+			usbnet_skb_return(dev, rx->ax_skb);
 
-		offset += (size + 1) & 0xfffe;
+		offset += (rx->size + 1) & 0xfffe;
+		rx->size = remaining;
 	}
 
 	if (skb->len != offset) {
-		netdev_err(dev->net, "asix_rx_fixup() Bad SKB Length %d\n",
-			   skb->len);
+		netdev_err(dev->net, "asix_rx_fixup() Bad SKB Length %d, %d\n",
+			   skb->len, offset);
 		return 0;
 	}
+
 	return 1;
 }
 
+static int asix_rx_fixup_common(struct usbnet *dev, struct sk_buff *skb)
+{
+	struct asix_common_private *dp = dev->driver_priv;
+	struct asix_rx_fixup_info *rx = &dp->rx_fixup_info;
+
+	return asix_rx_fixup_internal(dev, skb, rx);
+}
+
 static struct sk_buff *asix_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 					gfp_t flags)
 {
@@ -1110,9 +1161,19 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 		dev->rx_urb_size = 2048;
 	}
 
+	dev->driver_priv = kzalloc(sizeof(struct asix_common_private),
+				   GFP_KERNEL);
+	if (!dev->driver_priv)
+		return -ENOMEM;
+
 	return 0;
 }
 
+static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
+{
+	kfree(dev->driver_priv);
+}
+
 static const struct ethtool_ops ax88178_ethtool_ops = {
 	.get_drvinfo		= asix_get_drvinfo,
 	.get_link		= asix_get_link,
@@ -1445,6 +1506,11 @@ static int ax88178_bind(struct usbnet *dev, struct usb_interface *intf)
 		dev->rx_urb_size = 2048;
 	}
 
+	dev->driver_priv = kzalloc(sizeof(struct asix_common_private),
+				   GFP_KERNEL);
+	if (!dev->driver_priv)
+		return -ENOMEM;
+
 	return 0;
 }
 
@@ -1491,22 +1557,26 @@ static const struct driver_info hawking_uf200_info = {
 static const struct driver_info ax88772_info = {
 	.description = "ASIX AX88772 USB 2.0 Ethernet",
 	.bind = ax88772_bind,
+	.unbind = ax88772_unbind,
 	.status = asix_status,
 	.link_reset = ax88772_link_reset,
 	.reset = ax88772_reset,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR | FLAG_MULTI_PACKET,
-	.rx_fixup = asix_rx_fixup,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
+		 FLAG_MULTI_PACKET,
+	.rx_fixup = asix_rx_fixup_common,
 	.tx_fixup = asix_tx_fixup,
 };
 
 static const struct driver_info ax88178_info = {
 	.description = "ASIX AX88178 USB 2.0 Ethernet",
 	.bind = ax88178_bind,
+	.unbind = ax88772_unbind,
 	.status = asix_status,
 	.link_reset = ax88178_link_reset,
 	.reset = ax88178_reset,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR,
-	.rx_fixup = asix_rx_fixup,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
+		 FLAG_MULTI_PACKET,
+	.rx_fixup = asix_rx_fixup_common,
 	.tx_fixup = asix_tx_fixup,
 };
 
diff --git a/drivers/net/usb/gl620a.c b/drivers/net/usb/gl620a.c
index db3c802..f14e8de 100644
--- a/drivers/net/usb/gl620a.c
+++ b/drivers/net/usb/gl620a.c
@@ -86,6 +86,10 @@ static int genelink_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	u32			size;
 	u32			count;
 
+	/* This check is no longer done by usbnet */
+	if (skb->len < dev->net->hard_header_len)
+		return 0;
+
 	header = (struct gl_header *) skb->data;
 
 	// get the packet count of the received skb
diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
index 03c2d8d..3acdf1d 100644
--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -601,8 +601,9 @@ static int mcs7830_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
 	u8 status;
 
-	if (skb->len == 0) {
-		dev_err(&dev->udev->dev, "unexpected empty rx frame\n");
+	/* This check is no longer done by usbnet */
+	if (skb->len < dev->net->hard_header_len) {
+		dev_err(&dev->udev->dev, "unexpected tiny rx frame\n");
 		return 0;
 	}
 
diff --git a/drivers/net/usb/net1080.c b/drivers/net/usb/net1080.c
index 28c4d51..389afcf 100644
--- a/drivers/net/usb/net1080.c
+++ b/drivers/net/usb/net1080.c
@@ -419,6 +419,10 @@ static int net1080_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	struct nc_trailer	*trailer;
 	u16			hdr_len, packet_len;
 
+	/* This check is no longer done by usbnet */
+	if (skb->len < dev->net->hard_header_len)
+		return 0;
+
 	if (!(skb->len & 0x01)) {
 #ifdef DEBUG
 		struct net_device	*net = dev->net;
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 7589509..6546f21 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -202,10 +202,10 @@ static int qmi_wwan_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
 	__be16 proto;
 
-	/* usbnet rx_complete guarantees that skb->len is at least
-	 * hard_header_len, so we can inspect the dest address without
-	 * checking skb->len
-	 */
+	/* This check is no longer done by usbnet */
+	if (skb->len < dev->net->hard_header_len)
+		return 0;
+
 	switch (skb->data[0] & 0xf0) {
 	case 0x40:
 		proto = htons(ETH_P_IP);
diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 4a433583..38e6d25 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -495,6 +495,10 @@ EXPORT_SYMBOL_GPL(rndis_unbind);
  */
 int rndis_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
+	/* This check is no longer done by usbnet */
+	if (skb->len < dev->net->hard_header_len)
+		return 0;
+
 	/* peripheral may have batched packets to us... */
 	while (likely(skb->len)) {
 		struct rndis_data_hdr	*hdr = (void *)skb->data;
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index c241ae7..a4370d2 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1097,6 +1097,10 @@ static void smsc75xx_rx_csum_offload(struct usbnet *dev, struct sk_buff *skb,
 
 static int smsc75xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
+	/* This check is no longer done by usbnet */
+	if (skb->len < dev->net->hard_header_len)
+		return 0;
+
 	while (skb->len > 0) {
 		u32 rx_cmd_a, rx_cmd_b, align_count, size;
 		struct sk_buff *ax_skb;
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index b1112e7..86b6fda 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1041,6 +1041,10 @@ static void smsc95xx_rx_csum_offload(struct sk_buff *skb)
 
 static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
+	/* This check is no longer done by usbnet */
+	if (skb->len < dev->net->hard_header_len)
+		return 0;
+
 	while (skb->len > 0) {
 		u32 header, align_count;
 		struct sk_buff *ax_skb;
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index a936201..49d4e9a 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -415,17 +415,19 @@ static inline void rx_process (struct usbnet *dev, struct sk_buff *skb)
 	}
 	// else network stack removes extra byte if we forced a short packet
 
-	if (skb->len) {
-		/* all data was already cloned from skb inside the driver */
-		if (dev->driver_info->flags & FLAG_MULTI_PACKET)
-			dev_kfree_skb_any(skb);
-		else
-			usbnet_skb_return(dev, skb);
+	/* all data was already cloned from skb inside the driver */
+	if (dev->driver_info->flags & FLAG_MULTI_PACKET)
+		goto done;
+
+	if (skb->len < ETH_HLEN) {
+		dev->net->stats.rx_errors++;
+		dev->net->stats.rx_length_errors++;
+		netif_dbg(dev, rx_err, dev->net, "rx length %d\n", skb->len);
+	} else {
+		usbnet_skb_return(dev, skb);
 		return;
 	}
 
-	netif_dbg(dev, rx_err, dev->net, "drop\n");
-	dev->net->stats.rx_errors++;
 done:
 	skb_queue_tail(&dev->done, skb);
 }
@@ -447,13 +449,6 @@ static void rx_complete (struct urb *urb)
 	switch (urb_status) {
 	/* success */
 	case 0:
-		if (skb->len < dev->net->hard_header_len) {
-			state = rx_cleanup;
-			dev->net->stats.rx_errors++;
-			dev->net->stats.rx_length_errors++;
-			netif_dbg(dev, rx_err, dev->net,
-				  "rx length %d\n", skb->len);
-		}
 		break;
 
 	/* stalls need manual reset. this is rare ... except that
diff --git a/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h b/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h
index e19a20a..ecd1ac4 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h
+++ b/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h
@@ -15,6 +15,8 @@
 #ifndef RTL8187_H
 #define RTL8187_H
 
+#include <linux/cache.h>
+
 #include "rtl818x.h"
 #include "leds.h"
 
@@ -139,7 +141,10 @@ struct rtl8187_priv {
 	u8 aifsn[4];
 	u8 rfkill_mask;
 	struct {
-		__le64 buf;
+		union {
+			__le64 buf;
+			u8 dummy1[L1_CACHE_BYTES];
+		} ____cacheline_aligned;
 		struct sk_buff_head queue;
 	} b_tx_status; /* This queue is used by both -b and non-b devices */
 	struct mutex io_mutex;
@@ -147,7 +152,8 @@ struct rtl8187_priv {
 		u8 bits8;
 		__le16 bits16;
 		__le32 bits32;
-	} *io_dmabuf;
+		u8 dummy2[L1_CACHE_BYTES];
+	} *io_dmabuf ____cacheline_aligned;
 	bool rfkill_off;
 	u16 seqno;
 };
diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
index 5ae2664..18bd09a 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -48,7 +48,7 @@ bool rtl_ps_enable_nic(struct ieee80211_hw *hw)
 
 	/*<2> Enable Adapter */
 	if (rtlpriv->cfg->ops->hw_init(hw))
-		return 1;
+		return false;
 	RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 
 	/*<3> Enable Interrupt */
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index 509f661..18ddf57 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -902,14 +902,26 @@ int rtl92ce_hw_init(struct ieee80211_hw *hw)
 	bool is92c;
 	int err;
 	u8 tmp_u1b;
+	unsigned long flags;
 
 	rtlpci->being_init_adapter = true;
+
+	/* Since this function can take a very long time (up to 350 ms)
+	 * and can be called with irqs disabled, reenable the irqs
+	 * to let the other devices continue being serviced.
+	 *
+	 * It is safe doing so since our own interrupts will only be enabled
+	 * in a subsequent step.
+	 */
+	local_save_flags(flags);
+	local_irq_enable();
+
 	rtlpriv->intf_ops->disable_aspm(hw);
 	rtstatus = _rtl92ce_init_mac(hw);
 	if (!rtstatus) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Init MAC failed\n");
 		err = 1;
-		return err;
+		goto exit;
 	}
 
 	err = rtl92c_download_fw(hw);
@@ -917,7 +929,7 @@ int rtl92ce_hw_init(struct ieee80211_hw *hw)
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 "Failed to download FW. Init HW without FW now..\n");
 		err = 1;
-		return err;
+		goto exit;
 	}
 
 	rtlhal->last_hmeboxnum = 0;
@@ -978,6 +990,8 @@ int rtl92ce_hw_init(struct ieee80211_hw *hw)
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "under 1.5V\n");
 	}
 	rtl92c_dm_init(hw);
+exit:
+	local_irq_restore(flags);
 	rtlpci->being_init_adapter = false;
 	return err;
 }
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index caeddd4..42b9983 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1134,6 +1134,8 @@ EXPORT_SYMBOL_GPL(pci_load_and_free_saved_state);
 static int do_pci_enable_device(struct pci_dev *dev, int bars)
 {
 	int err;
+	u16 cmd;
+	u8 pin;
 
 	err = pci_set_power_state(dev, PCI_D0);
 	if (err < 0 && err != -EIO)
@@ -1143,6 +1145,14 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
 		return err;
 	pci_fixup_device(pci_fixup_enable, dev);
 
+	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
+	if (pin) {
+		pci_read_config_word(dev, PCI_COMMAND, &cmd);
+		if (cmd & PCI_COMMAND_INTX_DISABLE)
+			pci_write_config_word(dev, PCI_COMMAND,
+					      cmd & ~PCI_COMMAND_INTX_DISABLE);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 714a97d..a8eee44 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3367,7 +3367,8 @@ restart:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf02c,
 		    "SRR cmd %p (se_cmd %p, tag %d, op %x), "
 		    "sg_cnt=%d, offset=%d", cmd, &cmd->se_cmd, cmd->tag,
-		    se_cmd->t_task_cdb[0], cmd->sg_cnt, cmd->offset);
+		    se_cmd->t_task_cdb ? se_cmd->t_task_cdb[0] : 0,
+		    cmd->sg_cnt, cmd->offset);
 
 		qlt_handle_srr(vha, sctio, imm);
 
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 800be38..6cea7c4 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -849,8 +849,15 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);
 	u32			status, masked_status, pcd_status = 0, cmd;
 	int			bh;
+	unsigned long		flags;
 
-	spin_lock (&ehci->lock);
+	/*
+	 * For threadirqs option we use spin_lock_irqsave() variant to prevent
+	 * deadlock with ehci hrtimer callback, because hrtimer callbacks run
+	 * in interrupt context even when threadirqs is specified. We can go
+	 * back to spin_lock() variant when hrtimer callbacks become threaded.
+	 */
+	spin_lock_irqsave(&ehci->lock, flags);
 
 	status = ehci_readl(ehci, &ehci->regs->status);
 
@@ -868,7 +875,7 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 
 	/* Shared IRQ? */
 	if (!masked_status || unlikely(ehci->rh_state == EHCI_RH_HALTED)) {
-		spin_unlock(&ehci->lock);
+		spin_unlock_irqrestore(&ehci->lock, flags);
 		return IRQ_NONE;
 	}
 
@@ -969,7 +976,7 @@ dead:
 
 	if (bh)
 		ehci_work (ehci);
-	spin_unlock (&ehci->lock);
+	spin_unlock_irqrestore(&ehci->lock, flags);
 	if (pcd_status)
 		usb_hcd_poll_rh_status(hcd);
 	return IRQ_HANDLED;
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index ab8b689..1dfb333 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -918,6 +918,8 @@ static struct usb_device_id id_table_combined [] = {
 	/* Crucible Devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_CT_COMET_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_Z3X_PID) },
+	/* Cressi Devices */
+	{ USB_DEVICE(FTDI_VID, FTDI_CRESSI_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 1e2d369..e599fbf 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1320,3 +1320,9 @@
  * Manufacturer: Smart GSM Team
  */
 #define FTDI_Z3X_PID		0x0011
+
+/*
+ * Product: Cressi PC Interface
+ * Manufacturer: Cressi
+ */
+#define FTDI_CRESSI_PID		0x87d0
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index e681037..171ddc6 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1546,7 +1546,8 @@ static const struct usb_device_id option_ids[] = {
 	/* Cinterion */
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_E) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_P) },
-	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PH8) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PH8),
+		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_AHXX) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PLXX),
 		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 8a0f553..bd7d67c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2238,7 +2238,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
 {
 	unsigned long nr_pages, i;
-	size_t copied, len, cur_len;
+	size_t bytes, copied, len, cur_len;
 	ssize_t total_written = 0;
 	loff_t offset;
 	struct iov_iter it;
@@ -2289,14 +2289,45 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 
 		save_len = cur_len;
 		for (i = 0; i < nr_pages; i++) {
-			copied = min_t(const size_t, cur_len, PAGE_SIZE);
+			bytes = min_t(const size_t, cur_len, PAGE_SIZE);
 			copied = iov_iter_copy_from_user(wdata->pages[i], &it,
-							 0, copied);
+							 0, bytes);
 			cur_len -= copied;
 			iov_iter_advance(&it, copied);
+			/*
+			 * If we didn't copy as much as we expected, then that
+			 * may mean we trod into an unmapped area. Stop copying
+			 * at that point. On the next pass through the big
+			 * loop, we'll likely end up getting a zero-length
+			 * write and bailing out of it.
+			 */
+			if (copied < bytes)
+				break;
 		}
 		cur_len = save_len - cur_len;
 
+		/*
+		 * If we have no data to send, then that probably means that
+		 * the copy above failed altogether. That's most likely because
+		 * the address in the iovec was bogus. Set the rc to -EFAULT,
+		 * free anything we allocated and bail out.
+		 */
+		if (!cur_len) {
+			for (i = 0; i < nr_pages; i++)
+				put_page(wdata->pages[i]);
+			kfree(wdata);
+			rc = -EFAULT;
+			break;
+		}
+
+		/*
+		 * i + 1 now represents the number of pages we actually used in
+		 * the copy phase above. Bring nr_pages down to that, and free
+		 * any pages that we didn't use.
+		 */
+		for ( ; nr_pages > i + 1; nr_pages--)
+			put_page(wdata->pages[nr_pages - 1]);
+
 		wdata->sync_mode = WB_SYNC_ALL;
 		wdata->nr_pages = nr_pages;
 		wdata->offset = (__u64)offset;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6a83398..4373e10 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -775,6 +775,8 @@ do {									       \
 	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		       \
 		(einode)->xtime.tv_sec = 				       \
 			(signed)le32_to_cpu((raw_inode)->xtime);	       \
+	else								       \
+		(einode)->xtime.tv_sec = 0;				       \
 	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
 		ext4_decode_extra_time(&(einode)->xtime,		       \
 				       raw_inode->xtime ## _extra);	       \
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index d0ba1a9..7a7316b 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -377,7 +377,7 @@ static int set_flexbg_block_bitmap(struct super_block *sb, handle_t *handle,
 		start = ext4_group_first_block_no(sb, group);
 		group -= flex_gd->groups[0].group;
 
-		count2 = sb->s_blocksize * 8 - (block - start);
+		count2 = EXT4_BLOCKS_PER_GROUP(sb) - (block - start);
 		if (count2 > count)
 			count2 = count;
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b2ae1e8..44884b7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3548,16 +3548,22 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	for (i = 0; i < 4; i++)
 		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
 	sbi->s_def_hash_version = es->s_def_hash_version;
-	i = le32_to_cpu(es->s_flags);
-	if (i & EXT2_FLAGS_UNSIGNED_HASH)
-		sbi->s_hash_unsigned = 3;
-	else if ((i & EXT2_FLAGS_SIGNED_HASH) == 0) {
+	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_DIR_INDEX)) {
+		i = le32_to_cpu(es->s_flags);
+		if (i & EXT2_FLAGS_UNSIGNED_HASH)
+			sbi->s_hash_unsigned = 3;
+		else if ((i & EXT2_FLAGS_SIGNED_HASH) == 0) {
 #ifdef __CHAR_UNSIGNED__
-		es->s_flags |= cpu_to_le32(EXT2_FLAGS_UNSIGNED_HASH);
-		sbi->s_hash_unsigned = 3;
+			if (!(sb->s_flags & MS_RDONLY))
+				es->s_flags |=
+					cpu_to_le32(EXT2_FLAGS_UNSIGNED_HASH);
+			sbi->s_hash_unsigned = 3;
 #else
-		es->s_flags |= cpu_to_le32(EXT2_FLAGS_SIGNED_HASH);
+			if (!(sb->s_flags & MS_RDONLY))
+				es->s_flags |=
+					cpu_to_le32(EXT2_FLAGS_SIGNED_HASH);
 #endif
+		}
 	}
 
 	/* Handle clustersize */
diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
index 927cbd1..f060f28 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -233,6 +233,7 @@ void __init proc_device_tree_init(void)
 		return;
 	root = of_find_node_by_path("/");
 	if (root == NULL) {
+		remove_proc_entry("device-tree", NULL);
 		pr_debug("/proc/device-tree: can't find root\n");
 		return;
 	}
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 10cbe84..000831b 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -580,9 +580,17 @@ int dquot_scan_active(struct super_block *sb,
 		dqstats_inc(DQST_LOOKUPS);
 		dqput(old_dquot);
 		old_dquot = dquot;
-		ret = fn(dquot, priv);
-		if (ret < 0)
-			goto out;
+		/*
+		 * ->release_dquot() can be racing with us. Our reference
+		 * protects us from new calls to it so just wait for any
+		 * outstanding call and recheck the DQ_ACTIVE_B after that.
+		 */
+		wait_on_dquot(dquot);
+		if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
+			ret = fn(dquot, priv);
+			if (ret < 0)
+				goto out;
+		}
 		spin_lock(&dq_list_lock);
 		/* We are safe to continue now because our dquot could not
 		 * be moved out of the inuse list while we hold the reference */
diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index c731973..545893d 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -116,9 +116,7 @@ extern int mq_init_ns(struct ipc_namespace *ns);
  *     the new maximum will handle anyone else.  I may have to revisit this
  *     in the future.
  */
-#define MIN_QUEUESMAX			1
 #define DFLT_QUEUESMAX		      256
-#define HARD_QUEUESMAX		     1024
 #define MIN_MSGMAX			1
 #define DFLT_MSG		       10U
 #define DFLT_MSGMAX		       10
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 160f3ea..0f7fcc4 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2171,6 +2171,8 @@ extern int	       skb_shift(struct sk_buff *tgt, struct sk_buff *skb,
 extern struct sk_buff *skb_segment(struct sk_buff *skb,
 				   netdev_features_t features);
 
+unsigned int skb_gso_transport_seglen(const struct sk_buff *skb);
+
 static inline void *skb_header_pointer(const struct sk_buff *skb, int offset,
 				       int len, void *buffer)
 {
@@ -2585,5 +2587,22 @@ static inline bool skb_head_is_locked(const struct sk_buff *skb)
 {
 	return !skb->head_frag || skb_cloned(skb);
 }
+
+/**
+ * skb_gso_network_seglen - Return length of individual segments of a gso packet
+ *
+ * @skb: GSO skb
+ *
+ * skb_gso_network_seglen is used to determine the real size of the
+ * individual segments, including Layer3 (IP, IPv6) and L4 headers (TCP/UDP).
+ *
+ * The MAC/L2 header is not accounted for.
+ */
+static inline unsigned int skb_gso_network_seglen(const struct sk_buff *skb)
+{
+	unsigned int hdr_len = skb_transport_header(skb) -
+			       skb_network_header(skb);
+	return hdr_len + skb_gso_transport_seglen(skb);
+}
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/ipc/mq_sysctl.c b/ipc/mq_sysctl.c
index 383d638..5bb8bfe 100644
--- a/ipc/mq_sysctl.c
+++ b/ipc/mq_sysctl.c
@@ -22,6 +22,16 @@ static void *get_mq(ctl_table *table)
 	return which;
 }
 
+static int proc_mq_dointvec(ctl_table *table, int write,
+			    void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table mq_table;
+	memcpy(&mq_table, table, sizeof(mq_table));
+	mq_table.data = get_mq(table);
+
+	return proc_dointvec(&mq_table, write, buffer, lenp, ppos);
+}
+
 static int proc_mq_dointvec_minmax(ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -33,12 +43,10 @@ static int proc_mq_dointvec_minmax(ctl_table *table, int write,
 					lenp, ppos);
 }
 #else
+#define proc_mq_dointvec NULL
 #define proc_mq_dointvec_minmax NULL
 #endif
 
-static int msg_queues_limit_min = MIN_QUEUESMAX;
-static int msg_queues_limit_max = HARD_QUEUESMAX;
-
 static int msg_max_limit_min = MIN_MSGMAX;
 static int msg_max_limit_max = HARD_MSGMAX;
 
@@ -51,9 +59,7 @@ static ctl_table mq_sysctls[] = {
 		.data		= &init_ipc_ns.mq_queues_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_mq_dointvec_minmax,
-		.extra1		= &msg_queues_limit_min,
-		.extra2		= &msg_queues_limit_max,
+		.proc_handler	= proc_mq_dointvec,
 	},
 	{
 		.procname	= "msg_max",
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 8ce5769..44700e0 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -426,9 +426,9 @@ static int mqueue_create(struct inode *dir, struct dentry *dentry,
 		error = -EACCES;
 		goto out_unlock;
 	}
-	if (ipc_ns->mq_queues_count >= HARD_QUEUESMAX ||
-	    (ipc_ns->mq_queues_count >= ipc_ns->mq_queues_max &&
-	     !capable(CAP_SYS_RESOURCE))) {
+
+	if (ipc_ns->mq_queues_count >= ipc_ns->mq_queues_max &&
+	    !capable(CAP_SYS_RESOURCE)) {
 		error = -ENOSPC;
 		goto out_unlock;
 	}
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7720f52..e4a16ed 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2941,9 +2941,14 @@ static void cgroup_enable_task_cg_lists(void)
 		 * We should check if the process is exiting, otherwise
 		 * it will race with cgroup_exit() in that the list
 		 * entry won't be deleted though the process has exited.
+		 * Do it while holding siglock so that we don't end up
+		 * racing against cgroup_exit().
 		 */
+		spin_lock_irq(&p->sighand->siglock);
 		if (!(p->flags & PF_EXITING) && list_empty(&p->cg_list))
 			list_add(&p->cg_list, &p->cgroups->tasks);
+		spin_unlock_irq(&p->sighand->siglock);
+
 		task_unlock(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3ea14c1..9e13b2d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7148,14 +7148,14 @@ static void perf_pmu_rotate_stop(struct pmu *pmu)
 static void __perf_event_exit_context(void *__info)
 {
 	struct perf_event_context *ctx = __info;
-	struct perf_event *event, *tmp;
+	struct perf_event *event;
 
 	perf_pmu_rotate_stop(ctx->pmu);
 
-	list_for_each_entry_safe(event, tmp, &ctx->pinned_groups, group_entry)
-		__perf_remove_from_context(event);
-	list_for_each_entry_safe(event, tmp, &ctx->flexible_groups, group_entry)
+	rcu_read_lock();
+	list_for_each_entry_rcu(event, &ctx->event_list, event_entry)
 		__perf_remove_from_context(event);
+	rcu_read_unlock();
 }
 
 static void perf_event_exit_cpu_context(int cpu)
@@ -7179,11 +7179,11 @@ static void perf_event_exit_cpu(int cpu)
 {
 	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
 
+	perf_event_exit_cpu_context(cpu);
+
 	mutex_lock(&swhash->hlist_mutex);
 	swevent_hlist_release(swhash);
 	mutex_unlock(&swhash->hlist_mutex);
-
-	perf_event_exit_cpu_context(cpu);
 }
 #else
 static inline void perf_event_exit_cpu(int cpu) { }
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 89743ae..d19727f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1472,12 +1472,19 @@ static void destroy_worker(struct worker *worker)
 	if (worker->flags & WORKER_IDLE)
 		gcwq->nr_idle--;
 
+	/*
+	 * Once WORKER_DIE is set, the kworker may destroy itself at any
+	 * point.  Pin to ensure the task stays until we're done with it.
+	 */
+	get_task_struct(worker->task);
+
 	list_del_init(&worker->entry);
 	worker->flags |= WORKER_DIE;
 
 	spin_unlock_irq(&gcwq->lock);
 
 	kthread_stop(worker->task);
+	put_task_struct(worker->task);
 	kfree(worker);
 
 	spin_lock_irq(&gcwq->lock);
diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index d660ad4..cef5e71 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -716,6 +716,13 @@ static int fib_rules_event(struct notifier_block *this, unsigned long event,
 			attach_rules(&ops->rules_list, dev);
 		break;
 
+	case NETDEV_CHANGENAME:
+		list_for_each_entry(ops, &net->rules_ops, list) {
+			detach_rules(&ops->rules_list, dev);
+			attach_rules(&ops->rules_list, dev);
+		}
+		break;
+
 	case NETDEV_UNREGISTER:
 		list_for_each_entry(ops, &net->rules_ops, list)
 			detach_rules(&ops->rules_list, dev);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1e37e1a..50f7c96 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -47,6 +47,8 @@
 #include <linux/in.h>
 #include <linux/inet.h>
 #include <linux/slab.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
 #include <linux/netdevice.h>
 #ifdef CONFIG_NET_CLS_ACT
 #include <net/pkt_sched.h>
@@ -3358,3 +3360,26 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	return true;
 }
 EXPORT_SYMBOL(skb_try_coalesce);
+
+/**
+ * skb_gso_transport_seglen - Return length of individual segments of a gso packet
+ *
+ * @skb: GSO skb
+ *
+ * skb_gso_transport_seglen is used to determine the real size of the
+ * individual segments, including Layer4 headers (TCP/UDP).
+ *
+ * The MAC/L2 or network (IP, IPv6) headers are not accounted for.
+ */
+unsigned int skb_gso_transport_seglen(const struct sk_buff *skb)
+{
+	const struct skb_shared_info *shinfo = skb_shinfo(skb);
+	unsigned int hdr_len;
+
+	if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)))
+		hdr_len = tcp_hdrlen(skb);
+	else
+		hdr_len = sizeof(struct udphdr);
+	return hdr_len + shinfo->gso_size;
+}
+EXPORT_SYMBOL_GPL(skb_gso_transport_seglen);
diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
index ab09b12..d9342ce 100644
--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -39,6 +39,68 @@
 #include <net/route.h>
 #include <net/xfrm.h>
 
+static bool ip_may_fragment(const struct sk_buff *skb)
+{
+	return unlikely((ip_hdr(skb)->frag_off & htons(IP_DF)) == 0) ||
+	       !skb->local_df;
+}
+
+static bool ip_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
+{
+	if (skb->len <= mtu || skb->local_df)
+		return false;
+
+	if (skb_is_gso(skb) && skb_gso_network_seglen(skb) <= mtu)
+		return false;
+
+	return true;
+}
+
+static bool ip_gso_exceeds_dst_mtu(const struct sk_buff *skb)
+{
+	unsigned int mtu;
+
+	if (skb->local_df || !skb_is_gso(skb))
+		return false;
+
+	mtu = dst_mtu(skb_dst(skb));
+
+	/* if seglen > mtu, do software segmentation for IP fragmentation on
+	 * output.  DF bit cannot be set since ip_forward would have sent
+	 * icmp error.
+	 */
+	return skb_gso_network_seglen(skb) > mtu;
+}
+
+/* called if GSO skb needs to be fragmented on forward */
+static int ip_forward_finish_gso(struct sk_buff *skb)
+{
+	struct sk_buff *segs;
+	int ret = 0;
+
+	segs = skb_gso_segment(skb, 0);
+	if (IS_ERR(segs)) {
+		kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	consume_skb(skb);
+
+	do {
+		struct sk_buff *nskb = segs->next;
+		int err;
+
+		segs->next = NULL;
+		err = dst_output(segs);
+
+		if (err && ret == 0)
+			ret = err;
+		segs = nskb;
+	} while (segs);
+
+	return ret;
+}
+
 static int ip_forward_finish(struct sk_buff *skb)
 {
 	struct ip_options *opt	= &(IPCB(skb)->opt);
@@ -49,6 +111,9 @@ static int ip_forward_finish(struct sk_buff *skb)
 	if (unlikely(opt->optlen))
 		ip_forward_options(skb);
 
+	if (ip_gso_exceeds_dst_mtu(skb))
+		return ip_forward_finish_gso(skb);
+
 	return dst_output(skb);
 }
 
@@ -88,8 +153,7 @@ int ip_forward(struct sk_buff *skb)
 	if (opt->is_strictroute && opt->nexthop != rt->rt_gateway)
 		goto sr_failed;
 
-	if (unlikely(skb->len > dst_mtu(&rt->dst) && !skb_is_gso(skb) &&
-		     (ip_hdr(skb)->frag_off & htons(IP_DF))) && !skb->local_df) {
+	if (!ip_may_fragment(skb) && ip_exceeds_mtu(skb, dst_mtu(&rt->dst))) {
 		IP_INC_STATS(dev_net(rt->dst.dev), IPSTATS_MIB_FRAGFAILS);
 		icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 			  htonl(dst_mtu(&rt->dst)));
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 9665b28..3fe4480 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -381,6 +381,17 @@ static inline int ip6_forward_finish(struct sk_buff *skb)
 	return dst_output(skb);
 }
 
+static bool ip6_pkt_too_big(const struct sk_buff *skb, unsigned int mtu)
+{
+	if (skb->len <= mtu || skb->local_df)
+		return false;
+
+	if (skb_is_gso(skb) && skb_gso_network_seglen(skb) <= mtu)
+		return false;
+
+	return true;
+}
+
 int ip6_forward(struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb);
@@ -502,7 +513,7 @@ int ip6_forward(struct sk_buff *skb)
 	if (mtu < IPV6_MIN_MTU)
 		mtu = IPV6_MIN_MTU;
 
-	if (skb->len > mtu && !skb_is_gso(skb)) {
+	if (ip6_pkt_too_big(skb, mtu)) {
 		/* Again, force OUTPUT device used as source address */
 		skb->dev = dst->dev;
 		icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index d01802a..a06d778 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -70,6 +70,7 @@
 #include <linux/init.h>
 #include <linux/crypto.h>
 #include <linux/slab.h>
+#include <linux/compat.h>
 
 #include <net/ip.h>
 #include <net/icmp.h>
@@ -1376,11 +1377,19 @@ SCTP_STATIC int sctp_setsockopt_connectx(struct sock* sk,
 /*
  * New (hopefully final) interface for the API.
  * We use the sctp_getaddrs_old structure so that use-space library
- * can avoid any unnecessary allocations.   The only defferent part
+ * can avoid any unnecessary allocations. The only different part
  * is that we store the actual length of the address buffer into the
- * addrs_num structure member.  That way we can re-use the existing
+ * addrs_num structure member. That way we can re-use the existing
  * code.
  */
+#ifdef CONFIG_COMPAT
+struct compat_sctp_getaddrs_old {
+	sctp_assoc_t	assoc_id;
+	s32		addr_num;
+	compat_uptr_t	addrs;		/* struct sockaddr * */
+};
+#endif
+
 SCTP_STATIC int sctp_getsockopt_connectx3(struct sock* sk, int len,
 					char __user *optval,
 					int __user *optlen)
@@ -1389,16 +1398,30 @@ SCTP_STATIC int sctp_getsockopt_connectx3(struct sock* sk, int len,
 	sctp_assoc_t assoc_id = 0;
 	int err = 0;
 
-	if (len < sizeof(param))
-		return -EINVAL;
+#ifdef CONFIG_COMPAT
+	if (is_compat_task()) {
+		struct compat_sctp_getaddrs_old param32;
 
-	if (copy_from_user(&param, optval, sizeof(param)))
-		return -EFAULT;
+		if (len < sizeof(param32))
+			return -EINVAL;
+		if (copy_from_user(&param32, optval, sizeof(param32)))
+			return -EFAULT;
 
-	err = __sctp_setsockopt_connectx(sk,
-			(struct sockaddr __user *)param.addrs,
-			param.addr_num, &assoc_id);
+		param.assoc_id = param32.assoc_id;
+		param.addr_num = param32.addr_num;
+		param.addrs = compat_ptr(param32.addrs);
+	} else
+#endif
+	{
+		if (len < sizeof(param))
+			return -EINVAL;
+		if (copy_from_user(&param, optval, sizeof(param)))
+			return -EFAULT;
+	}
 
+	err = __sctp_setsockopt_connectx(sk, (struct sockaddr __user *)
+					 param.addrs, param.addr_num,
+					 &assoc_id);
 	if (err == 0 || err == -EINPROGRESS) {
 		if (copy_to_user(optval, &assoc_id, sizeof(assoc_id)))
 			return -EFAULT;
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 31f981d..31275e5 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -501,6 +501,7 @@ static int xs_nospace(struct rpc_task *task)
 	struct rpc_rqst *req = task->tk_rqstp;
 	struct rpc_xprt *xprt = req->rq_xprt;
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
+	struct sock *sk = transport->inet;
 	int ret = -EAGAIN;
 
 	dprintk("RPC: %5u xmit incomplete (%u left of %u)\n",
@@ -518,7 +519,7 @@ static int xs_nospace(struct rpc_task *task)
 			 * window size
 			 */
 			set_bit(SOCK_NOSPACE, &transport->sock->flags);
-			transport->inet->sk_write_pending++;
+			sk->sk_write_pending++;
 			/* ...and wait for more buffer space */
 			xprt_wait_for_buffer_space(task, xs_nospace_callback);
 		}
@@ -528,6 +529,9 @@ static int xs_nospace(struct rpc_task *task)
 	}
 
 	spin_unlock_bh(&xprt->transport_lock);
+
+	/* Race breaker in case memory is freed before above code is called */
+	sk->sk_write_space(sk);
 	return ret;
 }
 
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 142a59f..bcdca73 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -3258,10 +3258,10 @@ static int filename_write_helper(void *key, void *data, void *ptr)
 	if (rc)
 		return rc;
 
-	buf[0] = ft->stype;
-	buf[1] = ft->ttype;
-	buf[2] = ft->tclass;
-	buf[3] = otype->otype;
+	buf[0] = cpu_to_le32(ft->stype);
+	buf[1] = cpu_to_le32(ft->ttype);
+	buf[2] = cpu_to_le32(ft->tclass);
+	buf[3] = cpu_to_le32(otype->otype);
 
 	rc = put_entry(buf, sizeof(u32), 4, fp);
 	if (rc)
diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
index 8d717f4..70004f4 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -147,42 +147,42 @@ static const unsigned int sta32x_limiter_drc_release_tlv[] = {
 	13, 16, TLV_DB_SCALE_ITEM(-1500, 300, 0),
 };
 
-static const struct soc_enum sta32x_drc_ac_enum =
-	SOC_ENUM_SINGLE(STA32X_CONFD, STA32X_CONFD_DRC_SHIFT,
-			2, sta32x_drc_ac);
-static const struct soc_enum sta32x_auto_eq_enum =
-	SOC_ENUM_SINGLE(STA32X_AUTO1, STA32X_AUTO1_AMEQ_SHIFT,
-			3, sta32x_auto_eq_mode);
-static const struct soc_enum sta32x_auto_gc_enum =
-	SOC_ENUM_SINGLE(STA32X_AUTO1, STA32X_AUTO1_AMGC_SHIFT,
-			4, sta32x_auto_gc_mode);
-static const struct soc_enum sta32x_auto_xo_enum =
-	SOC_ENUM_SINGLE(STA32X_AUTO2, STA32X_AUTO2_XO_SHIFT,
-			16, sta32x_auto_xo_mode);
-static const struct soc_enum sta32x_preset_eq_enum =
-	SOC_ENUM_SINGLE(STA32X_AUTO3, STA32X_AUTO3_PEQ_SHIFT,
-			32, sta32x_preset_eq_mode);
-static const struct soc_enum sta32x_limiter_ch1_enum =
-	SOC_ENUM_SINGLE(STA32X_C1CFG, STA32X_CxCFG_LS_SHIFT,
-			3, sta32x_limiter_select);
-static const struct soc_enum sta32x_limiter_ch2_enum =
-	SOC_ENUM_SINGLE(STA32X_C2CFG, STA32X_CxCFG_LS_SHIFT,
-			3, sta32x_limiter_select);
-static const struct soc_enum sta32x_limiter_ch3_enum =
-	SOC_ENUM_SINGLE(STA32X_C3CFG, STA32X_CxCFG_LS_SHIFT,
-			3, sta32x_limiter_select);
-static const struct soc_enum sta32x_limiter1_attack_rate_enum =
-	SOC_ENUM_SINGLE(STA32X_L1AR, STA32X_LxA_SHIFT,
-			16, sta32x_limiter_attack_rate);
-static const struct soc_enum sta32x_limiter2_attack_rate_enum =
-	SOC_ENUM_SINGLE(STA32X_L2AR, STA32X_LxA_SHIFT,
-			16, sta32x_limiter_attack_rate);
-static const struct soc_enum sta32x_limiter1_release_rate_enum =
-	SOC_ENUM_SINGLE(STA32X_L1AR, STA32X_LxR_SHIFT,
-			16, sta32x_limiter_release_rate);
-static const struct soc_enum sta32x_limiter2_release_rate_enum =
-	SOC_ENUM_SINGLE(STA32X_L2AR, STA32X_LxR_SHIFT,
-			16, sta32x_limiter_release_rate);
+static SOC_ENUM_SINGLE_DECL(sta32x_drc_ac_enum,
+			    STA32X_CONFD, STA32X_CONFD_DRC_SHIFT,
+			    sta32x_drc_ac);
+static SOC_ENUM_SINGLE_DECL(sta32x_auto_eq_enum,
+			    STA32X_AUTO1, STA32X_AUTO1_AMEQ_SHIFT,
+			    sta32x_auto_eq_mode);
+static SOC_ENUM_SINGLE_DECL(sta32x_auto_gc_enum,
+			    STA32X_AUTO1, STA32X_AUTO1_AMGC_SHIFT,
+			    sta32x_auto_gc_mode);
+static SOC_ENUM_SINGLE_DECL(sta32x_auto_xo_enum,
+			    STA32X_AUTO2, STA32X_AUTO2_XO_SHIFT,
+			    sta32x_auto_xo_mode);
+static SOC_ENUM_SINGLE_DECL(sta32x_preset_eq_enum,
+			    STA32X_AUTO3, STA32X_AUTO3_PEQ_SHIFT,
+			    sta32x_preset_eq_mode);
+static SOC_ENUM_SINGLE_DECL(sta32x_limiter_ch1_enum,
+			    STA32X_C1CFG, STA32X_CxCFG_LS_SHIFT,
+			    sta32x_limiter_select);
+static SOC_ENUM_SINGLE_DECL(sta32x_limiter_ch2_enum,
+			    STA32X_C2CFG, STA32X_CxCFG_LS_SHIFT,
+			    sta32x_limiter_select);
+static SOC_ENUM_SINGLE_DECL(sta32x_limiter_ch3_enum,
+			    STA32X_C3CFG, STA32X_CxCFG_LS_SHIFT,
+			    sta32x_limiter_select);
+static SOC_ENUM_SINGLE_DECL(sta32x_limiter1_attack_rate_enum,
+			    STA32X_L1AR, STA32X_LxA_SHIFT,
+			    sta32x_limiter_attack_rate);
+static SOC_ENUM_SINGLE_DECL(sta32x_limiter2_attack_rate_enum,
+			    STA32X_L2AR, STA32X_LxA_SHIFT,
+			    sta32x_limiter_attack_rate);
+static SOC_ENUM_SINGLE_DECL(sta32x_limiter1_release_rate_enum,
+			    STA32X_L1AR, STA32X_LxR_SHIFT,
+			    sta32x_limiter_release_rate);
+static SOC_ENUM_SINGLE_DECL(sta32x_limiter2_release_rate_enum,
+			    STA32X_L2AR, STA32X_LxR_SHIFT,
+			    sta32x_limiter_release_rate);
 
 /* byte array controls for setting biquad, mixer, scaling coefficients;
  * for biquads all five coefficients need to be set in one go,
@@ -394,7 +394,7 @@ SOC_SINGLE_TLV("Treble Tone Control", STA32X_TONE, STA32X_TONE_TTC_SHIFT, 15, 0,
 SOC_ENUM("Limiter1 Attack Rate (dB/ms)", sta32x_limiter1_attack_rate_enum),
 SOC_ENUM("Limiter2 Attack Rate (dB/ms)", sta32x_limiter2_attack_rate_enum),
 SOC_ENUM("Limiter1 Release Rate (dB/ms)", sta32x_limiter1_release_rate_enum),
-SOC_ENUM("Limiter2 Release Rate (dB/ms)", sta32x_limiter1_release_rate_enum),
+SOC_ENUM("Limiter2 Release Rate (dB/ms)", sta32x_limiter2_release_rate_enum),
 
 /* depending on mode, the attack/release thresholds have
  * two different enum definitions; provide both
diff --git a/sound/soc/codecs/wm8770.c b/sound/soc/codecs/wm8770.c
index a5127b4..9e82674 100644
--- a/sound/soc/codecs/wm8770.c
+++ b/sound/soc/codecs/wm8770.c
@@ -162,8 +162,8 @@ static const char *ain_text[] = {
 	"AIN5", "AIN6", "AIN7", "AIN8"
 };
 
-static const struct soc_enum ain_enum =
-	SOC_ENUM_DOUBLE(WM8770_ADCMUX, 0, 4, 8, ain_text);
+static SOC_ENUM_DOUBLE_DECL(ain_enum,
+			    WM8770_ADCMUX, 0, 4, ain_text);
 
 static const struct snd_kcontrol_new ain_mux =
 	SOC_DAPM_ENUM("Capture Mux", ain_enum);
diff --git a/sound/soc/codecs/wm8958-dsp2.c b/sound/soc/codecs/wm8958-dsp2.c
index 1332692..77552b5 100644
--- a/sound/soc/codecs/wm8958-dsp2.c
+++ b/sound/soc/codecs/wm8958-dsp2.c
@@ -153,7 +153,7 @@ static int wm8958_dsp2_fw(struct snd_soc_codec *codec, const char *name,
 
 			data32 &= 0xffffff;
 
-			wm8994_bulk_write(codec->control_data,
+			wm8994_bulk_write(wm8994->wm8994,
 					  data32 & 0xffffff,
 					  block_len / 2,
 					  (void *)(data + 8));
diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index e71fe55..2dafe18 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -313,6 +313,11 @@ static struct usbmix_name_map hercules_usb51_map[] = {
 	{ 0 }				/* terminator */
 };
 
+static const struct usbmix_name_map kef_x300a_map[] = {
+	{ 10, NULL }, /* firmware locks up (?) when we try to access this FU */
+	{ 0 }
+};
+
 /*
  * Control map entries
  */
@@ -392,6 +397,10 @@ static struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.id = USB_ID(0x200c, 0x1018),
 		.map = ebox44_map,
 	},
+	{
+		.id = USB_ID(0x27ac, 0x1000),
+		.map = kef_x300a_map,
+	},
 	{ 0 } /* terminator */
 };
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 05dbc8b..5f99cec 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -420,7 +420,7 @@ int parse_events_add_cache(struct list_head **list, int *idx,
 	for (i = 0; (i < 2) && (op_result[i]); i++) {
 		char *str = op_result[i];
 
-		snprintf(name + n, MAX_NAME_LEN - n, "-%s\n", str);
+		n += snprintf(name + n, MAX_NAME_LEN - n, "-%s", str);
 
 		if (cache_op == -1) {
 			cache_op = parse_aliases(str, hw_cache_op,
