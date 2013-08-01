Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3HAP2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:28:47 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:41736 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab3HAP2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:28:44 -0400
Message-ID: <51FA7DCB.5090201@linux.vnet.ibm.com>
Date: Thu, 01 Aug 2013 20:54:59 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH] cpufreq: Do not hold driver module references for
 additional policy CPUs
References: <2362640.pUofnXyzOi@vostro.rjw.lan> <51FA1818.2050203@linux.vnet.ibm.com> <CAKohponkEWs2r5ibR8RTAN6D2LfNfDB7bvy1nqdTN4C3jQHdJA@mail.gmail.com>
In-Reply-To: <CAKohponkEWs2r5ibR8RTAN6D2LfNfDB7bvy1nqdTN4C3jQHdJA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080115-1396-0000-0000-000003597B18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 08:14 PM, Viresh Kumar wrote:
> On 1 August 2013 13:41, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> On 08/01/2013 05:38 AM, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>
>>> The cpufreq core is a little inconsistent in the way it uses the
>>> driver module refcount.
>>>
>>> Namely, if __cpufreq_add_dev() is called for a CPU without siblings
>>> or generally a CPU for which a new policy object has to be created,
>>> it grabs a reference to the driver module to start with, but drops
>>> that reference before returning.  As a result, the driver module
>>> refcount is then equal to 0 after __cpufreq_add_dev() has returned.
>>>
>>> On the other hand, if the given CPU is a sibling of some other
>>> CPU already having a policy, cpufreq_add_policy_cpu() is called
>>> to link the new CPU to the existing policy.  In that case,
>>> cpufreq_cpu_get() is called to obtain that policy and grabs a
>>> reference to the driver module, but that reference is not
>>> released and the module refcount will be different from 0 after
>>> __cpufreq_add_dev() returns (unless there is an error).  That
>>> prevents the driver module from being unloaded until
>>> __cpufreq_remove_dev() is called for all the CPUs that
>>> cpufreq_add_policy_cpu() was called for previously.
>>>
>>> To remove that inconsistency make cpufreq_add_policy_cpu() execute
>>> cpufreq_cpu_put() for the given policy before returning, which
>>> decrements the driver module refcount so that it will be 0 after
>>> __cpufreq_add_dev() returns,
>>
>> Removing the inconsistency is a good thing, but I think we should
>> make it consistent the other way around - make a CPU-online increment
>> the driver module refcount and decrement it only on CPU-offline.
> 
> I took time to review to this mail as I was looking at the problem
> yesterday. I am sorry to say, but I have completely different views as
> compared to You and Rafael both :)
> 
> First of all, Rafael's patch is incomplete as it hasn't fixed the issue
> completely. When we have multiple CPUs per policy and
> cpufreq_add_dev() is called for the first one, it call cpufreq_get_cpu()
> for all cpus of this policy(), so count is == x (no. of CPUs in this policy)
> + 1 (This is the initial value of .owner).
> 
> And so we still have module count getting incremented for other cpus :)
>

Good catch!
 
> Now few lines about My point of view to this whole thing. I believe we
> should get rid of .owner field from struct cpufreq_driver completely. It
> doesn't make sense to me in doing all this management at all. Surprised?
> Shocked? Laughing at me? :)
> 
> Well I may be wrong but this is what I think:
> - It looks stupid to me that I can't do this from userspace in one go:
>   $ insmod cpufreq_driver.ko
>   $ rmmod cpufreq_driver.ko
> 
> What the hell changed in between that isn't visible to user? It looked
> completely stupid in that way..
> 
> Something like this sure makes sense:
> $ insmod ondemand-governor.ko
> $ change governor to ondemand for few CPUs
> $ rmmod ondemand-governor.ko
> 
> as we have deliberately add few users of governor. And so without second
> step, rmmod should really work smoothly. And it does.
> 
> Now, why shouldn't there be a problem with this approach? I will write
> that inline to the problems you just described.
> 
>> The reason is, one should not be able to unload the back-end cpufreq
>> driver module when some CPUs are still being managed. Nasty things
>> will result if we allow that. For example, if we unload the module,
>> and then try to do a CPU offline, then the cpufreq hotplug notifier
>> won't even be called (because cpufreq_unregister_driver also
>> unregisters the hotplug notifier). And that might be troublesome.
> 
> So what? Its simply equivalent to we have booted our system, haven't
> inserted cpufreq module and taken out a cpu.
> 
>> Even worse, if we unload a cpufreq driver module and load a new
>> one and *then* try to offline the CPU, then the cpufreq_driver->exit()
>> function that we call during CPU offline will end up calling the
>> corresponding function of an entirely different driver! So the
>> ->init() and ->exit() calls won't match.
> 
> That's not true. When we unload the module, it must call
> cpufreq_unregister_driver() which should call cpufreq_remove_cpu()
> for all cpus and so exit() is already called for last module.
> 

Sorry, I missed this one.

> If we get something new now, it should simply work.
> 

Yeah, I now see your point. It won't create any problems by
unloading the module and loading a new one.

> What do you think gentlemen?
> 

Well, I now agree that we don't have to keep the module refcount
non-zero as long as CPUs are being managed (that was just my
misunderstanding, sorry for the noise). However, I think the _get()
and _put() used in the existing code is for synchronization: that
is, to avoid races between trying to unload the cpufreq driver
module and running a hotplug notifier (and calling the driver module's
->init() or ->exit() function).

With that being the case, I think we can retain the module refcounts
and use them only for synchronization. And naturally the refcount
should drop to zero after the critical section; no point keeping
it incremented until the CPU is taken offline.

Or, am I confused again?

Regards,
Srivatsa S. Bhat

