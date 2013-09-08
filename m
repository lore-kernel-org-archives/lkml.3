Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160Ab3IHDvW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:51:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56194 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756816Ab3IHDTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:01 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Russell King" <rmk+kernel@arm.linux.org.uk>,
        "Will Deacon" <will.deacon@arm.com>,
        "Ashish Sangwan" <ashishsangwan2@gmail.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.458899962@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [036/121] ARM: 7791/1: a.out: remove partial a.out support
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit acfdd4b1f7590d02e9bae3b73bdbbc4a31b05d38 upstream.

a.out support on ARM requires that argc, argv and envp are passed in
r0-r2 respectively, which requires hacking load_aout_binary to
prevent argc being clobbered by the return code. Whilst mainline kernels
do set the registers up in start_thread, the aout loader has never
carried the hack in mainline.

Initialising the registers in this way actually goes against the libc
expectations for ELF binaries, where argc, argv and envp are passed on
the stack, with r0 being used to hold a pointer to an exit function for
cleaning up after the dynamic linker if required. If the pointer is
NULL, then it is ignored. When execing an ELF binary, Linux currently
zeroes r0, then sets it to argc and then finally clobbers it with the
return value of the execve syscall, so we actually end up with:

	r0 = 0
	stack[0] = argc
	r1 = stack[1] = argv
	r2 = stack[2] = envp

libc treats r1 and r2 as undefined. The clobbering of r0 by sys_execve
works for user-spawned threads, but when executing an ELF binary from a
kernel thread (via call_usermodehelper), the execve is performed on the
ret_from_fork path, which restores r0 from the saved pt_regs, resulting
in argc being presented to the C library. This has horrible consequences
when the application exits, since we have an exit function registered
using argc, resulting in a jump to hyperspace.

This patch solves the problem by removing the partial a.out support from
arch/arm/ altogether.

Cc: Ashish Sangwan <ashishsangwan2@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[bwh: Backported to 3.2:
 - Adjust context
 - Adjust uapi filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1,7 +1,6 @@
 config ARM
 	bool
 	default y
-	select HAVE_AOUT
 	select HAVE_DMA_API_DEBUG
 	select HAVE_IDE if PCI || ISA || PCMCIA
 	select HAVE_MEMBLOCK
--- a/arch/arm/include/asm/a.out-core.h
+++ /dev/null
@@ -1,45 +0,0 @@
-/* a.out coredump register dumper
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#ifndef _ASM_A_OUT_CORE_H
-#define _ASM_A_OUT_CORE_H
-
-#ifdef __KERNEL__
-
-#include <linux/user.h>
-#include <linux/elfcore.h>
-
-/*
- * fill in the user structure for an a.out core dump
- */
-static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
-{
-	struct task_struct *tsk = current;
-
-	dump->magic = CMAGIC;
-	dump->start_code = tsk->mm->start_code;
-	dump->start_stack = regs->ARM_sp & ~(PAGE_SIZE - 1);
-
-	dump->u_tsize = (tsk->mm->end_code - tsk->mm->start_code) >> PAGE_SHIFT;
-	dump->u_dsize = (tsk->mm->brk - tsk->mm->start_data + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	dump->u_ssize = 0;
-
-	memset(dump->u_debugreg, 0, sizeof(dump->u_debugreg));
-
-	if (dump->start_stack < 0x04000000)
-		dump->u_ssize = (0x04000000 - dump->start_stack) >> PAGE_SHIFT;
-
-	dump->regs = *regs;
-	dump->u_fpvalid = dump_fpu (regs, &dump->u_fp);
-}
-
-#endif /* __KERNEL__ */
-#endif /* _ASM_A_OUT_CORE_H */
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -54,7 +54,6 @@ struct thread_struct {
 
 #define start_thread(regs,pc,sp)					\
 ({									\
-	unsigned long *stack = (unsigned long *)sp;			\
 	set_fs(USER_DS);						\
 	memset(regs->uregs, 0, sizeof(regs->uregs));			\
 	if (current->personality & ADDR_LIMIT_32BIT)			\
@@ -66,9 +65,6 @@ struct thread_struct {
 	regs->ARM_cpsr |= PSR_ENDSTATE;					\
 	regs->ARM_pc = pc & ~1;		/* pc */			\
 	regs->ARM_sp = sp;		/* sp */			\
-	regs->ARM_r2 = stack[2];	/* r2 (envp) */			\
-	regs->ARM_r1 = stack[1];	/* r1 (argv) */			\
-	regs->ARM_r0 = stack[0];	/* r0 (argc) */			\
 	nommu_start_thread(regs);					\
 })
 
--- a/arch/arm/include/asm/a.out.h
+++ /dev/null
@@ -1,34 +0,0 @@
-#ifndef __ARM_A_OUT_H__
-#define __ARM_A_OUT_H__
-
-#include <linux/personality.h>
-#include <linux/types.h>
-
-struct exec
-{
-  __u32 a_info;		/* Use macros N_MAGIC, etc for access */
-  __u32 a_text;		/* length of text, in bytes */
-  __u32 a_data;		/* length of data, in bytes */
-  __u32 a_bss;		/* length of uninitialized data area for file, in bytes */
-  __u32 a_syms;		/* length of symbol table data in file, in bytes */
-  __u32 a_entry;	/* start address */
-  __u32 a_trsize;	/* length of relocation info for text, in bytes */
-  __u32 a_drsize;	/* length of relocation info for data, in bytes */
-};
-
-/*
- * This is always the same
- */
-#define N_TXTADDR(a)	(0x00008000)
-
-#define N_TRSIZE(a)	((a).a_trsize)
-#define N_DRSIZE(a)	((a).a_drsize)
-#define N_SYMSIZE(a)	((a).a_syms)
-
-#define M_ARM 103
-
-#ifndef LIBRARY_START_TEXT
-#define LIBRARY_START_TEXT	(0x00c00000)
-#endif
-
-#endif /* __A_OUT_GNU_H__ */

