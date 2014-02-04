Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaBDOb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 09:31:27 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:57209 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbaBDObX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 09:31:23 -0500
Date: Tue, 4 Feb 2014 09:31:19 -0500
From: Matt Porter <mporter@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Tim Kryger <tim.kryger@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] mfd: add bcm59056 pmu driver
Message-ID: <20140204143119.GA4627@beef>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
 <1391516352-32359-4-git-send-email-mporter@linaro.org>
 <20140204132951.GE13529@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140204132951.GE13529@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 01:29:51PM +0000, Lee Jones wrote:
> > Add a driver for the BCM59056 PMU multi-function device. The driver
> > initially supports regmap initialization and instantiation of the
> > voltage regulator device function of the PMU.
> > 
> > Signed-off-by: Matt Porter <mporter@linaro.org>
> > Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> > Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> > ---
> >  drivers/mfd/Kconfig          |   8 +++
> >  drivers/mfd/Makefile         |   1 +
> >  drivers/mfd/bcm59056.c       | 119 +++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/bcm59056.h |  35 +++++++++++++
> >  4 files changed, 163 insertions(+)
> >  create mode 100644 drivers/mfd/bcm59056.c
> >  create mode 100644 include/linux/mfd/bcm59056.h
> 
> <snip>
> 
> > +static struct mfd_cell bcm59056s[] = {
> > +	{
> > +		.name = "bcm59056-pmu",
> 
> If you plan to use *->of_node in the PMU driver, which it looks like
> you do, you should set the compatible string here.

Ok. I missed that..I'll split bindings to reflect this as well. There's
an error in that the regulator properties are all defined in the base
compatible of brcm,bcm59056 atm and they'll need to be in
brcm,bcm59056-pmu's binding.

> > +	},
> > +};
> > +
> > +static const struct regmap_config bcm59056_regmap_config = {
> > +	.reg_bits	= 8,
> > +	.val_bits	= 8,
> > +	.max_register	= BCM59056_MAX_REGISTER - 1,
> 
> If you've just set this manually i.e. it's not part of an enum table,
> can't you set it a value you don't need to do math on? It's not used
> anywhere else is it?

Yes, I'll update this. It's not used elsewhere.

> 
> > +	.cache_type	= REGCACHE_RBTREE,
> > +};
> > +
> > +static int bcm59056_i2c_probe(struct i2c_client *i2c,
> > +			      const struct i2c_device_id *id)
> > +{
> > +	struct bcm59056 *bcm59056;
> > +	int chip_id = id->driver_data;
> 
> I thought this was a DT only driver? If so, you probably want to use
> of_match_device() instead.

Correct, I'll use of_match_device()

> > +	int ret = 0;
> > +
> > +	bcm59056 = devm_kzalloc(&i2c->dev, sizeof(*bcm59056), GFP_KERNEL);
> > +	if (!bcm59056)
> > +		return -ENOMEM;
> > +
> > +	i2c_set_clientdata(i2c, bcm59056);
> > +	bcm59056->dev = &i2c->dev;
> > +	bcm59056->i2c_client = i2c;
> > +	bcm59056->id = chip_id;
> > +
> > +	bcm59056->regmap = devm_regmap_init_i2c(i2c, &bcm59056_regmap_config);
> > +	if (IS_ERR(bcm59056->regmap)) {
> > +		ret = PTR_ERR(bcm59056->regmap);
> > +		dev_err(&i2c->dev, "regmap initialization failed: %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	ret = mfd_add_devices(bcm59056->dev, -1,
> > +			      bcm59056s, ARRAY_SIZE(bcm59056s),
> > +			      NULL, 0, NULL);
> 
> Are you sure you need all of your #includes?
> 
> I notice that irqdomain is there, but you don't actually have one?

Right, I'll do a sweep on them. In that particular case, I don't yet
have a need to implement interrupt support so it needs to go.

> 
> > +	if (ret < 0)
> > +		dev_err(&i2c->dev, "mfd_add_devices failed: %d\n", ret);
> 
> What if we change the name of the function? Probably better to say
> something like "device registration failed" or thelike.

Will do.

> 
> > +	return ret;
> > +}
> > +
> > +static int bcm59056_i2c_remove(struct i2c_client *i2c)
> > +{
> > +	struct bcm59056 *bcm59056 = i2c_get_clientdata(i2c);
> > +
> > +	mfd_remove_devices(bcm59056->dev);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct of_device_id bcm59056_of_match[] = {
> > +	{ .compatible = "brcm,bcm59056", .data = (void *)BCM59056 },
> 
> You've gone to the trouble of setting a device version here, but you
> don't seem to use it?

I'll drop the device version

> > +	{ }
> > +};
> > +
> > +static const struct i2c_device_id bcm59056_i2c_id[] = {
> > +	{ "bcm59056", BCM59056 },
> > +	{ }
> > +};
> 
> Ah, I guess this is where id->driver comes from.
> 
> It's pretty silly that the I2C subsystem demands the presence of this
> table, despite not using it if an of_device_id table is present.

It does make it very difficult to follow DT enabled I2C client drivers
:( I'll drop the BCM59056 too.

> > +MODULE_DEVICE_TABLE(i2c, bcm59056_i2c_id);
> > +
> > +static struct i2c_driver bcm59056_i2c_driver = {
> > +	.driver = {
> > +		   .name = "bcm59056",
> > +		   .owner = THIS_MODULE,
> > +		   .of_match_table = of_match_ptr(bcm59056_of_match),
> 
> No need to use of_match_ptr() here.

Will remove.

> > +	},
> > +	.probe = bcm59056_i2c_probe,
> > +	.remove = bcm59056_i2c_remove,
> > +	.id_table = bcm59056_i2c_id,
> 
> *grumble*

:) Yes, unavoidable for now.

> > +};
> > +
> > +static int __init bcm59056_init(void)
> > +{
> > +	return i2c_add_driver(&bcm59056_i2c_driver);
> > +}
> > +subsys_initcall(bcm59056_init);
> 
> Really? :(
> 
> Maybe you'll want to comment this, in case people do not know the back
> ground and attempts to clean it up.

I'll add a comment. This is the old problem of needing regulators really
early. It's exasperated by the fact that the USB gadget framework
drivers do not use driver probing. This means that they can not be
deferred after i2c/mfd/regulator init...the problem is particularly
noticeable when building in a gadget driver for nfsroot purposes.

Because of this I have the regulator, MFD, and i2c drivers all using
subsys_initcall() in this series. FWIW, there's some discussion about
how to resolve the USB gadget driver case but it's going to take a
while.

> > +static void __exit bcm59056_exit(void)
> > +{
> > +	i2c_del_driver(&bcm59056_i2c_driver);
> > +}
> > +module_exit(bcm59056_exit);
> 
> <snip>
> 
> > +/* chip id */
> > +#define BCM59056		0
> 
> Lonely, oh so lonely!

Understood. Will remove.

> > +/* max register address */
> > +#define BCM59056_MAX_REGISTER	0xe8
> 
> Don't you have a table of registers which you care about?

I placed the register defs that I actually use in the regulator driver
itself since that is the only place they are used. I notice most MFD
drivers centralize this in linux/mfd/*.h. However, generally chunk
of register defs are only used in one subdriver and not shared. If
it's preferred to move all register defs centrally I can do that.

> > +/* bcm59056 chip access */
> 
> Superfluous comment? Don't we all know what these containers do?

Indeed, will remove.

Thanks for reviewing.

-Matt

> > +struct bcm59056 {
> > +	struct device *dev;
> > +	struct i2c_client *i2c_client;
> > +	struct regmap *regmap;
> > +	unsigned int id;
> > +};
> > +
> > +#endif /*  __LINUX_MFD_BCM59056_H */
> 
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
