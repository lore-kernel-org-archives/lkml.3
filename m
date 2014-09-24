Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaIXHhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:37:05 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:49117 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaIXHhE convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 24 Sep 2014 03:37:04 -0400
Message-Id: <542290BC020000780003807D@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Wed, 24 Sep 2014 08:37:00 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: improve cmpxchg16b_emu.S
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- don't include unneeded headers
- don't open-code PER_CPU_VAR()
- drop redundant entry point label
- complete unwind annotations
- use .L prefix on local label to not clutter the symbol table

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/lib/cmpxchg16b_emu.S |   32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

--- 3.17-rc6/arch/x86/lib/cmpxchg16b_emu.S
+++ 3.17-rc6-x86_64-improve-cmpxchg16b_emu/arch/x86/lib/cmpxchg16b_emu.S
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
 



