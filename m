Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab3CKJlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:41:00 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37550
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402Ab3CKJk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:40:58 -0400
Message-ID: <1362994843.10972.40.camel@laptop>
Subject: Re: [PATCHv2] perf: Fix vmalloc ring buffer free function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 11 Mar 2013 10:40:43 +0100
In-Reply-To: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
References: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 17:34 +0100, Jiri Olsa wrote:
> If we allocate perf ring buffer with the size of single page,
> we will get memory corruption when releasing it. It's caused
> by rb_free_work function (CONFIG_PERF_USE_VMALLOC option).
> 
> For single page sized ring buffer the page_order is -1 (because
> nr_pages is 0). This needs to be recognized in the rb_free_work
> function to release proper amount of pages.
> 
> Introducing page_nr function (CONFIG_PERF_USE_VMALLOC only)
> that returns number of allocated pages. Using it in rb_free_work
> and perf_mmap_to_page functions.
> 
> Also setting rb->nr_pages to 0 in case we have only user page
> allocated, which will fail perf_output_begin function and
> prevents sample storage.
> 
> v2 changes:
>  - fixed the perf_output_begin handling of single page buffer
> 
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  kernel/events/ring_buffer.c | 40 +++++++++++++++++++++++++++++++++-------
>  1 file changed, 33 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> index 23cb34f..a802151 100644
> --- a/kernel/events/ring_buffer.c
> +++ b/kernel/events/ring_buffer.c
> @@ -154,7 +154,8 @@ int perf_output_begin(struct perf_output_handle *handle,
>  	if (head - local_read(&rb->wakeup) > rb->watermark)
>  		local_add(rb->watermark, &rb->wakeup);
>  
> -	handle->page = offset >> (PAGE_SHIFT + page_order(rb));
> +	/* page is allways 0 for CONFIG_PERF_USE_VMALLOC option */
> +	handle->page = offset >> PAGE_SHIFT;

I don't get that comment.. also it makes the calculation for page
inconsistent with the below calculation for addr.

We basically want to split the offset into a page number and an offset
within that; this means we need:

 pg_nr     = offset >> page_shift;
 pg_offset = offset & (1 << page_shift) - 1;

You just wrecked that.

>  	handle->page &= rb->nr_pages - 1;
>  	handle->size = offset & ((PAGE_SIZE << page_order(rb)) - 1);
>  	handle->addr = rb->data_pages[handle->page];
> @@ -312,11 +313,21 @@ void rb_free(struct ring_buffer *rb)
>  }
>  
>  #else
> +/*
> + * Returns the total number of pages allocated
> + * by ring buffer including the user page.
> + */
> +static int page_nr(struct ring_buffer *rb)
> +{
> +	return page_order(rb) == -1 ?
> +		1 :                        /* no data, just user page */
> +		1 + (1 << page_order(rb)); /* user page + data pages */
> +}

I think a number of the bugs below is due to the conflation of data
pages vs total pages. It might be best to call this data_page_nr() and
leave the +1 for the sites where its needed.


>  struct page *
>  perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
>  {
> -	if (pgoff > (1UL << page_order(rb)))
> +	if (pgoff > page_nr(rb))
>  		return NULL;

This is just wrong.. you have page_nr() be 1+2^n, but the comparison is
'>' not '>=', this means we get a range of 2+2^n, not the desired 1+2^n.

>  	return vmalloc_to_page((void *)rb->user_page + pgoff * PAGE_SIZE);
> @@ -336,10 +347,10 @@ static void rb_free_work(struct work_struct *work)
>  	int i, nr;
>  
>  	rb = container_of(work, struct ring_buffer, work);
> -	nr = 1 << page_order(rb);
> +	nr = page_nr(rb);
>  
>  	base = rb->user_page;
> -	for (i = 0; i < nr + 1; i++)
> +	for (i = 0; i < nr; i++)
>  		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
>  
>  	vfree(base);
> @@ -371,9 +382,24 @@ struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
>  		goto fail_all_buf;
>  
>  	rb->user_page = all_buf;
> -	rb->data_pages[0] = all_buf + PAGE_SIZE;
> -	rb->page_order = ilog2(nr_pages);
> -	rb->nr_pages = 1;
> +
> +	/*
> +	 * For special case nr_pages == 0 we have
> +	 * only the user page mmaped plus:
> +	 *
> +	 *   rb->data_pages[0] = NULL
> +	 *   rb->nr_pages      = 0
> +	 *   rb->page_order    = -1
> +	 *
> +	 * The perf_output_begin function is guarded
> +	 * by (rb->nr_pages > 0) condition, so no
> +	 * output code touches above setup if we
> +	 * have only user page allocated.
> +	 */
> +
> +	rb->data_pages[0] = nr_pages ? all_buf + PAGE_SIZE : NULL;
> +	rb->nr_pages      = nr_pages ? 1 : 0;
> +	rb->page_order    = ilog2(nr_pages);
>  
>  	ring_buffer_init(rb, watermark, flags);
>  


