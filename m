Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbaGYC1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 22:27:10 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:2087
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758508AbaGYC1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 22:27:08 -0400
Date: Fri, 25 Jul 2014 10:18:54 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: <sebastian.hesselbarth@gmail.com>, <balbi@ti.com>,
        <p.zabel@pengutronix.de>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140725021853.GA11052@shlinux1.ap.freescale.net>
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com>
 <1405499166-6726-8-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405499166-6726-8-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(24454002)(51704005)(189002)(84676001)(106466001)(102836001)(50466002)(23756003)(81342001)(54356999)(31966008)(95666004)(4396001)(76482001)(105606002)(104016003)(83506001)(85852003)(81156004)(76176999)(21056001)(79102001)(87936001)(26826002)(46102001)(92566001)(69596002)(50986999)(81542001)(19580395003)(20776003)(99396002)(77982001)(6806004)(83322001)(64706001)(33656002)(85306003)(107046002)(74662001)(110136001)(97736001)(74502001)(80022001)(44976005)(19580405001)(68736004)(86362001)(47776003)(83072002)(92726001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB570;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 10:26:01AM +0200, Antoine Ténart wrote:
> Add a USB2 ChipIdea driver for ci13xxx, with optional PHY, clock
> and DMA mask, to support USB2 ChipIdea controllers that don't need
> specific functions.

You may need to indicate it is a generic usb2 glue layer driver at both
subject and context.
> 
> Needed for the Marvell Berlin SoCs USB controllers.

You can say it is tested at Marvell Berlin SoCs USB controllers.

> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  drivers/usb/chipidea/Makefile       |   1 +
>  drivers/usb/chipidea/ci_hdrc_usb2.c | 147 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 148 insertions(+)
>  create mode 100644 drivers/usb/chipidea/ci_hdrc_usb2.c
> 
> diff --git a/drivers/usb/chipidea/Makefile b/drivers/usb/chipidea/Makefile
> index 2f099c7df7b5..1fc86a2ca22d 100644
> --- a/drivers/usb/chipidea/Makefile
> +++ b/drivers/usb/chipidea/Makefile
> @@ -10,6 +10,7 @@ ci_hdrc-$(CONFIG_USB_OTG_FSM)		+= otg_fsm.o
>  
>  # Glue/Bridge layers go here
>  
> +obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_usb2.o
>  obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_msm.o
>  obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_zevio.o
>  
> diff --git a/drivers/usb/chipidea/ci_hdrc_usb2.c b/drivers/usb/chipidea/ci_hdrc_usb2.c
> new file mode 100644
> index 000000000000..4ec2240d00a1
> --- /dev/null
> +++ b/drivers/usb/chipidea/ci_hdrc_usb2.c
> @@ -0,0 +1,147 @@
> +/*
> + * Copyright (C) 2014 Marvell Technology Group Ltd.
> + *
> + * Antoine Ténart <antoine.tenart@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/usb/chipidea.h>
> +#include <linux/usb/hcd.h>
> +#include <linux/usb/ulpi.h>
> +
> +#include "ci.h"
> +
> +struct ci_hdrc_usb2_priv {
> +	struct platform_device	*ci_pdev;
> +	struct clk		*clk;
> +	u32			dma_mask;
> +};
> +
> +static int ci_hdrc_usb2_dt_probe(struct device *dev,
> +				    struct ci_hdrc_platform_data *ci_pdata,
> +				    struct ci_hdrc_usb2_priv *priv)
> +{
> +	u32 mask;
> +	int ret;
> +
> +	priv->clk = devm_clk_get(dev, NULL);
> +	if (!IS_ERR(priv->clk)) {
> +		ret = clk_prepare_enable(priv->clk);
> +		if (ret) {
> +			dev_err(dev, "failed to enable the clock: %d\n", ret);
> +			return ret;
> +		}
> +	}

The clk API may be needed for both DT and non-DT cases.

> +
> +	ci_pdata->phy = of_phy_get(dev->of_node, 0);
> +	if (IS_ERR(ci_pdata->phy)) {
> +		if (PTR_ERR(ci_pdata->phy) == -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +
> +		/* PHY is optional */
> +		ci_pdata->phy = NULL;
> +	}
> +
> +	if (of_property_read_u32(dev->of_node, "dma-mask", &mask))
> +		priv->dma_mask = mask;
> +
According to discussion, you may not need dma_mask in driver any more,
and use below API for both DT and non-DT case.

        err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
        if (err)
        	                handle error;

Peter

> +	return 0;
> +}
> +
> +static struct ci_hdrc_platform_data ci_default_pdata = {
> +	.capoffset	= DEF_CAPOFFSET,
> +	.flags		= CI_HDRC_REQUIRE_TRANSCEIVER |
> +			  CI_HDRC_DISABLE_STREAMING,
> +};
> +
> +static int ci_hdrc_usb2_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct ci_hdrc_usb2_priv *priv;
> +	struct ci_hdrc_platform_data *ci_pdata = dev_get_platdata(&pdev->dev);
> +	int ret;
> +
> +	if (!ci_pdata)
> +		ci_pdata = &ci_default_pdata;
> +
> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	if (dev->of_node) {
> +		ret = ci_hdrc_usb2_dt_probe(dev, ci_pdata, priv);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	ci_pdata->name = dev_name(&pdev->dev);
> +
> +	if (priv->dma_mask) {
> +		ret = dma_coerce_mask_and_coherent(&pdev->dev, priv->dma_mask);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	priv->ci_pdev = ci_hdrc_add_device(dev, pdev->resource,
> +				     pdev->num_resources, ci_pdata);
> +	if (IS_ERR(priv->ci_pdev)) {
> +		ret = PTR_ERR(priv->ci_pdev);
> +		if (ret != -EPROBE_DEFER)
> +			dev_err(dev,
> +				"failed to register ci_hdrc platform device: %d\n",
> +				ret);
> +		goto clk_err;
> +	}
> +
> +	platform_set_drvdata(pdev, priv);
> +
> +	pm_runtime_no_callbacks(dev);
> +	pm_runtime_enable(dev);
> +
> +	return 0;
> +
> +clk_err:
> +	if (!IS_ERR(priv->clk))
> +		clk_disable_unprepare(priv->clk);
> +	return ret;
> +}
> +
> +static int ci_hdrc_usb2_remove(struct platform_device *pdev)
> +{
> +	struct ci_hdrc_usb2_priv *priv = platform_get_drvdata(pdev);
> +
> +	pm_runtime_disable(&pdev->dev);
> +	ci_hdrc_remove_device(priv->ci_pdev);
> +	clk_disable_unprepare(priv->clk);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id ci_hdrc_usb2_of_match[] = {
> +	{ .compatible = "chipidea,usb2" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, ci_hdrc_usb2_of_match);
> +
> +static struct platform_driver ci_hdrc_usb2_driver = {
> +	.probe	= ci_hdrc_usb2_probe,
> +	.remove	= ci_hdrc_usb2_remove,
> +	.driver	= {
> +		.name		= "chipidea-usb2",
> +		.owner		= THIS_MODULE,
> +		.of_match_table	= of_match_ptr(ci_hdrc_usb2_of_match),
> +	},
> +};
> +module_platform_driver(ci_hdrc_usb2_driver);
> +
> +MODULE_DESCRIPTION("ChipIdea HDRC USB2 binding for ci13xxx");
> +MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
> +MODULE_LICENSE("GPL");
> -- 
> 1.9.1
> 

-- 

Best Regards,
Peter Chen
