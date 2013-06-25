Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3FYTLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:11:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab3FYSdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>, Helge Deller <deller@gmx.de>
Subject: [ 19/95] parisc: make interrupt and interruption stack allocation reentrant
Date: Tue, 25 Jun 2013 11:32:06 -0700
Message-Id: <20130625182155.825009429@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit b63a2bbc0b9b106a93e11952ab057e2408f2eb02 upstream.

The get_stack_use_cr30 and get_stack_use_r30 macros allocate a stack
frame for external interrupts and interruptions requiring a stack frame.
They are currently not reentrant in that they save register context
before the stack is set or adjusted.

I have observed a number of system crashes where there was clear
evidence of stack corruption during interrupt processing, and as a
result register corruption. Some interruptions can still occur during
interruption processing, however external interrupts are disabled and
data TLB misses don't occur for absolute accesses. So, it's not entirely
clear what triggers this issue. Also, if an interruption occurs when
Q=0, it is generally not possible to recover as the shadowed registers
are not copied.

The attached patch reworks the get_stack_use_cr30 and get_stack_use_r30
macros to allocate stack before doing register saves. The new code is a
couple of instructions shorter than the old implementation. Thus, it's
an improvement even if it doesn't fully resolve the stack corruption
issue. Based on limited testing, it improves SMP system stability.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/asm/assembly.h |    1 -
 arch/parisc/kernel/entry.S         |   19 ++++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/arch/parisc/include/asm/assembly.h
+++ b/arch/parisc/include/asm/assembly.h
@@ -438,7 +438,6 @@
 	SAVE_SP  (%sr4, PT_SR4 (\regs))
 	SAVE_SP  (%sr5, PT_SR5 (\regs))
 	SAVE_SP  (%sr6, PT_SR6 (\regs))
-	SAVE_SP  (%sr7, PT_SR7 (\regs))
 
 	SAVE_CR  (%cr17, PT_IASQ0(\regs))
 	mtctl	 %r0,	%cr17
--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -65,15 +65,11 @@
 	rsm	PSW_SM_I, %r0	/* barrier for "Relied upon Translation */
 	mtsp	%r0, %sr4
 	mtsp	%r0, %sr5
-	mfsp	%sr7, %r1
-	or,=    %r0,%r1,%r0	/* Only save sr7 in sr3 if sr7 != 0 */
-	mtsp	%r1, %sr3
+	mtsp	%r0, %sr6
 	tovirt_r1 %r29
 	load32	KERNEL_PSW, %r1
 
 	rsm     PSW_SM_QUIET,%r0	/* second "heavy weight" ctl op */
-	mtsp	%r0, %sr6
-	mtsp	%r0, %sr7
 	mtctl	%r0, %cr17	/* Clear IIASQ tail */
 	mtctl	%r0, %cr17	/* Clear IIASQ head */
 	mtctl	%r1, %ipsw
@@ -119,17 +115,20 @@
 
 	/* we save the registers in the task struct */
 
+	copy	%r30, %r17
 	mfctl   %cr30, %r1
+	ldo	THREAD_SZ_ALGN(%r1), %r30
+	mtsp	%r0,%sr7
+	mtsp	%r16,%sr3
 	tophys  %r1,%r9
 	LDREG	TI_TASK(%r9), %r1	/* thread_info -> task_struct */
 	tophys  %r1,%r9
 	ldo     TASK_REGS(%r9),%r9
-	STREG   %r30, PT_GR30(%r9)
+	STREG   %r17,PT_GR30(%r9)
 	STREG   %r29,PT_GR29(%r9)
 	STREG   %r26,PT_GR26(%r9)
+	STREG	%r16,PT_SR7(%r9)
 	copy    %r9,%r29
-	mfctl   %cr30, %r1
-	ldo	THREAD_SZ_ALGN(%r1), %r30
 	.endm
 
 	.macro  get_stack_use_r30
@@ -137,10 +136,12 @@
 	/* we put a struct pt_regs on the stack and save the registers there */
 
 	tophys  %r30,%r9
-	STREG   %r30,PT_GR30(%r9)
+	copy	%r30,%r1
 	ldo	PT_SZ_ALGN(%r30),%r30
+	STREG   %r1,PT_GR30(%r9)
 	STREG   %r29,PT_GR29(%r9)
 	STREG   %r26,PT_GR26(%r9)
+	STREG	%r16,PT_SR7(%r9)
 	copy    %r9,%r29
 	.endm
 


