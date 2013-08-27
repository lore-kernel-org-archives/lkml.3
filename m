Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3H0ReT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 13:34:19 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:47231 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752618Ab3H0ReS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 13:34:18 -0400
Message-ID: <521CE317.20908@semaphore.gr>
Date: Tue, 27 Aug 2013 20:34:15 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: governors: Remove duplicate check of target
 freq in supported range
References: <521BA068.8030003@semaphore.gr> <CAKohpo=xBmpEv=oN1qEnq9RKhfjtc4wZayVYyVzjWOU8BnwVJQ@mail.gmail.com> <521CC9B8.2020801@semaphore.gr> <CAKohpo=XhHtRfsVrUZr0DQCK5L5zU_6DB4PBOA4QrJBvvcbe0Q@mail.gmail.com>
In-Reply-To: <CAKohpo=XhHtRfsVrUZr0DQCK5L5zU_6DB4PBOA4QrJBvvcbe0Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 07:07 PM, Viresh Kumar wrote:
> On 27 August 2013 21:16, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>> I think we should keep these checks because:
>>
>> 1) They shorten the execution code (there is no unnecessary call of
>> __cpufreq_driver_target)
>
> I don't really count this one.. This is how code is present everywhere in
> kernel.. These checks are present in routines and callers don't need to
> take care of them..

I mean that if we will get rid of the code you mentioned, we will have
an extra call to function __cpufreq_driver_target in some cases.

>> 2) In case my patch will be accepted, we need them to avoid continuously
>> increase of dbs_info->requested_freq.With my patch the requested_freq
>> can temporarily overcome policy->min and policy->max. __cpufreq_driver_target
>> will select the correct frequency (within policy->min and policy->max).
>> Then, dbs_cpufreq_notifier will adjust requested_freq.
>
> Sorry, I couldn't understand what you meant here :(
>

I'm sorry. Let me try to explain this better.

With my patch, dbs_info->requested_freq will not be capped within
policy->min and policy->max in cs_check_cpu.
So, temporarily it may have a value greater than policy->max
or lower that policy->min.
When we call __cpufreq_driver_target, the correct frequency will be 
selected because __cpufreq_driver_target takes care to adjust the
target frequency within policy range.
But, eventually, dbs_cpufreq_notifier will adjust dbs_info->requested
within policy range, if needed.

If we remove
	if (dbs_info->requested_freq == policy->max)
		return;
and
	if (policy->cur == policy->min)
		return;

request_freq will keep increasing or decreasing in each iteration and
finally will overflow or underflow.

Consider, for example, that in a CPU with policy->max = 1000MHz
the current frequency is 950MHz. With a constant load above
up_threshold, the requested_freq in first iteration will be 1000MHz
and __cpufreq_driver_target will select 1000MHz freq.

In second iteration, requested_freq will be 1050MHz, and 
__cpufreq_driver_target will select 1000MHz. dbs_cpufreq_notifier
will adjust requested_freq back to 1000MHz.

In next iterations, dbs_cpufreq_notifier will not be called, so we
need the above check (dbs_info->requested_freq == policy->max) to
prevent requested_freq to grow arbitrary.

I hope my explanation was better now. :)


Thanks,
Stratos
