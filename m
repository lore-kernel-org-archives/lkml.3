Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaIISz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:55:28 -0400
Received: from www.augenpunkt.de ([213.239.207.9]:50743 "EHLO
	www.augenpunkt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaIISzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:55:25 -0400
Message-ID: <540F523D.4010904@lategoodbye.de>
Date: Tue, 09 Sep 2014 21:17:17 +0200
From: Stefan Wahren <info@lategoodbye.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "stefan.wahren@i2se.com" <stefan.wahren@i2se.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC 2/3] ARM: regulator: add Freescale MXS regulator driver
References: <1410089869-6611-1-git-send-email-info@lategoodbye.de> <1410089869-6611-3-git-send-email-info@lategoodbye.de> <20140909182211.GG3896@leverpostej>
In-Reply-To: <20140909182211.GG3896@leverpostej>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 09.09.2014 20:22, schrieb Mark Rutland:
> [...]
>
>> +       regs = (__raw_readl(sreg->base_addr) & ~BM_POWER_LEVEL_TRG);
>
> I suspect you should be using the *_relaxed accessors rather than the
> __raw_* accessors.
>
> [...]
>
>> +static int mxs_regulator_probe(struct platform_device *pdev)
>> +{
>> +       struct device *dev = &pdev->dev;
>> +       struct device_node *np = dev->of_node;
>> +       struct device_node *parent;
>> +       struct regulator_desc *rdesc;
>> +       struct regulator_dev *rdev;
>> +       struct mxs_regulator *sreg;
>> +       struct regulator_init_data *initdata;
>> +       struct regulation_constraints *con;
>> +       struct regulator_config config = { };
>> +       void __iomem *base_addr = NULL;
>> +       void __iomem *power_addr = NULL;
>> +       u64 regaddr64 = 0;
>> +       const u32 *regaddr_p;
>> +       u32 val = 0;
>> +       int ret;
>> +
>> +       if (!np) {
>> +               dev_err(dev, "missing device tree\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       /* get device base address */
>> +       base_addr = of_iomap(np, 0);
>> +       if (!base_addr)
>> +               return -ENXIO;
>> +
>> +       parent = of_get_parent(np);
>> +       if (!parent)
>> +               return -ENXIO;
>
> Leak of the (successfully mapped) base_addr.
>
>> +
>> +       power_addr = of_iomap(parent, 0);
>> +       if (!power_addr)
>> +               return -ENXIO;
>
> Leak of base_addr and dangling refcount on parent. These apply to all
> subsequent returns.
>
>> +
>> +       regaddr_p = of_get_address(np, 0, NULL, NULL);
>
> of_get_address returns a __be32*, not a u32*, so sparse will be very
> unhappy here...
>
>> +       if (regaddr_p)
>> +               regaddr64 = of_translate_address(np, regaddr_p);
>
> ...and as of_translate_address returns a u64 you'll need a separate
> variable for the input and output.
>
>> +
>> +       if (!regaddr64) {
>> +               dev_err(dev, "no or invalid reg property set\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       initdata = of_get_regulator_init_data(dev, np);
>> +       if (!initdata)
>> +               return -EINVAL;
>> +
>> +       ret = of_property_read_u32(np, "mxs-max-reg-val",
>> +                                  &val);
>> +       if (!val) {
>> +               dev_err(dev, "no or invalid mxs-max-reg-val property set\n");
>> +               return ret;
>> +       }
>> +
>> +       dev_info(dev, "regulator found\n");
>> +
>> +       sreg = devm_kzalloc(dev, sizeof(*sreg), GFP_KERNEL);
>> +       if (!sreg)
>> +               return -ENOMEM;
>> +       sreg->initdata = initdata;
>> +       sreg->name = of_get_property(np, "regulator-name", NULL);
>
> I'm not keen on using of_get_property here. We have no idea if
> regulator-name is even a string (it should be, but we have no
> guarantee).

Better using of_property_read_string?

>
>> +       sreg->cur_uA = 0;
>> +       sreg->cur_uV = 0;
>> +       sreg->base_addr = base_addr;
>> +       sreg->power_addr = power_addr;
>> +       init_waitqueue_head(&sreg->wait_q);
>> +       spin_lock_init(&sreg->lock);
>> +       sreg->max_reg_val = val;
>> +
>> +       rdesc = &sreg->rdesc;
>> +       rdesc->name = sreg->name;
>> +       rdesc->owner = THIS_MODULE;
>> +       rdesc->ops = &mxs_rops;
>> +
>> +       if (strcmp(rdesc->name, "overall_current") == 0)
>> +               rdesc->type = REGULATOR_CURRENT;
>> +       else
>> +               rdesc->type = REGULATOR_VOLTAGE;
>
> Wouldn't it make more sense to explicitly match the names you expect?
>

Okay, i make "regulator-name" a required property and use a white list 
of all possible regulators.

>> +       con = &initdata->constraints;
>> +       rdesc->n_voltages = sreg->max_reg_val;
>> +       rdesc->min_uV = con->min_uV;
>> +       rdesc->uV_step = (con->max_uV - con->min_uV) / sreg->max_reg_val;
>> +       rdesc->linear_min_sel = 0;
>> +       rdesc->vsel_reg = regaddr64;
>> +       rdesc->vsel_mask = BM_POWER_LEVEL_TRG;
>> +
>> +       config.dev = &pdev->dev;
>> +       config.init_data = initdata;
>> +       config.driver_data = sreg;
>> +       config.of_node = np;
>> +
>> +       pr_debug("probing regulator %s %s %d\n",
>> +                       sreg->name,
>> +                       rdesc->name,
>> +                       pdev->id);
>
> Aren't those two names always the same per the code above?
>

Sure, i will fix that.

>> +
>> +       /* register regulator */
>> +       rdev = devm_regulator_register(dev, rdesc, &config);
>> +
>> +       if (IS_ERR(rdev)) {
>> +               dev_err(&pdev->dev, "failed to register %s\n",
>> +                       rdesc->name);
>> +               return PTR_ERR(rdev);
>> +       }
>> +
>> +       if (sreg->max_uA) {
>> +               struct regulator *regu;
>> +
>> +               regu = regulator_get(NULL, sreg->name);
>> +               sreg->nb.notifier_call = reg_callback;
>> +               regulator_register_notifier(regu, &sreg->nb);
>> +       }
>> +
>> +       platform_set_drvdata(pdev, rdev);
>> +
>> +       of_property_read_u32(np, "mxs-default-microvolt",
>> +                                  &val);
>> +
>> +       if (val)
>> +               mxs_set_voltage(rdev, val, val, NULL);
>
> As I mentioned in my comments on the binding, I'd like to know why this
> is necessary and if it is why it shouldn't be a standardised property.

 From my understanding the standardised properties only defines a range, 
but no default state of the regulators. If the initialization from the 
bootloader or a hardcoded initialization in the driver is okay then the 
property is not necessary.

> Mark.
>

Thanks for your feedback.

Stefan
