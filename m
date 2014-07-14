Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401AbaGNTIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:08:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59525 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaGNTI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:08:27 -0400
Message-ID: <53C42AA8.8010107@codeaurora.org>
Date: Mon, 14 Jul 2014 12:08:24 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
References: <1404959850-11617-1-git-send-email-skannan@codeaurora.org> <1405052287-4744-1-git-send-email-skannan@codeaurora.org> <CAKohponB9feyh50p+dL5hyU1ffHAzHU59G-sYCrCm1AbHQe9hw@mail.gmail.com> <2f549e6e4871ccf2a94dd4c8872c7a0b.squirrel@www.codeaurora.org> <CAKohpokhmj1OkCRj=X+Q7eYiun8fsqD2dpEt66VKYnqo3dENVA@mail.gmail.com> <53C0A12A.2060204@codeaurora.org> <CAKohpon9en_VnSx+CVydPsWBHtArvmazn0hrodrRJt9jgOa0-g@mail.gmail.com>
In-Reply-To: <CAKohpon9en_VnSx+CVydPsWBHtArvmazn0hrodrRJt9jgOa0-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2014 11:09 PM, Viresh Kumar wrote:
> On 12 July 2014 08:14, Saravana Kannan <skannan@codeaurora.org> wrote:
>
>>>> I'm just always adding the real nodes to the first CPU in a cluster
>>>> independent of which CPU gets added first. Makes it easier to know which
>>>> ones to symlink. See comment next to policy->cpu for full context.
>>>
>>>
>>> Yeah, and that is the order in which CPUs will boot and cpufreq_add_dev()
>>> will be called. So, isn't policy->cpu the right CPU always?
>>
>>
>> No, the "first" cpu in a cluster doesn't need to be the first one to be
>> added. An example is 2x2 cluster system where the system is booted with max
>> cpus = 2 and then cpu3 could be onlined first by userspace.
>
> Because we are getting rid of much of the complexity now, I do not want
> policy->cpu to keep changing. Just fix it up to the cpu for which the policy
> gets created first. That's it. No more changes required. It doesn't matter at
> userspace which cpu owns it as symlinks would anyway duplicate it under
> every cpu.

I think you missed one my of comments in the email. I agree with what 
you are saying here. I'll just do it as a separate patch to keep this 
one simpler. I don't want to touch all the governors and other potential 
uses of policy->cpu in this patch.

>> Yeah, it is pretty convolution. But pretty much anywhere in the gov code
>> where policy->cpu is used could cause this. The specific crash I hit was in
>> this code:
>>
>> static void od_dbs_timer(struct work_struct *work)
>> {
>>          struct od_cpu_dbs_info_s *dbs_info =
>>                  container_of(work, struct od_cpu_dbs_info_s,
>> cdbs.work.work);
>>          unsigned int cpu = dbs_info->cdbs.cur_policy->cpu;
>>
>> ======= CPU is policy->cpu here.
>>
>>          struct od_cpu_dbs_info_s *core_dbs_info = &per_cpu(od_cpu_dbs_info,
>>                          cpu);
>>
>> ======= Picks the per CPU struct of an offline CPU
>>
>> <snip>
>>
>>          mutex_lock(&core_dbs_info->cdbs.timer_mutex);
>>
>> ======= Dies trying to lock a destroyed mutex
>
> I am still not getting it. Why would we get into this if policy->cpu is fixed
> once at boot ?
>

Yeah, it definitely crashes if policy->cpu if an offline cpu. Because 
the mutex would be uninitialized if it's stopped after boot or it would 
never have been initialized (depending on how you fix policy->cpu at boot).

Look at this snippet on the actual tree and it should be pretty evident.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
