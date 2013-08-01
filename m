Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab3HAIDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:03:42 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39944 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3HAIDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:03:37 -0400
Date: Thu, 1 Aug 2013 09:03:31 +0100
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
Message-ID: <20130801080331.GK13298@lee--X1>
References: <A874F61F95741C4A9BA573A70FE3998F82E849D8@DQHE06.ent.ti.com>
 <20130731115630.GH13298@lee--X1>
 <A874F61F95741C4A9BA573A70FE3998F82E850A9@DQHE06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E850A9@DQHE06.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jul 2013, Kim, Milo wrote:

> Thanks for the review, please see my comments.
> 
> > <snip> * looks good up to me up to here *
> > 
> > Although, I think the 0 = 1, 1 = 2 ... stuff is really confusing. Is
> > there nothing we can do about that?
> 
> OK, enum value of lp3943_pwm_output can be changed as below
> because LP3943_PWM_INVALID is not used anymore.
> 
> enum lp3943_pwm_output {
> 	LP3943_PWM_OUT0,
> 	LP3943_PWM_OUT1,
> 	...
> 	LP3943_PWM_OUT15,
> };
> 
> Then, output index will match each enum integer value.
> Does it make sense?

Not really. IIRC the documentation said that LED0 (which I believe
you're calling OUT0 here) is located at pin one. So your enum above is
now incorrect isn't it? As *_OUT0 will be 0 and not 1? Or am I missing
something?

> > > +static int __init lp3943_init(void)
> > > +{
> > > +	return i2c_add_driver(&lp3943_driver);
> > > +}
> > > +subsys_initcall(lp3943_init);
> > > +
> > > +static void __exit lp3943_exit(void)
> > > +{
> > > +	i2c_del_driver(&lp3943_driver);
> > > +}
> > > +module_exit(lp3943_exit);
> > 
> > I think you want to replace:
> >   lp3943_init()
> >   lp3943_exit
> > 
> > With:
> >   module_i2c_driver()
> 
> This is related with initcall sequence.
> Some problem may happen if any GPIO or PWM consumer tries to request before
> LP3943 MFDs are added.
> For example, a GPIO is requested in _probe() of some device.
> Let's assume the GPIO number is in range of what LP3943 GPIO driver provided.
> Then, gpio_request() will be failed because the GPIO is invalid at this moment.
> If the device request again later, it will be OK, but we can't expect this 
> situation for every driver.
> Some drivers request a GPIO only once in _probe(), other devices may request
> a GPIO in some cases.
> So, I think lp3943_init() should be defined as subsys_initcall() instead of 
> module_init().

No I don't think so. Instead, you should use -EPROBE_DEFER in lieu of
messing around with initialisation orders.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
