Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbaIKWTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:19:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36506 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaIKWTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:19:52 -0400
Message-ID: <54121F47.7060702@ti.com>
Date: Thu, 11 Sep 2014 18:16:39 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Heiko Stuebner <heiko@sntech.de>, Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Nishanth Menon <nm@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@kernel.org>, Addy Ke <addy.ke@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] PM / AVS: rockchip-io: add driver handling Rockchip
 io domains
References: <1410469229-30167-1-git-send-email-dianders@chromium.org>	<541214A7.3040402@ti.com> <CAD=FV=VYkf1AuwwSHsdCX2sqzKmZBzWdMZhi-kx3ycKtTcA=pA@mail.gmail.com>
In-Reply-To: <CAD=FV=VYkf1AuwwSHsdCX2sqzKmZBzWdMZhi-kx3ycKtTcA=pA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2014 06:07 PM, Doug Anderson wrote:
> Santosh,
> 
> On Thu, Sep 11, 2014 at 2:31 PM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
>>> +Required properties:
>>> +- compatible: should be one of:
>>> +  - "rockchip,rk3188-iodomain" for rk3188
>>> +  - "rockchip,rk3288-iodomain" for rk3288
>> The key word 'voltage' is missing from the compatible. iodomain itself
>> doesn't convey what it is actually.
> 
> Sure, so you want "rockchip,rk3288-io-voltage-domain" then?
>
Sounds good for me.
 
[..]

>>> diff --git a/drivers/power/avs/rockchip-io-domain.c b/drivers/power/avs/rockchip-io-domain.c
>>> new file mode 100644
>>> index 0000000..f4e0ebc
>>> --- /dev/null
>>> +++ b/drivers/power/avs/rockchip-io-domain.c
>>> @@ -0,0 +1,333 @@
>>> +/*
>>> + * Rockchip IO Voltage Domain driver
>>> + *
>>> + * Copyright 2014 MundoReader S.L.
>>> + * Copyright 2014 Google, Inc.
>>> + *
>>> + * This software is licensed under the terms of the GNU General Public
>>> + * License version 2, as published by the Free Software Foundation, and
>>> + * may be copied, distributed, and modified under those terms.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + */
>>> +
>>> +#include <linux/kernel.h>
>>> +#include <linux/module.h>
>>> +#include <linux/err.h>
>>> +#include <linux/mfd/syscon.h>
>> The bindings are not talking about syscon usage. You might
>> want to document it appropriately to make the usage clear.
> 
> Doesn't the bindings have this?
> 
>> +- rockchip,grf: phandle to the syscon managing the "general register files"
> 
> I actually forgot that in v1, but I added it to v2.
> 
Sorry didn't spot that. Ignore the comment.

> 
>>> +#define MAX_VOLTAGE_1_8              1980000
>> This is close to 2V, Is that intentional.
>>
>>> +#define MAX_VOLTAGE_3_3              3600000
>>> +
>> Same here.
> 
> I got these numbers from the document "Rocchip RK3288 datasheet".
> Under "Recommended Operating Conditions" for "Digital GPIO".  When the
> typical is 3.3V the max is 3.6V.  When the typical is 1.8V the max is
> 1.98V.
> 
> The way these numbers are used is:
> 
> If the voltage on a rail is above the "1.8" voltage (1.98V) we'll tell
> the SoC we're at 3.3.  If the voltage on a rail is above the "3.3V"
> we'll consider that to be an error.
> 
> There's one secret ulterior motive here though that I'll admit to.
> When a client uses regulator_set_voltage() they actually specify a min
> and max voltage.  They might say that they want 3.3V by saying that
> they want a voltage between 2.7V and 3.6V.  They might say that they
> want 1.8V by saying that they want a voltage between 1.7V and 1.95V.
> In our pre-change notification we are only told the possible range.
> It's nice if things work properly in that case.  If we find some case
> that doesn't work later we can always get fancier and try to figure
> out what voltage the regulator will end up at, but I haven't seen the
> need yet.
> 
> Note that the 1.7 - 1.95V is more than hypothetical.  dw_mmc requests
> those ranges.  I'll admit that I was involved in that code, but I'll
> also admit to having stolen those numbers from sdhci.
> 
Thanks for explaination. I suggest you to document it above those macro's
so that its not confusing for any reader.

> 
>>> +struct rockchip_iodomain;
>>> +
>>> +/**
>>> + * @supplies: voltage settings matching the register bits.
>>> + */
>>> +struct rockchip_iodomain_soc_data {
>>> +     int grf_offset;
>>> +     const char *supply_names[MAX_SUPPLIES];
>>> +     void (*init)(struct rockchip_iodomain *iod);
>>> +};
>>> +
>>> +struct rockchip_iodomain_supply {
>>> +     struct rockchip_iodomain *iod;
>>> +     struct regulator *reg;
>>> +     struct notifier_block nb;
>>> +     int idx;
>>> +};
>>> +
>>> +struct rockchip_iodomain {
>>> +     struct device *dev;
>>> +     struct regmap *grf;
>>> +     struct rockchip_iodomain_soc_data *soc_data;
>>> +     struct rockchip_iodomain_supply supplies[MAX_SUPPLIES];
>>> +};
>>> +
>>> +static int rockchip_iodomain_write(struct rockchip_iodomain_supply *supply,
>>> +                                int uV)
>>> +{
>>> +     struct rockchip_iodomain *iod = supply->iod;
>>> +     u32 val;
>>> +     int ret;
>>> +
>>> +     /* set value bit */
>>> +     val = (uV > MAX_VOLTAGE_1_8) ? 0 : 1;
>>> +     val <<= supply->idx;
>>> +
>>> +     /* apply hiword-mask */
>>> +     val |= (BIT(supply->idx) << 16);
>>> +
>>> +     ret = regmap_write(iod->grf, iod->soc_data->grf_offset, val);
>>> +     if (ret)
>>> +             dev_err(iod->dev, "Couldn't write to GRF\n");
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static int rockchip_iodomain_notify(struct notifier_block *nb,
>>> +                                 unsigned long event,
>>> +                                 void *data)
>>> +{
>>> +     struct rockchip_iodomain_supply *supply =
>>> +                     container_of(nb, struct rockchip_iodomain_supply, nb);
>>> +     int uV;
>>> +     int ret;
>>> +
>>> +     /*
>>> +      * According to Rockchip it's important to keep the SoC IO domain
>>> +      * higher than (or equal to) the external voltage.  That means we need
>>> +      * to change it before external voltage changes happen in the case
>>> +      * of an increase.
>>> +      */
>>> +     if (event & REGULATOR_EVENT_PRE_VOLTAGE_CHANGE) {
>>> +             struct pre_voltage_change_data *pvc_data = data;
>>> +
>>> +             uV = max_t(unsigned long, pvc_data->old_uV, pvc_data->max_uV);
>>> +     } else if (event & (REGULATOR_EVENT_VOLTAGE_CHANGE |
>>> +                         REGULATOR_EVENT_ABORT_VOLTAGE_CHANGE)) {
>>> +             uV = (unsigned long)data;
>>> +     } else {
>>> +             return NOTIFY_OK;
>>> +     }
>>> +
>>> +     dev_dbg(supply->iod->dev, "Setting to %d\n", uV);
>>> +
>>> +     if (uV > MAX_VOLTAGE_3_3) {
>>> +             dev_err(supply->iod->dev, "Voltage too high: %d\n", uV);
>>> +
>>> +             if (event == REGULATOR_EVENT_PRE_VOLTAGE_CHANGE)
>>> +                     return NOTIFY_BAD;
>>> +     }
>>> +
>>> +     ret = rockchip_iodomain_write(supply, uV);
>>> +     if (ret && event == REGULATOR_EVENT_PRE_VOLTAGE_CHANGE)
>>> +             return NOTIFY_BAD;
>>> +
>>> +     dev_info(supply->iod->dev, "Setting to %d done\n", uV);
>>> +     return NOTIFY_OK;
>>> +}
>>> +
>>> +#define RK3288_SOC_CON2                      0x24c
>>> +#define RK3288_SOC_CON2_FLASH0               BIT(7)
>>> +#define RK3288_SOC_FLASH_SUPPLY_NUM  2
>>> +
>> Not a strong opinion but you can club all the defines on top
>> of the file.
> 
> Sure, I'll move them.
> 
OK. Feel free to add my reviewed-by tag after the updates if you need one.

regards,
Santosh

