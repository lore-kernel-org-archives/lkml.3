Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab3FERNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:13:31 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:34329 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756413Ab3FERN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:13:29 -0400
Message-ID: <51AF71B6.6030408@semaphore.gr>
Date: Wed, 05 Jun 2013 20:13:26 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of target
 frequency
References: <51AF60D5.3080605@semaphore.gr> <20130605161703.GA29958@pd.tnic>
In-Reply-To: <20130605161703.GA29958@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On 06/05/2013 07:17 PM, Borislav Petkov wrote:
> On Wed, Jun 05, 2013 at 07:01:25PM +0300, Stratos Karafotis wrote:
>> Ondemand calculates load in terms of frequency and increases it only
>> if the load_freq is greater than up_threshold multiplied by current
>> or average frequency. This seems to produce oscillations of frequency
>> between min and max because, for example, a relatively small load can
>> easily saturate minimum frequency and lead the CPU to max. Then, the
>> CPU will decrease back to min due to a small load_freq.
>
> Right, and I think this is how we want it, no?
>
> The thing is, the faster you finish your work, the faster you can become
> idle and save power.

This is exactly the goal of this patch. To use more efficiently middle
frequencies to finish faster the work.

> If you switch frequencies in a staircase-like manner, you're going to
> take longer to finish, in certain cases, and burn more power while doing
> so.

This is not true with this patch. It switches to middle frequencies
when the load < up_threshold.
Now, ondemand does not increase freq. CPU runs in lowest freq till the
load is greater than up_threshold.

> Btw, racing to idle is also a good example for why you want boosting:
> you want to go max out the core but stay within power limits so that you
> can finish sooner.
>
>> This patch changes the calculation method of load and target frequency
>> considering 2 points:
>> - Load computation should be independent from current or average
>> measured frequency. For example an absolute load 80% at 100MHz is not
>> necessarily equivalent to 8% at 1000MHz in the next sampling interval.
>> - Target frequency should be increased to any value of frequency table
>> proportional to absolute load, instead to only the max. Thus:
>>
>> Target frequency = C * load
>>
>> where C = policy->cpuinfo.max_freq / 100
>>
>> Tested on Intel i7-3770 CPU @ 3.40GHz and on Quad core 1500MHz Krait.
>> Phoronix benchmark of Linux Kernel Compilation 3.1 test shows an
>> increase ~1.5% in performance. cpufreq_stats (time_in_state) shows
>> that middle frequencies are used more, with this patch. Highest
>> and lowest frequencies were used less by ~9%
>
> I read this as "the workload takes longer to complete" which means
> higher power consumption and longer execution times which means less
> time spent in idle. And I don't think we want that.
>
> Yes, no?

In my opinion, no.
Running the benchmark mentioned in changelog shows shorter execution
time by ~1.5%

Thanks,
Stratos
