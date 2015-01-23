Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbbAWSqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:46:24 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38643 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523AbbAWSqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:46:12 -0500
From: Matt Fleming <matt@codeblueprint.co.uk>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v5 9/9] perf/x86/intel: Enable conflicting event scheduling for CQM
Date: Fri, 23 Jan 2015 18:45:48 +0000
Message-Id: <1422038748-21397-10-git-send-email-matt@codeblueprint.co.uk>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422038748-21397-1-git-send-email-matt@codeblueprint.co.uk>
References: <1422038748-21397-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

We can leverage the workqueue that we use for RMID rotation to support
scheduling of conflicting monitoring events. Allowing events that
monitor conflicting things is done at various other places in the perf
subsystem, so there's precedent there.

An example of two conflicting events would be monitoring a cgroup and
simultaneously monitoring a task within that cgroup.

This uses the cache_groups list as a queuing mechanism, where every
event that reaches the front of the list gets the chance to be scheduled
in, possibly descheduling any conflicting events that are running.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
Changes in v5:

 - s/intel_cqm_sched_out_events/intel_sched_out_conflicting_events/

 - Drop list_move_tail() which breaks rotatation fairness

 arch/x86/kernel/cpu/perf_event_intel_cqm.c | 130 +++++++++++++++++++----------
 1 file changed, 84 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_cqm.c b/arch/x86/kernel/cpu/perf_event_intel_cqm.c
index 3b3e84985b9e..e6c6c4834629 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_cqm.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_cqm.c
@@ -507,7 +507,6 @@ static unsigned int __rmid_queue_time_ms = RMID_DEFAULT_QUEUE_TIME;
 static bool intel_cqm_rmid_stabilize(unsigned int *available)
 {
 	struct cqm_rmid_entry *entry, *tmp;
-	struct perf_event *event;
 
 	lockdep_assert_held(&cache_mutex);
 
@@ -577,19 +576,9 @@ static bool intel_cqm_rmid_stabilize(unsigned int *available)
 
 		/*
 		 * If we have groups waiting for RMIDs, hand
-		 * them one now.
+		 * them one now provided they don't conflict.
 		 */
-		list_for_each_entry(event, &cache_groups,
-				    hw.cqm_groups_entry) {
-			if (__rmid_valid(event->hw.cqm_rmid))
-				continue;
-
-			intel_cqm_xchg_rmid(event, entry->rmid);
-			entry = NULL;
-			break;
-		}
-
-		if (!entry)
+		if (intel_cqm_sched_in_event(entry->rmid))
 			continue;
 
 		/*
@@ -604,25 +593,73 @@ static bool intel_cqm_rmid_stabilize(unsigned int *available)
 
 /*
  * Pick a victim group and move it to the tail of the group list.
+ * @next: The first group without an RMID
  */
-static struct perf_event *
-__intel_cqm_pick_and_rotate(void)
+static void __intel_cqm_pick_and_rotate(struct perf_event *next)
 {
 	struct perf_event *rotor;
+	unsigned int rmid;
 
 	lockdep_assert_held(&cache_mutex);
-	lockdep_assert_held(&cache_lock);
 
 	rotor = list_first_entry(&cache_groups, struct perf_event,
 				 hw.cqm_groups_entry);
+
+	/*
+	 * The group at the front of the list should always have a valid
+	 * RMID. If it doesn't then no groups have RMIDs assigned and we
+	 * don't need to rotate the list.
+	 */
+	if (next == rotor)
+		return;
+
+	rmid = intel_cqm_xchg_rmid(rotor, INVALID_RMID);
+	__put_rmid(rmid);
+
 	list_rotate_left(&cache_groups);
+}
+
+/*
+ * Deallocate the RMIDs from any events that conflict with @event, and
+ * place them on the back of the group list.
+ */
+static void intel_cqm_sched_out_conflicting_events(struct perf_event *event)
+{
+	struct perf_event *group, *g;
+	unsigned int rmid;
+
+	lockdep_assert_held(&cache_mutex);
+
+	list_for_each_entry_safe(group, g, &cache_groups, hw.cqm_groups_entry) {
+		if (group == event)
+			continue;
+
+		rmid = group->hw.cqm_rmid;
+
+		/*
+		 * Skip events that don't have a valid RMID.
+		 */
+		if (!__rmid_valid(rmid))
+			continue;
+
+		/*
+		 * No conflict? No problem! Leave the event alone.
+		 */
+		if (!__conflict_event(group, event))
+			continue;
 
-	return rotor;
+		intel_cqm_xchg_rmid(group, INVALID_RMID);
+		__put_rmid(rmid);
+	}
 }
 
 /*
  * Attempt to rotate the groups and assign new RMIDs.
  *
+ * We rotate for two reasons,
+ *   1. To handle the scheduling of conflicting events
+ *   2. To recycle RMIDs
+ *
  * Rotating RMIDs is complicated because the hardware doesn't give us
  * any clues.
  *
@@ -642,11 +679,10 @@ __intel_cqm_pick_and_rotate(void)
  */
 static bool __intel_cqm_rmid_rotate(void)
 {
-	struct perf_event *group, *rotor, *start = NULL;
+	struct perf_event *group, *start = NULL;
 	unsigned int threshold_limit;
 	unsigned int nr_needed = 0;
 	unsigned int nr_available;
-	unsigned int rmid;
 	bool rotated = false;
 
 	mutex_lock(&cache_mutex);
@@ -678,7 +714,9 @@ again:
 		goto stabilize;
 
 	/*
-	 * We have more event groups without RMIDs than available RMIDs.
+	 * We have more event groups without RMIDs than available RMIDs,
+	 * or we have event groups that conflict with the ones currently
+	 * scheduled.
 	 *
 	 * We force deallocate the rmid of the group at the head of
 	 * cache_groups. The first event group without an RMID then gets
@@ -688,15 +726,7 @@ again:
 	 * Rotate the cache_groups list so the previous head is now the
 	 * tail.
 	 */
-	rotor = __intel_cqm_pick_and_rotate();
-	rmid = intel_cqm_xchg_rmid(rotor, INVALID_RMID);
-
-	/*
-	 * The group at the front of the list should always have a valid
-	 * RMID. If it doesn't then no groups have RMIDs assigned.
-	 */
-	if (!__rmid_valid(rmid))
-		goto stabilize;
+	__intel_cqm_pick_and_rotate(start);
 
 	/*
 	 * If the rotation is going to succeed, reduce the threshold so
@@ -704,14 +734,14 @@ again:
 	 */
 	if (__rmid_valid(intel_cqm_rotation_rmid)) {
 		intel_cqm_xchg_rmid(start, intel_cqm_rotation_rmid);
-		intel_cqm_rotation_rmid = INVALID_RMID;
+		intel_cqm_rotation_rmid = __get_rmid();
+
+		intel_cqm_sched_out_conflicting_events(start);
 
 		if (__intel_cqm_threshold)
 			__intel_cqm_threshold--;
 	}
 
-	__put_rmid(rmid);
-
 	rotated = true;
 
 stabilize:
@@ -794,25 +824,37 @@ static void intel_cqm_rmid_rotate(struct work_struct *work)
  *
  * If we're part of a group, we use the group's RMID.
  */
-static int intel_cqm_setup_event(struct perf_event *event,
-				 struct perf_event **group)
+static void intel_cqm_setup_event(struct perf_event *event,
+				  struct perf_event **group)
 {
 	struct perf_event *iter;
+	unsigned int rmid;
+	bool conflict = false;
 
 	list_for_each_entry(iter, &cache_groups, hw.cqm_groups_entry) {
+		rmid = iter->hw.cqm_rmid;
+
 		if (__match_event(iter, event)) {
 			/* All tasks in a group share an RMID */
-			event->hw.cqm_rmid = iter->hw.cqm_rmid;
+			event->hw.cqm_rmid = rmid;
 			*group = iter;
-			return 0;
+			return;
 		}
 
-		if (__conflict_event(iter, event))
-			return -EBUSY;
+		/*
+		 * We only care about conflicts for events that are
+		 * actually scheduled in (and hence have a valid RMID).
+		 */
+		if (__conflict_event(iter, event) && __rmid_valid(rmid))
+			conflict = true;
 	}
 
-	event->hw.cqm_rmid = __get_rmid();
-	return 0;
+	if (conflict)
+		rmid = INVALID_RMID;
+	else
+		rmid = __get_rmid();
+
+	event->hw.cqm_rmid = rmid;
 }
 
 static void intel_cqm_event_read(struct perf_event *event)
@@ -1030,7 +1072,6 @@ static int intel_cqm_event_init(struct perf_event *event)
 {
 	struct perf_event *group = NULL;
 	bool rotate = false;
-	int err;
 
 	if (event->attr.type != intel_cqm_pmu.type)
 		return -ENOENT;
@@ -1056,9 +1097,7 @@ static int intel_cqm_event_init(struct perf_event *event)
 	mutex_lock(&cache_mutex);
 
 	/* Will also set rmid */
-	err = intel_cqm_setup_event(event, &group);
-	if (err)
-		goto out;
+	intel_cqm_setup_event(event, &group);
 
 	if (group) {
 		list_add_tail(&event->hw.cqm_group_entry,
@@ -1078,13 +1117,12 @@ static int intel_cqm_event_init(struct perf_event *event)
 			rotate = true;
 	}
 
-out:
 	mutex_unlock(&cache_mutex);
 
 	if (rotate)
 		schedule_delayed_work(&intel_cqm_rmid_work, 0);
 
-	return err;
+	return 0;
 }
 
 EVENT_ATTR_STR(llc_occupancy, intel_cqm_llc, "event=0x01");
-- 
1.9.3

