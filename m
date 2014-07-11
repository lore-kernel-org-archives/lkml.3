Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaGKKDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:03:01 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39784 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaGKKC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:02:58 -0400
Message-ID: <dd77b9ad6c51df71f24ba1f292b2ede8.squirrel@www.codeaurora.org>
In-Reply-To: <53BF95AB.6030800@mit.edu>
References: <1404959850-11617-1-git-send-email-skannan@codeaurora.org>
    <1405052287-4744-1-git-send-email-skannan@codeaurora.org>
    <53BF95AB.6030800@mit.edu>
Date: Fri, 11 Jul 2014 10:02:57 -0000
Subject: Re: [PATCH v2] cpufreq: Don't destroy/realloc policy/sysfs on
 hotplug/suspend
From: skannan@codeaurora.org
To: "Srivatsa S. Bhat" <srivatsa@MIT.EDU>
Cc: "Saravana Kannan" <skannan@codeaurora.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        "Viresh Kumar" <viresh.kumar@linaro.org>,
        "Todd Poynor" <toddpoynor@google.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Stephen Boyd" <sboyd@codeaurora.org>
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Srivatsa S. Bhat wrote:
> On 07/11/2014 09:48 AM, Saravana Kannan wrote:
>> The CPUfreq driver moves the cpufreq policy ownership between CPUs when
>> CPUs within a cluster (CPUs sharing same policy) go ONLINE/OFFLINE. When
>> moving policy ownership between CPUs, it also moves the cpufreq sysfs
>> directory between CPUs and also fixes up the symlinks of the other CPUs
>> in
>> the cluster.
>>
>> Also, when all the CPUs in a cluster go OFFLINE, all the sysfs nodes and
>> directories are deleted, the kobject is released and the policy is
>> freed.
>> And when the first CPU in a cluster comes up, the policy is reallocated
>> and
>> initialized, kobject is acquired, the sysfs nodes are created or
>> symlinked,
>> etc.
>>
>> All these steps end up creating unnecessarily complicated code and
>> locking.
>> There's no real benefit to adding/removing/moving the sysfs nodes and
>> the
>> policy between CPUs. Other per CPU sysfs directories like power and
>> cpuidle
>> are left alone during hotplug. So there's some precedence to what this
>> patch is trying to do.
>>
>> This patch simplifies a lot of the code and locking by removing the
>> adding/removing/moving of policy/sysfs/kobj and just leaves the cpufreq
>> directory and policy in place irrespective of whether the CPUs are
>> ONLINE/OFFLINE.
>>
>> Leaving the policy, sysfs and kobject in place also brings these
>> additional
>> benefits:
>> * Faster suspend/resume.
>> * Faster hotplug.
>> * Sysfs file permissions maintained across hotplug without userspace
>>   workarounds.
>> * Policy settings and governor tunables maintained across suspend/resume
>>   and hotplug.
>> * Cpufreq stats would be maintained across hotplug for all CPUs and can
>> be
>>   queried even after CPU goes OFFLINE.
>>
>> Change-Id: I39c395e1fee8731880c0fd7c8a9c1d83e2e4b8d0
>> Tested-by: Stephen Boyd <sboyd@codeaurora.org>
>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
>> ---
>>
>> Preliminary testing has been done. cpufreq directories are getting
>> created
>> properly. Online/offline of CPUs work. Policies remain unmodifiable from
>> userspace when all policy CPUs are offline.
>>
>> Error handling code has NOT been updated.
>>
>> I've added a bunch of FIXME comments next to where I'm not sure about
>> the
>> locking in the existing code. I believe most of the try_lock's were
>> present
>> to prevent a deadlock between sysfs lock and the cpufreq locks. Now that
>> the sysfs entries are not touched after creating them, we should be able
>> to
>> replace most/all of these try_lock's with a normal lock.
>>
>> This patch has more room for code simplification, but I would like to
>> get
>> some acks for the functionality and this code before I do further
>> simplification.
>>
>
> The idea behind this work is very welcome indeed! IMHO, there is nothing
> conceptually wrong in maintaining the per-cpu sysfs files across CPU
> hotplug
> (as long as we take care to return appropriate error codes if userspace
> tries to set values using the control files of offline CPUs). So, it
> really
> boils down to whether or not we get the implementation right; the idea
> itself
> looks fine as of now. Hence, your efforts in making this patch(set) easier
> to
> review will certainly help. Perhaps you can simplify the code later, but
> at
> this point, splitting up this patch into multiple smaller, reviewable
> pieces
> (accompanied by well-written changelogs that explain the intent) is the
> utmost
> priority. Just like Viresh, even I had a hard time reviewing all of this
> in
> one go.
>
> Thank you for taking up this work!

Thanks for the support. I'll keep in mind to keep the patches simple and
not do unnecessary optimizations. But the first patch diff unfortunately
is going to be a bit big since it'll delete a lot of code. :( But I'll add
more detailed commit text or "cover" text in the next one. I don't want to
split up the patch so much that individual ones don't compile or boot.

Maybe after patch v3, if you guys can suggest splitting it up into chunks
that won't involve huge rewrites, I can try to do that.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

