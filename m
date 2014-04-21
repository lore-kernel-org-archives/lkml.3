Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbaDUTBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 15:01:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40942 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbaDUTBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 15:01:44 -0400
Date: Mon, 21 Apr 2014 12:01:12 -0700
Message-Id: <201404211901.s3LJ1Cra010895@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/vdso fix for v3.15-rc3
Cc: Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a single build fix for building with gold as opposed to GNU
ld.  It got queued up separately and was expected to be pushed during
the merge window, but it got left behind.

The following changes since commit 37c975545ec63320789962bf307f000f08fabd48:

  x86, vdso: Fix the symbol versions on the 32-bit vDSO (2014-03-30 10:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-vdso-for-linus

  x86, vdso: Make the vdso linker script compatible with Gold (2014-04-03 12:03:59 -0700)

----------------------------------------------------------------
Andy Lutomirski (1):
      x86, vdso: Make the vdso linker script compatible with Gold

 arch/x86/vdso/vdso-layout.lds.S | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 2e263f367b13..9df017ab2285 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -9,12 +9,9 @@ SECTIONS
 #ifdef BUILD_VDSO32
 #include <asm/vdso32.h>
 
-	.hpet_sect : {
-		hpet_page = . - VDSO_OFFSET(VDSO_HPET_PAGE);
-	} :text :hpet_sect
+	hpet_page = . - VDSO_OFFSET(VDSO_HPET_PAGE);
 
-	.vvar_sect : {
-		vvar = . - VDSO_OFFSET(VDSO_VVAR_PAGE);
+	vvar = . - VDSO_OFFSET(VDSO_VVAR_PAGE);
 
 	/* Place all vvars at the offsets in asm/vvar.h. */
 #define EMIT_VVAR(name, offset) vvar_ ## name = vvar + offset;
@@ -22,7 +19,6 @@ SECTIONS
 #include <asm/vvar.h>
 #undef __VVAR_KERNEL_LDS
 #undef EMIT_VVAR
-	} :text :vvar_sect
 #endif
 	. = SIZEOF_HEADERS;
 
@@ -61,7 +57,12 @@ SECTIONS
 	 */
 	. = ALIGN(0x100);
 
-	.text		: { *(.text*) }			:text	=0x90909090
+	.text		: { *(.text*) }			:text	=0x90909090,
+
+	/*
+	 * The comma above works around a bug in gold:
+	 * https://sourceware.org/bugzilla/show_bug.cgi?id=16804
+	 */
 
 	/DISCARD/ : {
 		*(.discard)
@@ -84,8 +85,4 @@ PHDRS
 	dynamic		PT_DYNAMIC	FLAGS(4);		/* PF_R */
 	note		PT_NOTE		FLAGS(4);		/* PF_R */
 	eh_frame_hdr	PT_GNU_EH_FRAME;
-#ifdef BUILD_VDSO32
-	vvar_sect	PT_NULL		FLAGS(4);		/* PF_R */
-	hpet_sect	PT_NULL		FLAGS(4);		/* PF_R */
-#endif
 }
