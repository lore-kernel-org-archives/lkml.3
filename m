Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbaLHLIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:08:25 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53624 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbaLHLIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:08:23 -0500
Date: Mon, 8 Dec 2014 12:08:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: x86-ml <x86@kernel.org>
Cc: linux-tip-commits@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        bp@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [tip:x86/microcode] x86, microcode: Reload microcode on resume
Message-ID: <20141208110820.GB20057@pd.tnic>
References: <tip-fbae4ba8c4a387e306adc9c710e5c225cece7678@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-fbae4ba8c4a387e306adc9c710e5c225cece7678@git.kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 01:43:28AM -0800, tip-bot for Borislav Petkov wrote:
> Commit-ID:  fbae4ba8c4a387e306adc9c710e5c225cece7678
> Gitweb:     http://git.kernel.org/tip/fbae4ba8c4a387e306adc9c710e5c225cece7678
> Author:     Borislav Petkov <bp@suse.de>
> AuthorDate: Wed, 3 Dec 2014 17:21:41 +0100
> Committer:  Borislav Petkov <bp@suse.de>
> CommitDate: Sat, 6 Dec 2014 13:03:03 +0100
> 
> x86, microcode: Reload microcode on resume
> 
> Normally, we do reapply microcode on resume. However, in the cases where
> that microcode comes from the early loader and the late loader hasn't
> been utilized yet, there's no easy way for us to go and apply the patch
> applied during boot by the early loader.
> 
> Thus, reuse the patch stashed by the early loader for the BSP.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>

Yeah, that was too simple. Here's the real fix, please apply ontop.

Thanks and sorry for the fumble.

---
From: Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, microcode, intel: Fish out the stashed microcode for the BSP

I'm such a moron! The simple solution of saving the BSP patch for
use on resume was too simple (and wrong!), hint: sizeof(struct
microcode_intel).

What needs to be done instead is to fish out the microcode patch we have
stashed previously and apply that on the BSP in case the late loader
hasn't been utilized.

So do that instead.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/microcode/intel_early.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
index f04d0d6638ca..ec9df6f9cd47 100644
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
-- 
2.0.0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
