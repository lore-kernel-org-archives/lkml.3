Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbaFQNLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 09:11:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968AbaFQNLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 09:11:13 -0400
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Cc: peter@lekensteyn.nl, mhocko@suse.cz, Don Zickus <dzickus@redhat.com>
Subject: [PATCH] watchdog: Remove preemption restrictions when restarting lockup detector
Date: Tue, 17 Jun 2014 09:10:53 -0400
Message-Id: <1403010653-243385-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Wu noticed the following splat on his machine when updating
/proc/sys/kernel/watchdog_thresh:

[    0.676701] BUG: sleeping function called from invalid context at /tmp/linux/mm/slub.c:965
[    0.679396] in_atomic(): 1, irqs_disabled(): 0, pid: 1, name: init
[    0.681204] 3 locks held by init/1:
[    0.682371]  #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff8117b663>] vfs_write+0x143/0x180
[    0.685887]  #1:  (watchdog_proc_mutex){+.+.+.}, at: [<ffffffff810e02d3>] proc_dowatchdog+0x33/0x110
[    0.689631]  #2:  (cpu_hotplug.lock){.+.+.+}, at: [<ffffffff810589c2>] get_online_cpus+0x32/0x80
[    0.693117] Preemption disabled at:[<ffffffff810e0384>] proc_dowatchdog+0xe4/0x110
[    0.695753]
[    0.696588] CPU: 0 PID: 1 Comm: init Not tainted 3.16.0-rc1-testing #34
[    0.698404] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[    0.704622]  ffff88003f250000 ffff88003f1ffd10 ffffffff81624c59 0000000000000000
[    0.707749]  ffff88003f1ffd30 ffffffff8108df1d 0000000000000010 ffffffff81c56360
[    0.711010]  ffff88003f1ffd78 ffffffff8116a5de ffffffff811159a5 ffffffff810a5f4a
[    0.714053] Call Trace:
[    0.715015]  [<ffffffff81624c59>] dump_stack+0x4e/0x7a
[    0.716619]  [<ffffffff8108df1d>] __might_sleep+0x11d/0x190
[    0.718232]  [<ffffffff8116a5de>] kmem_cache_alloc_trace+0x4e/0x1e0
[    0.720214]  [<ffffffff811159a5>] ? perf_event_alloc+0x55/0x440
[    0.721910]  [<ffffffff810a5f4a>] ? mark_held_locks+0x6a/0x90
[    0.723558]  [<ffffffff811159a5>] perf_event_alloc+0x55/0x440
[    0.725304]  [<ffffffff810e0050>] ? restart_watchdog_hrtimer+0x50/0x50
[    0.727279]  [<ffffffff81116d16>] perf_event_create_kernel_counter+0x26/0xe0
[    0.729269]  [<ffffffff810dfe05>] watchdog_nmi_enable+0x75/0x140
[    0.730965]  [<ffffffff810dffb3>] update_timers_all_cpus+0x53/0xa0
[    0.732953]  [<ffffffff810e0384>] proc_dowatchdog+0xe4/0x110
[    0.738408]  [<ffffffff811d8c93>] proc_sys_call_handler+0xb3/0xc0
[    0.740266]  [<ffffffff811d8cb4>] proc_sys_write+0x14/0x20
[    0.742086]  [<ffffffff8117b5cd>] vfs_write+0xad/0x180
[    0.743669]  [<ffffffff810a606d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[    0.745593]  [<ffffffff8117b799>] SyS_write+0x49/0xb0
[    0.747101]  [<ffffffff8162fe92>] system_call_fastpath+0x16/0x1b
[    0.749069] NMI watchdog: disabled (cpu0): hardware events not enabled

What happened is after updating the watchdog_thresh, the lockup detector is
restarted to utilize the new value.  Part of this process involved disabling
preemption.  Once preemption was disabled, perf tried to allocate a new event
(as part of the restart).  This caused the above BUG_ON as you can't sleep with
preemption disabled.

The preemption restriction seemed agressive as we are not doing anything
on that particular cpu, but with all the online cpus (which are protected by
the get_online_cpus lock).  Remove the restriction and the BUG_ON goes away.

Reported-and-Tested-by: Peter Wu <peter@lekensteyn.nl>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 516203e..30e4822 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -527,10 +527,8 @@ static void update_timers_all_cpus(void)
 	int cpu;
 
 	get_online_cpus();
-	preempt_disable();
 	for_each_online_cpu(cpu)
 		update_timers(cpu);
-	preempt_enable();
 	put_online_cpus();
 }
 
-- 
1.7.1

