Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbaIQW0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:26:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:60720 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815AbaIQW0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:26:06 -0400
Date: Thu, 18 Sep 2014 00:25:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v5 11/12] sched: replace capacity_factor by utilization
Message-ID: <20140917222553.GD2848@worktop.localdomain>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-12-git-send-email-vincent.guittot@linaro.org>
 <20140911161517.GA3190@worktop.ger.corp.intel.com>
 <CAKfTPtDFuzxzGBKi_n6v_F8FUkQ84MW+dQBX4WNXo-o54mksGA@mail.gmail.com>
 <20140914194156.GC2832@worktop.localdomain>
 <20140915114229.GB3037@worktop.localdomain>
 <CAKfTPtDHSWs8xumOSfWkyucAtkBvvbJkOVTQkoYXYCBpmHrMZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtDHSWs8xumOSfWkyucAtkBvvbJkOVTQkoYXYCBpmHrMZg@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 12:14:54AM +0200, Vincent Guittot wrote:
> On 15 September 2014 13:42, Peter Zijlstra <peterz@infradead.org> wrote:

> > OK, I've reconsidered _again_, I still don't get it.
> >
> > So fundamentally I think its wrong to scale with the capacity; it just
> > doesn't make any sense. Consider big.little stuff, their CPUs are
> > inherently asymmetric in capacity, but that doesn't matter one whit for
> > utilization numbers. If a core is fully consumed its fully consumed, no
> > matter how much work it can or can not do.
> >
> >
> > So the only thing that needs correcting is the fact that these
> > statistics are based on clock_task and some of that time can end up in
> > other scheduling classes, at which point we'll never get 100% even
> > though we're 'saturated'. But correcting for that using capacity doesn't
> > 'work'.
> 
> I'm not sure to catch your last point because the capacity is the only
> figures that take into account the "time" consumed by other classes.
> Have you got in mind another way to take into account the other
> classes ?

So that was the entire point of stuffing capacity in? Note that that
point was not at all clear.

This is very much like 'all we have is a hammer, and therefore
everything is a nail'. The rt fraction is a 'small' part of what the
capacity is.

> So we have cpu_capacity that is the capacity that can be currently
> used by cfs class
> We have cfs.usage_load_avg that is the sum of running time of cfs
> tasks on the CPU and reflect the % of usage of this CPU by CFS tasks
> We have to use the same metrics to compare available capacity for CFS
> and current cfs usage

-ENOPARSE

> Now we have to use the same unit so we can either weight the
> cpu_capacity_orig with the cfs.usage_load_avg and compare it with
> cpu_capacity
> or with divide cpu_capacity by cpu_capacity_orig and scale it into the
> SCHED_LOAD_SCALE range. Is It what you are proposing ?

I'm so not getting it; orig vs capacity still includes
arch_scale_freq_capacity(), so that is not enough to isolate the rt
fraction.
