Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab3LLOXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:23:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36039 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3LLOVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:21:16 -0500
Message-Id: <20131212141655.118911949@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 12 Dec 2013 15:08:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/15] x86: Use mul_u64_u32_shr() for native_sched_clock()
References: <20131212140835.729222186@infradead.org>
Content-Disposition: inline; filename=peterz-cycles2ns-math64.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mul_u64_u32_shr() so that x86_64 can use a single 64x64->128 mul.

before:

0000000000000560 <native_sched_clock>:
 560:   44 8b 1d 00 00 00 00    mov    0x0(%rip),%r11d        # 567 <native_sched_clock+0x7>
 567:   55                      push   %rbp
 568:   48 89 e5                mov    %rsp,%rbp
 56b:   45 85 db                test   %r11d,%r11d
 56e:   75 4f                   jne    5bf <native_sched_clock+0x5f>
 570:   0f 31                   rdtsc  
 572:   89 c0                   mov    %eax,%eax
 574:   48 c1 e2 20             shl    $0x20,%rdx
 578:   48 c7 c1 00 00 00 00    mov    $0x0,%rcx
 57f:   48 09 c2                or     %rax,%rdx
 582:   48 c7 c7 00 00 00 00    mov    $0x0,%rdi
 589:   65 8b 04 25 00 00 00    mov    %gs:0x0,%eax
 590:   00 
 591:   48 98                   cltq   
 593:   48 8b 34 c5 00 00 00    mov    0x0(,%rax,8),%rsi
 59a:   00 
 59b:   48 89 d0                mov    %rdx,%rax
 59e:   81 e2 ff 03 00 00       and    $0x3ff,%edx
 5a4:   48 c1 e8 0a             shr    $0xa,%rax
 5a8:   48 0f af 14 0e          imul   (%rsi,%rcx,1),%rdx
 5ad:   48 0f af 04 0e          imul   (%rsi,%rcx,1),%rax
 5b2:   5d                      pop    %rbp
 5b3:   48 03 04 3e             add    (%rsi,%rdi,1),%rax
 5b7:   48 c1 ea 0a             shr    $0xa,%rdx
 5bb:   48 01 d0                add    %rdx,%rax
 5be:   c3                      retq 

after:

0000000000000550 <native_sched_clock>:
 550:   8b 3d 00 00 00 00       mov    0x0(%rip),%edi        # 556 <native_sched_clock+0x6>
 556:   55                      push   %rbp
 557:   48 89 e5                mov    %rsp,%rbp
 55a:   48 83 e4 f0             and    $0xfffffffffffffff0,%rsp
 55e:   85 ff                   test   %edi,%edi
 560:   75 2c                   jne    58e <native_sched_clock+0x3e>
 562:   0f 31                   rdtsc  
 564:   89 c0                   mov    %eax,%eax
 566:   48 c1 e2 20             shl    $0x20,%rdx
 56a:   48 09 c2                or     %rax,%rdx
 56d:   65 48 8b 04 25 00 00    mov    %gs:0x0,%rax
 574:   00 00 
 576:   89 c0                   mov    %eax,%eax
 578:   48 f7 e2                mul    %rdx
 57b:   65 48 8b 0c 25 00 00    mov    %gs:0x0,%rcx
 582:   00 00 
 584:   c9                      leaveq 
 585:   48 0f ac d0 0a          shrd   $0xa,%rdx,%rax
 58a:   48 01 c8                add    %rcx,%rax
 58d:   c3                      retq 

                        MAINLINE   POST

    sched_clock_stable: 1	   1
    (cold) sched_clock: 329841     331312
    (cold) local_clock: 301773     310296
    (warm) sched_clock: 38375      38247
    (warm) local_clock: 100371     102713
    (warm) rdtsc:       27340      27289
    sched_clock_stable: 0          0
    (cold) sched_clock: 382634     372706
    (cold) local_clock: 396890     399275
    (warm) sched_clock: 38194      38124
    (warm) local_clock: 143452     148698
    (warm) rdtsc:       27345      27365

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/timer.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -4,6 +4,7 @@
 #include <linux/pm.h>
 #include <linux/percpu.h>
 #include <linux/interrupt.h>
+#include <linux/math64.h>
 
 #define TICK_SIZE (tick_nsec / 1000)
 
@@ -57,10 +58,8 @@ DECLARE_PER_CPU(unsigned long long, cyc2
 
 static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
 {
-	int cpu = smp_processor_id();
-	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
-	ns += mult_frac(cyc, per_cpu(cyc2ns, cpu),
-			(1UL << CYC2NS_SCALE_FACTOR));
+	unsigned long long ns = this_cpu_read(cyc2ns_offset);
+	ns += mul_u64_u32_shr(cyc, this_cpu_read(cyc2ns), CYC2NS_SCALE_FACTOR);
 	return ns;
 }
 


