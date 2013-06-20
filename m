Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030244Ab3FTLcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:32:39 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46051 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965276Ab3FTLce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:32:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130620081850.GB20594@balto.lan>
References: <1371713002-18974-1-git-send-email-patrice.chotard.st@gmail.com>
	<1371713002-18974-3-git-send-email-patrice.chotard.st@gmail.com>
	<20130620081850.GB20594@balto.lan>
Date: Thu, 20 Jun 2013 13:32:32 +0200
Message-ID: <CAHK0JfguWgwLWWfaTrzsHEkgmjjFgW2MBoNM26RitcvTCEVw2Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: abx500: fix abx500_pin_config_set()
From: Patrice Chotard <patrice.chotard.st@gmail.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 10:18 AM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:
> On Thu, Jun 20, 2013 at 09:23:22AM +0200, patrice.chotard.st@gmail.com wrote:
>> From: Patrice Chotard <patrice.chotard@st.com>
>>
>> _ Update abx500_pin_config_set() in order to take in
>> account PIN_CONFIG_BIAS_DISABLE state to disable
>> pull up or pull down.
>>
>> _ Rework error path.
>>
>> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
>> ---
>>  drivers/pinctrl/pinctrl-abx500.c |   31 +++++++++++++++++++++++++------
>>  1 file changed, 25 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
>> index b5b5460..14dc078 100644
>> --- a/drivers/pinctrl/pinctrl-abx500.c
>> +++ b/drivers/pinctrl/pinctrl-abx500.c
>> @@ -33,6 +33,7 @@
>>  #include <linux/pinctrl/machine.h>
>>
>>  #include "pinctrl-abx500.h"
>> +#include "core.h"
>>  #include "pinconf.h"
>>
>>  /*
>> @@ -963,7 +964,7 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
>>       struct pullud *pullud = pct->soc->pullud;
>>       struct gpio_chip *chip = &pct->chip;
>>       unsigned offset;
>> -     int ret = 0;
>> +     int ret = -EINVAL;
>>       enum pin_config_param param = pinconf_to_config_param(config);
>>       enum pin_config_param argument = pinconf_to_config_argument(config);
>>
>> @@ -976,13 +977,32 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
>>       offset = pin - 1;
>>
>>       switch (param) {
>> -     case PIN_CONFIG_BIAS_PULL_DOWN:
>> +     case PIN_CONFIG_BIAS_DISABLE:
>> +             ret = abx500_gpio_direction_input(chip, offset);
>>               /*
>> -              * if argument = 1 set the pull down
>> -              * else clear the pull down
>> +              * Some chips only support pull down, while some actually
>> +              * support both pull up and pull down. Such chips have
>> +              * a "pullud" range specified for the pins that support
>> +              * both features. If the pin is not within that range, we
>> +              * fall back to the old bit set that only support pull down.
>>                */
>> +             if (pullud &&
>> +                 pin >= pullud->first_pin &&
>> +                 pin <= pullud->last_pin)
>
> This multi-line check is replicated in all conditions, would it make
> sense to move it on a dedicated function to improve readability?

Yes i will add a dedicated function.

>
>> +                     ret = abx500_set_pull_updown(pct,
>> +                             pin,
>> +                             ABX500_GPIO_PULL_NONE);
>> +             else
>> +                     /* Chip only supports pull down */
>> +                     ret = abx500_gpio_set_bits(chip, AB8500_GPIO_PUD1_REG,
>> +                             offset, ABX500_GPIO_PULL_NONE);
>> +             break;
>> +
>> +     case PIN_CONFIG_BIAS_PULL_DOWN:
>>               ret = abx500_gpio_direction_input(chip, offset);
>>               /*
>> +              * if argument = 1 set the pull down
>> +              * else clear the pull down
>>                * Some chips only support pull down, while some actually
>>                * support both pull up and pull down. Such chips have
>>                * a "pullud" range specified for the pins that support
>> @@ -1002,6 +1022,7 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
>>               break;
>>
>>       case PIN_CONFIG_BIAS_PULL_UP:
>> +             ret = abx500_gpio_direction_input(chip, offset);
>
> Here the return value of abx500_gpio_direction_input is set but never
> checked, and will be always overwritten by the next abx500_gpio_ call...
> Would it make sense to add a pr_err for it?  On the other side, if it
> never fails, you can just drop the return field altogether.

I will rework this part and make a global review as i notice that same issue
appears on several other place in this file.
>
> That's also done in other conditions in the same 'switch', it may make
> sense to have a patch just for that.
>
> Thanks,
> Fabio
>
>>               /*
>>                * if argument = 1 set the pull up
>>                * else clear the pull up
>> @@ -1030,8 +1051,6 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
>>
>>       default:
>>               dev_err(chip->dev, "illegal configuration requested\n");
>> -
>> -             return -EINVAL;
>>       }
>>
>>       return ret;
>> --
>> 1.7.10
>>
>
> --
> Fabio Baltieri
