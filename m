Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaKXREO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:04:14 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38273 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaKXREN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:04:13 -0500
Date: Mon, 24 Nov 2014 17:05:02 +0000
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
Subject: Re: [PATCH v9 05/10] sched: make scale_rt invariant with frequency
Message-ID: <20141124170502.GK23177@e105550-lin.cambridge.arm.com>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
 <1415033687-23294-6-git-send-email-vincent.guittot@linaro.org>
 <20141121123559.GF23177@e105550-lin.cambridge.arm.com>
 <CAKfTPtAo3PzZ=-KtH-YS2nf9R9srMGAUJ2A2qkHrsPZmj18-Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtAo3PzZ=-KtH-YS2nf9R9srMGAUJ2A2qkHrsPZmj18-Jw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 02:24:00PM +0000, Vincent Guittot wrote:
> On 21 November 2014 at 13:35, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> > On Mon, Nov 03, 2014 at 04:54:42PM +0000, Vincent Guittot wrote:
> 
> [snip]
> 
> >> The average running time of RT tasks is used to estimate the remaining compute
> >> @@ -5801,19 +5801,12 @@ static unsigned long scale_rt_capacity(int cpu)
> >>
> >>       total = sched_avg_period() + delta;
> >>
> >> -     if (unlikely(total < avg)) {
> >> -             /* Ensures that capacity won't end up being negative */
> >> -             available = 0;
> >> -     } else {
> >> -             available = total - avg;
> >> -     }
> >> +     used = div_u64(avg, total);
> >
> > I haven't looked through all the details of the rt avg tracking, but if
> > 'used' is in the range [0..SCHED_CAPACITY_SCALE], I believe it should
> > work. Is it guaranteed that total > 0 so we don't get division by zero?
> 
> static inline u64 sched_avg_period(void)
> {
> return (u64)sysctl_sched_time_avg * NSEC_PER_MSEC / 2;
> }
>

I see.

> >
> > It does get a slightly more complicated if we want to figure out the
> > available capacity at the current frequency (current < max) later. Say,
> > rt eats 25% of the compute capacity, but the current frequency is only
> > 50%. In that case get:
> >
> > curr_avail_capacity = (arch_scale_cpu_capacity() *
> >   (arch_scale_freq_capacity() - (SCHED_SCALE_CAPACITY - scale_rt_capacity())))
> >   >> SCHED_CAPACITY_SHIFT
> 
> You don't have to be so complicated but simply need to do:
> curr_avail_capacity for CFS = (capacity_of(CPU) *
> arch_scale_freq_capacity())  >> SCHED_CAPACITY_SHIFT
> 
> capacity_of(CPU) = 600 is the max available capacity for CFS tasks
> once we have removed the 25% of capacity that is used by RT tasks
> arch_scale_freq_capacity = 512 because we currently run at 50% of max freq
> 
> so curr_avail_capacity for CFS = 300

I don't think that is correct. It is at least not what I had in mind.

capacity_orig_of(cpu) = 800, we run at 50% frequency which means:

curr_capacity = capacity_orig_of(cpu) * arch_scale_freq_capacity()
                  >> SCHED_CAPACITY_SHIFT
              = 400

So the total capacity at the current frequency (50%) is 400, without
considering RT. scale_rt_capacity() is frequency invariant, so it takes
away capacity_orig_of(cpu) - capacity_of(cpu) = 200 worth of capacity
for RT.  We need to subtract that from the current capacity to get the
available capacity at the current frequency.

curr_available_capacity = curr_capacity - (capacity_orig_of(cpu) -
capacity_of(cpu)) = 200

In other words, 800 is the max capacity, we are currently running at 50%
frequency, which gives us 400. RT takes away 25% of 800
(frequency-invariant) from the 400, which leaves us with 200 left for
CFS tasks at the current frequency.

In your calculations you subtract the RT load before computing the
current capacity using arch_scale_freq_capacity(), where I think it
should be done after. You find the amount spare capacity you would have
at the maximum frequency when RT has been subtracted and then scale the
result by frequency which means indirectly scaling the RT load
contribution again (the rt avg has already been scaled). So instead of
taking away 200 of the 400 (current capacity @ 50% frequency), it only
takes away 100 which isn't right.

scale_rt_capacity() is frequency-invariant, so if the RT load is 50% and
the frequency is 50%, there are no spare cycles left.
curr_avail_capacity should be 0. But using your expression above you
would get capacity_of(cpu) = 400 after removing RT,
arch_scale_freq_capacity = 512 and you get 200. I don't think that is
right.

Morten
