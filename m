Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3KSXdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:33:10 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:36916 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab3KSXdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:33:06 -0500
Message-ID: <528BF535.1030504@linaro.org>
Date: Wed, 20 Nov 2013 00:33:09 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: ux500: decomission the non-DT MTU init sequence
References: <1384896471-9384-1-git-send-email-linus.walleij@linaro.org>	<528BE8F2.3030507@linaro.org> <CACRpkdab=1xJtcAg-_oUBr_jC5DgDre-f9jxuzDnZmXGFShvLw@mail.gmail.com>
In-Reply-To: <CACRpkdab=1xJtcAg-_oUBr_jC5DgDre-f9jxuzDnZmXGFShvLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 11:55 PM, Linus Walleij wrote:
> On Tue, Nov 19, 2013 at 11:40 PM, Daniel Lezcano
> <daniel.lezcano@linaro.org> wrote:
>> On 11/19/2013 10:27 PM, Linus Walleij wrote:
>
>>> -       if (!of_have_populated_dt())
>>> -               nmdk_timer_init(mtu_timer_base, IRQ_MTU0);
>>
>> If no timer have been defined in the dt [or wrongly defined], is there a
>> message to tell the user what is wrong ?
>
> Isn't that a question to be asked about a whole lot of such
> clocksource drivers and ARM platforms?

Yes, I did the comment based on your patch but I agree it must be 
addressed in a global manner.

> Most DT-only ARM platforms rely on
> arch/arm/kernel/time.c to call clocksource_of_init() if the
> machine_desc->init_time() hook is not set and has zero
> code to handle any such situation.
>
> So I guess what you're asking is whether we should patch
> clocksource_of_init() to warn if it cannot find any
> matching clock sources, like this:
>
>  From e55cf038b238d96b28d9fb01b5b6cdf345990d53 Mon Sep 17 00:00:00 2001
> From: Linus Walleij <linus.walleij@linaro.org>
> Date: Tue, 19 Nov 2013 23:52:56 +0100
> Subject: [PATCH] clksrc-of: warn if no clock sources are found
>
> Many platforms rely on clocksource_of_init() being implicitly
> called for registering clock sources and will get zero warnings
> if no working clock source is available. Let's print a critical
> error message if no clock source is found.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Yes, it sounds right to do this.

Thanks !

   -- Daniel

> ---
>   drivers/clocksource/clksrc-of.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/clocksource/clksrc-of.c b/drivers/clocksource/clksrc-of.c
> index 35639cf4e5a2..a30b42c3ac3b 100644
> --- a/drivers/clocksource/clksrc-of.c
> +++ b/drivers/clocksource/clksrc-of.c
> @@ -28,6 +28,7 @@ void __init clocksource_of_init(void)
>       struct device_node *np;
>       const struct of_device_id *match;
>       clocksource_of_init_fn init_func;
> +    unsigned clocksources = 0;
>
>       for_each_matching_node_and_match(np, __clksrc_of_table, &match) {
>           if (!of_device_is_available(np))
> @@ -36,5 +37,8 @@ void __init clocksource_of_init(void)
>           init_func = match->data;
>           init_func(np);
>           of_node_put(np);
> +        clocksources++;
>       }
> +    if (!clocksources)
> +        pr_crit("%s: no matching clocksources found\n", __func__);
>   }
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

