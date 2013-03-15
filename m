Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab3CONpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:45:47 -0400
Received: from multi.imgtec.com ([194.200.65.239]:34593 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268Ab3CONof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:44:35 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 4/9] metag: perf: add missing prev_count updates
Date: Fri, 15 Mar 2013 13:43:43 +0000
Message-ID: <1363355028-23278-5-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
References: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_15_13_44_32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prev_count needs setting when changing the counter value, otherwise
the calculated delta will be wrong, which for frequency sampling
(dynamic period sampling) results in sampling at too high a frequency.

For non-interrupting performance counters it should also be cleared when
enabling the counter since the write to the PERF_COUNT register will
clear the perf counter.

This also includes a minor change to remove the u64 cast from the
metag_pmu->write() call as metag_pmu->write() takes a u32 anyway, and in
any case GCC is smart enough to optimise away the cast.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 arch/metag/kernel/perf/perf_event.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/metag/kernel/perf/perf_event.c b/arch/metag/kernel/perf/perf_event.c
index a00f527..5bf984f 100644
--- a/arch/metag/kernel/perf/perf_event.c
+++ b/arch/metag/kernel/perf/perf_event.c
@@ -240,8 +240,10 @@ int metag_pmu_event_set_period(struct perf_event *event,
 	if (left > (s64)metag_pmu->max_period)
 		left = metag_pmu->max_period;
 
-	if (metag_pmu->write)
-		metag_pmu->write(idx, (u64)(-left) & MAX_PERIOD);
+	if (metag_pmu->write) {
+		local64_set(&hwc->prev_count, -(s32)left);
+		metag_pmu->write(idx, -left & MAX_PERIOD);
+	}
 
 	perf_event_update_userpage(event);
 
@@ -651,6 +653,12 @@ static void metag_pmu_enable_counter(struct hw_perf_event *event, int idx)
 		 * set to a specific value that needs preserving.
 		 */
 		tmp |= metag_in32(PERF_COUNT(idx)) & 0x00ffffff;
+	else
+		/*
+		 * Older cores reset the counter on write, so prev_count needs
+		 * resetting too so we can calculate a correct delta.
+		 */
+		local64_set(&event->prev_count, 0);
 
 	metag_out32(tmp, PERF_COUNT(idx));
 unlock:
-- 
1.8.1.2


