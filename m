Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964894AbaKNCXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 21:23:40 -0500
Received: from mail-bl2on0117.outbound.protection.outlook.com ([65.55.169.117]:20414
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933518AbaKNCXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 21:23:38 -0500
Date: Fri, 14 Nov 2014 09:16:55 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] usb: chipidea: add a core function to setup
 ci_hdrc_platform_data
Message-ID: <20141114011651.GA28697@shlinux2>
References: <1414669007-9850-1-git-send-email-antoine.tenart@free-electrons.com>
 <1414669007-9850-2-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1414669007-9850-2-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(199003)(51704005)(46102003)(83506001)(110136001)(106466001)(104016003)(120916001)(77156002)(62966003)(99396003)(97736003)(47776003)(54356999)(50986999)(76176999)(46406003)(64706001)(20776003)(33716001)(31966008)(84676001)(21056001)(33656002)(575784001)(87936001)(86362001)(6806004)(92726001)(68736004)(107046002)(19580395003)(97756001)(50466002)(92566001)(23726002)(105606002)(19580405001)(102836001)(4396001)(44976005)(95666004);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0636;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0636;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0636;
X-Forefront-PRVS: 03950F25EC
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0636;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0684;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 12:36:42PM +0100, Antoine Tenart wrote:
> Add a function into the chipidea core to help drivers setup the internal
> ci_hdrc_platform_data structure. This helps not duplicating common code.
> 
> The ci_hdrc_get_platdata function only setup non filled members of the
> structure so that is is possible to give an already filled one. This is
> what the ci_pdata_default parameter is for.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  drivers/usb/chipidea/core.c  | 129 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/usb/chipidea.h |   2 +
>  2 files changed, 131 insertions(+)
> 
> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> index ba0ac2723098..0ad55c10a903 100644
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
> @@ -535,6 +535,135 @@ static int ci_get_platdata(struct device *dev,
>  	return 0;
>  }
>  
> +/*
> + * Getting a PHY or an USB PHY is optional:
> + * If no PHY or USB PHY is found, or if their subsystems aren't enabled,
> + * PHY and/or USB PHY will be set to NULL. Otherwise returns an error.
> + */
> +static int ci_hdrc_get_phy(struct device *dev,
> +			   struct ci_hdrc_platform_data *ci_pdata)
> +{
> +	ci_pdata->phy = devm_phy_get(dev, "usb");
> +	ci_pdata->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> +
> +	if (PTR_ERR(ci_pdata->phy) == -EPROBE_DEFER ||
> +		PTR_ERR(ci_pdata->usb_phy) == -EPROBE_DEFER)
> +		return -EPROBE_DEFER;
> +
> +	if (IS_ERR(ci_pdata->phy)) {
> +		if (PTR_ERR(ci_pdata->phy) == -ENOSYS ||
> +				PTR_ERR(ci_pdata->phy) == -ENODEV) {
> +			ci_pdata->phy = NULL;
> +		} else {
> +			dev_err(dev, "Could not get PHY: %ld\n",
> +					PTR_ERR(ci_pdata->phy));
> +			return PTR_ERR(ci_pdata->phy);
> +		}
> +	}
> +
> +	if (IS_ERR(ci_pdata->usb_phy)) {
> +		if (PTR_ERR(ci_pdata->usb_phy) == -ENXIO ||
> +				PTR_ERR(ci_pdata->usb_phy) == -ENODEV) {
> +			ci_pdata->usb_phy = NULL;
> +		} else {
> +			dev_err(dev, "Could not get USB PHY: %ld\n",
> +					PTR_ERR(ci_pdata->usb_phy));
> +			return PTR_ERR(ci_pdata->usb_phy);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int ci_hdrc_get_usb_phy_mode(struct device *dev,
> +				    struct ci_hdrc_platform_data *ci_pdata)
> +{
> +	if (!ci_pdata->phy_mode)
> +		ci_pdata->phy_mode = of_usb_get_phy_mode(dev->of_node);
> +
> +	if (!ci_pdata->dr_mode)
> +		ci_pdata->dr_mode = of_usb_get_dr_mode(dev->of_node);
> +
> +	if (of_usb_get_maximum_speed(dev->of_node) == USB_SPEED_FULL)
> +		ci_pdata->flags |= CI_HDRC_FORCE_FULLSPEED;
> +
> +	return 0;
> +}
> +

The things in above function are no relationship.

> +/*
> + * Getting a regulator is optional:
> + * If no regulator is found, or if the regulator subsystem isn't enabled,
> + * the regulator will be set to NULL. Otherwise returns an error.
> + */
> +static int ci_hdrc_get_regulator(struct device *dev,
> +				 struct ci_hdrc_platform_data *ci_pdata)
> +{
> +	ci_pdata->reg_vbus = devm_regulator_get(dev, "vbus");
> +
> +	if (IS_ERR(ci_pdata->reg_vbus)) {
> +		if (PTR_ERR(ci_pdata->reg_vbus) == -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +
> +		if (PTR_ERR(ci_pdata->reg_vbus) == -ENODEV) {
> +			ci_pdata->reg_vbus = NULL;
> +		} else {
> +			dev_err(dev, "Could not get regulator for vbus: %ld\n",
> +					PTR_ERR(ci_pdata->reg_vbus));
> +			return PTR_ERR(ci_pdata->reg_vbus);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +struct ci_hdrc_platform_data *ci_hdrc_get_platdata(struct device *dev,
> +			struct ci_hdrc_platform_data *ci_pdata_default)
> +{
> +	struct ci_hdrc_platform_data *ci_pdata;
> +	int ret;
> +
> +	if (!ci_pdata_default) {
> +		ci_pdata = devm_kzalloc(dev, sizeof(*ci_pdata), GFP_KERNEL);
> +		if (!ci_pdata)
> +			return ERR_PTR(-ENOMEM);
> +	} else {
> +		ci_pdata = ci_pdata_default;
> +	}
> +
> +	if (!ci_pdata->name)
> +		ci_pdata->name = dev_name(dev);
> +
> +	if (!ci_pdata->phy && !ci_pdata->usb_phy) {
> +		ret = ci_hdrc_get_phy(dev, ci_pdata);
> +		if (ret)
> +			return ERR_PTR(ret);
> +	}
> +
> +	if (ci_pdata->usb_phy) {
> +		ret = ci_hdrc_get_usb_phy_mode(dev, ci_pdata);
> +		if (ret)
> +			return ERR_PTR(ret);
> +	}
> +
> +	if (ci_pdata->dr_mode == USB_DR_MODE_UNKNOWN)
> +		ci_pdata->dr_mode = USB_DR_MODE_OTG;
> +
> +	if (ci_pdata->dr_mode != USB_DR_MODE_PERIPHERAL) {
> +		if (!ci_pdata->reg_vbus) {
> +			ret = ci_hdrc_get_regulator(dev, ci_pdata);
> +			if (ret)
> +				return ERR_PTR(ret);
> +		}
> +
> +		if (!ci_pdata->tpl_support)
> +			ci_pdata->tpl_support =
> +				of_usb_host_tpl_support(dev->of_node);
> +	}
> +
> +	return ci_pdata;
> +}
> +EXPORT_SYMBOL_GPL(ci_hdrc_get_platdata);
> +
>  static DEFINE_IDA(ci_ida);
>  
>  struct platform_device *ci_hdrc_add_device(struct device *dev,
> diff --git a/include/linux/usb/chipidea.h b/include/linux/usb/chipidea.h
> index c01bf4ea27b9..7bb7520da59b 100644
> --- a/include/linux/usb/chipidea.h
> +++ b/include/linux/usb/chipidea.h
> @@ -39,6 +39,8 @@ struct ci_hdrc_platform_data {
>  /* Default offset of capability registers */
>  #define DEF_CAPOFFSET		0x100
>  
> +struct ci_hdrc_platform_data *ci_hdrc_get_platdata(struct device *dev,
> +			struct ci_hdrc_platform_data *ci_pdata_default);
>  /* Add ci hdrc device */
>  struct platform_device *ci_hdrc_add_device(struct device *dev,
>  			struct resource *res, int nres,
> -- 
> 2.1.0
> 

Ok, Antoine, I find this patch set may not have many benefits due to
below reasons:
- There is already function ci_get_platdata to do the similar things
- If the PHY can't get from the DT, it will use devm_phy_get or
devm_usb_get_phy to get, this code has already in core.

I am apologized that I wanted you to do a patch for moving get PHY
operation to core, it doesn't have many benefits currently
- For non-dt user, the phy get function has already in core like I said
above.
- For dt generic phy user, it uses of_phy_get, the second parameter
con_id may be different for platforms.
- For dt usb phy, it uses devm_usb_get_phy_by_phandle, the second
parameters phandle may be different for platforms.

So, please rebase my next tree which your generic phy patch set has
already in, and send your generic usb2 chipidea patch base on it.

-- 

Best Regards,
Peter Chen
