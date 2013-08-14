Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab3HNGsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 02:48:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46265 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab3HNGsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 02:48:53 -0400
Date: Tue, 13 Aug 2013 23:46:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v7 2/2] mm: make lru_add_drain_all() selective
Message-Id: <20130813234629.4ce2ec70.akpm@linux-foundation.org>
In-Reply-To: <520AC215.4050803@tilera.com>
References: <520AAF9C.1050702@tilera.com>
	<201308132307.r7DN74M5029053@farm-0021.internal.tilera.com>
	<20130813232904.GJ28996@mtj.dyndns.org>
	<520AC215.4050803@tilera.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013 19:32:37 -0400 Chris Metcalf <cmetcalf@tilera.com> wrote:

> On 8/13/2013 7:29 PM, Tejun Heo wrote:
> > Hello,
> >
> > On Tue, Aug 13, 2013 at 06:53:32PM -0400, Chris Metcalf wrote:
> >>  int lru_add_drain_all(void)
> >>  {
> >> -	return schedule_on_each_cpu(lru_add_drain_per_cpu);
> >> +	return schedule_on_each_cpu_cond(lru_add_drain_per_cpu,
> >> +					 lru_add_drain_cond, NULL);

This version looks nice to me.  It's missing the conversion of
schedule_on_each_cpu(), but I suppose that will be pretty simple.

> > It won't nest and doing it simultaneously won't buy anything, right?
> 
> Correct on both counts, I think.

I'm glad you understood the question :(

What does "nest" mean?  lru_add_drain_all() calls itself recursively,
presumably via some ghastly alloc_percpu()->alloc_pages(GFP_KERNEL)
route?  If that ever happens then we'd certainly want to know about it.
Hopefully PF_MEMALLOC would prevent infinite recursion.

If "nest" means something else then please enlighten me!

As for "doing it simultaneously", I assume we're referring to
concurrent execution from separate threads.  If so, why would that "buy
us anything"?  Confused.  As long as each thread sees "all pages which
were in pagevecs at the time I called lru_add_drain_all() get spilled
onto the LRU" then we're good.  afaict the implementation will do this.

> > Wouldn't it be better to protect it with a mutex and define all
> > necessary resources statically (yeah, cpumask is pain in the ass and I
> > think we should un-deprecate cpumask_t for static use cases)?  Then,
> > there'd be no allocation to worry about on the path.
> 
> If allocation is a real problem on this path, I think this is probably

Well as you pointed out, alloc_percpu() can already do a GFP_KERNEL
allocation, so adding another GFP_KERNEL allocation won't cause great
problems.  But the patchset demonstrates that the additional allocation
isn't needed.

> OK, though I don't want to speak for Andrew.  You could just guard it
> with a trylock and any caller that tried to start it while it was
> locked could just return happy that it was going on.
> 
> I'll put out a version that does that and see how that looks
> for comparison's sake.

That one's no good.  If thread A is holding the mutex, thread B will
bale out and we broke lru_add_drain_all()'s contract, "all pages which
...", above.

