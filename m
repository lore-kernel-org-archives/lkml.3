Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab3HEHrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:47:32 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:46910 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab3HEHra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:47:30 -0400
Date: Mon, 5 Aug 2013 08:47:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "Samuel Ortiz (sameo@linux.intel.com)" <sameo@linux.intel.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] mfd: add LP3943 MFD driver
Message-ID: <20130805074724.GB29942@lee--X1>
References: <A874F61F95741C4A9BA573A70FE3998F82E849D8@DQHE06.ent.ti.com>
 <20130731115630.GH13298@lee--X1>
 <A874F61F95741C4A9BA573A70FE3998F82E850A9@DQHE06.ent.ti.com>
 <20130801080331.GK13298@lee--X1>
 <A874F61F95741C4A9BA573A70FE3998F82E85CA9@DQHE06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E85CA9@DQHE06.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Although, I think the 0 = 1, 1 = 2 ... stuff is really confusing. Is
> > > > there nothing we can do about that?
> > >
> > > OK, enum value of lp3943_pwm_output can be changed as below because
> > > LP3943_PWM_INVALID is not used anymore.
> > >
> > > enum lp3943_pwm_output {
> > > 	LP3943_PWM_OUT0,
> > > 	LP3943_PWM_OUT1,
> > > 	...
> > > 	LP3943_PWM_OUT15,
> > > };
> > >
> > > Then, output index will match each enum integer value.
> > > Does it make sense?
> > 
> > Not really. IIRC the documentation said that LED0 (which I believe you're
> > calling OUT0 here) is located at pin one. So your enum above is now incorrect
> > isn't it? As *_OUT0 will be 0 and not 1? Or am I missing something?
> 
> If we consider this naming as the pin control description, it maybe confusing.
> However, this enum type means configurable platform data which output channel(s)
> are connected to LP3943 PWM controller.
> 
> I've changed this name from _PWM_LEDx to _PWM_OUTx in the second patch because
> PWM is used for not only LED function but also other operations.
> Zero base index notation is derived from the datasheet.
> If I remove LP3943_PWM_INVALID, then each enum type matches with
> register index(or offset) exactly. (But I need to fix LP3943 PWM driver)
> 
> In the meantime, I've reviewed the pin control subsystem,
> I think it is not the best way to implement LP3943 driver.
> The GPIO controller is OK, but I can't make flexible pin assignment for the PWM
> operation.
> For example, multiple output pins can be controlled by one PWM generator.
> These pin assignment are configurable - not fixed type.
> And pinmux are only two cases - GPIO and PWM.
> I think current driver structure is better because LP3943 uses very limited
> pinctrl functionalities.
> Any suggestion for this?

This is Linus Walleij's (CC'ed) domain.

> > > > > +static int __init lp3943_init(void) {
> > > > > +	return i2c_add_driver(&lp3943_driver); }
> > > > > +subsys_initcall(lp3943_init);
> > > > > +
> > > > > +static void __exit lp3943_exit(void) {
> > > > > +	i2c_del_driver(&lp3943_driver);
> > > > > +}
> > > > > +module_exit(lp3943_exit);
> > > >
> > > > I think you want to replace:
> > > >   lp3943_init()
> > > >   lp3943_exit
> > > >
> > > > With:
> > > >   module_i2c_driver()
> > >
> > > This is related with initcall sequence.
> > > Some problem may happen if any GPIO or PWM consumer tries to request
> > > before
> > > LP3943 MFDs are added.
> > > For example, a GPIO is requested in _probe() of some device.
> > > Let's assume the GPIO number is in range of what LP3943 GPIO driver
> > provided.
> > > Then, gpio_request() will be failed because the GPIO is invalid at this
> > moment.
> > > If the device request again later, it will be OK, but we can't expect
> > > this situation for every driver.
> > > Some drivers request a GPIO only once in _probe(), other devices may
> > > request a GPIO in some cases.
> > > So, I think lp3943_init() should be defined as subsys_initcall()
> > > instead of module_init().
> > 
> > No I don't think so. Instead, you should use -EPROBE_DEFER in lieu of messing
> > around with initialisation orders.
> 
> OK, got it. I'll replace them with module_i2c_driver(). Thanks!
> 
> Best Regards,
> Milo
> 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
