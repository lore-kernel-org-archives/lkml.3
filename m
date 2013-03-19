Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934359Ab3CSWJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:09:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:18565 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934172Ab3CSWJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:09:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,874,1355126400"; 
   d="scan'208";a="273258343"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        penguin-kernel@I-love.SAKURA.ne.jp,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH] x86/microcode_intel_early.c: Get 32-bit physical address by __pa_nodebug()
Date: Tue, 19 Mar 2013 08:04:44 -0700
Message-Id: <1363705484-27645-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

In 32-bit, __pa_symbol() in CONFIG_DEBUG_VIRTUAL accesses kernel data (e.g.
max_low_pfn) that haven't been setup yet in such early boot phase. To fix the
issue, __pa_nodebug() replaces __pa_symbol() to get a global symbol's physical
address.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/microcode_intel_early.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
index 7890bc8..5992ee8 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/microcode_intel_early.c
@@ -90,13 +90,13 @@ microcode_phys(struct microcode_intel **mc_saved_tmp,
 	struct microcode_intel ***mc_saved;
 
 	mc_saved = (struct microcode_intel ***)
-		   __pa_symbol(&mc_saved_data->mc_saved);
+		   __pa_nodebug(&mc_saved_data->mc_saved);
 	for (i = 0; i < mc_saved_data->mc_saved_count; i++) {
 		struct microcode_intel *p;
 
 		p = *(struct microcode_intel **)
-			__pa(mc_saved_data->mc_saved + i);
-		mc_saved_tmp[i] = (struct microcode_intel *)__pa(p);
+			__pa_nodebug(mc_saved_data->mc_saved + i);
+		mc_saved_tmp[i] = (struct microcode_intel *)__pa_nodebug(p);
 	}
 }
 #endif
@@ -562,7 +562,7 @@ scan_microcode(unsigned long start, unsigned long end,
 	struct cpio_data cd;
 	long offset = 0;
 #ifdef CONFIG_X86_32
-	char *p = (char *)__pa_symbol(ucode_name);
+	char *p = (char *)__pa_nodebug(ucode_name);
 #else
 	char *p = ucode_name;
 #endif
@@ -630,8 +630,8 @@ static void __cpuinit print_ucode(struct ucode_cpu_info *uci)
 	if (mc_intel == NULL)
 		return;
 
-	delay_ucode_info_p = (int *)__pa_symbol(&delay_ucode_info);
-	current_mc_date_p = (int *)__pa_symbol(&current_mc_date);
+	delay_ucode_info_p = (int *)__pa_nodebug(&delay_ucode_info);
+	current_mc_date_p = (int *)__pa_nodebug(&current_mc_date);
 
 	*delay_ucode_info_p = 1;
 	*current_mc_date_p = mc_intel->hdr.date;
@@ -741,15 +741,15 @@ load_ucode_intel_bsp(void)
 #ifdef CONFIG_X86_32
 	struct boot_params *boot_params_p;
 
-	boot_params_p = (struct boot_params *)__pa_symbol(&boot_params);
+	boot_params_p = (struct boot_params *)__pa_nodebug(&boot_params);
 	ramdisk_image = boot_params_p->hdr.ramdisk_image;
 	ramdisk_size  = boot_params_p->hdr.ramdisk_size;
 	initrd_start_early = ramdisk_image;
 	initrd_end_early = initrd_start_early + ramdisk_size;
 
 	_load_ucode_intel_bsp(
-		(struct mc_saved_data *)__pa_symbol(&mc_saved_data),
-		(unsigned long *)__pa_symbol(&mc_saved_in_initrd),
+		(struct mc_saved_data *)__pa_nodebug(&mc_saved_data),
+		(unsigned long *)__pa_nodebug(&mc_saved_in_initrd),
 		initrd_start_early, initrd_end_early, &uci);
 #else
 	ramdisk_image = boot_params.hdr.ramdisk_image;
@@ -772,10 +772,10 @@ void __cpuinit load_ucode_intel_ap(void)
 	unsigned long *initrd_start_p;
 
 	mc_saved_in_initrd_p =
-		(unsigned long *)__pa_symbol(mc_saved_in_initrd);
-	mc_saved_data_p = (struct mc_saved_data *)__pa_symbol(&mc_saved_data);
-	initrd_start_p = (unsigned long *)__pa_symbol(&initrd_start);
-	initrd_start_addr = (unsigned long)__pa_symbol(*initrd_start_p);
+		(unsigned long *)__pa_nodebug(mc_saved_in_initrd);
+	mc_saved_data_p = (struct mc_saved_data *)__pa_nodebug(&mc_saved_data);
+	initrd_start_p = (unsigned long *)__pa_nodebug(&initrd_start);
+	initrd_start_addr = (unsigned long)__pa_nodebug(*initrd_start_p);
 #else
 	mc_saved_data_p = &mc_saved_data;
 	mc_saved_in_initrd_p = mc_saved_in_initrd;
-- 
1.8.0.1

