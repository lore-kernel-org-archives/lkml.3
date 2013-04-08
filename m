Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936186Ab3DHUhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:37:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40916 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936032Ab3DHUhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:37:20 -0400
Date: Mon, 8 Apr 2013 13:36:55 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-6862c05ce4bc59ac52165df66f2a55ad692ef941@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20130321215234.886530981@linutronix.de>
References: <20130321215234.886530981@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] openrisc: Use generic idle loop
Git-Commit-ID: 6862c05ce4bc59ac52165df66f2a55ad692ef941
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:37:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6862c05ce4bc59ac52165df66f2a55ad692ef941
Gitweb:     http://git.kernel.org/tip/6862c05ce4bc59ac52165df66f2a55ad692ef941
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:54 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:27 +0200

openrisc: Use generic idle loop

Idle poller with an extra check_pgt_cache() invocation. Use the core
code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130321215234.886530981@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/openrisc/Kconfig         |  1 +
 arch/openrisc/kernel/Makefile |  2 +-
 arch/openrisc/kernel/idle.c   | 73 -------------------------------------------
 3 files changed, 2 insertions(+), 74 deletions(-)

diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index 9ab3bf2..e111b52 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -21,6 +21,7 @@ config OPENRISC
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select GENERIC_IDLE_LOOP
 	select MODULES_USE_ELF_RELA
 
 config MMU
diff --git a/arch/openrisc/kernel/Makefile b/arch/openrisc/kernel/Makefile
index 35f92ce..ec6d9d3 100644
--- a/arch/openrisc/kernel/Makefile
+++ b/arch/openrisc/kernel/Makefile
@@ -4,7 +4,7 @@
 
 extra-y	:= head.o vmlinux.lds
 
-obj-y	:= setup.o idle.o or32_ksyms.o process.o dma.o \
+obj-y	:= setup.o or32_ksyms.o process.o dma.o \
 	   traps.o time.o irq.o entry.o ptrace.o signal.o \
 	   sys_call_table.o
 
diff --git a/arch/openrisc/kernel/idle.c b/arch/openrisc/kernel/idle.c
deleted file mode 100644
index 5e8a3b6..0000000
--- a/arch/openrisc/kernel/idle.c
+++ /dev/null
@@ -1,73 +0,0 @@
-/*
- * OpenRISC idle.c
- *
- * Linux architectural port borrowing liberally from similar works of
- * others.  All original copyrights apply as per the original source
- * declaration.
- *
- * Modifications for the OpenRISC architecture:
- * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
- * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
- *
- *      This program is free software; you can redistribute it and/or
- *      modify it under the terms of the GNU General Public License
- *      as published by the Free Software Foundation; either version
- *      2 of the License, or (at your option) any later version.
- *
- * Idle daemon for or32.  Idle daemon will handle any action
- * that needs to be taken when the system becomes idle.
- */
-
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/smp.h>
-#include <linux/stddef.h>
-#include <linux/unistd.h>
-#include <linux/ptrace.h>
-#include <linux/slab.h>
-#include <linux/tick.h>
-
-#include <asm/pgtable.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
-#include <asm/processor.h>
-#include <asm/mmu.h>
-#include <asm/cache.h>
-#include <asm/pgalloc.h>
-
-void (*powersave) (void) = NULL;
-
-void cpu_idle(void)
-{
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-
-		while (!need_resched()) {
-			check_pgt_cache();
-			rmb();
-
-			clear_thread_flag(TIF_POLLING_NRFLAG);
-
-			local_irq_disable();
-			/* Don't trace irqs off for idle */
-			stop_critical_timings();
-			if (!need_resched() && powersave != NULL)
-				powersave();
-			start_critical_timings();
-			local_irq_enable();
-			set_thread_flag(TIF_POLLING_NRFLAG);
-		}
-
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
-	}
-}
