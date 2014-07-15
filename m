Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904AbaGOVoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:44:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55069 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759064AbaGOVjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:39:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Don Zickus <dzickus@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 178/198] kernel/watchdog.c: remove preemption restrictions when restarting lockup detector
Date: Tue, 15 Jul 2014 14:30:48 -0700
Message-Id: <1405459868-15089-179-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Don Zickus <dzickus@redhat.com>

commit bde92cf455a03a91badb7046855592d8c008e929 upstream.

Peter Wu noticed the following splat on his machine when updating
/proc/sys/kernel/watchdog_thresh:

  BUG: sleeping function called from invalid context at mm/slub.c:965
  in_atomic(): 1, irqs_disabled(): 0, pid: 1, name: init
  3 locks held by init/1:
   #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff8117b663>] vfs_write+0x143/0x180
   #1:  (watchdog_proc_mutex){+.+.+.}, at: [<ffffffff810e02d3>] proc_dowatchdog+0x33/0x110
   #2:  (cpu_hotplug.lock){.+.+.+}, at: [<ffffffff810589c2>] get_online_cpus+0x32/0x80
  Preemption disabled at:[<ffffffff810e0384>] proc_dowatchdog+0xe4/0x110

  CPU: 0 PID: 1 Comm: init Not tainted 3.16.0-rc1-testing #34
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
  Call Trace:
    dump_stack+0x4e/0x7a
    __might_sleep+0x11d/0x190
    kmem_cache_alloc_trace+0x4e/0x1e0
    perf_event_alloc+0x55/0x440
    perf_event_create_kernel_counter+0x26/0xe0
    watchdog_nmi_enable+0x75/0x140
    update_timers_all_cpus+0x53/0xa0
    proc_dowatchdog+0xe4/0x110
    proc_sys_call_handler+0xb3/0xc0
    proc_sys_write+0x14/0x20
    vfs_write+0xad/0x180
    SyS_write+0x49/0xb0
    system_call_fastpath+0x16/0x1b
  NMI watchdog: disabled (cpu0): hardware events not enabled

What happened is after updating the watchdog_thresh, the lockup detector
is restarted to utilize the new value.  Part of this process involved
disabling preemption.  Once preemption was disabled, perf tried to
allocate a new event (as part of the restart).  This caused the above
BUG_ON as you can't sleep with preemption disabled.

The preemption restriction seemed agressive as we are not doing anything
on that particular cpu, but with all the online cpus (which are
protected by the get_online_cpus lock).  Remove the restriction and the
BUG_ON goes away.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Peter Wu <peter@lekensteyn.nl>
Tested-by: Peter Wu <peter@lekensteyn.nl>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/watchdog.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 4431610..c9b6f01 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -524,10 +524,8 @@ static void update_timers_all_cpus(void)
 	int cpu;
 
 	get_online_cpus();
-	preempt_disable();
 	for_each_online_cpu(cpu)
 		update_timers(cpu);
-	preempt_enable();
 	put_online_cpus();
 }
 
-- 
1.9.1

