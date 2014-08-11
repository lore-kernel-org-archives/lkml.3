Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaHKF1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:27:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:19558 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbaHKF13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:27:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="scan'208";a="467285499"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v3 04/23] perf: Add a capability for AUX_NO_SG pmus to do software double buffering
Date: Mon, 11 Aug 2014 08:19:33 +0300
Message-Id: <1407734392-31097-5-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
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
 kernel/events/ring_buffer.c | 15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 4d9ede200f..71be27169c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -171,6 +171,7 @@ struct perf_event;
  */
 #define PERF_PMU_CAP_NO_INTERRUPT		0x01
 #define PERF_PMU_CAP_AUX_NO_SG			0x02
+#define PERF_PMU_CAP_AUX_SW_DOUBLEBUF		0x04
 
 /**
  * struct pmu - generic performance monitoring unit
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index d10919ca42..f5ee3669f8 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -286,9 +286,22 @@ int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
 	if (!has_aux(event))
 		return -ENOTSUPP;
 
-	if (event->pmu->capabilities & PERF_PMU_CAP_AUX_NO_SG)
+	if (event->pmu->capabilities & PERF_PMU_CAP_AUX_NO_SG) {
 		order = get_order(nr_pages * PAGE_SIZE);
 
+		/*
+		 * PMU requests more than one contiguous chunks of memory
+		 * for SW double buffering
+		 */
+		if ((event->pmu->capabilities & PERF_PMU_CAP_AUX_SW_DOUBLEBUF) &&
+		    !overwrite) {
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
2.1.0.rc1

