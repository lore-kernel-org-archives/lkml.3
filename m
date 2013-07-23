Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab3GWL7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 07:59:01 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:33138 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937Ab3GWL66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 07:58:58 -0400
Date: Tue, 23 Jul 2013 13:58:53 +0200
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH]Fix early microcode loading on AMD
Message-ID: <20130723135853.579c3cd5@googlemail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixup the early AMD microcode loading.

* load_microcode_amd() (and the helper its using) should not have an
cpu parameter. The microcode loading is not depending on the CPU it is
executed and all the loaded patches will end up in a global list for all
CPUs anyway.
* Return -1 (like Intels apply_microcode) when the loading fails, also
do not set the active microcode level on failure.
* Save the amd_bsp_mpb on apply, not on load. Otherwise someone could later 
load an older microcode file that would overwrite amd_bsp_mpb, but would
not be applied to the CPUs
* Save the amd_bsp_mpb on every update. Otherwise someone could offline
the BSP, update the microcode and this would be lost on resume
* apply_ucode_in_initrd() now also needs to save amd_bsp_mbp, because
load_microcode_amd() its no longer doing this and its not using 
apply_microcode_amd().
* extract common checks and initialisations from load_ucode_ap() and
load_microcode_amd() to load_microcode_amd_early(). The change from
cpu to x86family in load_microcode_amd() allows to drop the code messing
with cpu_data(cpu), with is wrong anyway because at that point the
per-cpu cpu_info is not yet setup. And these values would later be
overwritten by smp_store_boot_cpu_info() / smp_store_cpu_info().
* fold collect_cpu_info_amd_early() into load_ucode_amd_ap(), because its
only used at one place.
* load_ucode_ap(): Quick exit for !cpu, because without load_microcode_amd()
getting called apply_microcode_amd() can't do anything. Exit, if no microcode
could be loaded.
* reduce save_microcode_in_initrd_amd() by reusing load_microcode_amd_early()

Main benefit is, that the early microcode loading no longer plays games with the 
not-yet-initialised per-cpu cpu_info. apply_microcode_amd() will still write
into cpu_data(cpu)->microcode, but I see no good way to remove that there, because
for not-early microcode updates that is exactly the right place for that update.

Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>

---

This alone also fixes the hang-on-boot I experienced with 3.11-rc1 even
if the fix for cpu_has_amd_erratum() is not applied, because now the
trigger (filling ->x86 but not ->x86_vendor) is no longer there. But I
think both patches should be applied.

Boot tested on 64 and 32bit, but as my BIOS already provides up-to-date
microcode I could not test, if that gets applied correctly.

--- a/arch/x86/include/asm/microcode_amd.h	2013-07-22 17:54:25.166193431 +0200
+++ b/arch/x86/include/asm/microcode_amd.h	2013-07-22 17:56:31.066192463 +0200
@@ -59,7 +59,7 @@ static inline u16 find_equiv_id(struct e
 
 extern int __apply_microcode_amd(struct microcode_amd *mc_amd);
 extern int apply_microcode_amd(int cpu);
-extern enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size);
+extern enum ucode_state load_microcode_amd(u8 x86family, const u8 *data, size_t size);
 
 #ifdef CONFIG_MICROCODE_AMD_EARLY
 #ifdef CONFIG_X86_32
--- a/arch/x86/kernel/microcode_amd.c	2013-07-22 17:33:55.856202878 +0200
+++ b/arch/x86/kernel/microcode_amd.c	2013-07-22 21:45:28.186086900 +0200
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
@@ -220,12 +219,20 @@ int apply_microcode_amd(int cpu)
 		return 0;
 	}
 
-	if (__apply_microcode_amd(mc_amd))
+	if (__apply_microcode_amd(mc_amd)) {
 		pr_err("CPU%d: update failed for patch_level=0x%08x\n",
 			cpu, mc_amd->hdr.patch_id);
-	else
-		pr_info("CPU%d: new patch_level=0x%08x\n", cpu,
-			mc_amd->hdr.patch_id);
+		return -1;
+	}
+
+#if defined(CONFIG_MICROCODE_AMD_EARLY) && defined(CONFIG_X86_32)
+	/* save applied patch for early load */
+	memset(amd_bsp_mpb, 0, MPB_MAX_SIZE);
+	memcpy(amd_bsp_mpb, p->data, min_t(u32, ksize(p->data), MPB_MAX_SIZE));
+#endif
+
+	pr_info("CPU%d: new patch_level=0x%08x\n", cpu,
+		mc_amd->hdr.patch_id);
 
 	uci->cpu_sig.rev = mc_amd->hdr.patch_id;
 	c->microcode = mc_amd->hdr.patch_id;
@@ -276,9 +283,8 @@ static void cleanup(void)
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
@@ -298,7 +304,7 @@ static int verify_and_add_patch(unsigned
 
 	/* check if patch is for the current family */
 	proc_fam = ((proc_fam >> 8) & 0xf) + ((proc_fam >> 20) & 0xff);
-	if (proc_fam != c->x86)
+	if (proc_fam != x86family)
 		return crnt_size;
 
 	if (mc_hdr->nb_dev_id || mc_hdr->sb_dev_id) {
@@ -307,7 +313,7 @@ static int verify_and_add_patch(unsigned
 		return crnt_size;
 	}
 
-	ret = verify_patch_size(cpu, patch_size, leftover);
+	ret = verify_patch_size(x86family, patch_size, leftover);
 	if (!ret) {
 		pr_err("Patch-ID 0x%08x: size mismatch.\n", mc_hdr->patch_id);
 		return crnt_size;
@@ -338,7 +344,7 @@ static int verify_and_add_patch(unsigned
 	return crnt_size;
 }
 
-static enum ucode_state __load_microcode_amd(int cpu, const u8 *data, size_t size)
+static enum ucode_state __load_microcode_amd(u8 x86family, const u8 *data, size_t size)
 {
 	enum ucode_state ret = UCODE_ERROR;
 	unsigned int leftover;
@@ -361,7 +367,7 @@ static enum ucode_state __load_microcode
 	}
 
 	while (leftover) {
-		crnt_size = verify_and_add_patch(cpu, fw, leftover);
+		crnt_size = verify_and_add_patch(x86family, fw, leftover);
 		if (crnt_size < 0)
 			return ret;
 
@@ -372,29 +378,18 @@ static enum ucode_state __load_microcode
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
 
-#if defined(CONFIG_MICROCODE_AMD_EARLY) && defined(CONFIG_X86_32)
-	/* save BSP's matching patch for early load */
-	if (cpu_data(cpu).cpu_index == boot_cpu_data.cpu_index) {
-		struct ucode_patch *p = find_patch(cpu);
-		if (p) {
-			memset(amd_bsp_mpb, 0, MPB_MAX_SIZE);
-			memcpy(amd_bsp_mpb, p->data, min_t(u32, ksize(p->data),
-							   MPB_MAX_SIZE));
-		}
-	}
-#endif
 	return ret;
 }
 
@@ -440,7 +435,7 @@ static enum ucode_state request_microcod
 		goto fw_release;
 	}
 
-	ret = load_microcode_amd(cpu, fw->data, fw->size);
+	ret = load_microcode_amd(c->x86, fw->data, fw->size);
 
  fw_release:
 	release_firmware(fw);
--- a/arch/x86/kernel/microcode_amd_early.c	2013-07-22 17:34:03.096202822 +0200
+++ b/arch/x86/kernel/microcode_amd_early.c	2013-07-22 21:49:37.076084988 +0200
@@ -170,6 +170,13 @@ static void apply_ucode_in_initrd(void *
 		mc = (struct microcode_amd *)(data + SECTION_HDR_SIZE);
 		if (eq_id == mc->hdr.processor_rev_id && rev < mc->hdr.patch_id)
 			if (__apply_microcode_amd(mc) == 0) {
+#ifdef CONFIG_X86_32
+				/* save applied patch for early load */
+				memset((void *)__pa(amd_bsp_mpb), 0,
+					 MPB_MAX_SIZE);
+				memcpy((void *)__pa(amd_bsp_mpb), mc,
+					min_t(u32, header[1], MPB_MAX_SIZE));
+#endif
 				rev = mc->hdr.patch_id;
 				*new_rev = rev;
 			}
@@ -196,6 +203,26 @@ void __init load_ucode_amd_bsp(void)
 	apply_ucode_in_initrd(cd.data, cd.size);
 }
 
+static int load_microcode_amd_early(void)
+{
+	enum ucode_state ret;
+	void *ucode;
+	u32 eax;
+
+	if (ucode_loaded || !ucode_size || !initrd_start)
+		return 0;
+
+	ucode = (void *)(initrd_start + ucode_offset);
+	eax = cpuid_eax(0x00000001);
+	ret = load_microcode_amd(((eax >> 8) & 0xf) + ((eax >> 20) & 0xff),
+		ucode, ucode_size);
+	if (ret != UCODE_OK)
+		return -EINVAL;
+
+	ucode_loaded = true;
+	return 0;
+}
+
 #ifdef CONFIG_X86_32
 u8 amd_bsp_mpb[MPB_MAX_SIZE];
 
@@ -238,46 +265,30 @@ static void __init collect_cpu_sig_on_bs
 	uci->cpu_sig.sig = cpuid_eax(0x00000001);
 }
 #else
-static void collect_cpu_info_amd_early(struct cpuinfo_x86 *c,
-						 struct ucode_cpu_info *uci)
+void load_ucode_amd_ap(void)
 {
+	unsigned int cpu = smp_processor_id();
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	u32 rev, eax;
 
+	/* BSP via load_ucode_amd_bsp() */
+	if (!cpu)
+		return;
+
+	load_microcode_amd_early();
+	if (!ucode_loaded)
+		return;
+
 	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, eax);
 	eax = cpuid_eax(0x00000001);
-
 	uci->cpu_sig.sig = eax;
 	uci->cpu_sig.rev = rev;
-	c->microcode = rev;
-	c->x86 = ((eax >> 8) & 0xf) + ((eax >> 20) & 0xff);
-}
-
-void load_ucode_amd_ap(void)
-{
-	unsigned int cpu = smp_processor_id();
-
-	collect_cpu_info_amd_early(&cpu_data(cpu), ucode_cpu_info + cpu);
-
-	if (cpu && !ucode_loaded) {
-		void *ucode;
-
-		if (!ucode_size || !initrd_start)
-			return;
-
-		ucode = (void *)(initrd_start + ucode_offset);
-		if (load_microcode_amd(0, ucode, ucode_size) != UCODE_OK)
-			return;
-		ucode_loaded = true;
-	}
-
 	apply_microcode_amd(cpu);
 }
 #endif
 
 int __init save_microcode_in_initrd_amd(void)
 {
-	enum ucode_state ret;
-	void *ucode;
 #ifdef CONFIG_X86_32
 	unsigned int bsp = boot_cpu_data.cpu_index;
 	struct ucode_cpu_info *uci = ucode_cpu_info + bsp;
@@ -289,14 +300,5 @@ int __init save_microcode_in_initrd_amd(
 		pr_info("microcode: updated early to new patch_level=0x%08x\n",
 			ucode_new_rev);
 
-	if (ucode_loaded || !ucode_size || !initrd_start)
-		return 0;
-
-	ucode = (void *)(initrd_start + ucode_offset);
-	ret = load_microcode_amd(0, ucode, ucode_size);
-	if (ret != UCODE_OK)
-		return -EINVAL;
-
-	ucode_loaded = true;
-	return 0;
+	return load_microcode_amd_early();
 }
