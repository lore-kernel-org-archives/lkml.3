Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaDWVtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 17:49:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52365 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaDWVtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 17:49:45 -0400
Date: Wed, 23 Apr 2014 16:46:26 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Courtney Cavin <courtney.cavin@sonymobile.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        David Collins <collinsd@codeaurora.org>
Subject: Re: [PATCH 1/2] mfd: pm8x41: add support for Qualcomm 8x41 PMICs
Message-ID: <20140423214626.GA3215@joshc.qualcomm.com>
References: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 05:31:49PM -0700, Courtney Cavin wrote:
> From: Josh Cartwright <joshc@codeaurora.org>
> 
> The Qualcomm 8941 and 8841 PMICs are components used with the Snapdragon
> 800 series SoC family.  This driver exists largely as a glue mfd component,
> it exists to be an owner of an SPMI regmap for children devices
> described in device tree.
> 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>

Hey Courtney-

Thanks for picking this up!

One thing that I had meant to do is rename this thing.  Nothing about
this is PM8841/PM8941 specific at all.  It should apply equally to all
Qualcomm's PMICs which implement QPNP.

Perhaps a better name would be "qcom-pmic-qpnp".

[..]
> +++ b/drivers/mfd/pm8x41.c
> @@ -0,0 +1,63 @@
> +/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/spmi.h>
> +#include <linux/regmap.h>
> +#include <linux/of_platform.h>
> +
> +static const struct regmap_config pm8x41_regmap_config = {
> +	.reg_bits	= 16,
> +	.val_bits	= 8,
> +	.max_register	= 0xFFFF,
> +};

This reminds me.  David Collins (CC'd) noticed that there are usecases
where peripheral drivers will need to be accessing registers from atomic
context, so we should probably be setting .fast_io in the SPMI
regmap_bus structures, but we can tackle that when we get there.

> +
> +static int pm8x41_remove_child(struct device *dev, void *unused)
> +{
> +	platform_device_unregister(to_platform_device(dev));
> +	return 0;
> +}
> +
> +static void pm8x41_remove(struct spmi_device *sdev)
> +{
> +	device_for_each_child(&sdev->dev, NULL, pm8x41_remove_child);
> +}
> +
> +static int pm8x41_probe(struct spmi_device *sdev)
> +{
> +	struct regmap *regmap;
> +
> +	regmap = devm_regmap_init_spmi_ext(sdev, &pm8x41_regmap_config);
> +	if (IS_ERR(regmap)) {
> +		dev_dbg(&sdev->dev, "regmap creation failed.\n");
> +		return PTR_ERR(regmap);
> +	}
> +
> +	return of_platform_populate(sdev->dev.of_node, NULL, NULL, &sdev->dev);
> +}
> +
> +static const struct of_device_id pm8x41_id_table[] = {
> +	{ .compatible = "qcom,pm8841", },
> +	{ .compatible = "qcom,pm8941", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, pm8x41_id_table);

I'm thinking we should probably have a generic compatible entry as well,
"qcom,pmic-qpnp" or similar.  We should still specify in the binding
that PMIC slaves specify a version-specific string as well as the
generic string.  That is, a slave should have:

	compatible = "qcom,pm8841", "qcom,pmic-qpnp";

...in case we would ever need to differentiate in the future.

(I recall that in a previous version I had done this, but I don't
remember why I had changed it..)

Thanks again,
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
