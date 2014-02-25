Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaBYPkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 10:40:11 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:47098 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaBYPkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 10:40:09 -0500
MIME-Version: 1.0
In-Reply-To: <530C76E7.8090607@linaro.org>
References: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org>
	<1393223377-5744-8-git-send-email-tuukka.tikkanen@linaro.org>
	<530C76E7.8090607@linaro.org>
Date: Tue, 25 Feb 2014 17:40:08 +0200
Message-ID: <CAG-99FNrtBf77Kx4z3fhmpMnttnoowpqMiWFUTTMmdroBr4FYw@mail.gmail.com>
Subject: Re: [PATCH 7/7] Cpuidle: poll state can measure residency
From: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 February 2014 12:56, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> On 02/24/2014 07:29 AM, Tuukka Tikkanen wrote:
>>
>> For some platforms, a poll state is inserted in the cpuidle driver states.
>> The flags for the state do not indicate that timekeeping is not affected.
>> As the state does not do anything apart from calling cpu_relax(), the
>> times returned by ktime_get should remain valid. Add the missing flag.
>
>
> Yes, but it is done with the interrupt enabled, so the interrupt handler +
> softirq handler times will be accounted in the residency time.
>
> I am not sure adding this flag is good.

Granted, with a slow CPU and very complex interrupt handing there
might be some extra time added. So let's consider what might happen:

Menu: Not having this flag assumes the residency matches time until
next timer expiry. Any measured amount of time less than that
indicates that the residency was shorter. We might not know exactly
how much, but we are closer to the truth and everything is fine. So
that leaves reporting time that exceeds what was established as the
time until next timer expiry. That too is OK (assuming another patch
in the series) as the value is limited to the time until next timer
expiry. In short, we get the same or better outcome and have no
issues.

Ladder: Last residency is assumed to be
last_state->threshold.promotion_time + 1 if the flag is not set.
Obviously we won't be considering demotion in that case and will go
into the promotion path. Any measured value below that is again closer
to the truth and any value at or above that is simply going to result
in the same outcome.

The only remaining issue is any hypothetical governor not currently in
the kernel tree. It would have to depend on accurate measurements
while being able to work with states that do not have the valid time
flag. I'm not sure if I can picture a scenario like that.

Tuukka

>
>> Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
>> ---
>>   drivers/cpuidle/driver.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
>> index 06dbe7c..136d6a2 100644
>> --- a/drivers/cpuidle/driver.c
>> +++ b/drivers/cpuidle/driver.c
>> @@ -209,7 +209,7 @@ static void poll_idle_init(struct cpuidle_driver *drv)
>>         state->exit_latency = 0;
>>         state->target_residency = 0;
>>         state->power_usage = -1;
>> -       state->flags = 0;
>> +       state->flags = CPUIDLE_FLAG_TIME_VALID;
>>         state->enter = poll_idle;
>>         state->disabled = false;
>>   }
>>
>
>
> --
>  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
>
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
