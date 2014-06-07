Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaFGBiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:38:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35986 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbaFGBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jiri Olsa" <jolsa@redhat.com>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Paul Mackerras" <paulus@samba.org>, "Ingo Molnar" <mingo@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Corey Ashford" <cjashfor@linux.vnet.ibm.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Fengguang Wu" <fengguang.wu@intel.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.97441598@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 77/92] perf: Prevent false warning in perf_swevent_add
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@redhat.com>

commit 39af6b1678afa5880dda7e375cf3f9d395087f6d upstream.

The perf cpu offline callback takes down all cpu context
events and releases swhash->swevent_hlist.

This could race with task context software event being just
scheduled on this cpu via perf_swevent_add while cpu hotplug
code already cleaned up event's data.

The race happens in the gap between the cpu notifier code
and the cpu being actually taken down. Note that only cpu
ctx events are terminated in the perf cpu hotplug code.

It's easily reproduced with:
  $ perf record -e faults perf bench sched pipe

while putting one of the cpus offline:
  # echo 0 > /sys/devices/system/cpu/cpu1/online

Console emits following warning:
  WARNING: CPU: 1 PID: 2845 at kernel/events/core.c:5672 perf_swevent_add+0x18d/0x1a0()
  Modules linked in:
  CPU: 1 PID: 2845 Comm: sched-pipe Tainted: G        W    3.14.0+ #256
  Hardware name: Intel Corporation Montevina platform/To be filled by O.E.M., BIOS AMVACRB1.86C.0066.B00.0805070703 05/07/2008
   0000000000000009 ffff880077233ab8 ffffffff81665a23 0000000000200005
   0000000000000000 ffff880077233af8 ffffffff8104732c 0000000000000046
   ffff88007467c800 0000000000000002 ffff88007a9cf2a0 0000000000000001
  Call Trace:
   [<ffffffff81665a23>] dump_stack+0x4f/0x7c
   [<ffffffff8104732c>] warn_slowpath_common+0x8c/0xc0
   [<ffffffff8104737a>] warn_slowpath_null+0x1a/0x20
   [<ffffffff8110fb3d>] perf_swevent_add+0x18d/0x1a0
   [<ffffffff811162ae>] event_sched_in.isra.75+0x9e/0x1f0
   [<ffffffff8111646a>] group_sched_in+0x6a/0x1f0
   [<ffffffff81083dd5>] ? sched_clock_local+0x25/0xa0
   [<ffffffff811167e6>] ctx_sched_in+0x1f6/0x450
   [<ffffffff8111757b>] perf_event_sched_in+0x6b/0xa0
   [<ffffffff81117a4b>] perf_event_context_sched_in+0x7b/0xc0
   [<ffffffff81117ece>] __perf_event_task_sched_in+0x43e/0x460
   [<ffffffff81096f1e>] ? put_lock_stats.isra.18+0xe/0x30
   [<ffffffff8107b3c8>] finish_task_switch+0xb8/0x100
   [<ffffffff8166a7de>] __schedule+0x30e/0xad0
   [<ffffffff81172dd2>] ? pipe_read+0x3e2/0x560
   [<ffffffff8166b45e>] ? preempt_schedule_irq+0x3e/0x70
   [<ffffffff8166b45e>] ? preempt_schedule_irq+0x3e/0x70
   [<ffffffff8166b464>] preempt_schedule_irq+0x44/0x70
   [<ffffffff816707f0>] retint_kernel+0x20/0x30
   [<ffffffff8109e60a>] ? lockdep_sys_exit+0x1a/0x90
   [<ffffffff812a4234>] lockdep_sys_exit_thunk+0x35/0x67
   [<ffffffff81679321>] ? sysret_check+0x5/0x56

Fixing this by tracking the cpu hotplug state and displaying
the WARN only if current cpu is initialized properly.

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1396861448-10097-1-git-send-email-jolsa@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/events/core.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4899,6 +4899,9 @@ struct swevent_htable {
 
 	/* Recursion avoidance in each contexts */
 	int				recursion[PERF_NR_CONTEXTS];
+
+	/* Keeps track of cpu being initialized/exited */
+	bool				online;
 };
 
 static DEFINE_PER_CPU(struct swevent_htable, swevent_htable);
@@ -5141,8 +5144,14 @@ static int perf_swevent_add(struct perf_
 	hwc->state = !(flags & PERF_EF_START);
 
 	head = find_swevent_head(swhash, event);
-	if (WARN_ON_ONCE(!head))
+	if (!head) {
+		/*
+		 * We can race with cpu hotplug code. Do not
+		 * WARN if the cpu just got unplugged.
+		 */
+		WARN_ON_ONCE(swhash->online);
 		return -EINVAL;
+	}
 
 	hlist_add_head_rcu(&event->hlist_entry, head);
 
@@ -7081,6 +7090,7 @@ static void __cpuinit perf_event_init_cp
 	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
 
 	mutex_lock(&swhash->hlist_mutex);
+	swhash->online = true;
 	if (swhash->hlist_refcount > 0) {
 		struct swevent_hlist *hlist;
 
@@ -7138,6 +7148,7 @@ static void perf_event_exit_cpu(int cpu)
 	perf_event_exit_cpu_context(cpu);
 
 	mutex_lock(&swhash->hlist_mutex);
+	swhash->online = false;
 	swevent_hlist_release(swhash);
 	mutex_unlock(&swhash->hlist_mutex);
 }

