Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964772Ab3BFU3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:29:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36384 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab3BFU3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:29:40 -0500
Date: Wed, 6 Feb 2013 12:29:21 -0800
From: tip-bot for Robert Richter <rric@kernel.org>
Message-ID: <tip-4dd4c2ae555d8a91e8c5bf1cd56807a35764436a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jolsa@redhat.com, jacob.shin@amd.com,
        tglx@linutronix.de, rric@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, jolsa@redhat.com,
        jacob.shin@amd.com, tglx@linutronix.de, rric@kernel.org
In-Reply-To: <1360171589-6381-3-git-send-email-jacob.shin@amd.com>
References: <1360171589-6381-3-git-send-email-jacob.shin@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/amd:
  Generalize northbridge constraints code for family 15h
Git-Commit-ID: 4dd4c2ae555d8a91e8c5bf1cd56807a35764436a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 12:29:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4dd4c2ae555d8a91e8c5bf1cd56807a35764436a
Gitweb:     http://git.kernel.org/tip/4dd4c2ae555d8a91e8c5bf1cd56807a35764436a
Author:     Robert Richter <rric@kernel.org>
AuthorDate: Wed, 6 Feb 2013 11:26:25 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Feb 2013 19:45:23 +0100

perf/x86/amd: Generalize northbridge constraints code for family 15h

Generalize northbridge constraints code for family 10h so that
later we can reuse the same code path with other AMD processor
families that have the same northbridge event constraints.

Signed-off-by: Robert Richter <rric@kernel.org>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1360171589-6381-3-git-send-email-jacob.shin@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd.c | 43 +++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index e7963c7..f8c9dfb 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -188,20 +188,13 @@ static inline int amd_has_nb(struct cpu_hw_events *cpuc)
 	return nb && nb->nb_id != -1;
 }
 
-static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
-				      struct perf_event *event)
+static void __amd_put_nb_event_constraints(struct cpu_hw_events *cpuc,
+					   struct perf_event *event)
 {
-	struct hw_perf_event *hwc = &event->hw;
 	struct amd_nb *nb = cpuc->amd_nb;
 	int i;
 
 	/*
-	 * only care about NB events
-	 */
-	if (!(amd_has_nb(cpuc) && amd_is_nb_event(hwc)))
-		return;
-
-	/*
 	 * need to scan whole list because event may not have
 	 * been assigned during scheduling
 	 *
@@ -247,12 +240,13 @@ static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
   *
   * Given that resources are allocated (cmpxchg), they must be
   * eventually freed for others to use. This is accomplished by
-  * calling amd_put_event_constraints().
+  * calling __amd_put_nb_event_constraints()
   *
   * Non NB events are not impacted by this restriction.
   */
 static struct event_constraint *
-amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+__amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event,
+			       struct event_constraint *c)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct amd_nb *nb = cpuc->amd_nb;
@@ -260,12 +254,6 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	int idx, new = -1;
 
 	/*
-	 * if not NB event or no NB, then no constraints
-	 */
-	if (!(amd_has_nb(cpuc) && amd_is_nb_event(hwc)))
-		return &unconstrained;
-
-	/*
 	 * detect if already present, if so reuse
 	 *
 	 * cannot merge with actual allocation
@@ -275,7 +263,7 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	 * because of successive calls to x86_schedule_events() from
 	 * hw_perf_group_sched_in() without hw_perf_enable()
 	 */
-	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+	for_each_set_bit(idx, c->idxmsk, x86_pmu.num_counters) {
 		if (new == -1 || hwc->idx == idx)
 			/* assign free slot, prefer hwc->idx */
 			old = cmpxchg(nb->owners + idx, NULL, event);
@@ -391,6 +379,25 @@ static void amd_pmu_cpu_dead(int cpu)
 	}
 }
 
+static struct event_constraint *
+amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	/*
+	 * if not NB event or no NB, then no constraints
+	 */
+	if (!(amd_has_nb(cpuc) && amd_is_nb_event(&event->hw)))
+		return &unconstrained;
+
+	return __amd_get_nb_event_constraints(cpuc, event, &unconstrained);
+}
+
+static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
+				      struct perf_event *event)
+{
+	if (amd_has_nb(cpuc) && amd_is_nb_event(&event->hw))
+		__amd_put_nb_event_constraints(cpuc, event);
+}
+
 PMU_FORMAT_ATTR(event,	"config:0-7,32-35");
 PMU_FORMAT_ATTR(umask,	"config:8-15"	);
 PMU_FORMAT_ATTR(edge,	"config:18"	);
