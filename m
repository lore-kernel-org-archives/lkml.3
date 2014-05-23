Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaEWEY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 00:24:58 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:60054 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbaEWEY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 00:24:57 -0400
MIME-Version: 1.0
In-Reply-To: <537E27DA.9040709@wwwdotorg.org>
References: <cover.1400662383.git.viresh.kumar@linaro.org>
	<59e1185a31e61c428aca9f4b8f0a69f182ee458e.1400662383.git.viresh.kumar@linaro.org>
	<537E27DA.9040709@wwwdotorg.org>
Date: Fri, 23 May 2014 09:54:56 +0530
Message-ID: <CAKohpokhiTpTd-ByFUuOL1hR7MnKPPQj-peH7S5oFxowKt0BeQ@mail.gmail.com>
Subject: Re: [PATCH V4 2/3] cpufreq: add support for intermediate (stable) frequencies
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Doug Anderson <dianders@chromium.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 May 2014 22:07, Stephen Warren <swarren@wwwdotorg.org> wrote:
> It seems rather odd to set both freqs->old and freqs->new to the
> intermediate frequency upon success. It feels like it would make more
> sense to remove that final else clause above, and do the following where
> this function is called:
>
>         intermediate_freq = freqs.new;
>         if (intermediate_freq)
>                 freqs.old = intermediate_freq
>         freqs.new = freq_table[index].frequency

Looks better.

> (or even return the intermediate frequency from the function)

It can return errors as well and so I didn't tried to return frequency
from it. Though there are routines that return both error and freq
from such calls :)

> ?
>
> But I suppose isolating all the inside __target_intermediate() isn't so bad.

:)

>>  static int __target_index(struct cpufreq_policy *policy,
>>                         struct cpufreq_frequency_table *freq_table, int index)
>>  {
>> -     struct cpufreq_freqs freqs;
>> +     struct cpufreq_freqs freqs = {.old = policy->cur, .flags = 0};
>> +     unsigned int intermediate_freq = 0;
>>       int retval = -EINVAL;
>>       bool notify;
>>
>>       notify = !(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION);
>> -
>>       if (notify) {
>> -             freqs.old = policy->cur;
>> -             freqs.new = freq_table[index].frequency;
>> -             freqs.flags = 0;
>> +             /* Handle switching to intermediate frequency */
>> +             if (cpufreq_driver->get_intermediate) {
>> +                     retval = __target_intermediate(policy, &freqs, index);
>> +                     if (retval)
>> +                             return retval;
>
> Shouldn't this all be outside the if (notify) block, so that
> __target_intermediate is always called, and it's just the notify
> callbacks that gets skipped if (!notify)?

So, this is logic I had:

Should we support 'intermediate freq' infrastructure when driver wants
to handle notifications themselves?

Probably not.

The whole point of implementing this 'intermediate freq' infrastructure is to
get rid of code redundancy while sending notifications. If drivers want to
handle notifications then they better handle intermediate freqs as well in
their target_index() callback. They don't need to implement another routine
for intermediate stuff..

--
viresh
