Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251Ab3GSNz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:55:58 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:40429 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757534Ab3GSNz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:55:56 -0400
Message-ID: <51E94571.8080805@cogentembedded.com>
Date: Fri, 19 Jul 2013 17:56:01 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: linux-usb@vger.kernel.org, balbi@ti.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org, kishon@ti.com,
        bigeasy@linutronix.de
Subject: Re: [PATCH v2 3/4] arm: dts: Add USB phy nodes for AM33XX
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com> <1374237277-17769-4-git-send-email-george.cherian@ti.com>
In-Reply-To: <1374237277-17769-4-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 19-07-2013 16:34, George Cherian wrote:

> Add phy nodes for AM33XX platform and split the musb nodes
> per instance.

> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   arch/arm/boot/dts/am33xx.dtsi | 68 +++++++++++++++++++++++++++++++++----------
>   1 file changed, 53 insertions(+), 15 deletions(-)

> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 8e1248f..e3890c4 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -326,21 +326,59 @@
>   			status = "disabled";
>   		};
>
> -		usb@47400000 {
> -			compatible = "ti,musb-am33xx";
> -			reg = <0x47400000 0x1000	/* usbss */
> -			       0x47401000 0x800		/* musb instance 0 */
> -			       0x47401800 0x800>;	/* musb instance 1 */
> -			interrupts = <17		/* usbss */
> -				      18		/* musb instance 0 */
> -				      19>;		/* musb instance 1 */
> -			multipoint = <1>;
> -			num-eps = <16>;
> -			ram-bits = <12>;
> -			port0-mode = <3>;
> -			port1-mode = <3>;
> -			power = <250>;
> -			ti,hwmods = "usb_otg_hs";
> +		phy1: am335x-usb0@44e10620 {

    Shouldn't the PHYs be *under* the usb0/1 device nodes in the hierarchy?
They're not on the same bus as the MUSB controllers for sure.

> +			compatible = "ti,am335x-usb2";
> +			#phy-cells = <0>;
> +			id= <0>;

    Forgot space before =.

> +		};
> +
> +		phy2: am335x-usb1@44e10628 {
> +			compatible = "ti,am335x-usb2";
> +			#phy-cells = <0>;
> +			id= <1>;

    Same here.

> +		};
> +
> +		omap_control_usb: omap-control-usb@44e10620 {
> +			compatible = "ti,omap-control-usb";
> +			reg = <0x44e10620 0x10>;
> +			reg-names = "control_dev_conf";
> +			ti,type = <3>;
> +		};
> +
> +                musb: usb@47400000 {
> +                        compatible = "ti,musb-am33xx";
> +                        reg = <0x47400000 0x1000>;
> +                        ranges;
> +                        #address-cells = <1>;
> +                        #size-cells = <1>;
> +                        interrupts = <17>;
> +                        ti,hwmods = "usb_otg_hs";
> +
> +                        usb0@47401000 {

    I don't think you need index in the name since you have the address as a 
part of the name anyway. That way it's closer to the ePAPR spec.

> +                                reg = <0x47401000 0x800>;
> +                                interrupts = <18>;
> +                                interrupt-names = "mc";
> +                                multipoint = <1>;
> +                                num-eps = <16>;
> +                                ram-bits = <12>;
> +                                port-mode = <3>;
> +                                power = <250>;
> +                                phys = <&phy1>;

    The above lines are indented with spaces, the below one with tabs. Use 
tabs please.

> +				phy-names = "am335x-usb0";
> +                        };
> +
> +                        usb1@47401800 {
> +                                reg = <0x47401800 0x800>;
> +                                interrupts = <19>;
> +                                interrupt-names = "mc";
> +                                multipoint = <1>;
> +                                num-eps = <16>;
> +                                ram-bits = <12>;
> +                                port-mode = <3>;
> +                                power = <250>;
> +                                phys = <&phy2>;

    The above lines are indented with spaces, the below one with tabs. Use 
tabs please.

> +				phy-names = "am335x-usb1";
> +			};
>   		};

WBR, Sergei

