Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab3FQHna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:43:30 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:60975 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab3FQHn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:43:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130617091549.398b865f@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1371195540-2991-1-git-send-email-l.majewski@samsung.com>
	<1371195540-2991-2-git-send-email-l.majewski@samsung.com>
	<CAKohpokQAsuAqWi7rNx9RaFz8KVRNXVkBD22KC5_Qh05k66qqA@mail.gmail.com>
	<20130617091549.398b865f@amdc308.digital.local>
Date: Mon, 17 Jun 2013 13:13:27 +0530
Message-ID: <CAKohpo=nfuqwCoQJRczmNRNXCOTL5FSJQEzjKpVdXU+wu-KJ1g@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] cpufreq: Add boost frequency support in core
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 June 2013 12:45, Lukasz Majewski <l.majewski@samsung.com> wrote:
> On Mon, 17 Jun 2013 11:13:18 +0530, Viresh Kumar wrote:
>> On 14 June 2013 13:08, Lukasz Majewski <l.majewski@samsung.com> wrote:

>> > +int cpufreq_boost_trigger_state(int state) +{

>> > +       if (!cpufreq_driver->boost_supported)
>> > +               return -ENODEV;
>>
>> This can't happen. sysfs directory is present only when we
>> have boost supported.
>
> I know, that we shall not look into the future. But this method will be
> used when somebody would like to enable boost from kernel. Let's say
> new governor or such :-).

We don't know if that would be acceptable or not as of now.

> I can remove this and add it later, but I think, that it is safer to
> add it straightaway.

Remove it for now.

>>
>> > +       if (cpufreq_boost_enabled != state) {
>> > +               if (cpufreq_driver->set_boost_freq) {
>> > +                       ret = cpufreq_driver->set_boost_freq(state);
>>
>> I thought this routine was for setting boost frequency and not
>> for enabling boost feature. If boost has to be enabled separately
>> then this routine must take care of it while setting freq.
>>
>> So, in other words, this must not be called here.
>
> This function explicitly follows current logic of acpi-cpufreq.c.
>
> I would like to avoid modifying legacy/working code as much as
> possible (especially when I hadn't yet received any feedback about
> acpi-cpufreq.c file changes).

Hmm.. I saw that code now. You are talking about: boost_set_msrs ??

So, this function has nothing to do with set_boost_freq() but
enable_boost(). Rename your function similarly and keep this code.

>> > +                       if (ret) {
>> > +                               pr_err("%s: BOOST cannot enable
>> > (%d)\n",
>> > +                                      __func__, ret);
>> > +                               return ret;
>> > +                       }
>> > +               }
>> > +
>> > +               for_each_possible_cpu(cpu) {
>> > +                       policy = cpufreq_cpu_get(cpu);
>>
>> In case this code is required, it would make more sense to keep list
>> of all available policies, which we can iterate through.
>
> Maybe I don't get the big picture, but why we cannot iterate
> through possible CPUs? At least one shall have valid policy and
> freq_table combination.

Many cpus share same policy structure and so iterating over all of them
isn't a very good idea. Either keep a mask of cpus already iterated,
copy policy->cpus to it on each iteration. If a cpu is already done
skip loop for it.

OR keep a list of policies. I would prefer the later (do it in a separate
patch), as this can be used later too.

> I've already proposed list of all policies (at v1), but we decided to
> abandon this idea.

I don't remember why it was there but reason wasn't good enough to
keep it.

>> I am not sure if this is required at all. Or what complications can be
>> there when we update max/min on the fly here.
>
> Correct me if I'm wrong, but I'm using scripts for tests which run
> simultaneously and enables/disables boost feature. I don't recall if
> there is a lock at sysfs, which would prevent from simultaneous write
> to the "boost" sysfs attribute.
>
> I will doubble check that.

It isn't about a crash but how cpufreq subsystem works. I will think over
it later too, for now you can keep it.

>> > +{
>> > +       return cpufreq_boost_enabled;
>>
>> s/cpufreq_boost_enabled/boost_enabled

??

>> > @@ -318,6 +322,10 @@ __ATTR(_name, _perm, show_##_name, NULL)
>> >  static struct freq_attr _name =                        \
>> >  __ATTR(_name, 0644, show_##_name, store_##_name)
>> >
>> > +#define cpufreq_attr_available_freq(_name)       \
>> > +struct freq_attr cpufreq_freq_attr_##_name##_freqs =     \
>> > +__ATTR_RO(_name##_frequencies)
>>
>> What is this doing in cpufreq.h? It will only be used by freq_table.c
>> file.
>
> I wanted to add those #defines to the place where other similar ones
> are placed.

That's not how these or any other declaration should be placed. By adding
these to cpufreq.h, you are inviting other parts of kernel to use them.
Which we don't want.

> I can put it to freq_table.c.

Thanks.

>> Again, I couldn't see how boost freqs are getting used? You have
>> probably made them part of normal freq range here and so they
>> might be used during normal operations. But we wanted it to be
>> used only when we have few cpus on... etc.. Where is that logic?
>
> The logic is as follow:
> - cpufreq_driver exports .attr field. When driver supports boost then
>   two attributes are exported (even when boost is not enabled, but
>   supported):
>         - scaling_available_frequencies (only normal frequencies - this
>           attribute is unchanged)
>         - scaling_boost_frequencies - list possible boost frequencies.
>
> When boost is not supported - then only scaling_available_frequencies
> is exported (as it is done now).

You are missing the whole point behind keeping this patchset. Its not
about how to expose boost freqs to sysfs (that's what you are talking
about) but to use these frequencies on the fly. Some part of kernel
code would be setting these frequencies in real hardware. Who will
set these frequencies? On what basis? How do we ensure we don't
burn your chip?
