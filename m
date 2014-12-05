Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaLERAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 12:00:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:36587 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaLERAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 12:00:07 -0500
Date: Fri, 5 Dec 2014 18:00:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 fixes for 3.18
Message-ID: <alpine.DEB.2.11.1412051757530.16275@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

Two final fixlets for 3.18:
 - Prevent microcode reload wreckage on 32bit
 - Unbreak cross compilation

Thanks,

	tglx

------------------>
Borislav Petkov (1):
      x86, microcode: Limit the microcode reloading to 64-bit for now

Chris Clayton (1):
      x86: Use $(OBJDUMP) instead of plain objdump


 arch/x86/boot/compressed/Makefile    | 2 +-
 arch/x86/kernel/cpu/microcode/core.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index be1e07d4b596..45abc363dd3e 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -76,7 +76,7 @@ suffix-$(CONFIG_KERNEL_XZ)	:= xz
 suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
 suffix-$(CONFIG_KERNEL_LZ4) 	:= lz4
 
-RUN_SIZE = $(shell objdump -h vmlinux | \
+RUN_SIZE = $(shell $(OBJDUMP) -h vmlinux | \
 	     perl $(srctree)/arch/x86/tools/calc_run_size.pl)
 quiet_cmd_mkpiggy = MKPIGGY $@
       cmd_mkpiggy = $(obj)/mkpiggy $< $(RUN_SIZE) > $@ || ( rm -f $@ ; false )
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 2ce9051174e6..08fe6e8a726e 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -465,6 +465,7 @@ static void mc_bp_resume(void)
 
 	if (uci->valid && uci->mc)
 		microcode_ops->apply_microcode(cpu);
+#ifdef CONFIG_X86_64
 	else if (!uci->mc)
 		/*
 		 * We might resume and not have applied late microcode but still
@@ -473,6 +474,7 @@ static void mc_bp_resume(void)
 		 * applying patches early on the APs.
 		 */
 		load_ucode_ap();
+#endif
 }
 
 static struct syscore_ops mc_syscore_ops = {
