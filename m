Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbaDBDOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 23:14:38 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:42660 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364AbaDBDOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 23:14:36 -0400
Date: Tue, 1 Apr 2014 23:14:33 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 0/3] sched/idle : find the idlest cpu with cpuidle
 info
In-Reply-To: <22904760.5rGZuP5nsx@vostro.rjw.lan>
Message-ID: <alpine.LFD.2.11.1404012141580.1571@knanqh.ubzr>
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org> <22904760.5rGZuP5nsx@vostro.rjw.lan>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2014, Rafael J. Wysocki wrote:

> On Friday, March 28, 2014 01:29:53 PM Daniel Lezcano wrote:
> > The following patchset provides an interaction between cpuidle and the scheduler.
> > 
> > The first patch encapsulate the needed information for the scheduler in a
> > separate cpuidle structure. The second one stores the pointer to this structure
> > when entering idle. The third one, use this information to take the decision to
> > find the idlest cpu.
> > 
> > After some basic testing with hackbench, it appears there is an improvement for
> > the performances (small) and for the duration of the idle states (which provides
> > a better power saving).
> > 
> > The measurement has been done with the 'idlestat' tool previously posted in this
> > mailing list.
> > 
> > So the benefit is good for both sides performance and power saving.
> > 
> > The select_idle_sibling could be also improved in the same way.
> 
> Well, quite frankly, I don't really like this series.  Not the idea itself, but
> the way it has been implemented.
> 
> First off, if the scheduler is to access idle state data stored in struct
> cpuidle_state, I'm not sure why we need a separate new structure for that?
> Couldn't there be a pointer to a whole struct cpuidle_state from struct rq
> instead?  [->exit_latency is the only field that find_idlest_cpu() in your
> third patch seems to be using anyway.]

Future patches are likely to use the other fields.  I presume that's why 
Daniel put them there.

But I admit being on the fence about this i.e whether or not we should 
encapsulate shared fields into a separate structure or not.

> Second, is accessing the idle state information for all CPUs from find_idlest_cpu()
> guaranteed to be non-racy?  I mean, what if a CPU changes its state from idle to
> non-idle while another one is executing find_idlest_cpu()?  In other words,
> where's the read memory barrier corresponding to the write ones in the modified
> cpu_idle_call()?  And is the memory barrier actually sufficient?  After all,
> you need to guarantee that the CPU is still idle after you have evaluated
> idle_cpu() on it.

I don't think avoiding races is all that important here.  Right now any 
idle CPU is selected regardless of its idle state depth.  What this 
patch should do (considering my previous comments on it) is to favor the 
idle CPU with the shalloest idle state.  If once in a while the 
selection is wrong because of a race we're not going to make it any 
worse than what we have today without this patch.

That probably means the write barrier could potentially be omitted as 
well if it implies a useless cost.

We need to ensure the cpuidle data structure is not going away (e.g. 
cpuidle driver module removal) while another CPU looks at it though.  
The timing would have to be awfully weird for this to happen but still.

> Finally, is really the heuristics used by find_idlest_cpu() to select the "idlest"
> CPU the best one?  What about deeper vs shallower idle states, for example?

That's what this patch series is about.  The find_idlest_cpu code should 
look for the idle CPU with the shallowest idle state, or the one with 
the smallest load.  In this context "find_idlest_cpu" might become a 
misnomer.


Nicolas
