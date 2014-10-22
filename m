Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbaJVSpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:45:31 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:47760 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbaJVSpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:45:22 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Dinh Nguyen <dinguyen@opensource.altera.com>,
        Paul Bolle <pebolle@tiscali.nl>
CC: "balbi@ti.com" <balbi@ti.com>,
        "dinh.linux@gmail.com" <dinh.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "matthijs@stdin.nl" <matthijs@stdin.nl>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCHv5 7/7] usb: dwc2: Update Kconfig to support dual-role
Thread-Topic: [PATCHv5 7/7] usb: dwc2: Update Kconfig to support dual-role
Thread-Index: AQHP7JesnDFIW03SEUaNZEZCzxwRS5w52CKAgAGkhACAAPcx4A==
Date: Wed, 22 Oct 2014 18:45:08 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844E4EEC@US01WEMBX2.internal.synopsys.com>
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
	 <1413831126-24193-8-git-send-email-dinguyen@opensource.altera.com>
 <1413834151.2010.19.camel@x41> <5446C668.3020609@opensource.altera.com>
In-Reply-To: <5446C668.3020609@opensource.altera.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9MIjb1g010347

> From: Dinh Nguyen [mailto:dinguyen@opensource.altera.com]
> Sent: Tuesday, October 21, 2014 1:48 PM
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

Maybe "For all modes (host, gadget and dual-role), there will be an
additional module named dwc2.ko." That would be clearer.

>  if USB_DWC2
>  
> +choice
> +	bool "DWC2 Mode Selection"
> +	default USB_DWC2_DUAL_ROLE if (USB && USB_GADGET)
> +	default USB_DWC2_HOST if (USB && !USB_GADGET)
> +	default USB_DWC2_PERIPHERAL if (!USB && USB_GADGET)
> +
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

Shouldn't this be "This option requires USB_GADGET to be enabled"? It
doesn't have to be built-in.

> +config USB_DWC2_DUAL_ROLE
> +	bool "Dual Role mode"
> +	depends on (USB=y || USB=USB_DWC2) && (USB_GADGET=y || USB_GADGET=USB_DWC2)
> +	help
> +	  Select this option if you want the driver to work in a dual-role
> +	  mode. In this mode both host and gadget features are enabled, and
> +	  the role will be determined by the cable that gets plugged-in. This
> +	  option requires USB_GADGET=y.

Ditto.

Once you fix these, plus the extraneous "default y" that Paul Bolle
pointed out, you can add my acked-by.

-- 
Paul

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
