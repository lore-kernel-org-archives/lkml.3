Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbaIRRde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:33:34 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:49590 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbaIRRdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:33:32 -0400
Date: Thu, 18 Sep 2014 10:33:27 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        Mark Brown <broonie@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 3/3] mfd: palmas: Add support for optional wakeup
Message-ID: <20140918173327.GD8740@lee--X1>
References: <1409950311-25236-1-git-send-email-nm@ti.com>
 <1409950311-25236-4-git-send-email-nm@ti.com>
 <alpine.DEB.2.10.1409052311210.5472@nanos>
 <20140908154109.GA12336@kahuna>
 <541AE40F.1090101@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <541AE40F.1090101@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014, Nishanth Menon wrote:

> On 09/08/2014 10:41 AM, Nishanth Menon wrote:
> > On 23:13-20140905, Thomas Gleixner wrote:
> >> On Fri, 5 Sep 2014, Nishanth Menon wrote:
> >>> +	if (!palmas->wakeirq)
> >>> +		goto no_wake_irq;
> >>> +
> >>> +	ret = devm_request_irq(palmas->dev, palmas->wakeirq,
> >>> +			       palmas_wake_irq,
> >>> +			       IRQF_ONESHOT | pdata->irq_flags,
> >>
> >> Why is this marked IRQF_ONESHOT?
> > 
> > Uggh.. should have dropped it. my bad.. removed in the revision below.
> > Thanks for catching it.
> >>
> >>> +			       dev_name(palmas->dev),
> >>> +			       &palmas);
> >>> +	if (ret < 0)
> >>> +		goto err_i2c;
> >>
> >> Why err and not doing the obvious clearing of palmas->wakeirq and
> >> keep at least the i2c functional?
> > Hmmm.. true.. we can stay alive even though without wakeup capability if
> > someone messes up configuration..
> > 
> > Fixed version below. Let me know if you are ok with the following.
> 
> Gentle ping. Would you like me to repost this series over again?

Yes, always.

> > ----8<----
> > From 6da58ac66eedea46cf7282c6644c76c8f328f5ee Mon Sep 17 00:00:00 2001
> > From: Nishanth Menon <nm@ti.com>
> > Date: Tue, 12 Aug 2014 12:00:52 -0500
> > Subject: [PATCH V3 3/3] mfd: palmas: Add support for optional wakeup
> > 
> > With the recent pinctrl-single changes, omaps can treat wake-up events
> > from deeper power  states as interrupts.
> > 
> > This is to handle the case where the system needs two interrupt
> > sources when SoC is in deep sleep(1 to exit from deep power mode such
> > as sleep, and other from the module handling the actual event during
> > system active state). This is not the same as threaded interrupts as the
> > wakeup interrupt source is used only as part of deeper power saving
> > mode.
> > 
> > Let's add support for the optional second interrupt for wake-up
> > events. And then SoC can wakeup and handle the event using it's
> > regular handler.
> > 
> > This is similar in approach to commit 2a0b965cfb6e ("serial: omap: Add
> > support for optional wake-up")
> > 
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> > ---
> >  drivers/mfd/palmas.c       |   62 ++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/palmas.h |    2 ++
> >  2 files changed, 64 insertions(+)
> > 
> > diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
> > index 28cb048..de7d204 100644
> > --- a/drivers/mfd/palmas.c
> > +++ b/drivers/mfd/palmas.c
> > @@ -24,6 +24,7 @@
> >  #include <linux/mfd/core.h>
> >  #include <linux/mfd/palmas.h>
> >  #include <linux/of_device.h>
> > +#include <linux/of_irq.h>
> >  
> >  static const struct regmap_config palmas_regmap_config[PALMAS_NUM_CLIENTS] = {
> >  	{
> > @@ -326,6 +327,16 @@ static struct regmap_irq_chip tps65917_irq_chip = {
> >  			PALMAS_INT1_MASK),
> >  };
> >  
> > +static irqreturn_t palmas_wake_irq(int irq, void *_palmas)
> > +{
> > +	/*
> > +	 * Return Not handled so that interrupt is disabled.
> > +	 * Level event ensures that the event is eventually handled
> > +	 * by the appropriate chip handler already registered
> > +	 */
> > +	return IRQ_NONE;
> > +}
> > +
> >  int palmas_ext_control_req_config(struct palmas *palmas,
> >  	enum palmas_external_requestor_id id,  int ext_ctrl, bool enable)
> >  {
> > @@ -409,6 +420,7 @@ static void palmas_dt_to_pdata(struct i2c_client *i2c,
> >  		pdata->mux_from_pdata = 1;
> >  		pdata->pad2 = prop;
> >  	}
> > +	pdata->wakeirq = irq_of_parse_and_map(node, 1);
> >  
> >  	/* The default for this register is all masked */
> >  	ret = of_property_read_u32(node, "ti,power-ctrl", &prop);
> > @@ -521,6 +533,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
> >  	i2c_set_clientdata(i2c, palmas);
> >  	palmas->dev = &i2c->dev;
> >  	palmas->irq = i2c->irq;
> > +	palmas->wakeirq = pdata->wakeirq;
> >  
> >  	match = of_match_device(of_palmas_match_tbl, &i2c->dev);
> >  
> > @@ -587,6 +600,25 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
> >  	if (ret < 0)
> >  		goto err_i2c;
> >  
> > +	if (!palmas->wakeirq)
> > +		goto no_wake_irq;
> > +
> > +	ret = devm_request_irq(palmas->dev, palmas->wakeirq,
> > +			       palmas_wake_irq,
> > +			       pdata->irq_flags,
> > +			       dev_name(palmas->dev),
> > +			       &palmas);
> > +	if (ret < 0) {
> > +		dev_err(palmas->dev, "Invalid wakeirq(%d) (res: %d), skiping\n",
> > +			palmas->wakeirq, ret);
> > +		palmas->wakeirq = 0;
> > +	} else {
> > +		/* We use wakeirq only during suspend-resume path */
> > +		device_set_wakeup_capable(palmas->dev, true);
> > +		disable_irq_nosync(palmas->wakeirq);
> > +	}
> > +
> > +no_wake_irq:
> >  no_irq:
> >  	slave = PALMAS_BASE_TO_SLAVE(PALMAS_PU_PD_OD_BASE);
> >  	addr = PALMAS_BASE_TO_REG(PALMAS_PU_PD_OD_BASE,
> > @@ -706,6 +738,34 @@ static int palmas_i2c_remove(struct i2c_client *i2c)
> >  	return 0;
> >  }
> >  
> > +static int palmas_i2c_suspend(struct i2c_client *i2c,  pm_message_t mesg)
> > +{
> > +	struct palmas *palmas = i2c_get_clientdata(i2c);
> > +	struct device *dev = &i2c->dev;
> > +
> > +	if (!palmas->wakeirq)
> > +		return 0;
> > +
> > +	if (device_may_wakeup(dev))
> > +		enable_irq(palmas->wakeirq);
> > +
> > +	return 0;
> > +}
> > +
> > +static int palmas_i2c_resume(struct i2c_client *i2c)
> > +{
> > +	struct palmas *palmas = i2c_get_clientdata(i2c);
> > +	struct device *dev = &i2c->dev;
> > +
> > +	if (!palmas->wakeirq)
> > +		return 0;
> > +
> > +	if (device_may_wakeup(dev))
> > +		disable_irq_nosync(palmas->wakeirq);
> > +
> > +	return 0;
> > +}
> > +
> >  static const struct i2c_device_id palmas_i2c_id[] = {
> >  	{ "palmas", },
> >  	{ "twl6035", },
> > @@ -721,6 +781,8 @@ static struct i2c_driver palmas_i2c_driver = {
> >  		   .of_match_table = of_palmas_match_tbl,
> >  		   .owner = THIS_MODULE,
> >  	},
> > +	.suspend = palmas_i2c_suspend,
> > +	.resume = palmas_i2c_resume,
> >  	.probe = palmas_i2c_probe,
> >  	.remove = palmas_i2c_remove,
> >  	.id_table = palmas_i2c_id,
> > diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
> > index fb0390a..e8cf4c2 100644
> > --- a/include/linux/mfd/palmas.h
> > +++ b/include/linux/mfd/palmas.h
> > @@ -75,6 +75,7 @@ struct palmas {
> >  	/* IRQ Data */
> >  	int irq;
> >  	u32 irq_mask;
> > +	int wakeirq;
> >  	struct mutex irq_lock;
> >  	struct regmap_irq_chip_data *irq_data;
> >  
> > @@ -377,6 +378,7 @@ struct palmas_clk_platform_data {
> >  
> >  struct palmas_platform_data {
> >  	int irq_flags;
> > +	int wakeirq;
> >  	int gpio_base;
> >  
> >  	/* bit value to be loaded to the POWER_CTRL register */
> > 
> 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
