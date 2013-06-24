Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab3FXJYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:24:51 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.143]:52043 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092Ab3FXJYt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:24:49 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Jun 2013 05:24:49 EDT
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-16.tower-179.messagelabs.com!1372065491!27553148!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [RFC V1] COMMIT 1: DA9210 driver files
Thread-Topic: [RFC V1] COMMIT 1: DA9210 driver files
Thread-Index: AQHObpIm+PFPby+OME2lP/6mSPiChZlEj/MQ
Date: Mon, 24 Jun 2013 09:18:11 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB71D6CABFB@SW-EX-MBX02.diasemi.com>
References: <201306201454.r5KEsAAS010978@swsrvapps-01.diasemi.com>
 <20130621151523.GA27646@sirena.org.uk>
In-Reply-To: <20130621151523.GA27646@sirena.org.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 June 2013, Mark Brown wrote:

>
>On Thu, Jun 20, 2013 at 02:42:03PM +0100, Steve Twiss wrote:
>
>> @@ -293,6 +293,13 @@ config REGULATOR_LP8788
>>  	help
>>  	  This driver supports LP8788 voltage regulator chip.
>>
>> +config REGULATOR_DA9210
>> +	bool "Dialog Semiconductor DA9210 Regulator"
>> +	depends on I2C=y
>> +	select REGMAP_I2C
>> +	help
>> +	  Support for the Dialog Semiconductor DA9210 chip.
>> +
>>  config REGULATOR_PCF50633
>
>This file ought to be kept sorted though it seems that's not been happening, and I'm not
>seeing any reason why this can't be a tristate.
>

I have made this alphabetical now. 
I will also change this so it is capable of being built as a module then re-submit.

>> +#define DRIVER_NAME	"da9210"
>
>Why?
>

This has been removed and the other places have been replaced with a string instead.

>> +struct da9210 {
>> +	struct i2c_client *i2c;
>> +	struct device *dev;
>> +	struct mutex io_mutex;
>
>Why do you need an I/O lock?
>

This has been removed.

>> +static int da9210_enable(struct regulator_dev *rdev); static int
>> +da9210_set_voltage(struct regulator_dev *rdev, int min_uV,
>> +			      int max_uV, unsigned *selector); static int
>> +da9210_get_voltage(struct regulator_dev *rdev); static int
>> +da9210_set_current_limit(struct regulator_dev *rdev, int min_uA,
>> +				    int max_uA);
>> +static int da9210_get_current_limit(struct regulator_dev *rdev);
>> +
>> +static struct regulator_ops da9210_buck_ops = {
>> +	.enable = da9210_enable,
>> +	.disable = regulator_disable_regmap,
>> +	.is_enabled = regulator_is_enabled_regmap,
>> +	.set_voltage = da9210_set_voltage,
>> +	.get_voltage = da9210_get_voltage,
>> +	.list_voltage = regulator_list_voltage_linear,
>> +	.set_current_limit = da9210_set_current_limit,
>> +	.get_current_limit = da9210_get_current_limit, };
>
>Drivers are normally written to avoid forward declarations like this.
>

I will review this.

>> +static struct regulator_consumer_supply __initdata def_da9210_consumers[] = {
>> +	REGULATOR_SUPPLY("DA9210", NULL),
>> +};
>> +
>> +static struct regulator_init_data __initdata default_da9210_constraints = {
>> +	.constraints = {
>
>This is not at all sensible, there's a good solid reason why regulator drivers don't
>generally do this...  please review the machine interface and its purpose.
>

I will do this then re-submit.

>> +static int da9210_set_voltage(struct regulator_dev *rdev, int min_uV,
>> +			      int max_uV, unsigned *selector) {
>> +	struct da9210 *chip = rdev_get_drvdata(rdev);
>> +	int val;
>> +	int ret;
>> +
>> +	val = regulator_map_voltage_linear(rdev, min_uV, max_uV);
>> +	if (val < 0)
>> +		return -EINVAL;
>> +
>> +	ret = regmap_update_bits(chip->regmap, DA9210_REG_VBUCK_A,
>> +				 DA9210_VBUCK_MASK, val);
>> +	return ret;
>> +}
>
>Why not just use set_voltage_sel()?
>

Will re-write this to use core functionality 

>> +static int da9210_get_voltage_sel(struct regulator_dev *rdev) {
>> +	struct da9210 *chip = rdev_get_drvdata(rdev);
>> +	unsigned int data;
>> +	int sel;
>> +	int ret;
>> +
>> +	ret = regmap_read(chip->regmap, DA9210_REG_VBUCK_A, &data);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	sel = (data & DA9210_VBUCK_MASK) >> DA9210_VBUCK_SHIFT;
>> +	sel -= DA9210_VBUCK_BIAS;
>> +	if (sel < 0)
>> +		sel = 0;
>> +	if (sel >= chip->info->n_steps)
>> +		sel = chip->info->n_steps - 1;
>
>This looks like poor error handling, if the value is out of range isn't there an error state?
>

I will review this 

>> +static int da9210_get_voltage(struct regulator_dev *rdev) {
>> +	struct da9210 *chip = rdev_get_drvdata(rdev);
>> +	int sel = da9210_get_voltage_sel(rdev);
>> +
>> +	if (sel < 0)
>> +		return sel;
>> +
>> +	return (chip->info->step_uV * sel) + chip->info->min_uV; }
>
>Why are you open coding core functionalit?
>
>> +static int da9210_enable(struct regulator_dev *rdev) {
>> +	return regulator_enable_regmap(rdev); }
>
>This is pointless, just use the generic function directly.
>

Done: now using regulator_enable_regmap instead of function just containing regulator_enable_regmap.

>> +
>> +	dev_info(chip->dev, "Device DA9210 detected.\n");
>
>This is just noise.
>

Removed this.

>> +static const struct i2c_device_id da9210_i2c_id[] = {
>> +	{DRIVER_NAME, 0},
>> +	{},
>
>Just use the string.
>
>> +static struct i2c_driver da9210_regulator_driver = {
>> +	.driver = {
>> +		.name = DRIVER_NAME,
>
>Similarly here.
>

Yep, remove this now.

>> +		.owner = THIS_MODULE,
>> +		},
>
>Indentation.
>

Done.

>> +static int __init da9210_regulator_init(void) {
>> +	int ret;
>> +
>> +	ret = i2c_add_driver(&da9210_regulator_driver);
>> +	if (0 != ret)
>> +		pr_err("Failed to register da9210 I2C driver\n");
>> +
>> +	return ret;
>> +}
>> +
>> +subsys_initcall(da9210_regulator_init);
>
>Just use module_platform_driver() now we have probe deferral.
>

Yes. I will look at altering this then re-submit.

>> +/*
>> + * Registers bits
>> + */
>> +/* DA9210_REG_PAGE_CON (addr=0x00) */
>> +#define	DA9210_PEG_PAGE_SHIFT			0
>> +#define	DA9210_REG_PAGE_MASK			0x0F
>> +/* On I2C registers 0x00 - 0xFF */
>> +#define	DA9210_REG_PAGE0			0
>> +/* On I2C registers 0x100 - 0x1FF */
>> +#define	DA9210_REG_PAGE2			2
>> +#define	DA9210_PAGE_WRITE_MODE			0x00
>> +#define	DA9210_REPEAT_WRITE_MODE		0x40
>> +#define	DA9210_PAGE_REVERT			0x80
>
>This looks liike you should be using a regmap range.

I will look at this again and then resubmit.
Thanks for your comments.


