Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbbAVRVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:21:11 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:39908 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbbAVRVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:21:08 -0500
Date: Thu, 22 Jan 2015 17:21:00 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, rtc-linux@googlegroups.com, wim@iguana.be,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org,
        david.paris@st.com
Subject: Re: [PATCH v2 6/9] watchdog: st_wdt: Add new driver for ST's LPC
 Watchdog
Message-ID: <20150122172100.GF9129@x1>
References: <1421927767-28889-1-git-send-email-lee.jones@linaro.org>
 <1421927767-28889-7-git-send-email-lee.jones@linaro.org>
 <54C12F10.4090901@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54C12F10.4090901@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Guenter Roeck wrote:

> On 01/22/2015 03:56 AM, Lee Jones wrote:
> >Signed-off-by: David Paris <david.paris@st.com>
> >Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >---
> >  drivers/watchdog/Kconfig      |  13 ++
> >  drivers/watchdog/Makefile     |   1 +
> >  drivers/watchdog/st_lpc_wdt.c | 335 ++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 349 insertions(+)
> >  create mode 100644 drivers/watchdog/st_lpc_wdt.c

[...]

> >+struct st_wdog_syscfg {
> >+	struct regmap *regmap;
> 
> Hi David & Lee,
> 
> Why did you add the regmap pointer to this structure and not to st_wdog ?
> It is not a configuration value, after all, and it is always dereferenced
> through wt_wdog->syscfg. So all it does is to make the code more complicated.
> 
> Am I missing something ?

I guess it was just to group it all together, as it will all be used
at the same time:

	regmap_update_bits(st_wdog->syscfg->regmap,
			   st_wdog->syscfg->reset_type_reg,
			   st_wdog->syscfg->reset_type_mask,
			   st_wdog->warm_reset);

It really doesn't matter to me either way.

> >+	unsigned int reset_type_reg;
> >+	unsigned int reset_type_mask;
> >+	unsigned int enable_reg;
> >+	unsigned int enable_mask;
> >+};
> >+
> >+struct st_wdog {
> >+	void __iomem *base;
> >+	struct device *dev;
> >+	struct st_wdog_syscfg *syscfg;
> >+	struct clk *clk;
> >+	unsigned long clkrate;
> >+	bool warm_reset;
> >+};

[...]

> >+static int st_wdog_probe(struct platform_device *pdev)
> >+{
> >+	const struct of_device_id *match;
> >+	struct device_node *np = pdev->dev.of_node;
> >+	struct st_wdog *st_wdog;
> >+	struct regmap *regmap;
> >+	struct resource *res;
> >+	struct clk *clk;
> >+	void __iomem *base;
> >+	uint32_t mode;
> >+	int ret;
> >+
> >+	ret = of_property_read_u32(np, "st,lpc-mode", &mode);
> >+	if (ret) {
> >+		dev_err(&pdev->dev, "An LPC mode must be provided\n");
> >+		return -EINVAL;
> >+	}
> >+
> >+	/* LPC can either run in RTC or WDT mode */
> >+	if (mode != ST_LPC_MODE_WDT)
> >+		return -ENODEV;
> >+
> >+	st_wdog = devm_kzalloc(&pdev->dev, sizeof(*st_wdog), GFP_KERNEL);
> >+	if (!st_wdog)
> >+		return -ENOMEM;
> >+
> >+	match = of_match_device(st_wdog_match, &pdev->dev);
> >+	if (!match) {
> >+		dev_err(&pdev->dev, "Couldn't match device\n");
> >+		return -ENODEV;
> >+	}
> >+	st_wdog->syscfg	= (struct st_wdog_syscfg *)match->data;
> >+
> >+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >+	base = devm_ioremap_resource(&pdev->dev, res);
> >+	if (IS_ERR(base)) {
> >+		dev_err(&pdev->dev, "Failed to ioremap base\n");
> 
> devm_ioremap_resource already displays an error message, do this one is unnecessary.

You're right.  Will fix.

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
