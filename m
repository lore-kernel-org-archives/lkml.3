Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab3BFU2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:28:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36366 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968Ab3BFU2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:28:46 -0500
Date: Wed, 6 Feb 2013 12:28:12 -0800
From: tip-bot for Robert Richter <rric@kernel.org>
Message-ID: <tip-2c53c3dd0b6497484b29fd49d34ef98acbc14577@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jolsa@redhat.com, jacob.shin@amd.com,
        tglx@linutronix.de, rric@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jolsa@redhat.com, jacob.shin@amd.com,
        tglx@linutronix.de, rric@kernel.org
In-Reply-To: <1360171589-6381-2-git-send-email-jacob.shin@amd.com>
References: <1360171589-6381-2-git-send-email-jacob.shin@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/amd:
  Rework northbridge event constraints handler
Git-Commit-ID: 2c53c3dd0b6497484b29fd49d34ef98acbc14577
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 12:28:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c53c3dd0b6497484b29fd49d34ef98acbc14577
Gitweb:     http://git.kernel.org/tip/2c53c3dd0b6497484b29fd49d34ef98acbc14577
Author:     Robert Richter <rric@kernel.org>
AuthorDate: Wed, 6 Feb 2013 11:26:24 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Feb 2013 19:45:22 +0100

perf/x86/amd: Rework northbridge event constraints handler

Code simplification. No functional changes.

Signed-off-by: Robert Richter <rric@kernel.org>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Acked-by: Stephane Eranian <eranian@google.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Robert Richter <rric@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1360171589-6381-2-git-send-email-jacob.shin@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd.c | 68 ++++++++++++++----------------------
 1 file changed, 26 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index c93bc4e..e7963c7 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -256,9 +256,8 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct amd_nb *nb = cpuc->amd_nb;
-	struct perf_event *old = NULL;
-	int max = x86_pmu.num_counters;
-	int i, j, k = -1;
+	struct perf_event *old;
+	int idx, new = -1;
 
 	/*
 	 * if not NB event or no NB, then no constraints
@@ -276,48 +275,33 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	 * because of successive calls to x86_schedule_events() from
 	 * hw_perf_group_sched_in() without hw_perf_enable()
 	 */
-	for (i = 0; i < max; i++) {
-		/*
-		 * keep track of first free slot
-		 */
-		if (k == -1 && !nb->owners[i])
-			k = i;
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		if (new == -1 || hwc->idx == idx)
+			/* assign free slot, prefer hwc->idx */
+			old = cmpxchg(nb->owners + idx, NULL, event);
+		else if (nb->owners[idx] == event)
+			/* event already present */
+			old = event;
+		else
+			continue;
+
+		if (old && old != event)
+			continue;
+
+		/* reassign to this slot */
+		if (new != -1)
+			cmpxchg(nb->owners + new, event, NULL);
+		new = idx;
 
 		/* already present, reuse */
-		if (nb->owners[i] == event)
-			goto done;
-	}
-	/*
-	 * not present, so grab a new slot
-	 * starting either at:
-	 */
-	if (hwc->idx != -1) {
-		/* previous assignment */
-		i = hwc->idx;
-	} else if (k != -1) {
-		/* start from free slot found */
-		i = k;
-	} else {
-		/*
-		 * event not found, no slot found in
-		 * first pass, try again from the
-		 * beginning
-		 */
-		i = 0;
-	}
-	j = i;
-	do {
-		old = cmpxchg(nb->owners+i, NULL, event);
-		if (!old)
+		if (old == event)
 			break;
-		if (++i == max)
-			i = 0;
-	} while (i != j);
-done:
-	if (!old)
-		return &nb->event_constraints[i];
-
-	return &emptyconstraint;
+	}
+
+	if (new == -1)
+		return &emptyconstraint;
+
+	return &nb->event_constraints[new];
 }
 
 static struct amd_nb *amd_alloc_nb(int cpu)
