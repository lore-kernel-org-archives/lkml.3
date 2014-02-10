Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaBJN2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:28:05 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44014 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaBJN2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:28:00 -0500
Message-ID: <1392038875.6687.17.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH 1/2] regulator: anatop: Add power gating support to
 digital LDOs
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, Anson Huang <b20788@freescale.com>,
        kernel@pengutronix.de
Date: Mon, 10 Feb 2014 14:27:55 +0100
In-Reply-To: <20140210131557.GB1757@sirena.org.uk>
References: <1391697813-20091-1-git-send-email-p.zabel@pengutronix.de>
	 <20140210131557.GB1757@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Am Montag, den 10.02.2014, 13:15 +0000 schrieb Mark Brown:
> On Thu, Feb 06, 2014 at 03:43:32PM +0100, Philipp Zabel wrote:
> > The ARM, PU, and SOC LDOs in the i.MX6 PMU can completely gate
> > their power output. Since power gating is configured by writing
> > zero to the voltage target bitfield,, store a copy of the
> > voltage selector to be restored when reenabling the regulator.
> 
> This is mostly good but...
>
> >  static int anatop_regmap_set_voltage_sel(struct regulator_dev *reg,
> >  					unsigned selector)
> >  {
> >  	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
> > +	int ret;
> >  
> >  	if (!anatop_reg->control_reg)
> >  		return -ENOTSUPP;
> >  
> > -	return regulator_set_voltage_sel_regmap(reg, selector);
> > +	ret = regulator_set_voltage_sel_regmap(reg, selector);
> > +	if (!ret)
> > +		anatop_reg->sel = selector;
> > +	return ret;
> >  }
> 
> ...I don't understand this.  If the regulator is disabled won't this
> cause it to be reenabled since we just write the stored selector in to
> do that?  What I'd expect to see happening is the data being written to
> the cache always and only written to the hardware if it's enabled.

yes, thanks. I'll fix this. What should happen if the
regulator_set_voltage_sel_regmap fails? Is it ok to still
set the cache in this case?

> > +static int anatop_regmap_disable(struct regulator_dev *reg)
> > +{
> > +	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
> > +
> > +	if (!anatop_is_core_reg(anatop_reg))
> > +		return -ENOTSUPP;
> > +
> > +	return regulator_set_voltage_sel_regmap(reg, LDO_POWER_GATE);
> > +}
> 
> It's starting to seem like it's worth having separate ops for the core
> regulator rather than all these conditionals.

Will do.

regards
Philipp

