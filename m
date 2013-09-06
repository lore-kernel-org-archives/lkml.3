Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750842Ab3IFGH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 02:07:57 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:58638 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3IFGHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 02:07:55 -0400
Message-ID: <5229704B.7010200@linux.vnet.ibm.com>
Date: Fri, 06 Sep 2013 11:33:55 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpufreq: serialize calls to __cpufreq_governor()
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org> <1706734.hVYFTCa5rJ@vostro.rjw.lan> <5227C729.5040803@codeaurora.org> <16630296.tCCMEKstkO@vostro.rjw.lan> <5227D65A.7040200@codeaurora.org>
In-Reply-To: <5227D65A.7040200@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090606-8256-0000-0000-0000091C3F8D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 06:24 AM, Stephen Boyd wrote:
> On 09/04/13 17:26, Rafael J. Wysocki wrote:
>> On Wednesday, September 04, 2013 04:50:01 PM Stephen Boyd wrote:
>>> On 09/04/13 16:55, Rafael J. Wysocki wrote:
>>>> Well, I'm not sure when Viresh is going to be back.
>>>>
>>>> Srivatsa, can you please resend this patch with a proper changelog?
>>>>
>>> I haven't had a chance to try this out yet, but I was just thinking
>>> about this patch. How is it going to work? If one task opens the file
>>> and another task is taking down the CPU wouldn't we deadlock in the
>>> CPU_DOWN notifier waiting for the kobject to be released? Task 1 will
>>> grab the kobject reference and sleep on the hotplug mutex and task 2
>>> will put the kobject and wait for the completion, but it won't happen.
>>> At least I think that's what would happen.
>> Do you mean the completion in sysfs_deactivate()?  Yes, we can deadlock
>> there.
> 
> I mean the complete in cpufreq_sysfs_release(). I don't think that will
> ever be called because the kobject is held by the task calling store()
> which is waiting on the hotplug lock to be released.
> 
>>
>> Well, I guess the Srivatsa's patch may be salvaged by making it do a "trylock"
>> version of get_online_cpus(), but then I wonder if there's no better way.
> 
> I think the real solution is to remove the kobject first if the CPU
> going down is the last user of that policy. Once the completion is done
> we can stop the governor and clean up state. For the case where there
> are still CPUs using the policy why can't we cancel that CPU's work and
> do nothing else? Even in the case where we have to move the cpufreq
> directory do we need to do a STOP/START/LIMITS sequence? I hope we can
> get away with just moving the directory and canceling that CPUs work then.
> 

Conceptually, I agree that your idea of not allowing any process to take
a new reference to the kobject while we are taking the CPU offline, is a
sound solution.

However, I am reluctant to go down that path because, handling the CPU hotplug
sequence in the suspend/resume path might get even more tricky, if we want
to implement the changes that you propose. Just recently we managed to
rework the cpufreq CPU hotplug handling to retain the sysfs file permissions
around suspend/resume, and doing that was not at all simple. Adding more
quirks and complexity to the kobject handling in that path will only make
things even more challenging, IMHO. That's the reason I'm trying to think
of ways to avoid touching that fragile code, and instead solve this problem
in some other way, without compromising on the robustness of the solution.

So here is my new proposal, as a replacement to this patch[2/2]:

We note that, at CPU_DOWN_PREPARE stage, the CPU is not yet marked offline,
whereas by the time we handle CPU_POST_DEAD, the CPU is removed from the
cpu_online_mask, and also the cpu_hotplug lock is dropped.

So, let us split up __cpu_remove_dev() into 2 parts, say:
__cpu_remove_prepare() - invoked during CPU_DOWN_PREPARE
__cpu_remove_finish()  - invoked during CPU_POST_DEAD


In the former function, we stop the governors, so that policy->governor_enabled
gets set to false, so that patch [1/2] will return -EBUSY to any subsequent
->store() requests. Also, we do everything except the kobject cleanup.

In the latter function, we do the remaining work, particularly the part
where we wait for the kobject refcount to drop to zero and the subsequent
cleanup.


And the ->store() functions will be modified to look like this:

store()
{
	get_online_cpus();

	if (!cpu_online(cpu))
		goto out;

	/* Body of the function*/
out:
	put_online_cpus();
}

That way, if a task tries to write to a cpufreq file during CPU offline,
it will get blocked on get_online_cpus(), and will continue after
CPU_DEAD (since we release the lock here). Then it will notice that the cpu
is offline, and hence will return silently, thus dropping the kobject refcnt.
So, when the cpufreq core comes back at the CPU_POST_DEAD stage to cleanup
the kobject, it won't encounter any problems.

Any thoughts on this approach? I'll try to code it up and post the patch
later today.

Thank you!

Regards,
Srivatsa S. Bhat

