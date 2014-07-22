Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaGVCWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:22:53 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:53285
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752084AbaGVCWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:22:51 -0400
Date: Tue, 22 Jul 2014 10:22:33 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <peter.chen@freescale.com>, <s.hauer@pengutronix.de>,
        <b35083@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] ARM: dts: vf610: add USB PHY and controller
Message-ID: <20140722022232.GR8537@dragon>
References: <cover.1405702442.git.stefan@agner.ch>
 <839af70e8acf139bc0f7bbdb4dd68dd146b5d6a8.1405702442.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <839af70e8acf139bc0f7bbdb4dd68dd146b5d6a8.1405702442.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(52314003)(24454002)(199002)(189002)(51704005)(81342001)(83072002)(76482001)(83506001)(69596002)(102836001)(33716001)(46102001)(68736004)(33656002)(85306003)(57986006)(50986999)(105606002)(54356999)(85852003)(77982001)(97756001)(80022001)(4396001)(47776003)(31966008)(46406003)(6806004)(19580395003)(20776003)(97736001)(19580405001)(50466002)(74662001)(64706001)(83322001)(79102001)(26826002)(104016003)(86362001)(81156004)(92566001)(95666004)(23726002)(76176999)(87936001)(107046002)(81542001)(74502001)(92726001)(21056001)(99396002)(84676001)(44976005)(110136001)(106466001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB472;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 07:01:37PM +0200, Stefan Agner wrote:
> This adds USB PHY and USB controller nodes. Vybrid SoCs have two
> independent USB cores which each supports DR (dual role). However,
> real OTG is not supported since the OTG ID pin is not available.
> 
> The PHYs are located within the anadig register range, hence we need
> to change the length of the anadig registers.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  arch/arm/boot/dts/vf610.dtsi | 46 +++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 43 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> index 6a6190c..f6c3f02 100644
> --- a/arch/arm/boot/dts/vf610.dtsi
> +++ b/arch/arm/boot/dts/vf610.dtsi
> @@ -25,6 +25,8 @@
>  		gpio2 = &gpio3;
>  		gpio3 = &gpio4;
>  		gpio4 = &gpio5;
> +		usbphy0 = &usbphy0;
> +		usbphy1 = &usbphy1;
>  	};
>  
>  	cpus {
> @@ -285,9 +287,25 @@
>  				gpio-ranges = <&iomuxc 0 128 7>;
>  			};
>  
> -			anatop@40050000 {
> -				compatible = "fsl,vf610-anatop";
> -				reg = <0x40050000 0x1000>;
> +			anatop: anatop@40050000 {
> +				compatible = "fsl,vf610-anatop", "syscon";
> +				reg = <0x40050000 0x400>;
> +			};
> +
> +			usbphy0: usbphy@40050800 {
> +				compatible = "fsl,vf610-usbphy", "fsl,imx23-usbphy";

Since phy driver will match "fsl,vf610-usbphy" anyway, we do not need
"fsl,imx23-usbphy" here.

> +				reg = <0x40050800 0x400>;
> +				interrupts = <0 50 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&clks VF610_CLK_USBPHY0>;
> +				fsl,anatop = <&anatop>;
> +			};
> +
> +			usbphy1: usbphy@40050c00 {
> +				compatible = "fsl,vf610-usbphy", "fsl,imx23-usbphy";
> +				reg = <0x40050c00 0x400>;
> +				interrupts = <0 51 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&clks VF610_CLK_USBPHY1>;
> +				fsl,anatop = <&anatop>;
>  			};
>  
>  			i2c0: i2c@40066000 {
> @@ -309,6 +327,18 @@
>  				reg = <0x4006b000 0x1000>;
>  				#clock-cells = <1>;
>  			};
> +
> +			usbdev0: usb@40034000 {
> +				compatible = "fsl,imx6q-usb", "fsl,imx27-usb";

It doesn't really make any sense to have "fsl,imx6q-usb" here.  The
following one should be less confusing.

	compatible = "fsl,vf610-usb", "fsl,imx27-usb";

Shawn

> +				reg = <0x40034000 0x800>;
> +				interrupts = <0 75 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&clks VF610_CLK_USBC0>;
> +				fsl,usbphy = <&usbphy0>;
> +				dr_mode = "peripheral";
> +				status = "disabled";
> +			};
> +
> +
>  		};
>  
>  		aips1: aips-bus@40080000 {
> @@ -371,6 +401,16 @@
>  				status = "disabled";
>  			};
>  
> +			usbh1: usb@400b4000 {
> +				compatible = "fsl,imx6q-usb", "fsl,imx27-usb";
> +				reg = <0x400b4000 0x800>;
> +				interrupts = <0 76 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&clks VF610_CLK_USBC1>;
> +				fsl,usbphy = <&usbphy1>;
> +				dr_mode = "host";
> +				status = "disabled";
> +			};
> +
>  			ftm: ftm@400b8000 {
>  				compatible = "fsl,ftm-timer";
>  				reg = <0x400b8000 0x1000 0x400b9000 0x1000>;
> -- 
> 2.0.1
> 
