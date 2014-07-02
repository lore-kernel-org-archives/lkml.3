Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaGBDmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 23:42:46 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41810 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaGBDmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 23:42:45 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2] x86: Find correct 64 bit ramdisk address for microcode early update
Date: Tue,  1 Jul 2014 20:42:17 -0700
Message-Id: <1404272537-14457-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using kexec with 64bit kernel, bzImage and ramdisk could be
loaded above 4G. We need this to get correct ramdisk adress.

Make get_ramdisk_image() global and use it for early microcode updating.

-v2: update changelog.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/setup.h                |    3 +++
 arch/x86/kernel/cpu/microcode/amd_early.c   |   10 +++++-----
 arch/x86/kernel/cpu/microcode/intel_early.c |    8 ++++----
 arch/x86/kernel/setup.c                     |   28 ++++++++++++++--------------
 4 files changed, 26 insertions(+), 23 deletions(-)

Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -105,6 +105,9 @@ void *extend_brk(size_t size, size_t ali
 	RESERVE_BRK(name, sizeof(type) * entries)
 
 extern void probe_roms(void);
+u64 get_ramdisk_image(struct boot_params *bp);
+u64 get_ramdisk_size(struct boot_params *bp);
+
 #ifdef __i386__
 
 asmlinkage void __init i386_start_kernel(void);
Index: linux-2.6/arch/x86/kernel/cpu/microcode/amd_early.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/microcode/amd_early.c
+++ linux-2.6/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -51,12 +51,12 @@ static struct cpio_data __init find_ucod
 	 */
 	p       = (struct boot_params *)__pa_nodebug(&boot_params);
 	path    = (char *)__pa_nodebug(ucode_path);
-	start   = (void *)p->hdr.ramdisk_image;
-	size    = p->hdr.ramdisk_size;
+	start   = (void *)(unsigned long)get_ramdisk_image(p);
+	size    = get_ramdisk_size(p);
 #else
 	path    = ucode_path;
-	start   = (void *)(boot_params.hdr.ramdisk_image + PAGE_OFFSET);
-	size    = boot_params.hdr.ramdisk_size;
+	start   = (void *)(get_ramdisk_image(&boot_params) + PAGE_OFFSET);
+	size    = get_ramdisk_size(&boot_params);
 #endif
 
 	return find_cpio_data(path, start, size, &offset);
@@ -371,7 +371,7 @@ int __init save_microcode_in_initrd_amd(
 	 */
 	if (relocated_ramdisk)
 		container = (u8 *)(__va(relocated_ramdisk) +
-			     (cont - boot_params.hdr.ramdisk_image));
+			     (cont - get_ramdisk_size(&boot_params)));
 
 	if (ucode_new_rev)
 		pr_info("microcode: updated early to new patch_level=0x%08x\n",
Index: linux-2.6/arch/x86/kernel/cpu/microcode/intel_early.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/microcode/intel_early.c
+++ linux-2.6/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -733,8 +733,8 @@ load_ucode_intel_bsp(void)
 	struct boot_params *boot_params_p;
 
 	boot_params_p = (struct boot_params *)__pa_nodebug(&boot_params);
-	ramdisk_image = boot_params_p->hdr.ramdisk_image;
-	ramdisk_size  = boot_params_p->hdr.ramdisk_size;
+	ramdisk_image = get_ramdisk_image(boot_params_p);
+	ramdisk_size  = get_ramdisk_size(boot_params_p);
 	initrd_start_early = ramdisk_image;
 	initrd_end_early = initrd_start_early + ramdisk_size;
 
@@ -743,8 +743,8 @@ load_ucode_intel_bsp(void)
 		(unsigned long *)__pa_nodebug(&mc_saved_in_initrd),
 		initrd_start_early, initrd_end_early, &uci);
 #else
-	ramdisk_image = boot_params.hdr.ramdisk_image;
-	ramdisk_size  = boot_params.hdr.ramdisk_size;
+	ramdisk_image = get_ramdisk_image(&boot_params);
+	ramdisk_size  = get_ramdisk_size(&boot_params);
 	initrd_start_early = ramdisk_image + PAGE_OFFSET;
 	initrd_end_early = initrd_start_early + ramdisk_size;
 
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -299,19 +299,19 @@ u64 relocated_ramdisk;
 
 #ifdef CONFIG_BLK_DEV_INITRD
 
-static u64 __init get_ramdisk_image(void)
+u64 __init get_ramdisk_image(struct boot_params *bp)
 {
-	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
+	u64 ramdisk_image = bp->hdr.ramdisk_image;
 
-	ramdisk_image |= (u64)boot_params.ext_ramdisk_image << 32;
+	ramdisk_image |= (u64)bp->ext_ramdisk_image << 32;
 
 	return ramdisk_image;
 }
-static u64 __init get_ramdisk_size(void)
+u64 __init get_ramdisk_size(struct boot_params *bp)
 {
-	u64 ramdisk_size = boot_params.hdr.ramdisk_size;
+	u64 ramdisk_size = bp->hdr.ramdisk_size;
 
-	ramdisk_size |= (u64)boot_params.ext_ramdisk_size << 32;
+	ramdisk_size |= (u64)bp->ext_ramdisk_size << 32;
 
 	return ramdisk_size;
 }
@@ -320,8 +320,8 @@ static u64 __init get_ramdisk_size(void)
 static void __init relocate_initrd(void)
 {
 	/* Assume only end is not page aligned */
-	u64 ramdisk_image = get_ramdisk_image();
-	u64 ramdisk_size  = get_ramdisk_size();
+	u64 ramdisk_image = get_ramdisk_image(&boot_params);
+	u64 ramdisk_size  = get_ramdisk_size(&boot_params);
 	u64 area_size     = PAGE_ALIGN(ramdisk_size);
 	unsigned long slop, clen, mapaddr;
 	char *p, *q;
@@ -359,8 +359,8 @@ static void __init relocate_initrd(void)
 		ramdisk_size  -= clen;
 	}
 
-	ramdisk_image = get_ramdisk_image();
-	ramdisk_size  = get_ramdisk_size();
+	ramdisk_image = get_ramdisk_image(&boot_params);
+	ramdisk_size  = get_ramdisk_size(&boot_params);
 	printk(KERN_INFO "Move RAMDISK from [mem %#010llx-%#010llx] to"
 		" [mem %#010llx-%#010llx]\n",
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
@@ -370,8 +370,8 @@ static void __init relocate_initrd(void)
 static void __init early_reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
-	u64 ramdisk_image = get_ramdisk_image();
-	u64 ramdisk_size  = get_ramdisk_size();
+	u64 ramdisk_image = get_ramdisk_image(&boot_params);
+	u64 ramdisk_size  = get_ramdisk_size(&boot_params);
 	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
 
 	if (!boot_params.hdr.type_of_loader ||
@@ -383,8 +383,8 @@ static void __init early_reserve_initrd(
 static void __init reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
-	u64 ramdisk_image = get_ramdisk_image();
-	u64 ramdisk_size  = get_ramdisk_size();
+	u64 ramdisk_image = get_ramdisk_image(&boot_params);
+	u64 ramdisk_size  = get_ramdisk_size(&boot_params);
 	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
 	u64 mapped_size;
 
