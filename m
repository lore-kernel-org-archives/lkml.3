Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab3FFPqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:46:39 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:47701 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab3FFPqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:46:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130606134903.5f69b8fb@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1370502472-7249-3-git-send-email-l.majewski@samsung.com>
	<CAKohpok3KTfSWDU6PdDd4_VW4Pp+6J80yn5cLrYr5RuBNH-agA@mail.gmail.com>
	<20130606134903.5f69b8fb@amdc308.digital.local>
Date: Thu, 6 Jun 2013 21:16:35 +0530
Message-ID: <CAKohpo=jCuLwhB+3pC0NLRBDmfPpGr=hRgxTT4rXzSwM4BndaQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] cpufreq:boost: Add support for software based CPU
 frequency boost
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
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 June 2013 17:19, Lukasz Majewski <l.majewski@samsung.com> wrote:
>> On 6 June 2013 12:37, Lukasz Majewski <l.majewski@samsung.com> wrote:

>> > cpufreq_driver->boost->attr))
>>
>> Why is this required? Why do we want platforms to add some files
>> in sysfs?
>
> There are two kinds of attributes, which are exported by boost:
>
> 1. global boost (/sys/devices/system/cpu/cpufreq/boost)
>
> 2. attributes describing cpufreq abilities when boost is available
> (/sys/devices/syste/cpu/cpu0/cpufreq/):
>         - scaling_boost_frequencies - which will show over clocked
>           frequencies
>         - the scaling_available_frequencies will also display boosted
>           frequency (when boost enabled)
>
> Information from 2. is cpufreq_driver dependent. And that information
> shouldn't been displayed when boost is not available

This is not how I wanted this to be coded. Lets keep things simple:
- Implement it in the way cpufreq_freq_attr_scaling_available_freqs
  is implemented. And then drivers which need to see boost freqs
  can add it in their attr.

>> > +       policy->boost = cpufreq_boost = cpufreq_driver->boost;
>>
>> Why are we copying same pointer to policy->boost? Driver is
>> passing pointer to a single memory location, just save it globally.
>
> This needs some explanation.
>
> The sysfs entry presented at [1] doesn't bring any useful information
> to reuse (like *policy). For this reason the global cpufreq_boost
> pointer is needed.
>
> However to efficiently manage the boost, it is necessary to keep per
> policy pointer to the only struct cpufreq_boost instance (defined at
> cpufreq_driver code).

No we don't need to screw struct cpufreq_policy with it.
Just need two variables here:
- cpufreq_driver->boost: If driver supports boost or not.
- If above is true then a global bool variable that will say boost is
  enabled from sysfs or not.

>> > +       /* disable boost for newly created policy - as we e.g.
>> > change
>> > +          governor */
>> > +       policy->boost->status = CPUFREQ_BOOST_DIS;
>>
>> Drivers supporting boost may want boost to be enabled by default,
>> maybe without any sysfs calls.
>
> This can be done by setting the struct cpufreq_boost status field to
> CPUFREQ_BOOST_EN at cpufreq driver code (when boost structure is
> defined)

This really isn't driver dependent.. But user dependent. Maybe lets
keep it disabled and people can enable it from sysfs.

>> Why do we need to maintain a list of boost here? notifiers? complex :(
>
> Notifier is needed to disable boost when policy is changed (for
> example when we change from ondemand/lab to performance governor).
>
> I wanted to avoid the situation when boost stays enabled across
> different governors.
>
> The list of in system available policies is defined to allow boost
> enable/disable for all policies available (by changing for example
> policy->max field).
>
> If we decide, that we will support only one policy (as it is now at
> e.g. Exynos), the list is unnecessary here.

What we discussed last in your earlier patchset was:
- Keep boost feature separate from governors.
- If it is enabled, then any governor can use it (if they want).
- Lets not disable it if governor is changed. user must do it explicitly.

>> > +static int cpufreq_frequency_table_skip_boost(struct
>> > cpufreq_policy *policy,
>> > +                                             unsigned int index)
>> > +{
>> > +       if (index == CPUFREQ_BOOST)
>> > +               if (!policy->boost ||
>>
>> This shouldn't be true. If index has got CPUFREQ_BOOST, then driver
>> has to support boost.
>
> Correct me if I'm wrong here, but in my understanding the boost shall be
> only supported when both CPUFREQ_BOOST index is defined in a freq_table
> and boost.state = CPUFREQ_BOOST_EN is set.
>
> Setting of CPUFREQ_BOOST shouldn't by default allow to use over
> clocking frequency.

For cpufreq core boost is enabled as soon as cpufreq_driver->boost is
true. We can have additional checks to see if there is atleast one
boost frequency but can skip this too.

>> why do we need this?
>
> To evaluate the maximal boost frequency from the frequency table. It is
> then used as a delimiter (when LAB cooperates with thermal framework).

Introduce this with LAB then.. Lets keep it as simple as possible for now.
One step at a time.

>> > +struct cpufreq_boost {
>> > +       unsigned int            max_boost_freq; /* maximum value of
>> > +                                                * boosted freq */
>> > +       unsigned int            max_normal_freq; /* non boost max
>> > freq */
>> > +       int                     status; /* status of boost */
>> > +
>> > +       /* boost sysfs attributies */
>> > +       struct freq_attr        **attr;
>> > +
>> > +       /* low-level trigger for boost */
>> > +       int (*low_level_boost) (struct cpufreq_policy *policy, int
>> > state); +
>> > +       struct list_head        policies;
>> > +};
>>
>> We don't need it. Just add two more fields to cpufreq_driver:
>> - have_boost_freqs and low_level_boost (maybe a better name.
>> What's its use?)
>
> The separate struct cpufreq_boost was created to explicitly separate
> boost fields from cpufreq_driver structure.
>
> If in your opinion this structure is redundant, I can remove it and
> extend cpufreq_driver structure.

I am not against a structure (as putting related stuff in a struct is always
better), but against so many fields in it to make things complicated.

I will only keep have_boost_freqs and low_level_boost. Remove
everything else.

> *boost pointer is necessary when one wants to enable/disable boost from
> e.g governor code (which operates mostly on struct cpufreq_policy
> *policy pointers).

We don't need to do this. boost can only be disabled from userspace by
user. No intervention from governor.
