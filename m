Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbaFKPq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:46:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:61109 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761AbaFKPq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:46:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,458,1400050800"; 
   d="scan'208";a="526892959"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [RFC v2 4/7] perf: add a capability for AUX_NO_SG pmus to do software double buffering
Date: Wed, 11 Jun 2014 18:41:47 +0300
Message-Id: <1402501310-31940-5-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1402501310-31940-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1402501310-31940-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For pmus that don't support scatter-gather for AUX data in hardware, it
might still make sense to implement software double buffering to avoid
losing data while the user is reading data out. For this purpose, add
a pmu capability that guarantees multiple high-order chunks for AUX buffer,
so that the pmu driver can do switchover tricks.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/linux/perf_event.h  |  1 +
 kernel/events/ring_buffer.c | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index b316971..3d68411 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -276,6 +276,7 @@ struct pmu {
  */
 #define PERF_PMU_CAP_NO_INTERRUPT	1
 #define PERF_PMU_CAP_AUX_NO_SG		2
+#define PERF_PMU_CAP_AUX_SW_DOUBLEBUF	4
 
 /**
  * enum perf_event_active_state - the states of a event
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index e66ed76..43571ac 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -286,9 +286,21 @@ int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
 	if (!has_aux(event))
 		return -ENOTSUPP;
 
-	if (event->pmu->capabilities & PERF_PMU_CAP_AUX_NO_SG)
+	if (event->pmu->capabilities & PERF_PMU_CAP_AUX_NO_SG) {
 		order = get_order(nr_pages * PAGE_SIZE);
 
+		/*
+		 * PMU requests more than one contiguous chunks of memory
+		 * for SW double buffering
+		 */
+		if (event->pmu->capabilities & PERF_PMU_CAP_AUX_SW_DOUBLEBUF) {
+			if (!order)
+				return -EINVAL;
+
+			order--;
+		}
+	}
+
 	rb->aux_pages = kzalloc_node(nr_pages * sizeof(void *), GFP_KERNEL, node);
 	if (!rb->aux_pages)
 		return -ENOMEM;
-- 
2.0.0

