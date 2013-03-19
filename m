Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab3CSOfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:35:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134Ab3CSOfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:35:44 -0400
Date: Tue, 19 Mar 2013 15:35:09 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCHv4] perf: Fix vmalloc ring buffer pages handling
Message-ID: <20130319143509.GA1128@krava.brq.redhat.com>
References: <20130312100502.GC1348@krava.brq.redhat.com>
 <1363084030.14933.23.camel@laptop>
 <20130312135219.GA32001@krava.brq.redhat.com>
 <1363101972.24558.3.camel@laptop>
 <20130312153609.GC32001@krava.brq.redhat.com>
 <1363105490.24558.12.camel@laptop>
 <20130312170416.GD32001@krava.brq.redhat.com>
 <20130313111557.GC1064@krava.brq.redhat.com>
 <20130318190548.GA18920@krava.brq.redhat.com>
 <1363693618.22553.33.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363693618.22553.33.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 12:46:58PM +0100, Peter Zijlstra wrote:
> 
> > are you going to include that, or should I repost it?
> 
> Ah, please repost (and prettify) it, I'm still very limited in the
> amount of work that I can do :/
> 

ok, attached

jirka

---
If we allocate perf ring buffer with the size of single (user)
page, we will get memory corruption when releasing itin rb_free_work
function (for CONFIG_PERF_USE_VMALLOC option).

For single page sized ring buffer the page_order is -1 (because
nr_pages is 0). This needs to be recognized in the rb_free_work
function to release proper amount of pages.

Adding data_page_nr function that returns number of allocated
data pages. Customizing the rest of the code to use it.

Reported-by: Jan Stancek <jstancek@redhat.com>
Original-patch-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/events/ring_buffer.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 23cb34f..27a1af4 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -312,11 +312,16 @@ void rb_free(struct ring_buffer *rb)
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
@@ -336,10 +341,11 @@ static void rb_free_work(struct work_struct *work)
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
@@ -373,7 +379,7 @@ struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
 	rb->user_page = all_buf;
 	rb->data_pages[0] = all_buf + PAGE_SIZE;
 	rb->page_order = ilog2(nr_pages);
-	rb->nr_pages = 1;
+	rb->nr_pages = !!nr_pages;
 
 	ring_buffer_init(rb, watermark, flags);
 
-- 
1.7.11.7

