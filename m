Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab3GWVAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:00:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64638 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940Ab3GWVAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:00:31 -0400
Date: Tue, 23 Jul 2013 23:00:26 +0200
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] x86, AMD: cleanup: merge common code in early microcode
 loading
Message-ID: <20130723230026.394a5ee1@googlemail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract common checks and initialisations from load_ucode_ap() and
save_microcode_in_initrd_amd() to load_microcode_amd_early().
load_ucode_ap() gets a quick exit for !cpu, because for the BSP there is
already a different function dealing with its update.

The original code already didn't anything, because without load_microcode_amd()
getting called apply_microcode_amd() could not do anything.

Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>

--- a/arch/x86/kernel/microcode_amd_early.c	2013-07-22 06:22:32.000000000 +0200
+++ b/arch/x86/kernel/microcode_amd_early.c	2013-07-23 20:00:04.889508712 +0200
@@ -196,6 +196,23 @@ void __init load_ucode_amd_bsp(void)
 	apply_ucode_in_initrd(cd.data, cd.size);
 }
 
+static int load_microcode_amd_early(void)
+{
+	enum ucode_state ret;
+	void *ucode;
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
+
 #ifdef CONFIG_X86_32
 u8 amd_bsp_mpb[MPB_MAX_SIZE];
 
@@ -258,17 +275,13 @@ void load_ucode_amd_ap(void)
 
 	collect_cpu_info_amd_early(&cpu_data(cpu), ucode_cpu_info + cpu);
 
-	if (cpu && !ucode_loaded) {
-		void *ucode;
-
-		if (!ucode_size || !initrd_start)
-			return;
+	/* BSP via load_ucode_amd_bsp() */
+	if (!cpu)
+		return;
 
-		ucode = (void *)(initrd_start + ucode_offset);
-		if (load_microcode_amd(0, ucode, ucode_size) != UCODE_OK)
-			return;
-		ucode_loaded = true;
-	}
+	load_microcode_amd_early();
+	if (!ucode_loaded)
+		return;
 
 	apply_microcode_amd(cpu);
 }
@@ -276,8 +289,6 @@ void load_ucode_amd_ap(void)
 
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
