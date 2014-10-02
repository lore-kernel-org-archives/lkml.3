Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaJBStv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:49:51 -0400
Received: from mail-bn1bon0091.outbound.protection.outlook.com ([157.56.111.91]:12698
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751677AbaJBStt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:49:49 -0400
Date: Thu, 2 Oct 2014 13:43:30 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Guenter Roeck <linux@roeck-us.net>
CC: Mark Brown <broonie@kernel.org>, <jdelvare@suse.de>,
        <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v4 3/4] pmbus: add regulator support
In-Reply-To: <542D5186.7060908@roeck-us.net>
Message-ID: <alpine.DEB.2.02.1410021341570.11795@atx-linux-37>
References: <1412190349-16343-1-git-send-email-atull@opensource.altera.com> <1412190349-16343-4-git-send-email-atull@opensource.altera.com> <20141002112011.GS4273@sirena.org.uk> <542D5186.7060908@roeck-us.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0041.namprd05.prod.outlook.com (10.141.20.11) To
 BY2PR03MB313.namprd03.prod.outlook.com (10.141.139.13)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB313;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(164054003)(51704005)(479174003)(377454003)(24454002)(86362001)(101416001)(69596002)(4396001)(64706001)(19580395003)(10300001)(120916001)(81156004)(105586002)(107046002)(106356001)(95666004)(87976001)(99396003)(76482002)(19580405001)(77096002)(31966008)(85852003)(46102003)(80022003)(15975445006)(15202345003)(97736003)(83506001)(102836001)(110136001)(23726002)(46406003)(50986999)(20776003)(86152002)(92726001)(66066001)(53416004)(50466002)(21056001)(85306004)(54356999)(92566001)(33716001)(93886004)(47776003)(42186005)(76176999);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB313;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2014, Guenter Roeck wrote:

> On 10/02/2014 04:20 AM, Mark Brown wrote:
> > On Wed, Oct 01, 2014 at 02:05:49PM -0500, atull@opensource.altera.com wrote:
> > > From: Alan Tull <atull@opensource.altera.com>
> > > 
> > > Add support for simple on/off control of each channel.
> > 
> > This is basically fine but the regulator API has moved on a bit with the
> > DT handling over the time you've been working on this.
> > 
> > > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > > 
> > > v2: Remove '#include <linux/regulator/machine.h>'
> > >      Only one regulator per pmbus device
> > 
> > Put this after the --- as covered in SubmittingPatches.
> > 
> > > +static int _pmbus_regulator_on_off(struct regulator_dev *rdev, bool
> > > enable)
> > > +{
> > > +	struct device *dev = rdev_get_dev(rdev);
> > > +	struct i2c_client *client = to_i2c_client(dev->parent);
> > > +	u8 page = rdev_get_id(rdev);
> > > +
> > > +	return pmbus_update_byte_data(client, page, PMBUS_OPERATION,
> > > +				      PB_OPERATION_CONTROL_ON,
> > > +				      enable ? PB_OPERATION_CONTROL_ON : 0);
> > > +}
> > > +
> > > +static int pmbus_regulator_enable(struct regulator_dev *rdev)
> > > +{
> > > +	return _pmbus_regulator_on_off(rdev, 1);
> > > +}
> > 
> > I'm not sure factoring out the code actually won much here.
> > 
> > > +	np_regulators = of_get_child_by_name(dev->of_node, "regulators");
> > > +	if (!np_regulators)
> > > +		return 0;
> > > +
> > > +	ret = of_regulator_match(dev, np_regulators, info->reg_matches,
> > > +				 info->num_regulators);
> > > +	of_node_put(np_regulators);
> > 
> > We now have helpers in the regulator core for this - set of_match and
> > regulators_node in the regulator descriptor and the core will resolve
> > this stuff for you and...
> > 
> > > +		if (pdata && pdata->reg_init_data) {
> > > +			config.init_data = &pdata->reg_init_data[i];
> > > +		} else {
> > > +			config.init_data = info->reg_matches[i].init_data;
> > > +			config.of_node = info->reg_matches[i].of_node;
> > > +		}
> > 
> > ...you can just drop the else case (and check for reg_init_data) here.
> > 
> 
> Guess we'll need another version after all.
> 
> Alan, in that case please provide prototyles for the new API functions
> introduced in patch 2/4.
> 
> Thanks,
> Guenter

OK I have sent out v5 which uses the simplified DT parsing method.

I added the prototypes and made the other fixes requested.

Alan


> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
