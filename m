Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573Ab3GPRGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:06:10 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:40649 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483Ab3GPRF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:05:26 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org
Subject: [PATCH 6/7] alpha: Generate dwarf2 unwind info for various kernel entry points.
Date: Tue, 16 Jul 2013 10:04:39 -0700
Message-Id: <1373994280-12047-7-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373994280-12047-1-git-send-email-rth@twiddle.net>
References: <1373994280-12047-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having unwind info past the PALcode generated stack frame makes
debugging the kernel significantly easier.

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/kernel/entry.S | 399 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 288 insertions(+), 111 deletions(-)

diff --git a/arch/alpha/kernel/entry.S b/arch/alpha/kernel/entry.S
index f62a994..a969b95 100644
--- a/arch/alpha/kernel/entry.S
+++ b/arch/alpha/kernel/entry.S
@@ -12,11 +12,32 @@
 
 	.text
 	.set noat
+	.cfi_sections	.debug_frame
 
 /* Stack offsets.  */
 #define SP_OFF			184
 #define SWITCH_STACK_SIZE	320
 
+.macro	CFI_START_OSF_FRAME	func
+	.align	4
+	.globl	\func
+	.type	\func,@function
+\func:
+	.cfi_startproc simple
+	.cfi_return_column 64
+	.cfi_def_cfa	$sp, 48
+	.cfi_rel_offset	64, 8
+	.cfi_rel_offset	$gp, 16
+	.cfi_rel_offset	$16, 24
+	.cfi_rel_offset	$17, 32
+	.cfi_rel_offset	$18, 40
+.endm
+
+.macro	CFI_END_OSF_FRAME	func
+	.cfi_endproc
+	.size	\func, . - \func
+.endm
+
 /*
  * This defines the normal kernel pt-regs layout.
  *
@@ -27,100 +48,158 @@
  * the palcode-provided values are available to the signal handler.
  */
 
-#define SAVE_ALL			\
-	subq	$sp, SP_OFF, $sp;	\
-	stq	$0, 0($sp);		\
-	stq	$1, 8($sp);		\
-	stq	$2, 16($sp);		\
-	stq	$3, 24($sp);		\
-	stq	$4, 32($sp);		\
-	stq	$28, 144($sp);		\
-	lda	$2, alpha_mv;		\
-	stq	$5, 40($sp);		\
-	stq	$6, 48($sp);		\
-	stq	$7, 56($sp);		\
-	stq	$8, 64($sp);		\
-	stq	$19, 72($sp);		\
-	stq	$20, 80($sp);		\
-	stq	$21, 88($sp);		\
-	ldq	$2, HAE_CACHE($2);	\
-	stq	$22, 96($sp);		\
-	stq	$23, 104($sp);		\
-	stq	$24, 112($sp);		\
-	stq	$25, 120($sp);		\
-	stq	$26, 128($sp);		\
-	stq	$27, 136($sp);		\
-	stq	$2, 152($sp);		\
-	stq	$16, 160($sp);		\
-	stq	$17, 168($sp);		\
+.macro	SAVE_ALL
+	subq	$sp, SP_OFF, $sp
+	.cfi_adjust_cfa_offset	SP_OFF
+	stq	$0, 0($sp)
+	stq	$1, 8($sp)
+	stq	$2, 16($sp)
+	stq	$3, 24($sp)
+	stq	$4, 32($sp)
+	stq	$28, 144($sp)
+	.cfi_rel_offset	$0, 0
+	.cfi_rel_offset $1, 8
+	.cfi_rel_offset	$2, 16
+	.cfi_rel_offset	$3, 24
+	.cfi_rel_offset	$4, 32
+	.cfi_rel_offset	$28, 144
+	lda	$2, alpha_mv
+	stq	$5, 40($sp)
+	stq	$6, 48($sp)
+	stq	$7, 56($sp)
+	stq	$8, 64($sp)
+	stq	$19, 72($sp)
+	stq	$20, 80($sp)
+	stq	$21, 88($sp)
+	ldq	$2, HAE_CACHE($2)
+	stq	$22, 96($sp)
+	stq	$23, 104($sp)
+	stq	$24, 112($sp)
+	stq	$25, 120($sp)
+	stq	$26, 128($sp)
+	stq	$27, 136($sp)
+	stq	$2, 152($sp)
+	stq	$16, 160($sp)
+	stq	$17, 168($sp)
 	stq	$18, 176($sp)
+	.cfi_rel_offset	$5, 40
+	.cfi_rel_offset	$6, 48
+	.cfi_rel_offset	$7, 56
+	.cfi_rel_offset	$8, 64
+	.cfi_rel_offset $19, 72
+	.cfi_rel_offset	$20, 80
+	.cfi_rel_offset	$21, 88
+	.cfi_rel_offset $22, 96
+	.cfi_rel_offset	$23, 104
+	.cfi_rel_offset	$24, 112
+	.cfi_rel_offset	$25, 120
+	.cfi_rel_offset	$26, 128
+	.cfi_rel_offset	$27, 136
+.endm
 
-#define RESTORE_ALL			\
-	lda	$19, alpha_mv;		\
-	ldq	$0, 0($sp);		\
-	ldq	$1, 8($sp);		\
-	ldq	$2, 16($sp);		\
-	ldq	$3, 24($sp);		\
-	ldq	$21, 152($sp);		\
-	ldq	$20, HAE_CACHE($19);	\
-	ldq	$4, 32($sp);		\
-	ldq	$5, 40($sp);		\
-	ldq	$6, 48($sp);		\
-	ldq	$7, 56($sp);		\
-	subq	$20, $21, $20;		\
-	ldq	$8, 64($sp);		\
-	beq	$20, 99f;		\
-	ldq	$20, HAE_REG($19);	\
-	stq	$21, HAE_CACHE($19);	\
-	stq	$21, 0($20);		\
-99:;					\
-	ldq	$19, 72($sp);		\
-	ldq	$20, 80($sp);		\
-	ldq	$21, 88($sp);		\
-	ldq	$22, 96($sp);		\
-	ldq	$23, 104($sp);		\
-	ldq	$24, 112($sp);		\
-	ldq	$25, 120($sp);		\
-	ldq	$26, 128($sp);		\
-	ldq	$27, 136($sp);		\
-	ldq	$28, 144($sp);		\
+.macro	RESTORE_ALL
+	lda	$19, alpha_mv
+	ldq	$0, 0($sp)
+	ldq	$1, 8($sp)
+	ldq	$2, 16($sp)
+	ldq	$3, 24($sp)
+	ldq	$21, 152($sp)
+	ldq	$20, HAE_CACHE($19)
+	ldq	$4, 32($sp)
+	ldq	$5, 40($sp)
+	ldq	$6, 48($sp)
+	ldq	$7, 56($sp)
+	subq	$20, $21, $20
+	ldq	$8, 64($sp)
+	beq	$20, 99f
+	ldq	$20, HAE_REG($19)
+	stq	$21, HAE_CACHE($19)
+	stq	$21, 0($20)
+99:	ldq	$19, 72($sp)
+	ldq	$20, 80($sp)
+	ldq	$21, 88($sp)
+	ldq	$22, 96($sp)
+	ldq	$23, 104($sp)
+	ldq	$24, 112($sp)
+	ldq	$25, 120($sp)
+	ldq	$26, 128($sp)
+	ldq	$27, 136($sp)
+	ldq	$28, 144($sp)
 	addq	$sp, SP_OFF, $sp
+	.cfi_restore	$0
+	.cfi_restore	$1
+	.cfi_restore	$2
+	.cfi_restore	$3
+	.cfi_restore	$4
+	.cfi_restore	$5
+	.cfi_restore	$6
+	.cfi_restore	$7
+	.cfi_restore	$8
+	.cfi_restore	$19
+	.cfi_restore	$20
+	.cfi_restore	$21
+	.cfi_restore	$22
+	.cfi_restore	$23
+	.cfi_restore	$24
+	.cfi_restore	$25
+	.cfi_restore	$26
+	.cfi_restore	$27
+	.cfi_restore	$28
+	.cfi_adjust_cfa_offset	-SP_OFF
+.endm
+
+.macro	DO_SWITCH_STACK
+	bsr	$1, do_switch_stack
+	.cfi_adjust_cfa_offset	SWITCH_STACK_SIZE
+	.cfi_rel_offset	$9, 0
+	.cfi_rel_offset	$10, 8
+	.cfi_rel_offset	$11, 16
+	.cfi_rel_offset	$12, 24
+	.cfi_rel_offset	$13, 32
+	.cfi_rel_offset	$14, 40
+	.cfi_rel_offset	$15, 48
+	/* We don't really care about the FP registers for debugging.  */
+.endm
+
+.macro	UNDO_SWITCH_STACK
+	bsr	$1, undo_switch_stack
+	.cfi_restore	$9
+	.cfi_restore	$10
+	.cfi_restore	$11
+	.cfi_restore	$12
+	.cfi_restore	$13
+	.cfi_restore	$14
+	.cfi_restore	$15
+	.cfi_adjust_cfa_offset	-SWITCH_STACK_SIZE
+.endm
 
 /*
  * Non-syscall kernel entry points.
  */
 
-	.align	4
-	.globl	entInt
-	.ent	entInt
-entInt:
+CFI_START_OSF_FRAME entInt
 	SAVE_ALL
 	lda	$8, 0x3fff
 	lda	$26, ret_from_sys_call
 	bic	$sp, $8, $8
 	mov	$sp, $19
 	jsr	$31, do_entInt
-.end entInt
+CFI_END_OSF_FRAME entInt
 
-	.align	4
-	.globl	entArith
-	.ent	entArith
-entArith:
+CFI_START_OSF_FRAME entArith
 	SAVE_ALL
 	lda	$8, 0x3fff
 	lda	$26, ret_from_sys_call
 	bic	$sp, $8, $8
 	mov	$sp, $18
 	jsr	$31, do_entArith
-.end entArith
+CFI_END_OSF_FRAME entArith
 
-	.align	4
-	.globl	entMM
-	.ent	entMM
-entMM:
+CFI_START_OSF_FRAME entMM
 	SAVE_ALL
 /* save $9 - $15 so the inline exception code can manipulate them.  */
 	subq	$sp, 56, $sp
+	.cfi_adjust_cfa_offset	56
 	stq	$9, 0($sp)
 	stq	$10, 8($sp)
 	stq	$11, 16($sp)
@@ -128,6 +207,13 @@ entMM:
 	stq	$13, 32($sp)
 	stq	$14, 40($sp)
 	stq	$15, 48($sp)
+	.cfi_rel_offset	$9, 0
+	.cfi_rel_offset	$10, 8
+	.cfi_rel_offset	$11, 16
+	.cfi_rel_offset	$12, 24
+	.cfi_rel_offset	$13, 32
+	.cfi_rel_offset	$14, 40
+	.cfi_rel_offset	$15, 48
 	addq	$sp, 56, $19
 /* handle the fault */
 	lda	$8, 0x3fff
@@ -142,28 +228,33 @@ entMM:
 	ldq	$14, 40($sp)
 	ldq	$15, 48($sp)
 	addq	$sp, 56, $sp
+	.cfi_restore	$9
+	.cfi_restore	$10
+	.cfi_restore	$11
+	.cfi_restore	$12
+	.cfi_restore	$13
+	.cfi_restore	$14
+	.cfi_restore	$15
+	.cfi_adjust_cfa_offset	-56
 /* finish up the syscall as normal.  */
 	br	ret_from_sys_call
-.end entMM
+CFI_END_OSF_FRAME entMM
 
-	.align	4
-	.globl	entIF
-	.ent	entIF
-entIF:
+CFI_START_OSF_FRAME entIF
 	SAVE_ALL
 	lda	$8, 0x3fff
 	lda	$26, ret_from_sys_call
 	bic	$sp, $8, $8
 	mov	$sp, $17
 	jsr	$31, do_entIF
-.end entIF
+CFI_END_OSF_FRAME entIF
 
-	.align	4
-	.globl	entUna
-	.ent	entUna
-entUna:
+CFI_START_OSF_FRAME entUna
 	lda	$sp, -256($sp)
+	.cfi_adjust_cfa_offset	256
 	stq	$0, 0($sp)
+	.cfi_rel_offset	$0, 0
+	.cfi_remember_state
 	ldq	$0, 256($sp)	/* get PS */
 	stq	$1, 8($sp)
 	stq	$2, 16($sp)
@@ -195,6 +286,32 @@ entUna:
 	stq	$28, 224($sp)
 	mov	$sp, $19
 	stq	$gp, 232($sp)
+	.cfi_rel_offset	$1, 1*8
+	.cfi_rel_offset	$2, 2*8
+	.cfi_rel_offset	$3, 3*8
+	.cfi_rel_offset	$4, 4*8
+	.cfi_rel_offset	$5, 5*8
+	.cfi_rel_offset	$6, 6*8
+	.cfi_rel_offset	$7, 7*8
+	.cfi_rel_offset	$8, 8*8
+	.cfi_rel_offset	$9, 9*8
+	.cfi_rel_offset	$10, 10*8
+	.cfi_rel_offset	$11, 11*8
+	.cfi_rel_offset	$12, 12*8
+	.cfi_rel_offset	$13, 13*8
+	.cfi_rel_offset	$14, 14*8
+	.cfi_rel_offset	$15, 15*8
+	.cfi_rel_offset	$19, 19*8
+	.cfi_rel_offset	$20, 20*8
+	.cfi_rel_offset	$21, 21*8
+	.cfi_rel_offset	$22, 22*8
+	.cfi_rel_offset	$23, 23*8
+	.cfi_rel_offset	$24, 24*8
+	.cfi_rel_offset	$25, 25*8
+	.cfi_rel_offset	$26, 26*8
+	.cfi_rel_offset	$27, 27*8
+	.cfi_rel_offset	$28, 28*8
+	.cfi_rel_offset	$29, 29*8
 	lda	$8, 0x3fff
 	stq	$31, 248($sp)
 	bic	$sp, $8, $8
@@ -228,16 +345,45 @@ entUna:
 	ldq	$28, 224($sp)
 	ldq	$gp, 232($sp)
 	lda	$sp, 256($sp)
+	.cfi_restore	$1
+	.cfi_restore	$2
+	.cfi_restore	$3
+	.cfi_restore	$4
+	.cfi_restore	$5
+	.cfi_restore	$6
+	.cfi_restore	$7
+	.cfi_restore	$8
+	.cfi_restore	$9
+	.cfi_restore	$10
+	.cfi_restore	$11
+	.cfi_restore	$12
+	.cfi_restore	$13
+	.cfi_restore	$14
+	.cfi_restore	$15
+	.cfi_restore	$19
+	.cfi_restore	$20
+	.cfi_restore	$21
+	.cfi_restore	$22
+	.cfi_restore	$23
+	.cfi_restore	$24
+	.cfi_restore	$25
+	.cfi_restore	$26
+	.cfi_restore	$27
+	.cfi_restore	$28
+	.cfi_restore	$29
+	.cfi_adjust_cfa_offset	-256
 	call_pal PAL_rti
-.end entUna
 
 	.align	4
-	.ent	entUnaUser
 entUnaUser:
+	.cfi_restore_state
 	ldq	$0, 0($sp)	/* restore original $0 */
 	lda	$sp, 256($sp)	/* pop entUna's stack frame */
+	.cfi_restore	$0
+	.cfi_adjust_cfa_offset	-256
 	SAVE_ALL		/* setup normal kernel stack */
 	lda	$sp, -56($sp)
+	.cfi_adjust_cfa_offset	56
 	stq	$9, 0($sp)
 	stq	$10, 8($sp)
 	stq	$11, 16($sp)
@@ -245,6 +391,13 @@ entUnaUser:
 	stq	$13, 32($sp)
 	stq	$14, 40($sp)
 	stq	$15, 48($sp)
+	.cfi_rel_offset	$9, 0
+	.cfi_rel_offset	$10, 8
+	.cfi_rel_offset	$11, 16
+	.cfi_rel_offset	$12, 24
+	.cfi_rel_offset	$13, 32
+	.cfi_rel_offset	$14, 40
+	.cfi_rel_offset	$15, 48
 	lda	$8, 0x3fff
 	addq	$sp, 56, $19
 	bic	$sp, $8, $8
@@ -257,20 +410,25 @@ entUnaUser:
 	ldq	$14, 40($sp)
 	ldq	$15, 48($sp)
 	lda	$sp, 56($sp)
+	.cfi_restore	$9
+	.cfi_restore	$10
+	.cfi_restore	$11
+	.cfi_restore	$12
+	.cfi_restore	$13
+	.cfi_restore	$14
+	.cfi_restore	$15
+	.cfi_adjust_cfa_offset	-56
 	br	ret_from_sys_call
-.end entUnaUser
+CFI_END_OSF_FRAME entUna
 
-	.align	4
-	.globl	entDbg
-	.ent	entDbg
-entDbg:
+CFI_START_OSF_FRAME entDbg
 	SAVE_ALL
 	lda	$8, 0x3fff
 	lda	$26, ret_from_sys_call
 	bic	$sp, $8, $8
 	mov	$sp, $16
 	jsr	$31, do_entDbg
-.end entDbg
+CFI_END_OSF_FRAME entDbg
 
 /*
  * The system call entry point is special.  Most importantly, it looks
@@ -285,8 +443,12 @@ entDbg:
 
 	.align	4
 	.globl	entSys
-	.globl	ret_from_sys_call
-	.ent	entSys
+	.type	entSys, @function
+	.cfi_startproc simple
+	.cfi_return_column 64
+	.cfi_def_cfa	$sp, 48
+	.cfi_rel_offset	64, 8
+	.cfi_rel_offset	$gp, 16
 entSys:
 	SAVE_ALL
 	lda	$8, 0x3fff
@@ -300,6 +462,9 @@ entSys:
 	stq	$17, SP_OFF+32($sp)
 	s8addq	$0, $5, $5
 	stq	$18, SP_OFF+40($sp)
+	.cfi_rel_offset	$16, SP_OFF+24
+	.cfi_rel_offset	$17, SP_OFF+32
+	.cfi_rel_offset	$18, SP_OFF+40
 	blbs	$3, strace
 	beq	$4, 1f
 	ldq	$27, 0($5)
@@ -310,6 +475,7 @@ entSys:
 	stq	$31, 72($sp)		/* a3=0 => no error */
 
 	.align	4
+	.globl	ret_from_sys_call
 ret_from_sys_call:
 	cmovne	$26, 0, $18		/* $18 = 0 => non-restartable */
 	ldq	$0, SP_OFF($sp)
@@ -324,10 +490,12 @@ ret_to_user:
 	and	$17, _TIF_WORK_MASK, $2
 	bne	$2, work_pending
 restore_all:
+	.cfi_remember_state
 	RESTORE_ALL
 	call_pal PAL_rti
 
 ret_to_kernel:
+	.cfi_restore_state
 	lda	$16, 7
 	call_pal PAL_swpipl
 	br restore_all
@@ -356,7 +524,6 @@ $ret_success:
 	stq	$0, 0($sp)
 	stq	$31, 72($sp)	/* a3=0 => no error */
 	br	ret_from_sys_call
-.end entSys
 
 /*
  * Do all cleanup when returning from all interrupts and system calls.
@@ -370,7 +537,7 @@ $ret_success:
  */
 
 	.align	4
-	.ent	work_pending
+	.type	work_pending, @function
 work_pending:
 	and	$17, _TIF_NOTIFY_RESUME | _TIF_SIGPENDING, $2
 	bne	$2, $work_notifysig
@@ -387,23 +554,22 @@ $work_resched:
 
 $work_notifysig:
 	mov	$sp, $16
-	bsr	$1, do_switch_stack
+	DO_SWITCH_STACK
 	jsr	$26, do_work_pending
-	bsr	$1, undo_switch_stack
+	UNDO_SWITCH_STACK
 	br	restore_all
-.end work_pending
 
 /*
  * PTRACE syscall handler
  */
 
 	.align	4
-	.ent	strace
+	.type	strace, @function
 strace:
 	/* set up signal stack, call syscall_trace */
-	bsr	$1, do_switch_stack
+	DO_SWITCH_STACK
 	jsr	$26, syscall_trace_enter /* returns the syscall number */
-	bsr	$1, undo_switch_stack
+	UNDO_SWITCH_STACK
 
 	/* get the arguments back.. */
 	ldq	$16, SP_OFF+24($sp)
@@ -431,9 +597,9 @@ ret_from_straced:
 $strace_success:
 	stq	$0, 0($sp)		/* save return value */
 
-	bsr	$1, do_switch_stack
+	DO_SWITCH_STACK
 	jsr	$26, syscall_trace_leave
-	bsr	$1, undo_switch_stack
+	UNDO_SWITCH_STACK
 	br	$31, ret_from_sys_call
 
 	.align	3
@@ -447,26 +613,31 @@ $strace_error:
 	stq	$0, 0($sp)
 	stq	$1, 72($sp)	/* a3 for return */
 
-	bsr	$1, do_switch_stack
+	DO_SWITCH_STACK
 	mov	$18, $9		/* save old syscall number */
 	mov	$19, $10	/* save old a3 */
 	jsr	$26, syscall_trace_leave
 	mov	$9, $18
 	mov	$10, $19
-	bsr	$1, undo_switch_stack
+	UNDO_SWITCH_STACK
 
 	mov	$31, $26	/* tell "ret_from_sys_call" we can restart */
 	br	ret_from_sys_call
-.end strace
+CFI_END_OSF_FRAME entSys
 
 /*
  * Save and restore the switch stack -- aka the balance of the user context.
  */
 
 	.align	4
-	.ent	do_switch_stack
+	.type	do_switch_stack, @function
+	.cfi_startproc simple
+	.cfi_return_column 64
+	.cfi_def_cfa $sp, 0
+	.cfi_register 64, $1
 do_switch_stack:
 	lda	$sp, -SWITCH_STACK_SIZE($sp)
+	.cfi_adjust_cfa_offset	SWITCH_STACK_SIZE
 	stq	$9, 0($sp)
 	stq	$10, 8($sp)
 	stq	$11, 16($sp)
@@ -510,10 +681,14 @@ do_switch_stack:
 	stt	$f0, 312($sp)	# save fpcr in slot of $f31
 	ldt	$f0, 64($sp)	# dont let "do_switch_stack" change fp state.
 	ret	$31, ($1), 1
-.end do_switch_stack
+	.cfi_endproc
+	.size	do_switch_stack, .-do_switch_stack
 
 	.align	4
-	.ent	undo_switch_stack
+	.type	undo_switch_stack, @function
+	.cfi_startproc simple
+	.cfi_def_cfa $sp, 0
+	.cfi_register 64, $1
 undo_switch_stack:
 	ldq	$9, 0($sp)
 	ldq	$10, 8($sp)
@@ -558,7 +733,8 @@ undo_switch_stack:
 	ldt	$f30, 304($sp)
 	lda	$sp, SWITCH_STACK_SIZE($sp)
 	ret	$31, ($1), 1
-.end undo_switch_stack
+	.cfi_endproc
+	.size	undo_switch_stack, .-undo_switch_stack
 
 /*
  * The meat of the context switch code.
@@ -566,17 +742,18 @@ undo_switch_stack:
 
 	.align	4
 	.globl	alpha_switch_to
-	.ent	alpha_switch_to
+	.type	alpha_switch_to, @function
+	.cfi_startproc
 alpha_switch_to:
-	.prologue 0
-	bsr	$1, do_switch_stack
+	DO_SWITCH_STACK
 	call_pal PAL_swpctx
 	lda	$8, 0x3fff
-	bsr	$1, undo_switch_stack
+	UNDO_SWITCH_STACK
 	bic	$sp, $8, $8
 	mov	$17, $0
 	ret
-.end alpha_switch_to
+	.cfi_endproc
+	.size	alpha_switch_to, .-alpha_switch_to
 
 /*
  * New processes begin life here.
-- 
1.8.1.4

