Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab3KQO5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 09:57:12 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54466 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752891Ab3KQO5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 09:57:04 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpufreq: suspend/resume governors with PM notifiers
Date: Sun, 17 Nov 2013 16:09:40 +0100
Message-ID: <5974906.WAPp3f3eVY@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52887CB7.4000108@linaro.org>
References: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org> <6050176.zVNbf5pomE@vostro.rjw.lan> <52887CB7.4000108@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 17, 2013 01:52:15 PM viresh kumar wrote:
> On Sunday 17 November 2013 06:38 AM, Rafael J. Wysocki wrote:
> > On Saturday, November 16, 2013 08:47:24 PM Viresh Kumar wrote:
> >> Well that is pretty much doable.
> > 
> > Not necessarily on all CPU models.
> 
> Okay.. Just for my understanding, why?

If the graphics and processor are in one chip, the CPU may ignore your
perf bump up request for power balancing reasons.

> >> So PM_POST_HIBERNATION is called just before shutting off the system? And
> >> PM_POST_RESTORE is called after system is resumed from saved image?
> > 
> > PM_POST_HIBERNATION is only called if there's an error during hibernation.
> > PM_POST_RESTORE is called as you said.
> 
> Ahh I see. Thanks.
> 
> > Also you have to remember that the _PREPARE PM notifiers are called before the
> > freezing of tasks when user space is still running, so disabling governors at
> > that point may lead to some weird behavior.
> 
> Actually good point. I haven't thought about it earlier.
> 
> And when I see what bad can happen, I couldn't find much. The worst is that we
> wouldn't go to a frequency requested by userspace daemon. But we wouldn't send
> an error then. But I feel we can let that happen. Not servicing a request after
> we have started system suspend doesn't look that odd..
> 
> Sysfs infrastructure is still preserved and so all that information would still
> be available.
> 
> Do you see anything extra that might stop working?

Well, the code would be racy with the patch as is.  User space might manipulate
the sysfs knobs in parallel with your PM notifiers, for example, and I'm not
entirely sure what can happen then.  And the lock in there is pointless,
because it doesn't prevent any races from happening.

> >>> Actually, we use CPU offline/online during system suspend/resume to avoid
> >>> having to do stuff like this from PM notifiers.
> >>
> >> I didn't get the logic behind this one..
> > 
> > If we have to do special stuff from PM notifiers for CPU "suspend", we will be
> > better off by doing something entirely special instead of CPU offline down the
> > road.  Which we may end up doing given the problems with frozen/not frozen in
> > the cpufreq core.
> 
> A unrelated question here. Why are we offlining CPUs after suspending all the
> devices? Because the problem Nishanth mentioned was that he required few
> devices, i2c, to be available when CPUs are getting down. And there might be
> similar requirements at other places too. Was there any specific bottleneck due
> to which it is implemented this way?

No, this is because the ACPI spec mandates powering down devices before CPUs
during system suspend.  The way it is done today, however, I think we don't
need to keep that ordering so strictly any more.  We definitely don't need to
do that on non-ACPI systems.

So while I hate the PM notifiers idea (sorry, but that's how it goes), I think
it would be OK to suspend *some* devices after disabling CPUs (not all of them,
of course).

And as I said, I think it would be OK to introduce suspend/resume callbacks for
CPU devices and use those callbacks to work around the ordering issues, when
necessary.  The main point is that the changes made for this purpose should
only affect systems where they are necessary and not everyone.  I don't want
to change the way things work today in general in cpufreq too much unless they
are plain bugs that affect everyone.

> > We may introduce suspend_noirq and resume_noirq for cpu_subsys, for example,
> > and handle things from there.  Or something similar.  But slapping PM notifiers
> > on top of the existing code just because it appears to be easy (and making that
> > code even more overdesigned than it already is this way) doesn't seem quite
> > right.
> > 
> > Now, the Tianyu's patch extends the Srivatsa's approach to governors, which
> > actually should have been done from the outset, so it is within the scope of
> > what we have already.  It may not solve all of the problems, but it still makes
> > some progress and has a little chance to introduce *new* problems at the same
> > time.
> 
> I understand your point here. But this is what I feel:
> 
> - I don't have any special affection for using PM notifiers :) .. Its just that
> I need some way for cpufreq core to know that Suspend has started. Maybe after
> freezing of tasks and before removal of devices.
> 
> - I thought of adding something like a suspend-prepare for syscore_ops (You are
> owner of all these frameworks and so our life is easy as we can discuss stuff
> with you directly :)).. But then thought maybe we can use PM notifiers.. But it
> looks that we better do that now ?
> 
> - I have concerns with Tianyu's patch as policies should be better taken care of
> in cpufreq core instead of passing them over to governors.

Well, this is all too tangled anyway, but quite frankly I'm not sure if it is
worth untangling at this point.  We're deprecating cpufreq anyway.

> And with the alternative solution I had, code is getting more and more dirty.
> And so I thought of doing something else.
> 
> - Not all platforms have problem with changing frequency during suspend/resume
> and so we may not require disabling of governors for all of them. Probably can
> add another field based on which we may/may-not disable governors from PM or
> syscore notifiers.

What exactly is wrong with adding suspend/resume callbacks to cpu_subsys?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
