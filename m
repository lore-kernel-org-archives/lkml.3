Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaDNMEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 08:04:37 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:42521 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbaDNMEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:04:31 -0400
Message-ID: <534BCE80.3090406@huawei.com>
Date: Mon, 14 Apr 2014 20:03:12 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, <Sukie.Peng@arm.com>,
        Xinwei Hu <huxinwei@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm64: Flush the process's mm context TLB entries when switching
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I met a problem when migrating process by following steps:

1) The process was already running on core 0.
2) Set the CPU affinity of the process to 0x02 and move it to core 1,
   it could work well.
3) Set the CPU affinity of the process to 0x01 and move it to core 0 again,
   the problem occurs and the process was killed.

---------------------------------------------------------------------

Aborting.../init: line 29:   434 Aborted                 setsid cttyhack sh
Console sh exited with 134, respawning...
fork_test[440]: unhandled level 2 translation fault (11) at 0x00000000, esr 0x83
000006
pgd = ffffffc01a505000
[00000000] *pgd=000000001a3f4003, *pmd=0000000000000000

CPU: 0 PID: 440 Comm: fork_test Not tainted 3.13.0+ #7
task: ffffffc01a41c800 ti: ffffffc01a55c000 task.ti: ffffffc01a55c000
PC is at 0x0
LR is at 0x0
pc : [<0000000000000000>] lr : [<0000000000000000>] pstate: 20000000
sp : 0000007fdeb1dc50
x29: 0000000000000000 x28: 0000000000000000
x27: 0000000000000000 x26: 0000000000000000
x25: 0000000000000000 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000000
x21: 0000000000400570 x20: 0000000000000000
x19: 0000000000400570 x18: 0000007fdeb1d9e0
x17: 0000007fa7a65840 x16: 0000000000410a50
x15: 0000007fa7b3b028 x14: 0000000000000040
x13: 0000000000000090 x12: 000000000013c000
x11: 000000000002b028 x10: 0000000000000000
x9 : 00000000ffffffff x8 : 0000000000000104
x7 : 0000000000000000 x6 : 0000000000000000
x5 : 00000000fbad2a84 x4 : 0000000000000000
x3 : 0000000000000000 x2 : 0000000000000020
x1 : 0000007fa7b356f0 x0 : ffffffffffffffff

CPU: 0 PID: 440 Comm: fork_test Not tainted 3.13.0+ #7
Call trace:
[<ffffffc0000872b0>] dump_backtrace+0x0/0x12c
[<ffffffc0000873f0>] show_stack+0x14/0x1c
[<ffffffc000420e74>] dump_stack+0x70/0x90
[<ffffffc0000912d0>] __do_user_fault+0x48/0xf4
[<ffffffc0000914e4>] do_page_fault+0x168/0x378
[<ffffffc0000917b4>] do_translation_fault+0xc0/0xf0
[<ffffffc000081108>] do_mem_abort+0x3c/0x9c
Exception stack(0xffffffc01a55fe30 to 0xffffffc01a55ff50)
fe20:                                     00400570 00000000 00000000 00000000
fe40: ffffffff ffffffff 00000000 00000000 ffffffff ffffffff 000000dc 00000000
fe60: 00000003 00000004 00000000 00000000 00000000 00000000 000001bb 00000000
fe80: 00000000 00000000 00000000 0000007f 1a41c800 ffffffc0 00095508 ffffffc0
fea0: 00100100 00000000 00200200 00000000 fffffff6 00000000 00001000 00000000
fec0: deb1dc00 0000007f 000839ec ffffffc0 ffffffff ffffffff a7b356f0 0000007f
fee0: 00000020 00000000 00000000 00000000 00000000 00000000 fbad2a84 00000000
ff00: 00000000 00000000 00000000 00000000 00000104 00000000 ffffffff 00000000
ff20: 00000000 00000000 0002b028 00000000 0013c000 00000000 00000090 00000000
ff40: 00000040 00000000 a7b3b028 0000007f

---------------------------- cut here -----------------------------------

It was a very strange problem that the PC and LR are both 0, and the esr is
0x83000006, it means that the used for instruction access generated MMU faults
and synchronous external aborts, including synchronous parity errors.

I try to fix the problem by invalidating the process's TLB entries when switching,
it will make the context stale and pick new one, and then it could work well.

So I think in some situation that after the process switching, the modification of
the TLB entries in the new core didn't inform all other cores to invalidate the old
TLB entries which was in the inner shareable caches, and then if the process schedule
to another core, the old TLB entries may occur MMU faults.

Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 arch/arm64/kernel/process.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 6391485..d7d8439 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -283,6 +283,13 @@ static void tls_thread_switch(struct task_struct *next)
 	: : "r" (tpidr), "r" (tpidrro));
 }
 
+static void tlb_flush_thread(struct task_struct *prev)
+{
+	/* Flush the prev task's TLB entries */
+	if (prev->mm)
+		flush_tlb_mm(prev->mm);
+}
+
 /*
  * Thread switching.
  */
@@ -296,6 +303,8 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	hw_breakpoint_thread_switch(next);
 	contextidr_thread_switch(next);
 
+	tlb_flush_thread(prev);
+
 	/*
 	 * Complete any pending TLB or cache maintenance on this CPU in case
 	 * the thread migrates to a different CPU.
-- 
1.8.0

