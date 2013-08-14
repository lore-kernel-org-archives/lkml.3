Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564Ab3HNIli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 04:41:38 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:43527 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759527Ab3HNIld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 04:41:33 -0400
Message-ID: <520B42B8.5080107@baylibre.com>
Date: Wed, 14 Aug 2013 10:41:28 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: balbi@ti.com, tony@atomide.com, kishon@ti.com, george.cherian@ti.com,
        dmurphy@ti.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] ARM: dts: omap4: update omap-control-usb nodes
References: <1375365915-21380-1-git-send-email-rogerq@ti.com> <1375365915-21380-7-git-send-email-rogerq@ti.com>
In-Reply-To: <1375365915-21380-7-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On 01/08/2013 16:05, Roger Quadros wrote:
> Split otghs_ctrl and USB2 PHY power down into separate
> omap-control-usb nodes. Update ti,mode property.

Nit: I guess you mean ti,type?

> CC: Benoit Cousson <benoit.cousson@linaro.org>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>   arch/arm/boot/dts/omap4.dtsi |   17 ++++++++++++-----
>   1 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> index 22d9f2b..9a6fa27 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -519,7 +519,7 @@
>   			usb2_phy: usb2phy@4a0ad080 {
>   				compatible = "ti,omap-usb2";
>   				reg = <0x4a0ad080 0x58>;
> -				ctrl-module = <&omap_control_usb>;
> +				ctrl-module = <&omap_control_usb2phy>;
>   			};
>   		};
>   
> @@ -643,11 +643,17 @@
>   			};
>   		};
>   
> -		omap_control_usb: omap-control-usb@4a002300 {
> +		omap_control_usb2phy: omap-control-usb@4a002300 {
>   			compatible = "ti,omap-control-usb";
> -			reg = <0x4a002300 0x4>,
> -			      <0x4a00233c 0x4>;
> -			reg-names = "control_dev_conf", "otghs_control";
> +			reg = <0x4a002300 0x4>;
> +			reg-names = "power";
> +			ti,type = <2>;

Now that we can use the C preprocessor, it will be nice to use a macro instead of the value.

TYPE1 - if it has otghs_control mailbox register (e.g. on OMAP4)
TYPE2 - if it has Power down bit in control_dev_conf register. e.g. USB2 PHY
TYPE3 - if it has DPLL and individual Rx & Tx power control. e.g. USB3 PHY or SATA PHY
TYPE4 - if it has both power down and power aux registers. e.g. USB2 PHY on DRA7

Well, assuming you can find macro names that can explain a little bit what the type is about :-)

That being said...
Do you really need to expose the type here? Maybe with just a set of different compatible string you can figure out in the driver what type we are talking about.
It is always better to minimize the amount of information we put in DT as soon as we can infer it from the compatible string.

So instead of using a generic "ti,omap-control-usb" string + "ti,type" you can potentially use several specific strings: ti,omap4-control-usb, ti,dra7-control-usb...
Since the DT gurus are recommending to use specific compatible string as much as possible, this is maybe a better approach.

Regards,
Benoit

