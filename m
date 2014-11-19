Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbaKSOiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:38:06 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:41641 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbaKSOiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:38:04 -0500
Message-ID: <546CAB49.8030103@mentor.com>
Date: Wed, 19 Nov 2014 16:38:01 +0200
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Question about fixed regulator DT properties
References: <546B5EF9.3080102@mentor.com>
In-Reply-To: <546B5EF9.3080102@mentor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 18.11.2014 17:00, Vladimir Zapolskiy wrote:
> Hello,
> 
> I need to set a GPIO (active high) output high on boot, which enables a
> power rail supplying some external devices.
> 
> I have a question regarding "regulator-boot-on" and "enable-active-high"
> fixed regulator device tree properties (actually AFAIU it applies to
> gpio regulator as well, by the way, which one is proper to use in my
> situation?)
> 
> Here is what we have from the code:
> 
>   [...]
>   constraints->boot_on = of_property_read_bool(np, "regulator-boot-on");
>   [...]
>   if (init_data->constraints.boot_on)
>           config->enabled_at_boot = true;
>   [...]
>   config->enable_high = of_property_read_bool(np, "enable-active-high");
>   [...]
>   cfg.ena_gpio_invert = !config->enable_high;
>   if (config->enabled_at_boot) {
>           if (config->enable_high)
>                   cfg.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
>           else
>                   cfg.ena_gpio_flags |= GPIOF_OUT_INIT_LOW;
>   } else {
>           if (config->enable_high)
>                   cfg.ena_gpio_flags |= GPIOF_OUT_INIT_LOW;
>           else
>                  cfg.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
>   }
>   [...]
>   ret = gpio_request_one(config->ena_gpio,
>                          GPIOF_DIR_OUT | config->ena_gpio_flags,
>                          rdev_get_name(rdev));
>   [...]
>   /* Enable GPIO at initial use */
>   if (pin->enable_count == 0)
>           gpiod_set_value_cansleep(pin->gpiod,
>                                   !pin->ena_gpio_invert);
>   [...]
> 
> 
> If we simplify the matter by assuming GPIOF_OUT_INIT_LOW is inverted
> GPIOF_OUT_INIT_HIGH and vice versa, then it is easy to compute by
> running over the variants that GPIO output value is set HIGH (regardless
> of GPIO active low status) if and only if "regulator-boot-on" is
> provided and "enable-active-high" has no effect at all.
> 
> This fact confuses me, because from the general regulator and fixed
> regulator device tree bindings documentation I get:
> 
>   [...]
>   - regulator-boot-on: bootloader/firmware enabled regulator
>   [...]
>   - enable-active-high: Polarity of GPIO is Active high
>   If this property is missing, the default assumed is Active low.
>   [...]
> 
> According to the documentation I'd assume that "regulator-boot-on" does
> not touch gpio output value setting (so, if it is controlled by
> bootloader or firmware, then it might be out of Linux kernel control).
> Also my impression of "enable-active-high" property is that is should
> have some effect on the GPIO output value (but it is not, see above),
> and actually I don't quite understand why this property exists - there
> is a high chance that "enable-active-high" and the real GPIO polarity do
> not coincide, it should be more reliable to get GPIO flags of a
> particular GPIO right in the regulator driver/framework.
> 
> Let's consider two possible configurations:
> 
> | regulator-boot-on | enable-active-high | GPIO polarity | GPIO output |
> +-------------------+--------------------+---------------+-------------+
> |        no         |         yes        |  active high  |    low      |
> |        no         |          no        |  active low   |   high      |
> 
> I'd rather think that both resulting GPIO outputs are incorrect or
> better to say do not correspond to my perception of "regulator-boot-on"
> and "enable-active-high" DTS properties described in the documentation,
> however above "enable-active-high" and actual GPIO polarity are the same
> (when they are not, it is another open topic for discussion).
> 
> Do I miss something or have a mistake? Is there a problem in the
> implemented logic?
> 
> Should documentation be updated to reflect "regulator-boot-on" role that
> a regulator is re-enabled by the kernel?
> 
> Should "enable-active-high" be replaced by getting GPIO flags directly?
> 
> Thank you in advance.
> 

sorry for non-informative original subject, I would appreciate to get
any comments from you on the topic, if there is a problem, it may caused
by your commit 25a53dfbfbf.

If there is an actual problem, please let me know, I'm always willing to
improve the kernel.

--
With best wishes,
Vladimir
