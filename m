Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbaIXSg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:36:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40744 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaIXSgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:36:24 -0400
Date: Wed, 24 Sep 2014 13:30:50 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/3] watchdog: qcom: add support for KPSS WDT
Message-ID: <20140924183050.GI868@joshc.qualcomm.com>
References: <cover.1411513109.git.joshc@codeaurora.org>
 <8f4be0230a7fea8c299a0e878d0eb826eaba6099.1411513109.git.joshc@codeaurora.org>
 <20140924155854.GA12620@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924155854.GA12620@roeck-us.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 08:58:54AM -0700, Guenter Roeck wrote:
> On Tue, Sep 23, 2014 at 06:04:36PM -0500, Josh Cartwright wrote:
> > Add a driver for the watchdog timer block found in the Krait Processor
> > Subsystem (KPSS) on the MSM8960, APQ8064, and IPQ8064.
> > 
> > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> 
> Hi Josh,
> 
> looks much better. Couple of comments inline.

Thanks for another review!

[..]
> > +++ b/drivers/watchdog/Kconfig
> > @@ -443,6 +443,19 @@ config TEGRA_WATCHDOG
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called tegra_wdt.
> >  
> > +config QCOM_WDT
> > +	tristate "QCOM watchdog"
> > +	depends on HAS_IOMEM
> > +	depends on ARCH_QCOM
> > +	select WATCHDOG_CORE
> > +	help
> > +	  Say Y here to include Watchdog timer support for the watchdog found
> > +	  on QCOM chipsets.  Currently supported targets are the MSM8960,
> > +	  APQ8064, and IPQ8064.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called qcom_wdt.
> > +
> >  # AVR32 Architecture
[..]
> > +static int qcom_wdt_probe(struct platform_device *pdev)
> > +{
> > +	struct qcom_wdt *wdt;
> > +	struct resource *res;
> > +	unsigned long freq;
> > +	int ret;
> > +
> > +	wdt = devm_kzalloc(&pdev->dev, sizeof(*wdt), GFP_KERNEL);
> > +	if (!wdt)
> > +		return -ENOMEM;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	wdt->base = devm_ioremap_resource(&pdev->dev, res);
> > +	if (IS_ERR(wdt->base))
> > +		return PTR_ERR(wdt->base);
> > +
> > +	wdt->clk = devm_clk_get(&pdev->dev, NULL);
> > +	if (IS_ERR(wdt->clk))
> > +		return PTR_ERR(wdt->clk);
> > +
> > +	ret = clk_prepare_enable(wdt->clk);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "failed to setup clock\n");
> > +		return ret;
> > +	}
> > +
> > +	/*
> > +	 * We use the clock rate to calculate the max timeout, so ensure it's
> > +	 * not zero to avoid a divide-by-zero exception.
> > +	 */
> > +	freq = clk_get_rate(wdt->clk);
> > +	if (freq == 0) {
> > +		dev_err(&pdev->dev, "invalid clock rate\n");
> > +		return -EINVAL;
> > +	}
> 
> This will need clk_disable_unprepare().

Yep.  Nice catch.  Will fix.

> Since you are reading the frequency here, it might make sense to store it
> in struct qcom_wdt so you don't have to call clk_get_rate() again in the
> start function.

Yeah, it doesn't save much, but I'll go ahead and add it.

> > +	wdt->wdd.dev = &pdev->dev;
> > +	wdt->wdd.info = &qcom_wdt_info;
> > +	wdt->wdd.ops = &qcom_wdt_ops;
> > +	wdt->wdd.min_timeout = 1;
> > +	wdt->wdd.max_timeout = 0x10000000U / freq;
>
> What if the frequency turns out to be larger than 8947848 Hz ?
> Then your maximum timeout is below the default timeout.
> And if the frequency is larger than 268435456 Hz, the maximum
> timeout would be 0.

Yes, I should be doing more sanity checking.  I'll do so.

> > +	/*
> > +	 * If 'timeout-sec' unspecified in devicetree, assume a 30 second
> > +	 * default.
> > +	 */
> > +	if (watchdog_init_timeout(&wdt->wdd, 0, &pdev->dev))
> > +		wdt->wdd.timeout = 30;
> 
> You can just initialize timeout above with 30 seconds. Saves you the if
> statement here.

Great.  Thanks.

> > +	ret = watchdog_register_device(&wdt->wdd);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "failed to register watchdog\n");
>
> This will need a clk_disable_unprepare().
>
> Given that this is needed twice, you might want to consider using
> error exit code below, as suggested in CodingStyle.

Indeed.  Will do.

Thanks again,
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
