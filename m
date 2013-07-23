Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933999Ab3GWVGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:06:18 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:48612 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab3GWVGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:06:15 -0400
Date: Tue, 23 Jul 2013 23:06:10 +0200
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] x86, AMD: simplify load_microcode_amd() to fix early
 microcode loading to no longer access uninitialized per-cpu data
Message-ID: <20130723230610.73bd048d@googlemail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

load_microcode_amd() (and the helper it is using) should not have an
cpu parameter. The microcode loading is not depending on the CPU it is
executed and all the loaded patches will end up in a global list for all
CPUs anyway.
The change from cpu to x86family in load_microcode_amd() now allows to drop
the code messing with cpu_data(cpu) from collect_cpu_info_amd_early(), which 
is wrong anyway because at that point the per-cpu cpu_info is not yet setup. 
And these values would later be overwritten by smp_store_boot_cpu_info() / 
smp_store_cpu_info().

Fold the rest of collect_cpu_info_amd_early() into load_ucode_amd_ap(), because its
only used at one place and without the cpuinfo_x86 accesses it was not much left.

Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>

---

One effect of this early, partly initialisation of cpu_info was, that the fallback
logic in cpu_has_amd_erratum() did not use boot_cpu_data and because x86_vendor
was not initialised in the per-cpu struct the E400 erratum was not activated on
my system resulting in a failed boot.

--- a/arch/x86/include/asm/microcode_amd.h	2013-07-23 20:15:10.549501081 +0200
+++ b/arch/x86/include/asm/microcode_amd.h	2013-07-23 20:16:05.329500620 +0200
@@ -59,7 +59,7 @@ static inline u16 find_equiv_id(struct e
 
 extern int __apply_microcode_amd(struct microcode_amd *mc_amd);
 extern int apply_microcode_amd(int cpu);
-extern enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size);
+extern enum ucode_state load_microcode_amd(u8 x86family, const u8 *data, size_t size);
 
 #ifdef CONFIG_MICROCODE_AMD_EARLY
 #ifdef CONFIG_X86_32
--- a/arch/x86/kernel/microcode_amd.c	2013-07-23 20:05:04.469506188 +0200
+++ b/arch/x86/kernel/microcode_amd.c	2013-07-23 20:23:22.739496934 +0200
@@ -145,10 +145,9 @@ static int collect_cpu_info_amd(int cpu,
 	return 0;
 }
 
-static unsigned int verify_patch_size(int cpu, u32 patch_size,
+static unsigned int verify_patch_size(u8 x86family, u32 patch_size,
 				      unsigned int size)
 {
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	u32 max_size;
 
 #define F1XH_MPB_MAX_SIZE 2048
@@ -156,7 +155,7 @@ static unsigned int verify_patch_size(in
 #define F15H_MPB_MAX_SIZE 4096
 #define F16H_MPB_MAX_SIZE 3458
 
-	switch (c->x86) {
+	switch (x86family) {
 	case 0x14:
 		max_size = F14H_MPB_MAX_SIZE;
 		break;
@@ -283,9 +282,8 @@ static void cleanup(void)
  * driver cannot continue functioning normally. In such cases, we tear
  * down everything we've used up so far and exit.
  */
-static int verify_and_add_patch(unsigned int cpu, u8 *fw, unsigned int leftover)
+static int verify_and_add_patch(u8 x86family, u8 *fw, unsigned int leftover)
 {
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct microcode_header_amd *mc_hdr;
 	struct ucode_patch *patch;
 	unsigned int patch_size, crnt_size, ret;
@@ -305,7 +303,7 @@ static int verify_and_add_patch(unsigned
 
 	/* check if patch is for the current family */
 	proc_fam = ((proc_fam >> 8) & 0xf) + ((proc_fam >> 20) & 0xff);
-	if (proc_fam != c->x86)
+	if (proc_fam != x86family)
 		return crnt_size;
 
 	if (mc_hdr->nb_dev_id || mc_hdr->sb_dev_id) {
@@ -314,7 +312,7 @@ static int verify_and_add_patch(unsigned
 		return crnt_size;
 	}
 
-	ret = verify_patch_size(cpu, patch_size, leftover);
+	ret = verify_patch_size(x86family, patch_size, leftover);
 	if (!ret) {
 		pr_err("Patch-ID 0x%08x: size mismatch.\n", mc_hdr->patch_id);
 		return crnt_size;
@@ -345,7 +343,7 @@ static int verify_and_add_patch(unsigned
 	return crnt_size;
 }
 
-static enum ucode_state __load_microcode_amd(int cpu, const u8 *data, size_t size)
+static enum ucode_state __load_microcode_amd(u8 x86family, const u8 *data, size_t size)
 {
 	enum ucode_state ret = UCODE_ERROR;
 	unsigned int leftover;
@@ -368,7 +366,7 @@ static enum ucode_state __load_microcode
 	}
 
 	while (leftover) {
-		crnt_size = verify_and_add_patch(cpu, fw, leftover);
+		crnt_size = verify_and_add_patch(x86family, fw, leftover);
 		if (crnt_size < 0)
 			return ret;
 
@@ -379,14 +377,14 @@ static enum ucode_state __load_microcode
 	return UCODE_OK;
 }
 
-enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size)
+enum ucode_state load_microcode_amd(u8 x86family, const u8 *data, size_t size)
 {
 	enum ucode_state ret;
 
 	/* free old equiv table */
 	free_equiv_cpu_table();
 
-	ret = __load_microcode_amd(cpu, data, size);
+	ret = __load_microcode_amd(x86family, data, size);
 
 	if (ret != UCODE_OK)
 		cleanup();
@@ -436,7 +434,7 @@ static enum ucode_state request_microcod
 		goto fw_release;
 	}
 
-	ret = load_microcode_amd(cpu, fw->data, fw->size);
+	ret = load_microcode_amd(c->x86, fw->data, fw->size);
 
  fw_release:
 	release_firmware(fw);
--- a/arch/x86/kernel/microcode_amd_early.c	2013-07-23 20:05:14.969506099 +0200
+++ b/arch/x86/kernel/microcode_amd_early.c	2013-07-23 21:38:28.837977145 +0200
@@ -207,12 +207,15 @@ static int load_microcode_amd_early(void)
 {
 	enum ucode_state ret;
 	void *ucode;
+	u32 eax;
 
 	if (ucode_loaded || !ucode_size || !initrd_start)
 		return 0;
 
 	ucode = (void *)(initrd_start + ucode_offset);
-	ret = load_microcode_amd(0, ucode, ucode_size);
+	eax = cpuid_eax(0x00000001);
+	ret = load_microcode_amd(((eax >> 8) & 0xf) + ((eax >> 20) & 0xff),
+		ucode, ucode_size);
 	if (ret != UCODE_OK)
 		return -EINVAL;
 
@@ -261,25 +265,11 @@ static void __init collect_cpu_sig_on_bs
 	uci->cpu_sig.sig = cpuid_eax(0x00000001);
 }
 #else
-static void collect_cpu_info_amd_early(struct cpuinfo_x86 *c,
-						 struct ucode_cpu_info *uci)
-{
-	u32 rev, eax;
-
-	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, eax);
-	eax = cpuid_eax(0x00000001);
-
-	uci->cpu_sig.sig = eax;
-	uci->cpu_sig.rev = rev;
-	c->microcode = rev;
-	c->x86 = ((eax >> 8) & 0xf) + ((eax >> 20) & 0xff);
-}
-
 void load_ucode_amd_ap(void)
 {
 	unsigned int cpu = smp_processor_id();
-
-	collect_cpu_info_amd_early(&cpu_data(cpu), ucode_cpu_info + cpu);
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	u32 rev, eax;
 
 	/* BSP via load_ucode_amd_bsp() */
 	if (!cpu)
@@ -289,6 +279,11 @@ void load_ucode_amd_ap(void)
         if (!ucode_loaded)
                 return;
 
+	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, eax);
+	eax = cpuid_eax(0x00000001);
+	uci->cpu_sig.sig = eax;
+	uci->cpu_sig.rev = rev;
+
 	apply_microcode_amd(cpu);
 }
 #endif
