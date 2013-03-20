Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab3CTDMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 23:12:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43029 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375Ab3CTDMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 23:12:45 -0400
Date: Tue, 19 Mar 2013 20:11:27 -0700
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-c83a9d5e425d4678b05ca058fec6254f18601474@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp, fenghua.yu@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, penguin-kernel@I-love.SAKURA.ne.jp,
        tglx@linutronix.de
In-Reply-To: <1363705484-27645-1-git-send-email-fenghua.yu@intel.com>
References: <1363705484-27645-1-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32, microcode_intel_early:
  Fix crash with CONFIG_DEBUG_VIRTUAL
Git-Commit-ID: c83a9d5e425d4678b05ca058fec6254f18601474
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 19 Mar 2013 20:11:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c83a9d5e425d4678b05ca058fec6254f18601474
Gitweb:     http://git.kernel.org/tip/c83a9d5e425d4678b05ca058fec6254f18601474
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 19 Mar 2013 08:04:44 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 19 Mar 2013 19:51:08 -0700

x86-32, microcode_intel_early: Fix crash with CONFIG_DEBUG_VIRTUAL

In 32-bit, __pa_symbol() in CONFIG_DEBUG_VIRTUAL accesses kernel data
(e.g.  max_low_pfn) that not only hasn't been setup yet in such early
boot phase, but since we are in linear mode, cannot even be detected
as uninitialized.

Thus, use __pa_nodebug() rather than __pa_symbol() to get a global
symbol's physical address.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1363705484-27645-1-git-send-email-fenghua.yu@intel.com
Reported-and-tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
