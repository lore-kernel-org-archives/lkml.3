Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843AbbAGC5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:57:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683AbbAGBwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.18 46/84] x86/microcode/intel: Fish out the stashed microcode for the BSP
Date: Tue,  6 Jan 2015 17:49:49 -0800
Message-Id: <20150107014030.513813859@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@suse.de>

commit 25cdb9c86826f8d035d8aaa07fc36832e76bd8a0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/microcode/intel_early.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

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
@@ -717,8 +715,7 @@ _load_ucode_intel_bsp(struct mc_saved_da
 		      unsigned long *mc_saved_in_initrd,
 		      unsigned long initrd_start_early,
 		      unsigned long initrd_end_early,
-		      struct ucode_cpu_info *uci,
-		      struct microcode_intel *bsp)
+		      struct ucode_cpu_info *uci)
 {
 	enum ucode_state ret;
 
@@ -729,10 +726,8 @@ _load_ucode_intel_bsp(struct mc_saved_da
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


