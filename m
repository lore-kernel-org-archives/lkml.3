Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab3HaAs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 20:48:58 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49722 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab3HaAs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 20:48:56 -0400
Message-ID: <52213D76.3030304@codeaurora.org>
Date: Fri, 30 Aug 2013 17:48:54 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>,
        Gerlando Falauto <gerlando.falauto@keymile.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Brunck, Holger" <Holger.Brunck@keymile.com>,
        "Longchamp, Valentin" <Valentin.Longchamp@keymile.com>,
        "Bigler, Stefan" <Stefan.Bigler@keymile.com>
Subject: Re: kernel deadlock
References: <521F6D06.1040107@keymile.com> <E92455D61233364C88CCD4A6DAB2E2850E09518110@SRVDEHAN1MX1.keymile.net> <521FDD12.7050000@linaro.org> <52212511.9050206@keymile.com> <5221264F.4070402@linaro.org>
In-Reply-To: <5221264F.4070402@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/13 16:10, John Stultz wrote:
> On 08/30/2013 04:04 PM, Gerlando Falauto wrote:
>> Hi,
>>
>> sorry, it took me a while to narrow it down...
>>
>> On 08/30/2013 01:45 AM, John Stultz wrote:
>>> On 08/29/2013 01:56 PM, Falauto, Gerlando wrote:
>>>> Hi everyone,
>>>>
>>>> I ran into the deadlock situation reported at the bottom.
>>>> Actually, on my latest 3.10 kernel for some reason I don't get the
>>>> report (the kernel just hangs for some reason), so it took me quite
>>>> some
>>>> time to track it down.
>>>>
>>>> Once I figured the trigger to the machine hanging was adjtimex(), I
>>>> reverted everything (between 3.9 to 3.10) that was touching
>>>> kernel/time/timekeeping/timekeeping.c and kernel/time/ntp.c, I double
>>>> checked that indeed the problem was not happening anymore, and finally
>>>> started bisecting, landing on the following offending commit.
>>>> THEN, and ONLY THEN, did I get the &%""ç+"% deadlock report.
>>>>
>>>> Do you guys have any ideas what could be wrong and how to fix it?
>>> Thanks for the report!
>>>
>>> What exactly is your process for reproducing the issue?
>> Now (well, now...), it's quite easy.
>>
>> Three ingredients:
>>
>> 1) Kernel 3.10
>>
>> 2) Enable HRTICK
>>
>> diff --git a/kernel/sched/features.h b/kernel/sched/features.h
>> index 99399f8..294e3ca 100644
>> --- a/kernel/sched/features.h
>> +++ b/kernel/sched/features.h
>> @@ -41,7 +41,7 @@ SCHED_FEAT(WAKEUP_PREEMPTION, true)
>>   */
>>  SCHED_FEAT(ARCH_POWER, true)
>>
>> -SCHED_FEAT(HRTICK, false)
>> +SCHED_FEAT(HRTICK, true)
>>  SCHED_FEAT(DOUBLE_TICK, false)
>>  SCHED_FEAT(LB_BIAS, true)
>>
>> 3) Run the following:
>>
>> #include <stdio.h>
>> #include <sys/timex.h>
>>
>> int main(void)
>> {
>>     int i;
>>
>>     for (i = 0 ; ; i++) {
>>     struct timex adj = {};
>>     printf("%d\r", i);
>>     fflush(stdout);
>>     adjtimex(&adj);
>>     }
>>     return 0;
>> }
>>
>> Notice how:
>> 1) The original issue (with a bit more complicated scenario) was seen
>> on ARM and PowerPC platforms
>> 2) Under the above test conditions (on ARM) I *don't* get any deadlock
>> report printed, the machine just hangs
>> 3) The offending commit (below) I had found through a weird (manual)
>> process of reverting and re-reverting (where some commits could have
>> been reverted out of order), so I'm not 100% sure you'd come to the
>> same conclusions.
>>
>> commit 06c017fdd4dc48451a29ac37fc1db4a3f86b7f40
>> Author: John Stultz <john.stultz@linaro.org>
>> Date:   Fri Mar 22 11:37:28 2013 -0700
>>
>>      timekeeping: Hold timekeepering locks in do_adjtimex and hardpps
>>
>> I'm not able to perform any further testing at this very moment, but
>> if needed, I can try bisecting again sometime next week, so to make an
>> even more reliable statement.
>>
>>

Just curious. Do you have this patch from 3.11 applied to your 3.10
kernel tree?

commit 971ee28cbd1ccd87b3164facd9359a534c1d2892
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Jun 28 11:18:53 2013 +0200

    sched: Fix HRTICK
   
    David reported that the HRTICK sched feature was borken; which was
enough
    motivation for me to finally fix it ;-)
   
    We should not allow hrtimer code to do softirq wakeups while holding
schedul
er
    locks. The hrtimer code only needs this when we accidentally try to
program
an
    expired time. We don't much care about those anyway since we have
the regula
r
    tick to fall back to.
   
    Reported-by: David Ahern <dsahern@gmail.com>
    Tested-by: David Ahern <dsahern@gmail.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Link:
http://lkml.kernel.org/r/20130628091853.GE29209@dyad.programming.kicks
-ass.net
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

