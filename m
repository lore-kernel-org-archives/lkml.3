Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbaLJLTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:19:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39311 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbaLJLTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:19:51 -0500
Date: Wed, 10 Dec 2014 03:19:31 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-25cdb9c86826f8d035d8aaa07fc36832e76bd8a0@git.kernel.org>
Cc: bp@suse.de, hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Reply-To: tglx@linutronix.de, mingo@kernel.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, bp@suse.de
In-Reply-To: <20141208110820.GB20057@pd.tnic>
References: <20141208110820.GB20057@pd.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86/microcode/intel:
  Fish out the stashed microcode for the BSP
Git-Commit-ID: 25cdb9c86826f8d035d8aaa07fc36832e76bd8a0
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

Commit-ID:  25cdb9c86826f8d035d8aaa07fc36832e76bd8a0
Gitweb:     http://git.kernel.org/tip/25cdb9c86826f8d035d8aaa07fc36832e76bd8a0
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 8 Dec 2014 12:08:20 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Dec 2014 11:36:28 +0100

x86/microcode/intel: Fish out the stashed microcode for the BSP

I'm such a moron! The simple solution of saving the BSP patch
for use on resume was too simple (and wrong!), hint:
sizeof(struct microcode_intel).

What needs to be done instead is to fish out the microcode patch
we have stashed previously and apply that on the BSP in case the
late loader hasn't been utilized.

So do that instead.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20141208110820.GB20057@pd.tnic
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/microcode/intel_early.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
index f04d0d6..ec9df6f 100644
--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -34,8 +34,6 @@ static struct mc_saved_data {
 	struct microcode_intel **mc_saved;
 } mc_saved_data;
 
-static struct microcode_intel bsp_patch;
-
 static enum ucode_state
 generic_load_microcode_early(struct microcode_intel **mc_saved_p,
 			     unsigned int mc_saved_count,
@@ -717,8 +715,7 @@ _load_ucode_intel_bsp(struct mc_saved_data *mc_saved_data,
 		      unsigned long *mc_saved_in_initrd,
 		      unsigned long initrd_start_early,
 		      unsigned long initrd_end_early,
-		      struct ucode_cpu_info *uci,
-		      struct microcode_intel *bsp)
+		      struct ucode_cpu_info *uci)
 {
 	enum ucode_state ret;
 
@@ -729,10 +726,8 @@ _load_ucode_intel_bsp(struct mc_saved_data *mc_saved_data,
 	ret = load_microcode(mc_saved_data, mc_saved_in_initrd,
 			     initrd_start_early, uci);
 
-	if (ret == UCODE_OK) {
+	if (ret == UCODE_OK)
 		apply_microcode_early(uci, true);
-		memcpy(bsp, uci->mc, sizeof(*bsp));
-	}
 }
 
 void __init
@@ -741,12 +736,10 @@ load_ucode_intel_bsp(void)
 	u64 ramdisk_image, ramdisk_size;
 	unsigned long initrd_start_early, initrd_end_early;
 	struct ucode_cpu_info uci;
-	struct microcode_intel *bsp_p;
 #ifdef CONFIG_X86_32
 	struct boot_params *boot_params_p;
 
 	boot_params_p = (struct boot_params *)__pa_nodebug(&boot_params);
-	bsp_p	      = (struct microcode_intel *)__pa_nodebug(&bsp_patch);
 	ramdisk_image = boot_params_p->hdr.ramdisk_image;
 	ramdisk_size  = boot_params_p->hdr.ramdisk_size;
 	initrd_start_early = ramdisk_image;
@@ -755,9 +748,8 @@ load_ucode_intel_bsp(void)
 	_load_ucode_intel_bsp(
 		(struct mc_saved_data *)__pa_nodebug(&mc_saved_data),
 		(unsigned long *)__pa_nodebug(&mc_saved_in_initrd),
-		initrd_start_early, initrd_end_early, &uci, bsp_p);
+		initrd_start_early, initrd_end_early, &uci);
 #else
-	bsp_p	      = &bsp_patch;
 	ramdisk_image = boot_params.hdr.ramdisk_image;
 	ramdisk_size  = boot_params.hdr.ramdisk_size;
 	initrd_start_early = ramdisk_image + PAGE_OFFSET;
@@ -765,7 +757,7 @@ load_ucode_intel_bsp(void)
 
 	_load_ucode_intel_bsp(&mc_saved_data, mc_saved_in_initrd,
 			      initrd_start_early, initrd_end_early,
-			      &uci, bsp_p);
+			      &uci);
 #endif
 }
 
@@ -805,11 +797,17 @@ void load_ucode_intel_ap(void)
 void reload_ucode_intel(void)
 {
 	struct ucode_cpu_info uci;
+	enum ucode_state ret;
 
-	if (!bsp_patch.hdr.rev)
+	if (!mc_saved_data.mc_saved_count)
 		return;
 
-	uci.mc = &bsp_patch;
+	collect_cpu_info_early(&uci);
+
+	ret = generic_load_microcode_early(mc_saved_data.mc_saved,
+					   mc_saved_data.mc_saved_count, &uci);
+	if (ret != UCODE_OK)
+		return;
 
 	apply_microcode_early(&uci, false);
 }
