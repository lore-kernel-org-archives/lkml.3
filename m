Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab3HASvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 14:51:49 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50878 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab3HASvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 14:51:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH] cpufreq: Do not hold driver module references for additional policy CPUs
Date: Thu, 01 Aug 2013 21:01:59 +0200
Message-ID: <1656801.jLHjvytfNU@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51FAA3B9.7040009@linux.vnet.ibm.com>
References: <2362640.pUofnXyzOi@vostro.rjw.lan> <1864010.r8gSosnm8c@vostro.rjw.lan> <51FAA3B9.7040009@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 01, 2013 11:36:49 PM Srivatsa S. Bhat wrote:
> On 08/01/2013 11:34 PM, Rafael J. Wysocki wrote:
> > On Thursday, August 01, 2013 08:54:59 PM Srivatsa S. Bhat wrote:
> >> On 08/01/2013 08:14 PM, Viresh Kumar wrote:
> >>> On 1 August 2013 13:41, Srivatsa S. Bhat
> >>> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> >>>> On 08/01/2013 05:38 AM, Rafael J. Wysocki wrote:
> >>>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>>>>
> >>>>> The cpufreq core is a little inconsistent in the way it uses the
> >>>>> driver module refcount.
> >>>>>
> >>>>> Namely, if __cpufreq_add_dev() is called for a CPU without siblings
> >>>>> or generally a CPU for which a new policy object has to be created,
> >>>>> it grabs a reference to the driver module to start with, but drops
> >>>>> that reference before returning.  As a result, the driver module
> >>>>> refcount is then equal to 0 after __cpufreq_add_dev() has returned.
> >>>>>
> >>>>> On the other hand, if the given CPU is a sibling of some other
> >>>>> CPU already having a policy, cpufreq_add_policy_cpu() is called
> >>>>> to link the new CPU to the existing policy.  In that case,
> >>>>> cpufreq_cpu_get() is called to obtain that policy and grabs a
> >>>>> reference to the driver module, but that reference is not
> >>>>> released and the module refcount will be different from 0 after
> >>>>> __cpufreq_add_dev() returns (unless there is an error).  That
> >>>>> prevents the driver module from being unloaded until
> >>>>> __cpufreq_remove_dev() is called for all the CPUs that
> >>>>> cpufreq_add_policy_cpu() was called for previously.
> >>>>>
> >>>>> To remove that inconsistency make cpufreq_add_policy_cpu() execute
> >>>>> cpufreq_cpu_put() for the given policy before returning, which
> >>>>> decrements the driver module refcount so that it will be 0 after
> >>>>> __cpufreq_add_dev() returns,
> >>>>
> >>>> Removing the inconsistency is a good thing, but I think we should
> >>>> make it consistent the other way around - make a CPU-online increment
> >>>> the driver module refcount and decrement it only on CPU-offline.
> >>>
> >>> I took time to review to this mail as I was looking at the problem
> >>> yesterday. I am sorry to say, but I have completely different views as
> >>> compared to You and Rafael both :)
> >>>
> >>> First of all, Rafael's patch is incomplete as it hasn't fixed the issue
> >>> completely. When we have multiple CPUs per policy and
> >>> cpufreq_add_dev() is called for the first one, it call cpufreq_get_cpu()
> >>> for all cpus of this policy(), so count is == x (no. of CPUs in this policy)
> >>> + 1 (This is the initial value of .owner).
> >>>
> >>> And so we still have module count getting incremented for other cpus :)
> >>>
> >>
> >> Good catch!
> > 
> > Sorry, I don't see how this happens.
> > 
> > __cpufreq_add_dev() only directly calls cpufreq_cpu_get() at the beginning to
> > check if the policy is there and then immediately calls cpufreq_cpu_put() in
> > that case (for that policy).
> > 
> > Next, cpufreq_add_policy_cpu() calls cpufreq_cpu_get(), but that's what my
> > patch changes.
> > 
> > I don't see where else cpufreq_cpu_get() is called by __cpufreq_add_dev()
> > whether directly or indirectly.
> >
> 
> __cpufreq_add_dev()->cpufreq_add_dev_interface()->cpufreq_add_dev_symlink().

Ah, OK, thanks!

> The last one does:
> 
>  815         for_each_cpu(j, policy->cpus) {
>  816                 struct cpufreq_policy *managed_policy;
>  817                 struct device *cpu_dev;
>  818 
>  819                 if (j == cpu)
>  820                         continue;
>  821 
>  822                 pr_debug("CPU %u already managed, adding link\n", j);
>  823                 managed_policy = cpufreq_cpu_get(cpu);
>  824                 cpu_dev = get_cpu_device(j);
>  825                 ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
>  826                                         "cpufreq");
> 		     ...
> 	     }

And when do we drop this one?

> > Moreover, if I'm completely wrong and it is called there in an invisible
> > hush-hush way, it has to be explained why the module usage count as printed by
> > lsmod for acpi-cpufreq is 0 (in current linux-next).
> >
> 
> Perhaps because none of your policies have more than one CPU associated
> with it? I think related_cpus should be able to tell us that..

Yes, that's the case.

> But yes, it is a little hidden and moreover, we don't take the refcount if
> there is only one CPU in the mask. Which is a little inconsistent, IMHO.

Well, I obviously agree.

> >>> Now few lines about My point of view to this whole thing. I believe we
> >>> should get rid of .owner field from struct cpufreq_driver completely. It
> >>> doesn't make sense to me in doing all this management at all. Surprised?
> >>> Shocked? Laughing at me? :)
> >>>
> >>> Well I may be wrong but this is what I think:
> >>> - It looks stupid to me that I can't do this from userspace in one go:
> >>>   $ insmod cpufreq_driver.ko
> >>>   $ rmmod cpufreq_driver.ko
> >>>
> >>> What the hell changed in between that isn't visible to user? It looked
> >>> completely stupid in that way..
> >>>
> >>> Something like this sure makes sense:
> >>> $ insmod ondemand-governor.ko
> >>> $ change governor to ondemand for few CPUs
> >>> $ rmmod ondemand-governor.ko
> >>>
> >>> as we have deliberately add few users of governor. And so without second
> >>> step, rmmod should really work smoothly. And it does.
> >>>
> >>> Now, why shouldn't there be a problem with this approach? I will write
> >>> that inline to the problems you just described.
> >>>
> >>>> The reason is, one should not be able to unload the back-end cpufreq
> >>>> driver module when some CPUs are still being managed. Nasty things
> >>>> will result if we allow that. For example, if we unload the module,
> >>>> and then try to do a CPU offline, then the cpufreq hotplug notifier
> >>>> won't even be called (because cpufreq_unregister_driver also
> >>>> unregisters the hotplug notifier). And that might be troublesome.
> >>>
> >>> So what? Its simply equivalent to we have booted our system, haven't
> >>> inserted cpufreq module and taken out a cpu.
> > 
> > I'd put that differently.
> > 
> > With the current code as is it may cause problems to happen, but there are
> > two ways to change that in general:
> > 
> > (1) Disallow the removal of the cpufreq driver while there are any users, but
> >     for that we only need the driver to be refcounted *once* when a new policy
> >     is created (and not as many times as there are CPUs using that policy).
> >     Then, the reference can be dropped while removing the policy object.
> > 
> > (2) Allow the removal of the cpufreq driver, but harden the code against
> >     that.  [Maybe it doesn't have to be hardened any more as is, I haven't
> >     checked that.]
> > 
> > I agree with Viresh that (1) is kind of weird from the usability perspective,
> > because if we did that, it wouldn't be practically possible to remove cpufreq
> > driver modules after loading them (cpuidle currently has that problem).
> >
> 
> Yes, I think we can go with Viresh's approach and use plain locking to
> synchronize things. Returning -EBUSY isn't really beneficial, since the
> critical sections are small and finite - its not like the user has to wait
> a long time to rmmod the module if we use locking.

Agreed.

> >>>> Even worse, if we unload a cpufreq driver module and load a new
> >>>> one and *then* try to offline the CPU, then the cpufreq_driver->exit()
> >>>> function that we call during CPU offline will end up calling the
> >>>> corresponding function of an entirely different driver! So the
> >>>> ->init() and ->exit() calls won't match.
> >>>
> >>> That's not true. When we unload the module, it must call
> >>> cpufreq_unregister_driver() which should call cpufreq_remove_cpu()
> >>> for all cpus and so exit() is already called for last module.
> >>>
> >>
> >> Sorry, I missed this one.
> >>
> >>> If we get something new now, it should simply work.
> >>>
> >>
> >> Yeah, I now see your point. It won't create any problems by
> >> unloading the module and loading a new one.
> >>
> >>> What do you think gentlemen?
> >>>
> >>
> >> Well, I now agree that we don't have to keep the module refcount
> >> non-zero as long as CPUs are being managed (that was just my
> >> misunderstanding, sorry for the noise). However, I think the _get()
> >> and _put() used in the existing code is for synchronization: that
> >> is, to avoid races between trying to unload the cpufreq driver
> >> module and running a hotplug notifier (and calling the driver module's
> >> ->init() or ->exit() function).
> >>
> >> With that being the case, I think we can retain the module refcounts
> >> and use them only for synchronization. And naturally the refcount
> >> should drop to zero after the critical section; no point keeping
> >> it incremented until the CPU is taken offline.
> >>
> >> Or, am I confused again?
> > 
> > No, I don't think so.
> > 
> > In fact, the point of my patch was to make the module refcount stay 0
> > beyond critical sections, but it looks like I overlooked something.  What is
> > that?
> > 
> 
> Its the cpufreq_cpu_get() hidden away in cpufreq_add_dev_symlink(). With
> that taken care of, everything should be OK. Then we can change the
> synchronization part to avoid using refcounts.

So I actually don't see why cpufreq_add_dev_symlink() needs to call
cpufreq_cpu_get() at all, since the policy refcount is already 1 at the
point it is called and the bumping up of the driver module refcount is
pointless.

However, if I change that I also need to change the piece of code that
calls the complementary cpufreq_cpu_put() and I kind of cannot find it.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
