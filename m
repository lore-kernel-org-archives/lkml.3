Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052AbaAaSTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:19:30 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:39796 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528AbaAaST3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:19:29 -0500
Date: Fri, 31 Jan 2014 13:19:26 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        Preeti Murthy <preeti.lkml@gmail.com>, mingo@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct
 rq
In-Reply-To: <52EBC645.2040607@linux.intel.com>
Message-ID: <alpine.LFD.2.11.1401311236470.2312@knanqh.ubzr>
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org> <1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org> <20140130153150.GD5002@laptop.programming.kicks-ass.net> <52EA7D8A.6080604@linaro.org> <20140130163501.GG5002@laptop.programming.kicks-ass.net>
 <52EA8B07.6020206@linaro.org> <CAM4v1pPwmRUOtNeGh5sZmj+wAsC8RstofNA5Gx862SEECvW-Lg@mail.gmail.com> <20140131090230.GM5002@laptop.programming.kicks-ass.net> <52EB6F65.8050008@linux.vnet.ibm.com> <52EBBC23.8020603@linux.intel.com> <52EBC33A.6080101@linaro.org>
 <52EBC645.2040607@linux.intel.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014, Arjan van de Ven wrote:

> On 1/31/2014 7:37 AM, Daniel Lezcano wrote:
> > On 01/31/2014 04:07 PM, Arjan van de Ven wrote:
> > > > > >
> > > > > > Hence I think this patch would make sense only with additional
> > > > > > information
> > > > > > like exit_latency or target_residency is present for the scheduler.
> > > > > > The idle
> > > > > > state index alone will not be sufficient.
> > > > >
> > > > > Alternatively, can we enforce sanity on the cpuidle infrastructure to
> > > > > make the index naturally ordered? If not, please explain why :-)
> > > >
> > > > The commit id 71abbbf856a0e70 says that there are SOCs which could have
> > > > their target_residency and exit_latency values change at runtime. This
> > > > commit thus removed the ordering of the idle states according to their
> > > > target_residency/exit_latency. Adding Len and Arjan to the CC.
> > >
> > > the ARM folks wanted a dynamic exit latency, so.... it makes much more
> > > sense
> > > to me to store the thing you want to use (exit latency) than the number
> > > of the state.
> > >
> > > more than that, you can order either by target residency OR by exit
> > > latency,
> > > if you sort by one, there is no guarantee that you're also sorted by the
> > > other
> >
> > IMO, it would be preferable to store the index for the moment as we are
> > integrating cpuidle with the scheduler. The index allows to access more
> > informations. Then when
> > everything is fully integrated we can improve the result, no ?
> 
> more information, yes. but if the information isn't actually accurate (because
> it keeps changing
> in the datastructure away from what it was for the cpu)... are you really
> achieving what you want?

Right now (on ARM at least but I imagine this is pretty universal), the 
biggest impact on information accuracy for a CPU depends on what the 
other CPUs are doing.  The most obvious example is cluster power down.  
For a cluster to be powered down, all the CPUs sharing this cluster must 
also be powered down.  And all those CPUs must have agreed to a possible 
cluster power down in advance as well.  But it is not because an idle 
CPU has agreed to the extra latency imposed by a cluster power down that 
the cluster has actually powered down since another CPU in that cluster 
might still be running, in which case the recorded latency information 
for that idle CPU would be higher than it would be in practice at that 
moment.

A cluster should map naturally to a scheduling domain.  If we need to 
wake up a CPU, it is quite obvious that we should prefer an idle CPU 
from a scheduling domain which load is not zero.  If the load is not 
zero then this means that any idle CPU in that domain, even if it 
indicated it was ready for a cluster power down, will not require the 
cluster power-up latency as some other CPUs must still be running.  But 
we already know that of course even if the recorded latency might not 
say so.

In other words, the hardware latency information is dynamic of course.  
But we might not _need_ to have it reflected at the scheduler domain all 
the time as in this case it can be inferred by the scheduling domain 
load.

Within a scheduling domain it is OK to pick up the best idle CPU by 
looking at the index as it is best to leave those CPUs ready for a 
cluster power down set to that state and prefer one which is not.  And a 
scheduling domain with a load of zero should be left alone if idle CPUs 
are found in another domain which load is not zero, irrespective of 
absolute latency information. So all the existing heuristics already in 
place to optimize cache utilization and so on will make things just work 
for idle as well.

All this to say that it is not justified at the moment to worry about 
how to convey the full details to the scheduler and the complexity that 
goes with it since in practice we might be able to achieve our goal just 
as well using simpler hints like some arbitrary index.  Once this is in 
place, then we could look at the actual benefits from having more 
detailed information and weight that against the complexity that comes 
with it.


Nicolas
