Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbaJHIKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:10:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34822 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbaJHIKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:10:12 -0400
Date: Wed, 8 Oct 2014 01:09:34 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-3f63572187f5ae6a0a9e5ebee88b57e6f71c3cd4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de
In-Reply-To: <542290BC020000780003807D@mail.emea.novell.com>
References: <542290BC020000780003807D@mail.emea.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Improve cmpxchg16b_emu.S
Git-Commit-ID: 3f63572187f5ae6a0a9e5ebee88b57e6f71c3cd4
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

Commit-ID:  3f63572187f5ae6a0a9e5ebee88b57e6f71c3cd4
Gitweb:     http://git.kernel.org/tip/3f63572187f5ae6a0a9e5ebee88b57e6f71c3cd4
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Wed, 24 Sep 2014 08:37:00 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 8 Oct 2014 10:05:49 +0200

x86: Improve cmpxchg16b_emu.S

- don't include unneeded headers
- don't open-code PER_CPU_VAR()
- drop redundant entry point label
- complete unwind annotations
- use .L prefix on local label to not clutter the symbol table

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/542290BC020000780003807D@mail.emea.novell.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/lib/cmpxchg16b_emu.S | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/arch/x86/lib/cmpxchg16b_emu.S b/arch/x86/lib/cmpxchg16b_emu.S
index 1e572c5..40a1725 100644
--- a/arch/x86/lib/cmpxchg16b_emu.S
+++ b/arch/x86/lib/cmpxchg16b_emu.S
@@ -6,15 +6,8 @@
  *
  */
 #include <linux/linkage.h>
-#include <asm/alternative-asm.h>
-#include <asm/frame.h>
 #include <asm/dwarf2.h>
-
-#ifdef CONFIG_SMP
-#define SEG_PREFIX %gs:
-#else
-#define SEG_PREFIX
-#endif
+#include <asm/percpu.h>
 
 .text
 
@@ -39,24 +32,25 @@ CFI_STARTPROC
 # *atomic* on a single cpu (as provided by the this_cpu_xx class of
 # macros).
 #
-this_cpu_cmpxchg16b_emu:
-	pushf
+	pushfq_cfi
 	cli
 
-	cmpq SEG_PREFIX(%rsi), %rax
-	jne not_same
-	cmpq SEG_PREFIX 8(%rsi), %rdx
-	jne not_same
+	cmpq PER_CPU_VAR((%rsi)), %rax
+	jne .Lnot_same
+	cmpq PER_CPU_VAR(8(%rsi)), %rdx
+	jne .Lnot_same
 
-	movq %rbx, SEG_PREFIX(%rsi)
-	movq %rcx, SEG_PREFIX 8(%rsi)
+	movq %rbx, PER_CPU_VAR((%rsi))
+	movq %rcx, PER_CPU_VAR(8(%rsi))
 
-	popf
+	CFI_REMEMBER_STATE
+	popfq_cfi
 	mov $1, %al
 	ret
 
- not_same:
-	popf
+	CFI_RESTORE_STATE
+.Lnot_same:
+	popfq_cfi
 	xor %al,%al
 	ret
 
