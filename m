Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3KQA4Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 19:56:16 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54431 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751951Ab3KQA4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 19:56:07 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpufreq: suspend/resume governors with PM notifiers
Date: Sun, 17 Nov 2013 02:08:40 +0100
Message-ID: <6050176.zVNbf5pomE@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpok_zjdRVz5-ZGRmZtwysC7jORm2mgRbLWDUzo1ucYVKZg@mail.gmail.com>
References: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org> <2235672.LLJc6e6dny@vostro.rjw.lan> <CAKohpok_zjdRVz5-ZGRmZtwysC7jORm2mgRbLWDUzo1ucYVKZg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 16, 2013 08:47:24 PM Viresh Kumar wrote:
> On 16 November 2013 19:59, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> 
> > Well, disabling it for the whole duration of suspend/resume and/or hibernation
> > may not be the right approach entirely, unless we force the pax perf of the
> 
> s/pax/max ?

Yes.

> > boot CPU at least in addition to that.  Otherwise the latency of suspend and
> > the subsequent resume will depend on what perf level the CPUs where before
> > disabling the governors, which is not desirable at al.
> 
> Well that is pretty much doable.

Not necessarily on all CPU models.

> >> And these are the notifications that we send:
> >> - PM_HIBERNATION_PREPARE
> >> - PM_POST_HIBERNATION
> >> - PM_RESTORE_PREPARE
> >> - PM_POST_RESTORE
> >>
> >> If I am not wrong I need to stop governors on PM_HIBERNATION_PREPARE and need to
> >> start them back on: PM_POST_HIBERNATION (I am a bit confused with this one. Does
> >> this POST_HIBERNATION one happens at the end of going into hibernation? or after
> >> booting back? I need a notifier at the end of restore)..
> >
> > You'd need both PM_POST_HIBERNATION and PM_POST_RESTORE, but I wouldn't really
> > like cpufreq governors to be disabled throughout the whole hibernation.
> 
> So PM_POST_HIBERNATION is called just before shutting off the system? And
> PM_POST_RESTORE is called after system is resumed from saved image?

PM_POST_HIBERNATION is only called if there's an error during hibernation.
PM_POST_RESTORE is called as you said.

Also you have to remember that the _PREPARE PM notifiers are called before the
freezing of tasks when user space is still running, so disabling governors at
that point may lead to some weird behavior.

> > Actually, we use CPU offline/online during system suspend/resume to avoid
> > having to do stuff like this from PM notifiers.
> 
> I didn't get the logic behind this one..

If we have to do special stuff from PM notifiers for CPU "suspend", we will be
better off by doing something entirely special instead of CPU offline down the
road.  Which we may end up doing given the problems with frozen/not frozen in
the cpufreq core.

We may introduce suspend_noirq and resume_noirq for cpu_subsys, for example,
and handle things from there.  Or something similar.  But slapping PM notifiers
on top of the existing code just because it appears to be easy (and making that
code even more overdesigned than it already is this way) doesn't seem quite
right.

Now, the Tianyu's patch extends the Srivatsa's approach to governors, which
actually should have been done from the outset, so it is within the scope of
what we have already.  It may not solve all of the problems, but it still makes
some progress and has a little chance to introduce *new* problems at the same
time.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
