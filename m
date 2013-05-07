Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab3EGJwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:52:08 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:40813 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab3EGJwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:52:05 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] h8300: Hardcode symbol prefixes in asm sources
Date: Tue,  7 May 2013 11:52:00 +0200
Message-Id: <1367920320-18382-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e1b5bb6d1236d4ad2084c53aa83dde7cdf6f8eea ("consolidate cond_syscall
and SYSCALL_ALIAS declarations") broke the h8300 build because it removed
the duplicate SYMBOL_NAME() macro from arch/h8300/include/asm/linkage.h,
and all the h8300 asm files include <asm/linkage.h> instead of
<linux/linkage.h>.

Commit 126de6b20bfb82cc19012d5048f11f339ae5a021 ("linkage.h: fix build
breakage due to symbol prefix handling") broke it even more, by removing
SYMBOL_NAME() and replacing it by __SYMBOL_NAME().

Commit f8ce1faf55955de62e0a12e330c6d9a526071f65 ("Merge tag
'modules-next-for-linus' of
git://git.kernel.org/pub/scm/linuxkernel/git/rusty/linux")
also removed __SYMBOL_NAME(), hidden in a merge conflict resolution.

Hence, replace the use of SYMBOL_NAME() and SYMBOL_NAME_LABEL() in h8300
assembler sources by hardcoding the underscore symbol prefix, like other
architectures (blackfin/metag) do.

This allows to kill SYMBOL_NAME_LABEL(). Now <asm/linkage.h> becomes empty,
and h8300 can be switched to asm-generic/linkage.h.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/h8300/include/asm/Kbuild                    |    1 +
 arch/h8300/include/asm/linkage.h                 |    6 -
 arch/h8300/kernel/entry.S                        |  118 ++--
 arch/h8300/kernel/syscalls.S                     |  646 +++++++++++-----------
 arch/h8300/lib/abs.S                             |    4 +-
 arch/h8300/lib/memcpy.S                          |    4 +-
 arch/h8300/lib/memset.S                          |    4 +-
 arch/h8300/platform/h8300h/aki3068net/crt0_ram.S |   16 +-
 arch/h8300/platform/h8300h/generic/crt0_ram.S    |   14 +-
 arch/h8300/platform/h8300h/generic/crt0_rom.S    |   14 +-
 arch/h8300/platform/h8300h/h8max/crt0_ram.S      |   16 +-
 arch/h8300/platform/h8s/edosk2674/crt0_ram.S     |   16 +-
 arch/h8300/platform/h8s/edosk2674/crt0_rom.S     |   14 +-
 arch/h8300/platform/h8s/generic/crt0_ram.S       |   16 +-
 arch/h8300/platform/h8s/generic/crt0_rom.S       |   12 +-
 15 files changed, 448 insertions(+), 453 deletions(-)
 delete mode 100644 arch/h8300/include/asm/linkage.h

diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
index 995eb47..e0bce30 100644
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -1,6 +1,7 @@
 
 generic-y += clkdev.h
 generic-y += exec.h
+generic-y += linkage.h
 generic-y += mmu.h
 generic-y += module.h
 generic-y += trace_clock.h
diff --git a/arch/h8300/include/asm/linkage.h b/arch/h8300/include/asm/linkage.h
deleted file mode 100644
index 1d81604..0000000
--- a/arch/h8300/include/asm/linkage.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _H8300_LINKAGE_H
-#define _H8300_LINKAGE_H
-
-#undef SYMBOL_NAME_LABEL
-#define SYMBOL_NAME_LABEL(_name_) _##_name_##:
-#endif
diff --git a/arch/h8300/kernel/entry.S b/arch/h8300/kernel/entry.S
index 617a687..94bd30f 100644
--- a/arch/h8300/kernel/entry.S
+++ b/arch/h8300/kernel/entry.S
@@ -87,13 +87,13 @@ INTERRUPTS = 128
 	bne	5f
 
 	/* user mode */
-	mov.l	sp,@SYMBOL_NAME(sw_usp)
+	mov.l	sp,@_sw_usp
 	mov.l	@sp,er0				/* restore saved er0 */
 	orc	#0x10,ccr			/* switch kernel stack */
-	mov.l	@SYMBOL_NAME(sw_ksp),sp
+	mov.l	@_sw_ksp,sp
 	sub.l	#(LRET-LORIG),sp		/* allocate LORIG - LRET */
 	SAVEREGS
-	mov.l   @SYMBOL_NAME(sw_usp),er0
+	mov.l   @_sw_usp,er0
 	mov.l   @(USERRET:16,er0),er1           /* copy the RET addr */
 	mov.l   er1,@(LRET-LER3:16,sp)
 	SAVEEXR
@@ -128,7 +128,7 @@ INTERRUPTS = 128
 	bne	7f
 
 	orc	#0x80,ccr
-	mov.l	@SYMBOL_NAME(sw_usp),er0
+	mov.l	@_sw_usp,er0
 	mov.l	@(LER0-LER1:16,sp),er1		/* restore ER0 */
 	mov.l	er1,@er0
 	RESTOREEXR
@@ -141,7 +141,7 @@ INTERRUPTS = 128
 
 	mov.l	@sp+,er1
 	add.l	#(LRET-LER1),sp			/* remove LORIG - LRET */
-	mov.l	sp,@SYMBOL_NAME(sw_ksp)
+	mov.l	sp,@_sw_ksp
 	andc	#0xef,ccr			/* switch to user mode */
 	mov.l	er0,sp
 	bra	8f
@@ -155,20 +155,20 @@ INTERRUPTS = 128
 	rte
 	.endm
 
-.globl SYMBOL_NAME(system_call)
-.globl SYMBOL_NAME(ret_from_exception)
-.globl SYMBOL_NAME(ret_from_fork)
-.globl SYMBOL_NAME(ret_from_kernel_thread)
-.globl SYMBOL_NAME(ret_from_interrupt)
-.globl SYMBOL_NAME(interrupt_redirect_table)
-.globl SYMBOL_NAME(sw_ksp),SYMBOL_NAME(sw_usp)
-.globl SYMBOL_NAME(resume)
-.globl SYMBOL_NAME(interrupt_entry)
-.globl SYMBOL_NAME(trace_break)
+.globl _system_call
+.globl _ret_from_exception
+.globl _ret_from_fork
+.globl _ret_from_kernel_thread
+.globl _ret_from_interrupt
+.globl _interrupt_redirect_table
+.globl _sw_ksp,_sw_usp
+.globl _resume
+.globl _interrupt_entry
+.globl _trace_break
 
 #if defined(CONFIG_ROMKERNEL)
 	.section .int_redirect,"ax"
-SYMBOL_NAME_LABEL(interrupt_redirect_table)
+_interrupt_redirect_table:
 #if defined(CONFIG_CPU_H8300H)
 	.rept	7
 	.long	0
@@ -178,54 +178,54 @@ SYMBOL_NAME_LABEL(interrupt_redirect_table)
 	.rept	5
 	.long	0
 	.endr
-	jmp	@SYMBOL_NAME(trace_break)
+	jmp	@_trace_break
 	.long	0
 #endif
 
-	jsr	@SYMBOL_NAME(interrupt_entry)	/* NMI */
-	jmp	@SYMBOL_NAME(system_call)	/* TRAPA #0 (System call) */
+	jsr	@_interrupt_entry		/* NMI */
+	jmp	@_system_call			/* TRAPA #0 (System call) */
 	.long	0
 	.long	0
-	jmp	@SYMBOL_NAME(trace_break)	/* TRAPA #3 (breakpoint) */
+	jmp	@_trace_break			/* TRAPA #3 (breakpoint) */
 	.rept	INTERRUPTS-12
-	jsr	@SYMBOL_NAME(interrupt_entry)
+	jsr	@_interrupt_entry
 	.endr
 #endif
 #if defined(CONFIG_RAMKERNEL)
-.globl SYMBOL_NAME(interrupt_redirect_table)
+.globl _interrupt_redirect_table
 	.section .bss
-SYMBOL_NAME_LABEL(interrupt_redirect_table)
+_interrupt_redirect_table:
 	.space	4
 #endif
 
 	.section .text
 	.align	2
-SYMBOL_NAME_LABEL(interrupt_entry)
+_interrupt_entry:
 	SAVE_ALL
 	mov.l	sp,er0
 	add.l	#LVEC,er0
 	btst	#4,r1l
 	bne	1f
 	/* user LVEC */
-	mov.l	@SYMBOL_NAME(sw_usp),er0
+	mov.l	@_sw_usp,er0
 	adds	#4,er0
 1:
 	mov.l	@er0,er0			/* LVEC address */
 #if defined(CONFIG_ROMKERNEL)
-	sub.l	#SYMBOL_NAME(interrupt_redirect_table),er0
+	sub.l	#_interrupt_redirect_table,er0
 #endif
 #if defined(CONFIG_RAMKERNEL)
-	mov.l	@SYMBOL_NAME(interrupt_redirect_table),er1
+	mov.l	@_interrupt_redirect_table,er1
 	sub.l	er1,er0
 #endif
 	SHLR2	er0
 	dec.l	#1,er0
 	mov.l	sp,er1
 	subs	#4,er1				/* adjust ret_pc */
-	jsr	@SYMBOL_NAME(do_IRQ)
-	jmp	@SYMBOL_NAME(ret_from_interrupt)
+	jsr	@_do_IRQ
+	jmp	@_ret_from_interrupt
 
-SYMBOL_NAME_LABEL(system_call)
+_system_call:
 	subs	#4,sp				/* dummy LVEC */
 	SAVE_ALL
 	andc	#0x7f,ccr
@@ -233,21 +233,21 @@ SYMBOL_NAME_LABEL(system_call)
 
 	/* save top of frame */
 	mov.l	sp,er0
-	jsr	@SYMBOL_NAME(set_esp0)
+	jsr	@_set_esp0
 	mov.l	sp,er2
 	and.w	#0xe000,r2
 	mov.b	@((TI_FLAGS+3-(TIF_SYSCALL_TRACE >> 3)):16,er2),r2l
 	btst	#(TIF_SYSCALL_TRACE & 7),r2l
 	beq	1f
-	jsr	@SYMBOL_NAME(do_syscall_trace)
+	jsr	@_do_syscall_trace
 1:
 	cmp.l	#NR_syscalls,er4
 	bcc	badsys
 	SHLL2	er4
-	mov.l	#SYMBOL_NAME(sys_call_table),er0
+	mov.l	#_sys_call_table,er0
 	add.l	er4,er0
 	mov.l	@er0,er4
-	beq	SYMBOL_NAME(ret_from_exception):16
+	beq	_ret_from_exception:16
 	mov.l	@(LER1:16,sp),er0
 	mov.l	@(LER2:16,sp),er1
 	mov.l	@(LER3:16,sp),er2
@@ -258,10 +258,10 @@ SYMBOL_NAME_LABEL(system_call)
 	mov.b	@((TI_FLAGS+3-(TIF_SYSCALL_TRACE >> 3)):16,er2),r2l
 	btst	#(TIF_SYSCALL_TRACE & 7),r2l
 	beq	2f
-	jsr	@SYMBOL_NAME(do_syscall_trace)
+	jsr	@_do_syscall_trace
 2:
 #if defined(CONFIG_SYSCALL_PRINT)
-	jsr	@SYMBOL_NAME(syscall_print)
+	jsr	@_syscall_print
 #endif
 	orc	#0x80,ccr
 	bra	resume_userspace
@@ -275,11 +275,11 @@ badsys:
 #define resume_kernel restore_all
 #endif
 
-SYMBOL_NAME_LABEL(ret_from_exception)
+_ret_from_exception:
 #if defined(CONFIG_PREEMPT)
 	orc	#0x80,ccr
 #endif
-SYMBOL_NAME_LABEL(ret_from_interrupt)
+_ret_from_interrupt:
 	mov.b	@(LCCR+1:16,sp),r0l
 	btst	#4,r0l
 	bne	resume_kernel:8		/* return from kernel */
@@ -296,12 +296,12 @@ work_pending:
 	/* work notifysig */
 	mov.l	sp,er0
 	subs	#4,er0			/* er0: pt_regs */
-	jsr	@SYMBOL_NAME(do_notify_resume)
+	jsr	@_do_notify_resume
 	bra	restore_all:8
 work_resched:
 	mov.l	sp,er0
-	jsr	@SYMBOL_NAME(set_esp0)
-	jsr	@SYMBOL_NAME(schedule)
+	jsr	@_set_esp0
+	jsr	@_schedule
 	bra	resume_userspace:8
 restore_all:
 	RESTORE_ALL			/* Does RTE */
@@ -320,26 +320,26 @@ need_resched:
 	mov.l	er0,@(TI_PRE_COUNT:16,er4)
 	andc	#0x7f,ccr
 	mov.l	sp,er0
-	jsr	@SYMBOL_NAME(set_esp0)
-	jsr	@SYMBOL_NAME(schedule)
+	jsr	@_set_esp0
+	jsr	@_schedule
 	orc	#0x80,ccr
 	bra	need_resched:8
 #endif
 
-SYMBOL_NAME_LABEL(ret_from_fork)
+_ret_from_fork:
 	mov.l	er2,er0
-	jsr	@SYMBOL_NAME(schedule_tail)
-	jmp	@SYMBOL_NAME(ret_from_exception)
+	jsr	@_schedule_tail
+	jmp	@_ret_from_exception
 
-SYMBOL_NAME_LABEL(ret_from_kernel_thread)
+_ret_from_kernel_thread:
 	mov.l	er2,er0
-	jsr	@SYMBOL_NAME(schedule_tail)
+	jsr	@_schedule_tail
 	mov.l	@(LER4:16,sp),er0
 	mov.l	@(LER5:16,sp),er1
 	jsr	@er1
-	jmp	@SYMBOL_NAME(ret_from_exception)
+	jmp	@_ret_from_exception
 
-SYMBOL_NAME_LABEL(resume)
+_resume:
 	/*
 	 * Beware - when entering resume, offset of tss is in d1,
 	 * prev (the current task) is in a0, next (the new task)
@@ -355,7 +355,7 @@ SYMBOL_NAME_LABEL(resume)
 
 	/* disable interrupts */
 	orc	#0x80,ccr
-	mov.l	@SYMBOL_NAME(sw_usp),er3
+	mov.l	@_sw_usp,er3
 	mov.l	er3,@(THREAD_USP:16,er0)
 	mov.l	sp,@(THREAD_KSP:16,er0)
 
@@ -363,7 +363,7 @@ SYMBOL_NAME_LABEL(resume)
 	/* FIXME: what did we hack out of here, this does nothing! */
 
 	mov.l	@(THREAD_USP:16,er1),er0
-	mov.l	er0,@SYMBOL_NAME(sw_usp)
+	mov.l	er0,@_sw_usp
 	mov.l	@(THREAD_KSP:16,er1),sp
 
 	/* restore status register */
@@ -372,15 +372,15 @@ SYMBOL_NAME_LABEL(resume)
 	ldc	r3l,ccr
 	rts
 
-SYMBOL_NAME_LABEL(trace_break)
+_trace_break:
 	subs	#4,sp
 	SAVE_ALL
 	sub.l	er1,er1
 	dec.l	#1,er1
 	mov.l	er1,@(LORIG,sp)
 	mov.l	sp,er0
-	jsr	@SYMBOL_NAME(set_esp0)
-	mov.l	@SYMBOL_NAME(sw_usp),er0
+	jsr	@_set_esp0
+	mov.l	@_sw_usp,er0
 	mov.l	@er0,er1
 	mov.w	@(-2:16,er1),r2
 	cmp.w	#0x5730,r2
@@ -390,13 +390,13 @@ SYMBOL_NAME_LABEL(trace_break)
 1:
 	and.w	#0xff,e1
 	mov.l	er1,er0
-	jsr	@SYMBOL_NAME(trace_trap)
-	jmp	@SYMBOL_NAME(ret_from_exception)
+	jsr	@_trace_trap
+	jmp	@_ret_from_exception
 
 	.section	.bss
-SYMBOL_NAME_LABEL(sw_ksp)
+_sw_ksp:
 	.space	4
-SYMBOL_NAME_LABEL(sw_usp)
+_sw_usp:
 	.space	4
 
 	.end
diff --git a/arch/h8300/kernel/syscalls.S b/arch/h8300/kernel/syscalls.S
index 5c2168f..7497001 100644
--- a/arch/h8300/kernel/syscalls.S
+++ b/arch/h8300/kernel/syscalls.S
@@ -2,8 +2,8 @@
 #include <linux/sys.h>
 #include <asm/linkage.h>
 #include <asm/unistd.h>
-	
-.globl SYMBOL_NAME(sys_call_table)
+
+.globl _sys_call_table
 
 #if defined(CONFIG_CPU_H8300H)
 	.h8300h
@@ -13,324 +13,324 @@
 #endif
 	.section .text
 	.align	2
-SYMBOL_NAME_LABEL(sys_call_table)	
-	.long SYMBOL_NAME(sys_ni_syscall)	/* 0  -  old "setup()" system call*/
-	.long SYMBOL_NAME(sys_exit)
-	.long SYMBOL_NAME(sys_fork)
-	.long SYMBOL_NAME(sys_read)
-	.long SYMBOL_NAME(sys_write)
-	.long SYMBOL_NAME(sys_open)		/* 5 */
-	.long SYMBOL_NAME(sys_close)
-	.long SYMBOL_NAME(sys_waitpid)
-	.long SYMBOL_NAME(sys_creat)
-	.long SYMBOL_NAME(sys_link)
-	.long SYMBOL_NAME(sys_unlink)		/* 10 */
-	.long SYMBOL_NAME(sys_execve)
-	.long SYMBOL_NAME(sys_chdir)
-	.long SYMBOL_NAME(sys_time)
-	.long SYMBOL_NAME(sys_mknod)
-	.long SYMBOL_NAME(sys_chmod)		/* 15 */
-	.long SYMBOL_NAME(sys_chown16)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* old break syscall holder */
-	.long SYMBOL_NAME(sys_stat)
-	.long SYMBOL_NAME(sys_lseek)
-	.long SYMBOL_NAME(sys_getpid)		/* 20 */
-	.long SYMBOL_NAME(sys_mount)
-	.long SYMBOL_NAME(sys_oldumount)
-	.long SYMBOL_NAME(sys_setuid16)
-	.long SYMBOL_NAME(sys_getuid16)
-	.long SYMBOL_NAME(sys_stime)		/* 25 */
-	.long SYMBOL_NAME(sys_ptrace)
-	.long SYMBOL_NAME(sys_alarm)
-	.long SYMBOL_NAME(sys_fstat)
-	.long SYMBOL_NAME(sys_pause)
-	.long SYMBOL_NAME(sys_utime)		/* 30 */
-	.long SYMBOL_NAME(sys_ni_syscall)	/* old stty syscall holder */
-	.long SYMBOL_NAME(sys_ni_syscall)	/* old gtty syscall holder */
-	.long SYMBOL_NAME(sys_access)
-	.long SYMBOL_NAME(sys_nice)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* 35 old ftime syscall holder */
-	.long SYMBOL_NAME(sys_sync)
-	.long SYMBOL_NAME(sys_kill)
-	.long SYMBOL_NAME(sys_rename)
-	.long SYMBOL_NAME(sys_mkdir)
-	.long SYMBOL_NAME(sys_rmdir)		/* 40 */
-	.long SYMBOL_NAME(sys_dup)
-	.long SYMBOL_NAME(sys_pipe)
-	.long SYMBOL_NAME(sys_times)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* old prof syscall holder */
-	.long SYMBOL_NAME(sys_brk)		/* 45 */
-	.long SYMBOL_NAME(sys_setgid16)
-	.long SYMBOL_NAME(sys_getgid16)
-	.long SYMBOL_NAME(sys_signal)
-	.long SYMBOL_NAME(sys_geteuid16)
-	.long SYMBOL_NAME(sys_getegid16)	/* 50 */
-	.long SYMBOL_NAME(sys_acct)
-	.long SYMBOL_NAME(sys_umount)		/* recycled never used phys() */
-	.long SYMBOL_NAME(sys_ni_syscall)	/* old lock syscall holder */
-	.long SYMBOL_NAME(sys_ioctl)
-	.long SYMBOL_NAME(sys_fcntl)		/* 55 */
-	.long SYMBOL_NAME(sys_ni_syscall)	/* old mpx syscall holder */
-	.long SYMBOL_NAME(sys_setpgid)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* old ulimit syscall holder */
-	.long SYMBOL_NAME(sys_ni_syscall)
-	.long SYMBOL_NAME(sys_umask)		/* 60 */
-	.long SYMBOL_NAME(sys_chroot)
-	.long SYMBOL_NAME(sys_ustat)
-	.long SYMBOL_NAME(sys_dup2)
-	.long SYMBOL_NAME(sys_getppid)
-	.long SYMBOL_NAME(sys_getpgrp)		/* 65 */
-	.long SYMBOL_NAME(sys_setsid)
-	.long SYMBOL_NAME(sys_sigaction)
-	.long SYMBOL_NAME(sys_sgetmask)
-	.long SYMBOL_NAME(sys_ssetmask)
-	.long SYMBOL_NAME(sys_setreuid16)	/* 70 */
-	.long SYMBOL_NAME(sys_setregid16)
-	.long SYMBOL_NAME(sys_sigsuspend)
-	.long SYMBOL_NAME(sys_sigpending)
-	.long SYMBOL_NAME(sys_sethostname)
-	.long SYMBOL_NAME(sys_setrlimit)	/* 75 */
-	.long SYMBOL_NAME(sys_old_getrlimit)
-	.long SYMBOL_NAME(sys_getrusage)
-	.long SYMBOL_NAME(sys_gettimeofday)
-	.long SYMBOL_NAME(sys_settimeofday)
-	.long SYMBOL_NAME(sys_getgroups16)	/* 80 */
-	.long SYMBOL_NAME(sys_setgroups16)
-	.long SYMBOL_NAME(sys_old_select)
-	.long SYMBOL_NAME(sys_symlink)
-	.long SYMBOL_NAME(sys_lstat)
-	.long SYMBOL_NAME(sys_readlink)		/* 85 */
-	.long SYMBOL_NAME(sys_uselib)
-	.long SYMBOL_NAME(sys_swapon)
-	.long SYMBOL_NAME(sys_reboot)
-	.long SYMBOL_NAME(sys_old_readdir)
-	.long SYMBOL_NAME(sys_old_mmap)		/* 90 */
-	.long SYMBOL_NAME(sys_munmap)
-	.long SYMBOL_NAME(sys_truncate)
-	.long SYMBOL_NAME(sys_ftruncate)
-	.long SYMBOL_NAME(sys_fchmod)
-	.long SYMBOL_NAME(sys_fchown16)		/* 95 */
-	.long SYMBOL_NAME(sys_getpriority)
-	.long SYMBOL_NAME(sys_setpriority)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* old profil syscall holder */
-	.long SYMBOL_NAME(sys_statfs)
-	.long SYMBOL_NAME(sys_fstatfs)		/* 100 */
-	.long SYMBOL_NAME(sys_ni_syscall)	/* ioperm for i386 */
-	.long SYMBOL_NAME(sys_socketcall)
-	.long SYMBOL_NAME(sys_syslog)
-	.long SYMBOL_NAME(sys_setitimer)
-	.long SYMBOL_NAME(sys_getitimer)	/* 105 */
-	.long SYMBOL_NAME(sys_newstat)
-	.long SYMBOL_NAME(sys_newlstat)
-	.long SYMBOL_NAME(sys_newfstat)
-	.long SYMBOL_NAME(sys_ni_syscall)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* iopl for i386 */ /* 110 */
-	.long SYMBOL_NAME(sys_vhangup)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* obsolete idle() syscall */
-	.long SYMBOL_NAME(sys_ni_syscall)	/* vm86old for i386 */
-	.long SYMBOL_NAME(sys_wait4)
-	.long SYMBOL_NAME(sys_swapoff)		/* 115 */
-	.long SYMBOL_NAME(sys_sysinfo)
-	.long SYMBOL_NAME(sys_ipc)
-	.long SYMBOL_NAME(sys_fsync)
-	.long SYMBOL_NAME(sys_sigreturn)
-	.long SYMBOL_NAME(sys_clone)		/* 120 */
-	.long SYMBOL_NAME(sys_setdomainname)
-	.long SYMBOL_NAME(sys_newuname)
-	.long SYMBOL_NAME(sys_cacheflush)	/* modify_ldt for i386 */
-	.long SYMBOL_NAME(sys_adjtimex)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* 125 sys_mprotect */
-	.long SYMBOL_NAME(sys_sigprocmask)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_create_module */
-	.long SYMBOL_NAME(sys_init_module)
-	.long SYMBOL_NAME(sys_delete_module)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* 130 sys_get_kernel_syms */
-	.long SYMBOL_NAME(sys_quotactl)
-	.long SYMBOL_NAME(sys_getpgid)
-	.long SYMBOL_NAME(sys_fchdir)
-	.long SYMBOL_NAME(sys_bdflush)
-	.long SYMBOL_NAME(sys_sysfs)		/* 135 */
-	.long SYMBOL_NAME(sys_personality)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* for afs_syscall */
-	.long SYMBOL_NAME(sys_setfsuid16)
-	.long SYMBOL_NAME(sys_setfsgid16)
-	.long SYMBOL_NAME(sys_llseek)		/* 140 */
-	.long SYMBOL_NAME(sys_getdents)
-	.long SYMBOL_NAME(sys_select)
-	.long SYMBOL_NAME(sys_flock)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_msync */
-	.long SYMBOL_NAME(sys_readv)		/* 145 */
-	.long SYMBOL_NAME(sys_writev)
-	.long SYMBOL_NAME(sys_getsid)
-	.long SYMBOL_NAME(sys_fdatasync)
-	.long SYMBOL_NAME(sys_sysctl)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* 150 sys_mlock */
-	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_munlock */
-	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_mlockall */
-	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_munlockall */
-	.long SYMBOL_NAME(sys_sched_setparam)
-	.long SYMBOL_NAME(sys_sched_getparam)   /* 155 */
-	.long SYMBOL_NAME(sys_sched_setscheduler)
-	.long SYMBOL_NAME(sys_sched_getscheduler)
-	.long SYMBOL_NAME(sys_sched_yield)
-	.long SYMBOL_NAME(sys_sched_get_priority_max)
-	.long SYMBOL_NAME(sys_sched_get_priority_min)  /* 160 */
-	.long SYMBOL_NAME(sys_sched_rr_get_interval)
-	.long SYMBOL_NAME(sys_nanosleep)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_mremap */
-	.long SYMBOL_NAME(sys_setresuid16)
-	.long SYMBOL_NAME(sys_getresuid16)	/* 165 */
-	.long SYMBOL_NAME(sys_ni_syscall)	/* for vm86 */
-	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_query_module */
-	.long SYMBOL_NAME(sys_poll)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* old nfsservctl */
-	.long SYMBOL_NAME(sys_setresgid16)	/* 170 */
-	.long SYMBOL_NAME(sys_getresgid16)
-	.long SYMBOL_NAME(sys_prctl)
-	.long SYMBOL_NAME(sys_rt_sigreturn)
-	.long SYMBOL_NAME(sys_rt_sigaction)
-	.long SYMBOL_NAME(sys_rt_sigprocmask)	/* 175 */
-	.long SYMBOL_NAME(sys_rt_sigpending)
-	.long SYMBOL_NAME(sys_rt_sigtimedwait)
-	.long SYMBOL_NAME(sys_rt_sigqueueinfo)
-	.long SYMBOL_NAME(sys_rt_sigsuspend)
-	.long SYMBOL_NAME(sys_pread64)		/* 180 */
-	.long SYMBOL_NAME(sys_pwrite64)
-	.long SYMBOL_NAME(sys_lchown16);
-	.long SYMBOL_NAME(sys_getcwd)
-	.long SYMBOL_NAME(sys_capget)
-	.long SYMBOL_NAME(sys_capset)           /* 185 */
-	.long SYMBOL_NAME(sys_sigaltstack)
-	.long SYMBOL_NAME(sys_sendfile)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* streams1 */
-	.long SYMBOL_NAME(sys_ni_syscall)	/* streams2 */
-	.long SYMBOL_NAME(sys_vfork)            /* 190 */
-	.long SYMBOL_NAME(sys_getrlimit)
-	.long SYMBOL_NAME(sys_mmap_pgoff)
-	.long SYMBOL_NAME(sys_truncate64)
-	.long SYMBOL_NAME(sys_ftruncate64)
-	.long SYMBOL_NAME(sys_stat64)		/* 195 */
-	.long SYMBOL_NAME(sys_lstat64)
-	.long SYMBOL_NAME(sys_fstat64)
-	.long SYMBOL_NAME(sys_chown)
-	.long SYMBOL_NAME(sys_getuid)
-	.long SYMBOL_NAME(sys_getgid)		/* 200 */
-	.long SYMBOL_NAME(sys_geteuid)
-	.long SYMBOL_NAME(sys_getegid)
-	.long SYMBOL_NAME(sys_setreuid)
-	.long SYMBOL_NAME(sys_setregid)
-	.long SYMBOL_NAME(sys_getgroups)	/* 205 */
-	.long SYMBOL_NAME(sys_setgroups)
-	.long SYMBOL_NAME(sys_fchown)
-	.long SYMBOL_NAME(sys_setresuid)
-	.long SYMBOL_NAME(sys_getresuid)
-	.long SYMBOL_NAME(sys_setresgid)	/* 210 */
-	.long SYMBOL_NAME(sys_getresgid)
-	.long SYMBOL_NAME(sys_lchown)
-	.long SYMBOL_NAME(sys_setuid)
-	.long SYMBOL_NAME(sys_setgid)
-	.long SYMBOL_NAME(sys_setfsuid)		/* 215 */
-	.long SYMBOL_NAME(sys_setfsgid)
-	.long SYMBOL_NAME(sys_pivot_root)
-	.long SYMBOL_NAME(sys_ni_syscall)
-	.long SYMBOL_NAME(sys_ni_syscall)
-	.long SYMBOL_NAME(sys_getdents64)	/* 220 */
-	.long SYMBOL_NAME(sys_fcntl64)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* reserved TUX */
-	.long SYMBOL_NAME(sys_ni_syscall)	/* reserved Security */
-	.long SYMBOL_NAME(sys_gettid)
-	.long SYMBOL_NAME(sys_readahead)	/* 225 */
-	.long SYMBOL_NAME(sys_setxattr)
-	.long SYMBOL_NAME(sys_lsetxattr)
-	.long SYMBOL_NAME(sys_fsetxattr)
-	.long SYMBOL_NAME(sys_getxattr)
-	.long SYMBOL_NAME(sys_lgetxattr)	/* 230 */
-	.long SYMBOL_NAME(sys_fgetxattr)
-	.long SYMBOL_NAME(sys_listxattr)
-	.long SYMBOL_NAME(sys_llistxattr)
-	.long SYMBOL_NAME(sys_flistxattr)
-	.long SYMBOL_NAME(sys_removexattr)	/* 235 */
-	.long SYMBOL_NAME(sys_lremovexattr)
-	.long SYMBOL_NAME(sys_fremovexattr)
-	.long SYMBOL_NAME(sys_tkill)
-	.long SYMBOL_NAME(sys_sendfile64)
-	.long SYMBOL_NAME(sys_futex)		/* 240 */
-	.long SYMBOL_NAME(sys_sched_setaffinity)
-	.long SYMBOL_NAME(sys_sched_getaffinity)
-	.long SYMBOL_NAME(sys_ni_syscall)
-	.long SYMBOL_NAME(sys_ni_syscall)
-	.long SYMBOL_NAME(sys_io_setup)		/* 245 */
-	.long SYMBOL_NAME(sys_io_destroy)
-	.long SYMBOL_NAME(sys_io_getevents)
-	.long SYMBOL_NAME(sys_io_submit)
-	.long SYMBOL_NAME(sys_io_cancel)
-	.long SYMBOL_NAME(sys_fadvise64)	/* 250 */
-	.long SYMBOL_NAME(sys_ni_syscall)
-	.long SYMBOL_NAME(sys_exit_group)
-	.long SYMBOL_NAME(sys_lookup_dcookie)
-	.long SYMBOL_NAME(sys_epoll_create)
-	.long SYMBOL_NAME(sys_epoll_ctl)	/* 255 */
-	.long SYMBOL_NAME(sys_epoll_wait)
- 	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_remap_file_pages */
- 	.long SYMBOL_NAME(sys_set_tid_address)
- 	.long SYMBOL_NAME(sys_timer_create)
- 	.long SYMBOL_NAME(sys_timer_settime)	/* 260 */
- 	.long SYMBOL_NAME(sys_timer_gettime)
- 	.long SYMBOL_NAME(sys_timer_getoverrun)
- 	.long SYMBOL_NAME(sys_timer_delete)
- 	.long SYMBOL_NAME(sys_clock_settime)
- 	.long SYMBOL_NAME(sys_clock_gettime)	/* 265 */
- 	.long SYMBOL_NAME(sys_clock_getres)
- 	.long SYMBOL_NAME(sys_clock_nanosleep)
-	.long SYMBOL_NAME(sys_statfs64)
-	.long SYMBOL_NAME(sys_fstatfs64)	
-	.long SYMBOL_NAME(sys_tgkill)		/* 270 */
-	.long SYMBOL_NAME(sys_utimes)
- 	.long SYMBOL_NAME(sys_fadvise64_64)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_vserver */
-	.long SYMBOL_NAME(sys_ni_syscall)
-	.long SYMBOL_NAME(sys_get_mempolicy)	/* 275 */
-	.long SYMBOL_NAME(sys_set_mempolicy)
-	.long SYMBOL_NAME(sys_mq_open)
-	.long SYMBOL_NAME(sys_mq_unlink)
-	.long SYMBOL_NAME(sys_mq_timedsend)
-	.long SYMBOL_NAME(sys_mq_timedreceive)	/* 280 */
-	.long SYMBOL_NAME(sys_mq_notify)
-	.long SYMBOL_NAME(sys_mq_getsetattr)
-	.long SYMBOL_NAME(sys_waitid)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_kexec_load */
-	.long SYMBOL_NAME(sys_add_key) 		/* 285 */
-	.long SYMBOL_NAME(sys_request_key)
-	.long SYMBOL_NAME(sys_keyctl)
-	.long SYMBOL_NAME(sys_ioprio_set)
-	.long SYMBOL_NAME(sys_ioprio_get)	/* 290 */
-	.long SYMBOL_NAME(sys_inotify_init)
-	.long SYMBOL_NAME(sys_inotify_add_watch)
-	.long SYMBOL_NAME(sys_inotify_rm_watch)
-	.long SYMBOL_NAME(sys_migrate_pages)
-	.long SYMBOL_NAME(sys_openat)		/* 295 */
-	.long SYMBOL_NAME(sys_mkdirat)
-	.long SYMBOL_NAME(sys_mknodat)
-	.long SYMBOL_NAME(sys_fchownat)
-	.long SYMBOL_NAME(sys_futimesat)
-	.long SYMBOL_NAME(sys_fstatat64)	/* 300 */
-	.long SYMBOL_NAME(sys_unlinkat)
-	.long SYMBOL_NAME(sys_renameat)
-	.long SYMBOL_NAME(sys_linkat)
-	.long SYMBOL_NAME(sys_symlinkat)
-	.long SYMBOL_NAME(sys_readlinkat)	/* 305 */
-	.long SYMBOL_NAME(sys_fchmodat)
-	.long SYMBOL_NAME(sys_faccessat)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_pselect6 */
-	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_ppoll */
-	.long SYMBOL_NAME(sys_unshare)		/* 310 */
-	.long SYMBOL_NAME(sys_set_robust_list)
-	.long SYMBOL_NAME(sys_get_robust_list)
-	.long SYMBOL_NAME(sys_splice)
-	.long SYMBOL_NAME(sys_sync_file_range)
-	.long SYMBOL_NAME(sys_tee)		/* 315 */
-	.long SYMBOL_NAME(sys_vmsplice)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_move_pages */
-	.long SYMBOL_NAME(sys_getcpu)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_epoll_pwait */
-	.long SYMBOL_NAME(sys_setns)		/* 320 */
+_sys_call_table:
+	.long _sys_ni_syscall		/* 0  -  old "setup()" system call*/
+	.long _sys_exit
+	.long _sys_fork
+	.long _sys_read
+	.long _sys_write
+	.long _sys_open			/* 5 */
+	.long _sys_close
+	.long _sys_waitpid
+	.long _sys_creat
+	.long _sys_link
+	.long _sys_unlink		/* 10 */
+	.long _sys_execve
+	.long _sys_chdir
+	.long _sys_time
+	.long _sys_mknod
+	.long _sys_chmod		/* 15 */
+	.long _sys_chown16
+	.long _sys_ni_syscall		/* old break syscall holder */
+	.long _sys_stat
+	.long _sys_lseek
+	.long _sys_getpid		/* 20 */
+	.long _sys_mount
+	.long _sys_oldumount
+	.long _sys_setuid16
+	.long _sys_getuid16
+	.long _sys_stime		/* 25 */
+	.long _sys_ptrace
+	.long _sys_alarm
+	.long _sys_fstat
+	.long _sys_pause
+	.long _sys_utime		/* 30 */
+	.long _sys_ni_syscall		/* old stty syscall holder */
+	.long _sys_ni_syscall		/* old gtty syscall holder */
+	.long _sys_access
+	.long _sys_nice
+	.long _sys_ni_syscall		/* 35 old ftime syscall holder */
+	.long _sys_sync
+	.long _sys_kill
+	.long _sys_rename
+	.long _sys_mkdir
+	.long _sys_rmdir		/* 40 */
+	.long _sys_dup
+	.long _sys_pipe
+	.long _sys_times
+	.long _sys_ni_syscall		/* old prof syscall holder */
+	.long _sys_brk			/* 45 */
+	.long _sys_setgid16
+	.long _sys_getgid16
+	.long _sys_signal
+	.long _sys_geteuid16
+	.long _sys_getegid16		/* 50 */
+	.long _sys_acct
+	.long _sys_umount		/* recycled never used phys() */
+	.long _sys_ni_syscall		/* old lock syscall holder */
+	.long _sys_ioctl
+	.long _sys_fcntl		/* 55 */
+	.long _sys_ni_syscall		/* old mpx syscall holder */
+	.long _sys_setpgid
+	.long _sys_ni_syscall		/* old ulimit syscall holder */
+	.long _sys_ni_syscall
+	.long _sys_umask		/* 60 */
+	.long _sys_chroot
+	.long _sys_ustat
+	.long _sys_dup2
+	.long _sys_getppid
+	.long _sys_getpgrp		/* 65 */
+	.long _sys_setsid
+	.long _sys_sigaction
+	.long _sys_sgetmask
+	.long _sys_ssetmask
+	.long _sys_setreuid16		/* 70 */
+	.long _sys_setregid16
+	.long _sys_sigsuspend
+	.long _sys_sigpending
+	.long _sys_sethostname
+	.long _sys_setrlimit		/* 75 */
+	.long _sys_old_getrlimit
+	.long _sys_getrusage
+	.long _sys_gettimeofday
+	.long _sys_settimeofday
+	.long _sys_getgroups16		/* 80 */
+	.long _sys_setgroups16
+	.long _sys_old_select
+	.long _sys_symlink
+	.long _sys_lstat
+	.long _sys_readlink		/* 85 */
+	.long _sys_uselib
+	.long _sys_swapon
+	.long _sys_reboot
+	.long _sys_old_readdir
+	.long _sys_old_mmap		/* 90 */
+	.long _sys_munmap
+	.long _sys_truncate
+	.long _sys_ftruncate
+	.long _sys_fchmod
+	.long _sys_fchown16		/* 95 */
+	.long _sys_getpriority
+	.long _sys_setpriority
+	.long _sys_ni_syscall		/* old profil syscall holder */
+	.long _sys_statfs
+	.long _sys_fstatfs		/* 100 */
+	.long _sys_ni_syscall		/* ioperm for i386 */
+	.long _sys_socketcall
+	.long _sys_syslog
+	.long _sys_setitimer
+	.long _sys_getitimer		/* 105 */
+	.long _sys_newstat
+	.long _sys_newlstat
+	.long _sys_newfstat
+	.long _sys_ni_syscall
+	.long _sys_ni_syscall		/* iopl for i386 */ /* 110 */
+	.long _sys_vhangup
+	.long _sys_ni_syscall		/* obsolete idle() syscall */
+	.long _sys_ni_syscall		/* vm86old for i386 */
+	.long _sys_wait4
+	.long _sys_swapoff		/* 115 */
+	.long _sys_sysinfo
+	.long _sys_ipc
+	.long _sys_fsync
+	.long _sys_sigreturn
+	.long _sys_clone		/* 120 */
+	.long _sys_setdomainname
+	.long _sys_newuname
+	.long _sys_cacheflush		/* modify_ldt for i386 */
+	.long _sys_adjtimex
+	.long _sys_ni_syscall		/* 125 sys_mprotect */
+	.long _sys_sigprocmask
+	.long _sys_ni_syscall		/* sys_create_module */
+	.long _sys_init_module
+	.long _sys_delete_module
+	.long _sys_ni_syscall		/* 130 sys_get_kernel_syms */
+	.long _sys_quotactl
+	.long _sys_getpgid
+	.long _sys_fchdir
+	.long _sys_bdflush
+	.long _sys_sysfs		/* 135 */
+	.long _sys_personality
+	.long _sys_ni_syscall		/* for afs_syscall */
+	.long _sys_setfsuid16
+	.long _sys_setfsgid16
+	.long _sys_llseek		/* 140 */
+	.long _sys_getdents
+	.long _sys_select
+	.long _sys_flock
+	.long _sys_ni_syscall		/* sys_msync */
+	.long _sys_readv		/* 145 */
+	.long _sys_writev
+	.long _sys_getsid
+	.long _sys_fdatasync
+	.long _sys_sysctl
+	.long _sys_ni_syscall		/* 150 sys_mlock */
+	.long _sys_ni_syscall		/* sys_munlock */
+	.long _sys_ni_syscall		/* sys_mlockall */
+	.long _sys_ni_syscall		/* sys_munlockall */
+	.long _sys_sched_setparam
+	.long _sys_sched_getparam	/* 155 */
+	.long _sys_sched_setscheduler
+	.long _sys_sched_getscheduler
+	.long _sys_sched_yield
+	.long _sys_sched_get_priority_max
+	.long _sys_sched_get_priority_min  /* 160 */
+	.long _sys_sched_rr_get_interval
+	.long _sys_nanosleep
+	.long _sys_ni_syscall		/* sys_mremap */
+	.long _sys_setresuid16
+	.long _sys_getresuid16		/* 165 */
+	.long _sys_ni_syscall		/* for vm86 */
+	.long _sys_ni_syscall		/* sys_query_module */
+	.long _sys_poll
+	.long _sys_ni_syscall		/* old nfsservctl */
+	.long _sys_setresgid16		/* 170 */
+	.long _sys_getresgid16
+	.long _sys_prctl
+	.long _sys_rt_sigreturn
+	.long _sys_rt_sigaction
+	.long _sys_rt_sigprocmask	/* 175 */
+	.long _sys_rt_sigpending
+	.long _sys_rt_sigtimedwait
+	.long _sys_rt_sigqueueinfo
+	.long _sys_rt_sigsuspend
+	.long _sys_pread64		/* 180 */
+	.long _sys_pwrite64
+	.long _sys_lchown16;
+	.long _sys_getcwd
+	.long _sys_capget
+	.long _sys_capset		/* 185 */
+	.long _sys_sigaltstack
+	.long _sys_sendfile
+	.long _sys_ni_syscall		/* streams1 */
+	.long _sys_ni_syscall		/* streams2 */
+	.long _sys_vfork		/* 190 */
+	.long _sys_getrlimit
+	.long _sys_mmap_pgoff
+	.long _sys_truncate64
+	.long _sys_ftruncate64
+	.long _sys_stat64		/* 195 */
+	.long _sys_lstat64
+	.long _sys_fstat64
+	.long _sys_chown
+	.long _sys_getuid
+	.long _sys_getgid		/* 200 */
+	.long _sys_geteuid
+	.long _sys_getegid
+	.long _sys_setreuid
+	.long _sys_setregid
+	.long _sys_getgroups		/* 205 */
+	.long _sys_setgroups
+	.long _sys_fchown
+	.long _sys_setresuid
+	.long _sys_getresuid
+	.long _sys_setresgid		/* 210 */
+	.long _sys_getresgid
+	.long _sys_lchown
+	.long _sys_setuid
+	.long _sys_setgid
+	.long _sys_setfsuid		/* 215 */
+	.long _sys_setfsgid
+	.long _sys_pivot_root
+	.long _sys_ni_syscall
+	.long _sys_ni_syscall
+	.long _sys_getdents64		/* 220 */
+	.long _sys_fcntl64
+	.long _sys_ni_syscall		/* reserved TUX */
+	.long _sys_ni_syscall		/* reserved Security */
+	.long _sys_gettid
+	.long _sys_readahead		/* 225 */
+	.long _sys_setxattr
+	.long _sys_lsetxattr
+	.long _sys_fsetxattr
+	.long _sys_getxattr
+	.long _sys_lgetxattr		/* 230 */
+	.long _sys_fgetxattr
+	.long _sys_listxattr
+	.long _sys_llistxattr
+	.long _sys_flistxattr
+	.long _sys_removexattr		/* 235 */
+	.long _sys_lremovexattr
+	.long _sys_fremovexattr
+	.long _sys_tkill
+	.long _sys_sendfile64
+	.long _sys_futex		/* 240 */
+	.long _sys_sched_setaffinity
+	.long _sys_sched_getaffinity
+	.long _sys_ni_syscall
+	.long _sys_ni_syscall
+	.long _sys_io_setup		/* 245 */
+	.long _sys_io_destroy
+	.long _sys_io_getevents
+	.long _sys_io_submit
+	.long _sys_io_cancel
+	.long _sys_fadvise64		/* 250 */
+	.long _sys_ni_syscall
+	.long _sys_exit_group
+	.long _sys_lookup_dcookie
+	.long _sys_epoll_create
+	.long _sys_epoll_ctl		/* 255 */
+	.long _sys_epoll_wait
+ 	.long _sys_ni_syscall		/* sys_remap_file_pages */
+ 	.long _sys_set_tid_address
+ 	.long _sys_timer_create
+ 	.long _sys_timer_settime	/* 260 */
+ 	.long _sys_timer_gettime
+ 	.long _sys_timer_getoverrun
+ 	.long _sys_timer_delete
+ 	.long _sys_clock_settime
+ 	.long _sys_clock_gettime	/* 265 */
+ 	.long _sys_clock_getres
+ 	.long _sys_clock_nanosleep
+	.long _sys_statfs64
+	.long _sys_fstatfs64
+	.long _sys_tgkill		/* 270 */
+	.long _sys_utimes
+ 	.long _sys_fadvise64_64
+	.long _sys_ni_syscall		/* sys_vserver */
+	.long _sys_ni_syscall
+	.long _sys_get_mempolicy	/* 275 */
+	.long _sys_set_mempolicy
+	.long _sys_mq_open
+	.long _sys_mq_unlink
+	.long _sys_mq_timedsend
+	.long _sys_mq_timedreceive	/* 280 */
+	.long _sys_mq_notify
+	.long _sys_mq_getsetattr
+	.long _sys_waitid
+	.long _sys_ni_syscall		/* sys_kexec_load */
+	.long _sys_add_key 		/* 285 */
+	.long _sys_request_key
+	.long _sys_keyctl
+	.long _sys_ioprio_set
+	.long _sys_ioprio_get		/* 290 */
+	.long _sys_inotify_init
+	.long _sys_inotify_add_watch
+	.long _sys_inotify_rm_watch
+	.long _sys_migrate_pages
+	.long _sys_openat		/* 295 */
+	.long _sys_mkdirat
+	.long _sys_mknodat
+	.long _sys_fchownat
+	.long _sys_futimesat
+	.long _sys_fstatat64		/* 300 */
+	.long _sys_unlinkat
+	.long _sys_renameat
+	.long _sys_linkat
+	.long _sys_symlinkat
+	.long _sys_readlinkat		/* 305 */
+	.long _sys_fchmodat
+	.long _sys_faccessat
+	.long _sys_ni_syscall		/* sys_pselect6 */
+	.long _sys_ni_syscall		/* sys_ppoll */
+	.long _sys_unshare		/* 310 */
+	.long _sys_set_robust_list
+	.long _sys_get_robust_list
+	.long _sys_splice
+	.long _sys_sync_file_range
+	.long _sys_tee			/* 315 */
+	.long _sys_vmsplice
+	.long _sys_ni_syscall		/* sys_move_pages */
+	.long _sys_getcpu
+	.long _sys_ni_syscall		/* sys_epoll_pwait */
+	.long _sys_setns		/* 320 */
diff --git a/arch/h8300/lib/abs.S b/arch/h8300/lib/abs.S
index cabdd46..ddd1fb3 100644
--- a/arch/h8300/lib/abs.S
+++ b/arch/h8300/lib/abs.S
@@ -9,10 +9,10 @@
 	.h8300s
 #endif
 	.text
-.global SYMBOL_NAME(abs)
+.global _abs
 
 ;;; int abs(int n)
-SYMBOL_NAME_LABEL(abs)
+_abs:
 	mov.l	er0,er0
 	bpl	1f
 	neg.l	er0
diff --git a/arch/h8300/lib/memcpy.S b/arch/h8300/lib/memcpy.S
index fdcbc1e..cad325e 100644
--- a/arch/h8300/lib/memcpy.S
+++ b/arch/h8300/lib/memcpy.S
@@ -10,10 +10,10 @@
 #endif
 
 	.text
-.global SYMBOL_NAME(memcpy)
+.global _memcpy
 
 ;;; void *memcpy(void *to, void *from, size_t n)
-SYMBOL_NAME_LABEL(memcpy)
+_memcpy:
 	mov.l	er2,er2
 	bne	1f
 	rts	
diff --git a/arch/h8300/lib/memset.S b/arch/h8300/lib/memset.S
index 59abdf9..4549a64 100644
--- a/arch/h8300/lib/memset.S
+++ b/arch/h8300/lib/memset.S
@@ -10,13 +10,13 @@
 #endif
 	.text
 
-.global	SYMBOL_NAME(memset)
+.global	_memset
 
 ;;void *memset(*ptr, int c, size_t count)
 ;; ptr = er0
 ;; c   = er1(r1l)
 ;; count = er2
-SYMBOL_NAME_LABEL(memset)
+_memset:
 	btst	#0,r0l
 	beq	2f
 
diff --git a/arch/h8300/platform/h8300h/aki3068net/crt0_ram.S b/arch/h8300/platform/h8300h/aki3068net/crt0_ram.S
index ecaeb31..b2ad0f2 100644
--- a/arch/h8300/platform/h8300h/aki3068net/crt0_ram.S
+++ b/arch/h8300/platform/h8300h/aki3068net/crt0_ram.S
@@ -22,10 +22,10 @@
 #define RAMEND CONFIG_BLKDEV_RESERVE_ADDRESS
 #endif
 	
-	.global SYMBOL_NAME(_start)
-	.global SYMBOL_NAME(command_line)
-	.global SYMBOL_NAME(_platform_gpio_table)
-	.global SYMBOL_NAME(_target_name)
+	.global __start
+	.global _command_line
+	.global __platform_gpio_table
+	.global __target_name
 	
 	.h8300h
 
@@ -33,7 +33,7 @@
 	.file	"crt0_ram.S"
 
 	/* CPU Reset entry */
-SYMBOL_NAME_LABEL(_start)
+__start:
 	mov.l	#RAMEND,sp
 	ldc	#0x80,ccr
 
@@ -59,13 +59,13 @@ SYMBOL_NAME_LABEL(_start)
 
 	/* copy kernel commandline */
 	mov.l	#COMMAND_START,er5
-	mov.l	#SYMBOL_NAME(command_line),er6
+	mov.l	#_command_line,er6
 	mov.w	#512,r4
 	eepmov.w
 
 	/* uClinux kernel start */
 	ldc	#0x90,ccr	/* running kernel */
-	mov.l	#SYMBOL_NAME(init_thread_union),sp
+	mov.l	#_init_thread_union,sp
 	add.l	#0x2000,sp
 	jsr	@_start_kernel
 _exit:
@@ -107,4 +107,4 @@ __target_name:
 	.asciz	"AE-3068"
 	
 	.section .bootvec,"ax"
-	jmp	@SYMBOL_NAME(_start)
+	jmp	@__start
diff --git a/arch/h8300/platform/h8300h/generic/crt0_ram.S b/arch/h8300/platform/h8300h/generic/crt0_ram.S
index 80d0e16..5ab7d9c 100644
--- a/arch/h8300/platform/h8300h/generic/crt0_ram.S
+++ b/arch/h8300/platform/h8300h/generic/crt0_ram.S
@@ -22,10 +22,10 @@
 #define RAMEND CONFIG_BLKDEV_RESERVE_ADDRESS
 #endif
 	
-	.global SYMBOL_NAME(_start)
-	.global SYMBOL_NAME(command_line)
-	.global SYMBOL_NAME(_platform_gpio_table)
-	.global SYMBOL_NAME(_target_name)
+	.global __start
+	.global _command_line
+	.global __platform_gpio_table
+	.global __target_name
 	
 	.h8300h
 
@@ -33,7 +33,7 @@
 	.file	"crt0_ram.S"
 
 	/* CPU Reset entry */
-SYMBOL_NAME_LABEL(_start)
+__start:
 	mov.l	#RAMEND,sp
 	ldc	#0x80,ccr
 
@@ -59,13 +59,13 @@ SYMBOL_NAME_LABEL(_start)
 
 	/* copy kernel commandline */
 	mov.l	#COMMAND_START,er5
-	mov.l	#SYMBOL_NAME(command_line),er6
+	mov.l	#_command_line,er6
 	mov.w	#512,r4
 	eepmov.w
 
 	/* uClinux kernel start */
 	ldc	#0x90,ccr	/* running kernel */
-	mov.l	#SYMBOL_NAME(init_thread_union),sp
+	mov.l	#_init_thread_union,sp
 	add.l	#0x2000,sp
 	jsr	@_start_kernel
 _exit:
diff --git a/arch/h8300/platform/h8300h/generic/crt0_rom.S b/arch/h8300/platform/h8300h/generic/crt0_rom.S
index 120add7..dda1dfa 100644
--- a/arch/h8300/platform/h8300h/generic/crt0_rom.S
+++ b/arch/h8300/platform/h8300h/generic/crt0_rom.S
@@ -12,17 +12,17 @@
 
 #include <asm/linkage.h>
 	
-	.global SYMBOL_NAME(_start)
-	.global SYMBOL_NAME(_command_line)
-	.global SYMBOL_NAME(_platform_gpio_table)
-	.global SYMBOL_NAME(_target_name)
+	.global __start
+	.global __command_line
+	.global __platform_gpio_table
+	.global __target_name
 	
 	.h8300h
 	.section .text
 	.file	"crt0_rom.S"
 
 	/* CPU Reset entry */
-SYMBOL_NAME_LABEL(_start)
+__start:
 	mov.l	#__ramend,sp
 	ldc	#0x80,ccr
 
@@ -60,13 +60,13 @@ SYMBOL_NAME_LABEL(_start)
 
 	/* copy kernel commandline */
 	mov.l	#COMMAND_START,er5
-	mov.l	#SYMBOL_NAME(_command_line),er6
+	mov.l	#__command_line,er6
 	mov.w	#512,r4
 	eepmov.w
 
 	/* linux kernel start */
 	ldc	#0x90,ccr	/* running kernel */
-	mov.l	#SYMBOL_NAME(init_thread_union),sp
+	mov.l	#_init_thread_union,sp
 	add.l	#0x2000,sp
 	jsr	@_start_kernel
 _exit:
diff --git a/arch/h8300/platform/h8300h/h8max/crt0_ram.S b/arch/h8300/platform/h8300h/h8max/crt0_ram.S
index efcbefb..6a0d4e2 100644
--- a/arch/h8300/platform/h8300h/h8max/crt0_ram.S
+++ b/arch/h8300/platform/h8300h/h8max/crt0_ram.S
@@ -22,10 +22,10 @@
 #define RAMEND CONFIG_BLKDEV_RESERVE_ADDRESS
 #endif
 	
-	.global SYMBOL_NAME(_start)
-	.global SYMBOL_NAME(command_line)
-	.global SYMBOL_NAME(_platform_gpio_table)
-	.global SYMBOL_NAME(_target_name)
+	.global __start
+	.global _command_line
+	.global __platform_gpio_table
+	.global __target_name
 	
 	.h8300h
 
@@ -33,7 +33,7 @@
 	.file	"crt0_ram.S"
 
 	/* CPU Reset entry */
-SYMBOL_NAME_LABEL(_start)
+__start:
 	mov.l	#RAMEND,sp
 	ldc	#0x80,ccr
 
@@ -59,13 +59,13 @@ SYMBOL_NAME_LABEL(_start)
 
 	/* copy kernel commandline */
 	mov.l	#COMMAND_START,er5
-	mov.l	#SYMBOL_NAME(command_line),er6
+	mov.l	#_command_line,er6
 	mov.w	#512,r4
 	eepmov.w
 
 	/* uClinux kernel start */
 	ldc	#0x90,ccr	/* running kernel */
-	mov.l	#SYMBOL_NAME(init_thread_union),sp
+	mov.l	#_init_thread_union,sp
 	add.l	#0x2000,sp
 	jsr	@_start_kernel
 _exit:
@@ -107,4 +107,4 @@ __target_name:
 	.asciz	"H8MAX"
 	
 	.section .bootvec,"ax"
-	jmp	@SYMBOL_NAME(_start)
+	jmp	@__start
diff --git a/arch/h8300/platform/h8s/edosk2674/crt0_ram.S b/arch/h8300/platform/h8s/edosk2674/crt0_ram.S
index d12b0de..5ed191b 100644
--- a/arch/h8300/platform/h8s/edosk2674/crt0_ram.S
+++ b/arch/h8300/platform/h8s/edosk2674/crt0_ram.S
@@ -23,10 +23,10 @@
 #define RAMEND CONFIG_BLKDEV_RESERVE_ADDRESS
 #endif
 	
-	.global SYMBOL_NAME(_start)
-	.global SYMBOL_NAME(_command_line)
-	.global SYMBOL_NAME(_platform_gpio_table)
-	.global SYMBOL_NAME(_target_name)
+	.global __start
+	.global __command_line
+	.global __platform_gpio_table
+	.global __target_name
 	
 	.h8300s
 
@@ -34,7 +34,7 @@
 	.file	"crt0_ram.S"
 
 	/* CPU Reset entry */
-SYMBOL_NAME_LABEL(_start)
+__start:
 	mov.l	#RAMEND,sp
 	ldc	#0x80,ccr
 	ldc	#0x00,exr
@@ -66,13 +66,13 @@ SYMBOL_NAME_LABEL(_start)
 
 	/* copy kernel commandline */
 	mov.l	#COMMAND_START,er5
-	mov.l	#SYMBOL_NAME(command_line),er6
+	mov.l	#_command_line,er6
 	mov.w	#512,r4
 	eepmov.w
 
 	/* uClinux kernel start */
 	ldc	#0x90,ccr	/* running kernel */
-	mov.l	#SYMBOL_NAME(init_thread_union),sp
+	mov.l	#_init_thread_union,sp
 	add.l	#0x2000,sp
 	jsr	@_start_kernel
 _exit:
@@ -127,4 +127,4 @@ __target_name:
 	.asciz	"EDOSK-2674"
 	
 	.section .bootvec,"ax"
-	jmp	@SYMBOL_NAME(_start)
+	jmp	@__start
diff --git a/arch/h8300/platform/h8s/edosk2674/crt0_rom.S b/arch/h8300/platform/h8s/edosk2674/crt0_rom.S
index c03d23c..06d1d7f 100644
--- a/arch/h8300/platform/h8s/edosk2674/crt0_rom.S
+++ b/arch/h8300/platform/h8s/edosk2674/crt0_rom.S
@@ -13,17 +13,17 @@
 #include <asm/linkage.h>
 #include <asm/regs267x.h>
 		
-	.global SYMBOL_NAME(_start)
-	.global SYMBOL_NAME(_command_line)
-	.global SYMBOL_NAME(_platform_gpio_table)
-	.global SYMBOL_NAME(_target_name)
+	.global __start
+	.global __command_line
+	.global __platform_gpio_table
+	.global __target_name
 	
 	.h8300s
 	.section .text
 	.file	"crt0_rom.S"
 
 	/* CPU Reset entry */
-SYMBOL_NAME_LABEL(_start)
+__start:
 	mov.l	#__ramend,sp
 	ldc	#0x80,ccr
 	ldc	#0,exr
@@ -82,13 +82,13 @@ SYMBOL_NAME_LABEL(_start)
 
 	/* copy kernel commandline */
 	mov.l	#COMMAND_START,er5
-	mov.l	#SYMBOL_NAME(_command_line),er6
+	mov.l	#__command_line,er6
 	mov.w	#512,r4
 	eepmov.w
 
 	/* linux kernel start */
 	ldc	#0x90,ccr	/* running kernel */
-	mov.l	#SYMBOL_NAME(init_thread_union),sp
+	mov.l	#_init_thread_union,sp
 	add.l	#0x2000,sp
 	jsr	@_start_kernel
 _exit:
diff --git a/arch/h8300/platform/h8s/generic/crt0_ram.S b/arch/h8300/platform/h8s/generic/crt0_ram.S
index b045410..7018915 100644
--- a/arch/h8300/platform/h8s/generic/crt0_ram.S
+++ b/arch/h8300/platform/h8s/generic/crt0_ram.S
@@ -23,10 +23,10 @@
 #define RAMEND CONFIG_BLKDEV_RESERVE_ADDRESS
 #endif
 	
-	.global SYMBOL_NAME(_start)
-	.global SYMBOL_NAME(_command_line)
-	.global SYMBOL_NAME(_platform_gpio_table)
-	.global SYMBOL_NAME(_target_name)
+	.global __start
+	.global __command_line
+	.global __platform_gpio_table
+	.global __target_name
 	
 	.h8300s
 
@@ -34,7 +34,7 @@
 	.file	"crt0_ram.S"
 
 	/* CPU Reset entry */
-SYMBOL_NAME_LABEL(_start)
+__start:
 	mov.l	#RAMEND,sp
 	ldc	#0x80,ccr
 	ldc	#0x00,exr
@@ -63,13 +63,13 @@ SYMBOL_NAME_LABEL(_start)
 
 	/* copy kernel commandline */
 	mov.l	#COMMAND_START,er5
-	mov.l	#SYMBOL_NAME(command_line),er6
+	mov.l	#_command_line,er6
 	mov.w	#512,r4
 	eepmov.w
 
 	/* uClinux kernel start */
 	ldc	#0x90,ccr	/* running kernel */
-	mov.l	#SYMBOL_NAME(init_thread_union),sp
+	mov.l	#_init_thread_union,sp
 	add.l	#0x2000,sp
 	jsr	@_start_kernel
 _exit:
@@ -124,4 +124,4 @@ __target_name:
 	.asciz	"generic"
 	
 	.section .bootvec,"ax"
-	jmp	@SYMBOL_NAME(_start)
+	jmp	@__start
diff --git a/arch/h8300/platform/h8s/generic/crt0_rom.S b/arch/h8300/platform/h8s/generic/crt0_rom.S
index 95b6f28..623ba78 100644
--- a/arch/h8300/platform/h8s/generic/crt0_rom.S
+++ b/arch/h8300/platform/h8s/generic/crt0_rom.S
@@ -13,17 +13,17 @@
 #include <asm/linkage.h>
 #include <asm/regs267x.h>
 	
-	.global SYMBOL_NAME(_start)
-	.global SYMBOL_NAME(_command_line)
-	.global SYMBOL_NAME(_platform_gpio_table)
-	.global SYMBOL_NAME(_target_name)
+	.global __start
+	.global __command_line
+	.global __platform_gpio_table
+	.global __target_name
 	
 	.h8300s
 	.section .text
 	.file	"crt0_rom.S"
 
 	/* CPU Reset entry */
-SYMBOL_NAME_LABEL(_start)
+__start:
 	mov.l	#__ramend,sp
 	ldc	#0x80,ccr
 	ldc	#0,exr
@@ -61,7 +61,7 @@ SYMBOL_NAME_LABEL(_start)
 
 	/* linux kernel start */
 	ldc	#0x90,ccr	/* running kernel */
-	mov.l	#SYMBOL_NAME(init_thread_union),sp
+	mov.l	#_init_thread_union,sp
 	add.l	#0x2000,sp
 	jsr	@_start_kernel
 _exit:
-- 
1.7.0.4

