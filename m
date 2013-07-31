Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab3GaXaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 19:30:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46141 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab3GaX37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 19:29:59 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: "Samuel Ortiz (sameo@linux.intel.com)" <sameo@linux.intel.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
Subject: RE: [PATCH v2 1/4] mfd: add LP3943 MFD driver
Thread-Topic: [PATCH v2 1/4] mfd: add LP3943 MFD driver
Thread-Index: Ac6MtTyjOqxscTSbS1eNJ8jjFJq3OQA7LOYAAChTv8A=
Date: Wed, 31 Jul 2013 23:29:48 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E850A9@DQHE06.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E849D8@DQHE06.ent.ti.com>
 <20130731115630.GH13298@lee--X1>
In-Reply-To: <20130731115630.GH13298@lee--X1>
Accept-Language: en-US, ko-KR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6VNUAtg016267

Thanks for the review, please see my comments.

> <snip> * looks good up to me up to here *
> 
> Although, I think the 0 = 1, 1 = 2 ... stuff is really confusing. Is
> there nothing we can do about that?

OK, enum value of lp3943_pwm_output can be changed as below
because LP3943_PWM_INVALID is not used anymore.

enum lp3943_pwm_output {
	LP3943_PWM_OUT0,
	LP3943_PWM_OUT1,
	...
	LP3943_PWM_OUT15,
};

Then, output index will match each enum integer value.
Does it make sense?

> > +static const struct i2c_device_id lp3943_ids[] = {
> > +	{ "lp3943", 0 },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(i2c, lp3943_ids);
> 
> Are we expecting this driver to support more devices?

At this moment, this is the only one device supported.

> > +static int __init lp3943_init(void)
> > +{
> > +	return i2c_add_driver(&lp3943_driver);
> > +}
> > +subsys_initcall(lp3943_init);
> > +
> > +static void __exit lp3943_exit(void)
> > +{
> > +	i2c_del_driver(&lp3943_driver);
> > +}
> > +module_exit(lp3943_exit);
> 
> I think you want to replace:
>   lp3943_init()
>   lp3943_exit
> 
> With:
>   module_i2c_driver()

This is related with initcall sequence.
Some problem may happen if any GPIO or PWM consumer tries to request before
LP3943 MFDs are added.
For example, a GPIO is requested in _probe() of some device.
Let's assume the GPIO number is in range of what LP3943 GPIO driver provided.
Then, gpio_request() will be failed because the GPIO is invalid at this moment.
If the device request again later, it will be OK, but we can't expect this 
situation for every driver.
Some drivers request a GPIO only once in _probe(), other devices may request
a GPIO in some cases.
So, I think lp3943_init() should be defined as subsys_initcall() instead of 
module_init().

Best regards,
Milo -
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
