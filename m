Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab3JRHYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 03:24:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58914 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab3JRHYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 03:24:30 -0400
Message-ID: <5260E21F.8060001@ti.com>
Date: Fri, 18 Oct 2013 10:24:15 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: <tony@atomide.com>, <kishon@ti.com>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <rob@landley.net>, <ijc+devicetree@hellion.org.uk>,
        <swarren@wwwdotorg.org>, <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>
Subject: Re: [PATCH v2] usb: phy: omap: Add omap-control Support for AM437x
References: <1381831334-8840-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1381831334-8840-1-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 01:02 PM, George Cherian wrote:
> This adds omap control module support for USBSS in AM437x SoC.
> Update DT binding information to reflect these changes.
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>

Acked-by: Roger Quadros <rogerq@ti.com>

> ---
> Changes from v1:
> 	Make ON and OFF operations symmetric.
> 
>  Documentation/devicetree/bindings/usb/omap-usb.txt |  2 ++
>  drivers/usb/phy/phy-omap-control.c                 | 19 +++++++++++++++++++
>  include/linux/usb/omap_control_usb.h               |  6 ++++++
>  3 files changed, 27 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
> index 090e5e2..c495135 100644
> --- a/Documentation/devicetree/bindings/usb/omap-usb.txt
> +++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
> @@ -87,6 +87,8 @@ Required properties:
>  			e.g. USB3 PHY and SATA PHY on OMAP5.
>   "ti,control-phy-dra7usb2" - if it has power down register like USB2 PHY on
>  			DRA7 platform.
> + "ti,control-phy-am437usb2" - if it has power down register like USB2 PHY on
> +			AM437 platform.
>   - reg : Address and length of the register set for the device. It contains
>     the address of "otghs_control" for control-phy-otghs or "power" register
>     for other types.
> diff --git a/drivers/usb/phy/phy-omap-control.c b/drivers/usb/phy/phy-omap-control.c
> index 09c5ace..e725318 100644
> --- a/drivers/usb/phy/phy-omap-control.c
> +++ b/drivers/usb/phy/phy-omap-control.c
> @@ -84,6 +84,20 @@ void omap_control_usb_phy_power(struct device *dev, int on)
>  		else
>  			val |= OMAP_CTRL_USB2_PHY_PD;
>  		break;
> +
> +	case OMAP_CTRL_TYPE_AM437USB2:
> +		if (on) {
> +			val &= ~(AM437X_CTRL_USB2_PHY_PD |
> +					AM437X_CTRL_USB2_OTG_PD);
> +			val |= (AM437X_CTRL_USB2_OTGVDET_EN |
> +					AM437X_CTRL_USB2_OTGSESSEND_EN);
> +		} else {
> +			val &= ~(AM437X_CTRL_USB2_OTGVDET_EN |
> +					AM437X_CTRL_USB2_OTGSESSEND_EN);
> +			val |= (AM437X_CTRL_USB2_PHY_PD |
> +					 AM437X_CTRL_USB2_OTG_PD);
> +		}
> +		break;
>  	default:
>  		dev_err(dev, "%s: type %d not recognized\n",
>  					__func__, control_usb->type);
> @@ -197,6 +211,7 @@ static const enum omap_control_usb_type otghs_data = OMAP_CTRL_TYPE_OTGHS;
>  static const enum omap_control_usb_type usb2_data = OMAP_CTRL_TYPE_USB2;
>  static const enum omap_control_usb_type pipe3_data = OMAP_CTRL_TYPE_PIPE3;
>  static const enum omap_control_usb_type dra7usb2_data = OMAP_CTRL_TYPE_DRA7USB2;
> +static const enum omap_control_usb_type am437usb2_data = OMAP_CTRL_TYPE_AM437USB2;
>  
>  static const struct of_device_id omap_control_usb_id_table[] = {
>  	{
> @@ -215,6 +230,10 @@ static const struct of_device_id omap_control_usb_id_table[] = {
>  		.compatible = "ti,control-phy-dra7usb2",
>  		.data = &dra7usb2_data,
>  	},
> +	{
> +		.compatible = "ti,control-phy-am437usb2",
> +		.data = &am437usb2_data,
> +	},
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, omap_control_usb_id_table);
> diff --git a/include/linux/usb/omap_control_usb.h b/include/linux/usb/omap_control_usb.h
> index 596b019..69ae383 100644
> --- a/include/linux/usb/omap_control_usb.h
> +++ b/include/linux/usb/omap_control_usb.h
> @@ -24,6 +24,7 @@ enum omap_control_usb_type {
>  	OMAP_CTRL_TYPE_USB2,	/* USB2_PHY, power down in CONTROL_DEV_CONF */
>  	OMAP_CTRL_TYPE_PIPE3,	/* PIPE3 PHY, DPLL & seperate Rx/Tx power */
>  	OMAP_CTRL_TYPE_DRA7USB2, /* USB2 PHY, power and power_aux e.g. DRA7 */
> +	OMAP_CTRL_TYPE_AM437USB2, /* USB2 PHY, power e.g. AM437x */
>  };
>  
>  struct omap_control_usb {
> @@ -64,6 +65,11 @@ enum omap_control_usb_mode {
>  
>  #define OMAP_CTRL_USB2_PHY_PD		BIT(28)
>  
> +#define AM437X_CTRL_USB2_PHY_PD		BIT(0)
> +#define AM437X_CTRL_USB2_OTG_PD		BIT(1)
> +#define AM437X_CTRL_USB2_OTGVDET_EN	BIT(19)
> +#define AM437X_CTRL_USB2_OTGSESSEND_EN	BIT(20)
> +
>  #if IS_ENABLED(CONFIG_OMAP_CONTROL_USB)
>  extern void omap_control_usb_phy_power(struct device *dev, int on);
>  extern void omap_control_usb_set_mode(struct device *dev,
> 

