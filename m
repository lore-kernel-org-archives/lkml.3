Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaEUOCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:02:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:4788 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbaEUOCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:02:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,880,1392192000"; 
   d="scan'208";a="535464342"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC 2/2] perf: add AUX area to ring buffer for raw data streams
In-Reply-To: <20140520095102.GV2485@laptop.programming.kicks-ass.net>
References: <1400166510-9234-1-git-send-email-alexander.shishkin@linux.intel.com> <1400166510-9234-3-git-send-email-alexander.shishkin@linux.intel.com> <20140519085854.GW30445@twins.programming.kicks-ass.net> <87bnuuylha.fsf@ashishki-desk.ger.corp.intel.com> <20140520095102.GV2485@laptop.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 21 May 2014 17:02:10 +0300
Message-ID: <8761kzz0v1.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Mon, May 19, 2014 at 03:57:37PM +0300, Alexander Shishkin wrote:
>> Peter Zijlstra <peterz@infradead.org> writes:
>
>> > I'm not entirely thrilled to expose it to the PMU like this.. I realize
>> > you want this in order to get physically contiguous pages.
>> 
>> Hmm, I guess we can have code in perf core to carry out the allocation
>> according to, say, contstraint flags and pass the page array down to the
>> PMU if that sounds like a cleaner thing to do?
>> 
>> > Are you aware of allocation constraints for other architectures?
>> 
>> Somewhat. ARM's trace memory controller supports both scatter-gather and
>> a plain contiguous buffer, I haven't found evidence of one being
>> available while the other one isn't, so I'm inclined to assume that if
>> it can write to system memory, it supports SG.
>
> I've just added a patch from Vince Weaver:
>
>   http://lkml.kernel.org/r/alpine.DEB.2.10.1405161708060.11099@vincent-weaver-1.umelst.maine.edu
>
> That adds pmu::capabilities, I suppose we could start with something
> like:
>
>   PERF_PMU_CAP_AUX_BROKEN_SG
>
> which would make the allocator attempt to fill the AUX buffer with as
> big a chunks of contiguous memory as is available.

Ok, how about this (on top of the previous patch):

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 9643450..e2a6b6b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -278,15 +278,15 @@ struct pmu {
 	void (*flush_branch_stack)	(void);
 
 	/*
-	 * Allocate AUX space buffer: return an array of @nr_pages pages to be
-	 * mapped to userspace that will also be passed to ->free_aux.
+	 * Set up pmu-private data structures for an AUX area
 	 */
-	void *(*alloc_aux)		(int cpu, int nr_pages, bool overwrite,
+	void *(*setup_aux)		(int cpu, void **pages,
+					 int nr_pages, bool overwrite,
 					 struct perf_event_mmap_page *user_page);
 					/* optional */
 
 	/*
-	 * Free AUX buffer
+	 * Free pmu-private AUX data structures
 	 */
 	void (*free_aux)		(void *aux); /* optional */
 
@@ -300,6 +300,7 @@ struct pmu {
  * struct pmu::capabilities flags
  */
 #define PERF_PMU_CAP_NO_INTERRUPT	1
+#define PERF_PMU_CAP_AUX_BROKEN_SG	2
 
 /**
  * enum perf_event_active_state - the states of a event
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index ea51cfb..a06d7fe 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -41,6 +41,7 @@ struct ring_buffer {
 	atomic_t			aux_mmap_count;
 	unsigned long			aux_mmap_locked;
 	void				**aux_pages;
+	void				*aux_priv;
 	void				(*free_aux)(void *aux);
 
 	struct perf_event_mmap_page	*user_page;
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 5935cb2..7f166f2 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -244,32 +244,96 @@ ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
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
 	bool overwrite = !!(flags & RING_BUFFER_WRITABLE);
+	int pg, node = (event->cpu == -1) ? -1 : cpu_to_node(event->cpu);
+	int order = 0;
 
-	if (!event->pmu->alloc_aux)
+	if (!event->pmu->setup_aux)
 		return -ENOTSUPP;
 
-	rb->aux_pages = event->pmu->alloc_aux(event->cpu, nr_pages, overwrite,
-					      rb->user_page);
+	if (event->pmu->capabilities & PERF_PMU_CAP_AUX_BROKEN_SG)
+		order = get_order(nr_pages * PAGE_SIZE);
+
+	rb->aux_pages = kzalloc_node(nr_pages * sizeof(void *), GFP_KERNEL, node);
 	if (!rb->aux_pages)
 		return -ENOMEM;
 
+	for (pg = 0; pg < nr_pages;) {
+		struct page *page;
+		int last;
+
+		page = rb_alloc_aux_page(node, order);
+		if (!page)
+			goto err;
+
+		for (last = pg + (1 << page_private(page)); pg < last; pg++)
+			rb->aux_pages[pg] = page_address(page++);
+	}
+
+	rb->aux_priv = event->pmu->setup_aux(event->cpu, rb->aux_pages, nr_pages,
+					     overwrite, rb->user_page);
+	if (!rb->aux_priv) {
+		rb_free_aux(rb);
+		return -EINVAL;
+	}
+
 	rb->free_aux = event->pmu->free_aux;
 	rb->aux_pgoff = pgoff;
 	rb->aux_nr_pages = nr_pages;
 
 	return 0;
+err:
+	for (; pg >= 0; pg--)
+		rb_free_aux_page(rb, pg);
+
+	return -ENOMEM;
 }
 
 void rb_free_aux(struct ring_buffer *rb)
 {
-	if (WARN_ON_ONCE(!rb->free_aux))
-		return;
+	int pg;
+
+	for (pg = 0; pg < rb->aux_nr_pages; pg++)
+		rb_free_aux_page(rb, pg);
 
-	rb->free_aux(rb->aux_pages);
+	rb->free_aux(rb->aux_priv);
 	rb->aux_nr_pages = 0;
 }
 
>> > That appears to be missing a is_power_of_2(aux_size) check.
>> >
>> > The problem with not having that is that since
>> > perf_event_mmap_page::aux_{head,tail} are of Z mod 2^64 but your actual
>> > {head,tail} are of Z mod aux_size, you need aux_size to be a full
>> > divider of 2^64 or otherwise you get wrapping issues at the overflow.
>> >
>> > Having it them all 2^n makes the divider trivial.
>> 
>> I left it out so that the PMU callback could decide if it wants to do
>> the math or not. Maybe it can also be a constraint flag or is it not
>> worth it at all?
>
> I'd start with the most constrained model -- that is add the power of
> two test -- and worry about relaxing it if it turns out its really
> needed.

Makes sense, I'll put it back.

Regards,
--
Alex
