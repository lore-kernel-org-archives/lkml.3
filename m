Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbaISDab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 23:30:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53320 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaISDa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 23:30:29 -0400
Date: Thu, 18 Sep 2014 22:24:16 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] watchdog: qcom: add support for KPSS WDT
Message-ID: <20140919032416.GE3749@joshc.qualcomm.com>
References: <cover.1411078425.git.joshc@codeaurora.org>
 <32d17907ad1dfdcafe4e76f33adc2ff22631cd28.1411078425.git.joshc@codeaurora.org>
 <541B97CD.60400@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541B97CD.60400@roeck-us.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 07:41:17PM -0700, Guenter Roeck wrote:
> On 09/18/2014 03:26 PM, Josh Cartwright wrote:
> >Add a driver for the watchdog timer block found in the Krait Processor
> >Subsystem (KPSS) on the MSM8960, APQ8064, and IPQ8064.
> >
> >Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> 
> Hi Josh,
> 
> comments inline.

Thanks for taking a look!

[..]
> >+static int qcom_watchdog_probe(struct platform_device *pdev)
> >+{
> >+	struct qcom_wdt *wdt;
> >+	struct resource *res;
> >+	u32 tmp;
> >+	int ret;
> >+
> >+	wdt = devm_kzalloc(&pdev->dev, sizeof(*wdt), GFP_KERNEL);
> >+	if (!wdt)
> >+		return -ENOMEM;
> >+
> >+	platform_set_drvdata(pdev, wdt);
> >+
> >+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >+	wdt->base = devm_ioremap_resource(&pdev->dev, res);
> >+	if (IS_ERR(wdt->base))
> >+		return PTR_ERR(wdt->base);
> >+
> >+	ret = of_property_read_u32(pdev->dev.of_node, "clock-frequency", &tmp);
> >+	if (ret) {
> >+		dev_err(&pdev->dev, "unable to get clock-frequency\n");
> >+		return ret;
> >+	}
> >+
>
> You might want to use a clock property here, and the complete sequence of
> 	devm_clk_get
> 	clk_prepare_enable
> 	clk_disable_unprepare
> 	clk_get_rate

Agreed.  I think this would be ideal.  I'll need to take a closer look
at how this thing is clocked, and how/if the clocks are currently
being modelled.

> >+	wdt->freq = tmp;
> >+
> >+	wdt->wdd.dev = &pdev->dev;
> >+	wdt->wdd.info = &qcom_wdt_info;
> >+	wdt->wdd.ops = &qcom_wdt_ops;
> >+	wdt->wdd.min_timeout = 1;
> >+	wdt->wdd.max_timeout = 0x10000000U / wdt->freq;
>
> As written, wdt->freq can be 0, which results in a nice division by zero here.

Indeed.  I'll add a check.

> >+	watchdog_init_timeout(&wdt->wdd, 0, &pdev->dev);
>
> That leaves you with no default timeout if timeout-sec is not set in devicetree,
> which if I understand the code correctly might result in an immediate reset.
> Is this really what you want to happen ?

I think I'd like to handle timeout-sec being unspecified as an error at
probe.  If someone explicitly sets timeout-sec = <0>, then they get what
they ask for.  I'll take another look to see how to make this happen.

> >+
> >+	ret = watchdog_register_device(&wdt->wdd);
> >+	if (ret) {
> >+		dev_err(&pdev->dev, "failed to register watchdog\n");
> >+		return ret;
> >+	}
> >+
> >+	return 0;
> >+}
> >+
> >+static const struct of_device_id qcom_wdt_of_table[] = {
> >+	{ .compatible = "qcom,kpss-wdt-msm8960", },
> >+	{ .compatible = "qcom,kpss-wdt-apq8064", },
> >+	{ .compatible = "qcom,kpss-wdt-ipq8064", },
> >+	{ },
> >+};
> >+MODULE_DEVICE_TABLE(of, qcom_wdt_of_table);
> >+
> >+static struct platform_driver qcom_watchdog_driver = {
> >+	.probe	= qcom_watchdog_probe,
>
> No remove function ?
>
> Yes, you don't need it, because the driver can only be built into the kernel,
> but there is a practical impact: It means the driver must always be built
> into the kernel even if the image is supposed to be used on different systems,
> some of which may not support this specific watchdog.
>
> Sure, you might say that you don't care about images supporting more than one
> hardware, but the tendency seems to be multi-target images nowadays.

This was motivated by the addition of the restart_handler bits in patch
3.  For some reason I was thinking there were race conditions between
module unloading/the restart_handler mechanism, but looking at it again,
I'm not so sure.  Is it safe to implement these handlers in modules?  If
so, I'll revisit this.

Thanks again,
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
