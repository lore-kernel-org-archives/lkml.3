Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab3LLE0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 23:26:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58117 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3LLE0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 23:26:06 -0500
Message-ID: <1386822357.6056.12.camel@marge.simpson.net>
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
From: Mike Galbraith <bitbucket@online.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Date: Thu, 12 Dec 2013 05:25:57 +0100
In-Reply-To: <52A908DB.60902@zytor.com>
References: <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de>
	 <20131211113839.GF21683@pd.tnic>
	 <20131211115239.GA21999@twins.programming.kicks-ass.net>
	 <1386764955.12005.60.camel@marge.simpson.net>
	 <20131211124352.GB21999@twins.programming.kicks-ass.net>
	 <20131211134048.GH21683@pd.tnic> <20131211145655.GB4510@gmail.com>
	 <20131211164318.GA2480@laptop.programming.kicks-ass.net>
	 <20131211175036.GC12431@gmail.com> <52A8F073.9040500@zytor.com>
	 <20131211231425.GD8863@pd.tnic> <52A908DB.60902@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:UynxcBm0FhayPYcqtFxyuwIjW5mFYk4pOg8s3POAQDm
 br7Fg307FcD0aOfL0d6GMNHFygXd45FnvvM+RzpbRsmdfGMOrR
 9pud5RIPiCpa3depwtrm2902K8lKsrcaFa/mSiomkF4m+SiNqv
 jo8f33c15GClN9aqsMpBmASuCEdrbcq95JHKZaGpcIlVGyVRwJ
 aDqcIUk/PUU0v0gKCjibnfGiwGRwrixKCB32FMaXAR0SkZQivP
 7gNar7O3cFiCqYUPXOFy9NnUDhr5KKx4Gsvmd8el3xjdMTG1Sz
 VBJWLE6/oBbSWrO4Q4dQHWw0M2EWntIwQLbSxrclii8BfMHgCn
 XC/2wBHnN7bR+UEEZi8bmugTWXNbYyosCNvSLeWlFiMfLaKYq5
 Uv5pdsBfdnSQw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-11 at 16:52 -0800, H. Peter Anvin wrote: 
> On 12/11/2013 03:14 PM, Borislav Petkov wrote:
> > On Wed, Dec 11, 2013 at 03:08:35PM -0800, H. Peter Anvin wrote:
> >> So I would like to propose that we switch to using a percpu variable
> >> which is a single cache line of nothing at all. It would only ever
> >> be touched by MONITOR and for explicit wakeup. Hopefully that will
> >> resolve this problem without the need for the CLFLUSH.
> > 
> > Yep, makes a lot of sense to me to have an exclusive (overloaded meaning
> > here :-)) cacheline only for that. And, if it works, we'll save us the
> > penalty from the CLFLUSH too, cool.
> > 
> 
> Here is a POC patch... anyone willing to test it out?

Got it built, but it went boom on boot.  Off to rummage. 

[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:64 nr_node_ids:8
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88027ee00000 s75904 r8192 d22400 u131072
[    0.000000] pcpu-alloc: s75904 r8192 d22400 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] pcpu-alloc: [0] 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
[    0.000000] pcpu-alloc: [0] 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 
[    0.000000] pcpu-alloc: [0] 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 
[    0.000000] BUG: unable to handle kernel paging request at 000000000000b8a0
[    0.000000] IP: [<ffffffff81a9d072>] setup_mwait_doorbell+0x20/0x38
[    0.000000] PGD 0 
[    0.000000] Oops: 0002 [#1] SMP 
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.13.0-master #185
[    0.000000] Hardware name: Hewlett-Packard ProLiant DL980 G7, BIOS P66 07/07/2010
[    0.000000] task: ffffffff81a10460 ti: ffffffff81a00000 task.ti: ffffffff81a00000
[    0.000000] RIP: 0010:[<ffffffff81a9d072>]  [<ffffffff81a9d072>] setup_mwait_doorbell+0x20/0x38
[    0.000000] RSP: 0000:ffffffff81a01f28  EFLAGS: 00010002
[    0.000000] RAX: 0000000000014880 RBX: 0000000000000040 RCX: 0000000000000000
[    0.000000] RDX: 0000000000000040 RSI: 0000000000000040 RDI: ffffffff81a38e60
[    0.000000] RBP: ffffffff81a01f28 R08: 0000000000000040 R09: 0000000000000000
[    0.000000] R10: ffff88027f5f4880 R11: 0000000000000001 R12: 000000000000b850
[    0.000000] R13: 000000000000b026 R14: 000000000000b024 R15: 000000000000b020
[    0.000000] FS:  0000000000000000(0000) GS:ffff88027ee00000(0000) knlGS:0000000000000000
[    0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.000000] CR2: 000000000000b8a0 CR3: 0000000001a0b000 CR4: 00000000000000b0
[    0.000000] Stack:
[    0.000000]  ffffffff81a01f78 ffffffff81aa3641 ffffffff81a01f98 000000000000cd48
[    0.000000]  ffff88027ee00000 0000000000000000 0000000000000000 0000000000000000
[    0.000000]  0000000000000000 0000000000000000 ffffffff81a01fa8 ffffffff81a96d89
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81aa3641>] setup_per_cpu_areas+0x233/0x242
[    0.000000]  [<ffffffff81a96d89>] start_kernel+0x84/0x370
[    0.000000]  [<ffffffff81a964cc>] x86_64_start_reservations+0x1b/0x35
[    0.000000]  [<ffffffff81a96614>] x86_64_start_kernel+0x12e/0x135
[    0.000000] Code: 40 8f a7 81 e8 f6 fe ff ff c9 c3 55 48 8b 05 0a bf fd ff 48 89 e5 a8 08 75 02 c9 c3 0f b7 3d 84 bf fd ff 48 89 fe e8 fe dc 64 ff <48> 89 05 27 e8 56 7e 48 85 c0 75 e3 48 c7 c7 f0 83 78 81 e8 55 
[    0.000000] RIP  [<ffffffff81a9d072>] setup_mwait_doorbell+0x20/0x38
[    0.000000]  RSP <ffffffff81a01f28>
[    0.000000] CR2: 000000000000b8a0
[    0.000000] ---[ end trace f6e32c58e0729292 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!

Build delta.

---
 arch/x86/include/asm/mwait.h   |    4 ++--
 arch/x86/kernel/cpu/common.c   |    7 ++++---
 arch/x86/kernel/setup_percpu.c |    1 +
 3 files changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -65,13 +65,14 @@ void __init setup_cpu_local_masks(void)
 }
 
 /* allocate percpu area for mwait doorbell */
-char __percpu *mwait_doorbell;
+DEFINE_PER_CPU(char *, mwait_doorbell);
+EXPORT_PER_CPU_SYMBOL(mwait_doorbell);
 
 void __init setup_mwait_doorbell(void)
 {
 	if (boot_cpu_has(X86_FEATURE_MWAIT)) {
-		mwait_doorbell = __alloc_percpu(boot_cpu_data.clflush_size,
-						boot_cpu_data.clflush_size);
+		mwait_doorbell = __alloc_percpu(boot_cpu_data.x86_clflush_size,
+						boot_cpu_data.x86_clflush_size);
 
 		if (!mwait_doorbell) {
 			/* This should never happen... */
Index: linux-2.6/arch/x86/kernel/setup_percpu.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6/arch/x86/kernel/setup_percpu.c
@@ -20,6 +20,7 @@
 #include <asm/cpumask.h>
 #include <asm/cpu.h>
 #include <asm/stackprotector.h>
+#include <asm/mwait.h>
 
 DEFINE_PER_CPU_READ_MOSTLY(int, cpu_number);
 EXPORT_PER_CPU_SYMBOL(cpu_number);
Index: linux-2.6/arch/x86/include/asm/mwait.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mwait.h
+++ linux-2.6/arch/x86/include/asm/mwait.h
@@ -42,9 +42,9 @@ static inline void __sti_mwait(unsigned
 		     :: "a" (eax), "c" (ecx));
 }
 
-extern char __percpu *mwait_doorbell;
+DECLARE_PER_CPU(char *, mwait_doorbell);
 
-void __init setup_mwait_doorbell(void);
+extern void __init setup_mwait_doorbell(void);
 
 static inline void x86_monitor_doorbell(unsigned long ecx, unsigned long edx)
 {



