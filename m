Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaHOSCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:02:25 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2828 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaHOSCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:02:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 15 Aug 2014 10:53:00 -0700
Date: Fri, 15 Aug 2014 21:02:18 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mikko Perttunen <mperttunen@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: i2c-tegra: Move clk_prepare/clk_set_rate to probe
Message-ID: <20140815180218.GH1626@tbergstrom-lnx.Nvidia.com>
References: <1408096034-17270-1-git-send-email-mperttunen@nvidia.com>
 <53EE32C7.6000500@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53EE32C7.6000500@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 06:18:15PM +0200, Stephen Warren wrote:
> On 08/15/2014 03:47 AM, Mikko Perttunen wrote:
> > Currently the i2c-tegra bus driver prepares, enables
> > and set_rates its clocks separately for each transfer.
> > This causes locking problems when doing I2C transfers
> > from clock notifiers; see
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/268653.html
> >
> > This patch moves clk_prepare/unprepare and clk_set_rate calls to
> > the probe function, leaving only clk_enable/disable to be
> > done on each transfer. This solves the locking issue.
> 
> > diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> 
> > @@ -380,34 +380,33 @@ static inline int tegra_i2c_clock_enable(struct tegra_i2c_dev *i2c_dev)
> >   {
> >   	int ret;
> >   	if (!i2c_dev->hw->has_single_clk_source) {
> > -		ret = clk_prepare_enable(i2c_dev->fast_clk);
> > +		ret = clk_enable(i2c_dev->fast_clk);
> 
> Here, both the prepare and enable wrap just the I2C transfer, ...
> 
> > @@ -428,9 +427,6 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
> >   	i2c_writel(i2c_dev, val, I2C_CNFG);
> >   	i2c_writel(i2c_dev, 0, I2C_INT_MASK);
> >
> > -	clk_multiplier *= (i2c_dev->hw->clk_divisor_std_fast_mode + 1);
> > -	clk_set_rate(i2c_dev->div_clk, i2c_dev->bus_clk_rate * clk_multiplier);
> 
> ... whereas the rate is set up when the controller is initialized, i.e. 
> much earlier.
> 
> > @@ -777,17 +774,39 @@ static int tegra_i2c_probe(struct platform_device *pdev)
> 
> > +	if (!i2c_dev->hw->has_single_clk_source) {
> > +		ret = clk_prepare(i2c_dev->fast_clk);
> > +		if (ret < 0) {
> > +			dev_err(i2c_dev->dev, "Clock prepare failed %d\n", ret);
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	ret = clk_prepare(i2c_dev->div_clk);
> > +	if (ret < 0) {
> > +		dev_err(i2c_dev->dev, "Clock prepare failed %d\n", ret);
> > +		goto unprepare_fast_clk;
> > +	}
> > +
> > +	clk_multiplier *= (i2c_dev->hw->clk_divisor_std_fast_mode + 1);
> > +	ret = clk_set_rate(i2c_dev->div_clk,
> > +			   i2c_dev->bus_clk_rate * clk_multiplier);
> > +	if (ret) {
> > +		dev_err(i2c_dev->dev, "Clock rate change failed %d\n", ret);
> > +		goto unprepare_div_clk;
> > +	}
> 
> However, the new code sets the clock rate after the clock is prepared. I 
> think the rate should be set first, then the clock prepared. While this 
> likely doesn't apply to the Tegra clock controller, prepare() is allowed 
> to enable the clock if enable() can't be implemented in an atomic 
> fashion (in which case enable/disable would be no-ops), and we should 
> make sure that the driver correctly configures the clock before 
> potentially enabling it.
> 
> I'm not sure if a similar change to our SPI drivers is possible; after 
> all, the SPI transfer rate can vary per message, so if clk_set_rate() 
> acquires a lock, it seems there's no way to avoid the issue there. 

Even for i2c this could be the case I think if you use the highspeed (3.4Mhz)
mode? From what I remember, a highspeed i2c transaction starts with a lower
speed preamble to make sure non highspeed slaves don't get confused? Which
means you could change the bus speed depending on the slave you're addressing.

> Luckily, we don't have any SPI-based chips that do anything related to 
> clocks on any of our current boards...
> 

And we don't use SPI to talk to the PMIC, which is the usecase were actually
run into problems with the locking.

Cheers,

Peter.

