Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaGKKwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:52:12 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:40046 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaGKKwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:52:09 -0400
MIME-Version: 1.0
In-Reply-To: <2f549e6e4871ccf2a94dd4c8872c7a0b.squirrel@www.codeaurora.org>
References: <1404959850-11617-1-git-send-email-skannan@codeaurora.org>
	<1405052287-4744-1-git-send-email-skannan@codeaurora.org>
	<CAKohponB9feyh50p+dL5hyU1ffHAzHU59G-sYCrCm1AbHQe9hw@mail.gmail.com>
	<2f549e6e4871ccf2a94dd4c8872c7a0b.squirrel@www.codeaurora.org>
Date: Fri, 11 Jul 2014 16:22:08 +0530
Message-ID: <CAKohpokhmj1OkCRj=X+Q7eYiun8fsqD2dpEt66VKYnqo3dENVA@mail.gmail.com>
Subject: Re: [PATCH v2] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 July 2014 15:29,  <skannan@codeaurora.org> wrote:
> Viresh Kumar wrote:
>> On 11 July 2014 09:48, Saravana Kannan <skannan@codeaurora.org> wrote:

>>> * Policy settings and governor tunables maintained across suspend/resume
>>>   and hotplug.
>>
>> Its already maintained during suspend/resume.
>
> But not across hotplug. Which is also very useful when you have 2 clusters
> and one gets hotplugged offline due to thermal and then reinserted.
> Userspace has to come and restore it back today. In our tree, we "stitched
> up" the governor. Also, this make the suspend/resume code a tiny bit
> simpler -- in the sense, it's not a special case anymore.

Yeah, I understood that. I was just pointing that you need to mention
hotplug alone in the bullet point.

>>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c

>>>  static int cpufreq_add_dev_symlink(struct cpufreq_policy *policy)
>>>  {
>>> -       unsigned int j;
>>> +       unsigned int j, first_cpu = cpumask_first(policy->related_cpus);
>>>         int ret = 0;
>>>
>>> -       for_each_cpu(j, policy->cpus) {
>>> +       for_each_cpu(j, policy->related_cpus) {
>>>                 struct device *cpu_dev;
>>>
>>> -               if (j == policy->cpu)
>>> +               if (j == first_cpu)
>>
>> why?
>
> The first CPU is a cluster always own the real nodes.

What I meant was, why not use policy->cpu?

>>> +static int cpufreq_add_dev_interface(struct cpufreq_policy *policy)
>>>  {
>>>         struct freq_attr **drv_attr;
>>> +       struct device *dev;
>>>         int ret = 0;
>>>
>>> +       dev = get_cpu_device(cpumask_first(policy->related_cpus));
>>> +       if (!dev)
>>> +               return -EINVAL;
>>> +
>>
>> Why?
>
> I'm just always adding the real nodes to the first CPU in a cluster
> independent of which CPU gets added first. Makes it easier to know which
> ones to symlink. See comment next to policy->cpu for full context.

Yeah, and that is the order in which CPUs will boot and cpufreq_add_dev()
will be called. So, isn't policy->cpu the right CPU always?

>>> +       blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
>>> +                                       CPUFREQ_UPDATE_POLICY_CPU,
>>> policy);
>>
>> This should be only called when policy->cpu is updated. And shouldn't
>> be called anymore and can be dropped as you might not wanna change
>> policy->cpu after this patch.
>
> Right. I should have reordered this to after.
>
> But I always HAVE to send it when I add/remove a CPU. That's how I believe
> cpufreq stats can keep of CPUs going offline.

No. cpufreq-stats doesn't have to care about CPUs going in/out. It just
cares about poilcy->cpu and so we notify it when that gets updated.

> Oh, yeah. Which bring me to
> another point. If I'm not mistaken, cpufreq stats keeps track of policy
> stats. Really, it should track a CPU's stats. If it's hotplugged out, it
> should count that time towards it's current freq.

Even if CPU is hotplugged out, it is getting clock from the same pll. And
so if clock for rest of the CPUs change, it changes for the hotplugged
out one as well.. Even if it is not running.

So, we must account on the new frequencies.

>>> -       if (has_target()) {
>>> +       cpus = cpumask_weight(policy->cpus);
>>> +       policy->cpu = cpumask_first(policy->cpus);
>>
>> why update it at all? Also, as per your logic what if cpus == 0?
>
> Yeah, I didn't write it this way at first. But the governors are making
> the assumption that policy->cpu is always an online CPU. So, they try to

Are you sure? I had a quick look and failed to see that..

> queue work there and use data structs of that CPU (even if they free it in
> the STOP event since it went offline).

So, it queues work on all policy->cpus, not policy->cpu. And the data structures
are just allocated with a CPU number, its fine if its offline.

And where are we freeing that stuff in STOP ?

Sorry if I am really really tired and couldn't read it correctly.

> Another option is to leave policy->cpu unchanged and then fix all the
> governors. But this patch would get even more complicated. So, we can
> leave this as is, or fix that up in a separate patch.

Since we are simplifying it here, I think we should NOT change policy->cpu
at all. It will make life simple (probably).

>>> +       if (has_target() && cpus > 0) {
>>
>> Instead of > or < use cpus or !cpus.
>
> Kinda personal style I guess. cpus > 0 reads like "there's more than 0
> CPUs" which makes sense in English too. But sure, I can change if you
> really want to.

Actually at places its compared with 0 or 1, and so thought cpus, !cpus
would be better..

> Sorry if I gave the impression that this patch is complete.

No, you didn't :)

>>> +               cpufreq_driver->stop_cpu(policy);
>>
>> Where is ->exit() gone?
>>
>
> Why should I exit? I don't think we need to. I'm not planning on exit()
> and init() every time an entire cluster is offlined or onlined. Just stop
> the governor and let if go quiet.

Okay, my driver is compiled as a module. I insert/remove it multiple
times. Only ->init() will be called multiple times, no exit ?

>>>  #ifdef CONFIG_SMP
>>>         /* check whether a different CPU already registered this
>>>          * CPU because it is in the same boat. */
>>> +       /* FIXME: This probably needs fixing to avoid "try lock" from
>>> +        * returning NULL. Also, change to likely() */
>>
>> I wanted to give this comment later, but that's fine ..
>>
>> - First, I couldn't understand the try-lock fixme
>
> If trylock fails when we are adding a new CPU to an existing cluster, I
> should skip adding it just because someone else was holding the lock and
> the try lock failed.

But that trylock thing was later in the code. How does it affect the
'if' block you commented on?

> But I don't think trylocks are needed anymore. Maybe I can fix it in later
> patches. We'll see.

I don't know yet :)

>> - And you aren't freeing 'struct cpufreq_policy' at all now. Would result
>> in
>> Memory leak cpufreq driver is compiled as a module and inserted/removed
>> multiple times.
>
> Again, sorry, if I gave the impression this patch was done. If you don't
> want me to send intermediate RFC patches, I can hold off. I'm well aware
> that this is not completed yet. When I'm done, there should be no memory
> leak when modules get added/removed.

Oh yes. I believed that atleast the basic things are all working. It even had
a Tested-by from Stephen :)

Okay, this stuff isn't THAT big. So, hold-on your patches for sometime and
send when they are almost ready.

I understand that you wanted to have some early feedback, but its already
there with you. YES we want this change to retain settings during hotplug.

The problem is, even when I didn't review it completely it took over an hour
to do the reviews I did :)

So, I would like to see something *much more* stable. Finishing can be
done later.

>>>         policy = cpufreq_cpu_get(cpu);
>>>         if (unlikely(policy)) {
>>> +               cpufreq_change_policy_cpus(policy, cpu, true);
>>>                 cpufreq_cpu_put(policy);
>>>                 return 0;
>>>         }
>>
>> This optimization wasn't for the hotplug case, but for adding
>> non-policy->cpu
>> cpus for the first time.
>
> Sure, but I'm making it an optimization for any time a CPU is added except
> for the first time. Since I'm not always freeing and allocating policies
> or moving them around, I can simplify it as such.

Hmm, but that would be an overhead of calling cpufreq_change_policy_cpus()
for every cpu on boot. Wouldn't be that nice for big servers.

>> In your case policy->cpus would already be updated and so calling
>> cpufreq_change_policy_cpus() isn't required.
>
> How? I don't you misunderstood the intent here.

Only on first boot policy->cpus would be updated. Later on you can do it
separately as it was done in existing code.

> Yeah, that's why I didn't fix it here yet. Leaving existing bugs as is.

I would prefer cleaning them up first, so that the new changes you are
making are rock solid.

>>> +       /* Weed out impossible CPUs. */
>>> +       cpumask_and(policy->related_cpus, policy->related_cpus,
>>> +                       cpu_possible_mask);
>>
>> why?
>
> Why not? It should make the future bit ops faster?

Drivers shouldn't set non-populatable CPUs to this mask.

>> Sorry but I am stopping now. I have already pointed out some issues
>> which make this unusable.
>
> Most of them aren't really bugs, but I should clarify the intent though.

I wasn't worried about most of the comments, but exit(), memory leaks,
etc..

> In this patch, I'm ONLY touching hotplug and resume related code (except
> for one line). I'll give some description in my next patch on how I'm
> expecting the events to be across hotplug/suspend and what happens with
> the policies. Once we are on the same page on the intent of the patch, it
> should be easier.

>> Please make sure you take care of these issues:
>> - suspend/resume
> Didn't test. I expect it to be broken in v2.

:)

>> - module insert/remove
> Didn't test. Expected to be broken.
>
>> - Memory leaks
> Will do.
>
>> - multi cluster systems (with one and multiple CPU per cluster)
>> *by cluster I mean group of CPUs sharing clock line
>> - single cluster ones, one and multiple CPUs
>
> I actually tested hotplug for all these cases. That's how I found the
> governor issue.
>
>>
>> Will see how V3 goes. Thanks.
>
> Thanks for taking the time to review and being open to these changes.
> Appreciate the cooperation.

Thanks Saravana.
