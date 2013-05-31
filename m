Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab3EaDb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 23:31:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53284 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab3EaDbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 23:31:21 -0400
Date: Thu, 30 May 2013 20:31:08 -0700
From: tip-bot for Jacob Shin <tipbot@zytor.com>
Message-ID: <tip-757885e94a22bcc82beb9b1445c95218cb20ceab@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, jacob.shin@amd.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, jacob.shin@amd.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1369940959-2077-5-git-send-email-jacob.shin@amd.com>
References: <1369940959-2077-5-git-send-email-jacob.shin@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode, amd:
  Early microcode patch loading support for AMD
Git-Commit-ID: 757885e94a22bcc82beb9b1445c95218cb20ceab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  757885e94a22bcc82beb9b1445c95218cb20ceab
Gitweb:     http://git.kernel.org/tip/757885e94a22bcc82beb9b1445c95218cb20ceab
Author:     Jacob Shin <jacob.shin@amd.com>
AuthorDate: Thu, 30 May 2013 14:09:19 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 30 May 2013 20:19:25 -0700

x86, microcode, amd: Early microcode patch loading support for AMD

Add early microcode patch loading support for AMD.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Link: http://lkml.kernel.org/r/1369940959-2077-5-git-send-email-jacob.shin@amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 Documentation/x86/early-microcode.txt  |  11 +-
 arch/x86/Kconfig                       |  14 ++-
 arch/x86/include/asm/microcode_amd.h   |  14 +++
 arch/x86/kernel/Makefile               |   1 +
 arch/x86/kernel/microcode_amd.c        |  22 ++++
 arch/x86/kernel/microcode_amd_early.c  | 222 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/microcode_core_early.c |  43 ++++++-
 7 files changed, 310 insertions(+), 17 deletions(-)

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
index 685692c..28dba52 100644
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
+	depends on (MICROCODE_INTEL || MICROCODE_AMD) && BLK_DEV_INITRD
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
index a57d9b7..24254aa 100644
--- a/arch/x86/include/asm/microcode_amd.h
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -61,4 +61,18 @@ extern int __apply_microcode_amd(struct microcode_amd *mc_amd);
 extern int apply_microcode_amd(int cpu);
 extern enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size);
 
+#ifdef CONFIG_MICROCODE_AMD_EARLY
+#ifdef CONFIG_X86_32
+#define MPB_MAX_SIZE PAGE_SIZE
+extern u8 __cpuinitdata amd_bsp_mpb[MPB_MAX_SIZE];
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
 #endif /* _ASM_X86_MICROCODE_AMD_H */
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
index 8f11f8f..47ebb1d 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -126,9 +126,20 @@ static struct ucode_patch *find_patch(unsigned int cpu)
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
@@ -373,6 +384,17 @@ enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size)
 	if (ret != UCODE_OK)
 		cleanup();
 
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
 	return ret;
 }
 
diff --git a/arch/x86/kernel/microcode_amd_early.c b/arch/x86/kernel/microcode_amd_early.c
new file mode 100644
index 0000000..7e54d97
--- /dev/null
+++ b/arch/x86/kernel/microcode_amd_early.c
@@ -0,0 +1,222 @@
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
+
+#include <asm/cpu.h>
+#include <asm/setup.h>
+#include <asm/microcode_amd.h>
+
+static bool ucode_loaded;
+static u32 ucode_new_rev;
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
+	struct cpio_data cd;
+
+#ifdef CONFIG_X86_32
+	/*
+	 * On 32-bit, early load occurs before paging is turned on so we need
+	 * to use physical addresses.
+	 */
+	if (!(read_cr0() & X86_CR0_PG)) {
+		struct boot_params *p;
+		p  = (struct boot_params *)__pa_nodebug(&boot_params);
+		cd = find_cpio_data((char *)__pa_nodebug(ucode_path),
+			(void *)p->hdr.ramdisk_image, p->hdr.ramdisk_size,
+			&offset);
+	} else
+#endif
+		cd = find_cpio_data(ucode_path,
+			(void *)(boot_params.hdr.ramdisk_image + PAGE_OFFSET),
+			boot_params.hdr.ramdisk_size, &offset);
+
+	if (*(u32 *)cd.data != UCODE_MAGIC) {
+		cd.data = NULL;
+		cd.size = 0;
+	}
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
+static void __init apply_ucode_in_initrd(void)
+{
+	struct cpio_data cd;
+	struct equiv_cpu_entry *eq;
+	u32 *header;
+	u8  *data;
+	u16 eq_id;
+	int offset, left;
+	u32 rev, dummy;
+	u32 *new_rev;
+
+#ifdef CONFIG_X86_32
+	new_rev = (u32 *)__pa_nodebug(&ucode_new_rev);
+#else
+	new_rev = &ucode_new_rev;
+#endif
+	cd = find_ucode_in_initrd();
+	if (!cd.data)
+		return;
+
+	data   = cd.data;
+	left   = cd.size;
+	header = (u32 *)data;
+
+	/* find equiv cpu table */
+
+	if (header[1] != UCODE_EQUIV_CPU_TABLE_TYPE || /* type */
+	    header[2] == 0)                            /* size */
+		return;
+
+	eq     = (struct equiv_cpu_entry *)(data + CONTAINER_HDR_SZ);
+	offset = header[2] + CONTAINER_HDR_SZ;
+	data  += offset;
+	left  -= offset;
+
+	eq_id  = find_equiv_id(eq, cpuid_eax(0x00000001));
+	if (!eq_id)
+		return;
+
+	/* find ucode and update if needed */
+
+	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
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
+				if (!(*new_rev))
+					*new_rev = mc->hdr.patch_id;
+				break;
+			}
+
+		offset  = header[1] + SECTION_HDR_SIZE;
+		data   += offset;
+		left   -= offset;
+	}
+}
+
+void __init load_ucode_amd_bsp(void)
+{
+	apply_ucode_in_initrd();
+}
+
+#ifdef CONFIG_X86_32
+u8 __cpuinitdata amd_bsp_mpb[MPB_MAX_SIZE];
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
+
+	mc = (struct microcode_amd *)__pa_nodebug(amd_bsp_mpb);
+	if (mc->hdr.patch_id && mc->hdr.processor_rev_id)
+		__apply_microcode_amd(mc);
+	else
+		apply_ucode_in_initrd();
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
+		struct cpio_data cd = find_ucode_in_initrd();
+		if (load_microcode_amd(0, cd.data, cd.size) != UCODE_OK)
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
+	struct cpio_data cd;
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
+	if (ucode_loaded)
+		return 0;
+
+	cd = find_ucode_in_initrd();
+	if (!cd.data)
+		return -EINVAL;
+
+	ret = load_microcode_amd(0, cd.data, cd.size);
+	if (ret != UCODE_OK)
+		return -EINVAL;
+
+	ucode_loaded = true;
+	return 0;
+}
diff --git a/arch/x86/kernel/microcode_core_early.c b/arch/x86/kernel/microcode_core_early.c
index 0d19ac5..86119f6 100644
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
@@ -95,16 +106,36 @@ void __cpuinit load_ucode_ap(void)
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
 }
 
 int __init save_microcode_in_initrd(void)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
-	if (c->x86_vendor == X86_VENDOR_INTEL && c->x86 >= 6)
-		return save_microcode_in_initrd_intel();
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
 
 	return 0;
 }
