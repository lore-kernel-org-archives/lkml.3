Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab3FRCor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 22:44:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3FRCop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 22:44:45 -0400
Date: Mon, 17 Jun 2013 19:44:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: =?ISO-8859-1?Q?Rapha=EBl?= Beamonte <raphael.beamonte@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "lttng-dev@lists.lttng.org" <lttng-dev@lists.lttng.org>,
        Mel Gorman <mgorman@suse.de>, Rob van der Heij <rvdheij@gmail.com>
Subject: Re: [lttng-dev] [-stable 3.8.1 performance regression] madvise
 POSIX_FADV_DONTNEED
Message-Id: <20130617194430.16d8c3ea.akpm@linux-foundation.org>
In-Reply-To: <20130618021528.GA29506@Krystal>
References: <51BE1828.3060206@gmail.com>
	<20130617141357.GA6034@Krystal>
	<20130617142459.1d563072231ba269cdac8f11@linux-foundation.org>
	<CAE_Gge34HCroSgNgiXL1j7Le3CNKRXR=7TZQhJSmY+wfWniKug@mail.gmail.com>
	<20130617145714.8032ba33fd3e4e6887755209@linux-foundation.org>
	<20130618021528.GA29506@Krystal>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jun 2013 22:15:28 -0400 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> * Andrew Morton (akpm@linux-foundation.org) wrote:
> > On Mon, 17 Jun 2013 17:39:36 -0400 Rapha__l Beamonte <raphael.beamonte@gmail.com> wrote:
> > 
> > > 2013/6/17 Andrew Morton <akpm@linux-foundation.org>
> > > 
> > > > That change wasn't terribly efficient - if there are any unpopulated
> > > > pages in the range (which is quite likely), fadvise() will now always
> > > > call invalidate_mapping_pages() a second time.
> > > >
> > > > Perhaps this is fixable.  Say, make lru_add_drain_all() return a
> > > > success code, or even teach lru_add_drain_all() to return a code
> > > > indicating that one of the spilled pages was (or might have been) on a
> > > > particular mapping.
> > > >
> > > 
> > > Following our tests results, that was the call to lru_add_drain_all() that
> > > causes the problem. The second call to invalidate_mapping_pages() isn't
> > > really important. We tried to compile a kernel with the commit introducing
> > > this change but with the "lru_add_drain_all()" line removed, and the
> > > problem disappeared, even if we called two times invalidate_mapping_pages()
> > > (as the rest of the commit was still here).
> > 
> > Ah, OK, schedule_on_each_cpu() could certainly do that - it has to wait
> > for every CPU to context switch and schedule the worker function.
> > 
> > There's a lot we could do here.  Such as not doing the schedule_work()
> > at all for a cpu which has an empty lru_add_pvec.
> 
> First approach proposed, submitted as RFC. Compile-tested only.
> 
> ...
>
> Second approach, submitted as RFC with some questions left unanswered
> in the code. Compile-tested only.
> 
> ---
>  include/linux/swap.h |    1 
>  mm/fadvise.c         |    2 -
>  mm/swap.c            |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 64 insertions(+), 1 deletion(-)
> 
> Index: linux/include/linux/swap.h
> ===================================================================
> --- linux.orig/include/linux/swap.h
> +++ linux/include/linux/swap.h
> @@ -242,6 +242,7 @@ extern void mark_page_accessed(struct pa
>  extern void lru_add_drain(void);
>  extern void lru_add_drain_cpu(int cpu);
>  extern int lru_add_drain_all(void);
> +extern int lru_add_drain_mapping(struct address_space *mapping);
>  extern void rotate_reclaimable_page(struct page *page);
>  extern void deactivate_page(struct page *page);
>  extern void swap_setup(void);
> Index: linux/mm/swap.c
> ===================================================================
> --- linux.orig/mm/swap.c
> +++ linux/mm/swap.c
> @@ -689,6 +689,68 @@ int lru_add_drain_all(void)
>  }
>  
>  /*
> + * Returns 0 for success
> + */
> +int lru_add_drain_mapping(struct address_space *mapping)
> +{
> +	int cpu;
> +	struct work_struct __percpu *works;
> +
> +	works = alloc_percpu(struct work_struct);
> +	if (!works)
> +		return -ENOMEM;
> +
> +	get_online_cpus();
> +
> +	for_each_online_cpu(cpu) {
> +		struct pagevec *pvecs = per_cpu(lru_add_pvecs, cpu);
> +		struct work_struct *work = per_cpu_ptr(works, cpu);
> +		struct pagevec *pvec;
> +		int lru;
> +
> +		INIT_WORK(work, lru_add_drain_per_cpu);
> +		for_each_lru(lru) {
> +			int i;
> +
> +			pvec = &pvecs[lru - LRU_BASE];
> +			/*
> +			 * Race failure mode is to flush unnecessarily.
> +			 * We use PAGEVEC_SIZE rather than pvec->nr to
> +			 * stay on the safe-side wrt pvec resize.
> +			 */
> +			for (i = 0; i < PAGEVEC_SIZE; i++) {
> +				struct page *page;
> +
> +				/*
> +				 * Racy access to page. TODO: is it OK
> +				 * to access it from the remote CPU's
> +				 * lru without any kind of ownership or
> +				 * synchronization ?
> +				 */

Almost.  The only problem I can think of is that the other CPU flushes
its pagevec then a page gets freed then a memory hot-unplug occurs and
the memory hotplug handler frees and then unmaps the memory which was
used to hold the page's `struct page' (I don't think the current
mem-hotplug code even does this) and now this cpu's page->mapping
access goes oops.  

IOW, not worth worrying for a prototype "hey lets test this and see if
it fixes things" patch.


> +				page = ACCESS_ONCE(pvec->pages[i]);
> +				if (!pvec->pages[i])
> +					continue;
> +				if (page->mapping == mapping) {
> +					schedule_work_on(cpu, work);
> +					goto next_cpu;
> +				}
> +			}
> +		}
> +	next_cpu: ;	/* TODO: coding ugliness */
> +	}
> +
> +	for_each_online_cpu(cpu) {
> +		struct work_struct *work = per_cpu_ptr(works, cpu);
> +		if (work_pending(work))
> +			flush_work(work);
> +	}
> +
> +	put_online_cpus();
> +	free_percpu(works);
> +	return 0;
> +}
>
> ...
>
