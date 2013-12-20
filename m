Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3LTHth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:49:37 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:54898 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab3LTHtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:49:35 -0500
Message-ID: <52B3F66D.6060707@huawei.com>
Date: Fri, 20 Dec 2013 15:49:01 +0800
From: Weng Meiling <wengmeiling.weng@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>, <oprofile-list@lists.sf.net>,
        <linux-kernel@vger.kernel.org>
CC: Li Zefan <lizefan@huawei.com>, <wangnan0@huawei.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>
Subject: [PATCH] oprofile: check whether oprofile perf enabled in op_overflow_handler()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.127]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Weng Meiling <wengmeiling.weng@huawei.com>

There is a situation event is triggered before oprofile_perf_start() finish.
Because the event is still not stored in per_cpu(perf_events, cpu)[event],
op_overflow_handler() will print the warning. During the time, if unregistered
event is triggered again, the cpu will print again. This may make cpu keeping
on printing and trigger softlockup. So check whether events register finished
in op_overflow_handler().

The problem was once triggered on kernel 2.6.34, the main information:
<3>BUG: soft lockup - CPU#0 stuck for 60005ms! [opcontrol:8673]

Pid: 8673, comm:            opcontrol
=====================SOFTLOCKUP INFO BEGIN=======================
[CPU#0] the task [opcontrol] is not waiting for a lock,maybe a delay or deadcricle!
<6>opcontrol     R<c> running  <c>    0  8673   7603 0x00000002
locked:
bf0e1928   mutex            0  [<bf0de0d8>] oprofile_start+0x10/0x68 [oprofile]
bf0e1a24   mutex            0  [<bf0e07f0>] op_arm_start+0x10/0x48 [oprofile]
c0628020   &ctx->mutex      0  [<c00af85c>] perf_event_create_kernel_counter+0xa4/0x14c
[<c00362b8>] (unwind_backtrace+0x0/0x164) from [<c0031db4>] (show_stack+0x10/0x14)
[<c0031db4>] (show_stack+0x10/0x14) from [<c008d964>] (show_lock_info+0x9c/0x168)
[<c008d964>] (show_lock_info+0x9c/0x168) from [<c008dbf4>] (softlockup_tick+0x1c4/0x234)
[<c008dbf4>] (softlockup_tick+0x1c4/0x234) from [<c0066d58>] (update_process_times+0x2c/0x50)
[<c0066d58>] (update_process_times+0x2c/0x50) from [<c00811cc>] (tick_sched_timer+0x268/0x2c4)
[<c00811cc>] (tick_sched_timer+0x268/0x2c4) from [<c0077340>] (__run_hrtimer+0x158/0x25c)
[<c0077340>] (__run_hrtimer+0x158/0x25c) from [<c0077e08>] (hrtimer_interrupt+0x13c/0x2f8)
[<c0077e08>] (hrtimer_interrupt+0x13c/0x2f8) from [<c003f82c>] (timer64_timer_interrupt+0x20/0x2c)
[<c003f82c>] (timer64_timer_interrupt+0x20/0x2c) from [<c008e54c>] (handle_IRQ_event+0x144/0x2ec)
[<c008e54c>] (handle_IRQ_event+0x144/0x2ec) from [<c00900dc>] (handle_level_irq+0xc0/0x13c)
[<c00900dc>] (handle_level_irq+0xc0/0x13c) from [<c002b080>] (asm_do_IRQ+0x80/0xbc)
[<c002b080>] (asm_do_IRQ+0x80/0xbc) from [<c0274b8c>] (__irq_svc+0x4c/0xe4)
Exception stack(0xc4099db8 to 0xc4099e00)
9da0:                                                       c0357538 00000000
9dc0: 00000000 c0380cc0 c4098000 00000202 00000028 c4098000 3fca9fbc c4098000
9de0: c0028b08 00000000 c4098000 c4099e00 c005eb50 c005e544 20000113 ffffffff
[<c0274b8c>] (__irq_svc+0x4c/0xe4) from [<c005e544>] (__do_softirq+0x64/0x25c)
[<c005e544>] (__do_softirq+0x64/0x25c) from [<c005eb50>] (irq_exit+0x48/0x5c)
[<c005eb50>] (irq_exit+0x48/0x5c) from [<c002b084>] (asm_do_IRQ+0x84/0xbc)
[<c002b084>] (asm_do_IRQ+0x84/0xbc) from [<c0274b8c>] (__irq_svc+0x4c/0xe4)
Exception stack(0xc4099e58 to 0xc4099ea0)
9e40:                                                       c0628010 20000093
9e60: 00000001 00000000 00000000 60000013 c00aff24 cc4f6c00 00000001 c4098000
9e80: 00000000 00000000 00000000 c4099ea0 c0084fa0 c0084fa4 60000013 ffffffff
[<c0274b8c>] (__irq_svc+0x4c/0xe4) from [<c0084fa4>] (smp_call_function_single+0xc0/0x1d8)
[<c0084fa4>] (smp_call_function_single+0xc0/0x1d8) from [<c00af86c>] (perf_event_create_kernel_counter+0xb4/0x14c)
[<c00af86c>] (perf_event_create_kernel_counter+0xb4/0x14c) from [<bf0e0700>] (op_perf_start+0x54/0xf0 [oprofile])
[<bf0e0700>] (op_perf_start+0x54/0xf0 [oprofile]) from [<bf0e0800>] (op_arm_start+0x20/0x48 [oprofile])
[<bf0e0800>] (op_arm_start+0x20/0x48 [oprofile]) from [<bf0de100>] (oprofile_start+0x38/0x68 [oprofile])
[<bf0de100>] (oprofile_start+0x38/0x68 [oprofile]) from [<bf0dfac0>] (enable_write+0x34/0x54 [oprofile])
[<bf0dfac0>] (enable_write+0x34/0x54 [oprofile]) from [<c00e5368>] (vfs_write+0xa8/0x150)
[<c00e5368>] (vfs_write+0xa8/0x150) from [<c00e5698>] (sys_write+0x3c/0x100)
[<c00e5698>] (sys_write+0x3c/0x100) from [<c002c500>] (ret_fast_syscall+0x0/0x30)
=====================SOFTLOCKUP INFO END=========================
<0>Kernel panic - not syncing: softlockup: hung tasks

Cc: <stable@vger.kernel.org> # 2.6.34+
Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
---
 drivers/oprofile/oprofile_perf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
index d5b2732..a9e5761 100644
--- a/drivers/oprofile/oprofile_perf.c
+++ b/drivers/oprofile/oprofile_perf.c
@@ -38,6 +38,9 @@ static void op_overflow_handler(struct perf_event *event,
 	int id;
 	u32 cpu = smp_processor_id();

+	if (!oprofile_perf_enabled)
+		return;
+
 	for (id = 0; id < num_counters; ++id)
 		if (per_cpu(perf_events, cpu)[id] == event)
 			break;
-- 
1.8.3


