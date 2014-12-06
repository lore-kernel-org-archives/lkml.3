Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaLFPby (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:31:54 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54219 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbaLFPbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:31:51 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] x86, microcode: Reloading fixes
Date: Sat,  6 Dec 2014 16:31:45 +0100
Message-Id: <1417879908-4851-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi guys,

please pull three fixes for the microcode loader. More specifically,
microcode reloading for 3.19. Patches are against tip/x86/microcode.

I have this also as a tag if you'd prefer to pull:

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/microcode_fixes_for_3.19

This will have a conflict when merging into Linus' tree after
tip/x86/urgent has went in for 3.18 but resolving it should be easy. The
final result should be this with the ifdef dropped:

---
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 08fe6e8a726e..15c29096136b 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -465,16 +465,8 @@ static void mc_bp_resume(void)
 
        if (uci->valid && uci->mc)
                microcode_ops->apply_microcode(cpu);
-#ifdef CONFIG_X86_64
        else if (!uci->mc)
-               /*
-                * We might resume and not have applied late microcode but still
-                * have a newer patch stashed from the early loader. We don't
-                * have it in uci->mc so we have to load it the same way we're
-                * applying patches early on the APs.
-                */
-               load_ucode_ap();
-#endif
+               reload_early_microcode();
 }
--

Thanks.

Boris Ostrovsky (1):
  x86, microcode: Don't initialize microcode code on paravirt

Borislav Petkov (2):
  x86, microcode, intel: Drop unused parameter
  x86, microcode: Reload microcode on resume

 arch/x86/include/asm/microcode.h            |  2 ++
 arch/x86/include/asm/microcode_amd.h        |  2 ++
 arch/x86/include/asm/microcode_intel.h      |  2 ++
 arch/x86/kernel/cpu/microcode/amd_early.c   | 18 +++++++++++
 arch/x86/kernel/cpu/microcode/core.c        | 10 ++----
 arch/x86/kernel/cpu/microcode/core_early.c  | 21 +++++++++++++
 arch/x86/kernel/cpu/microcode/intel_early.c | 48 +++++++++++++++++++++++------
 7 files changed, 85 insertions(+), 18 deletions(-)

-- 
2.0.0

