Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaFOF6l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 01:58:41 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:33120 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbaFOF6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 01:58:39 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Sun, 15 Jun 2014 02:03:13 -0400 (EDT)
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 3/6] metag,perf: Use common PMU interrupt disabled code
Message-ID: <alpine.DEB.2.10.1406150202050.16738@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Transition to using the new generic PERF_PMU_CAP_NO_INTERRUPT method for
failing a sampling event when no PMU interrupt is available.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/arch/metag/kernel/perf/perf_event.c b/arch/metag/kernel/perf/perf_event.c
index 5cc4d4d..02c0873 100644
--- a/arch/metag/kernel/perf/perf_event.c
+++ b/arch/metag/kernel/perf/perf_event.c
@@ -568,16 +568,6 @@ static int _hw_perf_event_init(struct perf_event *event)
 		return -EINVAL;
 
 	/*
-	 * Early cores have "limited" counters - they have no overflow
-	 * interrupts - and so are unable to do sampling without extra work
-	 * and timer assistance.
-	 */
-	if (metag_pmu->max_period == 0) {
-		if (hwc->sample_period)
-			return -EINVAL;
-	}
-
-	/*
 	 * Don't assign an index until the event is placed into the hardware.
 	 * -1 signifies that we're still deciding where to put it. On SMP
 	 * systems each core has its own set of counters, so we can't do any
@@ -866,6 +856,15 @@ static int __init init_hw_perf_events(void)
 	pr_info("enabled with %s PMU driver, %d counters available\n",
 			metag_pmu->name, metag_pmu->max_events);
 
+	/*
+	 * Early cores have "limited" counters - they have no overflow
+	 * interrupts - and so are unable to do sampling without extra work
+	 * and timer assistance.
+	 */
+	if (metag_pmu->max_period == 0) {
+		metag_pmu->pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+	}
+
 	/* Initialise the active events and reservation mutex */
 	atomic_set(&metag_pmu->active_events, 0);
 	mutex_init(&metag_pmu->reserve_mutex);
