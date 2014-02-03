Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbaBCMy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 07:54:56 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:25710 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750967AbaBCMyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 07:54:54 -0500
Date: Mon, 3 Feb 2014 12:54:41 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        Preeti Murthy <preeti.lkml@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct rq
Message-ID: <20140203125441.GD19029@e103034-lin>
References: <52EA7D8A.6080604@linaro.org>
 <20140130163501.GG5002@laptop.programming.kicks-ass.net>
 <52EA8B07.6020206@linaro.org>
 <CAM4v1pPwmRUOtNeGh5sZmj+wAsC8RstofNA5Gx862SEECvW-Lg@mail.gmail.com>
 <20140131090230.GM5002@laptop.programming.kicks-ass.net>
 <52EB6F65.8050008@linux.vnet.ibm.com>
 <52EBBC23.8020603@linux.intel.com>
 <52EBC33A.6080101@linaro.org>
 <52EBC645.2040607@linux.intel.com>
 <alpine.LFD.2.11.1401311236470.2312@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1401311236470.2312@knanqh.ubzr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 06:19:26PM +0000, Nicolas Pitre wrote:
> Right now (on ARM at least but I imagine this is pretty universal), the 
> biggest impact on information accuracy for a CPU depends on what the 
> other CPUs are doing.  The most obvious example is cluster power down.  
> For a cluster to be powered down, all the CPUs sharing this cluster must 
> also be powered down.  And all those CPUs must have agreed to a possible 
> cluster power down in advance as well.  But it is not because an idle 
> CPU has agreed to the extra latency imposed by a cluster power down that 
> the cluster has actually powered down since another CPU in that cluster 
> might still be running, in which case the recorded latency information 
> for that idle CPU would be higher than it would be in practice at that 
> moment.
> 
> A cluster should map naturally to a scheduling domain.  If we need to 
> wake up a CPU, it is quite obvious that we should prefer an idle CPU 
> from a scheduling domain which load is not zero.  If the load is not 
> zero then this means that any idle CPU in that domain, even if it 
> indicated it was ready for a cluster power down, will not require the 
> cluster power-up latency as some other CPUs must still be running.  But 
> we already know that of course even if the recorded latency might not 
> say so.
> 
> In other words, the hardware latency information is dynamic of course.  
> But we might not _need_ to have it reflected at the scheduler domain all 
> the time as in this case it can be inferred by the scheduling domain 
> load.

I agree that the existing sched domain hierarchy should be used to
represent the power topology. But, it is not clear to me how much we can say
about the C-state of cpu without checking the load of the entire cluster
every time?

We would need to know which C-states (index) that are per cpu and per
cluster and ignore the cluster states when the cluster load is non-zero.

Current sched domain load is not maintained in the scheduler, it is only
produced when needed. But I guess you could derive the necessary
information from the idle cpu masks.

> 
> Within a scheduling domain it is OK to pick up the best idle CPU by 
> looking at the index as it is best to leave those CPUs ready for a 
> cluster power down set to that state and prefer one which is not.  And a 
> scheduling domain with a load of zero should be left alone if idle CPUs 
> are found in another domain which load is not zero, irrespective of 
> absolute latency information. So all the existing heuristics already in 
> place to optimize cache utilization and so on will make things just work 
> for idle as well.

IIUC, you propose to only use the index when picking an idle cpu inside
an already busy sched domain and leave idle sched domains alone if
possible. It may work for homogeneous SMP systems, but I don't think it
will work for heterogeneous systems like big.LITTLE.

If the little cluster has zero load and the big has stuff running, it
doesn't mean that it is a good idea to wake up another big cpu. It may
be more power efficient to wake up the little cluster. Comparing idle
state index of a big and little cpu won't help us in making that choice
as the clusters may have different idle states and the costs associated
with each state are different.

I'm therefore not convinced that idle state index is the right thing to
give the scheduler. Using a cost metric would be better in my
opinion.

Morten

