Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3HaAsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 20:48:47 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60871 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752682Ab3HaAsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 20:48:45 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: mutex warning in cpufreq + RFC patch
Date: Sat, 31 Aug 2013 02:59:31 +0200
Message-ID: <41768242.uCD68eUKhK@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2143062.PTWIfM6mhl@vostro.rjw.lan>
References: <20130828025721.GA19754@codeaurora.org> <20130831003641.GE19754@codeaurora.org> <2143062.PTWIfM6mhl@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 31, 2013 02:55:57 AM Rafael J. Wysocki wrote:
> On Friday, August 30, 2013 05:36:41 PM Stephen Boyd wrote:
> > On 08/29, Viresh Kumar wrote:
> > > On 28 August 2013 22:22, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > > >
> > > > I've applied these patches on top of v3.10
> > > >
> > > > f51e1eb63d9c28cec188337ee656a13be6980cfd (cpufreq: Fix cpufreq regression after suspend/resume
> > > > aae760ed21cd690fe8a6db9f3a177ad55d7e12ab (cpufreq: Revert commit a66b2e to fix suspend/resume regression)
> > > > e8d05276f236ee6435e78411f62be9714e0b9377 (cpufreq: Revert commit 2f7021a8 to fix CPU hotplug regression)
> > > > 2a99859932281ed6c2ecdd988855f8f6838f6743 (cpufreq: Fix cpufreq driver module refcount balance after suspend/resume)
> > > > 419e172145cf6c51d436a8bf4afcd17511f0ff79 (cpufreq: don't leave stale policy pointer in cdbs->cur_policy)
> > > > 95731ebb114c5f0c028459388560fc2a72fe5049 (cpufreq: Fix governor start/stop race condition)
> > > >
> > > > That second to last one causes a NULL pointer exception after the mutex
> > > > warning above because the limits case does
> > > >
> > > >     if (policy->max < cpu_cdbs->cur_policy->cur)
> > > >
> > > > and that dereferences a NULL cur_policy pointer.
> > > 
> > > I have seen something similar and the error checking patch that
> > > I mentioned earlier came as solution to that only..
> > 
> > Yes that patch may reduce the chance of the race condition but I
> > don't believe it removes it entirely. I believe this bug still
> > exists in linux-next. Consider the scenario where CPU1 is going
> > down.
> > 
> > __cpufreq_remove_dev()
> >  ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> >   __cpufreq_governor()
> >    policy->governor->governor(policy, CPUFREQ_GOV_STOP);
> >     cpufreq_governor_dbs()
> >      case CPUFREQ_GOV_STOP:
> >       mutex_destroy(&cpu_cdbs->timer_mutex)
> >       cpu_cdbs->cur_policy = NULL;
> >   <PREEMPT>
> > store()
> >  __cpufreq_set_policy()
> >   ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
> >    __cpufreq_governor()
> >     policy->governor->governor(policy, CPUFREQ_GOV_LIMITS);
> >      case CPUFREQ_GOV_LIMITS:
> >       mutex_lock(&cpu_cdbs->timer_mutex); <-- Warning (destroyed mutex)
> >        if (policy->max < cpu_cdbs->cur_policy->cur) <- cur_policy == NULL
> > 
> > Once we stop the governor I don't see how another thread can't
> > race in and get all the way down into the GOV_LIMITS case. Even
> > if we wanted to lock out that thread with some mutex or semaphore
> > it will have to continue running eventually and so we really need
> > to wait until all the sysfs files are gone before we stop the
> > governor (in the case of the last cpu for the policy) or we need
> > to stop and start the governor while holding the policy semaphore
> > to prevent a race.
> > 
> > > 
> > > > Are there any fixes that I'm missing? I see that some things are
> > > > changing in linux-next but they don't look like fixes, more like
> > > > optimizations.
> > > 
> > > Getting patches over 3.10 would be tricky.. You are two kernel
> > > version back and that's not going to help much.. There are too many
> > > patches in between linux-next and 3.10..
> > >
> > > 
> > > I really can't tell you which specific ones to include, as I am lost in them :)
> > 
> > That's a problem. 3.10 is the next long term stable kernel and so we need to
> > backport any fixes to 3.10 for the next two years. Hopefully these bugs I'm
> > finding in the 3.10 stable kernel's cpufreq code aren't known issues on
> > 3.11/next.
> 
> No, they aren't.
> 
> Well, that's the main reason why I've been pushing back against more churn in
> the cpuidle subsystem recently.  I think we went too far with changes that
> were not entirely understood and now we're seeing the fallout.

s/cpuidle/cpufreq/

Apparently, I'm already too tired.

