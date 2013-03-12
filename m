Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3CLNwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:52:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab3CLNwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:52:43 -0400
Date: Tue, 12 Mar 2013 14:52:19 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCHv3] perf: Fix vmalloc ring buffer free function
Message-ID: <20130312135219.GA32001@krava.brq.redhat.com>
References: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
 <1362994843.10972.40.camel@laptop>
 <20130311112105.GA9737@krava.brq.redhat.com>
 <1363019193.14933.14.camel@laptop>
 <20130311164309.GG13679@krava.brq.redhat.com>
 <1363023885.14933.16.camel@laptop>
 <20130311180229.GI13679@krava.brq.redhat.com>
 <20130312100502.GC1348@krava.brq.redhat.com>
 <1363084030.14933.23.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363084030.14933.23.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 11:27:10AM +0100, Peter Zijlstra wrote:
> On Tue, 2013-03-12 at 11:05 +0100, Jiri Olsa wrote:

SNIP

> ---
>  kernel/events/ring_buffer.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> index 23cb34f..4f48d02 100644
> --- a/kernel/events/ring_buffer.c
> +++ b/kernel/events/ring_buffer.c
> @@ -316,7 +316,7 @@ void rb_free(struct ring_buffer *rb)
>  struct page *
>  perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
>  {
> -	if (pgoff > (1UL << page_order(rb)))
> +	if (pgoff > rb->nr_pages)
>  		return NULL;
>  
>  	return vmalloc_to_page((void *)rb->user_page + pgoff * PAGE_SIZE);
> @@ -336,7 +336,7 @@ static void rb_free_work(struct work_struct *work)
>  	int i, nr;
>  
>  	rb = container_of(work, struct ring_buffer, work);
> -	nr = 1 << page_order(rb);
> +	nr = rb->nr_pages;
>  
>  	base = rb->user_page;
>  	for (i = 0; i < nr + 1; i++)
> @@ -373,7 +373,7 @@ struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
>  	rb->user_page = all_buf;
>  	rb->data_pages[0] = all_buf + PAGE_SIZE;
>  	rb->page_order = ilog2(nr_pages);
> -	rb->nr_pages = 1;
> +	rb->nr_pages = nr_pages;
>  

hum, and this ^^^ breaks perf_data_size(rb) ;)

static inline unsigned long perf_data_size(struct ring_buffer *rb)
{
        return rb->nr_pages << (PAGE_SHIFT + page_order(rb));
}

we could make it ifdef-ed for CONFIG_PERF_USE_VMALLOC

jirka
