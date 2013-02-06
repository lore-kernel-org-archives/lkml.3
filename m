Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab3BFR0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:26:49 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:52915
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755952Ab3BFR0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:26:36 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
X-WSS-ID: 0MHT744-02-2SD-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        <linux-kernel@vger.kernel.org>, Robert Richter <rric@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 2/6] perf, amd: Generalize northbridge constraints code for family 15h
Date: Wed, 6 Feb 2013 11:26:25 -0600
Message-ID: <1360171589-6381-3-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360171589-6381-1-git-send-email-jacob.shin@amd.com>
References: <1360171589-6381-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <rric@kernel.org>

Generalize northbridge constraints code for family 10h so that later
we can reuse the same code path with other AMD processor families that
have the same northbridge event constraints.

Signed-off-by: Robert Richter <rric@kernel.org>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd.c |   43 ++++++++++++++++++++--------------
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
-- 
1.7.9.5


