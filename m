Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbaHVBSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 21:18:16 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34182 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbaHVBSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 21:18:15 -0400
Date: Thu, 21 Aug 2014 18:18:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: atull@opensource.altera.com, jdelvare@suse.de, lm-sensors@lm-sensors.org,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH 2/2] pmbus: ltc2978: add regulator gating
Message-ID: <20140822011810.GA17461@roeck-us.net>
References: <1408659686-29106-1-git-send-email-atull@opensource.altera.com>
 <1408659686-29106-3-git-send-email-atull@opensource.altera.com>
 <20140822003650.GQ24407@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822003650.GQ24407@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 07:36:50PM -0500, Mark Brown wrote:
> On Thu, Aug 21, 2014 at 05:21:26PM -0500, atull@opensource.altera.com wrote:
> 
> > +config SENSORS_LTC2978_REGULATOR
> > +	boolean "Regulator support for LTC2974, LTC2978, LTC3880, and LTC3883"
> > +	default n
> 
> No need to say default n here, it's the default default.
> 
> > +	depends on SENSORS_LTC2978
> > +	select REGULATOR
> 
> I'd expect a depends here.
> 
> > +#include <linux/regulator/driver.h>
> > +#include <linux/regulator/machine.h>
> 
> If you need machine.h that's suspicious...  why do you need it?
> 
> > +static int ltc2978_write_pmbus_operation(struct regulator_dev *rdev, u8 value)
> > +{
> > +	struct device *dev = rdev_get_dev(rdev);
> > +	struct i2c_client *client = to_i2c_client(dev->parent);
> > +	int ret;
> > +
> > +	ret = pmbus_set_page(client, 0xff);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return i2c_smbus_write_byte_data(client, PMBUS_OPERATION, value);
> > +}
> 
> This all looks very much like pmbus could use regmap and then the regmap
> helpers.  I'd not insist on it though.  What I would however suggest is

Not unless regmap got extended recently to support quick, byte, and word
smbus accesses at the same time.

Guenter

> that these functions should all be helpers which read the specific
> page, addresses and bits to write from the driver structure - I bet the
> code is going to be identical for most pmbus using regulators and so it
> makes sense to share it like we do with the generic regmap functions.
> 
> That means that any good practice can be deployed more easily and any
> API updates only need to update the helpers.
> 
> > +static struct regulator_init_data ltc2978_regulator_init = {
> > +	.constraints = {
> > +		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
> > +	},
> > +};
> 
> You should not be forcing this on, you don't know what's safe on any
> given board.  Allow the board to specify constraints then it has
> control.


