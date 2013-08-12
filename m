Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3HLVFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 17:05:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab3HLVFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 17:05:32 -0400
Date: Mon, 12 Aug 2013 14:05:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/2] mm: make lru_add_drain_all() selective
Message-Id: <20130812140520.c6a2255d2176a690fadf9ba7@linux-foundation.org>
In-Reply-To: <201308072335.r77NZZwl022494@farm-0012.internal.tilera.com>
References: <5202CEAA.9040204@linux.vnet.ibm.com>
	<201308072335.r77NZZwl022494@farm-0012.internal.tilera.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Aug 2013 16:52:22 -0400 Chris Metcalf <cmetcalf@tilera.com> wrote:

> This change makes lru_add_drain_all() only selectively interrupt
> the cpus that have per-cpu free pages that can be drained.
> 
> This is important in nohz mode where calling mlockall(), for
> example, otherwise will interrupt every core unnecessarily.
> 
> ...
>
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -405,6 +405,11 @@ static void activate_page_drain(int cpu)
>  		pagevec_lru_move_fn(pvec, __activate_page, NULL);
>  }
>  
> +static bool need_activate_page_drain(int cpu)
> +{
> +	return pagevec_count(&per_cpu(activate_page_pvecs, cpu)) != 0;
> +}
> +
>  void activate_page(struct page *page)
>  {
>  	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
> @@ -422,6 +427,11 @@ static inline void activate_page_drain(int cpu)
>  {
>  }
>  
> +static bool need_activate_page_drain(int cpu)
> +{
> +	return false;
> +}
> +
>  void activate_page(struct page *page)
>  {
>  	struct zone *zone = page_zone(page);
> @@ -683,7 +693,32 @@ static void lru_add_drain_per_cpu(struct work_struct *dummy)
>   */
>  int lru_add_drain_all(void)
>  {
> -	return schedule_on_each_cpu(lru_add_drain_per_cpu);
> +	cpumask_var_t mask;
> +	int cpu, rc;
> +
> +	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
> +		return -ENOMEM;

Newly adding a GFP_KERNEL allocation attempt into lru_add_drain_all()
is dangerous and undesirable.  I took a quick look at all the callsites
and didn't immediately see a bug, but it's hard because they're
splattered all over the place.  It would be far better if we were to
not do this.

Rather than tossing this hang-grenade in there we should at a reluctant
minimum change lru_add_drain_all() to take a gfp_t argument and then
carefully review and update the callers.

> +	cpumask_clear(mask);
> +
> +	/*
> +	 * Figure out which cpus need flushing.  It's OK if we race
> +	 * with changes to the per-cpu lru pvecs, since it's no worse
> +	 * than if we flushed all cpus, since a cpu could still end
> +	 * up putting pages back on its pvec before we returned.
> +	 * And this avoids interrupting other cpus unnecessarily.
> +	 */
> +	for_each_online_cpu(cpu) {
> +		if (pagevec_count(&per_cpu(lru_add_pvec, cpu)) ||
> +		    pagevec_count(&per_cpu(lru_rotate_pvecs, cpu)) ||
> +		    pagevec_count(&per_cpu(lru_deactivate_pvecs, cpu)) ||
> +		    need_activate_page_drain(cpu))
> +			cpumask_set_cpu(cpu, mask);
> +	}
> +
> +	rc = schedule_on_cpu_mask(lru_add_drain_per_cpu, mask);

And it seems pretty easy to avoid the allocation.  Create a single
cpumask at boot (or, preferably, at compile-time) and whenever we add a
page to a drainable pagevec, do

	cpumask_set_cpu(smp_processor_id(), global_cpumask);

and to avoid needlessly dirtying a cacheline,

	if (!cpu_isset(smp_processor_id(), global_cpumask))
		cpumask_set_cpu(smp_processor_id(), global_cpumask);


This means that lru_add_drain_all() will need to clear the mask at some
point and atomicity issues arise.  It would be better to do the
clearing within schedule_on_cpu_mask() itself, using
cpumask_test_and_clear_cpu().



Also, what's up with the get_online_cpus() handling? 
schedule_on_each_cpu() does it, lru_add_drain_all() does not do it and
the schedule_on_cpu_mask() documentation forgot to mention it.


