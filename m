Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbaDBOUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:20:46 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53543 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaDBOTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:19:46 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-e6-533c1c7f79ed
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: stable@vger.kernel.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Xiaoguang Chen <chenxg@marvell.com>, Stephen Boyd <sboyd@codeaurora.org>,
        rjw@rjwysocki.net, Viresh Kumar <viresh.kumar@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 0/2] Backport to 3.10 stable (Fix CPU0 stall after CPU1 hotplug)
Date: Wed, 02 Apr 2014 16:19:36 +0200
Message-id: <1396448378-22487-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsVy+t/xy7r1MjbBBodWmVgcm76E1eJp0w92
	i9cvDC0u75rDZvG59wijxZnTl1gtfpzpZrFYsPERo8XGrx4OnB6X+3qZPO5c28PmMXnhRWaP
	LVfbWTz6tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoErY/mOGUwF7/QrtjXsY2xg/KbVxcjJISFg
	IvFkzj52CFtM4sK99WxdjFwcQgJLGSUevDrACOH0MUn8aJ7HBlLFJmAssXn5EjBbRCBX4nPH
	emaQImaBXYwS9xfvYAJJCAsESDx/94QFxGYRUJW48m0pI4jNK+Au0fv/M1CcA2idgsScSTYT
	GLkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJoC87GBcfszrEKMDBqMTDayFlEyzE
	mlhWXJl7iFGCg1lJhHfSJ+tgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyOYjuWhwv6f9odMmnR
	9fDVna+Y50YoMZ0SW6PlWbZ5W4/z3JdP1CfacCS6fd+9/dbX/DtMVrtdu7nWiDhOXRzZe3vD
	ryV5yap+Nj6pS8qlmOXPruLhXW2qWpcrdeKAx9dIE5arCrX3H/Dk8vZHyq/U25kWmnNMTDPZ
	qo7fy8MzSMFird8FOSWW4oxEQy3mouJEAJ6mrXT+AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These two patches are good candidates for backporting to stable 3.10. They fix
a CPU0 stall due to timer list corruption after hotplugging CPU1.

1. Commit: 95731ebb114c
   cpufreq: Fix governor start/stop race condition
2. Commit: 3617f2ca6d0e
   cpufreq: Fix timer/workqueue corruption due to double queueing

Stall:
[  130.127262] INFO: rcu_preempt detected stalls on CPUs/tasks: { 0} (detected by 1, t=12003 jiffies, g=172, c=171, q=0)
[  130.132285] Task dump for CPU 0:
[  130.135496] swapper/0       R running      0     0      0 0x00001000
[  130.141983] [<c04ae870>] (__schedule+0x3bc/0x80c) from [<c075ffec>] (cpu_idle_force_poll+0x0/0x4)

List corruption:
[ 4244.528166] ------------[ cut here ]------------
[ 4244.528507] WARNING: at lib/list_debug.c:33 __list_add+0xa8/0xbc()
[ 4244.533418] list_add corruption. prev->next should be next (c08864b0), but was   (null). (prev=c1105454).
[ 4244.542938] Modules linked in:
[ 4244.546024] CPU: 0 PID: 1 Comm: sh Tainted: G        W    3.10.14-03857-g20b26f7e0c59-dirty #1354
[ 4244.554956] [<c0016194>] (unwind_backtrace+0x0/0x138) from [<c001336c>] (show_stack+0x10/0x14)
[ 4244.563518] [<c001336c>] (show_stack+0x10/0x14) from [<c0025438>] (warn_slowpath_common+0x4c/0x68)
[ 4244.572452] [<c0025438>] (warn_slowpath_common+0x4c/0x68) from [<c00254e8>] (warn_slowpath_fmt+0x30/0x40)
[ 4244.582008] [<c00254e8>] (warn_slowpath_fmt+0x30/0x40) from [<c022b9b8>] (__list_add+0xa8/0xbc)
[ 4244.590696] [<c022b9b8>] (__list_add+0xa8/0xbc) from [<c0034ac8>] (internal_add_timer+0x10/0x40)
[ 4244.599462] [<c0034ac8>] (internal_add_timer+0x10/0x40) from [<c00350e4>] (add_timer_on+0x74/0x124)
[ 4244.608493] [<c00350e4>] (add_timer_on+0x74/0x124) from [<c004354c>] (mod_delayed_work_on+0x50/0x68)
[ 4244.617622] [<c004354c>] (mod_delayed_work_on+0x50/0x68) from [<c0347df8>] (gov_queue_work+0x48/0xa4)
[ 4244.626805] [<c0347df8>] (gov_queue_work+0x48/0xa4) from [<c0348518>] (cpufreq_governor_dbs+0x29c/0x668)
[ 4244.636261] [<c0348518>] (cpufreq_governor_dbs+0x29c/0x668) from [<c034438c>] (__cpufreq_governor.part.9+0x30/0xd4)
[ 4244.646689] [<c034438c>] (__cpufreq_governor.part.9+0x30/0xd4) from [<c0345474>] (__cpufreq_remove_dev.isra.12+0x130/0x484)
[ 4244.657798] [<c0345474>] (__cpufreq_remove_dev.isra.12+0x130/0x484) from [<c04cc8fc>] (cpufreq_cpu_callback+0x70/0x80)
[ 4244.668466] [<c04cc8fc>] (cpufreq_cpu_callback+0x70/0x80) from [<c004e808>] (notifier_call_chain+0x44/0x84)
[ 4244.678184] [<c004e808>] (notifier_call_chain+0x44/0x84) from [<c0028ac0>] (__cpu_notify+0x2c/0x48)
[ 4244.687200] [<c0028ac0>] (__cpu_notify+0x2c/0x48) from [<c04c9208>] (_cpu_down+0x80/0x268)
[ 4244.695436] [<c04c9208>] (_cpu_down+0x80/0x268) from [<c04c9418>] (cpu_down+0x28/0x3c)
[ 4244.703334] [<c04c9418>] (cpu_down+0x28/0x3c) from [<c04c9b44>] (store_online+0x30/0x74)
[ 4244.711426] [<c04c9b44>] (store_online+0x30/0x74) from [<c02cb2b0>] (dev_attr_store+0x18/0x24)
[ 4244.720027] [<c02cb2b0>] (dev_attr_store+0x18/0x24) from [<c016b2d4>] (sysfs_write_file+0x80/0xb4)
[ 4244.728960] [<c016b2d4>] (sysfs_write_file+0x80/0xb4) from [<c010f2d8>] (vfs_write+0xbc/0x1bc)
[ 4244.737551] [<c010f2d8>] (vfs_write+0xbc/0x1bc) from [<c010f718>] (SyS_write+0x40/0x68)
[ 4244.745541] [<c010f718>] (SyS_write+0x40/0x68) from [<c000ec00>] (ret_fast_syscall+0x0/0x3c)
[ 4244.753881] ---[ end trace 6c85e0f7596a61f2 ]---
[ 4244.758467] ------------[ cut here ]------------
[ 4244.763115] WARNING: at lib/list_debug.c:36 __list_add+0x88/0xbc()
[ 4244.769247] list_add double add: new=c1105454, prev=c1105454, next=c08864b0.
[ 4244.776254] Modules linked in:
[ 4244.779337] CPU: 0 PID: 1 Comm: sh Tainted: G        W    3.10.14-03857-g20b26f7e0c59-dirty #1354
[ 4244.788247] [<c0016194>] (unwind_backtrace+0x0/0x138) from [<c001336c>] (show_stack+0x10/0x14)
[ 4244.796830] [<c001336c>] (show_stack+0x10/0x14) from [<c0025438>] (warn_slowpath_common+0x4c/0x68)
[ 4244.805766] [<c0025438>] (warn_slowpath_common+0x4c/0x68) from [<c00254e8>] (warn_slowpath_fmt+0x30/0x40)
[ 4244.815325] [<c00254e8>] (warn_slowpath_fmt+0x30/0x40) from [<c022b998>] (__list_add+0x88/0xbc)
[ 4244.824009] [<c022b998>] (__list_add+0x88/0xbc) from [<c0034ac8>] (internal_add_timer+0x10/0x40)
[ 4244.832777] [<c0034ac8>] (internal_add_timer+0x10/0x40) from [<c00350e4>] (add_timer_on+0x74/0x124)
[ 4244.841811] [<c00350e4>] (add_timer_on+0x74/0x124) from [<c004354c>] (mod_delayed_work_on+0x50/0x68)
[ 4244.850935] [<c004354c>] (mod_delayed_work_on+0x50/0x68) from [<c0347df8>] (gov_queue_work+0x48/0xa4)
[ 4244.860120] [<c0347df8>] (gov_queue_work+0x48/0xa4) from [<c0348518>] (cpufreq_governor_dbs+0x29c/0x668)
[ 4244.869577] [<c0348518>] (cpufreq_governor_dbs+0x29c/0x668) from [<c034438c>] (__cpufreq_governor.part.9+0x30/0xd4)
[ 4244.880007] [<c034438c>] (__cpufreq_governor.part.9+0x30/0xd4) from [<c0345474>] (__cpufreq_remove_dev.isra.12+0x130/0x484)
[ 4244.891112] [<c0345474>] (__cpufreq_remove_dev.isra.12+0x130/0x484) from [<c04cc8fc>] (cpufreq_cpu_callback+0x70/0x80)
[ 4244.901780] [<c04cc8fc>] (cpufreq_cpu_callback+0x70/0x80) from [<c004e808>] (notifier_call_chain+0x44/0x84)
[ 4244.911499] [<c004e808>] (notifier_call_chain+0x44/0x84) from [<c0028ac0>] (__cpu_notify+0x2c/0x48)
[ 4244.920515] [<c0028ac0>] (__cpu_notify+0x2c/0x48) from [<c04c9208>] (_cpu_down+0x80/0x268)
[ 4244.928752] [<c04c9208>] (_cpu_down+0x80/0x268) from [<c04c9418>] (cpu_down+0x28/0x3c)
[ 4244.936653] [<c04c9418>] (cpu_down+0x28/0x3c) from [<c04c9b44>] (store_online+0x30/0x74)
[ 4244.944741] [<c04c9b44>] (store_online+0x30/0x74) from [<c02cb2b0>] (dev_attr_store+0x18/0x24)
[ 4244.953341] [<c02cb2b0>] (dev_attr_store+0x18/0x24) from [<c016b2d4>] (sysfs_write_file+0x80/0xb4)
[ 4244.962274] [<c016b2d4>] (sysfs_write_file+0x80/0xb4) from [<c010f2d8>] (vfs_write+0xbc/0x1bc)
[ 4244.970866] [<c010f2d8>] (vfs_write+0xbc/0x1bc) from [<c010f718>] (SyS_write+0x40/0x68)
[ 4244.978858] [<c010f718>] (SyS_write+0x40/0x68) from [<c000ec00>] (ret_fast_syscall+0x0/0x3c)
[ 4244.987198] ---[ end trace 6c85e0f7596a61f3 ]---


Best regards,
Krzysztof

