Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab3GAKeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:34:01 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:34418 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab3GAKeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:34:00 -0400
Date: Mon, 1 Jul 2013 12:33:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/microcode changes for v3.11
Message-ID: <20130701103355.GA18138@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-microcode-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-microcode-for-linus

   HEAD: 9608d33b8210c993af4430d661a6474946480c9b x86, microcode, amd: Another early loading fixup

Two main changes that improve microcode loading on AMD CPUs:

 - Add support for all-in-one binary microcode files that concatenate the 
   microcode images of multiple processor families, by Jacob Shin

 - Add early microcode loading (embedded in the initrd) support,
   by Jacob Shin

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86, microcode, intel: Correct typo in printk

Jacob Shin (7):
      x86, microcode: Vendor abstract out save_microcode_in_initrd()
      x86, microcode, amd: Refactor functions to prepare for early loading
      x86, microcode, amd: Early microcode patch loading support for AMD
      x86, microcode, amd: Fix warnings and errors on with CONFIG_MICROCODE=m
      x86, microcode, amd: Make find_ucode_in_initrd() __init
      x86, microcode, amd: Allow multiple families' bin files appended together
      x86, microcode, amd: Another early loading fixup


 Documentation/x86/early-microcode.txt   |  11 +-
 arch/x86/Kconfig                        |  14 +-
 arch/x86/include/asm/microcode_amd.h    |  78 +++++++++
 arch/x86/include/asm/microcode_intel.h  |   2 +
 arch/x86/kernel/Makefile                |   1 +
 arch/x86/kernel/microcode_amd.c         | 133 +++++++-------
 arch/x86/kernel/microcode_amd_early.c   | 302 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/microcode_core_early.c  |  49 +++++-
 arch/x86/kernel/microcode_intel_early.c |   6 +-
 9 files changed, 509 insertions(+), 87 deletions(-)
 create mode 100644 arch/x86/include/asm/microcode_amd.h
 create mode 100644 arch/x86/kernel/microcode_amd_early.c

diff --git a/Documentation/x86/early-microcode.txt b/Documentation/x86/early-microcode.txt
index 4aaf0df..d62bea6 100644
--- a/Documentation/x86/early-microcode.txt
+++ b/Documentation/x86/early-microcode.txt
@@ -11,7 +11,8 @@ file and loaded to CPUs during boot time.
 The format of the combined initrd image is microcode in cpio format followed by
 the initrd image (maybe compressed). Kernel parses the combined initrd image
 during boot time. The microcode file in cpio name space is:
-kernel/x86/microcode/GenuineIntel.bin
+on Intel: kernel/x86/microcode/GenuineIntel.bin
+on AMD  : kernel/x86/microcode/AuthenticAMD.bin
 
 During BSP boot (before SMP starts), if the kernel finds the microcode file in
 the initrd file, it parses the microcode and saves matching microcode in memory.
@@ -34,10 +35,8 @@ original initrd image /boot/initrd-3.5.0.img.
 
 mkdir initrd
 cd initrd
-mkdir kernel
-mkdir kernel/x86
-mkdir kernel/x86/microcode
-cp ../microcode.bin kernel/x86/microcode/GenuineIntel.bin
-find .|cpio -oc >../ucode.cpio
+mkdir -p kernel/x86/microcode
+cp ../microcode.bin kernel/x86/microcode/GenuineIntel.bin (or AuthenticAMD.bin)
+find . | cpio -o -H newc >../ucode.cpio
 cd ..
 cat ucode.cpio /boot/initrd-3.5.0.img >/boot/initrd-3.5.0.ucode.img
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 685692c..2705532 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1058,8 +1058,16 @@ config MICROCODE_INTEL_LIB
 	depends on MICROCODE_INTEL
 
 config MICROCODE_INTEL_EARLY
+	def_bool n
+
+config MICROCODE_AMD_EARLY
+	def_bool n
+
+config MICROCODE_EARLY
 	bool "Early load microcode"
-	depends on MICROCODE_INTEL && BLK_DEV_INITRD
+	depends on MICROCODE=y && BLK_DEV_INITRD
+	select MICROCODE_INTEL_EARLY if MICROCODE_INTEL
+	select MICROCODE_AMD_EARLY if MICROCODE_AMD
 	default y
 	help
 	  This option provides functionality to read additional microcode data
@@ -1067,10 +1075,6 @@ config MICROCODE_INTEL_EARLY
 	  microcode to CPU's as early as possible. No functional change if no
 	  microcode data is glued to the initrd, therefore it's safe to say Y.
 
-config MICROCODE_EARLY
-	def_bool y
-	depends on MICROCODE_INTEL_EARLY
-
 config X86_MSR
 	tristate "/dev/cpu/*/msr - Model-specific register support"
 	---help---
diff --git a/arch/x86/include/asm/microcode_amd.h b/arch/x86/include/asm/microcode_amd.h
new file mode 100644
index 0000000..c6b043f
--- /dev/null
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -0,0 +1,78 @@
+#ifndef _ASM_X86_MICROCODE_AMD_H
+#define _ASM_X86_MICROCODE_AMD_H
+
+#include <asm/microcode.h>
+
+#define UCODE_MAGIC			0x00414d44
+#define UCODE_EQUIV_CPU_TABLE_TYPE	0x00000000
+#define UCODE_UCODE_TYPE		0x00000001
+
+#define SECTION_HDR_SIZE		8
+#define CONTAINER_HDR_SZ		12
+
+struct equiv_cpu_entry {
+	u32	installed_cpu;
+	u32	fixed_errata_mask;
+	u32	fixed_errata_compare;
+	u16	equiv_cpu;
+	u16	res;
+} __attribute__((packed));
+
+struct microcode_header_amd {
+	u32	data_code;
+	u32	patch_id;
+	u16	mc_patch_data_id;
+	u8	mc_patch_data_len;
+	u8	init_flag;
+	u32	mc_patch_data_checksum;
+	u32	nb_dev_id;
+	u32	sb_dev_id;
+	u16	processor_rev_id;
+	u8	nb_rev_id;
+	u8	sb_rev_id;
+	u8	bios_api_rev;
+	u8	reserved1[3];
+	u32	match_reg[8];
+} __attribute__((packed));
+
+struct microcode_amd {
+	struct microcode_header_amd	hdr;
+	unsigned int			mpb[0];
+};
+
+static inline u16 find_equiv_id(struct equiv_cpu_entry *equiv_cpu_table,
+				unsigned int sig)
+{
+	int i = 0;
+
+	if (!equiv_cpu_table)
+		return 0;
+
+	while (equiv_cpu_table[i].installed_cpu != 0) {
+		if (sig == equiv_cpu_table[i].installed_cpu)
+			return equiv_cpu_table[i].equiv_cpu;
+
+		i++;
+	}
+	return 0;
+}
+
+extern int __apply_microcode_amd(struct microcode_amd *mc_amd);
+extern int apply_microcode_amd(int cpu);
+extern enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size);
+
+#ifdef CONFIG_MICROCODE_AMD_EARLY
+#ifdef CONFIG_X86_32
+#define MPB_MAX_SIZE PAGE_SIZE
+extern u8 amd_bsp_mpb[MPB_MAX_SIZE];
+#endif
+extern void __init load_ucode_amd_bsp(void);
+extern void __cpuinit load_ucode_amd_ap(void);
+extern int __init save_microcode_in_initrd_amd(void);
+#else
+static inline void __init load_ucode_amd_bsp(void) {}
+static inline void __cpuinit load_ucode_amd_ap(void) {}
+static inline int __init save_microcode_in_initrd_amd(void) { return -EINVAL; }
+#endif
+
+#endif /* _ASM_X86_MICROCODE_AMD_H */
diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index 5356f92..87a0853 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -67,10 +67,12 @@ update_match_revision(struct microcode_header_intel *mc_header, int rev);
 extern void __init load_ucode_intel_bsp(void);
 extern void __cpuinit load_ucode_intel_ap(void);
 extern void show_ucode_info_early(void);
+extern int __init save_microcode_in_initrd_intel(void);
 #else
 static inline __init void load_ucode_intel_bsp(void) {}
 static inline __cpuinit void load_ucode_intel_ap(void) {}
 static inline void show_ucode_info_early(void) {}
+static inline int __init save_microcode_in_initrd_intel(void) { return -EINVAL; }
 #endif
 
 #if defined(CONFIG_MICROCODE_INTEL_EARLY) && defined(CONFIG_HOTPLUG_CPU)
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 7bd3bd3..6c3fcea 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -93,6 +93,7 @@ obj-$(CONFIG_MICROCODE_INTEL_LIB)	+= microcode_intel_lib.o
 microcode-y				:= microcode_core.o
 microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
 microcode-$(CONFIG_MICROCODE_AMD)	+= microcode_amd.o
+obj-$(CONFIG_MICROCODE_AMD_EARLY)	+= microcode_amd_early.o
 obj-$(CONFIG_MICROCODE)			+= microcode.o
 
 obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index efdec7c..47ebb1d 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -31,48 +31,12 @@
 #include <asm/microcode.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
+#include <asm/microcode_amd.h>
 
 MODULE_DESCRIPTION("AMD Microcode Update Driver");
 MODULE_AUTHOR("Peter Oruba");
 MODULE_LICENSE("GPL v2");
 
-#define UCODE_MAGIC                0x00414d44
-#define UCODE_EQUIV_CPU_TABLE_TYPE 0x00000000
-#define UCODE_UCODE_TYPE           0x00000001
-
-struct equiv_cpu_entry {
-	u32	installed_cpu;
-	u32	fixed_errata_mask;
-	u32	fixed_errata_compare;
-	u16	equiv_cpu;
-	u16	res;
-} __attribute__((packed));
-
-struct microcode_header_amd {
-	u32	data_code;
-	u32	patch_id;
-	u16	mc_patch_data_id;
-	u8	mc_patch_data_len;
-	u8	init_flag;
-	u32	mc_patch_data_checksum;
-	u32	nb_dev_id;
-	u32	sb_dev_id;
-	u16	processor_rev_id;
-	u8	nb_rev_id;
-	u8	sb_rev_id;
-	u8	bios_api_rev;
-	u8	reserved1[3];
-	u32	match_reg[8];
-} __attribute__((packed));
-
-struct microcode_amd {
-	struct microcode_header_amd	hdr;
-	unsigned int			mpb[0];
-};
-
-#define SECTION_HDR_SIZE	8
-#define CONTAINER_HDR_SZ	12
-
 static struct equiv_cpu_entry *equiv_cpu_table;
 
 struct ucode_patch {
@@ -84,21 +48,10 @@ struct ucode_patch {
 
 static LIST_HEAD(pcache);
 
-static u16 find_equiv_id(unsigned int cpu)
+static u16 __find_equiv_id(unsigned int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	int i = 0;
-
-	if (!equiv_cpu_table)
-		return 0;
-
-	while (equiv_cpu_table[i].installed_cpu != 0) {
-		if (uci->cpu_sig.sig == equiv_cpu_table[i].installed_cpu)
-			return equiv_cpu_table[i].equiv_cpu;
-
-		i++;
-	}
-	return 0;
+	return find_equiv_id(equiv_cpu_table, uci->cpu_sig.sig);
 }
 
 static u32 find_cpu_family_by_equiv_cpu(u16 equiv_cpu)
@@ -163,7 +116,7 @@ static struct ucode_patch *find_patch(unsigned int cpu)
 {
 	u16 equiv_id;
 
-	equiv_id = find_equiv_id(cpu);
+	equiv_id = __find_equiv_id(cpu);
 	if (!equiv_id)
 		return NULL;
 
@@ -173,9 +126,20 @@ static struct ucode_patch *find_patch(unsigned int cpu)
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct ucode_patch *p;
 
 	csig->sig = cpuid_eax(0x00000001);
 	csig->rev = c->microcode;
+
+	/*
+	 * a patch could have been loaded early, set uci->mc so that
+	 * mc_bp_resume() can call apply_microcode()
+	 */
+	p = find_patch(cpu);
+	if (p && (p->patch_id == csig->rev))
+		uci->mc = p->data;
+
 	pr_info("CPU%d: patch_level=0x%08x\n", cpu, csig->rev);
 
 	return 0;
@@ -215,7 +179,21 @@ static unsigned int verify_patch_size(int cpu, u32 patch_size,
 	return patch_size;
 }
 
-static int apply_microcode_amd(int cpu)
+int __apply_microcode_amd(struct microcode_amd *mc_amd)
+{
+	u32 rev, dummy;
+
+	wrmsrl(MSR_AMD64_PATCH_LOADER, (u64)(long)&mc_amd->hdr.data_code);
+
+	/* verify patch application was successful */
+	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
+	if (rev != mc_amd->hdr.patch_id)
+		return -1;
+
+	return 0;
+}
+
+int apply_microcode_amd(int cpu)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct microcode_amd *mc_amd;
@@ -242,19 +220,15 @@ static int apply_microcode_amd(int cpu)
 		return 0;
 	}
 
-	wrmsrl(MSR_AMD64_PATCH_LOADER, (u64)(long)&mc_amd->hdr.data_code);
-
-	/* verify patch application was successful */
-	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
-	if (rev != mc_amd->hdr.patch_id) {
+	if (__apply_microcode_amd(mc_amd))
 		pr_err("CPU%d: update failed for patch_level=0x%08x\n",
-		       cpu, mc_amd->hdr.patch_id);
-		return -1;
-	}
+			cpu, mc_amd->hdr.patch_id);
+	else
+		pr_info("CPU%d: new patch_level=0x%08x\n", cpu,
+			mc_amd->hdr.patch_id);
 
-	pr_info("CPU%d: new patch_level=0x%08x\n", cpu, rev);
-	uci->cpu_sig.rev = rev;
-	c->microcode = rev;
+	uci->cpu_sig.rev = mc_amd->hdr.patch_id;
+	c->microcode = mc_amd->hdr.patch_id;
 
 	return 0;
 }
@@ -364,7 +338,7 @@ static int verify_and_add_patch(unsigned int cpu, u8 *fw, unsigned int leftover)
 	return crnt_size;
 }
 
-static enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size)
+static enum ucode_state __load_microcode_amd(int cpu, const u8 *data, size_t size)
 {
 	enum ucode_state ret = UCODE_ERROR;
 	unsigned int leftover;
@@ -398,6 +372,32 @@ static enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size)
 	return UCODE_OK;
 }
 
+enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size)
+{
+	enum ucode_state ret;
+
+	/* free old equiv table */
+	free_equiv_cpu_table();
+
+	ret = __load_microcode_amd(cpu, data, size);
+
+	if (ret != UCODE_OK)
+		cleanup();
+
+#if defined(CONFIG_MICROCODE_AMD_EARLY) && defined(CONFIG_X86_32)
+	/* save BSP's matching patch for early load */
+	if (cpu_data(cpu).cpu_index == boot_cpu_data.cpu_index) {
+		struct ucode_patch *p = find_patch(cpu);
+		if (p) {
+			memset(amd_bsp_mpb, 0, MPB_MAX_SIZE);
+			memcpy(amd_bsp_mpb, p->data, min_t(u32, ksize(p->data),
+							   MPB_MAX_SIZE));
+		}
+	}
+#endif
+	return ret;
+}
+
 /*
  * AMD microcode firmware naming convention, up to family 15h they are in
  * the legacy file:
@@ -440,12 +440,7 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
 		goto fw_release;
 	}
 
-	/* free old equiv table */
-	free_equiv_cpu_table();
-
 	ret = load_microcode_amd(cpu, fw->data, fw->size);
-	if (ret != UCODE_OK)
-		cleanup();
 
  fw_release:
 	release_firmware(fw);
diff --git a/arch/x86/kernel/microcode_amd_early.c b/arch/x86/kernel/microcode_amd_early.c
new file mode 100644
index 0000000..1ac6e9a
--- /dev/null
+++ b/arch/x86/kernel/microcode_amd_early.c
@@ -0,0 +1,302 @@
+/*
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * Author: Jacob Shin <jacob.shin@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/earlycpio.h>
+#include <linux/initrd.h>
+
+#include <asm/cpu.h>
+#include <asm/setup.h>
+#include <asm/microcode_amd.h>
+
+static bool ucode_loaded;
+static u32 ucode_new_rev;
+static unsigned long ucode_offset;
+static size_t ucode_size;
+
+/*
+ * Microcode patch container file is prepended to the initrd in cpio format.
+ * See Documentation/x86/early-microcode.txt
+ */
+static __initdata char ucode_path[] = "kernel/x86/microcode/AuthenticAMD.bin";
+
+static struct cpio_data __init find_ucode_in_initrd(void)
+{
+	long offset = 0;
+	char *path;
+	void *start;
+	size_t size;
+	unsigned long *uoffset;
+	size_t *usize;
+	struct cpio_data cd;
+
+#ifdef CONFIG_X86_32
+	struct boot_params *p;
+
+	/*
+	 * On 32-bit, early load occurs before paging is turned on so we need
+	 * to use physical addresses.
+	 */
+	p       = (struct boot_params *)__pa_nodebug(&boot_params);
+	path    = (char *)__pa_nodebug(ucode_path);
+	start   = (void *)p->hdr.ramdisk_image;
+	size    = p->hdr.ramdisk_size;
+	uoffset = (unsigned long *)__pa_nodebug(&ucode_offset);
+	usize   = (size_t *)__pa_nodebug(&ucode_size);
+#else
+	path    = ucode_path;
+	start   = (void *)(boot_params.hdr.ramdisk_image + PAGE_OFFSET);
+	size    = boot_params.hdr.ramdisk_size;
+	uoffset = &ucode_offset;
+	usize   = &ucode_size;
+#endif
+
+	cd = find_cpio_data(path, start, size, &offset);
+	if (!cd.data)
+		return cd;
+
+	if (*(u32 *)cd.data != UCODE_MAGIC) {
+		cd.data = NULL;
+		cd.size = 0;
+		return cd;
+	}
+
+	*uoffset = (u8 *)cd.data - (u8 *)start;
+	*usize   = cd.size;
+
+	return cd;
+}
+
+/*
+ * Early load occurs before we can vmalloc(). So we look for the microcode
+ * patch container file in initrd, traverse equivalent cpu table, look for a
+ * matching microcode patch, and update, all in initrd memory in place.
+ * When vmalloc() is available for use later -- on 64-bit during first AP load,
+ * and on 32-bit during save_microcode_in_initrd_amd() -- we can call
+ * load_microcode_amd() to save equivalent cpu table and microcode patches in
+ * kernel heap memory.
+ */
+static void __cpuinit apply_ucode_in_initrd(void *ucode, size_t size)
+{
+	struct equiv_cpu_entry *eq;
+	u32 *header;
+	u8  *data;
+	u16 eq_id = 0;
+	int offset, left;
+	u32 rev, eax;
+	u32 *new_rev;
+	unsigned long *uoffset;
+	size_t *usize;
+
+#ifdef CONFIG_X86_32
+	new_rev = (u32 *)__pa_nodebug(&ucode_new_rev);
+	uoffset = (unsigned long *)__pa_nodebug(&ucode_offset);
+	usize   = (size_t *)__pa_nodebug(&ucode_size);
+#else
+	new_rev = &ucode_new_rev;
+	uoffset = &ucode_offset;
+	usize   = &ucode_size;
+#endif
+
+	data   = ucode;
+	left   = size;
+	header = (u32 *)data;
+
+	/* find equiv cpu table */
+
+	if (header[1] != UCODE_EQUIV_CPU_TABLE_TYPE || /* type */
+	    header[2] == 0)                            /* size */
+		return;
+
+	eax = cpuid_eax(0x00000001);
+
+	while (left > 0) {
+		eq = (struct equiv_cpu_entry *)(data + CONTAINER_HDR_SZ);
+
+		offset = header[2] + CONTAINER_HDR_SZ;
+		data  += offset;
+		left  -= offset;
+
+		eq_id = find_equiv_id(eq, eax);
+		if (eq_id)
+			break;
+
+		/*
+		 * support multiple container files appended together. if this
+		 * one does not have a matching equivalent cpu entry, we fast
+		 * forward to the next container file.
+		 */
+		while (left > 0) {
+			header = (u32 *)data;
+			if (header[0] == UCODE_MAGIC &&
+			    header[1] == UCODE_EQUIV_CPU_TABLE_TYPE)
+				break;
+
+			offset = header[1] + SECTION_HDR_SIZE;
+			data  += offset;
+			left  -= offset;
+		}
+
+		/* mark where the next microcode container file starts */
+		offset    = data - (u8 *)ucode;
+		*uoffset += offset;
+		*usize   -= offset;
+		ucode     = data;
+	}
+
+	if (!eq_id) {
+		*usize = 0;
+		return;
+	}
+
+	/* find ucode and update if needed */
+
+	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, eax);
+
+	while (left > 0) {
+		struct microcode_amd *mc;
+
+		header = (u32 *)data;
+		if (header[0] != UCODE_UCODE_TYPE || /* type */
+		    header[1] == 0)                  /* size */
+			break;
+
+		mc = (struct microcode_amd *)(data + SECTION_HDR_SIZE);
+		if (eq_id == mc->hdr.processor_rev_id && rev < mc->hdr.patch_id)
+			if (__apply_microcode_amd(mc) == 0) {
+				rev = mc->hdr.patch_id;
+				*new_rev = rev;
+			}
+
+		offset  = header[1] + SECTION_HDR_SIZE;
+		data   += offset;
+		left   -= offset;
+	}
+
+	/* mark where this microcode container file ends */
+	offset  = *usize - (data - (u8 *)ucode);
+	*usize -= offset;
+
+	if (!(*new_rev))
+		*usize = 0;
+}
+
+void __init load_ucode_amd_bsp(void)
+{
+	struct cpio_data cd = find_ucode_in_initrd();
+	if (!cd.data)
+		return;
+
+	apply_ucode_in_initrd(cd.data, cd.size);
+}
+
+#ifdef CONFIG_X86_32
+u8 amd_bsp_mpb[MPB_MAX_SIZE];
+
+/*
+ * On 32-bit, since AP's early load occurs before paging is turned on, we
+ * cannot traverse cpu_equiv_table and pcache in kernel heap memory. So during
+ * cold boot, AP will apply_ucode_in_initrd() just like the BSP. During
+ * save_microcode_in_initrd_amd() BSP's patch is copied to amd_bsp_mpb, which
+ * is used upon resume from suspend.
+ */
+void __cpuinit load_ucode_amd_ap(void)
+{
+	struct microcode_amd *mc;
+	unsigned long *initrd;
+	unsigned long *uoffset;
+	size_t *usize;
+	void *ucode;
+
+	mc = (struct microcode_amd *)__pa(amd_bsp_mpb);
+	if (mc->hdr.patch_id && mc->hdr.processor_rev_id) {
+		__apply_microcode_amd(mc);
+		return;
+	}
+
+	initrd  = (unsigned long *)__pa(&initrd_start);
+	uoffset = (unsigned long *)__pa(&ucode_offset);
+	usize   = (size_t *)__pa(&ucode_size);
+
+	if (!*usize || !*initrd)
+		return;
+
+	ucode = (void *)((unsigned long)__pa(*initrd) + *uoffset);
+	apply_ucode_in_initrd(ucode, *usize);
+}
+
+static void __init collect_cpu_sig_on_bsp(void *arg)
+{
+	unsigned int cpu = smp_processor_id();
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	uci->cpu_sig.sig = cpuid_eax(0x00000001);
+}
+#else
+static void __cpuinit collect_cpu_info_amd_early(struct cpuinfo_x86 *c,
+						 struct ucode_cpu_info *uci)
+{
+	u32 rev, eax;
+
+	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, eax);
+	eax = cpuid_eax(0x00000001);
+
+	uci->cpu_sig.sig = eax;
+	uci->cpu_sig.rev = rev;
+	c->microcode = rev;
+	c->x86 = ((eax >> 8) & 0xf) + ((eax >> 20) & 0xff);
+}
+
+void __cpuinit load_ucode_amd_ap(void)
+{
+	unsigned int cpu = smp_processor_id();
+
+	collect_cpu_info_amd_early(&cpu_data(cpu), ucode_cpu_info + cpu);
+
+	if (cpu && !ucode_loaded) {
+		void *ucode;
+
+		if (!ucode_size || !initrd_start)
+			return;
+
+		ucode = (void *)(initrd_start + ucode_offset);
+		if (load_microcode_amd(0, ucode, ucode_size) != UCODE_OK)
+			return;
+		ucode_loaded = true;
+	}
+
+	apply_microcode_amd(cpu);
+}
+#endif
+
+int __init save_microcode_in_initrd_amd(void)
+{
+	enum ucode_state ret;
+	void *ucode;
+#ifdef CONFIG_X86_32
+	unsigned int bsp = boot_cpu_data.cpu_index;
+	struct ucode_cpu_info *uci = ucode_cpu_info + bsp;
+
+	if (!uci->cpu_sig.sig)
+		smp_call_function_single(bsp, collect_cpu_sig_on_bsp, NULL, 1);
+#endif
+	if (ucode_new_rev)
+		pr_info("microcode: updated early to new patch_level=0x%08x\n",
+			ucode_new_rev);
+
+	if (ucode_loaded || !ucode_size || !initrd_start)
+		return 0;
+
+	ucode = (void *)(initrd_start + ucode_offset);
+	ret = load_microcode_amd(0, ucode, ucode_size);
+	if (ret != UCODE_OK)
+		return -EINVAL;
+
+	ucode_loaded = true;
+	return 0;
+}
diff --git a/arch/x86/kernel/microcode_core_early.c b/arch/x86/kernel/microcode_core_early.c
index 833d51d..86119f6 100644
--- a/arch/x86/kernel/microcode_core_early.c
+++ b/arch/x86/kernel/microcode_core_early.c
@@ -18,6 +18,7 @@
  */
 #include <linux/module.h>
 #include <asm/microcode_intel.h>
+#include <asm/microcode_amd.h>
 #include <asm/processor.h>
 
 #define QCHAR(a, b, c, d) ((a) + ((b) << 8) + ((c) << 16) + ((d) << 24))
@@ -81,8 +82,18 @@ void __init load_ucode_bsp(void)
 	vendor = x86_vendor();
 	x86 = x86_family();
 
-	if (vendor == X86_VENDOR_INTEL && x86 >= 6)
-		load_ucode_intel_bsp();
+	switch (vendor) {
+	case X86_VENDOR_INTEL:
+		if (x86 >= 6)
+			load_ucode_intel_bsp();
+		break;
+	case X86_VENDOR_AMD:
+		if (x86 >= 0x10)
+			load_ucode_amd_bsp();
+		break;
+	default:
+		break;
+	}
 }
 
 void __cpuinit load_ucode_ap(void)
@@ -95,6 +106,36 @@ void __cpuinit load_ucode_ap(void)
 	vendor = x86_vendor();
 	x86 = x86_family();
 
-	if (vendor == X86_VENDOR_INTEL && x86 >= 6)
-		load_ucode_intel_ap();
+	switch (vendor) {
+	case X86_VENDOR_INTEL:
+		if (x86 >= 6)
+			load_ucode_intel_ap();
+		break;
+	case X86_VENDOR_AMD:
+		if (x86 >= 0x10)
+			load_ucode_amd_ap();
+		break;
+	default:
+		break;
+	}
+}
+
+int __init save_microcode_in_initrd(void)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
+	switch (c->x86_vendor) {
+	case X86_VENDOR_INTEL:
+		if (c->x86 >= 6)
+			save_microcode_in_initrd_intel();
+		break;
+	case X86_VENDOR_AMD:
+		if (c->x86 >= 0x10)
+			save_microcode_in_initrd_amd();
+		break;
+	default:
+		break;
+	}
+
+	return 0;
 }
diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
index 2e9e128..dabef95 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/microcode_intel_early.c
@@ -529,7 +529,7 @@ int save_mc_for_early(u8 *mc)
 	 */
 	ret = save_microcode(&mc_saved_data, mc_saved_tmp, mc_saved_count);
 	if (ret) {
-		pr_err("Can not save microcode patch.\n");
+		pr_err("Cannot save microcode patch.\n");
 		goto out;
 	}
 
@@ -699,7 +699,7 @@ static int __cpuinit apply_microcode_early(struct mc_saved_data *mc_saved_data,
  * This function converts microcode patch offsets previously stored in
  * mc_saved_in_initrd to pointers and stores the pointers in mc_saved_data.
  */
-int __init save_microcode_in_initrd(void)
+int __init save_microcode_in_initrd_intel(void)
 {
 	unsigned int count = mc_saved_data.mc_saved_count;
 	struct microcode_intel *mc_saved[MAX_UCODE_COUNT];
@@ -711,7 +711,7 @@ int __init save_microcode_in_initrd(void)
 	microcode_pointer(mc_saved, mc_saved_in_initrd, initrd_start, count);
 	ret = save_microcode(&mc_saved_data, mc_saved, count);
 	if (ret)
-		pr_err("Can not save microcod patches from initrd");
+		pr_err("Cannot save microcode patches from initrd.\n");
 
 	show_saved_mc();
 
