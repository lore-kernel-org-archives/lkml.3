Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaKKOvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:51:08 -0500
Received: from mga14.intel.com ([192.55.52.115]:63225 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaKKOvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:51:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="620586686"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        acme@infradead.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v7 04/14] perf: Add a capability for AUX_NO_SG pmus to do software double buffering
Date: Tue, 11 Nov 2014 16:48:18 +0200
Message-Id: <1415717308-209223-5-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415717308-209223-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1415717308-209223-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For pmus that don't support scatter-gather for AUX data in hardware, it
might still make sense to implement software double buffering to avoid
losing data while the user is reading data out. For this purpose, add
a pmu capability that guarantees multiple high-order chunks for AUX buffer,
so that the pmu driver can do switchover tricks.

To make use of this feature, add PERF_PMU_CAP_AUX_SW_DOUBLEBUF to your
pmu's capability mask. This will make the ring buffer AUX allocation code
ensure that the biggest high order allocation for the aux buffer pages is
no bigger than half of the total requested buffer size, thus making sure
that the buffer has at least two high order allocations.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/linux/perf_event.h  |  1 +
 kernel/events/ring_buffer.c | 15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 71df948b4d..e7a15f5c3f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -172,6 +172,7 @@ struct perf_event;
  */
 #define PERF_PMU_CAP_NO_INTERRUPT		0x01
 #define PERF_PMU_CAP_AUX_NO_SG			0x02
+#define PERF_PMU_CAP_AUX_SW_DOUBLEBUF		0x04
 
 /**
  * struct pmu - generic performance monitoring unit
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index ae49a9bd11..1b4b593a32 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -286,9 +286,22 @@ int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
 	if (!has_aux(event))
 		return -ENOTSUPP;
 
-	if (event->pmu->capabilities & PERF_PMU_CAP_AUX_NO_SG)
+	if (event->pmu->capabilities & PERF_PMU_CAP_AUX_NO_SG) {
 		max_order = get_order(nr_pages * PAGE_SIZE);
 
+		/*
+		 * PMU requests more than one contiguous chunks of memory
+		 * for SW double buffering
+		 */
+		if ((event->pmu->capabilities & PERF_PMU_CAP_AUX_SW_DOUBLEBUF) &&
+		    !overwrite) {
+			if (!max_order)
+				return -EINVAL;
+
+			max_order--;
+		}
+	}
+
 	rb->aux_pages = kzalloc_node(nr_pages * sizeof(void *), GFP_KERNEL, node);
 	if (!rb->aux_pages)
 		return -ENOMEM;
-- 
2.1.1

