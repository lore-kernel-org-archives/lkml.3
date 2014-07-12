Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaGLCpC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 22:45:02 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39122 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaGLCpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 22:45:00 -0400
Message-ID: <53C0A12A.2060204@codeaurora.org>
Date: Fri, 11 Jul 2014 19:44:58 -0700
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
References: <1404959850-11617-1-git-send-email-skannan@codeaurora.org> <1405052287-4744-1-git-send-email-skannan@codeaurora.org> <CAKohponB9feyh50p+dL5hyU1ffHAzHU59G-sYCrCm1AbHQe9hw@mail.gmail.com> <2f549e6e4871ccf2a94dd4c8872c7a0b.squirrel@www.codeaurora.org> <CAKohpokhmj1OkCRj=X+Q7eYiun8fsqD2dpEt66VKYnqo3dENVA@mail.gmail.com>
In-Reply-To: <CAKohpokhmj1OkCRj=X+Q7eYiun8fsqD2dpEt66VKYnqo3dENVA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 03:52 AM, Viresh Kumar wrote:

Just responding to one comment. The one about policy->cpu.

>
>>>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>
>>>>   static int cpufreq_add_dev_symlink(struct cpufreq_policy *policy)
>>>>   {
>>>> -       unsigned int j;
>>>> +       unsigned int j, first_cpu = cpumask_first(policy->related_cpus);
>>>>          int ret = 0;
>>>>
>>>> -       for_each_cpu(j, policy->cpus) {
>>>> +       for_each_cpu(j, policy->related_cpus) {
>>>>                  struct device *cpu_dev;
>>>>
>>>> -               if (j == policy->cpu)
>>>> +               if (j == first_cpu)
>>>
>>> why?
>>
>> The first CPU is a cluster always own the real nodes.
>
> What I meant was, why not use policy->cpu?
>
>>>> +static int cpufreq_add_dev_interface(struct cpufreq_policy *policy)
>>>>   {
>>>>          struct freq_attr **drv_attr;
>>>> +       struct device *dev;
>>>>          int ret = 0;
>>>>
>>>> +       dev = get_cpu_device(cpumask_first(policy->related_cpus));
>>>> +       if (!dev)
>>>> +               return -EINVAL;
>>>> +
>>>
>>> Why?
>>
>> I'm just always adding the real nodes to the first CPU in a cluster
>> independent of which CPU gets added first. Makes it easier to know which
>> ones to symlink. See comment next to policy->cpu for full context.
>
> Yeah, and that is the order in which CPUs will boot and cpufreq_add_dev()
> will be called. So, isn't policy->cpu the right CPU always?

No, the "first" cpu in a cluster doesn't need to be the first one to be 
added. An example is 2x2 cluster system where the system is booted with 
max cpus = 2 and then cpu3 could be onlined first by userspace.

>
>>>> -       if (has_target()) {
>>>> +       cpus = cpumask_weight(policy->cpus);
>>>> +       policy->cpu = cpumask_first(policy->cpus);
>>>
>>> why update it at all? Also, as per your logic what if cpus == 0?
>>
>> Yeah, I didn't write it this way at first. But the governors are making
>> the assumption that policy->cpu is always an online CPU. So, they try to
>
> Are you sure? I had a quick look and failed to see that..
>
>> queue work there and use data structs of that CPU (even if they free it in
>> the STOP event since it went offline).
>
> So, it queues work on all policy->cpus, not policy->cpu.
> And the data structures
> are just allocated with a CPU number, its fine if its offline.
>
> And where are we freeing that stuff in STOP ?
>
> Sorry if I am really really tired and couldn't read it correctly.

Yeah, it is pretty convolution. But pretty much anywhere in the gov code 
where policy->cpu is used could cause this. The specific crash I hit was 
in this code:

static void od_dbs_timer(struct work_struct *work)
{
	struct od_cpu_dbs_info_s *dbs_info =
		container_of(work, struct od_cpu_dbs_info_s, cdbs.work.work);
	unsigned int cpu = dbs_info->cdbs.cur_policy->cpu;

======= CPU is policy->cpu here.

	struct od_cpu_dbs_info_s *core_dbs_info = &per_cpu(od_cpu_dbs_info,
			cpu);

======= Picks the per CPU struct of an offline CPU

<snip>

	mutex_lock(&core_dbs_info->cdbs.timer_mutex);

======= Dies trying to lock a destroyed mutex

>
>> Another option is to leave policy->cpu unchanged and then fix all the
>> governors. But this patch would get even more complicated. So, we can
>> leave this as is, or fix that up in a separate patch.
>
> Since we are simplifying it here, I think we should NOT change policy->cpu
> at all. It will make life simple (probably).

I agree, but then I would have to fix up the governors. In the interest 
of keeping this patch small. I'll continue with what I'm doing and fix 
it up in another patch.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
