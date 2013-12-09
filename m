Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157Ab3LIJzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:55:35 -0500
Received: from top.free-electrons.com ([176.31.233.9]:34262 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932268Ab3LIJzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:55:33 -0500
Message-ID: <52A5938E.40201@free-electrons.com>
Date: Mon, 09 Dec 2013 10:55:26 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] pinctrl: at91: initialize config parameter to 0
References: <1386421734-10240-1-git-send-email-alexandre.belloni@free-electrons.com> <1386421734-10240-2-git-send-email-alexandre.belloni@free-electrons.com> <52A57E55.40808@atmel.com>
In-Reply-To: <52A57E55.40808@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/12/2013 09:24, Nicolas Ferre wrote:
> On 07/12/2013 14:08, Alexandre Belloni :
>> When passing a not initialized config parameter, at91_pinconf_get()
>> would return
>> a bogus value. Fix that by initializing it to zero before using it.
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>> ---
>>   drivers/pinctrl/pinctrl-at91.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/pinctrl/pinctrl-at91.c
>> b/drivers/pinctrl/pinctrl-at91.c
>> index 6446dc804aa7..b0b78f3468ae 100644
>> --- a/drivers/pinctrl/pinctrl-at91.c
>> +++ b/drivers/pinctrl/pinctrl-at91.c
>> @@ -722,7 +722,8 @@ static int at91_pinconf_get(struct pinctrl_dev
>> *pctldev,
>>       unsigned pin;
>>       int div;
>>
>> -    dev_dbg(info->dev, "%s:%d, pin_id=%d, config=0x%lx", __func__,
>> __LINE__, pin_id, *config);
>> +    *config = 0;
>> +    dev_dbg(info->dev, "%s:%d, pin_id=%d", __func__, __LINE__, pin_id);
>>       pio = pin_to_controller(info, pin_to_bank(pin_id));
>>       pin = pin_id % MAX_NB_GPIO_PER_BANK;
>
> Beyond this patch, I must say that I am puzzled by this function.
>
> What I read from the prototype documentation and what I see in
> different implementations is different...
>
> Linus, can we have a review of this function because it seems not in
> line with what is used for u300 (but on the other hand looks like the
> what is returned by pinctrl-exynos5440.c driver for example).
>
> What would be the consequences if we change this function's behavior:
> I mean use of -EINVAL for pin configuration "available but disabled"
> as said in include/linux/pinctrl/pinconf.h?
>

>From what I understand, it doesn't really matter because that function
is never used. I guess the best implementation is the tegra one ;)

It is only called in one specific case:
 - you have ops->is_generic == true (that is only true for a few
implmentations)
 - and you are dumping the pinconf state using debugfs

I'm actually wondering if the checks for the ops->pin_config_get are not
a bit overkill. We check for that function in:
 - pinconf_check_ops()
 - before calling it in pin_config_get_for_pin() which is only used
once, in the same path : dump using debugfs and having ops->is_generic
== true
 - in pinconf_pins_show() which is the function calling also in the same
path

What I would do is:
 - remove all the checks in pinconf_check_ops() and pinconf_pins_show()
so that people are not pressured to implement a function that is simply
never used.
 - modify pin_config_get_for_pin() by removing the dev_err() call and
returning -ENOTSUPP instead of -EINVAL (it doesn't change the behaviour
but I feel -ENOTSUPP is more appropriate)

I have a patch ready but I can't test it as I don't own any of the
is_generic platforms.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

