Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3CMLQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:16:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab3CMLQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:16:18 -0400
Date: Wed, 13 Mar 2013 12:15:57 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCHv3] perf: Fix vmalloc ring buffer free function
Message-ID: <20130313111557.GC1064@krava.brq.redhat.com>
References: <20130311164309.GG13679@krava.brq.redhat.com>
 <1363023885.14933.16.camel@laptop>
 <20130311180229.GI13679@krava.brq.redhat.com>
 <20130312100502.GC1348@krava.brq.redhat.com>
 <1363084030.14933.23.camel@laptop>
 <20130312135219.GA32001@krava.brq.redhat.com>
 <1363101972.24558.3.camel@laptop>
 <20130312153609.GC32001@krava.brq.redhat.com>
 <1363105490.24558.12.camel@laptop>
 <20130312170416.GD32001@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312170416.GD32001@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 06:04:16PM +0100, Jiri Olsa wrote:
> On Tue, Mar 12, 2013 at 05:24:50PM +0100, Peter Zijlstra wrote:
> > Right you are..
> > 
> > How about something like the below; using that 0 << -1 is still 0.
> 
> hum.. we are obviously not on the same page wrt 'confusing' ;-)
> 
> looks ok, I'll test it

hi, it work's fine..

Tested-by: Jiri Olsa <jolsa@redhat.com>

> 
> jirka
> 
> > 
> > ---
> >  kernel/events/ring_buffer.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> > index 23cb34f..e72ca70 100644
> > --- a/kernel/events/ring_buffer.c
> > +++ b/kernel/events/ring_buffer.c
> > @@ -316,7 +316,7 @@ void rb_free(struct ring_buffer *rb)
> >  struct page *
> >  perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
> >  {
> > -	if (pgoff > (1UL << page_order(rb)))
> > +	if (pgoff > (rb->nr_pages << page_order(rb)))
> >  		return NULL;
> >  
> >  	return vmalloc_to_page((void *)rb->user_page + pgoff * PAGE_SIZE);
> > @@ -336,10 +336,10 @@ static void rb_free_work(struct work_struct *work)
> >  	int i, nr;
> >  
> >  	rb = container_of(work, struct ring_buffer, work);
> > -	nr = 1 << page_order(rb);
> > +	nr = rb->nr_pages << page_order(rb);
> >  
> >  	base = rb->user_page;
> > -	for (i = 0; i < nr + 1; i++)
> > +	for (i = 0; i <= nr; i++)
> >  		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
> >  
> >  	vfree(base);
> > @@ -373,7 +373,7 @@ struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
> >  	rb->user_page = all_buf;
> >  	rb->data_pages[0] = all_buf + PAGE_SIZE;

just a nit pick.. in case of having just user page,
data_pages[0] holds wrong pointer, but it 'should'
be never touch in this case
