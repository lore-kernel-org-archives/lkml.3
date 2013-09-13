Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab3IMTAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 15:00:11 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:50961 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3IMTAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 15:00:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130901201321.GB23687@sirena.org.uk>
References: <1378065659-18135-1-git-send-email-linus.walleij@linaro.org>
	<20130901201321.GB23687@sirena.org.uk>
Date: Fri, 13 Sep 2013 21:00:08 +0200
Message-ID: <CACRpkdapBc6pRTTpnM3VWErMyzz1So_50H9_efsxXaEO_JLV7A@mail.gmail.com>
Subject: Re: [PATCH 2/4] regulator: add STw481x VMMC driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 1, 2013 at 10:13 PM, Mark Brown <broonie@kernel.org> wrote:
> On Sun, Sep 01, 2013 at 10:00:59PM +0200, Linus Walleij wrote:
>
>> Hi Mark, I'm seeking an ACK for this driver eventually, to
>> take it through the ARM SoC tree with the dependency MFD
>> driver and the enablement patches.
>
> I can put it on a branch so it can be pulled into arm-soc - it makes
> life easier for framework refactorings to have the driver in the
> regulator tree as well.  Would that be OK?

Sure but then you need patch 1/4 in there as well. I don't know if that
comment pertained to the situation prior to the v3.12 merge window
though, can I take this in now maybe or is there still a stir in the
regulator tree?

>> +static int stw481x_vmmc_enable(struct regulator_dev *reg)
>> +{
>> +     struct stw481x *stw481x = rdev_get_drvdata(reg);
>> +     int ret;
>> +
>> +     /* First disable the external VMMC if it's active */
>> +     ret = regmap_update_bits(stw481x->map, STW_CONF2,
>> +                              STW_CONF2_VMMC_EXT, 0);
>> +     if (ret)
>> +             return ret;
>
> This is a bit unusual - is there some definite relationship between the
> two?

They are mutally exclusive. You cannot have both at the same
time. The datasheet says:

0 Internal LDO VMMC is used
1 External VMMC is used

If it is set to 1, the internal VMMC is disconnected. So it's
like some internal mux. All designs I've seen use the internal
regulator though.

I move this to probe() and used regulator_enable_regmap()
instead.

> Should use regulator_disable_regmap().
> Should use regulator_is_enabled_regmap().
> Should use regulator_get/set_voltage_sel_regmap().

OK OK OK :-)

All too new stuff to me, the helpers are really convenient!

I only just rewrote the driver to use regmap and saved
some lines, with this I save even more, cool.

>> +static ssize_t show_ctrl1(struct device *dev,
>> +                       struct device_attribute *attr, char *buf)
>> +{
>> +     int ret;
>> +     unsigned int val;
>> +     struct stw481x *stw481x = dev_get_platdata(dev);
>> +
>> +     ret = regmap_read(stw481x->map, STW_CONF1, &val);
>> +     if (ret)
>> +             return ret;
>> +
>> +     return sprintf(buf, "%#x\n", val);
>> +};
>> +
>> +static DEVICE_ATTR(ctrl1, S_IRUGO, show_ctrl1, NULL);
>
> I'd suggest setting max_register (and possibly readable_reg()) in the
> regmap config rather than adding specific sysfs files.  Unless there's
> some pressing reason for this beyond debug?

This should've been just debug, and it's way simpler to do using
just regmap. Deleted.

>> +     stw481x->vmmc_regulator = regulator_register(&vmmc_regulator, &config);
>> +     if (IS_ERR(stw481x->vmmc_regulator)) {
>> +             dev_err(&pdev->dev,
>> +                     "error initializing STw481x VMMC regulator\n");
>> +             return PTR_ERR(stw481x->vmmc_regulator);
>> +     }
>
> I sent patches for a devm_regulator_register() yesterday - it'll be
> going into -next after the merge window, though the conversion can
> always happen later (I didn't convert most of the drivers yet anyway).

Hm nice, if we can merge the MFD patch into the regulator tree
I can rebase this on you branch for next and use that.

>> +static __init int stw481x_vmmc_regulator_init(void)
>> +{
>> +     return platform_driver_register(&stw481x_vmmc_regulator_driver);
>> +}
>> +
>> +static __exit void stw481x_vmmc_regulator_exit(void)
>> +{
>> +     platform_driver_unregister(&stw481x_vmmc_regulator_driver);
>> +}
>> +
>> +subsys_initcall(stw481x_vmmc_regulator_init);
>> +module_exit(stw481x_vmmc_regulator_exit);
>
> You should be able to use module_platform_driver() with modern systems,

Yeah ... and module_init() level works just fine this is just
some kind of artifact.

Yours,
Linus Walleij
