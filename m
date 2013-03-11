Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3CKLVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:21:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab3CKLVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:21:31 -0400
Date: Mon, 11 Mar 2013 12:21:05 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCHv2] perf: Fix vmalloc ring buffer free function
Message-ID: <20130311112105.GA9737@krava.brq.redhat.com>
References: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
 <1362994843.10972.40.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362994843.10972.40.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

heya ;)

great to hear from you again!

On Mon, Mar 11, 2013 at 10:40:43AM +0100, Peter Zijlstra wrote:
> On Fri, 2013-03-01 at 17:34 +0100, Jiri Olsa wrote:
> > If we allocate perf ring buffer with the size of single page,

SNIP

> > diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> > index 23cb34f..a802151 100644
> > --- a/kernel/events/ring_buffer.c
> > +++ b/kernel/events/ring_buffer.c
> > @@ -154,7 +154,8 @@ int perf_output_begin(struct perf_output_handle *handle,
> >  	if (head - local_read(&rb->wakeup) > rb->watermark)
> >  		local_add(rb->watermark, &rb->wakeup);
> >  
> > -	handle->page = offset >> (PAGE_SHIFT + page_order(rb));
> > +	/* page is allways 0 for CONFIG_PERF_USE_VMALLOC option */
> > +	handle->page = offset >> PAGE_SHIFT;
> 
> I don't get that comment.. also it makes the calculation for page
> inconsistent with the below calculation for addr.
> 
> We basically want to split the offset into a page number and an offset
> within that; this means we need:
> 
>  pg_nr     = offset >> page_shift;
>  pg_offset = offset & (1 << page_shift) - 1;
> 
> You just wrecked that.
> 
> >  	handle->page &= rb->nr_pages - 1;

here's ^^^ where the handle->page becomes 0 due to (rb->nr_pages == 0)

for CONFIG_PERF_USE_VMALLOC we use only the first item in
rb->data_pages[] array, which holds the whole data memory,
and got accessed by 'offset' directly


> >  	handle->size = offset & ((PAGE_SIZE << page_order(rb)) - 1);
> >  	handle->addr = rb->data_pages[handle->page];
> > @@ -312,11 +313,21 @@ void rb_free(struct ring_buffer *rb)
> >  }
> >  
> >  #else
> > +/*
> > + * Returns the total number of pages allocated
> > + * by ring buffer including the user page.
> > + */
> > +static int page_nr(struct ring_buffer *rb)
> > +{
> > +	return page_order(rb) == -1 ?
> > +		1 :                        /* no data, just user page */
> > +		1 + (1 << page_order(rb)); /* user page + data pages */
> > +}
> 
> I think a number of the bugs below is due to the conflation of data
> pages vs total pages. It might be best to call this data_page_nr() and
> leave the +1 for the sites where its needed.

both places using page_nr need total pages count,
maybe I can rename it into total_page_nr()

> 
> 
> >  struct page *
> >  perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
> >  {
> > -	if (pgoff > (1UL << page_order(rb)))
> > +	if (pgoff > page_nr(rb))
> >  		return NULL;
> 
> This is just wrong.. you have page_nr() be 1+2^n, but the comparison is

> '>' not '>=', this means we get a range of 2+2^n, not the desired 1+2^n.

ouch, missed that one

thanks,
jirka
