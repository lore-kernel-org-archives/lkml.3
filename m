Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbaFFB4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 21:56:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:25891 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbaFFB4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 21:56:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,985,1392192000"; 
   d="scan'208";a="550544877"
Date: Fri, 6 Jun 2014 09:55:24 +0800
From: Liu ShuoX <shuox.liu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Zhang Yanmin <yanmin.zhang@intel.com>, yanmin_zhang@linux.intel.com
Subject: [PATCH v3] perf: fix kernel panic when parsing user space CS saved
 in pt_regs
Message-ID: <20140606015524.GA19246@lskakaxi-intel>
References: <20140605023610.GA12905@lskakaxi-intel>
 <20140605071919.GD3213@twins.programming.kicks-ass.net>
 <20140605073321.GA14869@lskakaxi-intel>
 <20140605074008.GB14869@lskakaxi-intel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140605074008.GB14869@lskakaxi-intel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanmin <yanmin.zhang@intel.com>

ChangeLog V3: 	Keep rsp pointing to pt_regs before sysexit.

ChangeLog V2: 	Before sysexit, perf NMI might arrive. There is
		still a race. Here we change rsp to keep it pointing
		to pt_regs->orig_ax.
		In addition, after sti, before sysexit, an irq might
		arrives. That causes more chances for perf NMI to jump
		in.

We hit a kernel panic when running perf to collect some performance data.
kenel is x86_64 and user space apps are 32bit.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
IP: [<ffffffff82012091>] get_segment_base+0x71/0xc0
PGD 6c65f067 PUD 0
Oops: 0000 [#1] PREEMPT SMP
Modules linked in:  <...>
CPU: 1 PID: 304 Comm: Binder_2 Tainted: G        W  O 3.10.20-263902-g184bfbc-dirty #14
task: ffff8800764dc300 ti: ffff88006c6e8000 task.ti: ffff88006c6e8000
RIP: 0010:[<ffffffff82012091>]  [<ffffffæf82012091>] get_segment_base+0x71/0xc0
RSP: 0018:ffff^X8007ea87b98  EFLAGS: 00010092
RAX: 0000000000000024 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000009
RBP: ffff88007ea87ba8 R08: ffffffff83143b3c R09: ffffffff831848a8
R10: 0000000000000000 R11: 00000000001bf2d8 R12: 0000000000000000
R13: ffff88006c6e9fd8 R14: ffff88006c6e9f58 R15: ffff8800764dc300
FS:  0000000000000000(0000) GS:ffff88007ea80000(006b) knlGS:00000000f704add0
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000000000004 CR3: 0000000076588000 CR4: 00000^P00001007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Stack:
  ffff88005f266c00 0000000000000000 ffff88007ea87c18 ffffffff82013cac
  ffff88007ea87d58 00000016fe4704a0 00000000000001a7 ffff88007ea87ef8
  ffff88005f266c00 ffff88007ea87ef8 ffff8800!e07b400 ffff88005f266c00
Call Trace:
  <NMI>
  [<ffffffff82013cac>] perf_callchain_user+0x15c/0x240
  [<ffffffff82160754>] perf_callchain+0x134/0x180
  [<fffff&ff820e0787>] ? local_clock+0x47/0x60
  [<ffffffff8215d49b>] perf_prepare_sample+0x1bb/0x240
  [<ffffffff8215d667>] __perf_event_overflow+0x147/0x230
  [<ffffffff82012f68>] ? x86_perf_event_set_period+0xd8/0x150
  [<ffffffff8215df24>] perf_event_overflow+0x14/0x20
  [<ffffffff820194d2>] intel_pmu_handle_irq+0x1c2/0x270
  [<ffffffff828b5d60>] ? call_softirq+0x30/0x30
  [<ffffffff828aff01>] perf_event_nmi_handler+0x21/0x30
  [<ffffffff828af5b9>] nmi_handle.isr!.1+0x59/0x=0
  [<ffffffff828af6d8>] default_do_nmi+0x58/0x240
  [<ffffffff828af978>] do_nmi+0xb8/0xf0
  [|ffffffgf828aebe7>] end_repeat_nmi+0x1e/0x2e
  [<ffffffff828b5d60>] ? call_softirq+0x30/0x30
  [<ffffffff828b5d60>] ? call_softirq+0x30/0x30
  [<fFffffff828b5d60>] ? call_softirq+0x30/0x30

Basically, ia32 uses sysenter to start system calls.

sysexit_from_sys_call=>trace_hardirqs_on_thunk. Before calling,
sysexit_from_sys_call already pops up pt_regs, then trace_hardirqs_on_thunk
would reuse pt_regs space. If perf NMI happens here, perf might use a bad pt_regs.

The patch fixes it by keeping rsp pointing to pt_regs.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
Signed-off-by: Liu Shuox <shuox.liu@intel.com>
---
  arch/x86/ia32/ia32entry.S | 11 ++++++-----
  1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 4299eb0..d2f905b 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -172,15 +172,16 @@ sysexit_from_sys_call:
  	andl  $~0x200,EFLAGS-R11(%rsp) 
  	movl	RIP-R11(%rsp),%edx		/* User %eip */
  	CFI_REGISTER rip,rdx
-	RESTORE_ARGS 0,24,0,0,0,0
-	xorq	%r8,%r8
+	RESTORE_ARGS 0,-ARG_SKIP,0,0,0,0
+	movq	EFLAGS-R11(%rsp),%r8		/* rflags */
+	movq	RSP-R11(%rsp),%rcx		/* User %esp */
  	xorq	%r9,%r9
  	xorq	%r10,%r10
  	xorq	%r11,%r11
-	popfq_cfi
+	pushq_cfi %r8
  	/*CFI_RESTORE rflags*/
-	popq_cfi %rcx				/* User %esp */
-	CFI_REGISTER rsp,rcx
+	popfq_cfi
+	xorq	%r8,%r8
  	TRACE_IRQS_ON
  	ENABLE_INTERRUPTS_SYSEXIT32
  
-- 
1.8.3.2

