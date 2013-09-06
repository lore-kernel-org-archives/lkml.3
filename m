Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab3IFMUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 08:20:35 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36567 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab3IFMUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 08:20:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpufreq: serialize calls to __cpufreq_governor()
Date: Fri, 06 Sep 2013 14:31:24 +0200
Message-ID: <1793243.Kh0U858eu6@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5229704B.7010200@linux.vnet.ibm.com>
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org> <5227D65A.7040200@codeaurora.org> <5229704B.7010200@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 06, 2013 11:33:55 AM Srivatsa S. Bhat wrote:
> On 09/05/2013 06:24 AM, Stephen Boyd wrote:
> > On 09/04/13 17:26, Rafael J. Wysocki wrote:
> >> On Wednesday, September 04, 2013 04:50:01 PM Stephen Boyd wrote:
> >>> On 09/04/13 16:55, Rafael J. Wysocki wrote:
> >>>> Well, I'm not sure when Viresh is going to be back.
> >>>>
> >>>> Srivatsa, can you please resend this patch with a proper changelog?
> >>>>
> >>> I haven't had a chance to try this out yet, but I was just thinking
> >>> about this patch. How is it going to work? If one task opens the file
> >>> and another task is taking down the CPU wouldn't we deadlock in the
> >>> CPU_DOWN notifier waiting for the kobject to be released? Task 1 will
> >>> grab the kobject reference and sleep on the hotplug mutex and task 2
> >>> will put the kobject and wait for the completion, but it won't happen.
> >>> At least I think that's what would happen.
> >> Do you mean the completion in sysfs_deactivate()?  Yes, we can deadlock
> >> there.
> > 
> > I mean the complete in cpufreq_sysfs_release(). I don't think that will
> > ever be called because the kobject is held by the task calling store()
> > which is waiting on the hotplug lock to be released.
> > 
> >>
> >> Well, I guess the Srivatsa's patch may be salvaged by making it do a "trylock"
> >> version of get_online_cpus(), but then I wonder if there's no better way.
> > 
> > I think the real solution is to remove the kobject first if the CPU
> > going down is the last user of that policy. Once the completion is done
> > we can stop the governor and clean up state. For the case where there
> > are still CPUs using the policy why can't we cancel that CPU's work and
> > do nothing else? Even in the case where we have to move the cpufreq
> > directory do we need to do a STOP/START/LIMITS sequence? I hope we can
> > get away with just moving the directory and canceling that CPUs work then.
> > 
> 
> Conceptually, I agree that your idea of not allowing any process to take
> a new reference to the kobject while we are taking the CPU offline, is a
> sound solution.
> 
> However, I am reluctant to go down that path because, handling the CPU hotplug
> sequence in the suspend/resume path might get even more tricky, if we want
> to implement the changes that you propose. Just recently we managed to
> rework the cpufreq CPU hotplug handling to retain the sysfs file permissions
> around suspend/resume, and doing that was not at all simple. Adding more
> quirks and complexity to the kobject handling in that path will only make
> things even more challenging, IMHO. That's the reason I'm trying to think
> of ways to avoid touching that fragile code, and instead solve this problem
> in some other way, without compromising on the robustness of the solution.
> 
> So here is my new proposal, as a replacement to this patch[2/2]:

Actually, I've already applied patch [2/2], because while it doesn't solve the
whole problem, it narrows it down somewhat.  So, please work on top of that
patch going forward.

> We note that, at CPU_DOWN_PREPARE stage, the CPU is not yet marked offline,
> whereas by the time we handle CPU_POST_DEAD, the CPU is removed from the
> cpu_online_mask, and also the cpu_hotplug lock is dropped.
> 
> So, let us split up __cpu_remove_dev() into 2 parts, say:
> __cpu_remove_prepare() - invoked during CPU_DOWN_PREPARE
> __cpu_remove_finish()  - invoked during CPU_POST_DEAD
> 
> 
> In the former function, we stop the governors, so that policy->governor_enabled
> gets set to false, so that patch [1/2] will return -EBUSY to any subsequent
> ->store() requests. Also, we do everything except the kobject cleanup.
> 
> In the latter function, we do the remaining work, particularly the part
> where we wait for the kobject refcount to drop to zero and the subsequent
> cleanup.
> 
> 
> And the ->store() functions will be modified to look like this:
> 
> store()
> {
> 	get_online_cpus();
> 
> 	if (!cpu_online(cpu))
> 		goto out;
> 
> 	/* Body of the function*/
> out:
> 	put_online_cpus();
> }
> 
> That way, if a task tries to write to a cpufreq file during CPU offline,
> it will get blocked on get_online_cpus(), and will continue after
> CPU_DEAD (since we release the lock here). Then it will notice that the cpu
> is offline, and hence will return silently, thus dropping the kobject refcnt.
> So, when the cpufreq core comes back at the CPU_POST_DEAD stage to cleanup
> the kobject, it won't encounter any problems.
> 
> Any thoughts on this approach? I'll try to code it up and post the patch
> later today.

It sounds good to me (modulo the remark above).

Thanks,
Rafael

