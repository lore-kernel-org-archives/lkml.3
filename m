Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbaBFTkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 14:40:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46634 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbaBFTkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 14:40:01 -0500
Date: Thu, 6 Feb 2014 11:39:38 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-75a1ba5b2c529db60ca49626bcaf0bddf4548438@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        boris.ostrovsky@oracle.com, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1391460104-7261-1-git-send-email-bp@alien8.de>
References: <1391460104-7261-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, microcode, AMD:
  Unify valid container checks
Git-Commit-ID: 75a1ba5b2c529db60ca49626bcaf0bddf4548438
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 06 Feb 2014 11:39:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75a1ba5b2c529db60ca49626bcaf0bddf4548438
Gitweb:     http://git.kernel.org/tip/75a1ba5b2c529db60ca49626bcaf0bddf4548438
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 3 Feb 2014 21:41:44 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 6 Feb 2014 11:11:19 -0800

x86, microcode, AMD: Unify valid container checks

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
Link: http://lkml.kernel.org/r/1391460104-7261-1-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/microcode/amd_early.c | 43 +++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
index 8384c0f..617a9e2 100644
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
 
