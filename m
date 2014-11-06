Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaKFMYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:24:07 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38530 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaKFMXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:23:54 -0500
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 11/11] perf/x86/intel: Enable conflicting event scheduling for CQM
Date: Thu,  6 Nov 2014 12:23:22 +0000
Message-Id: <1415276602-10337-12-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
References: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
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
 arch/x86/kernel/cpu/perf_event_intel_cqm.c | 161 ++++++++++++++++++++---------
 1 file changed, 115 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_cqm.c b/arch/x86/kernel/cpu/perf_event_intel_cqm.c
index 661ce4d70e4f..c06ba467b1ee 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_cqm.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_cqm.c
@@ -455,6 +455,35 @@ static void intel_cqm_stable(void *arg)
 	}
 }
 
+/*
+ * If we have group events waiting for an RMID that don't conflict with
+ * events already running, assign @rmid.
+ */
+static bool intel_cqm_sched_in_event(unsigned int rmid)
+{
+	struct perf_event *leader, *event;
+
+	lockdep_assert_held(&cache_mutex);
+
+	leader = list_first_entry(&cache_groups, struct perf_event,
+				  hw.cqm_groups_entry);
+	event = leader;
+
+	list_for_each_entry_continue(event, &cache_groups,
+				     hw.cqm_groups_entry) {
+		if (__rmid_valid(event->hw.cqm_rmid))
+			continue;
+
+		if (__conflict_event(event, leader))
+			continue;
+
+		intel_cqm_xchg_rmid(event, rmid);
+		return true;
+	}
+
+	return false;
+}
+
 static unsigned int __rotation_period = 250; /* ms */
 
 /*
@@ -480,7 +509,6 @@ static bool intel_cqm_rmid_stabilize(bool *available)
 {
 	struct cqm_rmid_entry *entry;
 	unsigned int nr_bits;
-	struct perf_event *event;
 
 	lockdep_assert_held(&cache_mutex);
 
@@ -554,19 +582,9 @@ static bool intel_cqm_rmid_stabilize(bool *available)
 
 			/*
 			 * If we have groups waiting for RMIDs, hand
-			 * them one now.
+			 * them one now provided they don't conflict.
 			 */
-			list_for_each_entry(event, &cache_groups,
-					    hw.cqm_groups_entry) {
-				if (__rmid_valid(event->hw.cqm_rmid))
-					continue;
-
-				intel_cqm_xchg_rmid(event, i);
-				entry = NULL;
-				break;
-			}
-
-			if (!entry)
+			if (intel_cqm_sched_in_event(i))
 				continue;
 
 			/*
@@ -581,25 +599,75 @@ static bool intel_cqm_rmid_stabilize(bool *available)
 
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
 
-	return rotor;
+/*
+ * Deallocate the RMIDs from any events that conflict with @event, and
+ * place them on the back of the group list.
+ */
+static void intel_cqm_sched_out_events(struct perf_event *event)
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
+
+		intel_cqm_xchg_rmid(group, INVALID_RMID);
+		__put_rmid(rmid);
+
+		list_move_tail(&group->hw.cqm_groups_entry, &cache_groups);
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
@@ -619,9 +687,8 @@ __intel_cqm_pick_and_rotate(void)
  */
 static bool __intel_cqm_rmid_rotate(void)
 {
-	struct perf_event *group, *rotor, *start = NULL;
+	struct perf_event *group, *start = NULL;
 	unsigned int nr_needed = 0;
-	unsigned int rmid;
 	bool rotated = false;
 	bool available;
 
@@ -654,7 +721,9 @@ again:
 		goto stabilize;
 
 	/*
-	 * We have more event groups without RMIDs than available RMIDs.
+	 * We have more event groups without RMIDs than available RMIDs,
+	 * or we have event groups that conflict with the ones currently
+	 * scheduled.
 	 *
 	 * We force deallocate the rmid of the group at the head of
 	 * cache_groups. The first event group without an RMID then gets
@@ -664,15 +733,7 @@ again:
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
@@ -680,14 +741,14 @@ again:
 	 */
 	if (__rmid_valid(intel_cqm_rotation_rmid)) {
 		intel_cqm_xchg_rmid(start, intel_cqm_rotation_rmid);
-		intel_cqm_rotation_rmid = INVALID_RMID;
+		intel_cqm_rotation_rmid = __get_rmid();
+
+		intel_cqm_sched_out_events(start);
 
 		if (__intel_cqm_threshold)
 			__intel_cqm_threshold--;
 	}
 
-	__put_rmid(rmid);
-
 	rotated = true;
 
 stabilize:
@@ -731,25 +792,37 @@ static void intel_cqm_rmid_rotate(struct work_struct *work)
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
@@ -971,7 +1044,6 @@ static int intel_cqm_event_init(struct perf_event *event)
 {
 	struct perf_event *group = NULL;
 	bool rotate = false;
-	int err;
 
 	if (event->attr.type != intel_cqm_pmu.type)
 		return -ENOENT;
@@ -997,9 +1069,7 @@ static int intel_cqm_event_init(struct perf_event *event)
 	mutex_lock(&cache_mutex);
 
 	/* Will also set rmid */
-	err = intel_cqm_setup_event(event, &group);
-	if (err)
-		goto out;
+	intel_cqm_setup_event(event, &group);
 
 	if (group) {
 		list_add_tail(&event->hw.cqm_group_entry,
@@ -1019,13 +1089,12 @@ static int intel_cqm_event_init(struct perf_event *event)
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

