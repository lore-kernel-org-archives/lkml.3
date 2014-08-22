Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbaHVPiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:38:17 -0400
Received: from [207.46.163.189] ([207.46.163.189]:22148 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932097AbaHVPiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:38:14 -0400
Date: Fri, 22 Aug 2014 10:30:58 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Mark Brown <broonie@kernel.org>
CC: <linux@roeck-us.net>, <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>,
        <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH 2/2] pmbus: ltc2978: add regulator gating
In-Reply-To: <20140822003650.GQ24407@sirena.org.uk>
Message-ID: <alpine.DEB.2.02.1408221026340.30084@atx-linux-37>
References: <1408659686-29106-1-git-send-email-atull@opensource.altera.com> <1408659686-29106-3-git-send-email-atull@opensource.altera.com> <20140822003650.GQ24407@sirena.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0018.namprd02.prod.outlook.com (10.141.56.18) To
 BL2PR03MB306.namprd03.prod.outlook.com (10.141.68.14)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0311124FA9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(51704005)(41574002)(199003)(189002)(24454002)(51914003)(92566001)(79102001)(83506001)(87976001)(19580395003)(69596002)(85306004)(105586002)(95666004)(110136001)(106356001)(54356999)(46406003)(85852003)(76176999)(90102001)(99396002)(86362001)(80022001)(83322001)(107046002)(92726001)(83072002)(81542001)(50986999)(20776003)(81342001)(46102001)(21056001)(23726002)(102836001)(64706001)(47776003)(50466002)(42186005)(4396001)(86152002)(77096002)(101416001)(66066001)(31966008)(33716001)(53416004)(74662001)(77982001)(76482001)(74502001)(81156004);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB306;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Mark Brown wrote:

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

Hi Mark,

Thanks for the review.  I'll fix these two Kconfig issues.

> 
> > +#include <linux/regulator/driver.h>
> > +#include <linux/regulator/machine.h>
> 
> If you need machine.h that's suspicious...  why do you need it?

It was to define 'struct regulator_init_data' which I had hardwired here 
as you noted below.  Will fix.

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
> 

Yes, this info should be from board info or device tree.  I'll fix this.

Thanks!

Alan
