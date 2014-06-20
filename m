Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaFTOPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:15:14 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:50842 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaFTOPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:15:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140620135454.GA10566@kahuna>
References: <1403164154-1362-1-git-send-email-acourbot@nvidia.com>
 <53A308C8.2070004@wwwdotorg.org> <20140619175643.GR5099@sirena.org.uk>
 <53A3C613.8030207@nvidia.com> <53A3D85E.7030704@nvidia.com>
 <20140620094119.GT5099@sirena.org.uk> <53A4039B.7000504@nvidia.com>
 <20140620132310.GA11936@kahuna> <20140620135454.GA10566@kahuna>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 20 Jun 2014 23:14:51 +0900
Message-ID: <CAAVeFuJ=JTNkwDKBvuoyL=ARQs_UJb_MHzL9S8gOc8EU98znPg@mail.gmail.com>
Subject: Re: Palmas regulator broken (was Re: [PATCH] ARM: tegra: TN7: relax
 some regulators)
To: Nishanth Menon <nm@ti.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Keerthy <j-keerthy@ti.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 10:54 PM, Nishanth Menon <nm@ti.com> wrote:
> On 08:23-20140620, Nishanth Menon wrote:
>> + l-o,
>>       http://marc.info/?t=140316427500004&r=1&w=2 full thread
>>
>> Minor change in subject to indicate palmas regulator fail
>>
>> On 18:49-20140620, Alexandre Courbot wrote:
>> > On 06/20/2014 06:41 PM, Mark Brown wrote:
>> > >* PGP Signed by an unknown key
>> > >
>> > >On Fri, Jun 20, 2014 at 03:44:46PM +0900, Alexandre Courbot wrote:
>> > >
>> > >>dbabd624d
>> > >>regulator: palmas: Reemove open coded functions with helper functions
>> > >
>> > >>Keerthy, Nishanth, could it be that there is still something wrong with the
>> > >>REGULATOR_LINEAR_RANGE() definitions?
>> > >
>> > >>This seems to be the cause for our trouble, but the other questions might
>> > >>still stand, in case there is interest in discussing them.
>> > >
>> > >There was a bug fix to the Palmas driver which just went to Linus the
>> > >other day, are you sure this isn't fixed in mainline (or -next, it's
>> > >been in -next for a week or something)?
>> >
>> > If you are talking about
>> >
>> > 6b7f2d82d5
>> > regulator: palmas: Fix SMPS list for 0V
>> >
>> > then it is in my tree. There is actually no difference on
>> > palmas-regulator.c between my tree and the current -next (or Linus'
>> > tree for that instance).
>> >
>> > So it seems to be something else we are dealing with here.
>>
>> Your quote earlier in the thread
>> "
>> _regulator_is_enabled() *also* returns false
>> "
>>
>> Got me curious. Looking at the patch:
>> dbabd624d4eec50b623bab070d1e39a854b2d65c (regulator: palmas: Reemove
>> open coded functions with helper functions)
>> I noticed the following change
>> palmas_is_enabled_smps -> regulator_is_enabled_regmap
>>
>> So I decided to search for enable_reg in palmas-regulator.c and I think
>> it needs valid enable_reg, mask, value for regulator_is_enabled_regmap to work
>> :).
>>
>> Maybe to be sure, we could print the following:
>> PALMAS_SMPS8_VOLTAGE, PALMAS_SMPS8_CTRL, PALMAS_SMPS8_TSTEP,
>>
>> Anyways, I quickly boot tested the following on DRA7evm (which also uses Palmas):
>> [    1.933939] palmas-pmic 48070000.i2c:tps659038@58:tps659038_pmic: enable_reg = 0x00, mask =0x00
>> [    1.944210] smps123: 850 <--> 1250 mV at 1060 mV
>> [    1.950717] palmas-pmic 48070000.i2c:tps659038@58:tps659038_pmic: enable_reg = 0x00, mask =0x00
>> [    1.960754] smps45: 850 <--> 1150 mV at 1060 mV
>> [    1.967048] palmas-pmic 48070000.i2c:tps659038@58:tps659038_pmic: enable_reg = 0x00, mask =0x00
>> [    1.977072] smps6: 850 <--> 1650 mV at 1060 mV
>> [    1.983077] palmas-pmic 48070000.i2c:tps659038@58:tps659038_pmic: enable_reg = 0x00, mask =0x00
>> [    1.992994] smps7: 850 <--> 1030 mV at 1030 mV
>> [    1.999238] palmas-pmic 48070000.i2c:tps659038@58:tps659038_pmic: enable_reg = 0x00, mask =0x00
>> [    2.009161] smps8: 850 <--> 1250 mV at 1060 mV
>> [    2.015304] palmas-pmic 48070000.i2c:tps659038@58:tps659038_pmic: enable_reg = 0x00, mask =0x00
>>
>> It does seem to me that either set_mode also should use core functions
>> OR you still need a palmas specific is_enable, enable/disable functions
>> (contrary to the claim of the patch in question - which I think
>>  introduced regressions).
>>
>> Otherwise, completely untested diff below - can you  give this a shot?
>>
>> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
>> index b982f0f..bbfe22f 100644
>> --- a/drivers/regulator/palmas-regulator.c
>> +++ b/drivers/regulator/palmas-regulator.c
>> @@ -964,6 +964,20 @@ static int palmas_regulators_probe(struct platform_device *pdev)
>>                               return ret;
>>                       pmic->current_reg_mode[id] = reg &
>>                                       PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
>> +
>> +                     dev_err(&pdev->dev, "enable_reg = 0x%02x, mask =0x%02x\n",
>> +                             pmic->desc[id].enable_reg,
>> +                             pmic->desc[id].enable_mask);
>> +                     pmic->desc[id].enable_reg =
>> +                                     PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
>> +                                             palmas_regs_info[id].ctrl_addr);
>> +                     pmic->desc[id].enable_mask =
>> +                                     PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
>> +                     /*
>> +                      * The following completely ignores
>> +                      * pmic->current_reg_mode[id] (set_mode)
>> +                      */
>> +                     pmic->desc[id].enable_val = SMPS_CTRL_MODE_ON;
>>               }
>>
>>               pmic->desc[id].type = REGULATOR_VOLTAGE;
>
> rev 2 of the diff - this does depened on the fact that regulator_desc is
> not memdup-ed by regulator code - that lets us do a bit of a trickery ;)
> - and I dropped the prints.. Unrelated: This makes me wonder why
> palmas_is_enabled_ldo at all?
>
> Keerthy, Mark,
> what do you think of the following (esp the flip of desc value):
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index b982f0f..f01d9c5 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -299,7 +299,7 @@ static int palmas_set_mode_smps(struct regulator_dev *dev, unsigned int mode)
>         struct palmas_pmic *pmic = rdev_get_drvdata(dev);
>         int id = rdev_get_id(dev);
>         unsigned int reg;
> -       bool rail_enable = true;
> +       bool rail_enable = true, enable_val = true;
>
>         palmas_smps_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
>         reg &= ~PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
> @@ -318,6 +318,7 @@ static int palmas_set_mode_smps(struct regulator_dev *dev, unsigned int mode)
>                 reg |= SMPS_CTRL_MODE_PWM;
>                 break;
>         default:
> +               enable_val = false;
>                 return -EINVAL;
>         }
>
> @@ -325,6 +326,11 @@ static int palmas_set_mode_smps(struct regulator_dev *dev, unsigned int mode)
>         if (rail_enable)
>                 palmas_smps_write(pmic->palmas,
>                         palmas_regs_info[id].ctrl_addr, reg);
> +
> +       /* Switch the enable value to ensure this is used for enable */
> +       if (enable_val)
> +               pmic->desc[id].enable_val = pmic->current_reg_mode[id];
> +
>         return 0;
>  }
>
> @@ -964,6 +970,14 @@ static int palmas_regulators_probe(struct platform_device *pdev)
>                                 return ret;
>                         pmic->current_reg_mode[id] = reg &
>                                         PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
> +
> +                       pmic->desc[id].enable_reg =
> +                                       PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
> +                                               palmas_regs_info[id].ctrl_addr);
> +                       pmic->desc[id].enable_mask =
> +                                       PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
> +                       /* set_mode overrides this value */
> +                       pmic->desc[id].enable_val = SMPS_CTRL_MODE_ON;
>                 }
>
>                 pmic->desc[id].type = REGULATOR_VOLTAGE;

Tried this v2 and it seems to do the trick! My panel switches on as expected.

Thanks,
Alex.
