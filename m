Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaGPT25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:28:57 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26779 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaGPT2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:28:49 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86, mptable: Remove update mptable support
Date: Wed, 16 Jul 2014 12:28:34 -0700
Message-Id: <1405538914-23084-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was used to boot first kernel with acpi support kexec second kernel
without acpi support.

As BIOS may have other acpi problem but irq routing is right, and same time
mptable is totally broken.

Other use case is that linuxbios was not using acpi, and we need dump
correct mptable from legacy bios when we don't have idea about hw irq
routing.

Assume new systems will only work with acpi enabled kernel and well tested
on linux, and even system with coreboot and linuxbios support acpi properly
so remove this workaround from the kernel.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/e820.h   |    1 
 arch/x86/include/asm/mpspec.h |    4 
 arch/x86/kernel/acpi/boot.c   |   39 -----
 arch/x86/kernel/e820.c        |   32 ----
 arch/x86/kernel/mpparse.c     |  277 ------------------------------------------
 arch/x86/kernel/setup.c       |    3 
 6 files changed, 356 deletions(-)

Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -64,8 +64,6 @@ static inline void find_smp_config(void)
 }
 
 #ifdef CONFIG_X86_MPPARSE
-extern void early_reserve_e820_mpc_new(void);
-extern int enable_update_mptable;
 extern int default_mpc_apic_id(struct mpc_cpu *m);
 extern void default_smp_read_mpc_oem(struct mpc_table *mpc);
 # ifdef CONFIG_X86_IO_APIC
@@ -76,8 +74,6 @@ extern void default_mpc_oem_bus_info(str
 extern void default_find_smp_config(void);
 extern void default_get_smp_config(unsigned int early);
 #else
-static inline void early_reserve_e820_mpc_new(void) { }
-#define enable_update_mptable 0
 #define default_mpc_apic_id NULL
 #define default_smp_read_mpc_oem NULL
 #define default_mpc_oem_bus_info NULL
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -642,280 +642,3 @@ void __init default_find_smp_config(void
 	if (address)
 		smp_scan_config(address, 0x400);
 }
-
-#ifdef CONFIG_X86_IO_APIC
-static u8 __initdata irq_used[MAX_IRQ_SOURCES];
-
-static int  __init get_MP_intsrc_index(struct mpc_intsrc *m)
-{
-	int i;
-
-	if (m->irqtype != mp_INT)
-		return 0;
-
-	if (m->irqflag != 0x0f)
-		return 0;
-
-	/* not legacy */
-
-	for (i = 0; i < mp_irq_entries; i++) {
-		if (mp_irqs[i].irqtype != mp_INT)
-			continue;
-
-		if (mp_irqs[i].irqflag != 0x0f)
-			continue;
-
-		if (mp_irqs[i].srcbus != m->srcbus)
-			continue;
-		if (mp_irqs[i].srcbusirq != m->srcbusirq)
-			continue;
-		if (irq_used[i]) {
-			/* already claimed */
-			return -2;
-		}
-		irq_used[i] = 1;
-		return i;
-	}
-
-	/* not found */
-	return -1;
-}
-
-#define SPARE_SLOT_NUM 20
-
-static struct mpc_intsrc __initdata *m_spare[SPARE_SLOT_NUM];
-
-static void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
-{
-	int i;
-
-	apic_printk(APIC_VERBOSE, "OLD ");
-	print_mp_irq_info(m);
-
-	i = get_MP_intsrc_index(m);
-	if (i > 0) {
-		memcpy(m, &mp_irqs[i], sizeof(*m));
-		apic_printk(APIC_VERBOSE, "NEW ");
-		print_mp_irq_info(&mp_irqs[i]);
-		return;
-	}
-	if (!i) {
-		/* legacy, do nothing */
-		return;
-	}
-	if (*nr_m_spare < SPARE_SLOT_NUM) {
-		/*
-		 * not found (-1), or duplicated (-2) are invalid entries,
-		 * we need to use the slot later
-		 */
-		m_spare[*nr_m_spare] = m;
-		*nr_m_spare += 1;
-	}
-}
-
-static int __init
-check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length, int count)
-{
-	if (!mpc_new_phys || count <= mpc_new_length) {
-		WARN(1, "update_mptable: No spare slots (length: %x)\n", count);
-		return -1;
-	}
-
-	return 0;
-}
-#else /* CONFIG_X86_IO_APIC */
-static
-inline void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
-#endif /* CONFIG_X86_IO_APIC */
-
-static int  __init replace_intsrc_all(struct mpc_table *mpc,
-					unsigned long mpc_new_phys,
-					unsigned long mpc_new_length)
-{
-#ifdef CONFIG_X86_IO_APIC
-	int i;
-#endif
-	int count = sizeof(*mpc);
-	int nr_m_spare = 0;
-	unsigned char *mpt = ((unsigned char *)mpc) + count;
-
-	pr_info("mpc_length %x\n", mpc->length);
-	while (count < mpc->length) {
-		switch (*mpt) {
-		case MP_PROCESSOR:
-			skip_entry(&mpt, &count, sizeof(struct mpc_cpu));
-			break;
-		case MP_BUS:
-			skip_entry(&mpt, &count, sizeof(struct mpc_bus));
-			break;
-		case MP_IOAPIC:
-			skip_entry(&mpt, &count, sizeof(struct mpc_ioapic));
-			break;
-		case MP_INTSRC:
-			check_irq_src((struct mpc_intsrc *)mpt, &nr_m_spare);
-			skip_entry(&mpt, &count, sizeof(struct mpc_intsrc));
-			break;
-		case MP_LINTSRC:
-			skip_entry(&mpt, &count, sizeof(struct mpc_lintsrc));
-			break;
-		default:
-			/* wrong mptable */
-			smp_dump_mptable(mpc, mpt);
-			goto out;
-		}
-	}
-
-#ifdef CONFIG_X86_IO_APIC
-	for (i = 0; i < mp_irq_entries; i++) {
-		if (irq_used[i])
-			continue;
-
-		if (mp_irqs[i].irqtype != mp_INT)
-			continue;
-
-		if (mp_irqs[i].irqflag != 0x0f)
-			continue;
-
-		if (nr_m_spare > 0) {
-			apic_printk(APIC_VERBOSE, "*NEW* found\n");
-			nr_m_spare--;
-			memcpy(m_spare[nr_m_spare], &mp_irqs[i], sizeof(mp_irqs[i]));
-			m_spare[nr_m_spare] = NULL;
-		} else {
-			struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
-			count += sizeof(struct mpc_intsrc);
-			if (check_slot(mpc_new_phys, mpc_new_length, count) < 0)
-				goto out;
-			memcpy(m, &mp_irqs[i], sizeof(*m));
-			mpc->length = count;
-			mpt += sizeof(struct mpc_intsrc);
-		}
-		print_mp_irq_info(&mp_irqs[i]);
-	}
-#endif
-out:
-	/* update checksum */
-	mpc->checksum = 0;
-	mpc->checksum -= mpf_checksum((unsigned char *)mpc, mpc->length);
-
-	return 0;
-}
-
-int enable_update_mptable;
-
-static int __init update_mptable_setup(char *str)
-{
-	enable_update_mptable = 1;
-#ifdef CONFIG_PCI
-	pci_routeirq = 1;
-#endif
-	return 0;
-}
-early_param("update_mptable", update_mptable_setup);
-
-static unsigned long __initdata mpc_new_phys;
-static unsigned long mpc_new_length __initdata = 4096;
-
-/* alloc_mptable or alloc_mptable=4k */
-static int __initdata alloc_mptable;
-static int __init parse_alloc_mptable_opt(char *p)
-{
-	enable_update_mptable = 1;
-#ifdef CONFIG_PCI
-	pci_routeirq = 1;
-#endif
-	alloc_mptable = 1;
-	if (!p)
-		return 0;
-	mpc_new_length = memparse(p, &p);
-	return 0;
-}
-early_param("alloc_mptable", parse_alloc_mptable_opt);
-
-void __init early_reserve_e820_mpc_new(void)
-{
-	if (enable_update_mptable && alloc_mptable)
-		mpc_new_phys = early_reserve_e820(mpc_new_length, 4);
-}
-
-static int __init update_mp_table(void)
-{
-	char str[16];
-	char oem[10];
-	struct mpf_intel *mpf;
-	struct mpc_table *mpc, *mpc_new;
-
-	if (!enable_update_mptable)
-		return 0;
-
-	mpf = mpf_found;
-	if (!mpf)
-		return 0;
-
-	/*
-	 * Now see if we need to go further.
-	 */
-	if (mpf->feature1 != 0)
-		return 0;
-
-	if (!mpf->physptr)
-		return 0;
-
-	mpc = phys_to_virt(mpf->physptr);
-
-	if (!smp_check_mpc(mpc, oem, str))
-		return 0;
-
-	pr_info("mpf: %llx\n", (u64)virt_to_phys(mpf));
-	pr_info("physptr: %x\n", mpf->physptr);
-
-	if (mpc_new_phys && mpc->length > mpc_new_length) {
-		mpc_new_phys = 0;
-		pr_info("mpc_new_length is %ld, please use alloc_mptable=8k\n",
-			mpc_new_length);
-	}
-
-	if (!mpc_new_phys) {
-		unsigned char old, new;
-		/* check if we can change the position */
-		mpc->checksum = 0;
-		old = mpf_checksum((unsigned char *)mpc, mpc->length);
-		mpc->checksum = 0xff;
-		new = mpf_checksum((unsigned char *)mpc, mpc->length);
-		if (old == new) {
-			pr_info("mpc is readonly, please try alloc_mptable instead\n");
-			return 0;
-		}
-		pr_info("use in-position replacing\n");
-	} else {
-		mpf->physptr = mpc_new_phys;
-		mpc_new = phys_to_virt(mpc_new_phys);
-		memcpy(mpc_new, mpc, mpc->length);
-		mpc = mpc_new;
-		/* check if we can modify that */
-		if (mpc_new_phys - mpf->physptr) {
-			struct mpf_intel *mpf_new;
-			/* steal 16 bytes from [0, 1k) */
-			pr_info("mpf new: %x\n", 0x400 - 16);
-			mpf_new = phys_to_virt(0x400 - 16);
-			memcpy(mpf_new, mpf, 16);
-			mpf = mpf_new;
-			mpf->physptr = mpc_new_phys;
-		}
-		mpf->checksum = 0;
-		mpf->checksum -= mpf_checksum((unsigned char *)mpf, 16);
-		pr_info("physptr new: %x\n", mpf->physptr);
-	}
-
-	/*
-	 * only replace the one with mp_INT and
-	 *	 MP_IRQ_TRIGGER_LEVEL|MP_IRQ_POLARITY_LOW,
-	 * already in mp_irqs , stored by ... and mp_config_acpi_gsi,
-	 * may need pci=routeirq for all coverage
-	 */
-	replace_intsrc_all(mpc, mpc_new_phys, mpc_new_length);
-
-	return 0;
-}
-
-late_initcall(update_mp_table);
Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -491,13 +491,6 @@ u64 __init e820_update_range(u64 start,
 	return __e820_update_range(&e820, start, size, old_type, new_type);
 }
 
-static u64 __init e820_update_range_saved(u64 start, u64 size,
-					  unsigned old_type, unsigned new_type)
-{
-	return __e820_update_range(&e820_saved, start, size, old_type,
-				     new_type);
-}
-
 /* make e820 not cover the range */
 u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
 			     int checktype)
@@ -570,15 +563,7 @@ void __init update_e820(void)
 	printk(KERN_INFO "e820: modified physical RAM map:\n");
 	e820_print_map("modified");
 }
-static void __init update_e820_saved(void)
-{
-	u32 nr_map;
 
-	nr_map = e820_saved.nr_map;
-	if (sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map), &nr_map))
-		return;
-	e820_saved.nr_map = nr_map;
-}
 #define MAX_GAP_END 0x100000000ull
 /*
  * Search for a gap in the e820 memory space from start_addr to end_addr.
@@ -727,23 +712,6 @@ static int __init e820_mark_nvs_memory(v
 core_initcall(e820_mark_nvs_memory);
 #endif
 
-/*
- * pre allocated 4k and reserved it in memblock and e820_saved
- */
-u64 __init early_reserve_e820(u64 size, u64 align)
-{
-	u64 addr;
-
-	addr = __memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
-	if (addr) {
-		e820_update_range_saved(addr, size, E820_RAM, E820_RESERVED);
-		printk(KERN_INFO "e820: update e820_saved for early_reserve_e820\n");
-		update_e820_saved();
-	}
-
-	return addr;
-}
-
 #ifdef CONFIG_X86_32
 # ifdef CONFIG_X86_PAE
 #  define MAX_ARCH_PFN		(1ULL<<(36-PAGE_SHIFT))
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -1095,9 +1095,6 @@ void __init setup_arch(char **cmdline_p)
 	if (efi_enabled(EFI_MEMMAP))
 		efi_reserve_boot_services();
 
-	/* preallocate 4k for mptable mpc */
-	early_reserve_e820_mpc_new();
-
 #ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
 	setup_bios_corruption_check();
 #endif
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -351,42 +351,6 @@ static void __init mp_override_legacy_ir
 	isa_irq_to_gsi[bus_irq] = gsi;
 }
 
-static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
-			int polarity)
-{
-#ifdef CONFIG_X86_MPPARSE
-	struct mpc_intsrc mp_irq;
-	struct pci_dev *pdev;
-	unsigned char number;
-	unsigned int devfn;
-	int ioapic;
-	u8 pin;
-
-	if (!acpi_ioapic)
-		return 0;
-	if (!dev || !dev_is_pci(dev))
-		return 0;
-
-	pdev = to_pci_dev(dev);
-	number = pdev->bus->number;
-	devfn = pdev->devfn;
-	pin = pdev->pin;
-	/* print the entry should happen on mptable identically */
-	mp_irq.type = MP_INTSRC;
-	mp_irq.irqtype = mp_INT;
-	mp_irq.irqflag = (trigger == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
-				(polarity == ACPI_ACTIVE_HIGH ? 1 : 3);
-	mp_irq.srcbus = number;
-	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
-	ioapic = mp_find_ioapic(gsi);
-	mp_irq.dstapic = mpc_ioapic_id(ioapic);
-	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
-
-	mp_save_irq(&mp_irq);
-#endif
-	return 0;
-}
-
 static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 			   int polarity)
 {
@@ -411,9 +375,6 @@ static int mp_register_gsi(struct device
 	if (irq < 0)
 		return irq;
 
-	if (enable_update_mptable)
-		mp_config_acpi_gsi(dev, gsi, trigger, polarity);
-
 	return irq;
 }
 
Index: linux-2.6/arch/x86/include/asm/e820.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/e820.h
+++ linux-2.6/arch/x86/include/asm/e820.h
@@ -50,7 +50,6 @@ static inline void early_memtest(unsigne
 
 extern unsigned long e820_end_of_ram_pfn(void);
 extern unsigned long e820_end_of_low_ram_pfn(void);
-extern u64 early_reserve_e820(u64 sizet, u64 align);
 
 void memblock_x86_fill(void);
 void memblock_find_dma_reserve(void);
