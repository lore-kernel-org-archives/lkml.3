Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaGVB7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 21:59:40 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:20741
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751139AbaGVB7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 21:59:39 -0400
Date: Tue, 22 Jul 2014 09:52:11 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>,
        <b35083@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] chipidea: usbmisc_imx: Add USB support for VF610
 SoCs
Message-ID: <20140722015210.GB10650@shlinux1.ap.freescale.net>
References: <cover.1405702442.git.stefan@agner.ch>
 <e776c8a6ea0d919edb5e3ce1bf0697b23f09f028.1405702442.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e776c8a6ea0d919edb5e3ce1bf0697b23f09f028.1405702442.git.stefan@agner.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6029001)(6009001)(24454002)(478694002)(189002)(51704005)(199002)(21056001)(44976005)(87936001)(33656002)(19580405001)(81156004)(80022001)(77982001)(6806004)(83072002)(76482001)(104016003)(64706001)(74502001)(86362001)(68736004)(102836001)(31966008)(20776003)(92726001)(46102001)(19580395003)(85852003)(97756001)(97736001)(83506001)(110136001)(79102001)(76176999)(84676001)(83322001)(50986999)(105606002)(81342001)(50466002)(81542001)(85306003)(4396001)(46406003)(69596002)(47776003)(92566001)(99396002)(106466001)(74662001)(23726002)(107046002)(26826002)(95666004)(54356999);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB344;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 07:01:40PM +0200, Stefan Agner wrote:
> This adds Vybrid VF610 SoC support. The IP is very similar to i.MX6,
> however the non-core registers are spread in two different register
> areas. Hence we support multiple registers which are addressed by
> the index of usbmisc.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
> I tried first to create two usbmisc nodes and hoped it would instanciate
> the driver twice, however, the driver currently only supports one instance.
> In an short attempt to add support for that, I realized that since the
> data structure holding the information for each instance is within the
> driver ci_hdrc_imx. For Vybrid two instances would make much more sense,
> however, a i.MX6Q shares all the non-core registers in one register area,
> hence only one driver can map this area. I ended up with this multiple
> registers solution, altough for the Vybrid multiple instances would
> probably make more sense. Any thoughts on this?
> 

I prefer rename current usbmisc_imx as usbmisc_mix_v1 and create the
new usbmisc_imx_v2 for multiple instances case.

Peter

>  drivers/usb/chipidea/usbmisc_imx.c | 76 +++++++++++++++++++++++++++-----------
>  1 file changed, 54 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/usb/chipidea/usbmisc_imx.c b/drivers/usb/chipidea/usbmisc_imx.c
> index 85293b8..61c2350 100644
> --- a/drivers/usb/chipidea/usbmisc_imx.c
> +++ b/drivers/usb/chipidea/usbmisc_imx.c
> @@ -57,6 +57,10 @@
>  
>  #define MX6_BM_OVER_CUR_DIS		BIT(7)
>  
> +#define VF610_OVER_CUR_DIS		BIT(7)
> +
> +#define MAX_BASE_ADDR			2
> +
>  struct usbmisc_ops {
>  	/* It's called once when probe a usb device */
>  	int (*init)(struct imx_usbmisc_data *data);
> @@ -65,7 +69,7 @@ struct usbmisc_ops {
>  };
>  
>  struct imx_usbmisc {
> -	void __iomem *base;
> +	void __iomem *base[MAX_BASE_ADDR];
>  	spinlock_t lock;
>  	struct clk *clk;
>  	const struct usbmisc_ops *ops;
> @@ -84,20 +88,20 @@ static int usbmisc_imx25_init(struct imx_usbmisc_data *data)
>  	spin_lock_irqsave(&usbmisc->lock, flags);
>  	switch (data->index) {
>  	case 0:
> -		val = readl(usbmisc->base);
> +		val = readl(usbmisc->base[0]);
>  		val &= ~(MX25_OTG_SIC_MASK | MX25_OTG_PP_BIT);
>  		val |= (MX25_EHCI_INTERFACE_DIFF_UNI & MX25_EHCI_INTERFACE_MASK) << MX25_OTG_SIC_SHIFT;
>  		val |= (MX25_OTG_PM_BIT | MX25_OTG_OCPOL_BIT);
> -		writel(val, usbmisc->base);
> +		writel(val, usbmisc->base[0]);
>  		break;
>  	case 1:
> -		val = readl(usbmisc->base);
> +		val = readl(usbmisc->base[0]);
>  		val &= ~(MX25_H1_SIC_MASK | MX25_H1_PP_BIT |  MX25_H1_IPPUE_UP_BIT);
>  		val |= (MX25_EHCI_INTERFACE_SINGLE_UNI & MX25_EHCI_INTERFACE_MASK) << MX25_H1_SIC_SHIFT;
>  		val |= (MX25_H1_PM_BIT | MX25_H1_OCPOL_BIT | MX25_H1_TLL_BIT |
>  			MX25_H1_USBTE_BIT | MX25_H1_IPPUE_DOWN_BIT);
>  
> -		writel(val, usbmisc->base);
> +		writel(val, usbmisc->base[0]);
>  
>  		break;
>  	}
> @@ -115,7 +119,7 @@ static int usbmisc_imx25_post(struct imx_usbmisc_data *data)
>  	if (data->index > 2)
>  		return -EINVAL;
>  
> -	reg = usbmisc->base + MX25_USB_PHY_CTRL_OFFSET;
> +	reg = usbmisc->base[0] + MX25_USB_PHY_CTRL_OFFSET;
>  
>  	if (data->evdo) {
>  		spin_lock_irqsave(&usbmisc->lock, flags);
> @@ -149,10 +153,10 @@ static int usbmisc_imx27_init(struct imx_usbmisc_data *data)
>  
>  	spin_lock_irqsave(&usbmisc->lock, flags);
>  	if (data->disable_oc)
> -		val = readl(usbmisc->base) | val;
> +		val = readl(usbmisc->base[0]) | val;
>  	else
> -		val = readl(usbmisc->base) & ~val;
> -	writel(val, usbmisc->base);
> +		val = readl(usbmisc->base[0]) & ~val;
> +	writel(val, usbmisc->base[0]);
>  	spin_unlock_irqrestore(&usbmisc->lock, flags);
>  
>  	return 0;
> @@ -168,29 +172,29 @@ static int usbmisc_imx53_init(struct imx_usbmisc_data *data)
>  		return -EINVAL;
>  
>  	/* Select a 24 MHz reference clock for the PHY  */
> -	reg = usbmisc->base + MX53_USB_OTG_PHY_CTRL_1_OFFSET;
> +	reg = usbmisc->base[0] + MX53_USB_OTG_PHY_CTRL_1_OFFSET;
>  	val = readl(reg);
>  	val &= ~MX53_USB_PHYCTRL1_PLLDIV_MASK;
>  	val |= MX53_USB_PLL_DIV_24_MHZ;
> -	writel(val, usbmisc->base + MX53_USB_OTG_PHY_CTRL_1_OFFSET);
> +	writel(val, usbmisc->base[0] + MX53_USB_OTG_PHY_CTRL_1_OFFSET);
>  
>  	if (data->disable_oc) {
>  		spin_lock_irqsave(&usbmisc->lock, flags);
>  		switch (data->index) {
>  		case 0:
> -			reg = usbmisc->base + MX53_USB_OTG_PHY_CTRL_0_OFFSET;
> +			reg = usbmisc->base[0] + MX53_USB_OTG_PHY_CTRL_0_OFFSET;
>  			val = readl(reg) | MX53_BM_OVER_CUR_DIS_OTG;
>  			break;
>  		case 1:
> -			reg = usbmisc->base + MX53_USB_OTG_PHY_CTRL_0_OFFSET;
> +			reg = usbmisc->base[0] + MX53_USB_OTG_PHY_CTRL_0_OFFSET;
>  			val = readl(reg) | MX53_BM_OVER_CUR_DIS_H1;
>  			break;
>  		case 2:
> -			reg = usbmisc->base + MX53_USB_UH2_CTRL_OFFSET;
> +			reg = usbmisc->base[0] + MX53_USB_UH2_CTRL_OFFSET;
>  			val = readl(reg) | MX53_BM_OVER_CUR_DIS_UHx;
>  			break;
>  		case 3:
> -			reg = usbmisc->base + MX53_USB_UH3_CTRL_OFFSET;
> +			reg = usbmisc->base[0] + MX53_USB_UH3_CTRL_OFFSET;
>  			val = readl(reg) | MX53_BM_OVER_CUR_DIS_UHx;
>  			break;
>  		}
> @@ -212,15 +216,31 @@ static int usbmisc_imx6q_init(struct imx_usbmisc_data *data)
>  
>  	if (data->disable_oc) {
>  		spin_lock_irqsave(&usbmisc->lock, flags);
> -		reg = readl(usbmisc->base + data->index * 4);
> +		reg = readl(usbmisc->base[0] + data->index * 4);
>  		writel(reg | MX6_BM_OVER_CUR_DIS,
> -			usbmisc->base + data->index * 4);
> +			usbmisc->base[0] + data->index * 4);
>  		spin_unlock_irqrestore(&usbmisc->lock, flags);
>  	}
>  
>  	return 0;
>  }
>  
> +static int usbmisc_vf610_init(struct imx_usbmisc_data *data)
> +{
> +	u32 reg;
> +
> +	if (data->index >= 2)
> +		return -EINVAL;
> +
> +	if (data->disable_oc) {
> +		reg = readl(usbmisc->base[data->index]);
> +		writel(reg | VF610_OVER_CUR_DIS,
> +			usbmisc->base[data->index]);
> +	}
> +
> +	return 0;
> +}
> +
>  static const struct usbmisc_ops imx25_usbmisc_ops = {
>  	.init = usbmisc_imx25_init,
>  	.post = usbmisc_imx25_post,
> @@ -238,6 +258,10 @@ static const struct usbmisc_ops imx6q_usbmisc_ops = {
>  	.init = usbmisc_imx6q_init,
>  };
>  
> +static const struct usbmisc_ops vf610_usbmisc_ops = {
> +	.init = usbmisc_vf610_init,
> +};
> +
>  int imx_usbmisc_init(struct imx_usbmisc_data *data)
>  {
>  	if (!usbmisc)
> @@ -283,6 +307,10 @@ static const struct of_device_id usbmisc_imx_dt_ids[] = {
>  		.compatible = "fsl,imx6q-usbmisc",
>  		.data = &imx6q_usbmisc_ops,
>  	},
> +	{
> +		.compatible = "fsl,vf610-usbmisc",
> +		.data = &vf610_usbmisc_ops,
> +	},
>  	{ /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(of, usbmisc_imx_dt_ids);
> @@ -291,7 +319,7 @@ static int usbmisc_imx_probe(struct platform_device *pdev)
>  {
>  	struct resource	*res;
>  	struct imx_usbmisc *data;
> -	int ret;
> +	int ret, i;
>  	struct of_device_id *tmp_dev;
>  
>  	if (usbmisc)
> @@ -303,10 +331,14 @@ static int usbmisc_imx_probe(struct platform_device *pdev)
>  
>  	spin_lock_init(&data->lock);
>  
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	data->base = devm_ioremap_resource(&pdev->dev, res);
> -	if (IS_ERR(data->base))
> -		return PTR_ERR(data->base);
> +	for (i = 0; i < MAX_BASE_ADDR; i++) {
> +		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
> +		data->base[i] = devm_ioremap_resource(&pdev->dev, res);
> +
> +		/* First base address is mandatory */
> +		if (IS_ERR(data->base) && !i)
> +			return PTR_ERR(data->base);
> +	}
>  
>  	data->clk = devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(data->clk)) {
> -- 
> 2.0.1
> 

-- 

Best Regards,
Peter Chen
