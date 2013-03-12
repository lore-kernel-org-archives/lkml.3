Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab3CLK1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:27:36 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44192
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932115Ab3CLK1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:27:34 -0400
Message-ID: <1363084030.14933.23.camel@laptop>
Subject: Re: [PATCHv3] perf: Fix vmalloc ring buffer free function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 12 Mar 2013 11:27:10 +0100
In-Reply-To: <20130312100502.GC1348@krava.brq.redhat.com>
References: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
	 <1362994843.10972.40.camel@laptop>
	 <20130311112105.GA9737@krava.brq.redhat.com>
	 <1363019193.14933.14.camel@laptop>
	 <20130311164309.GG13679@krava.brq.redhat.com>
	 <1363023885.14933.16.camel@laptop>
	 <20130311180229.GI13679@krava.brq.redhat.com>
	 <20130312100502.GC1348@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-12 at 11:05 +0100, Jiri Olsa wrote:
> +/*
> + * Returns the total number of pages allocated
> + * by ring buffer including the user page.
> + */
> +static int page_nr(struct ring_buffer *rb)
> +{
> +       return page_order(rb) == -1 ?
> +               1 :                        /* no data, just user page */
> +               1 + (1 << page_order(rb)); /* user page + data pages */
> +}

> @@ -371,9 +381,24 @@ struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
>                 goto fail_all_buf;
>  
>         rb->user_page = all_buf;
> -       rb->data_pages[0] = all_buf + PAGE_SIZE;
> -       rb->page_order = ilog2(nr_pages);
> -       rb->nr_pages = 1;

> +
> +       rb->data_pages[0] = nr_pages ? all_buf + PAGE_SIZE : NULL;
> +       rb->nr_pages      = nr_pages ? 1 : 0;
> +       rb->page_order    = ilog2(nr_pages);
>  
>         ring_buffer_init(rb, watermark, flags);

Still somewhat confused by this.. wouldn't something 'simple' like the
below suffice?

Note how the !vmalloc branch also sets rb->nr_pages = nr_pages.

---
 kernel/events/ring_buffer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 23cb34f..4f48d02 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -316,7 +316,7 @@ void rb_free(struct ring_buffer *rb)
 struct page *
 perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
 {
-	if (pgoff > (1UL << page_order(rb)))
+	if (pgoff > rb->nr_pages)
 		return NULL;
 
 	return vmalloc_to_page((void *)rb->user_page + pgoff * PAGE_SIZE);
@@ -336,7 +336,7 @@ static void rb_free_work(struct work_struct *work)
 	int i, nr;
 
 	rb = container_of(work, struct ring_buffer, work);
-	nr = 1 << page_order(rb);
+	nr = rb->nr_pages;
 
 	base = rb->user_page;
 	for (i = 0; i < nr + 1; i++)
@@ -373,7 +373,7 @@ struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
 	rb->user_page = all_buf;
 	rb->data_pages[0] = all_buf + PAGE_SIZE;
 	rb->page_order = ilog2(nr_pages);
-	rb->nr_pages = 1;
+	rb->nr_pages = nr_pages;
 
 	ring_buffer_init(rb, watermark, flags);
 


