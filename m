Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab3HEHKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:10:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45287 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab3HEHKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:10:09 -0400
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
Thread-Index: Ac6MtTyjOqxscTSbS1eNJ8jjFJq3OQA7LOYAAChTv8AAAdPTgADVVt6g
Date: Mon, 5 Aug 2013 07:09:56 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E85CA9@DQHE06.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E849D8@DQHE06.ent.ti.com>
 <20130731115630.GH13298@lee--X1>
 <A874F61F95741C4A9BA573A70FE3998F82E850A9@DQHE06.ent.ti.com>
 <20130801080331.GK13298@lee--X1>
In-Reply-To: <20130801080331.GK13298@lee--X1>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r757AK9T009563

> > > Although, I think the 0 = 1, 1 = 2 ... stuff is really confusing. Is
> > > there nothing we can do about that?
> >
> > OK, enum value of lp3943_pwm_output can be changed as below because
> > LP3943_PWM_INVALID is not used anymore.
> >
> > enum lp3943_pwm_output {
> > 	LP3943_PWM_OUT0,
> > 	LP3943_PWM_OUT1,
> > 	...
> > 	LP3943_PWM_OUT15,
> > };
> >
> > Then, output index will match each enum integer value.
> > Does it make sense?
> 
> Not really. IIRC the documentation said that LED0 (which I believe you're
> calling OUT0 here) is located at pin one. So your enum above is now incorrect
> isn't it? As *_OUT0 will be 0 and not 1? Or am I missing something?

If we consider this naming as the pin control description, it maybe confusing.
However, this enum type means configurable platform data which output channel(s)
are connected to LP3943 PWM controller.

I've changed this name from _PWM_LEDx to _PWM_OUTx in the second patch because
PWM is used for not only LED function but also other operations.
Zero base index notation is derived from the datasheet.
If I remove LP3943_PWM_INVALID, then each enum type matches with
register index(or offset) exactly. (But I need to fix LP3943 PWM driver)

In the meantime, I've reviewed the pin control subsystem,
I think it is not the best way to implement LP3943 driver.
The GPIO controller is OK, but I can't make flexible pin assignment for the PWM
operation.
For example, multiple output pins can be controlled by one PWM generator.
These pin assignment are configurable - not fixed type.
And pinmux are only two cases - GPIO and PWM.
I think current driver structure is better because LP3943 uses very limited
pinctrl functionalities.
Any suggestion for this?

> > > > +static int __init lp3943_init(void) {
> > > > +	return i2c_add_driver(&lp3943_driver); }
> > > > +subsys_initcall(lp3943_init);
> > > > +
> > > > +static void __exit lp3943_exit(void) {
> > > > +	i2c_del_driver(&lp3943_driver);
> > > > +}
> > > > +module_exit(lp3943_exit);
> > >
> > > I think you want to replace:
> > >   lp3943_init()
> > >   lp3943_exit
> > >
> > > With:
> > >   module_i2c_driver()
> >
> > This is related with initcall sequence.
> > Some problem may happen if any GPIO or PWM consumer tries to request
> > before
> > LP3943 MFDs are added.
> > For example, a GPIO is requested in _probe() of some device.
> > Let's assume the GPIO number is in range of what LP3943 GPIO driver
> provided.
> > Then, gpio_request() will be failed because the GPIO is invalid at this
> moment.
> > If the device request again later, it will be OK, but we can't expect
> > this situation for every driver.
> > Some drivers request a GPIO only once in _probe(), other devices may
> > request a GPIO in some cases.
> > So, I think lp3943_init() should be defined as subsys_initcall()
> > instead of module_init().
> 
> No I don't think so. Instead, you should use -EPROBE_DEFER in lieu of messing
> around with initialisation orders.

OK, got it. I'll replace them with module_i2c_driver(). Thanks!

Best Regards,
Milo

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
