Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaBCUlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 15:41:49 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47872 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbaBCUls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:41:48 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, microcode, AMD: Unify valid container checks
Date: Mon,  3 Feb 2014 21:41:44 +0100
Message-Id: <1391460104-7261-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
In-Reply-To: <20140203203323.GG4281@pd.tnic>
References: <20140203203323.GG4281@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

For additional coverage, BorisO and friends unknowlingly did swap AMD
microcode with Intel microcode blobs in order to see what happens. What
did happen on 32-bit was

[    5.722656] BUG: unable to handle kernel paging request at be3a6008
[    5.722693] IP: [<c106d6b4>] load_microcode_amd+0x24/0x3f0
[    5.722716] *pdpt = 0000000000000000 *pde = 0000000000000000

because there was a valid initrd there but without valid microcode in it
and the container check happened *after* the relocated ramdisk handling
on 32-bit, which was clearly wrong.

While at it, take care of the ramdisk relocation on both 32- and 64-bit
as it is done on both. Also, comment what we're doing because this code
is a bit tricky.

Reported-and-tested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/microcode/amd_early.c | 43 +++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
index 8384c0fa206f..617a9e284245 100644
--- a/arch/x86/kernel/cpu/microcode/amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -285,6 +285,15 @@ static void __init collect_cpu_sig_on_bsp(void *arg)
 
 	uci->cpu_sig.sig = cpuid_eax(0x00000001);
 }
+
+static void __init get_bsp_sig(void)
+{
+	unsigned int bsp = boot_cpu_data.cpu_index;
+	struct ucode_cpu_info *uci = ucode_cpu_info + bsp;
+
+	if (!uci->cpu_sig.sig)
+		smp_call_function_single(bsp, collect_cpu_sig_on_bsp, NULL, 1);
+}
 #else
 void load_ucode_amd_ap(void)
 {
@@ -337,31 +346,37 @@ void load_ucode_amd_ap(void)
 
 int __init save_microcode_in_initrd_amd(void)
 {
+	unsigned long cont;
 	enum ucode_state ret;
 	u32 eax;
 
-#ifdef CONFIG_X86_32
-	unsigned int bsp = boot_cpu_data.cpu_index;
-	struct ucode_cpu_info *uci = ucode_cpu_info + bsp;
-
-	if (!uci->cpu_sig.sig)
-		smp_call_function_single(bsp, collect_cpu_sig_on_bsp, NULL, 1);
+	if (!container)
+		return -EINVAL;
 
+#ifdef CONFIG_X86_32
+	get_bsp_sig();
+	cont = (unsigned long)container;
+#else
 	/*
-	 * Take into account the fact that the ramdisk might get relocated
-	 * and therefore we need to recompute the container's position in
-	 * virtual memory space.
+	 * We need the physical address of the container for both bitness since
+	 * boot_params.hdr.ramdisk_image is a physical address.
 	 */
-	container = (u8 *)(__va((u32)relocated_ramdisk) +
-			   ((u32)container - boot_params.hdr.ramdisk_image));
+	cont = __pa(container);
 #endif
+
+	/*
+	 * Take into account the fact that the ramdisk might get relocated and
+	 * therefore we need to recompute the container's position in virtual
+	 * memory space.
+	 */
+	if (relocated_ramdisk)
+		container = (u8 *)(__va(relocated_ramdisk) +
+			     (cont - boot_params.hdr.ramdisk_image));
+
 	if (ucode_new_rev)
 		pr_info("microcode: updated early to new patch_level=0x%08x\n",
 			ucode_new_rev);
 
-	if (!container)
-		return -EINVAL;
-
 	eax   = cpuid_eax(0x00000001);
 	eax   = ((eax >> 8) & 0xf) + ((eax >> 20) & 0xff);
 
-- 
1.8.5.2.192.g7794a68

