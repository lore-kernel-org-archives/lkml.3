Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab3GWVC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:02:27 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:37071 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941Ab3GWVCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:02:25 -0400
Date: Tue, 23 Jul 2013 23:02:21 +0200
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] x86, AMD: saved applied, not loaded microcode for
 reloading on resume
Message-ID: <20130723230221.34d29488@googlemail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Save the amd_bsp_mpb on apply, not on load. Otherwise someone could
  later load an older microcode file via load_microcode_amd() that
  would overwrite amd_bsp_mpb, but would not be applied to the CPUs
(apply_microcode_amd() checks the current patchlevel, but the copy code
in load_microcode_adm() did not. If somehow cleanup() gets called and
  clears pcache find_patch() could return return older patches then the
  currently installed microcode)
* Save the amd_bsp_mpb on every update. Otherwise, if someone would
  update the microcode after offlining the BSP, these updates would not
  get saved and would be lost on resume.
* apply_ucode_in_initrd() now also needs to save amd_bsp_mbp, because
load_microcode_amd() its no longer doing this and its not using
apply_microcode_amd().

Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>

---

Removing this hunk from load_microcode_amd() also allows me to kill the
cpu parameter for that function in the next patch...

--- a/arch/x86/kernel/microcode_amd.c	2013-07-23 19:43:30.359517091 +0200
+++ b/arch/x86/kernel/microcode_amd.c	2013-07-23 20:05:04.469506188 +0200
@@ -228,6 +228,12 @@ int apply_microcode_amd(int cpu)
 	pr_info("CPU%d: new patch_level=0x%08x\n", cpu,
 		mc_amd->hdr.patch_id);
 
+#if defined(CONFIG_MICROCODE_AMD_EARLY) && defined(CONFIG_X86_32)
+	/* save applied patch for early load */
+	memset(amd_bsp_mpb, 0, MPB_MAX_SIZE);
+	memcpy(amd_bsp_mpb, p->data, min_t(u32, ksize(p->data), MPB_MAX_SIZE));
+#endif
+
 	uci->cpu_sig.rev = mc_amd->hdr.patch_id;
 	c->microcode = mc_amd->hdr.patch_id;
 
@@ -385,17 +391,6 @@ enum ucode_state load_microcode_amd(int
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
 
--- a/arch/x86/kernel/microcode_amd_early.c	2013-07-23 20:00:04.889508712 +0200
+++ b/arch/x86/kernel/microcode_amd_early.c	2013-07-23 20:05:14.969506099 +0200
@@ -170,6 +170,13 @@ static void apply_ucode_in_initrd(void *
 		mc = (struct microcode_amd *)(data + SECTION_HDR_SIZE);
 		if (eq_id == mc->hdr.processor_rev_id && rev < mc->hdr.patch_id)
 			if (__apply_microcode_amd(mc) == 0) {
+#ifdef CONFIG_X86_32
+				/* save applied patch for early load */
+				memset((void *)__pa(amd_bsp_mpb), 0,
+					MPB_MAX_SIZE);
+				memcpy((void *)__pa(amd_bsp_mpb), mc,
+					min_t(u32, header[1], MPB_MAX_SIZE));
+#endif
 				rev = mc->hdr.patch_id;
 				*new_rev = rev;
 			}
