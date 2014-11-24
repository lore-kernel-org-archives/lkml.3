Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbaKXR3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:29:55 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38316 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaKXR3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:29:54 -0500
Date: Mon, 24 Nov 2014 17:30:46 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "kamalesh@linux.vnet.ibm.com" <kamalesh@linux.vnet.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v9 10/10] sched: move cfs task on a CPU with higher
 capacity
Message-ID: <20141124173046.GM23177@e105550-lin.cambridge.arm.com>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
 <1415033687-23294-11-git-send-email-vincent.guittot@linaro.org>
 <20141121123733.GI23177@e105550-lin.cambridge.arm.com>
 <CAKfTPtC9tew3wzoWfyxOWJR8MtpL+jjwWoA9Lkpk4opVUEXcxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtC9tew3wzoWfyxOWJR8MtpL+jjwWoA9Lkpk4opVUEXcxQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 02:45:45PM +0000, Vincent Guittot wrote:
> On 21 November 2014 at 13:37, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> > On Mon, Nov 03, 2014 at 04:54:47PM +0000, Vincent Guittot wrote:
> 
> >>
> >> +     /*
> >> +      * The dst_cpu is idle and the src_cpu CPU has only 1 CFS task.
> >> +      * It's worth migrating the task if the src_cpu's capacity is reduced
> >> +      * because of other sched_class or IRQs whereas capacity stays
> >> +      * available on dst_cpu.
> >> +      */
> >> +     if ((env->idle != CPU_NOT_IDLE) &&
> >> +                     (env->src_rq->cfs.h_nr_running == 1)) {
> >> +             unsigned long src_eff_capacity, dst_eff_capacity;
> >> +
> >> +             dst_eff_capacity = 100;
> >> +             dst_eff_capacity *= capacity_of(env->dst_cpu);
> >> +             dst_eff_capacity *= capacity_orig_of(env->src_cpu);
> >> +
> >> +             src_eff_capacity = sd->imbalance_pct;
> >> +             src_eff_capacity *= capacity_of(env->src_cpu);
> >> +             src_eff_capacity *= capacity_orig_of(env->dst_cpu);
> >
> > Do we need to scale by capacity_orig? Shouldn't the absolute capacity be
> > better?
> >
> > if (capacity_of(env->src) * sd->imbalance_pct < capacity_of(env->dst) *
> > 100) ?
> 
> we don't want to compare absolute capacity between CPUs but to compare
> the reduction of their capacity because we want to choose the CPU
> which is less used  by RT tasks or irq

But least relative RT load doesn't necessarily mean most available
compute capacity. 50% RT use of a capacity_orig = 1000 (capacity_of(cpu) =
500, eff_capacity = 50%) gives better CFS throughput than 20% RT use of
a capacity_orig = 500 (capacity_of(cpu) = 400, eff_capacity = 80%). Why pick
the cpu with less throughput?

Morten

> 
> Regards,
> Vincent
> >
> > Isn't it the absolute available capacity that matters? For SMP
> > capacity_orig is the same and cancels out and doesn't change anything.
> > For big.LITTLE we would rather have the task run on a big where rt/irq
> > eats 30% than a little cpu where rq/irq eats 5%, assuming big capacity
> > is much bigger than little capacity so the absolute available capacity
> > (~cycles/time) is larger on the big cpu.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
