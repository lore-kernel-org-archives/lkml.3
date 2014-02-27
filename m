Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaB0JER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 04:04:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:10348 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaB0JEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 04:04:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,553,1389772800"; 
   d="scan'208";a="463298033"
From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chew, Kean Ho" <kean.ho.chew@intel.com>,
        "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
Subject: RE: [PATCH] pwm: add support for Intel Low Power Subsystem PWM
Thread-Topic: [PATCH] pwm: add support for Intel Low Power Subsystem PWM
Thread-Index: AQHPMwBv2djQrKF+B0qVvtI3oBWPk5rISP8AgACFakA=
Date: Thu, 27 Feb 2014 09:03:41 +0000
Message-ID: <604BF5F4C5D71041942BC7E84ED659EA0155B2E7@PGSMSX103.gar.corp.intel.com>
References: <1390240808-18582-1-git-send-email-chiau.ee.chew@intel.com>
 <20140226143822.GG29779@ulmo.nvidia.com> <20140227090152.GH5018@intel.com>
In-Reply-To: <20140227090152.GH5018@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mika Westerberg [mailto:mika.westerberg@linux.intel.com]
> Sent: Thursday, February 27, 2014 5:02 PM
> To: Thierry Reding
> Cc: Chew, Chiau Ee; linux-pwm@vger.kernel.org; linux-kernel@vger.kernel.org;
> Chew, Kean Ho; Chang, Rebecca Swee Fun
> Subject: Re: [PATCH] pwm: add support for Intel Low Power Subsystem PWM
> 
> On Wed, Feb 26, 2014 at 03:38:23PM +0100, Thierry Reding wrote:
> > On Tue, Jan 21, 2014 at 02:00:08AM +0800, Chew Chiau Ee wrote:
> > [...]
> > > diff --git a/drivers/pwm/pwm-lpss.c b/drivers/pwm/pwm-lpss.c
> > [...]
> > > +/*
> > > + * Intel Low Power Subsystem PWM controller driver
> > > + *
> > > + * Copyright (C) 2014, Intel Corporation
> > > + * Author: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > + * Author: Chew Kean Ho <kean.ho.chew@intel.com>
> > > + * Author: Chang Rebecca Swee Fun
> > > +<rebecca.swee.fun.chang@intel.com>
> > > + * Author: Chew Chiau Ee <chiau.ee.chew@intel.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > +modify
> > > + * it under the terms of the GNU General Public License version 2
> > > +as
> > > + * published by the Free Software Foundation.
> > > + */
> > > +
> > > +#include <linux/acpi.h>
> > > +#include <linux/clk.h>
> > > +#include <linux/device.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/module.h>
> > > +#include <linux/pwm.h>
> > > +#include <linux/platform_device.h>
> > > +
> > > +#define PWM				0x00000000
> > > +#define PWM_ENABLE			BIT(31)
> > > +#define PWM_SW_UPDATE			BIT(30)
> > > +#define PWM_BASE_UNIT_SHIFT		8
> > > +#define PWM_BASE_UNIT_MASK		0x00ffff00
> > > +#define PWM_ON_TIME_DIV_MASK		0x000000ff
> >
> > Does the documentation really call this "on time"? I've always only
> > seen this called duty-cycle.
> 
> Yes, it's called like that in the documentation.
> 
> >
> > > +#define PWM_DIVISION_CORRECTION		0x2
> > > +#define PWM_LIMIT			(0x8000 +
> PWM_DIVISION_CORRECTION)
> > > +
> > > +
> > > +struct pwm_lpss_chip {
> > > +	struct pwm_chip chip;
> > > +	void __iomem *regs;
> > > +	struct clk *clk;
> > > +};
> > > +
> > > +static inline struct pwm_lpss_chip *to_lpwm(struct pwm_chip *chip)
> > > +{
> > > +	return container_of(chip, struct pwm_lpss_chip, chip); }
> > > +
> > > +static void pwm_lpss_set_state(struct pwm_lpss_chip *lpwm, bool
> > > +enable) {
> > > +	u32 ctrl;
> > > +
> > > +	ctrl = readl(lpwm->regs + PWM);
> > > +	if (enable)
> > > +		ctrl |= PWM_ENABLE;
> > > +	else
> > > +		ctrl &= ~PWM_ENABLE;
> > > +	writel(ctrl, lpwm->regs + PWM);
> >
> > Nit: could use more blank lines around readl() and writel(), but I'm
> > told that not everybody likes it that way, so if you absolutely must
> > keep it this way, that's fine, too. =)
> >
> > Also, is it really necessary to turn this into a function? It's only
> > called in three places, where each call site would only require three
> > lines. This function takes up 12 lines in total, so there's no real
> > gain.
> 
> Good point.
> 
> >
> > > +static int pwm_lpss_config(struct pwm_chip *chip, struct pwm_device
> *pwm,
> > > +	int duty_ns, int period_ns)
> >
> > Align arguments on subsequent lines with those of the first line,
> > please.
> 
> OK
> 
> >
> > > +{
> > > +	struct pwm_lpss_chip *lpwm = to_lpwm(chip);
> > > +	u8 on_time_div;
> > > +	unsigned long c = clk_get_rate(lpwm->clk);
> > > +	unsigned long long base_unit, hz = 1000000000UL;
> >
> > "hz" -> "freq"? "1000000000UL" -> "NSECS_PER_SEC"?
> 
> OK
> 
> >
> > > +static int pwm_lpss_enable(struct pwm_chip *chip, struct pwm_device
> > > +*pwm) {
> > > +	struct pwm_lpss_chip *lpwm = to_lpwm(chip);
> > > +
> > > +	clk_prepare_enable(lpwm->clk);
> >
> > You need to check the return value of clk_prepare_enable().
> 
> Indeed. Will fix.
> 
> >
> > > +#ifdef CONFIG_ACPI
> > > +struct pwm_lpss_chip *pwm_lpss_acpi_get_pdata(struct
> > > +platform_device *pdev) {
> > > +	struct pwm_lpss_chip *lpwm;
> > > +	struct resource *r;
> > > +
> > > +	lpwm = devm_kzalloc(&pdev->dev, sizeof(*lpwm), GFP_KERNEL);
> > > +	if (!lpwm) {
> > > +		dev_err(&pdev->dev, "failed to allocate memory for platform
> > > +data\n");
> >
> > No need to print this message. You should get one from the allocator
> > itself.
> 
> OK
> 
> >
> > > +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > +	if (!r) {
> > > +		dev_err(&pdev->dev, "failed to get mmio base\n");
> > > +		return NULL;
> > > +	}
> > > +
> > > +	lpwm->clk = devm_clk_get(&pdev->dev, NULL);
> > > +	if (IS_ERR(lpwm->clk)) {
> > > +		dev_err(&pdev->dev, "failed to get pwm clk\n");
> > > +		return NULL;
> > > +	}
> >
> > "pwm" -> "PWM", "clk" -> "clock", please.
> 
> OK
> 
> >
> > > +
> > > +	lpwm->chip.base = -1;
> > > +
> > > +	lpwm->regs = devm_request_and_ioremap(&pdev->dev, r);
> > > +	if (!lpwm->regs)
> >
> > devm_ioremap_resource()? If so, it returns an ERR_PTR() encoded error
> > code on failure, so make sure to check with IS_ERR(lpwm->regs) instead.
> > Also you can get rid of the extra error checking after the call to
> > platform_get_resource() because devm_ioremap_resource() checks for it
> > already.
> >
> > Furthermore the ordering of calls is somewhat unusual here. I'd prefer
> > platform_get_resource() followed by devm_ioremap_resource() directly.
> 
> Yup, we will change that.
> 
> >
> > > +		return NULL;
> > > +
> > > +	return lpwm;
> > > +}
> > > +
> > > +static const struct acpi_device_id pwm_lpss_acpi_match[] = {
> > > +	{ "80860F08", 0 },
> > > +	{ "80860F09", 0 },
> > > +	{ },
> > > +};
> > > +MODULE_DEVICE_TABLE(acpi, pwm_lpss_acpi_match); #else struct
> > > +pwm_lpss_chip *pwm_lpss_acpi_get_pdata(struct platform_device
> > > +*pdev) {
> > > +	return NULL;
> > > +}
> > > +#endif
> >
> > I think that #else is completely dead code since the driver depends on
> > ACPI and therefore CONFIG_ACPI will always be enabled when building
> > this driver.
> 
> We are getting PCI enumeration for this device as well but for now we can drop
> the code and add it back later if needed.
> 
> >
> > > +static int pwm_lpss_probe(struct platform_device *pdev) {
> > > +	struct device *dev = &pdev->dev;
> > > +	struct pwm_lpss_chip *lpwm;
> > > +	int ret;
> > > +
> > > +	lpwm = dev_get_platdata(dev);
> >
> > struct pwm_lpss_chip is defined in this source file, how can anybody
> > else know what to fill platform_data with?
> 
> Good point. Chiau Ee, do you recall why that thing is there in the first place?

This is added because we would eventually want to have PCI enumeration support
added. I think we shall find a way to better enable both the ACPI enumeration and
PCI enumeration support.

> 
> > > +	if (!lpwm) {
> > > +		lpwm = pwm_lpss_acpi_get_pdata(pdev);
> > > +		if (!lpwm)
> > > +			return -ENODEV;
> > > +	}
> > [...]
> > > +static struct platform_driver pwm_lpss_driver = {
> > > +	.driver = {
> > > +		.name = "pwm-lpss",
> > > +		.acpi_match_table = ACPI_PTR(pwm_lpss_acpi_match),
> >
> > ACPI_PTR not needed since the table will always be there.
> 
> OK.
> 
> >
> > > +	},
> > > +	.probe = pwm_lpss_probe,
> > > +	.remove = pwm_lpss_remove,
> > > +};
> > > +module_platform_driver(pwm_lpss_driver);
> > > +
> > > +MODULE_DESCRIPTION("PWM driver for Intel LPSS");
> > > +MODULE_AUTHOR("Mika Westerberg
> <mika.westerberg@linux.intel.com>");
> > > +MODULE_LICENSE("GPL");
> >
> > The file header says GPL v2, but "GPL" here means "GPL v2 or later".
> 
> OK, we will change that to GPLv2.
> 
> Thanks a lot for your review! We will do the changes and submit v2.

Ok. I will make the changes accordingly.
