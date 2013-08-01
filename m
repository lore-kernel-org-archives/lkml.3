Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3HAFYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 01:24:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44723 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab3HAFYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 01:24:38 -0400
Message-ID: <51F9F10A.4000908@ti.com>
Date: Thu, 1 Aug 2013 10:54:26 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] usb: musb: dsps: use proper child nodes
References: <1375215401-19729-1-git-send-email-bigeasy@linutronix.de> <1375215401-19729-6-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1375215401-19729-6-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/2013 1:46 AM, Sebastian Andrzej Siewior wrote:
> This moves the two instances from the big node into two child nodes. The
> glue layer ontop does almost nothing.
> There is one devices containing the control module for USB (2) phy,
> (2) usb and later the dma engine. The usb device is the "glue device"
> which contains the musb device as a child. This is what we do ever since.
> The new file musb_am335x is just here to prob the new bus and populate
> child devices.
> There are a lot of changes to the dsps file as a result of the changes:
> - musb_core_offset
>    This is gone. The device tree provides memory ressources information
>    for the device there is no need to "fix" things
> - instances
>    This is gone as well. If we have two instances then we have have two
>    child enabled nodes in the device tree. For instance the SoC in beagle
>    bone has two USB instances but only one has been wired up so there is
>    no need to load and init the second instance since it won't be used.
> - dsps_glue is now per glue device
>    In the past there was one of this structs but with an array of two and
>    each instance accessed its variable depending on the platform device
>    id.
> - no unneeded copy of structs
>    I do not know why struct dsps_musb_wrapper is copied but it is not
>    necessary. The same goes for musb_hdrc_platform_data which allocated
>    on demand and then again by platform_device_add_data(). One copy is
>    enough.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

<snip >

>   
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 38b446b..0f756ca 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -26,6 +26,10 @@
>   		serial5 = &uart5;
>   		d_can0 = &dcan0;
>   		d_can1 = &dcan1;
> +		usb0 = &usb0;
> +		usb1 = &usb1;
> +		phy0 = &usb0_phy;
> +		phy1 = &usb1_phy;
>   	};
>   
>   	cpus {
> @@ -333,21 +337,85 @@
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
> +		usb: usb@47400000 {
> +			compatible = "ti,am33xx-usb";
> +			reg = <0x47400000 0x1000>;
> +			ranges;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
>   			ti,hwmods = "usb_otg_hs";
> +			status = "disabled";
> +
> +			ctrl_mod: control@44e10000 {
> +				compatible = "ti,am335x-ctrl-module";
> +				reg = <0x44e10000 0x650>;

Do you really need to map Control Module base to 0x650? If some other driver does this mapping

we will always end returning -EPROBE_DEFER.

How about this
	reg = 	<0x44e10620 0x4> ,
		<0x44e10648 0x1>;
	reg-names = "phycontrol_dev" , "phywkup_dev";

and map for power on/off and phywkup separately in the control driver.

> +				reg-names = "control_dev";
> +				status = "disabled";
> +			};
> +

<snip>

> diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
> index 797e3fd..b7257ae 100644
> --- a/drivers/usb/musb/Kconfig
> +++ b/drivers/usb/musb/Kconfig
> @@ -83,6 +83,7 @@ config USB_MUSB_AM35X
>   
>   config USB_MUSB_DSPS
>   	tristate "TI DSPS platforms"
> +	select USB_MUSB_AM335X_CHILD

How about adding select AM335X_PHY_USB here?

>   
>   config USB_MUSB_BLACKFIN
>   	tristate "Blackfin"
> @@ -93,6 +94,9 @@ config USB_MUSB_UX500
>   
>   endchoice
>   
> +config USB_MUSB_AM335X_CHILD
> +	tristate
> +
>   choice
>   	prompt 'MUSB DMA mode'
>   	default MUSB_PIO_ONLY if ARCH_MULTIPLATFORM
>

-- 
-George

