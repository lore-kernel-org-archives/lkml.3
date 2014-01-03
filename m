Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaACNz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:55:58 -0500
Received: from www.linutronix.de ([62.245.132.108]:42487 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaACNz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:55:56 -0500
Date: Fri, 3 Jan 2014 14:55:48 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>, 723180@bugs.debian.org,
        Brian Silverman <bsilver16384@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] Revert "x86: Disable IST stacks for debug/int 3/stack
 fault for PREEMPT_RT"
Message-ID: <20140103135548.GA6327@linutronix.de>
References: <20130917061329.4872.51468.reportbug@dell-inspiron-linux.dlinkrouter>
 <1379427451.23881.48.camel@deadeye.wl.decadent.org.uk>
 <CAP01z6LVxoA6kDJeL8NuO2aA22BjMvXSk9ZY7z9cOK1=k56vpg@mail.gmail.com>
 <1379905562.3913.8.camel@deadeye.wl.decadent.org.uk>
 <CAP01z6+j6moUio9pc3G3iz+ebJCdKEvngddxnxazRP+NXwLkyg@mail.gmail.com>
 <1380115449.4430.21.camel@deadeye.wl.decadent.org.uk>
 <52AE0419.3050103@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52AE0419.3050103@linutronix.de>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

where do I start. Let me explain what is going on here. The code
sequence
| pushf
| pop    %edx
| or     $0x1,%dh
| push   %edx
| mov    $0xe0,%eax
| popf
| sysenter

triggers the bug. On 64bit kernel we see the double fault (with 32bit and
64bit userland) and on 32bit kernel there is no problem. The reporter said
that double fault does not happen on 64bit kernel with 64bit userland and
this is because in that case the VDSO uses the "syscall" interface instead
of "sysenter".

The bug. "popf" loads the flags with the TF bit set which enables
"single stepping" and this leads to a debug exception. Usually on 64bit
we have a special IST stack for the debug exception. Due to patch [0] we
do not use the IST stack but the kernel stack instead. On 64bit the
sysenter instruction starts in kernel with the stack address NULL. The
code sequence above enters the debug exception (TF flag) after the
sysenter instruction was executed which sets the stack pointer to NULL
and we have a fault (it seems that the debug exception saves some bytes
on the stack).
To fix the double fault I'm going to drop patch [0]. It is completely
pointless. In do_debug() and do_stack_segment() we disable preemption
which means the task can't leave the CPU. So it does not matter if we run
on IST or on kernel stack.
There is a patch [1] which drops preempt_disable() call for a 32bit
kernel but not for 64bit so there should be no regression.
And [1] seems valid even for this code sequence. We enter the debug
exception with a 256bytes long per cpu stack and migrate to the kernel
stack before calling do_debug().

[0] x86-disable-debug-stack.patch
[1] fix-rt-int3-x86_32-3.2-rt.patch

Reported-by: Brian Silverman <bsilver16384@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/include/asm/page_64_types.h | 21 ++++++---------------
 arch/x86/kernel/cpu/common.c         |  2 --
 arch/x86/kernel/dumpstack_64.c       |  4 ----
 3 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 695e04d..43dcd80 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -14,21 +14,12 @@
 #define IRQ_STACK_ORDER 2
 #define IRQ_STACK_SIZE (PAGE_SIZE << IRQ_STACK_ORDER)
 
-#ifdef CONFIG_PREEMPT_RT_FULL
-# define STACKFAULT_STACK 0
-# define DOUBLEFAULT_STACK 1
-# define NMI_STACK 2
-# define DEBUG_STACK 0
-# define MCE_STACK 3
-# define N_EXCEPTION_STACKS 3  /* hw limit: 7 */
-#else
-# define STACKFAULT_STACK 1
-# define DOUBLEFAULT_STACK 2
-# define NMI_STACK 3
-# define DEBUG_STACK 4
-# define MCE_STACK 5
-# define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
-#endif
+#define STACKFAULT_STACK 1
+#define DOUBLEFAULT_STACK 2
+#define NMI_STACK 3
+#define DEBUG_STACK 4
+#define MCE_STACK 5
+#define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
 
 #define PUD_PAGE_SIZE		(_AC(1, UL) << PUD_SHIFT)
 #define PUD_PAGE_MASK		(~(PUD_PAGE_SIZE-1))
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c0dcf06..2793d1f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1105,9 +1105,7 @@ DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
  */
 static const unsigned int exception_stack_sizes[N_EXCEPTION_STACKS] = {
 	  [0 ... N_EXCEPTION_STACKS - 1]	= EXCEPTION_STKSZ,
-#if DEBUG_STACK > 0
 	  [DEBUG_STACK - 1]			= DEBUG_STKSZ
-#endif
 };
 
 static DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 52b4bcd..addb207 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -21,14 +21,10 @@
 		(N_EXCEPTION_STACKS + DEBUG_STKSZ/EXCEPTION_STKSZ - 2)
 
 static char x86_stack_ids[][8] = {
-#if DEBUG_STACK > 0
 		[ DEBUG_STACK-1			]	= "#DB",
-#endif
 		[ NMI_STACK-1			]	= "NMI",
 		[ DOUBLEFAULT_STACK-1		]	= "#DF",
-#if STACKFAULT_STACK > 0
 		[ STACKFAULT_STACK-1		]	= "#SS",
-#endif
 		[ MCE_STACK-1			]	= "#MC",
 #if DEBUG_STKSZ > EXCEPTION_STKSZ
 		[ N_EXCEPTION_STACKS ...
-- 
1.8.5.2

