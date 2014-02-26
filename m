Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaBZOi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:38:29 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:47405 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaBZOi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:38:28 -0500
Date: Wed, 26 Feb 2014 15:38:23 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Chew Kean Ho <kean.ho.chew@intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: Re: [PATCH] pwm: add support for Intel Low Power Subsystem PWM
Message-ID: <20140226143822.GG29779@ulmo.nvidia.com>
References: <1390240808-18582-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nhYGnrYv1PEJ5gA2"
Content-Disposition: inline
In-Reply-To: <1390240808-18582-1-git-send-email-chiau.ee.chew@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nhYGnrYv1PEJ5gA2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 21, 2014 at 02:00:08AM +0800, Chew Chiau Ee wrote:
[...]
> diff --git a/drivers/pwm/pwm-lpss.c b/drivers/pwm/pwm-lpss.c
[...]
> +/*
> + * Intel Low Power Subsystem PWM controller driver
> + *
> + * Copyright (C) 2014, Intel Corporation
> + * Author: Mika Westerberg <mika.westerberg@linux.intel.com>
> + * Author: Chew Kean Ho <kean.ho.chew@intel.com>
> + * Author: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> + * Author: Chew Chiau Ee <chiau.ee.chew@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/clk.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/pwm.h>
> +#include <linux/platform_device.h>
> +
> +#define PWM				0x00000000
> +#define PWM_ENABLE			BIT(31)
> +#define PWM_SW_UPDATE			BIT(30)
> +#define PWM_BASE_UNIT_SHIFT		8
> +#define PWM_BASE_UNIT_MASK		0x00ffff00
> +#define PWM_ON_TIME_DIV_MASK		0x000000ff

Does the documentation really call this "on time"? I've always only seen
this called duty-cycle.

> +#define PWM_DIVISION_CORRECTION		0x2
> +#define PWM_LIMIT			(0x8000 + PWM_DIVISION_CORRECTION)
> +
> +
> +struct pwm_lpss_chip {
> +	struct pwm_chip chip;
> +	void __iomem *regs;
> +	struct clk *clk;
> +};
> +
> +static inline struct pwm_lpss_chip *to_lpwm(struct pwm_chip *chip)
> +{
> +	return container_of(chip, struct pwm_lpss_chip, chip);
> +}
> +
> +static void pwm_lpss_set_state(struct pwm_lpss_chip *lpwm, bool enable)
> +{
> +	u32 ctrl;
> +
> +	ctrl = readl(lpwm->regs + PWM);
> +	if (enable)
> +		ctrl |= PWM_ENABLE;
> +	else
> +		ctrl &= ~PWM_ENABLE;
> +	writel(ctrl, lpwm->regs + PWM);

Nit: could use more blank lines around readl() and writel(), but I'm
told that not everybody likes it that way, so if you absolutely must
keep it this way, that's fine, too. =)

Also, is it really necessary to turn this into a function? It's only
called in three places, where each call site would only require three
lines. This function takes up 12 lines in total, so there's no real
gain.

> +static int pwm_lpss_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +	int duty_ns, int period_ns)

Align arguments on subsequent lines with those of the first line,
please.

> +{
> +	struct pwm_lpss_chip *lpwm = to_lpwm(chip);
> +	u8 on_time_div;
> +	unsigned long c = clk_get_rate(lpwm->clk);
> +	unsigned long long base_unit, hz = 1000000000UL;

"hz" -> "freq"? "1000000000UL" -> "NSECS_PER_SEC"?

> +static int pwm_lpss_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct pwm_lpss_chip *lpwm = to_lpwm(chip);
> +
> +	clk_prepare_enable(lpwm->clk);

You need to check the return value of clk_prepare_enable().

> +#ifdef CONFIG_ACPI
> +struct pwm_lpss_chip *pwm_lpss_acpi_get_pdata(struct platform_device *pdev)
> +{
> +	struct pwm_lpss_chip *lpwm;
> +	struct resource *r;
> +
> +	lpwm = devm_kzalloc(&pdev->dev, sizeof(*lpwm), GFP_KERNEL);
> +	if (!lpwm) {
> +		dev_err(&pdev->dev, "failed to allocate memory for platform data\n");

No need to print this message. You should get one from the allocator
itself.

> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!r) {
> +		dev_err(&pdev->dev, "failed to get mmio base\n");
> +		return NULL;
> +	}
> +
> +	lpwm->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(lpwm->clk)) {
> +		dev_err(&pdev->dev, "failed to get pwm clk\n");
> +		return NULL;
> +	}

"pwm" -> "PWM", "clk" -> "clock", please.

> +
> +	lpwm->chip.base = -1;
> +
> +	lpwm->regs = devm_request_and_ioremap(&pdev->dev, r);
> +	if (!lpwm->regs)

devm_ioremap_resource()? If so, it returns an ERR_PTR() encoded error
code on failure, so make sure to check with IS_ERR(lpwm->regs) instead.
Also you can get rid of the extra error checking after the call to
platform_get_resource() because devm_ioremap_resource() checks for it
already.

Furthermore the ordering of calls is somewhat unusual here. I'd prefer
platform_get_resource() followed by devm_ioremap_resource() directly.

> +		return NULL;
> +
> +	return lpwm;
> +}
> +
> +static const struct acpi_device_id pwm_lpss_acpi_match[] = {
> +	{ "80860F08", 0 },
> +	{ "80860F09", 0 },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(acpi, pwm_lpss_acpi_match);
> +#else
> +struct pwm_lpss_chip *pwm_lpss_acpi_get_pdata(struct platform_device *pdev)
> +{
> +	return NULL;
> +}
> +#endif

I think that #else is completely dead code since the driver depends on
ACPI and therefore CONFIG_ACPI will always be enabled when building this
driver.

> +static int pwm_lpss_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct pwm_lpss_chip *lpwm;
> +	int ret;
> +
> +	lpwm = dev_get_platdata(dev);

struct pwm_lpss_chip is defined in this source file, how can anybody
else know what to fill platform_data with?

> +	if (!lpwm) {
> +		lpwm = pwm_lpss_acpi_get_pdata(pdev);
> +		if (!lpwm)
> +			return -ENODEV;
> +	}
[...]
> +static struct platform_driver pwm_lpss_driver = {
> +	.driver = {
> +		.name = "pwm-lpss",
> +		.acpi_match_table = ACPI_PTR(pwm_lpss_acpi_match),

ACPI_PTR not needed since the table will always be there.

> +	},
> +	.probe = pwm_lpss_probe,
> +	.remove = pwm_lpss_remove,
> +};
> +module_platform_driver(pwm_lpss_driver);
> +
> +MODULE_DESCRIPTION("PWM driver for Intel LPSS");
> +MODULE_AUTHOR("Mika Westerberg <mika.westerberg@linux.intel.com>");
> +MODULE_LICENSE("GPL");

The file header says GPL v2, but "GPL" here means "GPL v2 or later".

Thierry

--nhYGnrYv1PEJ5gA2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDfxeAAoJEN0jrNd/PrOhNwYP/2oVuhDJFniL0pxcFIN0Bscp
mscLr44XwSfor96XhchttxdJ9rJXQ7X/GoW3dybeZ9CqUWmTFRkriDvDcRx+9BXb
XRmbC3LAWJ/uvSEUjQ7AWQaEh2Agf5NXBuLlEaVzaVPQDEnq3N9fdPCdxOCbzkgM
TW3ygL3H5OGg2NU7yCTG4JBF2ZdZ+tZXbf94MRlZZ+MgDDNXfad8rnVbEn8Tgz3F
fxYbG45mgvmxIURY0NEhiFoQ8mOIDYg7C/4HuITMW2WnYtWVIFjiu2zSG5ANGa2v
m/CHU6QJHUo/kJZzHIs1co3aVDA0T1C1y+TlqnNU0TIbAdXMcXYKcXoK6oEH5t1z
B26zHYMiZs8mfQsy8jLTgw9IWDN3X2xKFVuLKe11+l+jG91UnSqoQ0sKVKmXGQP4
NGKZ0pVJL7adduIimOEqbK9JjA6km2J+A14CwmhkkxaPnEFCwm7u4ViVusC3fivH
QltMWu8o0xxGoemNHk1onQ5ejhUVsZP652gAc45sPl+A3i/ScJfi2M6AHr+uVB1a
1uTl3N6NtN4fsolJJUYLjlDP7Re7+DXaxUetzwjUXItN/tciYTIWCpWwEZvqQfeo
0/qHYU0jt4Es6hixHXN+d2QCORsrUaRmK5/nbK4glriSGf9jDi29DkylUuLZJYKB
zud/B/gsCb7wDQjiKG/q
=o/gu
-----END PGP SIGNATURE-----

--nhYGnrYv1PEJ5gA2--
