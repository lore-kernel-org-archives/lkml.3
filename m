Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaF0E4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 00:56:00 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:6464
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750729AbaF0Ez7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 00:55:59 -0400
Date: Fri, 27 Jun 2014 11:25:07 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: <sebastian.hesselbarth@gmail.com>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 07/12] usb: chipidea: add a generic driver
Message-ID: <20140627032506.GA18039@shlinux1.ap.freescale.net>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
 <1403606121-6368-8-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403606121-6368-8-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(24454002)(189002)(199002)(85852003)(102836001)(83072002)(33656002)(97736001)(92726001)(87936001)(92566001)(77982001)(68736004)(575784001)(69596002)(84676001)(86362001)(83506001)(46102001)(19580395003)(26826002)(19580405001)(83322001)(6806004)(44976005)(74502001)(31966008)(76482001)(79102001)(85306003)(50466002)(99396002)(76176999)(54356999)(74662001)(50986999)(21056001)(106466001)(81542001)(81156004)(81342001)(107046002)(95666004)(20776003)(47776003)(64706001)(105606002)(104016002)(80022001)(23756003)(4396001)(41533002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB090;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0255DF69B9
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 12:35:16PM +0200, Antoine Ténart wrote:
> Add a generic ChipIdea driver, with optional PHY and clock, to support
> ChipIdea controllers that doesn't need specific functions.
> 
> Needed for the Marvell Berlin SoCs SUB controllers.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  drivers/usb/chipidea/Makefile          |   1 +
>  drivers/usb/chipidea/ci_hdrc_generic.c | 108 +++++++++++++++++++++++++++++++++
>  2 files changed, 109 insertions(+)
>  create mode 100644 drivers/usb/chipidea/ci_hdrc_generic.c
> 
> diff --git a/drivers/usb/chipidea/Makefile b/drivers/usb/chipidea/Makefile
> index 2f099c7df7b5..c705f0fe7a00 100644
> --- a/drivers/usb/chipidea/Makefile
> +++ b/drivers/usb/chipidea/Makefile
> @@ -20,4 +20,5 @@ endif
>  
>  ifneq ($(CONFIG_OF),)
>  	obj-$(CONFIG_USB_CHIPIDEA)	+= usbmisc_imx.o ci_hdrc_imx.o
> +	obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_generic.o
>  endif

As a generic driver, you may need to support both dt and non-dt
solution.

> diff --git a/drivers/usb/chipidea/ci_hdrc_generic.c b/drivers/usb/chipidea/ci_hdrc_generic.c
> new file mode 100644
> index 000000000000..27520710a1f7
> --- /dev/null
> +++ b/drivers/usb/chipidea/ci_hdrc_generic.c
> @@ -0,0 +1,108 @@
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
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/usb/chipidea.h>
> +#include <linux/usb/hcd.h>
> +#include <linux/usb/ulpi.h>
> +
> +#include "ci.h"
> +
> +struct ci_hdrc_generic_priv {
> +	struct platform_device	*ci_pdev;
> +	struct clk		*clk;
> +};
> +
> +static int ci_hdrc_generic_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct ci_hdrc_generic_priv *priv;
> +	struct ci_hdrc_platform_data ci_pdata = {
> +		.name		= "ci_hdrc",

How about this using dev_name(&pdev->dev) for name?

> +		.capoffset	= DEF_CAPOFFSET,
> +		.flags		= CI_HDRC_REQUIRE_TRANSCEIVER |
> +				  CI_HDRC_DISABLE_STREAMING,
> +	};
> +	int ret;
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
> +	ci_pdata.phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
> +	if (IS_ERR(ci_pdata.phy))
> +		/* PHY is optional */
> +		ci_pdata.phy = NULL;
> +
> +	priv->ci_pdev = ci_hdrc_add_device(dev, pdev->resource,
> +				     pdev->num_resources, &ci_pdata);
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
> +	clk_disable_unprepare(priv->clk);

You may need to add "if (!IS_ERR(priv->clk))"

> +	return ret;
> +}
> +
> +static int ci_hdrc_generic_remove(struct platform_device *pdev)
> +{
> +	struct ci_hdrc_generic_priv *priv = platform_get_drvdata(pdev);
> +
> +	pm_runtime_disable(&pdev->dev);
> +	ci_hdrc_remove_device(priv->ci_pdev);
> +	clk_disable_unprepare(priv->clk);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id ci_hdrc_generic_of_match[] = {
> +	{ .compatible = "chipidea-usb" },
> +	{ }
> +};

Even as a generic driver, you can also use your own compatible string.

> +MODULE_DEVICE_TABLE(of, ci_hdrc_generic_of_match);
> +
> +static struct platform_driver ci_hdrc_generic_driver = {
> +	.probe	= ci_hdrc_generic_probe,
> +	.remove	= ci_hdrc_generic_remove,
> +	.driver	= {
> +		.name		= "chipidea-usb",
> +		.owner		= THIS_MODULE,
> +		.of_match_table	= ci_hdrc_generic_of_match,
> +	},
> +};
> +module_platform_driver(ci_hdrc_generic_driver);
> +
> +MODULE_DESCRIPTION("Generic ChipIdea HDRC USB binding");
> +MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
> +MODULE_LICENSE("GPL");
> -- 
> 1.9.1
> 

-- 

Best Regards,
Peter Chen
