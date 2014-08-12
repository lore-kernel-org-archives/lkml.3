Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaHLH0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:26:43 -0400
Received: from natalenko.name ([78.47.77.148]:55102 "EHLO natalenko.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbaHLH0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:26:41 -0400
DMARC-Filter: OpenDMARC Filter v1.2.0 natalenko.name 97608A5B3
Authentication-Results: mail.natalenko.name; dmarc=none header.from=natalenko.name
User-Agent: K-9 Mail for Android
In-Reply-To: <CAOh2x=k09cQ40EiK72ELfDH8e2M9_ZYbrtK3wz9_1dtYU1+DCQ@mail.gmail.com>
References: <4708675.eITUXPv8Ih@spock> <2651364.4shODVy8cx@spock> <CAOh2x=k2xpfqz+VjYpPbQy6Z5aeo8DxkYmk7JSmrAZxQOJSU9Q@mail.gmail.com> <1827037.Yd5d4GH5Ub@spock> <CAOh2x=k09cQ40EiK72ELfDH8e2M9_ZYbrtK3wz9_1dtYU1+DCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [BUG] oops in cpufreq driver with AMD Kaveri CPU
From: Oleksandr Natalenko <oleksandr@natalenko.name>
Date: Tue, 12 Aug 2014 10:26:35 +0300
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Message-ID: <97078cc7-f961-4575-ab72-ec88e6f30b9e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got that and will try to investigate ASAP.

Just to note: I tried to use powersave governor and got the same result. I believe notifiers are used with powersave governor as well. Am I wrong?

On August 12, 2014 9:16:21 AM EEST, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>On Tue, Aug 12, 2014 at 11:25 AM, Oleksandr Natalenko
><oleksandr@natalenko.name> wrote:
>> What should I do to debug it? Is that necessary to recompile kernel
>with full
>> debug?
>
>Yeah, you need to recompile the kernel for sure but not necessarily
>with debug
>support..
>
>Some background:
>
>In cpufreq framework, we manage a CPUs frequency based on the load
>on CPU. You are using ondemand governor which tries to
>increase/decrease frequency
>continuously at fixed intervals.
>
>Now, when we change the frequency we *may* need to communicate this to
>few
>drivers which *may* depend on CPUs frequency for their functioning.
>
>This is handled via notifications.
>
>Other drivers are required to do this:
>cpufreq_register_notifier(&<some-local-struct>,
>CPUFREQ_TRANSITION_NOTIFIER);
>
>to register themselves for frequency-change and them a routine of
>theirs would
>be called from cpufreq-core..
>
>This is exactly where it is crashing for you. i.e. while calling the
>notifier list.
>
>So, you need to check which all notifiers are registered and out of
>those which
>one is crashing..
>
>The first parameter of the above register-call should be declared this
>way:
>
>static struct notifier_block xyz_notifier_block = {
>    .notifier_call = xyz_freq_notifier,
>};
>
>I would have done it this way:
>
>- Add a print in cpufreq_register_notifier() to print the address of
>routine
>present in .notifier_call for case: CPUFREQ_TRANSITION_NOTIFIER
>
>- Then add prints to all the notifiers added for your configuration,
>shouldn't
>be much only 4-5 I believe. i.e. you can add print messages to the
>notifier
>callbacks..
>
>- Then see the sequence/order in which they are called normally, when
>we
>don't crash.. and check that when it crashes..
>
>- You will be able to make out which notifier is crashing. And then we
>can
>see why?
>
>- You can add something like this to notifier routines:
>pr_info("%s\n", __func__);
>
>This will print function name.
>
>>> Which patch are you talking about here?
>>
>> I thought about this one [1], but I guess that's not my case.
>>
>> [1] https://lkml.org/lkml/2014/7/16/815
>
>I guessed so and I don't think it will help as the crashes reported in
>this
>bug-log is something different.

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
