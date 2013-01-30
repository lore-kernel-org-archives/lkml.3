Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3A3KkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:40:22 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:50593 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3A3KkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:40:14 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v4 5/8] MFD: ti_am335x_tscadc: Add DT support
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <1358999112-31192-6-git-send-email-rachna@ti.com>
Date: Wed, 30 Jan 2013 11:40:09 +0100
Cc: <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Rob Herring <rob.herring@calxeda.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, Tony Lindgren <tony@atomide.com>,
        Benit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        <gururaja.hebbar@ti.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <A9839AA2-ABCD-4642-9766-D56824AC27AD@dominion.thruhere.net>
References: <1358999112-31192-1-git-send-email-rachna@ti.com> <1358999112-31192-6-git-send-email-rachna@ti.com>
To: "Patil, Rachna" <rachna@ti.com>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 24 jan. 2013, om 04:45 heeft "Patil, Rachna" <rachna@ti.com> het volgende geschreven:

> From: "Patil, Rachna" <rachna@ti.com>
> 
> Make changes to add DT support in the MFD core driver.
> 
> Signed-off-by: Patil, Rachna <rachna@ti.com>
> ---
> Changes in v4:
> 	Non-standard properties prefixed with vendor name.
> 
> drivers/mfd/ti_am335x_tscadc.c |   28 +++++++++++++++++++++++-----
> 1 file changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
> index e9f3fb5..87b446b 100644
> --- a/drivers/mfd/ti_am335x_tscadc.c
> +++ b/drivers/mfd/ti_am335x_tscadc.c
> @@ -22,6 +22,8 @@
> #include <linux/regmap.h>
> #include <linux/mfd/core.h>
> #include <linux/pm_runtime.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> 
> #include <linux/mfd/ti_am335x_tscadc.h>
> #include <linux/input/ti_am335x_tsc.h>
> @@ -64,20 +66,31 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
> 	struct resource		*res;
> 	struct clk		*clk;
> 	struct mfd_tscadc_board	*pdata = pdev->dev.platform_data;
> +	struct device_node	*node = pdev->dev.of_node;
> 	struct mfd_cell		*cell;
> 	int			err, ctrl;
> 	int			clk_value, clock_rate;
> -	int			tsc_wires, adc_channels = 0, total_channels;
> +	int			tsc_wires = 0, adc_channels = 0, total_channels;
> 
> -	if (!pdata) {
> +	if (!pdata && !pdev->dev.of_node) {
> 		dev_err(&pdev->dev, "Could not find platform data\n");
> 		return -EINVAL;
> 	}
> 
> -	if (pdata->adc_init)
> -		adc_channels = pdata->adc_init->adc_channels;
> +	if (pdev->dev.platform_data) {
> +		if (pdata->tsc_init)
> +			tsc_wires = pdata->tsc_init->wires;
> +
> +		if (pdata->adc_init)
> +			adc_channels = pdata->adc_init->adc_channels;
> +	} else {
> +		node = of_find_node_by_name(pdev->dev.of_node, "tsc");
> +		of_property_read_u32(node, "ti,wires", &tsc_wires);
> +
> +		node = of_find_node_by_name(pdev->dev.of_node, "adc");
> +		of_property_read_u32(node, "ti,adc-channels", &adc_channels);
> +	}

Since AM335x is DT only, why is there a platform data codepath and why is it the first branch it tries? And I guess the next question is related to the first: why doesn't it work when used with DT? When I copy over the nodes from the evm.dts to my board I get "tsc tsc: Missing platform data" in dmesg.

What are the chances this driver will work when applied on top of 3.8-rcX? Has it even been tested with that? Has it been tested at all?



