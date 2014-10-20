Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaJTTmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:42:38 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:51624 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751885AbaJTTmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:42:36 -0400
Message-ID: <1413834151.2010.19.camel@x41>
Subject: Re: [PATCHv5 7/7] usb: dwc2: Update Kconfig to support dual-role
From: Paul Bolle <pebolle@tiscali.nl>
To: dinguyen@opensource.altera.com
Cc: paulz@synopsys.com, balbi@ti.com, dinh.linux@gmail.com,
        linux-kernel@vger.kernel.org, swarren@wwwdotorg.org,
        b.zolnierkie@samsung.com, matthijs@stdin.nl, r.baldyga@samsung.com,
        jg1.han@samsung.com, sachin.kamat@linaro.org, ben-linux@fluff.org,
        dianders@chromium.org, kever.yang@rock-chips.com,
        linux-usb@vger.kernel.org
Date: Mon, 20 Oct 2014 21:42:31 +0200
In-Reply-To: <1413831126-24193-8-git-send-email-dinguyen@opensource.altera.com>
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
	 <1413831126-24193-8-git-send-email-dinguyen@opensource.altera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Oct 2014 19:42:33.0282 (UTC) FILETIME=[FE056220:01CFEC9D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dinguyen@opensource.altera.com schreef op ma 20-10-2014 om 13:52
[-0500]:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> Update DWC2 kconfig and makefile to support dual-role mode. The platform
> file will always get compiled for the case where the controller is directly
> connected to the CPU. So for loadable modules, dwc2.ko is built for host,
> peripheral, and dual-role mode. The PCI bus interface will be called
> dwc2_pci.ko and the platform interface module will be called dwc2_platform.ko.
> 
> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> ---
> v5: dwc2.ko for all modes along with dwc2_platform.ko and dwc2_pci.ko will
>     get built for kernel modules.
> v3: Add USB_GADGET=y and USB_GADGET=USB_DWC2 for peripheral and dual-role
>     config options.
> v2: Remove reference to dwc2_gadget
> ---
>  drivers/usb/dwc2/Kconfig  | 61 ++++++++++++++++++++++++++++-------------------
>  drivers/usb/dwc2/Makefile | 32 ++++++++++++-------------
>  2 files changed, 53 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/Kconfig b/drivers/usb/dwc2/Kconfig
> index f93807b..1ea702e 100644
> --- a/drivers/usb/dwc2/Kconfig
> +++ b/drivers/usb/dwc2/Kconfig
> @@ -1,5 +1,5 @@
>  config USB_DWC2
> -	bool "DesignWare USB2 DRD Core Support"
> +	tristate "DesignWare USB2 DRD Core Support"
>  	depends on USB

(Side note: drivers/usb/dwc2/Kconfig is sourced (in drivers/usb/Kconfig)
even if USB is _not_ set. But USB_DCW2 still depends on USB. Why is
that?)

>  	help
>  	  Say Y here if your system has a Dual Role Hi-Speed USB
> @@ -10,31 +10,53 @@ config USB_DWC2
>  	  bus interface module (if you have a PCI bus system) will be
>  	  called dwc2_pci.ko, and the platform interface module (for
>  	  controllers directly connected to the CPU) will be called
> -	  dwc2_platform.ko. For gadget mode, there will be a single
> -	  module called dwc2_gadget.ko.
> -
> -	  NOTE: The s3c-hsotg driver is now renamed to dwc2_gadget. The
> -	  host and gadget drivers are still currently separate drivers.
> -	  There are plans to merge the dwc2_gadget driver with the dwc2
> -	  host driver in the near future to create a dual-role driver.
> +	  dwc2_platform.ko. For all modes(host, gadget and dual-role), there
> +	  will be a single module called dwc2.ko.
>  
>  if USB_DWC2
>  
> +choice
> +	bool "DWC2 Mode Selection"
> +	default USB_DWC2_DUAL_ROLE if (USB && USB_GADGET)
> +	default USB_DWC2_HOST if (USB && !USB_GADGET)
> +	default USB_DWC2_PERIPHERAL if (!USB && USB_GADGET)
> +

Juggling kconfig tristate logic is still rather hard for me, but don't
the above three "if" rules all evaluate to non-zero if both USB and
USB_GADGET are 'm'? If that's correct perhaps USB_DWC2_DUAL_ROLE should
be the last default (assuming the last default wins, that is).

Besides, will the default USB_DWC2_PERIPHERAL ever trigger as !USB can't
be true at this point, can it?

>  config USB_DWC2_HOST
> -	tristate "Host only mode"
> +	bool "Host only mode"
>  	depends on USB
>  	help
>  	  The Designware USB2.0 high-speed host controller
> -	  integrated into many SoCs.
> +	  integrated into many SoCs. Select this option if you want the
> +	  driver to operate in Host-only mode.
> +
> +comment "Gadget/Dual-role mode requires USB Gadget support to be enabled"
> +
> +config USB_DWC2_PERIPHERAL
> +	bool "Gadget only mode"
> +	depends on USB_GADGET=y || USB_GADGET=USB_DWC2
> +	help
> +	  The Designware USB2.0 high-speed gadget controller
> +	  integrated into many SoCs. Select this option if you want the
> +	  driver to operate in Peripheral-only mode. This option requires
> +	  USB_GADGET=y.
> +
> +config USB_DWC2_DUAL_ROLE
> +	bool "Dual Role mode"
> +	depends on (USB=y || USB=USB_DWC2) && (USB_GADGET=y || USB_GADGET=USB_DWC2)
> +	help
> +	  Select this option if you want the driver to work in a dual-role
> +	  mode. In this mode both host and gadget features are enabled, and
> +	  the role will be determined by the cable that gets plugged-in. This
> +	  option requires USB_GADGET=y.
> +endchoice

(I wonder how the dependencies of these three config entries interact
with the three defaults of this choice. Since we're dealing with three
options here this requires a piece of paper, a pencil, and clear mind to
figure out. Maybe I'll try that in a few days...)

>  config USB_DWC2_PLATFORM
>  	bool "DWC2 Platform"
> -	depends on USB_DWC2_HOST
>  	default USB_DWC2_HOST
> -	help
> -	  The Designware USB2.0 platform interface module for
> -	  controllers directly connected to the CPU. This is only
> -	  used for host mode.
> +        default y

You now have to default lines. Which one wins?

> +        help
> +          The Designware USB2.0 platform interface module for
> +          controllers directly connected to the CPU.
>  
>  config USB_DWC2_PCI
>  	bool "DWC2 PCI"
> @@ -44,15 +66,6 @@ config USB_DWC2_PCI
>  	  The Designware USB2.0 PCI interface module for controllers
>  	  connected to a PCI bus. This is only used for host mode.
>  
> -comment "Gadget mode requires USB Gadget support to be enabled"
> -
> -config USB_DWC2_PERIPHERAL
> -	tristate "Gadget only mode"
> -	depends on USB_GADGET
> -	help
> -	  The Designware USB2.0 high-speed gadget controller
> -	  integrated into many SoCs.
> -
>  config USB_DWC2_DEBUG
>  	bool "Enable Debugging Messages"
>  	help
> diff --git a/drivers/usb/dwc2/Makefile b/drivers/usb/dwc2/Makefile
> index b73d2a5..2175d93 100644


Paul Bolle

