Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaJ1S2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:28:10 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:52523 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaJ1S2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:28:08 -0400
Message-ID: <544FE032.5050900@linaro.org>
Date: Tue, 28 Oct 2014 19:28:02 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Preeti Murthy <preeti.lkml@gmail.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        patches@linaro.org, Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH V2 3/5] cpuidle: idle: menu: Don't reflect when a state
 selection failed
References: <1414054881-17713-1-git-send-email-daniel.lezcano@linaro.org>	<1414054881-17713-3-git-send-email-daniel.lezcano@linaro.org> <CAM4v1pO9e7r10KX=D=9aVTV_ecvPa-aJOoB6PAwR5jxMS3eg4w@mail.gmail.com>
In-Reply-To: <CAM4v1pO9e7r10KX=D=9aVTV_ecvPa-aJOoB6PAwR5jxMS3eg4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 08:01 AM, Preeti Murthy wrote:
> On Thu, Oct 23, 2014 at 2:31 PM, Daniel Lezcano
> <daniel.lezcano@linaro.org> wrote:
>> In the current code, the check to reflect or not the outcoming state is done
>> against the idle state which has been chosen and its value.
>>
>> Instead of doing a check in each of the reflect functions, just don't call reflect
>> if something went wrong in the idle path.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Acked-by: Nicolas Pitre <nico@linaro.org>
>> ---
>>   drivers/cpuidle/governors/ladder.c | 3 +--
>>   drivers/cpuidle/governors/menu.c   | 4 +---
>>   kernel/sched/idle.c                | 3 ++-
>>   3 files changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
>> index fb396d6..c0b36a8 100644
>> --- a/drivers/cpuidle/governors/ladder.c
>> +++ b/drivers/cpuidle/governors/ladder.c
>> @@ -165,8 +165,7 @@ static int ladder_enable_device(struct cpuidle_driver *drv,
>>   static void ladder_reflect(struct cpuidle_device *dev, int index)
>>   {
>>          struct ladder_device *ldev = &__get_cpu_var(ladder_devices);
>> -       if (index > 0)
>> -               ldev->last_state_idx = index;
>> +       ldev->last_state_idx = index;
>>   }
>>
>>   static struct cpuidle_governor ladder_governor = {
>> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
>> index a17515f..3907301 100644
>> --- a/drivers/cpuidle/governors/menu.c
>> +++ b/drivers/cpuidle/governors/menu.c
>> @@ -365,9 +365,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
>>   static void menu_reflect(struct cpuidle_device *dev, int index)
>>   {
>>          struct menu_device *data = &__get_cpu_var(menu_devices);
>> -       data->last_state_idx = index;
>> -       if (index >= 0)
>> -               data->needs_update = 1;
>> +       data->needs_update = 1;
>
> Why is the last_state_idx not getting updated ?

Oups, right. This is missing.

Thanks for pointing this out.

By the way, I don't think a back end driver is changing the selected 
state currently and I am not sure this is desirable since we want to 
trust the state we are going (as a best effort). So if the 'enter' 
function does not change the index, that means the last_state_idx has 
not to be changed since it has been assigned in the 'select' function.



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

