Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3CONrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:47:25 -0400
Received: from multi.imgtec.com ([194.200.65.239]:34595 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab3CONoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:44:34 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 3/9] metag: perf: fixes for interrupting perf counters
Date: Fri, 15 Mar 2013 13:43:42 +0000
Message-ID: <1363355028-23278-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
References: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_15_13_44_32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The overflow handler needs to read modify write when re-enabling the
counter so as not to change the counter value as it may have been
changed to ready the next interrupt on overflow. Similarly for
interrupting counters metag_pmu_enable_counter needs to leave the
counter value unchanged rather than resetting it to zero.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 arch/metag/kernel/perf/perf_event.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/metag/kernel/perf/perf_event.c b/arch/metag/kernel/perf/perf_event.c
index 8096db2..a00f527 100644
--- a/arch/metag/kernel/perf/perf_event.c
+++ b/arch/metag/kernel/perf/perf_event.c
@@ -643,13 +643,15 @@ static void metag_pmu_enable_counter(struct hw_perf_event *event, int idx)
 		config = tmp >> 4;
 	}
 
-	/*
-	 * Enabled counters start from 0. Early cores clear the count on
-	 * write but newer cores don't, so we make sure that the count is
-	 * set to 0.
-	 */
 	tmp = ((config & 0xf) << 28) |
 			((1 << 24) << cpu_2_hwthread_id[get_cpu()]);
+	if (metag_pmu->max_period)
+		/*
+		 * Cores supporting overflow interrupts may have had the counter
+		 * set to a specific value that needs preserving.
+		 */
+		tmp |= metag_in32(PERF_COUNT(idx)) & 0x00ffffff;
+
 	metag_out32(tmp, PERF_COUNT(idx));
 unlock:
 	raw_spin_unlock_irqrestore(&events->pmu_lock, flags);
@@ -764,10 +766,16 @@ static irqreturn_t metag_pmu_counter_overflow(int irq, void *dev)
 
 	/*
 	 * Enable the counter again once core overflow processing has
-	 * completed.
+	 * completed. Note the counter value may have been modified while it was
+	 * inactive to set it up ready for the next interrupt.
 	 */
-	if (!perf_event_overflow(event, &sampledata, regs))
+	if (!perf_event_overflow(event, &sampledata, regs)) {
+		__global_lock2(flags);
+		counter = (counter & 0xff000000) |
+			  (metag_in32(PERF_COUNT(idx)) & 0x00ffffff);
 		metag_out32(counter, PERF_COUNT(idx));
+		__global_unlock2(flags);
+	}
 
 	return IRQ_HANDLED;
 }
-- 
1.8.1.2


