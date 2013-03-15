Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab3CONoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:44:39 -0400
Received: from multi.imgtec.com ([194.200.65.239]:34593 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab3CONoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:44:37 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Robert Richter <rric@kernel.org>, <oprofile-list@lists.sf.net>
Subject: [PATCH 8/9] metag: perf: prepare for use by oprofile
Date: Fri, 15 Mar 2013 13:43:47 +0000
Message-ID: <1363355028-23278-9-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
References: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_15_13_44_35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To allow our perf_events code to work with oprofile the PERF_TYPE_RAW
event type attribute is implemented, which allows the internal encoding
of events to be used externally (this requires some tweaks so that it
handles invalid event types more gracefully), and perf_pmu_name() is
adjusted to return metag_pmu->name instead of metag_pmu->pmu.name (which
is changed to "meta2").

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Robert Richter <rric@kernel.org>
Cc: oprofile-list@lists.sf.net
---
 arch/metag/kernel/perf/perf_event.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/metag/kernel/perf/perf_event.c b/arch/metag/kernel/perf/perf_event.c
index a1eff36..3665694 100644
--- a/arch/metag/kernel/perf/perf_event.c
+++ b/arch/metag/kernel/perf/perf_event.c
@@ -40,10 +40,10 @@ static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
 /* PMU admin */
 const char *perf_pmu_name(void)
 {
-	if (metag_pmu)
-		return metag_pmu->pmu.name;
+	if (!metag_pmu)
+		return NULL;
 
-	return NULL;
+	return metag_pmu->name;
 }
 EXPORT_SYMBOL_GPL(perf_pmu_name);
 
@@ -171,6 +171,7 @@ static int metag_pmu_event_init(struct perf_event *event)
 	switch (event->attr.type) {
 	case PERF_TYPE_HARDWARE:
 	case PERF_TYPE_HW_CACHE:
+	case PERF_TYPE_RAW:
 		err = _hw_perf_event_init(event);
 		break;
 
@@ -556,6 +557,10 @@ static int _hw_perf_event_init(struct perf_event *event)
 		if (err)
 			return err;
 		break;
+
+	case PERF_TYPE_RAW:
+		mapping = attr->config;
+		break;
 	}
 
 	/* Return early if the event is unsupported */
@@ -623,7 +628,7 @@ static void metag_pmu_enable_counter(struct hw_perf_event *event, int idx)
 
 	/* Check for a core internal or performance channel event. */
 	if (tmp) {
-		void *perf_addr = (void *)PERF_COUNT(idx);
+		void *perf_addr;
 
 		/*
 		 * Anything other than a cycle count will write the low-
@@ -637,9 +642,14 @@ static void metag_pmu_enable_counter(struct hw_perf_event *event, int idx)
 		case 0xf0:
 			perf_addr = (void *)PERF_CHAN(idx);
 			break;
+
+		default:
+			perf_addr = NULL;
+			break;
 		}
 
-		metag_out32((config & 0x0f), perf_addr);
+		if (perf_addr)
+			metag_out32((config & 0x0f), perf_addr);
 
 		/*
 		 * Now we use the high nibble as the performance event to
@@ -848,7 +858,7 @@ static int __init init_hw_perf_events(void)
 			metag_pmu->max_period = 0;
 		}
 
-		metag_pmu->name = "Meta 2";
+		metag_pmu->name = "meta2";
 		metag_pmu->version = version;
 		metag_pmu->pmu = pmu;
 	}
-- 
1.8.1.2


