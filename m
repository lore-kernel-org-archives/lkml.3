Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaEOLvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 07:51:31 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56622 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaEOLva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 07:51:30 -0400
Date: Thu, 15 May 2014 13:52:22 +0200
From: Juri Lelli <juri.lelli@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [REGRESSION] funny sched_domain build failure during resume
Message-Id: <20140515135222.1479ae10c22fd1b91995806b@gmail.com>
In-Reply-To: <20140515085156.GG30445@twins.programming.kicks-ass.net>
References: <20140509160455.GA4486@htj.dyndns.org>
	<20140514140034.GM30445@twins.programming.kicks-ass.net>
	<20140515104055.e91844a5b75529edc560349a@gmail.com>
	<20140515085156.GG30445@twins.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 10:51:56 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, May 15, 2014 at 10:40:55AM +0200, Juri Lelli wrote:
> > Hi,
> > 
> > > @@ -37,10 +38,7 @@ static inline int dl_time_before(u64 a, u64 b)
> > >  
> > >  static void cpudl_exchange(struct cpudl *cp, int a, int b)
> > >  {
> > > -	int cpu_a = cp->elements[a].cpu, cpu_b = cp->elements[b].cpu;
> > > -
> > >  	swap(cp->elements[a], cp->elements[b]);
> > > -	swap(cp->cpu_to_idx[cpu_a], cp->cpu_to_idx[cpu_b]);
> > >  }
> > >  
> > 
> > I think there is a problem here. Your patch "embeds" cpu_to_idx array
> > in elements array, but here the swap operates differently on the two.
> 
> <snip>
> 
> > Sorry for this long reply, but I had to convince also myself...
> 
> Glad you explained it before I tried to untangle that code myself.
> 
> > So, I think that having just one dynamic array is nicer and better, but
> > we still need to swap things separately. Something like (on top of
> > yours):
> > 
> > diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
> > index 60ad0af..10dc7ab 100644
> > --- a/kernel/sched/cpudeadline.c
> > +++ b/kernel/sched/cpudeadline.c
> > @@ -36,9 +36,31 @@ static inline int dl_time_before(u64 a, u64 b)
> >         return (s64)(a - b) < 0;
> >  }
> >  
> > +static inline void swap_element(struct cpudl *cp, int a, int b)
> > +{
> > +       int cpu_tmp = cp->elements[a].cpu;
> > +       u64 dl_tmp = cp->elements[a].dl;
> > +
> > +       cp->elements[a].cpu = cp->elements[b].cpu;
> > +       cp->elements[a].dl = cp->elements[b].dl;
> > +       cp->elements[b].cpu = cpu_tmp;
> > +       cp->elements[b].dl = dl_tmp;
> 
> You could've just written:
> 
> 	swap(cp->elements[a].cpu, cp->elements[b].cpu);
> 	swap(cp->elements[a].dl , cp->elements[b].dl );
> 
> The swap macro does the tmp var for you.
> 
> > +}
> > +
> > +static inline void swap_idx(struct cpudl *cp, int a, int b)
> > +{
> > +       int idx_tmp = cp->elements[a].idx;
> > +
> > +       cp->elements[a].idx = cp->elements[b].idx;
> > +       cp->elements[b].idx = idx_tmp;
> 
> 	swap(cp->elements[a].idx, cp->elements[b].idx);
> 
> > +}
> > +
> >  static void cpudl_exchange(struct cpudl *cp, int a, int b)
> >  {
> > -       swap(cp->elements[a], cp->elements[b]);
> > +       int cpu_a = cp->elements[a].cpu, cpu_b = cp->elements[b].cpu;
> > +
> > +       swap_element(cp, a, b);
> > +       swap_idx(cp, cpu_a, cpu_b);
> 
> Or just skip the lot and put the 3 swap() stmts here.
> 

Ah, yes, sure!

Maybe we could add in cpudeadline.c also a comment explaining a bit how
the thing works. Something along the line of cpupri.c:

/*
 *  kernel/sched/cpudeadline.c
 *
 *  Global CPU deadline management                                     
 *                               
 *  Author: Juri Lelli <juri.lelli@gmail.com>
 *
 *  This code tracks the deadline of each CPU (i.e., the deadline of
 *  current on the CPU) so that global migration decisions are easy
 *  to calculate. Each CPU can be in a state as follows:
 *
 *            (INVALID), WITH_DL_TASK(S)
 *
 *  The system maintains this state with a max-heap implemented as
 *  a simple array. To efficiently handle updates on intermediate nodes
 *  the array can be thought as splitted in two parts, one that contains
 *  heap nodes, and the other that keeps track of where nodes reside in
 *  the first part. From kernel/sched/cpudeadline.h we conceptually
 *  have:
 *
 *  	struct cpudl_item {
 *  		u64 dl;
 * 		int cpu;
 *  	-------------------
 *  		int idx;
 *  	}
 *
 *  Moreover, we keep track of CPUs in the INVALID state with a cpumask
 *  (no need to use the array if some CPU is free).
 *
 *  Let's clarify this with a simple example. Suppose at a certain
 *  instant of time we have this situation (4CPUs box):
 *
 *                     CPU 1
 *                     DL 50
 *                   /       \         
 *                  /         \
 *               CPU 2       CPU 0
 *               DL 30       DL 40
 *              /
 *             /
 *           CPU 3
 *           DL 25
 *
 *  In this case the state is mantained as:
 *
 *  elements[dl/cpu] |  50/1  |  30/2  |  40/0  |  25/3  |
 *                       ^          ^     ^          ^
 *                       |          +-----|-+        |
 *                       +---------+      | |        |
 *                        +--------|------+ |        |
 *  elements[idx]    |    2   |    0   |    1   |    3   |
 *
 *  Operations on the heap (e.g., node updates) must thus handle
 *  the two parts of elements array separately, see cpudl_set()
 *  and cpudl_exchange() for details.
 *                 
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; version 2
 *  of the License.
 */

Thanks,

- Juri

> >  }
> >  
> >  static void cpudl_heapify(struct cpudl *cp, int idx)
> > ---
> > 
> > But, I don't know if this is too ugly and we better go with two arrays
> > (or a better solution, as this is the fastest thing I could come up
> > with :)).
> 
> Thanks for looking at it, and sorry for breaking it.
