Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbaJGMLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:11:08 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:59098 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbaJGMLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:11:04 -0400
Message-ID: <5433D84F.3040003@monom.org>
Date: Tue, 07 Oct 2014 14:10:55 +0200
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
CC: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: Do not try to replenish from a non deadline tasks
References: <1411565056-15577-1-git-send-email-daniel.wagner@bmw-carit.de> <5433B5B9.70006@arm.com> <5433D654.2020108@monom.org>
In-Reply-To: <5433D654.2020108@monom.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 02:02 PM, Daniel Wagner wrote:
>> Anyway, the callpath you talked about on IRC seems to make sense, does
>> what below fix the thing?

For the record that was:

16:30 < wagi> juril: rt_mutex_setprio() resets p->dl.dl_throttled. So the pattern is: start_dl_timer() 
              throttled = 1, rt_mutex_setprio() throlled = 0, sched_switch() -> enqueue_task(), dl_task_timer 
              -> enqueue_task() throttled is 0

> I'll give it a spin.

Not much fun.

 echo 1 > /proc/sys/kernel/ftrace_dump_on_oops 
 trace-cmd  start -e sched -e syscalls:*_futex

with a tracepoint at start_dl_timer, dequeue_dl_entity and enqueue_dl_entity 


[   36.689416] pthread_-1554    0...1 18486104us : sys_futex(uaddr: 6020e0, op: 87, val: 0, utime: 0, uaddr2: 6020e0, val3: 612)
[   36.689416] pthread_-1554    0d..5 18486108us : sched_enqueue_dl_entity: comm=pthread_test pid=1555 pi_comm=pthread_test pi_pid=1555 flags=1
[   36.689416] pthread_-1554    0d..5 18486109us : sched_wakeup: comm=pthread_test pid=1555 prio=-1 success=1 target_cpu=000
[   36.689416] pthread_-1554    0d..4 18486111us : sched_pi_setprio: comm=pthread_test pid=1554 oldprio=-1 newprio=120
[   36.689416] pthread_-1554    0d..4 18486111us : sched_dequeue_dl_entity: comm=pthread_test pid=1554 flags=0
[   36.689416] pthread_-1554    0d..4 18486112us : sched_stat_runtime: comm=pthread_test pid=1554 runtime=851 [ns] vruntime=686604712 [ns]
[   36.689416] pthread_-1554    0dN.3 18486113us : sched_stat_runtime: comm=pthread_test pid=1554 runtime=1714 [ns] vruntime=686606426 [ns]
[   36.689416] pthread_-1554    0d..3 18486114us : sched_switch: prev_comm=pthread_test prev_pid=1554 prev_prio=120 prev_state=R ==> next_comm=pthread_test next_pid=1555 next_prio=-1
[   36.689416] pthread_-1555    0...1 18486117us : sys_futex -> 0x0
[   36.689416] pthread_-1555    0d..3 18486253us : sched_dequeue_dl_entity: comm=pthread_test pid=1555 flags=0
[   36.689416] pthread_-1555    0d..3 18486254us : sched_start_dl_timer: comm=pthread_test pid=1555
[   36.689416] pthread_-1555    0dN.3 18486255us : sched_dequeue_dl_entity: comm=pthread_test pid=1555 flags=0
[   36.689416] pthread_-1555    0dN.3 18486256us : sched_stat_wait: comm=pthread_test pid=1554 delay=139764 [ns]
[   36.689416] pthread_-1555    0d..3 18486256us : sched_switch: prev_comm=pthread_test prev_pid=1555 prev_prio=-1 prev_state=S ==> next_comm=pthread_test next_pid=1554 next_prio=120
[   36.689416] pthread_-1554    0...1 18486257us : sys_futex -> 0x0
[   36.689416] pthread_-1554    0...1 18486258us : sys_futex(uaddr: 6020e0, op: 86, val: 1, utime: 0, uaddr2: 0, val3: 612)
[   36.689416] pthread_-1554    0d..4 18486262us : sched_pi_setprio: comm=pthread_test pid=1555 oldprio=-1 newprio=-1
[   36.689416] pthread_-1554    0d..3 18486264us : sched_stat_runtime: comm=pthread_test pid=1554 runtime=10735 [ns] vruntime=686617161 [ns]
[   36.689416] pthread_-1554    0d..3 18486265us : sched_stat_wait: comm=kworker/u2:0 pid=6 delay=304089 [ns]
[   36.689416] pthread_-1554    0d..3 18486265us : sched_switch: prev_comm=pthread_test prev_pid=1554 prev_prio=120 prev_state=S ==> next_comm=kworker/u2:0 next_pid=6 next_prio=120
[   36.689416] kworker/-6       0d.H5 18486392us : sched_enqueue_dl_entity: comm=pthread_test pid=1555 pi_comm=pthread_test pi_pid=1555 flags=1
[   36.689416] kworker/-6       0dNH5 18486393us : sched_wakeup: comm=pthread_test pid=1555 prio=-1 success=1 target_cpu=000
[   36.689416] kworker/-6       0dN.3 18486401us : sched_stat_runtime: comm=kworker/u2:0 pid=6 runtime=128451 [ns] vruntime=2964293245 [ns]
[   36.689416] kworker/-6       0d..3 18486401us : sched_switch: prev_comm=kworker/u2:0 prev_pid=6 prev_prio=120 prev_state=R ==> next_comm=pthread_test next_pid=1555 next_prio=-1
[   36.689416] pthread_-1555    0...1 18486403us : sys_futex(uaddr: 6020e0, op: 87, val: 0, utime: 0, uaddr2: 6020e0, val3: 613)
[   36.689416] pthread_-1555    0d..5 18486408us : sched_stat_sleep: comm=pthread_test pid=1554 delay=143975 [ns]
[   36.689416] pthread_-1555    0d..5 18486408us : sched_wakeup: comm=pthread_test pid=1554 prio=120 success=1 target_cpu=000
[   36.689416] pthread_-1555    0d..4 18486420us : sched_pi_setprio: comm=pthread_test pid=1555 oldprio=-1 newprio=-1
[   36.689416] pthread_-1555    0d..4 18486421us : sched_dequeue_dl_entity: comm=pthread_test pid=1555 flags=0
[   36.689416] pthread_-1555    0d..4 18486421us : sched_enqueue_dl_entity: comm=pthread_test pid=1555 pi_comm=pthread_test pi_pid=1555 flags=8
[   36.689416] pthread_-1555    0d..4 18486421us : sched_dequeue_dl_entity: comm=pthread_test pid=1555 flags=0
[   36.689416] pthread_-1555    0d..4 18486422us : sched_enqueue_dl_entity: comm=pthread_test pid=1555 pi_comm=pthread_test pi_pid=1555 flags=0
[   36.689416] pthread_-1555    0d.H4 18486539us : sched_enqueue_dl_entity: comm=pthread_test pid=1555 pi_comm=pthread_test pi_pid=1555 flags=8
[   36.689416] ---------------------------------
[   36.689416] Modules linked in:
[   36.689416] CPU: 0 PID: 1555 Comm: pthread_test Not tainted 3.17.0-rc5+ #67
[   36.689416] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   36.689416] task: ffff88007cbc28c0 ti: ffff88007a758000 task.ti: ffff88007a758000
[   36.689416] RIP: 0010:[<ffffffff8106cc20>]  [<ffffffff8106cc20>] enqueue_task_dl+0x2b0/0x330
[   36.689416] RSP: 0018:ffffffff81e2baa8  EFLAGS: 00010082
[   36.689416] RAX: 0000000000000000 RBX: ffff88007cbc28c0 RCX: ffff880078217000
[   36.689416] RDX: 0000000000010104 RSI: 0000000000000046 RDI: ffff88007d041e00
[   36.689416] RBP: ffffffff81e2bad8 R08: 0000000000000000 R09: ffff880078217eb4
[   36.689416] R10: 000000088f9c5ab5 R11: 000000000000000d R12: ffff88007cbc2aa8
[   36.689416] R13: 0000000000000008 R14: ffff88007cbc2aa8 R15: 0000000000000001
[   36.689416] FS:  00007f82e9959700(0000) GS:ffffffff81e28000(0000) knlGS:0000000000000000
[   36.689416] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   36.689416] CR2: 00007ff67cbd2000 CR3: 00000000780a2000 CR4: 00000000000006f0
[   36.689416] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   36.689416] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   36.689416] Stack:
[   36.689416]  ffff88007cbc28c0 ffff88007cbc2b08 ffffffff81e2bb48 ffffffff82010ca8
[   36.689416]  ffffffff82010c20 0000000000000003 ffffffff81e2baf0 ffffffff8106cd17
[   36.689416]  ffff88007cbc2b08 ffffffff81e2bb30 ffffffff81094ecf ffffffff8106cca0
[   36.689416] Call Trace:
[   36.689416]  <IRQ> 
[   36.689416]  [<ffffffff8106cd17>] dl_task_timer+0x77/0xb0
[   36.689416]  [<ffffffff81094ecf>] __run_hrtimer+0x7f/0x200
[   36.689416]  [<ffffffff8106cca0>] ? enqueue_task_dl+0x330/0x330
[   36.689416]  [<ffffffff810952a7>] hrtimer_interrupt+0xd7/0x250
[   36.689416]  [<ffffffff8102b022>] local_apic_timer_interrupt+0x22/0x50
[   36.689416]  [<ffffffff8102b698>] smp_apic_timer_interrupt+0x38/0x50
[   36.689416]  [<ffffffff818bd17d>] apic_timer_interrupt+0x6d/0x80
[   36.689416]  [<ffffffff818bb7d3>] ? _raw_spin_unlock_irqrestore+0x33/0x50
[   36.689416]  [<ffffffff815289cd>] ata_scsi_queuecmd+0x13d/0x420
[   36.689416]  [<ffffffff815259d0>] ? ata_scsi_invalid_field+0x40/0x40
[   36.689416]  [<ffffffff814fd5bf>] scsi_dispatch_cmd+0x9f/0x190
[   36.689416]  [<ffffffff81505ce5>] scsi_request_fn+0x415/0x650
[   36.689416]  [<ffffffff81333c0e>] __blk_run_queue+0x2e/0x40
[   36.689416]  [<ffffffff81333c41>] blk_run_queue+0x21/0x40
[   36.689416]  [<ffffffff81503580>] scsi_run_queue+0x260/0x300
[   36.689416]  [<ffffffff814fd1d3>] ? scsi_put_command+0x73/0xc0
[   36.689416]  [<ffffffff81505f5b>] scsi_next_command+0x1b/0x30
[   36.689416]  [<ffffffff815060c5>] scsi_end_request+0x155/0x1d0
[   36.689416]  [<ffffffff8150628c>] scsi_io_completion+0xec/0x5e0
[   36.689416]  [<ffffffff814fd769>] scsi_finish_command+0xb9/0xf0
[   36.689416]  [<ffffffff815058aa>] scsi_softirq_done+0x10a/0x130
[   36.689416]  [<ffffffff8133cabb>] blk_done_softirq+0x7b/0x90
[   36.689416]  [<ffffffff81045bd4>] __do_softirq+0x114/0x2e0
[   36.689416]  [<ffffffff81046035>] irq_exit+0xa5/0xb0
[   36.689416]  [<ffffffff81003f90>] do_IRQ+0x50/0xe0
[   36.689416]  [<ffffffff818bcead>] common_interrupt+0x6d/0x6d
[   36.689416]  <EOI> 
[   36.689416]  [<ffffffff818b6701>] ? __schedule+0x2e1/0x6d0
[   36.689416]  [<ffffffff8136167e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   36.689416]  [<ffffffff818b6b13>] schedule+0x23/0x60
[   36.689416]  [<ffffffff818bc5f3>] int_careful+0x12/0x1e
[   36.689416] Code: 38 02 00 00 00 00 00 00 48 89 83 20 02 00 00 eb 9b be 1a 01 00 00 48 c7 c7 1b f0 cb 81 e8 49 5c fd ff 48 8b 93 e8 01 00 00 eb bd <0f> 0b 0f 0b 48 c7 c7 f8 44 cb 81 31 c0 c6 05 31 1a 09 01 01 e8 
[   36.689416] RIP  [<ffffffff8106cc20>] enqueue_task_dl+0x2b0/0x330
[   36.689416]  RSP <ffffffff81e2baa8>
[   36.689416] ---[ end trace 823be5ba7376cc37 ]---
[   36.689416] Kernel panic - not syncing: Fatal exception in interrupt
[   36.689416] Dumping ftrace buffer:
[   36.689416]    (ftrace buffer empty)
[   36.689416] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[   36.689416] ---[ end Kernel panic - not syncing: Fatal exception in interrupt
