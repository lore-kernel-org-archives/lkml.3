Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaJJHpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 03:45:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49346 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaJJHpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 03:45:04 -0400
Date: Fri, 10 Oct 2014 09:44:54 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] net/phy: micrel: Add clock support for KSZ8021/KSZ8031
Message-ID: <20141010074454.GO4992@pengutronix.de>
References: <1412857956-6207-1-git-send-email-s.hauer@pengutronix.de>
 <5436BF5B.5060006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5436BF5B.5060006@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:41:16 up 30 days, 28 min, 86 users,  load average: 0.19, 0.29,
 0.27
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 10:01:15AM -0700, Florian Fainelli wrote:
> On 10/09/2014 05:32 AM, Sascha Hauer wrote:
> >  static int ksz8021_config_init(struct phy_device *phydev)
> >  {
> > +	struct clk *clk;
> >  	const u16 val = KSZPHY_OMSO_B_CAST_OFF | KSZPHY_OMSO_RMII_OVERRIDE;
> >  	int rc;
> >  
> > +	clk = devm_clk_get(&phydev->dev, "rmii-ref");
> > +	if (!IS_ERR(clk)) {
> > +		unsigned long rate = clk_get_rate(clk);
> > +
> > +		if (rate > 24500000 && rate < 25500000)
> > +			phydev->dev_flags |= MICREL_PHY_25MHZ_CLK;
> > +		else if (rate > 49500000 && rate < 50500000)
> > +			phydev->dev_flags |= MICREL_PHY_50MHZ_CLK;
> > +	}
> 
> I suppose that you could move this to the PHY driver probe() callback,
> and perform the rate checking from here, rejecting a clock whose rate is
> out of the acceptable range, and return an error to prevent the PHY
> driver registration? It is really up to you though.

Oh, it seems doing this in config_init is really wrong as it can be
called multiple times, even as a response to the SIOCSMIIREG ioctl.
We would request the clock each time then without ever releasing it.
I'll send an updated version with clock handling in probe().

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
