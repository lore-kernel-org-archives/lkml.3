Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaGJJQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:16:42 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:42053 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaGJJQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:16:40 -0400
Message-ID: <53BE59F2.1090102@collabora.com>
Date: Thu, 10 Jul 2014 11:16:34 +0200
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, rabin@rab.in,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: Rabin Vincent <rabin.vincent@stericsson.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [RFC v2 3/5] clk: use struct clk only for external API
References: <1404398323-18934-1-git-send-email-tomeu.vizoso@collabora.com> <1404398323-18934-4-git-send-email-tomeu.vizoso@collabora.com> <53BDA21D.3070504@gmail.com>
In-Reply-To: <53BDA21D.3070504@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 10:12 PM, Tomasz Figa wrote:
> Actually few more comments, see inline.
>
> On 03.07.2014 16:38, Tomeu Vizoso wrote:
>> From: Rabin Vincent <rabin.vincent@stericsson.com>
>>
>> In order to provide per-user accounting, this separates the struct clk
>> used in the common clock framework into two structures 'struct clk_core'
>> and 'struct clk'.  struct clk_core will be used for internal
>> manipulation and struct clk will be used in the clock API
>> implementation.
>
> [snip]
>
>> diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
>> index 8f57154..5f2aba9 100644
>> --- a/drivers/clk/clk-devres.c
>> +++ b/drivers/clk/clk-devres.c
>> @@ -5,6 +5,7 @@
>>    */
>>
>>   #include <linux/clk.h>
>> +#include <linux/clk-provider.h>
>>   #include <linux/device.h>
>>   #include <linux/export.h>
>>   #include <linux/gfp.h>
>> @@ -14,15 +15,15 @@ static void devm_clk_release(struct device *dev, void *res)
>>   	clk_put(*(struct clk **)res);
>
> This function still expects to get a (struct clk *) here, but...
>
>>   }
>>
>> -struct clk *devm_clk_get(struct device *dev, const char *id)
>> +struct clk_core *devm_clk_provider_get(struct device *dev, const char *id)
>>   {
>> -	struct clk **ptr, *clk;
>> +	struct clk_core **ptr, *clk;
>>
>>   	ptr = devres_alloc(devm_clk_release, sizeof(*ptr), GFP_KERNEL);
>>   	if (!ptr)
>>   		return ERR_PTR(-ENOMEM);
>>
>> -	clk = clk_get(dev, id);
>> +	clk = clk_provider_get(dev, id);
>>   	if (!IS_ERR(clk)) {
>>   		*ptr = clk;
>
> ...here a (struct clk_core *) is stored.

Thanks, well spotted.

>>   		devres_add(dev, ptr);
>
> [snip]
>
>> diff --git a/drivers/clk/clk.h b/drivers/clk/clk.h
>> index d278572..c69f4fe 100644
>> --- a/drivers/clk/clk.h
>> +++ b/drivers/clk/clk.h
>> @@ -15,3 +15,7 @@ struct clk_core *__of_clk_get_from_provider(struct of_phandle_args *clkspec);
>>   void of_clk_lock(void);
>>   void of_clk_unlock(void);
>>   #endif
>> +
>> +#if defined(CONFIG_COMMON_CLK)
>> +#define clk_to_clk_core(clk)	(clk->core)
>
> Making this a static inline will benefit you with type checking at
> compilation time.

Good point.

>> +#endif
>
> [snip]
>
>> +
>> +#define clk_core_to_clk(core)	((struct clk *)(core))
>
> Hmm, I'm not following. clk_to_clk_core() returns clk->core, while
> clk_core_to_clk() simply casts whatever the former returns into a
> pointer to struct clk?

Yeah, this is totally wrong, v3 will be fixing this, I have tested it on 
an Odroid U2, so the most embarrassing issues have been fixed.

Thanks,

Tomeu

> Also this should be a static inline to benefit from compiler type checking.
>
> Best regards,
> Tomasz
>

