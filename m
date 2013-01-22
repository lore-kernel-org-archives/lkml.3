Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab3AVEDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 23:03:46 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:25327 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3AVEDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 23:03:44 -0500
Message-ID: <50FE0F72.6070501@huawei.com>
Date: Tue, 22 Jan 2013 12:02:58 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: perf: cgroup: INFO: suspicious RCU usage
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got this warning as soon as I ran "perf stat -a -e faults -G cgrp1 -- sleep 1"

This is a long-standing bug. At least I can trigger the same warning in 3.4 kernel.
There were several bug reports before, but no one seems to care?

===============================
[ INFO: suspicious RCU usage. ]
3.8.0-rc2-default+ #17 Not tainted
-------------------------------
include/linux/cgroup.h:534 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 1
1 lock held by swapper/0/0:
 #0:  (&cpuctx_lock){-.....}, at: [<ffffffff81115325>] perf_ctx_lock+0x15/0x30

stack backtrace:
Pid: 0, comm: swapper/0 Not tainted 3.8.0-rc2-tj-0.7-default+ #17
Call Trace:
 <IRQ>  [<ffffffff810aa863>] lockdep_rcu_suspicious+0xe3/0x130
 [<ffffffff8111ea96>] __perf_install_in_context+0x1a6/0x210
 [<ffffffff811148d9>] remote_function+0x49/0x60
 [<ffffffff810b4877>] ? generic_smp_call_function_single_interrupt+0x57/0x120
 [<ffffffff810b48e6>] generic_smp_call_function_single_interrupt+0xc6/0x120
 [<ffffffff813953b0>] ? disable_cpuidle+0x20/0x20
 [<ffffffff81026bf7>] smp_call_function_single_interrupt+0x27/0x40
 [<ffffffff8149ebb2>] call_function_single_interrupt+0x72/0x80
 <EOI>  [<ffffffff81395a53>] ? cpuidle_wrap_enter+0x53/0xa0
 [<ffffffff81395a4f>] ? cpuidle_wrap_enter+0x4f/0xa0
 [<ffffffff81395ab0>] cpuidle_enter_tk+0x10/0x20
 [<ffffffff813953e7>] cpuidle_enter_state+0x17/0x50
 [<ffffffff81395d9a>] cpuidle_idle_call+0x13a/0x1c0
 [<ffffffff8100b0df>] cpu_idle+0x9f/0xf0
 [<ffffffff8147be7f>] rest_init+0xdf/0x160
 [<ffffffff8147bda0>] ? csum_partial_copy_generic+0x170/0x170
 [<ffffffff81addb3a>] start_kernel+0x372/0x442
 [<ffffffff81add5c1>] ? repair_env_string+0x58/0x58
 [<ffffffff8148ee7e>] ? memblock_reserve+0x2e/0x4e
 [<ffffffff81add2b5>] x86_64_start_reservations+0xa5/0xc2
 [<ffffffff81add3e1>] x86_64_start_kernel+0x10f/0x12a
 [<ffffffff81add120>] ? early_idt_handlers+0x120/0x120

