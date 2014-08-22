Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbaHVMPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:15:54 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44492 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbaHVMPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:15:52 -0400
Message-ID: <53F73472.8010609@collabora.co.uk>
Date: Fri, 22 Aug 2014 14:15:46 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Yuvaraj Cd <yuvaraj.lkml@gmail.com>
CC: Mark Brown <broonie@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Prashanth G <prashanth.g@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>, sunil joshi <joshi@samsung.com>
Subject: Re: [PATCH v9 1/2] regulator: Add driver for max77802 PMIC PMIC regulators
References: <1408350762-15520-1-git-send-email-javier.martinez@collabora.co.uk>	<1408350762-15520-2-git-send-email-javier.martinez@collabora.co.uk> <CA+NduCDL65=Y=PyU3FfXsTz0FfbmYzicGrY4U7ji3_V+nXhtCQ@mail.gmail.com>
In-Reply-To: <CA+NduCDL65=Y=PyU3FfXsTz0FfbmYzicGrY4U7ji3_V+nXhtCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Yuvaraj,

On 08/22/2014 08:01 AM, Yuvaraj Cd wrote:
>> +
>> +static int max77802_pmic_probe(struct platform_device *pdev)
>> +{
>> +       struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
>> +       struct max77686_platform_data *pdata = dev_get_platdata(iodev->dev);
>> +       struct max77802_regulator_prv *max77802;
>> +       int i, ret = 0, val;
>> +       struct regulator_config config = { };
>> +
>> +       /* This is allocated by the MFD driver */
>> +       if (!pdata) {
>> +               dev_err(&pdev->dev, "no platform data found for regulator\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       max77802 = devm_kzalloc(&pdev->dev,
>> +                               sizeof(struct max77802_regulator_prv),
>> +                               GFP_KERNEL);
>> +       if (!max77802)
>> +               return -ENOMEM;
>> +
>> +       if (iodev->dev->of_node) {
>> +               ret = max77802_pmic_dt_parse_pdata(pdev, pdata);
>> +               if (ret)
>> +                       return ret;
>> +       }
>> +
>> +       config.dev = iodev->dev;
>> +       config.regmap = iodev->regmap;
>> +       config.driver_data = max77802;
>> +       platform_set_drvdata(pdev, max77802);
>> +
>> +       for (i = 0; i < MAX77802_REG_MAX; i++) {
>> +               struct regulator_dev *rdev;
>> +               int id = pdata->regulators[i].id;
>> +               int shift = max77802_get_opmode_shift(id);
>> +
>> +               config.init_data = pdata->regulators[i].initdata;
>> +               config.of_node = pdata->regulators[i].of_node;
>> +
>> +               ret = regmap_read(iodev->regmap, regulators[i].enable_reg, &val);
>> +               max77802->opmode[id] = val >> shift & MAX77802_OPMODE_MASK;
> 
> I have been using this patch series for adding UHS support for dw_mmc
> driver. During reboot testing I came across an issue where card
> detection fails due to vqmmc regulator not getting enabled. On
> debugging further, I found that PMIC driver is reading the operating
> mode during probe and reusing it in the enable function. With the UHS
> patches vqmmc regulator gets disabled during POWER_OFF and if we do
> warm reboot, an incorrect operating mode(OFF) is read. This leads to
> the vqmmc regulator staying disabled. I have referred to 77686 driver
> and observed that they are handling this a little differently. With
> the following change in the driver above issue is resolved:
> 
> -               ret = regmap_read(iodev->regmap,
> regulators[i].enable_reg, &val);
> -               max77802->opmode[id] = val >> shift & MAX77802_OPMODE_MASK;
> +               max77802->opmode[i] = regulators[i].enable_mask >> shift;
> 

I don't think this change is correct it its current form since
.enable_mask is initialized to MAX77802_OPMODE_MASK << shift so this is
actually setting the opmode to MAX77802_OPMODE_MASK.

Now, MAX77802_OPMODE_MASK has the same value than MAX77802_OPMODE_NORMAL
so what you are really doing here is initializing the opmode to
MAX77802_OPMODE_NORMAL.

> Please have a look and let me know, if there is any better way of handling this.
>

The first versions of this driver did in fact set the opmode to
MAX77802_OPMODE_NORMAL on probe but Mark asked me to read it from the
hardware instead [0]. I was indeed worried at the time that something like
this could happen on a warm reset [1].

Mark, any opinions on how this should be solved will be highly appreciated.

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/6/16/576
[1]: https://lkml.org/lkml/2014/6/17/174
