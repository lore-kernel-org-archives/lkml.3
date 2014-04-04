Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaDDL1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 07:27:09 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62932 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752597AbaDDL1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 07:27:08 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 0/3] sched/idle : find the idlest cpu with cpuidle info
Date: Fri, 04 Apr 2014 13:43 +0200
Message-ID: <1930679.LtC4HPqI3x@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.LFD.2.11.1404012141580.1571@knanqh.ubzr>
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org> <22904760.5rGZuP5nsx@vostro.rjw.lan> <alpine.LFD.2.11.1404012141580.1571@knanqh.ubzr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 01, 2014 11:14:33 PM Nicolas Pitre wrote:
> On Wed, 2 Apr 2014, Rafael J. Wysocki wrote:
> 
> > On Friday, March 28, 2014 01:29:53 PM Daniel Lezcano wrote:
> > > The following patchset provides an interaction between cpuidle and the scheduler.
> > > 
> > > The first patch encapsulate the needed information for the scheduler in a
> > > separate cpuidle structure. The second one stores the pointer to this structure
> > > when entering idle. The third one, use this information to take the decision to
> > > find the idlest cpu.
> > > 
> > > After some basic testing with hackbench, it appears there is an improvement for
> > > the performances (small) and for the duration of the idle states (which provides
> > > a better power saving).
> > > 
> > > The measurement has been done with the 'idlestat' tool previously posted in this
> > > mailing list.
> > > 
> > > So the benefit is good for both sides performance and power saving.
> > > 
> > > The select_idle_sibling could be also improved in the same way.
> > 
> > Well, quite frankly, I don't really like this series.  Not the idea itself, but
> > the way it has been implemented.
> > 
> > First off, if the scheduler is to access idle state data stored in struct
> > cpuidle_state, I'm not sure why we need a separate new structure for that?
> > Couldn't there be a pointer to a whole struct cpuidle_state from struct rq
> > instead?  [->exit_latency is the only field that find_idlest_cpu() in your
> > third patch seems to be using anyway.]
> 
> Future patches are likely to use the other fields.  I presume that's why 
> Daniel put them there.
> 
> But I admit being on the fence about this i.e whether or not we should 
> encapsulate shared fields into a separate structure or not.

Quite frankly, I don't see a point in using a separate structure here.

> > Second, is accessing the idle state information for all CPUs from find_idlest_cpu()
> > guaranteed to be non-racy?  I mean, what if a CPU changes its state from idle to
> > non-idle while another one is executing find_idlest_cpu()?  In other words,
> > where's the read memory barrier corresponding to the write ones in the modified
> > cpu_idle_call()?  And is the memory barrier actually sufficient?  After all,
> > you need to guarantee that the CPU is still idle after you have evaluated
> > idle_cpu() on it.
> 
> I don't think avoiding races is all that important here.  Right now any 
> idle CPU is selected regardless of its idle state depth.  What this 
> patch should do (considering my previous comments on it) is to favor the 
> idle CPU with the shalloest idle state.  If once in a while the 
> selection is wrong because of a race we're not going to make it any 
> worse than what we have today without this patch.
> 
> That probably means the write barrier could potentially be omitted as 
> well if it implies a useless cost.

Yes, the write barriers don't seem to serve any real purpose.

> We need to ensure the cpuidle data structure is not going away (e.g. 
> cpuidle driver module removal) while another CPU looks at it though.  
> The timing would have to be awfully weird for this to happen but still.

Well, I'm not sure if that is a real concern.  Only a couple of drivers try
to implement module unloading and I guess this isn't tested too much, so
perhaps we should just make it impossible to unload a cpuidle driver?

> > Finally, is really the heuristics used by find_idlest_cpu() to select the "idlest"
> > CPU the best one?  What about deeper vs shallower idle states, for example?
> 
> That's what this patch series is about.  The find_idlest_cpu code should 
> look for the idle CPU with the shallowest idle state, or the one with 
> the smallest load.  In this context "find_idlest_cpu" might become a 
> misnomer.

Yes, clearly.  It should be called find_best_cpu or something like that.

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
