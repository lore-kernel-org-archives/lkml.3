Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbaJCJf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 05:35:58 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40853 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaJCJf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 05:35:57 -0400
Date: Fri, 3 Oct 2014 10:35:46 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>
Subject: Re: [PATCH v6 5/6] sched: replace capacity_factor by usage
Message-ID: <20141003093546.GB28662@e103034-lin>
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
 <1411488485-10025-6-git-send-email-vincent.guittot@linaro.org>
 <20141002165745.GA28662@e103034-lin>
 <CAKfTPtA5XTwT0fTqXZJWWwfUQ8SfVxiqmQwSWqFKpbb1XpriRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtA5XTwT0fTqXZJWWwfUQ8SfVxiqmQwSWqFKpbb1XpriRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 08:24:23AM +0100, Vincent Guittot wrote:
> On 2 October 2014 18:57, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> > On Tue, Sep 23, 2014 at 05:08:04PM +0100, Vincent Guittot wrote:
> >> Below are two examples to illustrate the problem that this patch solves:
> >>
> >> 1 - capacity_factor makes the assumption that max capacity of a CPU is
> >> SCHED_CAPACITY_SCALE and the load of a thread is always is
> >> SCHED_LOAD_SCALE. It compares the output of these figures with the sum
> >> of nr_running to decide if a group is overloaded or not.
> >>
> >> But if the default capacity of a CPU is less than SCHED_CAPACITY_SCALE
> >> (640 as an example), a group of 3 CPUS will have a max capacity_factor
> >> of 2 ( div_round_closest(3x640/1024) = 2) which means that it will be
> >> seen as overloaded if we have only one task per CPU.
> >
> > I did some testing on TC2 which has the setup you describe above on the
> > A7 cluster when the clock-frequency property is set in DT. The two A15s
> > have max capacities above 1024. When using sysbench with five threads I
> > still get three tasks on the two A15s and two tasks on the three A7
> > leaving one cpu idle (on average).
> >
> > Using cpu utilization (usage) does correctly identify the A15 cluster as
> > overloaded and it even gets as far as selecting the A15 running two
> > tasks as the source cpu in load_balance(). However, load_balance() bails
> > out without pulling the task due to calculate_imbalance() returning a
> > zero imbalance. calculate_imbalance() bails out just before the hunk you
> > changed due to comparison of the sched_group avg_loads. sgs->avg_load is
> > basically the sum of load in the group divided by its capacity. Since
> > load isn't scaled the avg_load of the overloaded A15 group is slightly
> > _lower_ than the partially idle A7 group. Hence calculate_imbalance()
> > bails out, which isn't what we want.
> >
> > I think we need to have a closer look at the imbalance calculation code
> > and any other users of sgs->avg_load to get rid of all code making
> > assumptions about cpu capacity.
> 
> We already had this discussion during the review of a previous version
> https://lkml.org/lkml/2014/6/3/422
> and my answer has not changed; This patch is necessary to solve the 1
> task per CPU issue of the HMP system but is not enough. I have a patch
> for solving the imbalance calculation issue and i have planned to send
> it once this patch will be in a good shape for being accepted by
> Peter.
> 
> I don't want to mix this patch and the next one because there are
> addressing different problem: this one is how evaluate the capacity of
> a system and detect when a group is overloaded and the next one will
> handle the case when the balance of the system can't rely on the
> average load figures of the group because we have a significant
> capacity difference between groups. Not that i haven't specifically
> mentioned HMP for the last patch because SMP system can also take
> advantage of it

You do mention 'big' and 'little' cores in your commit message and quote
example numbers with are identical to the cpu capacities for TC2. That
lead me to believe that this patch would address the issues we see for
HMP systems. But that is clearly wrong. I would suggest that you drop
mentioning big and little cores and stick to only describing cpu
capacity reductions due to rt tasks and irq to avoid any confusion about
the purpose of the patch. Maybe explicitly say that non-default cpu
capacities (capacity_orig) isn't addressed yet.

I think the two problems you describe are very much related. This patch
set is half the solution of the HMP balancing problem. We just need the
last bit for avg_load and then we can add scale-invariance on top.

IMHO, it would be good to have all the bits and pieces for cpu capacity
scaling and scaling of per-entity load-tracking on the table so we fit
things together. We only have patches for parts of the solution posted
so far.

Morten
