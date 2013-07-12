Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab3GLQKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 12:10:51 -0400
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:54502
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932699Ab3GLQKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 12:10:50 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzzz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Sat, 13 Jul 2013 00:15:12 +0800
From: Robin Gong <b38343@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <lgirdwood@gmail.com>,
        <shawn.guo@linaro.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <rob@landley.net>
Subject: Re: [PATCH v2] regulator: pfuze100: add pfuze100 regulator driver
Message-ID: <20130712161511.GA21203@Robin-OptiPlex-780>
References: <1373604855-17714-1-git-send-email-b38343@freescale.com>
 <20130712144037.GJ24508@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130712144037.GJ24508@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark, 
	Thanks for your kindly review, please see below comments.

On Fri, Jul 12, 2013 at 03:40:37PM +0100, Mark Brown wrote:
> On Fri, Jul 12, 2013 at 12:54:15PM +0800, Robin Gong wrote:
> > Add pfuze100 regulator driver.
> 
> This looks mostly good.  A few small issues below but nothing major.
> 
> > +enum pfuze_id {
> > +	PFUZE_ID_PFUZE100,
> > +	PFUZE_ID_INVALID,
> > +};
> > +struct pfuze_chip {
> 
> Missing blank line here - there are a few other small coding style
> things, checkpatch should help.
>
Thanks Mark, I will check carefully, although I have run the script...
> > +static struct regulator_ops pfuze100_ldo_regulator_ops;
> > +static struct regulator_ops pfuze100_fixed_regulator_ops;
> > +static struct regulator_ops pfuze100_sw_regulator_ops;
> > +static struct regulator_ops pfuze100_swb_regulator_ops;
> 
> Better to just reorder things so that no forward declaration is needed.
> 
Accept.
> > +static const int pfuze100_swbst[] = {
> > +	5000000, 5050000, 5100000, 5150000,
> > +};
> 
> This looks like a linear map, the steps are all 50mV?
> 
Yes, but the swbst regulator share the same define type with the vsnvs regulator, and the later voltage table is not linear, so I use volt_table in swbst regulator . I don't want to  add another regulator type for this.
> > +	num_regulators = pfuze_get_num_regulators_dt(&client->dev);
> > +	if (num_regulators <= 0 && pdata)
> > +		num_regulators = pdata->num_regulators;
> > +	if (num_regulators <= 0) {
> > +		dev_err(&client->dev, "no platform data,please add it!\n");
> > +		ret = -EINVAL;
> > +		return ret;
> 
> You should just register all the regulators rather than only registering
> those that the user explicitly selects.  This allows users to inpect the
> current configuration and simplifies the code - for example you don't
> need to count the DT nodes and you can just have a simple array in the
> platform data (see how wm831x does this for an example).
> 
Yes, it will simplifies the code, but sometimes we will not use all the regulators on boards, in this case, Is it better that only register the available regulators?
> > +		/* SW2~SW4 high bit check and modify the voltage value table */
> > +		if (i > PFUZE100_SW1C && i < PFUZE100_SWBST) {
> > +			regmap_read(pfuze_chip->regmap, PFUZE100_SW2VOL +
> > +					(i - PFUZE100_SW2) * 7, &val);
> > +			if (val & 0x40) {
> > +				pfuze100_regulators[id].desc.min_uV = 800000;
> > +				pfuze100_regulators[id].desc.uV_step = 50000;
> > +			}
> > +		}
> 
> You should really be doing this on a copy of the regulators table rather
> than on the table itself.
> 
everyone of the four regulators(SW2~SW4) has two different linear voltage table which decided by the specific bit(one regulator ,one different bit) . So  will modify the voltage table dynamically before regulator register. I think this way is more simple , although looks little weird and uncomfortable.
> > +	for (i = 0; i < pfuze_chip->num_regulators; i++)
> > +		regulator_unregister(pfuze_chip->regulators[i]);
> > +	kfree(pfuze_chip);
> 
> Use devm_kzalloc().
Accept



