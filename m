Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaIXHkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:40:17 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:49241 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaIXHkP convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 24 Sep 2014 03:40:15 -0400
Message-Id: <5422917E0200007800038081@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Wed, 24 Sep 2014 08:40:14 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] ix86: improve cmpxchg8b_emu.S
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- don't include unneeded headers
- drop redundant entry point label
- complete unwind annotations
- use .L prefix on local labels to not clutter the symbol table

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/lib/cmpxchg8b_emu.S |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- 3.17-rc6/arch/x86/lib/cmpxchg8b_emu.S
+++ 3.17-rc6-ix86-improve-cmpxchg8b_emu/arch/x86/lib/cmpxchg8b_emu.S
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



