Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab3CEOdC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:33:02 -0500
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:44823 "EHLO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab3CEOc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:32:59 -0500
Message-ID: <5135FD01.8060306@verisign.com>
Date: Tue, 05 Mar 2013 09:11:13 -0500
From: David C Niemi <dniemi@verisign.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Stratos Karafotis <stratosk@semaphore.gr>
CC: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] cpufreq: conservative: Fix sampling_down_factor
 functionality
References: <51351CC3.4010301@semaphore.gr> <CAOh2x=m0KLbjGKvLvTH7-yQb4SU5-v=-r4Ba3LSZz=NvfvO6mg@mail.gmail.com> <51358117.9060902@semaphore.gr>
In-Reply-To: <51358117.9060902@semaphore.gr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2013 14:11:12.0737 (UTC) FILETIME=[4AEB7510:01CE19AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am the author of sampling_down_factor.  I only intended it to have an effect if you are already attempting to achieve maximum performance (e.g. at the top available clock speed for the current infrastructure).  This is special because there is no possibility of going any faster so the only speed change you can think about is slowing down, which is typically much less urgent than speeding up.  So I did not see sampling_down_factor as being relevant at intermediate frequencies, though perhaps there could be something interesting but opposite to do at the minimum-power state too.

In the applications this was originally intended for you were likely to either be idle and trying to save power (but be ready to ramp up quickly), or at max speed, and rarely in between.  sampling_down_factor made a dramatic improvement in performance, to the point there was no longer any reason to use the "performance" governor.

I suspect the rationale for sampling_down_factor would apply to non-frequency-based governor/driver combos as well, like the p-state driver, though in that case you are not necessarily changing a literal clock speed and you also have additional opportunities like turbo/boost states to consider.  But in some applications, you may not want to use boost states that cannot be sustained when all cores are active, so there is more user/operator intent that must be communicated to the governor.

DCN

On 03/05/13 00:22, Stratos Karafotis wrote:
> Hi Viresh,
>
> On 03/05/2013 02:23 AM, Viresh Kumar wrote:> Interesting. Because it was removed earlier and no body complained :)
>> I got following from Documentation:
>>
>> sampling_down_factor: this parameter controls the rate at which the
>> kernel makes a decision on when to decrease the frequency while running
>> at top speed. When set to 1 (the default) decisions to reevaluate load
>> are made at the same interval regardless of current clock speed. But
>> when set to greater than 1 (e.g. 100) it acts as a multiplier for the
>> scheduling interval for reevaluating load when the CPU is at its top
>> speed due to high load. This improves performance by reducing the overhead
>> of load evaluation and helping the CPU stay at its top speed when truly
>> busy, rather than shifting back and forth in speed. This tunable has no
>> effect on behavior at lower speeds/lower CPU loads.
>>
>> And i believe we are supposed to check if we are at the top speed or not.
>> Over that i believe the code should be like:
>>
>> While setting speed to top speed, set the timer to delay * sampling_down_factor,
>> so that we actually don't reevaluate the load. What do you say?
>>
> I had the same thoughts, but I saw the comments in the code:
>
> /*
>  * Every sampling_rate, we check, if current idle time is less than 20%
>  * (default), then we try to increase frequency Every sampling_rate *
>  * sampling_down_factor, we check, if current idle time is more than 80%, then
>  * we try to decrease frequency
>  *
>
> Also checking the code before the commit 8e677ce83bf41ba9c74e5b6d9ee60b07d4e5ed93 you may see that sampling down factor works in this way.
> So, I decided to keep the original functionality (also down_skip was already there unused).
>
> Regards,
> Stratos
>
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

