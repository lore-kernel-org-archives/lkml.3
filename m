Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab3CFOed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:34:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44223 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab3CFOe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:34:29 -0500
Date: Wed, 6 Mar 2013 06:30:30 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-12bc915ee149ac31d17c513edc7303660d024239@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, davem@davemloft.net,
        jstancek@redhat.com, jolsa@redhat.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, namhyung@kernel.org, jolsa@redhat.com,
        jstancek@redhat.com, davem@davemloft.net, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
References: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix vmalloc ring buffer free function
Git-Commit-ID: 12bc915ee149ac31d17c513edc7303660d024239
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Mar 2013 06:30:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12bc915ee149ac31d17c513edc7303660d024239
Gitweb:     http://git.kernel.org/tip/12bc915ee149ac31d17c513edc7303660d024239
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 1 Mar 2013 17:34:49 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Mar 2013 11:14:01 +0100

perf: Fix vmalloc ring buffer free function

If we allocate perf ring buffer with the size of single page,
we will get memory corruption when releasing it. It's caused
by rb_free_work function (CONFIG_PERF_USE_VMALLOC option).

For single page sized ring buffer the page_order is -1 (because
nr_pages is 0). This needs to be recognized in the rb_free_work
function to release proper amount of pages.

Introducing page_nr function (CONFIG_PERF_USE_VMALLOC only)
that returns number of allocated pages. Using it in rb_free_work
and perf_mmap_to_page functions.

Also setting rb->nr_pages to 0 in case we have only user page
allocated, which will fail perf_output_begin function and
prevents sample storage.

Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1362155689-13719-1-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/ring_buffer.c | 40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 23cb34f..a802151 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -154,7 +154,8 @@ int perf_output_begin(struct perf_output_handle *handle,
 	if (head - local_read(&rb->wakeup) > rb->watermark)
 		local_add(rb->watermark, &rb->wakeup);
 
-	handle->page = offset >> (PAGE_SHIFT + page_order(rb));
+	/* page is allways 0 for CONFIG_PERF_USE_VMALLOC option */
+	handle->page = offset >> PAGE_SHIFT;
 	handle->page &= rb->nr_pages - 1;
 	handle->size = offset & ((PAGE_SIZE << page_order(rb)) - 1);
 	handle->addr = rb->data_pages[handle->page];
@@ -312,11 +313,21 @@ void rb_free(struct ring_buffer *rb)
 }
 
 #else
+/*
+ * Returns the total number of pages allocated
+ * by ring buffer including the user page.
+ */
+static int page_nr(struct ring_buffer *rb)
+{
+	return page_order(rb) == -1 ?
+		1 :                        /* no data, just user page */
+		1 + (1 << page_order(rb)); /* user page + data pages */
+}
 
 struct page *
 perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
 {
-	if (pgoff > (1UL << page_order(rb)))
+	if (pgoff > page_nr(rb))
 		return NULL;
 
 	return vmalloc_to_page((void *)rb->user_page + pgoff * PAGE_SIZE);
@@ -336,10 +347,10 @@ static void rb_free_work(struct work_struct *work)
 	int i, nr;
 
 	rb = container_of(work, struct ring_buffer, work);
-	nr = 1 << page_order(rb);
+	nr = page_nr(rb);
 
 	base = rb->user_page;
-	for (i = 0; i < nr + 1; i++)
+	for (i = 0; i < nr; i++)
 		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
 
 	vfree(base);
@@ -371,9 +382,24 @@ struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
 		goto fail_all_buf;
 
 	rb->user_page = all_buf;
-	rb->data_pages[0] = all_buf + PAGE_SIZE;
-	rb->page_order = ilog2(nr_pages);
-	rb->nr_pages = 1;
+
+	/*
+	 * For special case nr_pages == 0 we have
+	 * only the user page mmaped plus:
+	 *
+	 *   rb->data_pages[0] = NULL
+	 *   rb->nr_pages      = 0
+	 *   rb->page_order    = -1
+	 *
+	 * The perf_output_begin function is guarded
+	 * by (rb->nr_pages > 0) condition, so no
+	 * output code touches above setup if we
+	 * have only user page allocated.
+	 */
+
+	rb->data_pages[0] = nr_pages ? all_buf + PAGE_SIZE : NULL;
+	rb->nr_pages      = nr_pages ? 1 : 0;
+	rb->page_order    = ilog2(nr_pages);
 
 	ring_buffer_init(rb, watermark, flags);
 
