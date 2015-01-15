Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbbAOTh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:37:28 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:47096 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbbAOTh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:37:27 -0500
Date: Thu, 15 Jan 2015 19:37:23 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v4 10/11] perf/x86/intel: Perform rotation on Intel CQM
 RMIDs
Message-ID: <20150115193723.GA12079@codeblueprint.co.uk>
References: <1415999712-5850-1-git-send-email-matt@console-pimps.org>
 <1415999712-5850-11-git-send-email-matt@console-pimps.org>
 <20150106171712.GH3337@twins.programming.kicks-ass.net>
 <20150109121401.GB495@console-pimps.org>
 <20150109130250.GH29390@twins.programming.kicks-ass.net>
 <20150109152442.GG495@console-pimps.org>
 <20150109155835.GJ29390@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109155835.GJ29390@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jan, at 04:58:35PM, Peter Zijlstra wrote:
> 
> Yeah, that'll work, when the free+limbo count is 1/4th the total we
> should stop pulling more plugs.

Perhaps something like this? It favours stealing more RMIDs over
increasing the "dirty threshold".

---

diff --git a/arch/x86/kernel/cpu/perf_event_intel_cqm.c b/arch/x86/kernel/cpu/perf_event_intel_cqm.c
index fc1a90245601..af58f233c93c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_cqm.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_cqm.c
@@ -490,29 +490,27 @@ static unsigned int __rmid_queue_time_ms = RMID_DEFAULT_QUEUE_TIME;
 
 /*
  * intel_cqm_rmid_stabilize - move RMIDs from limbo to free list
- * @available: are there freeable RMIDs on the limbo list?
+ * @nr_available: number of freeable RMIDs on the limbo list
  *
  * Quiescent state; wait for all 'freed' RMIDs to become unused, i.e. no
  * cachelines are tagged with those RMIDs. After this we can reuse them
  * and know that the current set of active RMIDs is stable.
  *
- * Return %true or %false depending on whether we were able to stabilize
- * an RMID for intel_cqm_rotation_rmid.
+ * Return %true or %false depending on whether stabilization needs to be
+ * reattempted.
  *
- * If we return %false then @available is updated to indicate the reason
- * we couldn't stabilize any RMIDs. @available is %false if no suitable
- * RMIDs were found on the limbo list to recycle, i.e. no RMIDs had been
- * on the list for the minimum queue time. If @available is %true then,
- * we found suitable RMIDs to recycle but none had an associated
- * occupancy value below __intel_cqm_threshold and the threshold should
- * be increased and stabilization reattempted.
+ * If we return %true then @nr_available is updated to indicate the
+ * number of RMIDs on the limbo list that have been queued for the
+ * minimum queue time (RMID_AVAILABLE), but whose data occupancy values
+ * are above __intel_cqm_threshold.
  */
-static bool intel_cqm_rmid_stabilize(bool *available)
+static bool intel_cqm_rmid_stabilize(unsigned int *available)
 {
 	struct cqm_rmid_entry *entry, *tmp;
 
 	lockdep_assert_held(&cache_mutex);
 
+	*available = 0;
 	list_for_each_entry(entry, &cqm_rmid_limbo_lru, list) {
 		unsigned long min_queue_time;
 		unsigned long now = jiffies;
@@ -539,7 +537,7 @@ static bool intel_cqm_rmid_stabilize(bool *available)
 			break;
 
 		entry->state = RMID_AVAILABLE;
-		*available = true;
+		*available++;
 	}
 
 	/*
@@ -547,7 +545,7 @@ static bool intel_cqm_rmid_stabilize(bool *available)
 	 * sitting on the queue for the minimum queue time.
 	 */
 	if (!*available)
-		return false;
+		return true;
 
 	/*
 	 * Test whether an RMID is free for each package.
@@ -684,9 +682,10 @@ static void intel_cqm_sched_out_events(struct perf_event *event)
 static bool __intel_cqm_rmid_rotate(void)
 {
 	struct perf_event *group, *start = NULL;
+	unsigned int threshold_limit;
 	unsigned int nr_needed = 0;
+	unsigned int nr_available;
 	bool rotated = false;
-	bool available;
 
 	mutex_lock(&cache_mutex);
 
@@ -756,14 +755,41 @@ stabilize:
 	 * Alternatively, if we didn't need to perform any rotation,
 	 * we'll have a bunch of RMIDs in limbo that need stabilizing.
 	 */
-	if (!intel_cqm_rmid_stabilize(&available)) {
-		unsigned int limit;
+	threshold_limit = __intel_cqm_max_threshold / cqm_l3_scale;
+
+	while (intel_cqm_rmid_stabilize(&nr_available) &&
+	       __intel_cqm_threshold < threshold_limit) {
+		unsigned int steal_limit;
+
+		/* Allow max 25% of RMIDs to be in limbo. */
+		steal_limit = (cqm_max_rmid + 1) / 4;
 
-		limit = __intel_cqm_max_threshold / cqm_l3_scale;
-		if (available && __intel_cqm_threshold < limit) {
-			__intel_cqm_threshold++;
+		/*
+		 * We failed to stabilize any RMIDs so our rotation
+		 * logic is now stuck. In order to make forward progress
+		 * we have a few options:
+		 *
+		 *   1. rotate ("steal") another RMID
+		 *   2. increase the threshold
+		 *   3. do nothing
+		 *
+		 * We do both of 1. and 2. until we hit the steal limit.
+		 *
+		 * The steal limit prevents all RMIDs ending up on the
+		 * limbo list. This can happen if every RMID has a
+		 * non-zero occupancy above threshold_limit, and the
+		 * occupancy values aren't dropping fast enough.
+		 *
+		 * Note that there is prioritisation at work here - we'd
+		 * rather increase the number of RMIDs on the limbo list
+		 * than increase the threshold, because increasing the
+		 * threshold skews the event data (because we reuse
+		 * dirty RMIDs) - threshold bumps are a last resort.
+		 */
+		if (nr_available < steal_limit)
 			goto again;
-		}
+
+		__intel_cqm_threshold++;
 	}
 
 out:

-- 
Matt Fleming, Intel Open Source Technology Center
