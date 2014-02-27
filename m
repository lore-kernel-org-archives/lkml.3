Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaB0Vbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:31:42 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57635 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbaB0Vbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:31:38 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>, scottwood@freescale.com,
        Peter Zijlstra <peterz@infradead.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v3 03/11] perf: provide a common perf_event_nop_0() for use with .event_idx
Date: Thu, 27 Feb 2014 13:04:56 -0800
Message-Id: <1393535105-7528-4-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393535105-7528-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1393535105-7528-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022721-0320-0000-0000-0000029120F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather an having every pmu that needs a function that just returns 0 for
.event_idx define their own copy, reuse the one in kernel/events/core.c.

Rename from perf_swevent_event_idx() because we're no longer using it
for just software events. Naming is based on the perf_pmu_nop_*()
functions.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/perf_event.h |  1 +
 kernel/events/core.c       | 10 +++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3da5081..24a7b45 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -560,6 +560,7 @@ extern void perf_pmu_migrate_context(struct pmu *pmu,
 extern u64 perf_event_read_value(struct perf_event *event,
 				 u64 *enabled, u64 *running);
 
+extern int perf_event_nop_0(struct perf_event *event);
 
 struct perf_sample_data {
 	u64				type;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 56003c6..2938a77 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5816,7 +5816,7 @@ static int perf_swevent_init(struct perf_event *event)
 	return 0;
 }
 
-static int perf_swevent_event_idx(struct perf_event *event)
+int perf_event_nop_0(struct perf_event *event)
 {
 	return 0;
 }
@@ -5831,7 +5831,7 @@ static struct pmu perf_swevent = {
 	.stop		= perf_swevent_stop,
 	.read		= perf_swevent_read,
 
-	.event_idx	= perf_swevent_event_idx,
+	.event_idx	= perf_event_nop_0,
 };
 
 #ifdef CONFIG_EVENT_TRACING
@@ -5950,7 +5950,7 @@ static struct pmu perf_tracepoint = {
 	.stop		= perf_swevent_stop,
 	.read		= perf_swevent_read,
 
-	.event_idx	= perf_swevent_event_idx,
+	.event_idx	= perf_event_nop_0,
 };
 
 static inline void perf_tp_register(void)
@@ -6177,7 +6177,7 @@ static struct pmu perf_cpu_clock = {
 	.stop		= cpu_clock_event_stop,
 	.read		= cpu_clock_event_read,
 
-	.event_idx	= perf_swevent_event_idx,
+	.event_idx	= perf_event_nop_0,
 };
 
 /*
@@ -6257,7 +6257,7 @@ static struct pmu perf_task_clock = {
 	.stop		= task_clock_event_stop,
 	.read		= task_clock_event_read,
 
-	.event_idx	= perf_swevent_event_idx,
+	.event_idx	= perf_event_nop_0,
 };
 
 static void perf_pmu_nop_void(struct pmu *pmu)
-- 
1.9.0

