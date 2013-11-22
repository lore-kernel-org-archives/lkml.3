Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab3KVQbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:31:45 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:61022 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab3KVQbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:31:43 -0500
Message-ID: <528F86F2.40706@linaro.org>
Date: Fri, 22 Nov 2013 17:31:46 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@calxeda.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?VXdl?= =?UTF-8?B?IEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] clocksource: Do not drop unheld reference on device node
References: <1382136588-15320-1-git-send-email-treding@nvidia.com> <20131122161607.GA5088@ulmo.nvidia.com>
In-Reply-To: <20131122161607.GA5088@ulmo.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 05:16 PM, Thierry Reding wrote:
> On Sat, Oct 19, 2013 at 12:49:48AM +0200, Thierry Reding wrote:
>> When booting a recent kernel on ARM with OF_DYNAMIC enabled, the kernel
>> warns about the following:
>>
>> 	[    0.000000] ERROR: Bad of_node_put() on /timer@50004600
>> 	[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-rc5-next-20131017-00077-gedfd827-dirty #406
>> 	[    0.000000] [<c0015b68>] (unwind_backtrace+0x0/0xf4) from [<c00117e4>] (show_stack+0x10/0x14)
>> 	[    0.000000] [<c00117e4>] (show_stack+0x10/0x14) from [<c055f734>] (dump_stack+0x9c/0xc8)
>> 	[    0.000000] [<c055f734>] (dump_stack+0x9c/0xc8) from [<c03b47d4>] (of_node_release+0x90/0x9c)
>> 	[    0.000000] [<c03b47d4>] (of_node_release+0x90/0x9c) from [<c03b5084>] (of_find_matching_node_and_match+0x78/0xb4)
>> 	[    0.000000] [<c03b5084>] (of_find_matching_node_and_match+0x78/0xb4) from [<c07887c8>] (clocksource_of_init+0x60/0x70)
>> 	[    0.000000] [<c07887c8>] (clocksource_of_init+0x60/0x70) from [<c076e99c>] (start_kernel+0x1f4/0x33c)
>> 	[    0.000000] [<c076e99c>] (start_kernel+0x1f4/0x33c) from [<80008074>] (0x80008074)
>>
>> This is caused by clocksource_of_init() dropping a reference on the
>> device node that it never took. The reference taken by the loop is
>> implicitly dropped on subsequent iterations. See the implementation of
>> and the comment on top of the of_find_matching_node_and_match()
>> function for reference (no pun intended).
>>
>> Signed-off-by: Thierry Reding <treding@nvidia.com>
>> ---
>>   drivers/clocksource/clksrc-of.c | 1 -
>>   1 file changed, 1 deletion(-)
>
> Can someone look at this?

Yes. Sounds like I missed it.

This regression has been introduced by:

commit 326e31eebe61dc838e031ea16968b2cfb43443e3
Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date:   Tue Oct 1 11:00:53 2013 +0200

     clocksource: Put nodes passed to CLOCKSOURCE_OF_DECLARE callbacks 
centrally

     Instead of letting each driver call of_node_put do it centrally in the
     loop that also calls the CLOCKSOURCE_OF_DECLARE callbacks. This is less
     prone to error and also moves getting and putting the references 
into the
     same function.

     Consequently all respective of_node_put calls in drivers are removed.

     Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
     Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
     Acked-by: David Brown <davidb@codeaurora.org>


>> diff --git a/drivers/clocksource/clksrc-of.c b/drivers/clocksource/clksrc-of.c
>> index 35639cf4..b9ddd9e 100644
>> --- a/drivers/clocksource/clksrc-of.c
>> +++ b/drivers/clocksource/clksrc-of.c
>> @@ -35,6 +35,5 @@ void __init clocksource_of_init(void)
>>
>>   		init_func = match->data;
>>   		init_func(np);
>> -		of_node_put(np);
>>   	}
>>   }
>> --
>> 1.8.4
>>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

