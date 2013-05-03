Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762943Ab3ECJVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:21:36 -0400
Received: from service87.mimecast.com ([91.220.42.44]:59376 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab3ECJVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:21:33 -0400
Message-ID: <5183819E.50308@arm.com>
Date: Fri, 03 May 2013 10:21:34 +0100
From: Jonathan Austin <jonathan.austin@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcsOpIEhlbnRzY2hlbA==?= <nerv@dawncrow.de>
CC: Will Deacon <Will.Deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2] arm: Preserve TPIDRURW on context switch
References: <517168BB.3070903@dawncrow.de> <20130422143616.GP14496@n2100.arm.linux.org.uk> <20130422151836.GA15665@mudshark.cambridge.arm.com> <5175A697.3080308@dawncrow.de> <20130423091536.GB17593@mudshark.cambridge.arm.com> <51770E4E.2040003@dawncrow.de> <20130424094251.GA21850@mudshark.cambridge.arm.com> <5182C480.3080001@dawncrow.de>
In-Reply-To: <5182C480.3080001@dawncrow.de>
X-OriginalArrivalTime: 03 May 2013 09:21:31.0142 (UTC) FILETIME=[990DCA60:01CE47DF]
X-MC-Unique: 113050310213104001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi André,

Will pointed me at this thread and I had a look at fixing
this up yesterday by extending his original patch...

There are a few things about this that aren't quite right. Most
of the comments are cosmetic but there's an issue in copy_thread
that will result in incorrect behaviour, I think.

I've commented below inline and there's a patch at the bottom- can
you let me know if it works for you?

On 02/05/13 20:54, André Hentschel wrote:
> Am 24.04.2013 11:42, schrieb Will Deacon:
>> Hi Andrew,
>>
>> On Tue, Apr 23, 2013 at 11:42:22PM +0100, André Hentschel wrote:
>>> Am 23.04.2013 11:15, schrieb Will Deacon:
>>>> You could introduce `get' tls functions, which don't do anything for CPUs
>>>> without the relevant registers.
>>>
>>> Before i have another round of testing and patch formatting/sending,
>>> what about the untested patch below?
>>
>> Ok. Comments inline.
> 
> I answered to that seperatly.
> Here is another try based on your comments:
> 
> 
> 
> diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
> index cddda1f..bb5b48d 100644
> --- a/arch/arm/include/asm/thread_info.h
> +++ b/arch/arm/include/asm/thread_info.h
> @@ -58,7 +58,7 @@ struct thread_info {
>   	struct cpu_context_save	cpu_context;	/* cpu context */
>   	__u32			syscall;	/* syscall number */
>   	__u8			used_cp[16];	/* thread used copro */
> -	unsigned long		tp_value;
> +	unsigned long		tp_value[2];
>   #ifdef CONFIG_CRUNCH
>   	struct crunch_state	crunchstate;
>   #endif
> diff --git a/arch/arm/include/asm/tls.h b/arch/arm/include/asm/tls.h
> index 73409e6..02f8674 100644
> --- a/arch/arm/include/asm/tls.h
> +++ b/arch/arm/include/asm/tls.h
> @@ -2,48 +2,87 @@
>   #define __ASMARM_TLS_H
>   
>   #ifdef __ASSEMBLY__
> +	.macro check_hwcap_tls, tmp1
> +	ldr	\tmp1, =elf_hwcap
> +	ldr	\tmp1, [\tmp1, #0]
> +	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
> +	.endm
> +
> +
> +	.macro get_tls_none, tp, tmp1
> +	.endm
> +
> +	.macro get_tls_v6k, tp, tmp1
> +	mrc	p15, 0, \tmp1, c13, c0, 2		@ get user r/w TLS register
> +	str	\tmp1, [\tp, #4]
> +	.endm
> +
> +	.macro get_tls_v6, tp, tmp1
> +	check_hwcap_tls \tmp1

I tend to steer clear of asm that requires certain behaviour wrt
the flags, though in this case I think it's probably a sufficiently
self contained case to be okay...

> +	mrcne	p15, 0, \tmp1, c13, c0, 2		@ get user r/w TLS register
> +	strne	\tmp1, [\tp, #4]
> +	.endm
> +
> +
>   	.macro set_tls_none, tp, tmp1, tmp2
>   	.endm
>   
>   	.macro set_tls_v6k, tp, tmp1, tmp2
> -	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
> -	mov	\tmp1, #0
> -	mcr	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
> +	ldrd	\tmp1, \tmp2, [\tp]
> +	mcr	p15, 0, \tmp1, c13, c0, 3	@ set user r/o TLS register
> +	mcr	p15, 0, \tmp2, c13, c0, 2	@ set user r/w TLS register
>   	.endm
>   
>   	.macro set_tls_v6, tp, tmp1, tmp2
> -	ldr	\tmp1, =elf_hwcap
> -	ldr	\tmp1, [\tmp1, #0]
>   	mov	\tmp2, #0xffff0fff
> -	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
> -	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
> -	movne	\tmp1, #0
> -	mcrne	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
> -	streq	\tp, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
> +	check_hwcap_tls \tmp1
> +	ldrdne	\tmp1, \tmp2, [\tp]
> +	ldreq	\tmp1, [\tp]
> +	mcrne	p15, 0, \tmp1, c13, c0, 3	@ yes, set user r/o TLS register
> +	mcrne	p15, 0, \tmp2, c13, c0, 2	@ set user r/w TLS register
> +	streq	\tmp1, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
>   	.endm
>   
>   	.macro set_tls_software, tp, tmp1, tmp2
> -	mov	\tmp1, #0xffff0fff
> -	str	\tp, [\tmp1, #-15]		@ set TLS value at 0xffff0ff0
> +	ldr	\tmp1, [\tp]
> +	mov	\tmp2, #0xffff0fff
> +	str	\tmp1, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
>   	.endm
>   #endif
>   
>   #ifdef CONFIG_TLS_REG_EMUL
>   #define tls_emu		1
>   #define has_tls_reg		1
> +#define get_tls		get_tls_none

This is different from the set_tls, which deals with both
tpidrurw and tpidruro, so the naming is a little inconsistent here...

>   #define set_tls		set_tls_none
>   #elif defined(CONFIG_CPU_V6)
>   #define tls_emu		0
>   #define has_tls_reg		(elf_hwcap & HWCAP_TLS)
> +#define get_tls		get_tls_v6
>   #define set_tls		set_tls_v6
>   #elif defined(CONFIG_CPU_32v6K)
>   #define tls_emu		0
>   #define has_tls_reg		1
> +#define get_tls		get_tls_v6k
>   #define set_tls		set_tls_v6k
>   #else
>   #define tls_emu		0
>   #define has_tls_reg		0
> +#define get_tls		get_tls_none
>   #define set_tls		set_tls_software
>   #endif
>   
> +#ifndef __ASSEMBLY__
> +static inline void get_tpidrurw(unsigned long *tpidrurw)

A bit weird to have tpidrurw here but tls elsewhere - I
settled on tlsuser... (see below)

> +{
> +	unsigned long t;
> +#ifdef CONFIG_TLS_REG_EMUL
> +	return;
> +#endif
> +	if (!has_tls_reg) return;
> +	__asm__("mcr p15, 0, %0, c13, c0, 2" : : "r" (t));
> +	*tpidrurw = t;
> +}
> +#endif
> +
>   #endif	/* __ASMARM_TLS_H */
> diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
> index 0f82098..2c892b2 100644
> --- a/arch/arm/kernel/entry-armv.S
> +++ b/arch/arm/kernel/entry-armv.S
> @@ -728,7 +728,7 @@ ENTRY(__switch_to)
>    UNWIND(.fnstart	)
>    UNWIND(.cantunwind	)
>   	add	ip, r1, #TI_CPU_SAVE
> -	ldr	r3, [r2, #TI_TP_VALUE]
> +	add	r3, r1, #TI_TP_VALUE
>    ARM(	stmia	ip!, {r4 - sl, fp, sp, lr} )	@ Store most regs on stack
>    THUMB(	stmia	ip!, {r4 - sl, fp}	   )	@ Store most regs on stack
>    THUMB(	str	sp, [ip], #4		   )
> @@ -736,6 +736,8 @@ ENTRY(__switch_to)
>   #ifdef CONFIG_CPU_USE_DOMAINS
>   	ldr	r6, [r2, #TI_CPU_DOMAIN]
>   #endif
> +	get_tls	r3, r4
> +	add	r3, r2, #TI_TP_VALUE
>   	set_tls	r3, r4, r5
>   #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
>   	ldr	r7, [r2, #TI_TASK]
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index 047d3e4..a13bbc8 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -36,6 +36,7 @@
>   #include <asm/cacheflush.h>
>   #include <asm/idmap.h>
>   #include <asm/processor.h>
> +#include <asm/tls.h>
>   #include <asm/thread_notify.h>
>   #include <asm/stacktrace.h>
>   #include <asm/mach/time.h>
> @@ -395,7 +396,10 @@ copy_thread(unsigned long clone_flags, unsigned long stack_start,
>   	clear_ptrace_hw_breakpoint(p);
>   
>   	if (clone_flags & CLONE_SETTLS)
> -		thread->tp_value = childregs->ARM_r3;
> +	{
> +		thread->tp_value[0] = childregs->ARM_r3;
> +		get_tpidrurw(&thread->tp_value[1]);
> +	}

This isn't quite right - the re-reading of tpidrurw should
be independent of CLONE_SETTLS. We should update tpidrurw
from userspace in all cases.

The following is what I've been looking at/testing...
It works on V7 and I've build tested it for 1136 - I would've
sent it yesterday but was getting things set up for testing on
1136 (v6 not k)

----8<-------
>From bd3fe4055777b404a1635f366483637fd0cfa35a Mon Sep 17 00:00:00 2001
From: Jonathan Austin <jonathan.austin@arm.com>
Date: Fri, 8 Feb 2013 15:55:12 +0000
Subject: [PATCH] ARM: tls: context switch user writeable TLS register
 TPIDRURW

Since commit 6a1c53124aa1 ("ARM: 7403/1: tls: remove covert channel via
TPIDRURW") we have zeroed the user writeable TLS register to prevent it
from being used as a covert channel between two tasks.

However, it turns out that the wine guys would rather we actually
switched the register so that WinRT applications can use it to store a
pointer to their `thread environment block (TEB)'.

This patch implements TPIDRURW context-switching for cpus implementing
the register. Unlike the TPIDRURO, which is already switched, the TPIDRURW
can be updated from userspace so needs careful treatment in the case that we
modify TPIDRURW and call fork(). If no context switch occurs between these
two events then the thread_info struct that we use to construct the child
will have the old, stale, TPIDRURW value. To avoid this we must always read
TPIDRURW in copy_thread.

This patch is extended from an earlier version by Will Deacon in order to:
- Save TPIDRURW at context switch
- Deal with the race condition described above, including adding C-getters

Reported-by: Andre Hentschel <nerv@dawncrow.de>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jonathan Austin <jonathan.austin@arm.com>
---
 arch/arm/include/asm/thread_info.h |    2 +-
 arch/arm/include/asm/tls.h         |   51 +++++++++++++++++++++++++++++-------
 arch/arm/kernel/Makefile           |    2 +-
 arch/arm/kernel/entry-armv.S       |    5 +++-
 arch/arm/kernel/process.c          |    4 ++-
 arch/arm/kernel/ptrace.c           |    2 +-
 arch/arm/kernel/tls.c              |   50 +++++++++++++++++++++++++++++++++++
 arch/arm/kernel/traps.c            |    4 +--
 8 files changed, 104 insertions(+), 16 deletions(-)
 create mode 100644 arch/arm/kernel/tls.c

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index cddda1f..d90be6d 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -58,7 +58,7 @@ struct thread_info {
 	struct cpu_context_save	cpu_context;	/* cpu context */
 	__u32			syscall;	/* syscall number */
 	__u8			used_cp[16];	/* thread used copro */
-	unsigned long		tp_value;
+	unsigned long		tp_value[2];	/* TLS registers */
 #ifdef CONFIG_CRUNCH
 	struct crunch_state	crunchstate;
 #endif
diff --git a/arch/arm/include/asm/tls.h b/arch/arm/include/asm/tls.h
index 73409e6..e292794 100644
--- a/arch/arm/include/asm/tls.h
+++ b/arch/arm/include/asm/tls.h
@@ -5,10 +5,19 @@
 	.macro set_tls_none, tp, tmp1, tmp2
 	.endm
 
+	.macro save_tlsuser_none, tp, tmp1, tmp2
+	.endm
+
 	.macro set_tls_v6k, tp, tmp1, tmp2
-	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
-	mov	\tmp1, #0
-	mcr	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
+	ldrd	\tmp1, \tmp2, [\tp]
+	mcr	p15, 0, \tmp1, c13, c0, 3	@ set user r/o TLS register
+	mcr	p15, 0, \tmp2, c13, c0, 2	@ set user r/w TLS register
+	.endm
+
+	.macro save_tlsuser_v6k, tp, tmp1, tmp2
+	@ TPIDRURW can be updated from userspace, so we have to re-read it
+	mrc	p15, 0, \tmp2, c13, c0, 2	@ load user r/w TLS register
+	str	\tmp2, [\tp, #4]
 	.endm
 
 	.macro set_tls_v6, tp, tmp1, tmp2
@@ -16,15 +25,26 @@
 	ldr	\tmp1, [\tmp1, #0]
 	mov	\tmp2, #0xffff0fff
 	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
-	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
-	movne	\tmp1, #0
-	mcrne	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
-	streq	\tp, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
+	ldrned	\tmp1, \tmp2, [\tp]
+	ldreq	\tmp1, [\tp]
+	mcrne	p15, 0, \tmp1, c13, c0, 3	@ yes, set user r/o TLS register
+	mcrne	p15, 0, \tmp2, c13, c0, 2	@ set user r/w TLS register
+	streq	\tmp1, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
+	.endm
+
+	.macro save_tlsuser_v6, tp, tmp1, tmp2
+	@ TPIDRURW can be updated from userspace, so we have to re-read it
+	ldr	\tmp1, =elf_hwcap
+	ldr	\tmp1, [\tmp1, #0]
+	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
+	mrcne	p15, 0, \tmp2, c13, c0, 2	@ read user r/w TLS register
+	strne	\tmp2, [\tp, #4]		@ save in to thread_info
 	.endm
 
 	.macro set_tls_software, tp, tmp1, tmp2
-	mov	\tmp1, #0xffff0fff
-	str	\tp, [\tmp1, #-15]		@ set TLS value at 0xffff0ff0
+	ldr	\tmp1, [\tp]
+	mov	\tmp2, #0xffff0fff
+	str	\tmp1, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
 	.endm
 #endif
 
@@ -32,18 +52,31 @@
 #define tls_emu		1
 #define has_tls_reg		1
 #define set_tls		set_tls_none
+#define save_tlsuser	save_tlsuser_none
+#define get_tlsuser	get_tlsuser_none
 #elif defined(CONFIG_CPU_V6)
 #define tls_emu		0
 #define has_tls_reg		(elf_hwcap & HWCAP_TLS)
 #define set_tls		set_tls_v6
+#define save_tlsuser	save_tlsuser_v6
+#define get_tlsuser	get_tlsuser_v6
 #elif defined(CONFIG_CPU_32v6K)
 #define tls_emu		0
 #define has_tls_reg		1
 #define set_tls		set_tls_v6k
+#define save_tlsuser	save_tlsuser_v6k
+#define get_tlsuser	get_tlsuser_v6k
 #else
 #define tls_emu		0
 #define has_tls_reg		0
 #define set_tls		set_tls_software
+#define save_tlsuser	save_tlsuser_none
+#define get_tlsuser	get_tlsuser_none
 #endif
 
+#ifndef __ASSEMBLY__
+extern unsigned long get_tlsuser_none(void);
+extern unsigned long get_tlsuser_v6(void);
+extern unsigned long get_tlsuser_v6k(void);
+#endif
 #endif	/* __ASMARM_TLS_H */
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 5f3338e..4e1114c 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -17,7 +17,7 @@ CFLAGS_REMOVE_return_address.o = -pg
 
 obj-y		:= elf.o entry-armv.o entry-common.o irq.o opcodes.o \
 		   process.o ptrace.o return_address.o sched_clock.o \
-		   setup.o signal.o stacktrace.o sys_arm.o time.o traps.o
+		   setup.o signal.o stacktrace.o sys_arm.o time.o tls.o traps.o
 
 obj-$(CONFIG_ATAGS)		+= atags_parse.o
 obj-$(CONFIG_ATAGS_PROC)	+= atags_proc.o
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 0f82098..66adb0c 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -728,7 +728,7 @@ ENTRY(__switch_to)
  UNWIND(.fnstart	)
  UNWIND(.cantunwind	)
 	add	ip, r1, #TI_CPU_SAVE
-	ldr	r3, [r2, #TI_TP_VALUE]
+	add	r3, r1, #TI_TP_VALUE
  ARM(	stmia	ip!, {r4 - sl, fp, sp, lr} )	@ Store most regs on stack
  THUMB(	stmia	ip!, {r4 - sl, fp}	   )	@ Store most regs on stack
  THUMB(	str	sp, [ip], #4		   )
@@ -736,6 +736,9 @@ ENTRY(__switch_to)
 #ifdef CONFIG_CPU_USE_DOMAINS
 	ldr	r6, [r2, #TI_CPU_DOMAIN]
 #endif
+	/* Save the user-writeable tls register */
+	save_tlsuser	r3, r4, r5
+	add	r3, r2, #TI_TP_VALUE
 	set_tls	r3, r4, r5
 #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
 	ldr	r7, [r2, #TI_TASK]
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 047d3e4..24dbc72 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -39,6 +39,7 @@
 #include <asm/thread_notify.h>
 #include <asm/stacktrace.h>
 #include <asm/mach/time.h>
+#include <asm/tls.h>
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 #include <linux/stackprotector.h>
@@ -395,7 +396,8 @@ copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	clear_ptrace_hw_breakpoint(p);
 
 	if (clone_flags & CLONE_SETTLS)
-		thread->tp_value = childregs->ARM_r3;
+		thread->tp_value[0] = childregs->ARM_r3;
+	thread->tp_value[1] = get_tlsuser();
 
 	thread_notify(THREAD_NOTIFY_COPY, thread);
 
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 03deeff..2bc1514 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -849,7 +849,7 @@ long arch_ptrace(struct task_struct *child, long request,
 #endif
 
 		case PTRACE_GET_THREAD_AREA:
-			ret = put_user(task_thread_info(child)->tp_value,
+			ret = put_user(task_thread_info(child)->tp_value[0],
 				       datap);
 			break;
 
diff --git a/arch/arm/kernel/tls.c b/arch/arm/kernel/tls.c
new file mode 100644
index 0000000..1627f5b
--- /dev/null
+++ b/arch/arm/kernel/tls.c
@@ -0,0 +1,50 @@
+/*
+ * arch/arm/kernel/tls.c
+ *
+ * Copyright (C) 2013 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/kernel.h>
+#include <asm/tls.h>
+
+/*
+ * Access to the TPIDRURW register, with full certainty that it exists.
+ */
+unsigned long get_tlsuser_v6k(void)
+{
+	unsigned long v;
+	asm("mrc        p15, 0, %0, c13, c0, 2\n" : "=r" (v));
+	return v;
+}
+
+/*
+ * Access to the TPIDRURW register if it exists.
+ */
+unsigned long get_tlsuser_v6(void)
+{
+	unsigned long v = 0;
+	if (elf_hwcap & HWCAP_TLS)
+		asm("mrc        p15, 0, %0, c13, c0, 2\n" : "=r" (v));
+	return v;
+}
+
+/*
+ * Dummy access for the case that TLS is emulated in software
+ */
+unsigned long get_tlsuser_none(void)
+{
+	return 0;
+}
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 1c08911..f9d6259 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -588,7 +588,7 @@ asmlinkage int arm_syscall(int no, struct pt_regs *regs)
 		return regs->ARM_r0;
 
 	case NR(set_tls):
-		thread->tp_value = regs->ARM_r0;
+		thread->tp_value[0] = regs->ARM_r0;
 		if (tls_emu)
 			return 0;
 		if (has_tls_reg) {
@@ -706,7 +706,7 @@ static int get_tp_trap(struct pt_regs *regs, unsigned int instr)
 	int reg = (instr >> 12) & 15;
 	if (reg == 15)
 		return 1;
-	regs->uregs[reg] = current_thread_info()->tp_value;
+	regs->uregs[reg] = current_thread_info()->tp_value[0];
 	regs->ARM_pc += 4;
 	return 0;
 }
-- 
1.7.9.5


