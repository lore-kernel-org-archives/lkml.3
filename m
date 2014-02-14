Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaBNKNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:13:22 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61743 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312AbaBNKNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:13:20 -0500
Date: Fri, 14 Feb 2014 10:13:06 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Milo Kim <milo.kim@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 02/10] backlight: Add TI LMU backlight common driver
Message-ID: <20140214101306.GF25107@e106331-lin.cambridge.arm.com>
References: <1392359468-6925-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392359468-6925-1-git-send-email-milo.kim@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 06:31:08AM +0000, Milo Kim wrote:
> TI LMU backlight driver provides common driver features.
> Chip specific configuration is handled by each backlight driver such like
> LM3532, LM3631, LM3633, LM3695 and LM3697.
> 
> It supports common features as below.
>   - Consistent device control flow
>   - Control bank assignment from the platform data
>   - Backlight subsystem control
>   - PWM brightness control
>   - Shared device tree node
> 
> Cc: Jingoo Han <jg1.han@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
>  drivers/video/backlight/Kconfig            |    7 +
>  drivers/video/backlight/Makefile           |    1 +
>  drivers/video/backlight/ti-lmu-backlight.c |  369 ++++++++++++++++++++++++++++
>  drivers/video/backlight/ti-lmu-backlight.h |   78 ++++++
>  4 files changed, 455 insertions(+)
>  create mode 100644 drivers/video/backlight/ti-lmu-backlight.c
>  create mode 100644 drivers/video/backlight/ti-lmu-backlight.h

[...]

> +static int ti_lmu_backlight_parse_dt(struct device *dev, struct ti_lmu *lmu)
> +{
> +       struct ti_lmu_backlight_platform_data *pdata;
> +       struct device_node *node = dev->of_node;
> +       struct device_node *child;
> +       int num_backlights;
> +       int i = 0;
> +       u8 imax_mA;
> +
> +       if (!node) {
> +               dev_err(dev, "No device node exists\n");
> +               return -ENODEV;
> +       }
> +
> +       num_backlights = of_get_child_count(node);
> +       if (num_backlights == 0) {
> +               dev_err(dev, "No backlight strings\n");
> +               return -EINVAL;
> +       }
> +
> +       pdata = devm_kzalloc(dev, sizeof(*pdata) * num_backlights, GFP_KERNEL);
> +       if (!pdata)
> +               return -ENOMEM;
> +
> +       for_each_child_of_node(node, child) {
> +               of_property_read_string(child, "bl-name", &pdata[i].name);
> +
> +               /* Make backlight strings */
> +               pdata[i].bl_string = 0;
> +               if (of_find_property(child, "hvled1-used", NULL))
> +                       pdata[i].bl_string |= LMU_HVLED1;
> +               if (of_find_property(child, "hvled2-used", NULL))
> +                       pdata[i].bl_string |= LMU_HVLED2;
> +               if (of_find_property(child, "hvled3-used", NULL))
> +                       pdata[i].bl_string |= LMU_HVLED3;

Use of_property_read_bool here.

> +
> +               of_property_read_u8(child, "max-current-milliamp", &imax_mA);
> +               pdata[i].imax = ti_lmu_get_current_code(imax_mA);

If this is missing from a node, imax_mA will have the value from the
last iteration (or an uninitialised value).

Thanks,
Mark.
