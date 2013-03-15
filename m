Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab3CONpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:45:45 -0400
Received: from multi.imgtec.com ([194.200.65.239]:34595 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab3CONof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:44:35 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 5/9] metag: perf: fix frequency sampling (dynamic period)
Date: Fri, 15 Mar 2013 13:43:44 +0000
Message-ID: <1363355028-23278-6-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
References: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_15_13_44_33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frequency sampling mode dynamically adjusts the sample period so as to
hit a particular frequency of samples. The sample period starts at just
1 and then gets increased if the interrupt rate is too high. This
changed sample period needs handling in metag_pmu_event_set_period to
update period_left (as the ARM equivalent does). The calculated delta
also needs subtracting from period_left in metag_pmu_event_update in
order to hit the conditional blocks in metag_pmu_event_set_period which
update last_period (which is used in the dynamic sampling period
calculation).

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 arch/metag/kernel/perf/perf_event.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/metag/kernel/perf/perf_event.c b/arch/metag/kernel/perf/perf_event.c
index 5bf984f..6210126 100644
--- a/arch/metag/kernel/perf/perf_event.c
+++ b/arch/metag/kernel/perf/perf_event.c
@@ -214,6 +214,7 @@ again:
 	delta = (new_raw_count - prev_raw_count) & MAX_PERIOD;
 
 	local64_add(delta, &event->count);
+	local64_sub(delta, &hwc->period_left);
 }
 
 int metag_pmu_event_set_period(struct perf_event *event,
@@ -223,6 +224,10 @@ int metag_pmu_event_set_period(struct perf_event *event,
 	s64 period = hwc->sample_period;
 	int ret = 0;
 
+	/* The period may have been changed */
+	if (unlikely(period != hwc->last_period))
+		left += period - hwc->last_period;
+
 	if (unlikely(left <= -period)) {
 		left = period;
 		local64_set(&hwc->period_left, left);
-- 
1.8.1.2


