Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab3EXQI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 12:08:26 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:60045 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab3EXQID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 12:08:03 -0400
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Li Zefan <lizefan@huawei.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: [PATCH 0/1] sched/autogroup: Fix race with task_groups list
Date: Fri, 24 May 2013 18:07:48 +0200
Message-Id: <1369411669-46971-1-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: git-send-email 1.8.1.6
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052416-1948-0000-0000-0000053F1FF1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the output of a panic that was triggered during CPU unplug.
__enable_runtime() accessed a freed and poisoned rt_rq that it got from
for_each_rt_rq() from the task_groups list. It seems to me that there
is a race with autogroup_create(), where tg->rt_rq is freed after the
tg was already added to the task_groups list.

A possible patch is attached, which moves the tg list add behind the
tg modifiaction in autogroup_create(), but I am currently not able to
reproduce the bug to test the patch. Feedback is welcome, as I am not
really familiar with scheduling or autogroup code.

[   47.256201] Unable to handle kernel pointer dereference at virtual kernel address 6b6b6b6b6b6b6000
[   47.256236] Oops: 0038 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   47.256243] Modules linked in: dm_multipath scsi_dh eadm_sch dm_mod ctcm fsm ipv6 autofs4
[   47.256253] CPU: 0 Not tainted 3.9.2-60.x.20130514-s390xdefault #1
[   47.256255] Process cpuplugd (pid: 6542, task: 00000032710b4ae0, ksp: 0000003270dc77a8)
[   47.256258] Krnl PSW : 0404c00180000000 00000000001b71dc (__lock_acquire+0x14e8/0x16a4)
[   47.256265]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 EA:3
               Krnl GPRS: 0000000000000001 0000000000000001 6b6b6b6b00000000 0000000000000000
[   47.256270]            0000000000000000 0000000000000000 0000000000000002 0000000000a54018
[   47.256272]            00000032710b4ae0 0000000000000000 0000000000000000 6b6b6b6b6b6b6c33
[   47.256275]            0000000000cb2708 00000000006e12a0 0000003270dc7798 0000003270dc76f0
[   47.256285] Krnl Code: 00000000001b71ce: e340f1300004        lg      %r4,304(%r15)
                          00000000001b71d4: eb6ff0f00004        lmg     %r6,%r15,240(%r15)
                         #00000000001b71da: 07f4                bcr     15,%r4
                         >00000000001b71dc: d507d000b000        clc     0(8,%r13),0(%r11)
                          00000000001b71e2: a774f5d8            brc     7,1b5d92
                          00000000001b71e6: a7f4f5d4            brc     15,1b5d8e
                          00000000001b71ea: e310f0a80004        lg      %r1,168(%r15)
                          00000000001b71f0: e310d0200009        sg      %r1,32(%r13)
[   47.256304] Call Trace:
[   47.256306] ([<0000000000000000>] 0x0)
[   47.256309]  [<00000000001b7b96>] lock_acquire+0x1be/0x234
[   47.256312]  [<00000000006ce794>] _raw_spin_lock+0x5c/0x98
[   47.256319]  [<0000000000190abc>] __enable_runtime+0x5c/0x16c
[   47.256323]  [<0000000000191cb0>] rq_online_rt+0xbc/0xe0
[   47.256326]  [<0000000000173b00>] set_rq_online+0xac/0xc8
[   47.256329]  [<0000000000178ae8>] rq_attach_root+0x1e4/0x220
[   47.256332]  [<0000000000179560>] cpu_attach_domain+0x1b8/0x40c
[   47.256335]  [<000000000018201e>] build_sched_domains+0x1896/0x1f58
[   47.256339]  [<0000000000182c6a>] partition_sched_domains+0x572/0x694
[   47.256341]  [<00000000001de8d6>] cpuset_update_active_cpus+0x2e/0x40
[   47.256345]  [<0000000000182e6a>] cpuset_cpu_inactive+0x3a/0x80
[   47.256348]  [<00000000006d27fa>] notifier_call_chain+0x11a/0x168
[   47.256352]  [<000000000016e5e2>] __raw_notifier_call_chain+0x22/0x30
[   47.256357]  [<000000000013a874>] __cpu_notify+0x44/0x70
[   47.256363]  [<00000000006b4bf6>] _cpu_down+0xd6/0x3bc
[   47.256367]  [<00000000006b4f1e>] cpu_down+0x42/0x60
[   47.256370]  [<00000000006b83ae>] store_online+0x4a/0xb4
[   47.256373]  [<00000000003291e2>] sysfs_write_file+0x116/0x174
[   47.256378]  [<000000000029cfd0>] vfs_write+0xa4/0x180
[   47.256382]  [<000000000029d4d4>] SyS_write+0x5c/0x98
[   47.256385]  [<00000000006d013c>] sysc_nr_ok+0x22/0x28
[   47.256388]  [<000000477ec0af28>] 0x477ec0af28
[   47.256390] INFO: lockdep is turned off.
[   47.256392] Last Breaking-Event-Address:
[   47.256393]  [<00000000001b5d64>] __lock_acquire+0x70/0x16a4
[   47.256396]
[   47.256398] Kernel panic - not syncing: Fatal exception: panic_on_oops


Gerald Schaefer (1):
  sched/autogroup: Fix race with task_groups list

 kernel/sched/auto_group.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

-- 
1.8.1.6

