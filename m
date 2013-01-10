Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab3AJTvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:51:09 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:58550
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754758Ab3AJTvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:51:07 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(z551bizzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1155h)
X-WSS-ID: 0MGFDSX-02-364-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>, <linux-kernel@vger.kernel.org>,
        Robert Richter <rric@kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH RESEND V5 1/6] perf, amd: Rework northbridge event constraints handler
Date: Thu, 10 Jan 2013 13:50:37 -0600
Message-ID: <1357847443-3878-2-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357847443-3878-1-git-send-email-jacob.shin@amd.com>
References: <1357847443-3878-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <rric@kernel.org>

Code simplification. No functional changes.

Signed-off-by: Robert Richter <rric@kernel.org>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd.c |   68 +++++++++++++---------------------
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
-- 
1.7.9.5


