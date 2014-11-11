Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaKKOwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:52:34 -0500
Received: from mga14.intel.com ([192.55.52.115]:63225 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaKKOu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:50:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="620586661"
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
Subject: [PATCH v7 03/14] perf: Support high-order allocations for AUX space
Date: Tue, 11 Nov 2014 16:48:17 +0200
Message-Id: <1415717308-209223-4-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415717308-209223-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1415717308-209223-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some pmus (such as BTS or Intel PT without multiple-entry ToPA capability)
don't support scatter-gather and will prefer larger contiguous areas for
their output regions.

This patch adds a new pmu capability to request higher order allocations.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/linux/perf_event.h  |  1 +
 kernel/events/ring_buffer.c | 53 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 48 insertions(+), 6 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 344058c71d..71df948b4d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -171,6 +171,7 @@ struct perf_event;
  * pmu::capabilities flags
  */
 #define PERF_PMU_CAP_NO_INTERRUPT		0x01
+#define PERF_PMU_CAP_AUX_NO_SG			0x02
 
 /**
  * struct pmu - generic performance monitoring unit
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index c6fdce4ea0..ae49a9bd11 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -242,30 +242,71 @@ ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
 	spin_lock_init(&rb->event_lock);
 }
 
+#define PERF_AUX_GFP	(GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN | __GFP_NORETRY)
+
+static struct page *rb_alloc_aux_page(int node, int order)
+{
+	struct page *page;
+
+	if (order > MAX_ORDER)
+		order = MAX_ORDER;
+
+	do {
+		page = alloc_pages_node(node, PERF_AUX_GFP, order);
+	} while (!page && order--);
+
+	if (page && order) {
+		/*
+		 * Communicate the allocation size to the driver
+		 */
+		split_page(page, order);
+		SetPagePrivate(page);
+		set_page_private(page, order);
+	}
+
+	return page;
+}
+
+static void rb_free_aux_page(struct ring_buffer *rb, int idx)
+{
+	struct page *page = virt_to_page(rb->aux_pages[idx]);
+
+	ClearPagePrivate(page);
+	page->mapping = NULL;
+	__free_page(page);
+}
+
 int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
 		 pgoff_t pgoff, int nr_pages, int flags)
 {
 	bool overwrite = !(flags & RING_BUFFER_WRITABLE);
 	int node = (event->cpu == -1) ? -1 : cpu_to_node(event->cpu);
-	int ret = -ENOMEM;
+	int ret = -ENOMEM, max_order = 0;
 
 	if (!has_aux(event))
 		return -ENOTSUPP;
 
+	if (event->pmu->capabilities & PERF_PMU_CAP_AUX_NO_SG)
+		max_order = get_order(nr_pages * PAGE_SIZE);
+
 	rb->aux_pages = kzalloc_node(nr_pages * sizeof(void *), GFP_KERNEL, node);
 	if (!rb->aux_pages)
 		return -ENOMEM;
 
 	rb->free_aux = event->pmu->free_aux;
-	for (rb->aux_nr_pages = 0; rb->aux_nr_pages < nr_pages;
-	     rb->aux_nr_pages++) {
+	for (rb->aux_nr_pages = 0; rb->aux_nr_pages < nr_pages;) {
 		struct page *page;
+		int last, order;
 
-		page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+		order = min(max_order,
+			    get_order((nr_pages - rb->aux_nr_pages) * PAGE_SIZE));
+		page = rb_alloc_aux_page(node, order);
 		if (!page)
 			goto out;
 
-		rb->aux_pages[rb->aux_nr_pages] = page_address(page);
+		for (last = rb->aux_nr_pages + (1 << page_private(page));
+		     last > rb->aux_nr_pages; rb->aux_nr_pages++)
+			rb->aux_pages[rb->aux_nr_pages] = page_address(page++);
 	}
 
 	rb->aux_priv = event->pmu->setup_aux(event->cpu, rb->aux_pages, nr_pages,
@@ -303,7 +344,7 @@ static void __rb_free_aux(struct ring_buffer *rb)
 	}
 
 	for (pg = 0; pg < rb->aux_nr_pages; pg++)
-		free_page((unsigned long)rb->aux_pages[pg]);
+		rb_free_aux_page(rb, pg);
 
 	kfree(rb->aux_pages);
 	rb->aux_nr_pages = 0;
-- 
2.1.1

