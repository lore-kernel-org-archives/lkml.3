Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab3FDPUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:20:13 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:58000 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751173Ab3FDPUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:20:09 -0400
Message-ID: <51AE05A5.7080504@semaphore.gr>
Date: Tue, 04 Jun 2013 18:20:05 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: David C Niemi <dniemi@verisign.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] cpufreq: ondemand: Change the calculation of target
 frequency
References: <51ACF2EA.70001@semaphore.gr> <51ACFEBE.1050801@verisign.com>
In-Reply-To: <51ACFEBE.1050801@verisign.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 11:38 PM, David C Niemi wrote:
> 
> Interesting analysis; I just got back from vacation and have not had a chance to comment until now.
> 
> I like Stratos' general idea of making the decision to upshift or downshift independent of current frequency, as it makes thinks simpler and potentially more stable.  But I believe it will be important to measure performance and power consumption in a wider range of use cases to know whether it is an overall win (or whether it can at least be tuned to match the status quo for various use cases).
> 
> In my main use case (network servers), I don't think using more middle frequencies is a good thing at all; as soon as a load gets heavy even briefly I want the CPU doing all it can until the load has clearly abated.  The main competition in this use case is between using ondemand (tuned for performance at the cost of some extra power consumption) or the "performance" governor (which cannot be tuned at all, and where C-states are the only hope for moderating power consumption).
> 
> A couple of additional points -- it is possible to get excellent overall performance and avoid oscillation using ondemand right now by using a low up_threshold and a sampling_down_factor of around 100; in this case you spend most of your time at either the lowest or highest possible frequency and you spend very little time thinking about slowing down.  The main downside of this is an increase in power consumption, so it is not a battery-friendly approach, but someone will need to also measure power consumption if we want to justify a change from the status quo on that basis.  There are dozens of ways to save power at the expense of performance or vice versa, so any major change like this needs to be analyzed for both, in case your patch just results in running at higher average frequencies and gets its performance boost from that.
> 
> David C Niemi

Hi David, 
Thanks for your comments!

In your case, the behavior of ondemand will not change to the worst.
up_threshold/sampling down factor remain as is. 
So, for loads above up_threshold ondemand will behave the same.

For loads lower than up_threshold, CPU will remain in lowest
frequency or downshift to a middle one with the old method.
After this patch, CPU will remain to the lowest or downshift to a
middle frequency or upshift to a middle frequency. So, I think we will
have a better performance, with the patch.

I know that CPU load tends to be chaotic, but please let me try to explain
my logic with a theoretical example to compare ondemand with and without
this patch that I think it will be valid in many cases.

Let's assume for simplicity a single core CPU with available
frequencies 100-1000MHz in steps of 100MHz. The architecture does
not support APERF/MPERF to measure average frequency. All tunables
to default values. As initial state we consider that the CPU is
idling in 100MHz with load = 0 (ideally).

A process needs CPU time and in the next iteration ondemand calculates
the load of the previous sampling interval.
There are 3 different possible paths:
1) Load is greater than up_threshold: with or without the patch, CPU will increase to max.
2) Load is lower than 10: with or without the patch, CPU will remain in the lowest freq.
3) Load between 10 and up_threshold, for example 50:
	without this patch, CPU will remain to 100MHz
	with this patch, CPU will increase to a frequency that it's directly
	proportional to load (500MHz)

If we concern about performance, ondemand will behave better with this patch
for case 3. But what about power consumption? I would say that this depends
on the duration of load:

3a) Suppose that the process causes a CPU load of 50 for 5 sampling periods without this patch.
Without this patch, the CPU will remain for 5 sampling periods in 100MHz
With this patch, CPU will increase to 500Mhz, most probably, for ~1 sampling period.

3b) The process causes a CPU load of 50 for 1 sampling period.
Without this patch, the CPU will remain to 100MHz for 1 sampling period
With this patch, the CPU will increase to 500MHz for 1 sampling period

3c) The process causes a CPU load of 50, and then increases to 100 for next iterations
(most probably because the process started in the middle of sampling period).
Without this patch CPU will remain to 100MHz for the 1st period and then
it will increase to 1000MHz for next iterations.
With this patch the CPU will increase to 500MHz for the 1st period and then
it will increase to 1000MHz for next iterations.

The only case that the new method will be less power efficient is b) but I think there will be
significant improvement in performance for a) and c)

The results will be similar when the governor upshifts from any other frequency.

Using the highest frequency, the proposed method will downshift to lower frequencies
because with the 'old' method the calculation it's dependent from the current frequency
and up_threshold.

In this simplified example the new method seems to have a better ratio of
performance/power consumption.

I don't know if it is appropriate to mention that I use the proposed method
in 3.4.47 and 3.0.80 kernels for two embedded devices (smart phones). There are
about 2,000 installations and no reports for increased power consumption (so far).
Of course this is not a proof but maybe and indication.
But unfortunately, I don't have measurements about the ratio of performance/consumption.

Thanks,
Stratos

