Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab3JAQLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:11:17 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56634 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3JAQLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:11:14 -0400
Message-ID: <524AF322.8040200@linux.vnet.ibm.com>
Date: Tue, 01 Oct 2013 21:36:58 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        g.liakhovetski@gmx.de, amit.daniel@samsung.com, kgene.kim@samsung.com
Subject: Re: [PATCH 2/2] cpufreq: make sure frequency transitions are serialized
References: <a0cad3326c6a6c8f0517332dd2230edaf67268e7.1378979483.git.viresh.kumar@linaro.org> <793a5fadad931d04c2adb3a61c64063b7e62d083.1378979483.git.viresh.kumar@linaro.org> <1791712.tJBFGgQvyI@vostro.rjw.lan>
In-Reply-To: <1791712.tJBFGgQvyI@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100116-0260-0000-0000-000003B6F876
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 12:07 AM, Rafael J. Wysocki wrote:
> On Thursday, September 12, 2013 03:40:46 PM Viresh Kumar wrote:
>> Some part of this patch was pushed in mainline earlier but was then removed due
>> to loopholes in the patch. Those are now fixed and this patch is tested by the
>> people who reported these problems.
>>
>> Whenever we are changing frequency of a cpu, we are calling PRECHANGE and
>> POSTCHANGE notifiers. They must be serialized. i.e. PRECHANGE or POSTCHANGE
>> shouldn't be called twice contiguously. Also, calls to cpufreq_driver_target()
>> or cpufreq_driver->target() must also be serialized. Following examples show why
>> this is important:
>>
>> Scenario 1:
>> -----------
>> One thread reading value of cpuinfo_cur_freq, which will call
>> __cpufreq_cpu_get()->cpufreq_out_of_sync()->cpufreq_notify_transition()..
>>
>> And ondemand governor trying to change freq of cpu at the same time and so
>> sending notification via ->target()..
>>
>> Notifiers are not serialized and suppose this is what happened
>> - PRECHANGE Notification for freq A (from cpuinfo_cur_freq)
>> - PRECHANGE Notification for freq B (from target())
>> - Freq changed by target() to B
>> - POSTCHANGE Notification for freq B
>> - POSTCHANGE Notification for freq A
>>
>> Now the last POSTCHANGE Notification happened for freq A and hardware is
>> currently running at freq B :)
>>
>> Where would we break then?: adjust_jiffies() in cpufreq.c,
>> cpufreq_callback() in arch/arm/kernel/smp.c (which is also adjusting
>> jiffies).. All loops_per_jiffy based stuff is broken..
>>
>> Scenario 2:
>> -----------
>> Governor is changing freq and has called __cpufreq_driver_target(). At the same
>> time we are changing scaling_{min|max}_freq from sysfs, which would eventually
>> end up calling governor's: CPUFREQ_GOV_LIMITS notification, that will also call:
>> __cpufreq_driver_target().. And hence concurrent calls to ->target()
>>
>> And Platform have something like this in their ->target()
>> (Like: cpufreq-cpu0, omap, exynos, etc)
>>
>> A. If new freq is more than old: Increase voltage
>> B. Change freq
>> C. If new freq is less than old: decrease voltage
>>
>> Now, two concurrent calls to target are X and Y, where X is trying to increase
>> freq and Y is trying to decrease it..
>>
>> And this is the sequence that followed due to races..
>>
>> X.A: voltage increased for larger freq
>> Y.A: nothing happened here
>> Y.B: freq decreased
>> Y.C: voltage decreased
>> X.B: freq increased
>> X.C: nothing happened..
>>
>> We ended up setting a freq which is not supported by the voltage we have
>> set.. That will probably make clock to CPU unstable and system wouldn't
>> be workable anymore...
>>
>> This patch adds some protection against to make transitions serialized.
>>
>> Tested-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> So the problem is real, but the fix seems to be of a "quick and dirty" kind.
> 
> First of all, it looks like we need a clear "begin transition" call that
> I suppose drivers should execute from their .target() methods once they have
> decided to do a transition.  That would increment the "ongoing" counter etc.
> 
> Second, we need a corresponding "end transition" call that would be executed
> whenever appropriate from the driver's perspective.
> 
> Clearly, these two things should be independent of the notifiers and the
> notifications should only be done between "begin transition" and "end
> transition" and only by whoever called the "begin transition" to start with.
> 
> Now, question is what should happen if "begin transition" is called when
> the previous transition hasn't been completed yet, should it block or should
> it fail?  There seem to be arguments for both, but I suppose blocking would be
> easier to implement.
>

I agree with Rafael. We really need an elegant solution for this problem,
something whose very semantics makes it easy and almost intuitive to get the
synchronization right. Otherwise it might become too easy to get things wrong
in these cases.

Regards,
Srivatsa S. Bhat

