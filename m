Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaHBAga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 20:36:30 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:29813
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751008AbaHBAg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 20:36:28 -0400
Date: Sat, 2 Aug 2014 08:36:16 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>,
        <b35083@freescale.com>, <jingchang.lu@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/7] usb: phy: mxs: Add VF610 USB PHY support
Message-ID: <20140802003615.GA2833@peterchendt>
References: <cover.1406558450.git.stefan@agner.ch>
 <acb7c055ded38c74291d0f0d8d2fdca54a8b95f8.1406558450.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <acb7c055ded38c74291d0f0d8d2fdca54a8b95f8.1406558450.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(199002)(189002)(24454002)(4396001)(106466001)(54356999)(87936001)(95666004)(92566001)(104016003)(23726002)(107046002)(44976005)(6806004)(50986999)(92726001)(83506001)(85306004)(97756001)(80022001)(81542001)(20776003)(74662001)(19580405001)(46102001)(86362001)(46406003)(64706001)(77982001)(26826002)(76176999)(110136001)(69596002)(50466002)(33716001)(102836001)(31966008)(33656002)(76482001)(68736004)(81342001)(85852003)(105606002)(84676001)(83072002)(57986006)(21056001)(83322001)(99396002)(97736001)(47776003)(79102001)(19580395003)(81156004)(74502001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB469;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029174C036
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 04:57:29PM +0200, Stefan Agner wrote:
> This adds support for the USB PHY in Vybrid VF610. We assume that
> the disconnection without VBUS is also needed for Vybrid.
> 
> Tests showed, without MXS_PHY_NEED_IP_FIX, enumeration of devices
> behind a USB Hub fails with errors:
> 
> [  215.163507] usb usb1-port1: cannot reset (err = -32)
> [  215.170498] usb usb1-port1: cannot reset (err = -32)
> [  215.185120] usb usb1-port1: cannot reset (err = -32)
> [  215.191345] usb usb1-port1: cannot reset (err = -32)
> [  215.202487] usb usb1-port1: cannot reset (err = -32)
> [  215.207718] usb usb1-port1: Cannot enable. Maybe the USB cable is bad?
> [  215.219317] usb usb1-port1: unable to enumerate USB device
> 
> Hence we also enable the MXS_PHY_NEED_IP_FIX flag.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  Documentation/devicetree/bindings/usb/mxs-phy.txt | 1 +
>  drivers/usb/phy/phy-mxs-usb.c                     | 6 ++++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/usb/mxs-phy.txt b/Documentation/devicetree/bindings/usb/mxs-phy.txt
> index cef181a..fe3eed8 100644
> --- a/Documentation/devicetree/bindings/usb/mxs-phy.txt
> +++ b/Documentation/devicetree/bindings/usb/mxs-phy.txt
> @@ -5,6 +5,7 @@ Required properties:
>  	* "fsl,imx23-usbphy" for imx23 and imx28
>  	* "fsl,imx6q-usbphy" for imx6dq and imx6dl
>  	* "fsl,imx6sl-usbphy" for imx6sl
> +	* "fsl,vf610-usbphy" for Vybrid vf610
>    "fsl,imx23-usbphy" is still a fallback for other strings
>  - reg: Should contain registers location and length
>  - interrupts: Should contain phy interrupt
> diff --git a/drivers/usb/phy/phy-mxs-usb.c b/drivers/usb/phy/phy-mxs-usb.c
> index c42bdf0..8c2f23b 100644
> --- a/drivers/usb/phy/phy-mxs-usb.c
> +++ b/drivers/usb/phy/phy-mxs-usb.c
> @@ -125,10 +125,16 @@ static const struct mxs_phy_data imx6sl_phy_data = {
>  		MXS_PHY_NEED_IP_FIX,
>  };
>  
> +static const struct mxs_phy_data vf610_phy_data = {
> +	.flags = MXS_PHY_DISCONNECT_LINE_WITHOUT_VBUS |
> +		MXS_PHY_NEED_IP_FIX,
> +};
> +
>  static const struct of_device_id mxs_phy_dt_ids[] = {
>  	{ .compatible = "fsl,imx6sl-usbphy", .data = &imx6sl_phy_data, },
>  	{ .compatible = "fsl,imx6q-usbphy", .data = &imx6q_phy_data, },
>  	{ .compatible = "fsl,imx23-usbphy", .data = &imx23_phy_data, },
> +	{ .compatible = "fsl,vf610-usbphy", .data = &vf610_phy_data, },
>  	{ /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(of, mxs_phy_dt_ids);
> -- 
> 2.0.2
> 

Acked-by: Peter Chen <peter.chen@freescale.com>

-- 
Best Regards,
Peter Chen
