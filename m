Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaDCTQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 15:16:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39339 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaDCTQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 15:16:51 -0400
Date: Thu, 3 Apr 2014 12:16:18 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-378ed3ccd2a0404d031e771b65aa3af221ea8aea@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, markus@trippelsdorf.de, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, markus@trippelsdorf.de,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <243fa205098d112ec759c9b1b26785c09f399833.1396547532.git.luto@amacapital.net>
References: <243fa205098d112ec759c9b1b26785c09f399833.1396547532.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso:
  Make the vdso linker script compatible with Gold
Git-Commit-ID: 378ed3ccd2a0404d031e771b65aa3af221ea8aea
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

Commit-ID:  378ed3ccd2a0404d031e771b65aa3af221ea8aea
Gitweb:     http://git.kernel.org/tip/378ed3ccd2a0404d031e771b65aa3af221ea8aea
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Thu, 3 Apr 2014 10:53:43 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 3 Apr 2014 12:03:59 -0700

x86, vdso: Make the vdso linker script compatible with Gold

Gold can't parse the script due to:
https://sourceware.org/bugzilla/show_bug.cgi?id=16804

With a workaround in place for that issue, Gold 2.23 crashes due to:
https://sourceware.org/bugzilla/show_bug.cgi?id=15355

This works around the former bug and avoids the second by removing
the unnecessary vvar and hpet sections and segments.  The vdso and
hpet symbols are still there, and nothing needed the sections or
segments.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/243fa205098d112ec759c9b1b26785c09f399833.1396547532.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/vdso/vdso-layout.lds.S | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 2e263f3..9df017a 100644
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
