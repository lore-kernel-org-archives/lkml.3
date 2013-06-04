Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab3FDRK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:10:57 -0400
Received: from exprod6og119.obsmtp.com ([64.18.1.234]:57067 "EHLO
	exprod6og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880Ab3FDRAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:00:42 -0400
Message-ID: <51AE1D34.7060908@verisign.com>
Date: Tue, 04 Jun 2013 13:00:36 -0400
From: David C Niemi <dniemi@verisign.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stratos Karafotis <stratosk@semaphore.gr>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] cpufreq: ondemand: Change the calculation of target
 frequency
References: <51ACF2EA.70001@semaphore.gr> <51ACFEBE.1050801@verisign.com> <51AE05A5.7080504@semaphore.gr>
In-Reply-To: <51AE05A5.7080504@semaphore.gr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2013 17:00:36.0838 (UTC) FILETIME=[08C97060:01CE6145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for the detailed response.  I am heartened by the edge cases (true idle and above up_threshold) remaining the same, that sounds like it should cover a lot of ground well.

David C Niemi


On 06/04/13 11:20, Stratos Karafotis wrote:
> Hi David, 
> Thanks for your comments!
>
> In your case, the behavior of ondemand will not change to the worst.
> up_threshold/sampling down factor remain as is. 
> So, for loads above up_threshold ondemand will behave the same.
>
> For loads lower than up_threshold, CPU will remain in lowest
> frequency or downshift to a middle one with the old method.
> After this patch, CPU will remain to the lowest or downshift to a
> middle frequency or upshift to a middle frequency. So, I think we will
> have a better performance, with the patch.
>
> I know that CPU load tends to be chaotic, but please let me try to explain
> my logic with a theoretical example to compare ondemand with and without
> this patch that I think it will be valid in many cases.
>
> Let's assume for simplicity a single core CPU with available
> frequencies 100-1000MHz in steps of 100MHz. The architecture does
> not support APERF/MPERF to measure average frequency. All tunables
> to default values. As initial state we consider that the CPU is
> idling in 100MHz with load = 0 (ideally).
>
> A process needs CPU time and in the next iteration ondemand calculates
> the load of the previous sampling interval.
> There are 3 different possible paths:
> 1) Load is greater than up_threshold: with or without the patch, CPU will increase to max.
> 2) Load is lower than 10: with or without the patch, CPU will remain in the lowest freq.
> 3) Load between 10 and up_threshold, for example 50:
> 	without this patch, CPU will remain to 100MHz
> 	with this patch, CPU will increase to a frequency that it's directly
> 	proportional to load (500MHz)
>
> If we concern about performance, ondemand will behave better with this patch
> for case 3. But what about power consumption? I would say that this depends
> on the duration of load:
>
> 3a) Suppose that the process causes a CPU load of 50 for 5 sampling periods without this patch.
> Without this patch, the CPU will remain for 5 sampling periods in 100MHz
> With this patch, CPU will increase to 500Mhz, most probably, for ~1 sampling period.
>
> 3b) The process causes a CPU load of 50 for 1 sampling period.
> Without this patch, the CPU will remain to 100MHz for 1 sampling period
> With this patch, the CPU will increase to 500MHz for 1 sampling period
>
> 3c) The process causes a CPU load of 50, and then increases to 100 for next iterations
> (most probably because the process started in the middle of sampling period).
> Without this patch CPU will remain to 100MHz for the 1st period and then
> it will increase to 1000MHz for next iterations.
> With this patch the CPU will increase to 500MHz for the 1st period and then
> it will increase to 1000MHz for next iterations.
>
> The only case that the new method will be less power efficient is b) but I think there will be
> significant improvement in performance for a) and c)
>
> The results will be similar when the governor upshifts from any other frequency.
>
> Using the highest frequency, the proposed method will downshift to lower frequencies
> because with the 'old' method the calculation it's dependent from the current frequency
> and up_threshold.
>
> In this simplified example the new method seems to have a better ratio of
> performance/power consumption.
>
> I don't know if it is appropriate to mention that I use the proposed method
> in 3.4.47 and 3.0.80 kernels for two embedded devices (smart phones). There are
> about 2,000 installations and no reports for increased power consumption (so far).
> Of course this is not a proof but maybe and indication.
> But unfortunately, I don't have measurements about the ratio of performance/consumption.
>
> Thanks,
> Stratos

