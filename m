Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaATOyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:54:18 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:63592 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaATOyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:54:15 -0500
Date: Mon, 20 Jan 2014 15:54:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/microcode changes for v3.14
Message-ID: <20140120145411.GA14995@gmail.com>
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

   # HEAD: 9c079129d7bfb24251890e40694fd79dd1872ed9 Merge tag 'amd_ucode_for_3.14' of git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp into x86/microcode

There are two main changes in this tree:

     - AMD microcode early loading fixes
     - Some microcode loader source files reorganization

 Thanks,

	Ingo

------------------>
Borislav Petkov (4):
      x86, ramdisk: Export relocated ramdisk VA
      x86, microcode: Share native MSR accessing variants
      x86, microcode, AMD: Fix early ucode loading
      x86, microcode: Move to a proper location


 arch/x86/Kconfig                                   |   4 -
 arch/x86/include/asm/microcode.h                   |  15 ++
 arch/x86/include/asm/microcode_amd.h               |   7 +-
 arch/x86/include/asm/setup.h                       |   3 +-
 arch/x86/kernel/Makefile                           |   9 -
 arch/x86/kernel/cpu/Makefile                       |   1 +
 arch/x86/kernel/cpu/microcode/Makefile             |   7 +
 .../{microcode_amd.c => cpu/microcode/amd.c}       |  13 +-
 .../microcode/amd_early.c}                         | 239 ++++++++++++++-------
 .../{microcode_core.c => cpu/microcode/core.c}     |   0
 .../microcode/core_early.c}                        |   0
 .../{microcode_intel.c => cpu/microcode/intel.c}   |   0
 .../microcode/intel_early.c}                       |  10 -
 .../microcode/intel_lib.c}                         |   0
 arch/x86/kernel/setup.c                            |  19 +-
 15 files changed, 205 insertions(+), 122 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/microcode/Makefile
 rename arch/x86/kernel/{microcode_amd.c => cpu/microcode/amd.c} (96%)
 rename arch/x86/kernel/{microcode_amd_early.c => cpu/microcode/amd_early.c} (55%)
 rename arch/x86/kernel/{microcode_core.c => cpu/microcode/core.c} (100%)
 rename arch/x86/kernel/{microcode_core_early.c => cpu/microcode/core_early.c} (100%)
 rename arch/x86/kernel/{microcode_intel.c => cpu/microcode/intel.c} (100%)
 rename arch/x86/kernel/{microcode_intel_early.c => cpu/microcode/intel_early.c} (98%)
 rename arch/x86/kernel/{microcode_intel_lib.c => cpu/microcode/intel_lib.c} (100%)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0952ecd..01bfb9e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1080,10 +1080,6 @@ config MICROCODE_OLD_INTERFACE
 	def_bool y
 	depends on MICROCODE
 
-config MICROCODE_INTEL_LIB
-	def_bool y
-	depends on MICROCODE_INTEL
-
 config MICROCODE_INTEL_EARLY
 	def_bool n
 
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index f98bd66..b59827e 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -1,6 +1,21 @@
 #ifndef _ASM_X86_MICROCODE_H
 #define _ASM_X86_MICROCODE_H
 
+#define native_rdmsr(msr, val1, val2)			\
+do {							\
+	u64 __val = native_read_msr((msr));		\
+	(void)((val1) = (u32)__val);			\
+	(void)((val2) = (u32)(__val >> 32));		\
+} while (0)
+
+#define native_wrmsr(msr, low, high)			\
+	native_write_msr(msr, low, high)
+
+#define native_wrmsrl(msr, val)				\
+	native_write_msr((msr),				\
+			 (u32)((u64)(val)),		\
+			 (u32)((u64)(val) >> 32))
+
 struct cpu_signature {
 	unsigned int sig;
 	unsigned int pf;
diff --git a/arch/x86/include/asm/microcode_amd.h b/arch/x86/include/asm/microcode_amd.h
index 4c01917..b7b10b8 100644
--- a/arch/x86/include/asm/microcode_amd.h
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -61,11 +61,10 @@ extern int __apply_microcode_amd(struct microcode_amd *mc_amd);
 extern int apply_microcode_amd(int cpu);
 extern enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size);
 
+#define PATCH_MAX_SIZE PAGE_SIZE
+extern u8 amd_ucode_patch[PATCH_MAX_SIZE];
+
 #ifdef CONFIG_MICROCODE_AMD_EARLY
-#ifdef CONFIG_X86_32
-#define MPB_MAX_SIZE PAGE_SIZE
-extern u8 amd_bsp_mpb[MPB_MAX_SIZE];
-#endif
 extern void __init load_ucode_amd_bsp(void);
 extern void load_ucode_amd_ap(void);
 extern int __init save_microcode_in_initrd_amd(void);
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 59bcf4e..d62c9f8 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -3,7 +3,6 @@
 
 #include <uapi/asm/setup.h>
 
-
 #define COMMAND_LINE_SIZE 2048
 
 #include <linux/linkage.h>
@@ -29,6 +28,8 @@
 #include <asm/bootparam.h>
 #include <asm/x86_init.h>
 
+extern u64 relocated_ramdisk;
+
 /* Interrupt control for vSMPowered x86_64 systems */
 #ifdef CONFIG_X86_64
 void vsmp_init(void);
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 9b0a34e..4d0094d 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -91,15 +91,6 @@ obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
 
 obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
 
-obj-$(CONFIG_MICROCODE_EARLY)		+= microcode_core_early.o
-obj-$(CONFIG_MICROCODE_INTEL_EARLY)	+= microcode_intel_early.o
-obj-$(CONFIG_MICROCODE_INTEL_LIB)	+= microcode_intel_lib.o
-microcode-y				:= microcode_core.o
-microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
-microcode-$(CONFIG_MICROCODE_AMD)	+= microcode_amd.o
-obj-$(CONFIG_MICROCODE_AMD_EARLY)	+= microcode_amd_early.o
-obj-$(CONFIG_MICROCODE)			+= microcode.o
-
 obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 47b56a7..0710eef 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -42,6 +42,7 @@ endif
 
 obj-$(CONFIG_X86_MCE)			+= mcheck/
 obj-$(CONFIG_MTRR)			+= mtrr/
+obj-$(CONFIG_MICROCODE)			+= microcode/
 
 obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o perf_event_amd_ibs.o
 
diff --git a/arch/x86/kernel/cpu/microcode/Makefile b/arch/x86/kernel/cpu/microcode/Makefile
new file mode 100644
index 0000000..285c854
--- /dev/null
+++ b/arch/x86/kernel/cpu/microcode/Makefile
@@ -0,0 +1,7 @@
+microcode-y				:= core.o
+obj-$(CONFIG_MICROCODE)			+= microcode.o
+microcode-$(CONFIG_MICROCODE_INTEL)	+= intel.o intel_lib.o
+microcode-$(CONFIG_MICROCODE_AMD)	+= amd.o
+obj-$(CONFIG_MICROCODE_EARLY)		+= core_early.o
+obj-$(CONFIG_MICROCODE_INTEL_EARLY)	+= intel_early.o
+obj-$(CONFIG_MICROCODE_AMD_EARLY)	+= amd_early.o
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/cpu/microcode/amd.c
similarity index 96%
rename from arch/x86/kernel/microcode_amd.c
rename to arch/x86/kernel/cpu/microcode/amd.c
index c3d4cc9..4a6ff74 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -182,10 +182,10 @@ int __apply_microcode_amd(struct microcode_amd *mc_amd)
 {
 	u32 rev, dummy;
 
-	wrmsrl(MSR_AMD64_PATCH_LOADER, (u64)(long)&mc_amd->hdr.data_code);
+	native_wrmsrl(MSR_AMD64_PATCH_LOADER, (u64)(long)&mc_amd->hdr.data_code);
 
 	/* verify patch application was successful */
-	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
+	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 	if (rev != mc_amd->hdr.patch_id)
 		return -1;
 
@@ -332,6 +332,9 @@ static int verify_and_add_patch(u8 family, u8 *fw, unsigned int leftover)
 	patch->patch_id  = mc_hdr->patch_id;
 	patch->equiv_cpu = proc_id;
 
+	pr_debug("%s: Added patch_id: 0x%08x, proc_id: 0x%04x\n",
+		 __func__, patch->patch_id, proc_id);
+
 	/* ... and add to cache. */
 	update_cache(patch);
 
@@ -390,9 +393,9 @@ enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size)
 	if (cpu_data(smp_processor_id()).cpu_index == boot_cpu_data.cpu_index) {
 		struct ucode_patch *p = find_patch(smp_processor_id());
 		if (p) {
-			memset(amd_bsp_mpb, 0, MPB_MAX_SIZE);
-			memcpy(amd_bsp_mpb, p->data, min_t(u32, ksize(p->data),
-							   MPB_MAX_SIZE));
+			memset(amd_ucode_patch, 0, PATCH_MAX_SIZE);
+			memcpy(amd_ucode_patch, p->data, min_t(u32, ksize(p->data),
+							       PATCH_MAX_SIZE));
 		}
 	}
 #endif
diff --git a/arch/x86/kernel/microcode_amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
similarity index 55%
rename from arch/x86/kernel/microcode_amd_early.c
rename to arch/x86/kernel/cpu/microcode/amd_early.c
index 6073104..8384c0f 100644
--- a/arch/x86/kernel/microcode_amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -2,6 +2,7 @@
  * Copyright (C) 2013 Advanced Micro Devices, Inc.
  *
  * Author: Jacob Shin <jacob.shin@amd.com>
+ * Fixes: Borislav Petkov <bp@suse.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -15,10 +16,18 @@
 #include <asm/setup.h>
 #include <asm/microcode_amd.h>
 
-static bool ucode_loaded;
+/*
+ * This points to the current valid container of microcode patches which we will
+ * save from the initrd before jettisoning its contents.
+ */
+static u8 *container;
+static size_t container_size;
+
 static u32 ucode_new_rev;
-static unsigned long ucode_offset;
-static size_t ucode_size;
+u8 amd_ucode_patch[PATCH_MAX_SIZE];
+static u16 this_equiv_id;
+
+struct cpio_data ucode_cpio;
 
 /*
  * Microcode patch container file is prepended to the initrd in cpio format.
@@ -32,9 +41,6 @@ static struct cpio_data __init find_ucode_in_initrd(void)
 	char *path;
 	void *start;
 	size_t size;
-	unsigned long *uoffset;
-	size_t *usize;
-	struct cpio_data cd;
 
 #ifdef CONFIG_X86_32
 	struct boot_params *p;
@@ -47,30 +53,50 @@ static struct cpio_data __init find_ucode_in_initrd(void)
 	path    = (char *)__pa_nodebug(ucode_path);
 	start   = (void *)p->hdr.ramdisk_image;
 	size    = p->hdr.ramdisk_size;
-	uoffset = (unsigned long *)__pa_nodebug(&ucode_offset);
-	usize   = (size_t *)__pa_nodebug(&ucode_size);
 #else
 	path    = ucode_path;
 	start   = (void *)(boot_params.hdr.ramdisk_image + PAGE_OFFSET);
 	size    = boot_params.hdr.ramdisk_size;
-	uoffset = &ucode_offset;
-	usize   = &ucode_size;
 #endif
 
-	cd = find_cpio_data(path, start, size, &offset);
-	if (!cd.data)
-		return cd;
+	return find_cpio_data(path, start, size, &offset);
+}
 
-	if (*(u32 *)cd.data != UCODE_MAGIC) {
-		cd.data = NULL;
-		cd.size = 0;
-		return cd;
-	}
+static size_t compute_container_size(u8 *data, u32 total_size)
+{
+	size_t size = 0;
+	u32 *header = (u32 *)data;
 
-	*uoffset = (u8 *)cd.data - (u8 *)start;
-	*usize   = cd.size;
+	if (header[0] != UCODE_MAGIC ||
+	    header[1] != UCODE_EQUIV_CPU_TABLE_TYPE || /* type */
+	    header[2] == 0)                            /* size */
+		return size;
 
-	return cd;
+	size = header[2] + CONTAINER_HDR_SZ;
+	total_size -= size;
+	data += size;
+
+	while (total_size) {
+		u16 patch_size;
+
+		header = (u32 *)data;
+
+		if (header[0] != UCODE_UCODE_TYPE)
+			break;
+
+		/*
+		 * Sanity-check patch size.
+		 */
+		patch_size = header[1];
+		if (patch_size > PATCH_MAX_SIZE)
+			break;
+
+		size	   += patch_size + SECTION_HDR_SIZE;
+		data	   += patch_size + SECTION_HDR_SIZE;
+		total_size -= patch_size + SECTION_HDR_SIZE;
+	}
+
+	return size;
 }
 
 /*
@@ -85,23 +111,22 @@ static struct cpio_data __init find_ucode_in_initrd(void)
 static void apply_ucode_in_initrd(void *ucode, size_t size)
 {
 	struct equiv_cpu_entry *eq;
+	size_t *cont_sz;
 	u32 *header;
-	u8  *data;
+	u8  *data, **cont;
 	u16 eq_id = 0;
 	int offset, left;
-	u32 rev, eax;
+	u32 rev, eax, ebx, ecx, edx;
 	u32 *new_rev;
-	unsigned long *uoffset;
-	size_t *usize;
 
 #ifdef CONFIG_X86_32
 	new_rev = (u32 *)__pa_nodebug(&ucode_new_rev);
-	uoffset = (unsigned long *)__pa_nodebug(&ucode_offset);
-	usize   = (size_t *)__pa_nodebug(&ucode_size);
+	cont_sz = (size_t *)__pa_nodebug(&container_size);
+	cont	= (u8 **)__pa_nodebug(&container);
 #else
 	new_rev = &ucode_new_rev;
-	uoffset = &ucode_offset;
-	usize   = &ucode_size;
+	cont_sz = &container_size;
+	cont	= &container;
 #endif
 
 	data   = ucode;
@@ -109,23 +134,37 @@ static void apply_ucode_in_initrd(void *ucode, size_t size)
 	header = (u32 *)data;
 
 	/* find equiv cpu table */
-
-	if (header[1] != UCODE_EQUIV_CPU_TABLE_TYPE || /* type */
+	if (header[0] != UCODE_MAGIC ||
+	    header[1] != UCODE_EQUIV_CPU_TABLE_TYPE || /* type */
 	    header[2] == 0)                            /* size */
 		return;
 
-	eax = cpuid_eax(0x00000001);
+	eax = 0x00000001;
+	ecx = 0;
+	native_cpuid(&eax, &ebx, &ecx, &edx);
 
 	while (left > 0) {
 		eq = (struct equiv_cpu_entry *)(data + CONTAINER_HDR_SZ);
 
+		*cont = data;
+
+		/* Advance past the container header */
 		offset = header[2] + CONTAINER_HDR_SZ;
 		data  += offset;
 		left  -= offset;
 
 		eq_id = find_equiv_id(eq, eax);
-		if (eq_id)
+		if (eq_id) {
+			this_equiv_id = eq_id;
+			*cont_sz = compute_container_size(*cont, left + offset);
+
+			/*
+			 * truncate how much we need to iterate over in the
+			 * ucode update loop below
+			 */
+			left = *cont_sz - offset;
 			break;
+		}
 
 		/*
 		 * support multiple container files appended together. if this
@@ -145,19 +184,18 @@ static void apply_ucode_in_initrd(void *ucode, size_t size)
 
 		/* mark where the next microcode container file starts */
 		offset    = data - (u8 *)ucode;
-		*uoffset += offset;
-		*usize   -= offset;
 		ucode     = data;
 	}
 
 	if (!eq_id) {
-		*usize = 0;
+		*cont = NULL;
+		*cont_sz = 0;
 		return;
 	}
 
 	/* find ucode and update if needed */
 
-	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, eax);
+	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, eax);
 
 	while (left > 0) {
 		struct microcode_amd *mc;
@@ -168,73 +206,83 @@ static void apply_ucode_in_initrd(void *ucode, size_t size)
 			break;
 
 		mc = (struct microcode_amd *)(data + SECTION_HDR_SIZE);
-		if (eq_id == mc->hdr.processor_rev_id && rev < mc->hdr.patch_id)
-			if (__apply_microcode_amd(mc) == 0) {
+
+		if (eq_id == mc->hdr.processor_rev_id && rev < mc->hdr.patch_id) {
+
+			if (!__apply_microcode_amd(mc)) {
 				rev = mc->hdr.patch_id;
 				*new_rev = rev;
+
+				/* save ucode patch */
+				memcpy(amd_ucode_patch, mc,
+				       min_t(u32, header[1], PATCH_MAX_SIZE));
 			}
+		}
 
 		offset  = header[1] + SECTION_HDR_SIZE;
 		data   += offset;
 		left   -= offset;
 	}
-
-	/* mark where this microcode container file ends */
-	offset  = *usize - (data - (u8 *)ucode);
-	*usize -= offset;
-
-	if (!(*new_rev))
-		*usize = 0;
 }
 
 void __init load_ucode_amd_bsp(void)
 {
-	struct cpio_data cd = find_ucode_in_initrd();
-	if (!cd.data)
+	struct cpio_data cp;
+	void **data;
+	size_t *size;
+
+#ifdef CONFIG_X86_32
+	data =  (void **)__pa_nodebug(&ucode_cpio.data);
+	size = (size_t *)__pa_nodebug(&ucode_cpio.size);
+#else
+	data = &ucode_cpio.data;
+	size = &ucode_cpio.size;
+#endif
+
+	cp = find_ucode_in_initrd();
+	if (!cp.data)
 		return;
 
-	apply_ucode_in_initrd(cd.data, cd.size);
+	*data = cp.data;
+	*size = cp.size;
+
+	apply_ucode_in_initrd(cp.data, cp.size);
 }
 
 #ifdef CONFIG_X86_32
-u8 amd_bsp_mpb[MPB_MAX_SIZE];
-
 /*
  * On 32-bit, since AP's early load occurs before paging is turned on, we
  * cannot traverse cpu_equiv_table and pcache in kernel heap memory. So during
  * cold boot, AP will apply_ucode_in_initrd() just like the BSP. During
- * save_microcode_in_initrd_amd() BSP's patch is copied to amd_bsp_mpb, which
- * is used upon resume from suspend.
+ * save_microcode_in_initrd_amd() BSP's patch is copied to amd_ucode_patch,
+ * which is used upon resume from suspend.
  */
 void load_ucode_amd_ap(void)
 {
 	struct microcode_amd *mc;
-	unsigned long *initrd;
-	unsigned long *uoffset;
 	size_t *usize;
-	void *ucode;
+	void **ucode;
 
-	mc = (struct microcode_amd *)__pa(amd_bsp_mpb);
+	mc = (struct microcode_amd *)__pa(amd_ucode_patch);
 	if (mc->hdr.patch_id && mc->hdr.processor_rev_id) {
 		__apply_microcode_amd(mc);
 		return;
 	}
 
-	initrd  = (unsigned long *)__pa(&initrd_start);
-	uoffset = (unsigned long *)__pa(&ucode_offset);
-	usize   = (size_t *)__pa(&ucode_size);
+	ucode = (void *)__pa_nodebug(&container);
+	usize = (size_t *)__pa_nodebug(&container_size);
 
-	if (!*usize || !*initrd)
+	if (!*ucode || !*usize)
 		return;
 
-	ucode = (void *)((unsigned long)__pa(*initrd) + *uoffset);
-	apply_ucode_in_initrd(ucode, *usize);
+	apply_ucode_in_initrd(*ucode, *usize);
 }
 
 static void __init collect_cpu_sig_on_bsp(void *arg)
 {
 	unsigned int cpu = smp_processor_id();
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+
 	uci->cpu_sig.sig = cpuid_eax(0x00000001);
 }
 #else
@@ -242,36 +290,54 @@ void load_ucode_amd_ap(void)
 {
 	unsigned int cpu = smp_processor_id();
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct equiv_cpu_entry *eq;
+	struct microcode_amd *mc;
 	u32 rev, eax;
+	u16 eq_id;
+
+	/* Exit if called on the BSP. */
+	if (!cpu)
+		return;
+
+	if (!container)
+		return;
 
 	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, eax);
-	eax = cpuid_eax(0x00000001);
 
 	uci->cpu_sig.rev = rev;
 	uci->cpu_sig.sig = eax;
 
-	if (cpu && !ucode_loaded) {
-		void *ucode;
+	eax = cpuid_eax(0x00000001);
+	eq  = (struct equiv_cpu_entry *)(container + CONTAINER_HDR_SZ);
 
-		if (!ucode_size || !initrd_start)
-			return;
+	eq_id = find_equiv_id(eq, eax);
+	if (!eq_id)
+		return;
+
+	if (eq_id == this_equiv_id) {
+		mc = (struct microcode_amd *)amd_ucode_patch;
 
-		ucode = (void *)(initrd_start + ucode_offset);
-		eax   = ((eax >> 8) & 0xf) + ((eax >> 20) & 0xff);
-		if (load_microcode_amd(eax, ucode, ucode_size) != UCODE_OK)
+		if (mc && rev < mc->hdr.patch_id) {
+			if (!__apply_microcode_amd(mc))
+				ucode_new_rev = mc->hdr.patch_id;
+		}
+
+	} else {
+		if (!ucode_cpio.data)
 			return;
 
-		ucode_loaded = true;
+		/*
+		 * AP has a different equivalence ID than BSP, looks like
+		 * mixed-steppings silicon so go through the ucode blob anew.
+		 */
+		apply_ucode_in_initrd(ucode_cpio.data, ucode_cpio.size);
 	}
-
-	apply_microcode_amd(cpu);
 }
 #endif
 
 int __init save_microcode_in_initrd_amd(void)
 {
 	enum ucode_state ret;
-	void *ucode;
 	u32 eax;
 
 #ifdef CONFIG_X86_32
@@ -280,22 +346,35 @@ int __init save_microcode_in_initrd_amd(void)
 
 	if (!uci->cpu_sig.sig)
 		smp_call_function_single(bsp, collect_cpu_sig_on_bsp, NULL, 1);
+
+	/*
+	 * Take into account the fact that the ramdisk might get relocated
+	 * and therefore we need to recompute the container's position in
+	 * virtual memory space.
+	 */
+	container = (u8 *)(__va((u32)relocated_ramdisk) +
+			   ((u32)container - boot_params.hdr.ramdisk_image));
 #endif
 	if (ucode_new_rev)
 		pr_info("microcode: updated early to new patch_level=0x%08x\n",
 			ucode_new_rev);
 
-	if (ucode_loaded || !ucode_size || !initrd_start)
-		return 0;
+	if (!container)
+		return -EINVAL;
 
-	ucode = (void *)(initrd_start + ucode_offset);
 	eax   = cpuid_eax(0x00000001);
 	eax   = ((eax >> 8) & 0xf) + ((eax >> 20) & 0xff);
 
-	ret = load_microcode_amd(eax, ucode, ucode_size);
+	ret = load_microcode_amd(eax, container, container_size);
 	if (ret != UCODE_OK)
 		return -EINVAL;
 
-	ucode_loaded = true;
+	/*
+	 * This will be freed any msec now, stash patches for the current
+	 * family and switch to patch cache for cpu hotplug, etc later.
+	 */
+	container = NULL;
+	container_size = 0;
+
 	return 0;
 }
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/cpu/microcode/core.c
similarity index 100%
rename from arch/x86/kernel/microcode_core.c
rename to arch/x86/kernel/cpu/microcode/core.c
diff --git a/arch/x86/kernel/microcode_core_early.c b/arch/x86/kernel/cpu/microcode/core_early.c
similarity index 100%
rename from arch/x86/kernel/microcode_core_early.c
rename to arch/x86/kernel/cpu/microcode/core_early.c
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/cpu/microcode/intel.c
similarity index 100%
rename from arch/x86/kernel/microcode_intel.c
rename to arch/x86/kernel/cpu/microcode/intel.c
diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
similarity index 98%
rename from arch/x86/kernel/microcode_intel_early.c
rename to arch/x86/kernel/cpu/microcode/intel_early.c
index 1575deb..18f7391 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -365,16 +365,6 @@ out:
 	return state;
 }
 
-#define native_rdmsr(msr, val1, val2)		\
-do {						\
-	u64 __val = native_read_msr((msr));	\
-	(void)((val1) = (u32)__val);		\
-	(void)((val2) = (u32)(__val >> 32));	\
-} while (0)
-
-#define native_wrmsr(msr, low, high)		\
-	native_write_msr(msr, low, high);
-
 static int collect_cpu_info_early(struct ucode_cpu_info *uci)
 {
 	unsigned int val[2];
diff --git a/arch/x86/kernel/microcode_intel_lib.c b/arch/x86/kernel/cpu/microcode/intel_lib.c
similarity index 100%
rename from arch/x86/kernel/microcode_intel_lib.c
rename to arch/x86/kernel/cpu/microcode/intel_lib.c
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cb233bc..baefc6d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -295,6 +295,8 @@ static void __init reserve_brk(void)
 	_brk_start = 0;
 }
 
+u64 relocated_ramdisk;
+
 #ifdef CONFIG_BLK_DEV_INITRD
 
 static u64 __init get_ramdisk_image(void)
@@ -321,25 +323,24 @@ static void __init relocate_initrd(void)
 	u64 ramdisk_image = get_ramdisk_image();
 	u64 ramdisk_size  = get_ramdisk_size();
 	u64 area_size     = PAGE_ALIGN(ramdisk_size);
-	u64 ramdisk_here;
 	unsigned long slop, clen, mapaddr;
 	char *p, *q;
 
 	/* We need to move the initrd down into directly mapped mem */
-	ramdisk_here = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
-						 area_size, PAGE_SIZE);
+	relocated_ramdisk = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
+						   area_size, PAGE_SIZE);
 
-	if (!ramdisk_here)
+	if (!relocated_ramdisk)
 		panic("Cannot find place for new RAMDISK of size %lld\n",
-			 ramdisk_size);
+		      ramdisk_size);
 
 	/* Note: this includes all the mem currently occupied by
 	   the initrd, we rely on that fact to keep the data intact. */
-	memblock_reserve(ramdisk_here, area_size);
-	initrd_start = ramdisk_here + PAGE_OFFSET;
+	memblock_reserve(relocated_ramdisk, area_size);
+	initrd_start = relocated_ramdisk + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
 	printk(KERN_INFO "Allocated new RAMDISK: [mem %#010llx-%#010llx]\n",
-			 ramdisk_here, ramdisk_here + ramdisk_size - 1);
+	       relocated_ramdisk, relocated_ramdisk + ramdisk_size - 1);
 
 	q = (char *)initrd_start;
 
@@ -363,7 +364,7 @@ static void __init relocate_initrd(void)
 	printk(KERN_INFO "Move RAMDISK from [mem %#010llx-%#010llx] to"
 		" [mem %#010llx-%#010llx]\n",
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
-		ramdisk_here, ramdisk_here + ramdisk_size - 1);
+		relocated_ramdisk, relocated_ramdisk + ramdisk_size - 1);
 }
 
 static void __init early_reserve_initrd(void)
