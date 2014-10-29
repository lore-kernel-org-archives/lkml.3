Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbaJ2SPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:15:39 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47365 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291AbaJ2SPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:15:35 -0400
Message-ID: <54512EC6.4010901@linaro.org>
Date: Wed, 29 Oct 2014 19:15:34 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linaro-kernel@lists.linaro.org,
        Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH V2 4/5] cpuidle: menu: Fix the get_typical_interval
References: <1414054881-17713-1-git-send-email-daniel.lezcano@linaro.org>	<1414054881-17713-4-git-send-email-daniel.lezcano@linaro.org> <CAJvTdKk=uQmon81Y8+jVmYggxg-K2sWC4vEFM+bycKCEAt0fFg@mail.gmail.com>
In-Reply-To: <CAJvTdKk=uQmon81Y8+jVmYggxg-K2sWC4vEFM+bycKCEAt0fFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 03:48 AM, Len Brown wrote:
> On Thu, Oct 23, 2014 at 5:01 AM, Daniel Lezcano
> <daniel.lezcano@linaro.org> wrote:
>> The first time the 'get_typical_function' is called, it computes an average
>> of zero as no data is filled yet. That leads the 'data->predicted_us' variable
>> to be set to zero too.
>>
>> The caller, 'menu_select' will then do:
>>
>>          interactivity_req = data->predicted_us /
>>                          performance_multiplier(nr_iowaiters, cpu_load);
>>
>> That sets the interactivity_req to zero (0/performance...).
>>
>> and then
>>
>>          if (latency_req > interactivity_req)
>>                  latency_req = interactivity_req;
>>
>> ... setting 'latency_req' to zero too.
>>
>> No idle state will fulfill this constraint and we will go the C1 state as
>> default and leading to an update. So the next calls will compute an average
>> different from zero.
>>
>> Even if that works with the current code but with a broken semantic, it will
>> just break with the next patches where we are stricter with the latencies
>> check: the first check will fail (latency_req is zero), then no update will
>> occur leading to always falling to choose an idle state.
>>
>> As there are no previous values and it is pointless to compute a standard
>> deviation for these unexisting values. Just return without setting the
>> 'data->predicted_us' to zero.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> ---
>>   drivers/cpuidle/governors/menu.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
>> index 3907301..6ae8390 100644
>> --- a/drivers/cpuidle/governors/menu.c
>> +++ b/drivers/cpuidle/governors/menu.c
>> @@ -226,6 +226,15 @@ again:
>>          else
>>                  do_div(avg, divisor);
>>
>> +       /*
>> +        * We are at the very beginning and no data have been filled
>> +        * yet. Let's skip the standard deviation computation
>> +        * otherwise the data->predicted_us will be zero and that will
>> +        * lead to a zero latency req in the select function
>> +        */
>> +       if (!avg)
>> +               return;
>> +
>
> Unfortunately, you've touched ugly code,
> and your (correct) patch makes it ever-so slightly more ugly,
> instead of more clear.
>
> I think the code would read more clearly, and your patch would
> less obscure, if the code read something like this sow that it is
> clear at the menu_select level when and where we monkey
> with predicted_us:
>
> menu_select()...
> ...
> data->predicted_us = div_round64(bla bla bla
>
> interactivity_overrride_us = get_typical_interval(data);
>
> if (interactivity_override_us)
>    if (interactivity_predicted_us < data->predicted_us)
>          data->predicted_us = interactivity_override_us;
>
> And, of course, down inside get_typical_interval()
> ...
> if (!avg)
>          return 0;
> ...
> if (likely(stddev <= ULONG_MAX)) {
> ...
>          return avg;


Ok, thanks for the suggestion. I will look at reworking this patch.

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

