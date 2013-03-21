Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab3CUV5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:57:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:33217 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab3CUVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:17 -0400
Message-Id: <20130321215234.886530981@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 24/34] openrisc: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=openrisc-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Idle poller with an extra check_pgt_cache() invocation. Use the core
code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/openrisc/Kconfig       |    1 
 arch/openrisc/kernel/idle.c |   73 --------------------------------------------
 2 files changed, 1 insertion(+), 73 deletions(-)

Index: linux-2.6/arch/openrisc/Kconfig
===================================================================
--- linux-2.6.orig/arch/openrisc/Kconfig
+++ linux-2.6/arch/openrisc/Kconfig
@@ -21,6 +21,7 @@ config OPENRISC
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select GENERIC_IDLE_LOOP
 	select MODULES_USE_ELF_RELA
 
 config MMU
Index: linux-2.6/arch/openrisc/kernel/idle.c
===================================================================
--- linux-2.6.orig/arch/openrisc/kernel/idle.c
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


