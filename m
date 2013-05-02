Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab3EBHzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:55:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56932 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3EBHzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:55:14 -0400
Date: Thu, 2 May 2013 00:54:28 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-5919b30933d7c4fac1f214c59f26c5e990044f09@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jstancek@redhat.com, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, jstancek@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <20130319143509.GA1128@krava.brq.redhat.com>
References: <20130319143509.GA1128@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix vmalloc ring buffer pages handling
Git-Commit-ID: 5919b30933d7c4fac1f214c59f26c5e990044f09
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

Commit-ID:  5919b30933d7c4fac1f214c59f26c5e990044f09
Gitweb:     http://git.kernel.org/tip/5919b30933d7c4fac1f214c59f26c5e990044f09
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 19 Mar 2013 15:35:09 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 1 May 2013 12:34:46 +0200

perf: Fix vmalloc ring buffer pages handling

If we allocate perf ring buffer with the size of single (user)
page, we will get memory corruption when releasing itin
rb_free_work function (for CONFIG_PERF_USE_VMALLOC option).

For single page sized ring buffer the page_order is -1 (because
nr_pages is 0). This needs to be recognized in the rb_free_work
function to release proper amount of pages.

Adding data_page_nr function that returns number of allocated
data pages. Customizing the rest of the code to use it.

Reported-by: Jan Stancek <jstancek@redhat.com>
Original-patch-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/20130319143509.GA1128@krava.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/ring_buffer.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 97fddb0..cd55144 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -326,11 +326,16 @@ void rb_free(struct ring_buffer *rb)
 }
 
 #else
+static int data_page_nr(struct ring_buffer *rb)
+{
+	return rb->nr_pages << page_order(rb);
+}
 
 struct page *
 perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
 {
-	if (pgoff > (1UL << page_order(rb)))
+	/* The '>' counts in the user page. */
+	if (pgoff > data_page_nr(rb))
 		return NULL;
 
 	return vmalloc_to_page((void *)rb->user_page + pgoff * PAGE_SIZE);
@@ -350,10 +355,11 @@ static void rb_free_work(struct work_struct *work)
 	int i, nr;
 
 	rb = container_of(work, struct ring_buffer, work);
-	nr = 1 << page_order(rb);
+	nr = data_page_nr(rb);
 
 	base = rb->user_page;
-	for (i = 0; i < nr + 1; i++)
+	/* The '<=' counts in the user page. */
+	for (i = 0; i <= nr; i++)
 		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
 
 	vfree(base);
@@ -387,7 +393,7 @@ struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
 	rb->user_page = all_buf;
 	rb->data_pages[0] = all_buf + PAGE_SIZE;
 	rb->page_order = ilog2(nr_pages);
-	rb->nr_pages = 1;
+	rb->nr_pages = !!nr_pages;
 
 	ring_buffer_init(rb, watermark, flags);
 
