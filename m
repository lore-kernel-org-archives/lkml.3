Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbaIPAvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:51:46 -0400
Received: from mail-by2on0101.outbound.protection.outlook.com ([207.46.100.101]:27456
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756162AbaIPAvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:51:43 -0400
Date: Tue, 16 Sep 2014 08:51:30 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: <sebastian.hesselbarth@gmail.com>, <balbi@ti.com>,
        <p.zabel@pengutronix.de>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140916005129.GC3379@peterchendt>
References: <1410777378-12726-1-git-send-email-antoine.tenart@free-electrons.com>
 <1410777378-12726-8-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410777378-12726-8-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(189002)(24454002)(104016003)(90102001)(110136001)(106466001)(107046002)(57986006)(80022001)(99396002)(97736003)(85306004)(105606002)(64706001)(47776003)(20776003)(33656002)(26826002)(102836001)(46102001)(79102001)(76482001)(95666004)(77982001)(97756001)(54356999)(21056001)(50466002)(83072002)(4396001)(85852003)(87936001)(74662001)(31966008)(6806004)(23726002)(83322001)(84676001)(19580405001)(44976005)(92566001)(92726001)(74502001)(68736004)(19580395003)(76176999)(81542001)(46406003)(81342001)(50986999)(33716001)(83506001)(86362001)(575784001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB259;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 12:36:13PM +0200, Antoine Tenart wrote:
> Add a USB2 ChipIdea driver for ci13xxx, with optional PHY, clock
> and DMA mask, to support USB2 ChipIdea controllers that don't need
> specific functions.
> 
> Tested on the Marvell Berlin SoCs USB controllers.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  drivers/usb/chipidea/Makefile       |   1 +
>  drivers/usb/chipidea/ci_hdrc_usb2.c | 137 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 138 insertions(+)
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
> index 000000000000..1ef0db79505a
> --- /dev/null
> +++ b/drivers/usb/chipidea/ci_hdrc_usb2.c
> @@ -0,0 +1,137 @@
> +/*
> + * Copyright (C) 2014 Marvell Technology Group Ltd.
> + *
> + * Antoine Tenart <antoine.tenart@free-electrons.com>
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
> +};
> +
> +static int ci_hdrc_usb2_dt_probe(struct device *dev,
> +				 struct ci_hdrc_platform_data *ci_pdata)
> +{
> +	ci_pdata->phy = of_phy_get(dev->of_node, 0);
> +	if (IS_ERR(ci_pdata->phy)) {
> +		if (PTR_ERR(ci_pdata->phy) == -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +
> +		/* PHY is optional */
> +		ci_pdata->phy = NULL;
> +	}
> +
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
> +	priv->clk = devm_clk_get(dev, NULL);
> +	if (!IS_ERR(priv->clk)) {
> +		ret = clk_prepare_enable(priv->clk);
> +		if (ret) {
> +			dev_err(dev, "failed to enable the clock: %d\n", ret);
> +			return ret;
> +		}
> +	}
> +
> +	if (dev->of_node) {
> +		ret = ci_hdrc_usb2_dt_probe(dev, ci_pdata);
> +		if (ret)
> +			goto clk_err;
> +	} else {
> +		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> +		if (ret)
> +			goto clk_err;
> +	}
> +
> +	ci_pdata->name = dev_name(&pdev->dev);
> +
> +	priv->ci_pdev = ci_hdrc_add_device(dev, pdev->resource,
> +					   pdev->num_resources, ci_pdata);
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
> +MODULE_AUTHOR("Antoine Tenart <antoine.tenart@free-electrons.com>");
> +MODULE_LICENSE("GPL");
> -- 
> 1.9.1
> 

compile error:

/home/peter/work/projects/usb/drivers/usb/chipidea/ci_hdrc_usb2.c: In function 'ci_hdrc_usb2_dt_probe':
/home/peter/work/projects/usb/drivers/usb/chipidea/ci_hdrc_usb2.c:30:2: error: implicit declaration of function 'of_phy_get' [-Werror=implicit-function-declaration]
/home/peter/work/projects/usb/drivers/usb/chipidea/ci_hdrc_usb2.c:30:16: warning: assignment makes pointer from integer without a cast [enabled by default]

-- 
Best Regards,
Peter Chen
