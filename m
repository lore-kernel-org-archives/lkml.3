Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaJHIKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:10:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34824 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbaJHIKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:10:14 -0400
Date: Wed, 8 Oct 2014 01:09:48 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-5f1d919a8ca15f450c749227bc5e2e18f3cbfdb4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de
In-Reply-To: <5422917E0200007800038081@mail.emea.novell.com>
References: <5422917E0200007800038081@mail.emea.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Improve cmpxchg8b_emu.S
Git-Commit-ID: 5f1d919a8ca15f450c749227bc5e2e18f3cbfdb4
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

Commit-ID:  5f1d919a8ca15f450c749227bc5e2e18f3cbfdb4
Gitweb:     http://git.kernel.org/tip/5f1d919a8ca15f450c749227bc5e2e18f3cbfdb4
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Wed, 24 Sep 2014 08:40:14 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 8 Oct 2014 10:05:49 +0200

x86: Improve cmpxchg8b_emu.S

- don't include unneeded headers
- drop redundant entry point label
- complete unwind annotations
- use .L prefix on local labels to not clutter the symbol table

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/5422917E0200007800038081@mail.emea.novell.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/lib/cmpxchg8b_emu.S | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/lib/cmpxchg8b_emu.S b/arch/x86/lib/cmpxchg8b_emu.S
index 828cb71..b4807fce 100644
--- a/arch/x86/lib/cmpxchg8b_emu.S
+++ b/arch/x86/lib/cmpxchg8b_emu.S
@@ -7,11 +7,8 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/alternative-asm.h>
-#include <asm/frame.h>
 #include <asm/dwarf2.h>
 
-
 .text
 
 /*
@@ -30,27 +27,28 @@ CFI_STARTPROC
 # set the whole ZF thing (caller will just compare
 # eax:edx with the expected value)
 #
-cmpxchg8b_emu:
-	pushfl
+	pushfl_cfi
 	cli
 
 	cmpl  (%esi), %eax
-	jne not_same
+	jne .Lnot_same
 	cmpl 4(%esi), %edx
-	jne half_same
+	jne .Lhalf_same
 
 	movl %ebx,  (%esi)
 	movl %ecx, 4(%esi)
 
-	popfl
+	CFI_REMEMBER_STATE
+	popfl_cfi
 	ret
 
- not_same:
+	CFI_RESTORE_STATE
+.Lnot_same:
 	movl  (%esi), %eax
- half_same:
+.Lhalf_same:
 	movl 4(%esi), %edx
 
-	popfl
+	popfl_cfi
 	ret
 
 CFI_ENDPROC
