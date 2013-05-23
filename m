Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3EWBQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 21:16:52 -0400
Received: from [216.32.181.182] ([216.32.181.182]:13501 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756084Ab3EWBQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 21:16:50 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MN88U2-02-1XM-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>
CC: Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Borislav Petkov <bp@alien8.de>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 2/2] x86/microcode: early microcode patch loading support on AMD
Date: Wed, 22 May 2013 20:15:34 -0500
Message-ID: <1369271734-3231-3-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369271734-3231-1-git-send-email-jacob.shin@amd.com>
References: <1369271734-3231-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for early microcode patch loading on AMD.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/Kconfig                       |   14 +-
 arch/x86/include/asm/microcode_amd.h   |   14 ++
 arch/x86/kernel/microcode_amd.c        |  335 ++++++++++++++++++++++++++++----
 arch/x86/kernel/microcode_core_early.c |    7 +
 4 files changed, 324 insertions(+), 46 deletions(-)
 create mode 100644 arch/x86/include/asm/microcode_amd.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3a5bced..8ab7b6a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1090,8 +1090,16 @@ config MICROCODE_INTEL_LIB
 	depends on MICROCODE_INTEL
 
 config MICROCODE_INTEL_EARLY
-	bool "Early load microcode"
+	def_bool y
 	depends on MICROCODE_INTEL && BLK_DEV_INITRD
+
+config MICROCODE_AMD_EARLY
+	def_bool y
+	depends on MICROCODE_AMD && BLK_DEV_INITRD
+
+config MICROCODE_EARLY
+	bool "Early load microcode"
+	depends on MICROCODE_INTEL_EARLY || MICROCODE_AMD_EARLY
 	default y
 	help
 	  This option provides functionality to read additional microcode data
@@ -1099,10 +1107,6 @@ config MICROCODE_INTEL_EARLY
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
index 0000000..56274b3
--- /dev/null
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_X86_MICROCODE_AMD_H
+#define _ASM_X86_MICROCODE_AMD_H
+
+#ifdef CONFIG_MICROCODE_AMD_EARLY
+extern void __init load_ucode_amd_bsp(void);
+extern void __cpuinit load_ucode_amd_ap(void);
+extern int __init save_microcode_in_initrd_amd(void);
+#else
+static inline void __init load_ucode_amd_bsp(void) {}
+static inline void __cpuinit load_ucode_amd_ap(void) {}
+static inline int __init save_microcode_in_initrd_amd(void) {}
+#endif
+
+#endif /* _ASM_X86_MICROCODE_AMD_H */
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index efdec7c..9a13b89 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -27,10 +27,12 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/earlycpio.h>
 
 #include <asm/microcode.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
+#include <asm/setup.h>
 
 MODULE_DESCRIPTION("AMD Microcode Update Driver");
 MODULE_AUTHOR("Peter Oruba");
@@ -84,23 +86,28 @@ struct ucode_patch {
 
 static LIST_HEAD(pcache);
 
-static u16 find_equiv_id(unsigned int cpu)
+static u16 _find_equiv_id(struct equiv_cpu_entry *eq,
+			  struct ucode_cpu_info *uci)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	int i = 0;
 
-	if (!equiv_cpu_table)
+	if (!eq)
 		return 0;
 
-	while (equiv_cpu_table[i].installed_cpu != 0) {
-		if (uci->cpu_sig.sig == equiv_cpu_table[i].installed_cpu)
-			return equiv_cpu_table[i].equiv_cpu;
+	while (eq[i].installed_cpu != 0) {
+		if (uci->cpu_sig.sig == eq[i].installed_cpu)
+			return eq[i].equiv_cpu;
 
 		i++;
 	}
 	return 0;
 }
 
+static u16 find_equiv_id(unsigned int cpu)
+{
+	return _find_equiv_id(equiv_cpu_table, ucode_cpu_info + cpu);
+}
+
 static u32 find_cpu_family_by_equiv_cpu(u16 equiv_cpu)
 {
 	int i = 0;
@@ -173,9 +180,17 @@ static struct ucode_patch *find_patch(unsigned int cpu)
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct ucode_patch *p;
 
 	csig->sig = cpuid_eax(0x00000001);
 	csig->rev = c->microcode;
+
+	/* if a patch was early loaded, tell microcode_core.c about it */
+	p = find_patch(cpu);
+	if (p && (p->patch_id == csig->rev))
+		uci->mc = p->data;
+
 	pr_info("CPU%d: patch_level=0x%08x\n", cpu, csig->rev);
 
 	return 0;
@@ -215,24 +230,14 @@ static unsigned int verify_patch_size(int cpu, u32 patch_size,
 	return patch_size;
 }
 
-static int apply_microcode_amd(int cpu)
+static int _apply_microcode_amd(int cpu, void *data, struct cpuinfo_x86 *c,
+				struct ucode_cpu_info *uci, bool silent)
 {
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct microcode_amd *mc_amd;
-	struct ucode_cpu_info *uci;
-	struct ucode_patch *p;
 	u32 rev, dummy;
 
-	BUG_ON(raw_smp_processor_id() != cpu);
-
-	uci = ucode_cpu_info + cpu;
-
-	p = find_patch(cpu);
-	if (!p)
-		return 0;
-
-	mc_amd  = p->data;
-	uci->mc = p->data;
+	mc_amd  = data;
+	uci->mc = data;
 
 	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
@@ -247,18 +252,37 @@ static int apply_microcode_amd(int cpu)
 	/* verify patch application was successful */
 	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 	if (rev != mc_amd->hdr.patch_id) {
-		pr_err("CPU%d: update failed for patch_level=0x%08x\n",
-		       cpu, mc_amd->hdr.patch_id);
+		if (!silent)
+			pr_err("CPU%d: update failed for patch_level=0x%08x\n",
+				cpu, mc_amd->hdr.patch_id);
 		return -1;
 	}
 
-	pr_info("CPU%d: new patch_level=0x%08x\n", cpu, rev);
+	if (!silent)
+		pr_info("CPU%d: new patch_level=0x%08x\n", cpu, rev);
 	uci->cpu_sig.rev = rev;
 	c->microcode = rev;
 
 	return 0;
 }
 
+static int apply_microcode_amd(int cpu)
+{
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	struct ucode_cpu_info *uci;
+	struct ucode_patch *p;
+
+	BUG_ON(raw_smp_processor_id() != cpu);
+
+	uci = ucode_cpu_info + cpu;
+
+	p = find_patch(cpu);
+	if (!p)
+		return 0;
+
+	return _apply_microcode_amd(cpu, p->data, c, uci, false);
+}
+
 static int install_equiv_cpu_table(const u8 *buf)
 {
 	unsigned int *ibuf = (unsigned int *)buf;
@@ -398,6 +422,44 @@ static enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size)
 	return UCODE_OK;
 }
 
+#ifdef CONFIG_X86_32
+#define MPB_MAX_SIZE F15H_MPB_MAX_SIZE
+static u8 bsp_mpb[MPB_MAX_SIZE];
+#endif
+static enum ucode_state request_microcode_fw(int cpu, const struct firmware *fw)
+{
+	enum ucode_state ret = UCODE_ERROR;
+
+	if (*(u32 *)fw->data != UCODE_MAGIC) {
+		pr_err("invalid magic value (0x%08x)\n", *(u32 *)fw->data);
+		return ret;
+	}
+
+	/* free old equiv table */
+	free_equiv_cpu_table();
+
+	ret = load_microcode_amd(cpu, fw->data, fw->size);
+	if (ret != UCODE_OK)
+		cleanup();
+
+#ifdef CONFIG_X86_32
+	/*
+	 * on X86_32 early load, while CPU hotplugging on, we cannot traverse
+	 * pcache since paging is not turneded on yet. so stash away BSP's MPB
+	 * when a new fw file is installed.
+	 */
+	if (cpu_data(cpu).cpu_index == boot_cpu_data.cpu_index) {
+		struct ucode_patch *p;
+
+		p = find_patch(cpu);
+		if (p)
+			memcpy(bsp_mpb, p->data, min_t(u32, ksize(p->data),
+						       MPB_MAX_SIZE));
+	}
+#endif
+	return ret;
+}
+
 /*
  * AMD microcode firmware naming convention, up to family 15h they are in
  * the legacy file:
@@ -419,7 +481,7 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
 {
 	char fw_name[36] = "amd-ucode/microcode_amd.bin";
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	enum ucode_state ret = UCODE_NFOUND;
+	enum ucode_state ret;
 	const struct firmware *fw;
 
 	/* reload ucode container only on the boot cpu */
@@ -431,26 +493,11 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
 
 	if (request_firmware(&fw, (const char *)fw_name, device)) {
 		pr_err("failed to load file %s\n", fw_name);
-		goto out;
+		return UCODE_NFOUND;
 	}
 
-	ret = UCODE_ERROR;
-	if (*(u32 *)fw->data != UCODE_MAGIC) {
-		pr_err("invalid magic value (0x%08x)\n", *(u32 *)fw->data);
-		goto fw_release;
-	}
-
-	/* free old equiv table */
-	free_equiv_cpu_table();
-
-	ret = load_microcode_amd(cpu, fw->data, fw->size);
-	if (ret != UCODE_OK)
-		cleanup();
-
- fw_release:
+	ret = request_microcode_fw(cpu, fw);
 	release_firmware(fw);
-
- out:
 	return ret;
 }
 
@@ -475,6 +522,212 @@ static struct microcode_ops microcode_amd_ops = {
 	.microcode_fini_cpu               = microcode_fini_cpu_amd,
 };
 
+/*
+ * Early Loading Support
+ */
+
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
+/*
+ * microcode patch container file is prepended to the initrd in cpio format.
+ * see Documentation/x86/early-microcode.txt
+ */
+static __initdata char ucode_path[] = "kernel/x86/microcode/AuthenticAMD.bin";
+
+static struct cpio_data __init
+request_firmware_in_initrd(void)
+{
+	long offset = 0;
+
+	return find_cpio_data(ucode_path,
+			(void *)(boot_params.hdr.ramdisk_image + PAGE_OFFSET),
+			boot_params.hdr.ramdisk_size, &offset);
+}
+
+static struct cpio_data __init request_firmware_in_initrd_early(void)
+{
+#ifdef CONFIG_X86_32
+	struct boot_params *boot_params_p;
+	long offset = 0;
+
+	boot_params_p = (struct boot_params *)__pa_nodebug(&boot_params);
+	return find_cpio_data((char *)__pa_nodebug(ucode_path),
+			(void *)boot_params_p->hdr.ramdisk_image,
+			boot_params_p->hdr.ramdisk_size, &offset);
+#else
+	return request_firmware_in_initrd();
+#endif
+}
+
+static int __init
+find_equiv_cpu_table_early(const u8 *buf, struct equiv_cpu_entry **eq)
+{
+	unsigned int *ibuf = (unsigned int *)buf;
+	unsigned int type = ibuf[1];
+	unsigned int size = ibuf[2];
+
+	if (type != UCODE_EQUIV_CPU_TABLE_TYPE || !size)
+		return -EINVAL;
+
+	/*
+	 * during BSP load, vmalloc() is not available yet.
+	 * so just use equivalent cpu table in initrd memory in place,
+	 * no need to copy it. on X86_64, first AP to load will actually
+	 * "install" the equiv_cpu_table. on X86_32, before mm frees up initrd.
+	 */
+	*eq = (struct equiv_cpu_entry *)(buf + CONTAINER_HDR_SZ);
+
+	/* add header length */
+	return size + CONTAINER_HDR_SZ;
+}
+
+static enum ucode_state __init
+load_microcode_amd_early(int cpu, const u8 *data, size_t size)
+{
+	unsigned int leftover;
+	u8 *fw = (u8 *)data;
+	int offset;
+	u16 equiv_id;
+	struct equiv_cpu_entry *eq;
+	struct cpuinfo_x86 c;
+	struct ucode_cpu_info uci;
+
+	collect_cpu_info_amd_early(&c, &uci);
+
+	offset = find_equiv_cpu_table_early(data, &eq);
+	if (offset < 0)
+		return UCODE_ERROR;
+	fw += offset;
+	leftover = size - offset;
+
+	if (*(u32 *)fw != UCODE_UCODE_TYPE)
+		return UCODE_ERROR;
+
+	equiv_id = _find_equiv_id(eq, &uci);
+	if (!equiv_id)
+		return UCODE_NFOUND;
+
+	while (leftover) {
+		struct microcode_amd *mc;
+		int patch_size = *(u32 *)(fw + 4);
+
+		/*
+		 * during BSP load, vmalloc() is not available yet,
+		 * so simply find and apply the matching microcode patch in
+		 * initrd memory in place. on X86_64, first AP to load will
+		 * actually "cache" the patches in kernel memory.
+		 */
+		mc = (struct microcode_amd *)(fw + SECTION_HDR_SIZE);
+		if (equiv_id == mc->hdr.processor_rev_id)
+			if (_apply_microcode_amd(cpu, mc, &c, &uci, true) == 0)
+				break;
+
+		offset    = patch_size + SECTION_HDR_SIZE;
+		fw	 += offset;
+		leftover -= offset;
+	}
+
+	return UCODE_OK;
+}
+
+static void collect_cpu_info_amd_early_bsp(void *arg)
+{
+	unsigned int cpu = smp_processor_id();
+	struct cpuinfo_x86 dummy;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	collect_cpu_info_amd_early(&dummy, uci);
+}
+
+int __init save_microcode_in_initrd_amd(void)
+{
+	struct cpio_data cd;
+	struct firmware fw;
+	struct ucode_cpu_info *uci = ucode_cpu_info + boot_cpu_data.cpu_index;
+
+	if (equiv_cpu_table)
+		return 0;
+
+	cd = request_firmware_in_initrd();
+	if (!cd.data)
+		return -EINVAL;
+
+	fw.data = cd.data;
+	fw.size = cd.size;
+
+	if (!uci->cpu_sig.sig)
+		smp_call_function_single(boot_cpu_data.cpu_index,
+					 collect_cpu_info_amd_early_bsp, NULL,
+					 1);
+
+	if (request_microcode_fw(boot_cpu_data.cpu_index, &fw) != UCODE_OK)
+		return -EINVAL;
+
+	return 0;
+}
+
+void __init load_ucode_amd_bsp(void)
+{
+	unsigned int cpu = smp_processor_id();
+	struct cpio_data fw = request_firmware_in_initrd_early();
+
+	if (!fw.data)
+		return;
+
+	load_microcode_amd_early(cpu, fw.data, fw.size);
+}
+
+#ifdef CONFIG_X86_32
+/*
+ * on X86_32 AP load, since paging is turned off and vmalloc() is not available
+ * yet, we cannot install the equivalent cpu table nor cache the microcode
+ * patches in kernel memory, so just take the BSP code path. unless we are
+ * CPU hotplugging on (i.e. resume from suspend), which then we will load from
+ * bsp_mpb instead.
+ */
+void __cpuinit load_ucode_amd_ap(void)
+{
+	unsigned int cpu = smp_processor_id();
+	struct microcode_amd *mc;
+	struct cpuinfo_x86 c;
+	struct ucode_cpu_info uci;
+
+	mc = (struct microcode_amd *)__pa_nodebug(bsp_mpb);
+	if (mc->hdr.patch_id && mc->hdr.processor_rev_id)
+		_apply_microcode_amd(cpu, mc, &c, &uci, true);
+	else
+		load_ucode_amd_bsp();
+}
+#else
+/*
+ * on X86_64 AP load, we can vmalloc(). we can go through the normal (non-early)
+ * code path, we just have to make sure we prepare cpu_data and ucode_cpu_info.
+ */
+void __cpuinit load_ucode_amd_ap(void)
+{
+	unsigned int cpu = smp_processor_id();
+
+	collect_cpu_info_amd_early(&cpu_data(cpu), ucode_cpu_info + cpu);
+
+	if (cpu && !equiv_cpu_table)
+		if (save_microcode_in_initrd_amd())
+			return;
+
+	apply_microcode_amd(cpu);
+}
+#endif
+
 struct microcode_ops * __init init_amd_microcode(void)
 {
 	struct cpuinfo_x86 *c = &cpu_data(0);
diff --git a/arch/x86/kernel/microcode_core_early.c b/arch/x86/kernel/microcode_core_early.c
index 0d19ac5..1221c22 100644
--- a/arch/x86/kernel/microcode_core_early.c
+++ b/arch/x86/kernel/microcode_core_early.c
@@ -18,6 +18,7 @@
  */
 #include <linux/module.h>
 #include <asm/microcode_intel.h>
+#include <asm/microcode_amd.h>
 #include <asm/processor.h>
 
 #define QCHAR(a, b, c, d) ((a) + ((b) << 8) + ((c) << 16) + ((d) << 24))
@@ -83,6 +84,8 @@ void __init load_ucode_bsp(void)
 
 	if (vendor == X86_VENDOR_INTEL && x86 >= 6)
 		load_ucode_intel_bsp();
+	else if (vendor == X86_VENDOR_AMD && x86 >= 0x10)
+		load_ucode_amd_bsp();
 }
 
 void __cpuinit load_ucode_ap(void)
@@ -97,6 +100,8 @@ void __cpuinit load_ucode_ap(void)
 
 	if (vendor == X86_VENDOR_INTEL && x86 >= 6)
 		load_ucode_intel_ap();
+	else if (vendor == X86_VENDOR_AMD && x86 >= 0x10)
+		load_ucode_amd_ap();
 }
 
 int __init save_microcode_in_initrd(void)
@@ -105,6 +110,8 @@ int __init save_microcode_in_initrd(void)
 
 	if (c->x86_vendor == X86_VENDOR_INTEL && c->x86 >= 6)
 		return save_microcode_in_initrd_intel();
+	else if (c->x86_vendor == X86_VENDOR_AMD && c->x86 >= 0x10)
+		return save_microcode_in_initrd_amd();
 
 	return 0;
 }
-- 
1.7.9.5


