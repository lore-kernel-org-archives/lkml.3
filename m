Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaFSMiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:38:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57596 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbaFSMit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:38:49 -0400
Date: Thu, 19 Jun 2014 05:37:41 -0700
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-1b92722fafe2003e49ec904f33c0020ade36bd16@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, james.hogan@imgtec.com, peterz@infradead.org,
        acme@kernel.org, vincent.weaver@maine.edu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, james.hogan@imgtec.com,
        peterz@infradead.org, acme@kernel.org, vincent.weaver@maine.edu,
        tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.10.1406150202050.16738@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1406150202050.16738@vincent-weaver-1.umelst.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] metag, perf:
  Use common PMU interrupt disabled code
Git-Commit-ID: 1b92722fafe2003e49ec904f33c0020ade36bd16
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b92722fafe2003e49ec904f33c0020ade36bd16
Gitweb:     http://git.kernel.org/tip/1b92722fafe2003e49ec904f33c0020ade36bd16
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Sun, 15 Jun 2014 02:03:13 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 18 Jun 2014 18:43:45 +0200

metag, perf: Use common PMU interrupt disabled code

Transition to using the new generic PERF_PMU_CAP_NO_INTERRUPT method for
failing a sampling event when no PMU interrupt is available.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Acked-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linux-metag@vger.kernel.org
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1406150202050.16738@vincent-weaver-1.umelst.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/metag/kernel/perf/perf_event.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

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
