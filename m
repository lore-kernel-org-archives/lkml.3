Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaGCLgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 07:36:53 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55249 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbaGCLgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 07:36:51 -0400
Date: Thu, 3 Jul 2014 12:36:45 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Jenny Tc <jenny.tc@intel.com>
Subject: Re: [RESEND PATCH 3/5] charger: max14577: Configure
 battery-dependent settings from DTS
Message-ID: <20140703113645.GB28504@leverpostej>
References: <1404198121-22989-1-git-send-email-k.kozlowski@samsung.com>
 <1404198121-22989-4-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404198121-22989-4-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 08:01:58AM +0100, Krzysztof Kozlowski wrote:
> Remove hard-coded values for:
>  - Fast Charge current,
>  - End Of Charge current,
>  - Fast Charge timer,
>  - Overvoltage Protection Threshold,
>  - Battery Constant Voltage,
> and use DTS to configure them. This allows using the max14577 charger
> driver with different batteries.
> 
> Now the charger driver requires valid configuration data from DTS. In
> case of wrong configuration data it fails during probe. Patch adds
> of_compatible to the charger mfd cell in MFD driver core.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Jenny Tc <jenny.tc@intel.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/max14577.c               |   5 +-
>  drivers/power/max14577_charger.c     | 232 +++++++++++++++++++++++++++++++----
>  include/linux/mfd/max14577-private.h |  16 +++
>  include/linux/mfd/max14577.h         |   8 ++
>  4 files changed, 233 insertions(+), 28 deletions(-)

[...]

> +       pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +       if (!pdata) {
> +               dev_err(&pdev->dev, "Memory alloc for charger pdata failed\n");
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       ret = of_property_read_u32(np, "maxim,fast-charge-timer",
> +                       &pdata->fast_charge_timer);
> +       if (ret)
> +               return ERR_PTR(ret);
> +
> +       ret = of_property_read_u32(np, "maxim,constant-uvolt",
> +                       &pdata->constant_uvolt);
> +       if (ret)
> +               return ERR_PTR(ret);
> +
> +       ret = of_property_read_u32(np, "maxim,fast-charge-uamp",
> +                       &pdata->fast_charge_uamp);
> +       if (ret)
> +               return ERR_PTR(ret);
> +
> +       ret = of_property_read_u32(np, "maxim,eoc-uamp", &pdata->eoc_uamp);
> +       if (ret)
> +               return ERR_PTR(ret);
> +
> +       ret = of_property_read_u32(np, "maxim,ovp-uvolt", &pdata->ovp_uvolt);
> +       if (ret)
> +               return ERR_PTR(ret);

None of the fields being read into are u32 per the structure definition
below. Please use a u32 temporary variable or make the fields u32
values.

It would also be a good idea to print a warning as to _which_ field is
missing and/or invalid as that really helps someone writing a DTS to
figure out why the device isn't probing.

[...]

> +struct max14577_charger_platform_data {
> +       unsigned int fast_charge_timer;
> +       unsigned int constant_uvolt;
> +       unsigned int fast_charge_uamp;
> +       unsigned int eoc_uamp;
> +       unsigned int ovp_uvolt;
> +};

Thanks,
Mark.
