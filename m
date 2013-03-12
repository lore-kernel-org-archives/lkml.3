Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab3CLMiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:38:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35592 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab3CLMiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:38:54 -0400
Message-ID: <1363091919.24558.1.camel@laptop>
Subject: Re: [PATCHv3] perf: Fix vmalloc ring buffer free function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 12 Mar 2013 13:38:39 +0100
In-Reply-To: <20130312105300.GD1348@krava.brq.redhat.com>
References: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
	 <1362994843.10972.40.camel@laptop>
	 <20130311112105.GA9737@krava.brq.redhat.com>
	 <1363019193.14933.14.camel@laptop>
	 <20130311164309.GG13679@krava.brq.redhat.com>
	 <1363023885.14933.16.camel@laptop>
	 <20130311180229.GI13679@krava.brq.redhat.com>
	 <20130312100502.GC1348@krava.brq.redhat.com>
	 <1363084030.14933.23.camel@laptop>
	 <20130312105300.GD1348@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-12 at 11:53 +0100, Jiri Olsa wrote:
> > @@ -316,7 +316,7 @@ void rb_free(struct ring_buffer *rb)
> >  struct page *
> >  perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
> >  {
> > -     if (pgoff > (1UL << page_order(rb)))
> > +     if (pgoff > rb->nr_pages)
> >               return NULL;
> 
> here it's the '>' that masks that there's actually (rb->nr_pages + 1) pages
> 
> >  
> >       return vmalloc_to_page((void *)rb->user_page + pgoff * PAGE_SIZE);
> > @@ -336,7 +336,7 @@ static void rb_free_work(struct work_struct *work)
> >       int i, nr;
> >  
> >       rb = container_of(work, struct ring_buffer, work);
> > -     nr = 1 << page_order(rb);
> > +     nr = rb->nr_pages;
> >  
> >       base = rb->user_page;
> >       for (i = 0; i < nr + 1; i++)
> 
> and here's the user plus one

Right, we could make that either '< nr' and '<= nr' or '<= nr+1' and '<
nr+1'. No real preference either way, but you're right in that being
consistent here makes sense.

