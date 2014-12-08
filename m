Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaLHUVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:21:31 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:40844 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbaLHUV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:21:29 -0500
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, dahi@linux.vnet.ibm.com, borntraeger@de.ibm.com,
        rafael.j.wysocki@intel.com, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, bp@suse.de, jkosina@suse.cz
Subject: [PATCH v2] CPU hotplug: active_writer not woken up in some cases - deadlock
Date: Mon,  8 Dec 2014 21:21:22 +0100
Message-Id: <1418070082-13512-1-git-send-email-dahi@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120820-0013-0000-0000-000002234AAE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b2c4623dcd07 ("rcu: More on deadlock between CPU hotplug and expedited
grace periods") introduced another problem that can easily be reproduced by
starting/stopping cpus in a loop.

E.g.:
  for i in `seq 5000`; do
      echo 1 > /sys/devices/system/cpu/cpu1/online
      echo 0 > /sys/devices/system/cpu/cpu1/online
  done

Will result in:
  INFO: task /cpu_start_stop:1 blocked for more than 120 seconds.
  Call Trace:
  ([<00000000006a028e>] __schedule+0x406/0x91c)
   [<0000000000130f60>] cpu_hotplug_begin+0xd0/0xd4
   [<0000000000130ff6>] _cpu_up+0x3e/0x1c4
   [<0000000000131232>] cpu_up+0xb6/0xd4
   [<00000000004a5720>] device_online+0x80/0xc0
   [<00000000004a57f0>] online_store+0x90/0xb0
  ...

And a deadlock.

Problem is that if the last ref in put_online_cpus() can't get the
cpu_hotplug.lock the puts_pending count is incremented, but a sleeping active_writer
might never be woken up, therefore never exiting the loop in cpu_hotplug_begin().

This quick fix wakes up the active_writer proactively. The writer already
goes back to sleep if the ref count isn't already down to 0, so this should be
fine. Also move setting of TASK_UNINTERRUPTIBLE in cpu_hotplug_begin() above the
check, so we won't lose any wakeups when racing with put_online_cpus().

Can't reproduce it with this fix.

Signed-off-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
---
 kernel/cpu.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 90a3d01..1f50c06 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -113,10 +113,16 @@ EXPORT_SYMBOL_GPL(try_get_online_cpus);
 
 void put_online_cpus(void)
 {
+	struct task_struct *active_writer;
+
 	if (cpu_hotplug.active_writer == current)
 		return;
 	if (!mutex_trylock(&cpu_hotplug.lock)) {
 		atomic_inc(&cpu_hotplug.puts_pending);
+		/* we might be the last one */
+		active_writer = cpu_hotplug.active_writer;
+		if (unlikely(active_writer))
+			wake_up_process(active_writer);
 		cpuhp_lock_release();
 		return;
 	}
@@ -161,15 +167,17 @@ void cpu_hotplug_begin(void)
 	cpuhp_lock_acquire();
 	for (;;) {
 		mutex_lock(&cpu_hotplug.lock);
+		__set_current_state(TASK_UNINTERRUPTIBLE);
 		if (atomic_read(&cpu_hotplug.puts_pending)) {
 			int delta;
 
 			delta = atomic_xchg(&cpu_hotplug.puts_pending, 0);
 			cpu_hotplug.refcount -= delta;
 		}
-		if (likely(!cpu_hotplug.refcount))
+		if (likely(!cpu_hotplug.refcount)) {
+			__set_current_state(TASK_RUNNING);
 			break;
-		__set_current_state(TASK_UNINTERRUPTIBLE);
+		}
 		mutex_unlock(&cpu_hotplug.lock);
 		schedule();
 	}
-- 
1.8.5.5

