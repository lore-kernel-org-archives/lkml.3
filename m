Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485Ab3JOQke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:40:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:37371 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758902Ab3JOQkc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:40:32 -0400
Date: Tue, 15 Oct 2013 12:40:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "Ingo Molnar (mingo@kernel.org)" <mingo@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "Peter Zijlstra (peterz@infradead.org)" <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
Subject: Re: Panic and page fault in loop during handling NMI backtrace
 handler
Message-ID: <20131015124028.2221e85d@gandalf.local.home>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01B60835@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A01B60835@SHSMSX101.ccr.corp.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


BTW, please do not send out HTML email, as that gets blocked from going
to LKML.

On Tue, 15 Oct 2013 02:01:04 +0000
"Liu, Chuansheng" <chuansheng.liu@intel.com> wrote:

> We meet one issue that during trigger all CPU backtrace, but during in the NMI handler arch_trigger_all_cpu_backtrace_handler,
> It hit the PAGE fault, then PAGE fault is in loop, at last the thread stack overflow, and system panic.
> 
> Anyone can give some help? Thanks.
> 
> 
> Panic log as below:
> ===============
> [   15.069144] BUG: unable to handle kernel [   15.073635] paging request at 1649736d
> [   15.076379] IP: [<c200402a>] print_context_stack+0x4a/0xa0
> [   15.082529] *pde = 00000000
> [   15.085758] Thread overran stack, or stack corrupted
> [   15.091303] Oops: 0000 [#1] SMP
> [   15.094932] Modules linked in: atomisp_css2400b0_v2(+) lm3554 ov2722 imx1x5 atmel_mxt_ts vxd392 videobuf_vmalloc videobuf_core bcm_bt_lpm bcm43241 kct_daemon(O)
> [   15.111093] CPU: 2 PID: 2443 Comm: Compiler Tainted: G        W  O 3.10.1+ #1

I'm curious, what "Out-of-tree" module was loaded?

Read the rest from the bottom up, as that's how I wrote it :-)


> [   15.119075] task: f213f980 ti: f0c42000 task.ti: f0c42000
> [   15.125116] EIP: 0060:[<c200402a>] EFLAGS: 00210087 CPU: 2
> [   15.131255] EIP is at print_context_stack+0x4a/0xa0
> [   15.136712] EAX: 16497ffc EBX: 1649736d ECX: 986736d8 EDX: 1649736d
> [   15.143722] ESI: 00000000 EDI: ffffe000 EBP: f0c4220c ESP: f0c421ec
> [   15.150732]  DS: 007b ES: 007b FS: 00d8 GS: 003b SS: 0068
> [   15.156771] CR0: 80050033 CR2: 1649736d CR3: 31245000 CR4: 001007d0
> [   15.163781] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   15.170789] DR6: ffff0ff0 DR7: 00000400
> [   15.175076] Stack:
> [   15.177324]  16497ffc 16496000 986736d8 ffffe000 986736d8 1649736d c282c148 16496000
> [   15.186067]  f0c4223c c20033b0 c282c148 c29ceecf 00000000 f0c4222c 986736d8 f0c4222c
> [   15.194810]  00000000 c29ceecf 00000000 00000000 f0c42260 c20041a7 f0c4229c c282c148
> [   15.203549] Call Trace:
> [   15.206295]  [<c20033b0>] dump_trace+0x70/0xf0
> [   15.211274]  [<c20041a7>] show_trace_log_lvl+0x47/0x60
> [   15.217028]  [<c2003482>] show_stack_log_lvl+0x52/0xd0
> [   15.222782]  [<c2004201>] show_stack+0x21/0x50
> [   15.227762]  [<c281b38b>] dump_stack+0x16/0x18
> [   15.232742]  [<c2037cff>] warn_slowpath_common+0x5f/0x80
> [   15.238693]  [<c282553a>] ? vmalloc_fault+0x5a/0xcf
> [   15.244156]  [<c282553a>] ? vmalloc_fault+0x5a/0xcf
> [   15.249621]  [<c2825b00>] ? __do_page_fault+0x4a0/0x4a0
> [   15.255472]  [<c2037d3d>] warn_slowpath_null+0x1d/0x20
> [   15.261228]  [<c282553a>] vmalloc_fault+0x5a/0xcf
> [   15.266497]  [<c282592f>] __do_page_fault+0x2cf/0x4a0
> [   15.272154]  [<c25e13e0>] ? logger_aio_write+0x230/0x230
> [   15.278106]  [<c2039c94>] ? console_unlock+0x314/0x440
> ... //
> [   16.885364]  [<c2825b00>] ? __do_page_fault+0x4a0/0x4a0
> [   16.891217]  [<c2825b08>] do_page_fault+0x8/0x10
> [   16.896387]  [<c2823066>] error_code+0x5a/0x60
> [   16.901367]  [<c2825b00>] ? __do_page_fault+0x4a0/0x4a0
> [   16.907219]  [<c208d6a0>] ? print_modules+0x20/0x90
> [   16.912685]  [<c2037cfa>] warn_slowpath_common+0x5a/0x80
> [   16.918634]  [<c282553a>] ? vmalloc_fault+0x5a/0xcf
> [   16.924097]  [<c282553a>] ? vmalloc_fault+0x5a/0xcf
> [   16.929562]  [<c2825b00>] ? __do_page_fault+0x4a0/0x4a0
> [   16.935415]  [<c2037d3d>] warn_slowpath_null+0x1d/0x20
> [   16.941169]  [<c282553a>] vmalloc_fault+0x5a/0xcf
> [   16.946437]  [<c282592f>] __do_page_fault+0x2cf/0x4a0
> [   16.952095]  [<c25e13e0>] ? logger_aio_write+0x230/0x230
> [   16.958046]  [<c2039c94>] ? console_unlock+0x314/0x440
> [   16.963800]  [<c2003e62>] ? sys_modify_ldt+0x2/0x160
> [   16.969362]  [<c2825b00>] ? __do_page_fault+0x4a0/0x4a0
> [   16.975215]  [<c2825b08>] do_page_fault+0x8/0x10
> [   16.980386]  [<c2823066>] error_code+0x5a/0x60
> [   16.985366]  [<c2825b00>] ? __do_page_fault+0x4a0/0x4a0
> [   16.991215]  [<c208d6a0>] ? print_modules+0x20/0x90
> [   16.996673]  [<c2037cfa>] warn_slowpath_common+0x5a/0x80
> [   17.002622]  [<c282553a>] ? vmalloc_fault+0x5a/0xcf
> [   17.008086]  [<c282553a>] ? vmalloc_fault+0x5a/0xcf
> [   17.013550]  [<c2825b00>] ? __do_page_fault+0x4a0/0x4a0
> [   17.019403]  [<c2037d3d>] warn_slowpath_null+0x1d/0x20
> [   17.025159]  [<c282553a>] vmalloc_fault+0x5a/0xcf

Oh look, we are constantly warning about this same fault! There's your
infinite loop.

Note the WARN_ON_ONCE() does the WARN_ON() first and then updates
__warned = true. Thus, if the WARN_ON() itself faults, then we are in
an infinite loop.

> [   17.030428]  [<c282592f>] __do_page_fault+0x2cf/0x4a0
> [   17.036085]  [<c25e13e0>] ? logger_aio_write+0x230/0x230
> [   17.042037]  [<c2039c94>] ? console_unlock+0x314/0x440
> [   17.047790]  [<c2003e62>] ? sys_modify_ldt+0x2/0x160
> [   17.053352]  [<c2825b00>] ? __do_page_fault+0x4a0/0x4a0
> [   17.059205]  [<c2825b08>] do_page_fault+0x8/0x10
> [   17.064375]  [<c2823066>] error_code+0x5a/0x60
> [   17.069354]  [<c2825b00>] ? __do_page_fault+0x4a0/0x4a0
> [   17.075204]  [<c208d6a0>] ? print_modules+0x20/0x90
> [   17.080669]  [<c2037cfa>] warn_slowpath_common+0x5a/0x80
> [   17.086619]  [<c282553a>] ? vmalloc_fault+0x5a/0xcf
> [   17.092082]  [<c282553a>] ? vmalloc_fault+0x5a/0xcf
> [   17.097546]  [<c2825b00>] ? __do_page_fault+0x4a0/0x4a0
> [   17.103399]  [<c2037d3d>] warn_slowpath_null+0x1d/0x20
> [   17.109154]  [<c282553a>] vmalloc_fault+0x5a/0xcf

Yep, the WARN_ON() triggered in vmalloc_fault(). We shouldn't worry
about warning in_nmi() for vmalloc faults anymore.


> [   17.114422]  [<c282592f>] __do_page_fault+0x2cf/0x4a0
> [   17.120080]  [<c206b93d>] ? update_group_power+0x1fd/0x240
> [   17.126224]  [<c227827b>] ? number.isra.2+0x32b/0x330
> [   17.131880]  [<c20679bc>] ? update_curr+0xac/0x190
> [   17.137247]  [<c227827b>] ? number.isra.2+0x32b/0x330
> [   17.142905]  [<c2825b00>] ? __do_page_fault+0x4a0/0x4a0
> [   17.148755]  [<c2825b08>] do_page_fault+0x8/0x10
> [   17.153926]  [<c2823066>] error_code+0x5a/0x60
> [   17.158905]  [<c2825b00>] ? __do_page_fault+0x4a0/0x4a0
> [   17.164760]  [<c208d1a9>] ? module_address_lookup+0x29/0xb0
> [   17.170999]  [<c208dddb>] kallsyms_lookup+0x9b/0xb0

Looks like kallsyms_lookup() faulted?

> [   17.176462]  [<c208de1d>] __sprint_symbol+0x2d/0xd0
> [   17.181926]  [<c22790cc>] ? sprintf+0x1c/0x20
> [   17.186804]  [<c208def4>] sprint_symbol+0x14/0x20
> [   17.192063]  [<c208df1e>] __print_symbol+0x1e/0x40
> [   17.197430]  [<c25e00d7>] ? ashmem_shrink+0x77/0xf0
> [   17.202895]  [<c25e13e0>] ? logger_aio_write+0x230/0x230
> [   17.208845]  [<c205bdf5>] ? up+0x25/0x40
> [   17.213242]  [<c2039cb7>] ? console_unlock+0x337/0x440
> [   17.218998]  [<c2818236>] ? printk+0x38/0x3a
> [   17.223782]  [<c20006d0>] __show_regs+0x70/0x190
> [   17.228954]  [<c200353a>] show_regs+0x3a/0x1b0
> [   17.233931]  [<c2818236>] ? printk+0x38/0x3a
> [   17.238717]  [<c2824182>] arch_trigger_all_cpu_backtrace_handler+0x62/0x80
> [   17.246413]  [<c2823919>] nmi_handle.isra.0+0x39/0x60
> [   17.252071]  [<c2823a29>] do_nmi+0xe9/0x3f0

Start here and read upward.

Can you try this patch:

>From 794197cf3f563d36e5ee5b29cbf8e941163f9bc9 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Tue, 15 Oct 2013 12:34:56 -0400
Subject: [PATCH] x86: Remove WARN_ON(in_nmi()) from vmalloc_fault

Since the NMI iretq nesting has been fixed, there's no reason that
an NMI handler can not take a page fault for vmalloc'd code. No locks
are taken in that code path, and the software now handles nested NMIs
when the fault re-enables NMIs on iretq.

Not only that, if the vmalloc_fault() WARN_ON_ONCE() is hit, and that
warn on triggers a vmalloc fault for some reason, then we can go into
an infinite loop (the WARN_ON_ONCE() does the WARN() before updating
the variable to make it happen "once").

Reported-by: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/mm/fault.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 3aaeffc..78926c6 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -268,8 +268,6 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
 	if (!(address >= VMALLOC_START && address < VMALLOC_END))
 		return -1;
 
-	WARN_ON_ONCE(in_nmi());
-
 	/*
 	 * Synchronize this task's top level page-table
 	 * with the 'reference' page table.
-- 
1.8.1.4

