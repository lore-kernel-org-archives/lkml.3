Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbaJHOQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:16:46 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42516 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbaJHOQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:16:45 -0400
Date: Wed, 8 Oct 2014 15:16:26 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] sched: Introduce scale-invariant load tracking
Message-ID: <20141008141626.GE1788@e105550-lin.cambridge.arm.com>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
 <1411403047-32010-2-git-send-email-morten.rasmussen@arm.com>
 <CAKfTPtBXP7HQBHL_Z3aAfdsuLP44_0x_e_LmzEw8qVC-2g=M-w@mail.gmail.com>
 <20140925172343.GX23693@e103034-lin>
 <20141002203428.GI2849@worktop.programming.kicks-ass.net>
 <20141008110054.GA1788@e105550-lin.cambridge.arm.com>
 <CAKfTPtAQ5FqHqdqDHDKg11XOHt_i0EsQFTuKg4OpreYA9a74Gg@mail.gmail.com>
 <20141008135339.GC1788@e105550-lin.cambridge.arm.com>
 <CAKfTPtAefmLDsEhWgri=urSmHQ-sydqcYDGX08dN982Lav1sGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtAefmLDsEhWgri=urSmHQ-sydqcYDGX08dN982Lav1sGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 03:08:04PM +0100, Vincent Guittot wrote:
> On 8 October 2014 15:53, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> > On Wed, Oct 08, 2014 at 12:21:45PM +0100, Vincent Guittot wrote:
> >> On 8 October 2014 13:00, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> 
> >> >
> >> > Sure. The easiest way to avoid introducing overflows is to ensure that
> >> > we always scale by a factor >= 1.0. That should be true as long as
> >> > arch_scale_{cpu,freq}_capacity() never returns anything greater than
> >> > SCHED_CAPACITY_SCALE (= 1024 = 1.0).
> >>
> >> the current ARM arch_scale_cpu is in the range [1536..0] which is free
> >> of overflow AFAICT
> >
> > If I'm not mistaken, that will cause an overflow in
> > __update_task_entity_contrib():
> >
> > static inline void __update_task_entity_contrib(struct sched_entity *se)
> > {
> >         u32 contrib;
> >         /* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
> >         contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
> >         contrib /= (se->avg.avg_period + 1);
> >         se->avg.load_avg_contrib = scale_load(contrib);
> > }
> >
> > With arch_scale_cpu_capacity() > 1024 se->avg.runnable_avg_sum is no
> > longer bounded by LOAD_AVG_MAX = 47742. scale_load_down(se->load.weight)
> > == se->load.weight =< 88761.
> >
> >         47742 * 88761 = 4237627662 (2^32 = 4294967296)
> >
> > To avoid overflow se->avg.runnable_avg_sum must be less than 2^32/88761
> > = 48388, which means that arch_scale_cpu_capacity() must be in the range
> > 0..48388*1024/47742 = 0..1037.
> >
> > I also think it is easier to have a fixed defined max scaling factor,
> > but that might just be me.
> 
> OK,  overflow comes with adding uarch invariance into runnable load average
> 
> >
> > Regarding the ARM arch_scale_cpu_capacity() implementation, I think that
> > can be changed to fit the 0..1024 range easily. Currently, it will only
> > report a non-default (1024) capacity for big.LITTLE systems and actually
> > enabling it (requires a certain property to be set in device tree) leads
> > to broken load-balancing decisions. We have discussed that several times
> 
> Only the 1 task per CPU is broken but in the other hand, it better
> handles the overload use case where we have more tasks than CPU and
> other middle range use case by putting more task on big cluster.

Yes, agreed. My point was just to say that it shouldn't cause a lot of
harm changing the range of arch_scale_cpu_capacity() for ARM. We need to
fix things anyway.
