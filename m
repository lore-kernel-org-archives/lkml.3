Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaI3MGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:06:42 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:65160 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091AbaI3MGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:06:40 -0400
Message-ID: <1412078798.21730.6.camel@x220>
Subject: Re: [PATCH] USB: host: st: fix ehci/ohci driver selection
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Peter Griffin <peter.griffin@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Tue, 30 Sep 2014 14:06:38 +0200
In-Reply-To: <2536929.C0XC0THfdJ@wuerfel>
References: <2536929.C0XC0THfdJ@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Sep 2014 12:06:38.0435 (UTC) FILETIME=[FCFFFB30:01CFDCA6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-29 at 14:54 +0200, Arnd Bergmann wrote:
> The newly added sti ehci and ohci drivers come with a single
> Kconfig entry that does not depend on either of the base drivers,
> which leads to a link error when they are disabled:
> 
> drivers/built-in.o: In function `ohci_platform_init':
> :(.init.text+0x14788): undefined reference to `ohci_init_driver'
> 
> To fix that, this patch introduces two separate Kconfig options
> with proper dependencies, which avoids the problem and is also
> more consistent with the other glue drivers.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: d115837259ada ("usb: host: ohci-st: Add OHCI driver support for ST STB devices")
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Peter Griffin <peter.griffin@linaro.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: linux-usb@vger.kernel.org

This became commit 905e300e1043 ("USB: host: st: fix ehci/ohci driver
selection") in next-20140930.

> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index b943545f862c..002ba1d5bcf5 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -174,6 +174,15 @@ config USB_EHCI_HCD_SPEAR
>            Enables support for the on-chip EHCI controller on
>            ST SPEAr chips.
>  
> +config USB_EHCI_HCD_STI
> +	tristate "Support for ST STiHxxx on-chip EHCI USB controller"
> +	depends on ARCH_STI && OF
> +	select GENERIC_PHY
> +	select USB_EHCI_HCD_PLATFORM
> +	help
> +	  Enable support for the on-chip EHCI controller found on
> +	  STMicroelectronics consumer electronics SoC's.
> +
>  config USB_EHCI_HCD_AT91
>          tristate  "Support for Atmel on-chip EHCI USB controller"
>          depends on USB_EHCI_HCD && ARCH_AT91
> @@ -402,6 +411,15 @@ config USB_OHCI_HCD_SPEAR
>            Enables support for the on-chip OHCI controller on
>            ST SPEAr chips.
>  
> +config USB_OHCI_HCD_STI
> +	tristate "Support for ST STiHxxx on-chip OHCI USB controller"
> +	depends on ARCH_STI && OF
> +	select GENERIC_PHY
> +	select USB_OHCI_HCD_PLATFORM
> +	help
> +	  Enable support for the on-chip OHCI controller found on
> +	  STMicroelectronics consumer electronics SoC's.
> +
>  config USB_OHCI_HCD_S3C2410
>          tristate "OHCI support for Samsung S3C24xx/S3C64xx SoC series"
>          depends on USB_OHCI_HCD && (ARCH_S3C24XX || ARCH_S3C64XX)
> @@ -761,14 +779,6 @@ config USB_HCD_SSB
>  
>  	  If unsure, say N.
>  
> -config USB_HCD_ST
> -	tristate "ST USB driver for ST SoC Series"
> -	depends on ARCH_STI && OF
> -	select GENERIC_PHY
> -	help
> -	  Enable support for the on-chip OHCI & EHCI controller found on
> -	  STMicroelectronics consumer electronics SoC's.
> -
>  config USB_HCD_TEST_MODE
>  	bool "HCD test mode support"
>  	---help---
> diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
> index ae2db0b87993..0336bb2c0e6f 100644
> --- a/drivers/usb/host/Makefile
> +++ b/drivers/usb/host/Makefile
> @@ -38,6 +38,7 @@ obj-$(CONFIG_USB_EHCI_MXC)	+= ehci-mxc.o
>  obj-$(CONFIG_USB_EHCI_HCD_OMAP)	+= ehci-omap.o
>  obj-$(CONFIG_USB_EHCI_HCD_ORION)	+= ehci-orion.o
>  obj-$(CONFIG_USB_EHCI_HCD_SPEAR)	+= ehci-spear.o
> +obj-$(CONFIG_USB_EHCI_HCD_ST)	+= ehci-st.o

This should have been
    CONFIG_USB_EHCI_HCD_STI

(A rather subtle typo, easy to make given the rest of the patch.)

>  obj-$(CONFIG_USB_EHCI_EXYNOS)	+= ehci-exynos.o
>  obj-$(CONFIG_USB_EHCI_HCD_AT91) += ehci-atmel.o
>  obj-$(CONFIG_USB_EHCI_MSM)	+= ehci-msm.o
> @@ -55,6 +56,7 @@ obj-$(CONFIG_USB_OHCI_EXYNOS)	+= ohci-exynos.o
>  obj-$(CONFIG_USB_OHCI_HCD_OMAP1)	+= ohci-omap.o
>  obj-$(CONFIG_USB_OHCI_HCD_OMAP3)	+= ohci-omap3.o
>  obj-$(CONFIG_USB_OHCI_HCD_SPEAR)	+= ohci-spear.o
> +obj-$(CONFIG_USB_OHCI_HCD_STI)	+= ohci-st.o
>  obj-$(CONFIG_USB_OHCI_HCD_AT91)	+= ohci-at91.o
>  obj-$(CONFIG_USB_OHCI_HCD_S3C2410)	+= ohci-s3c2410.o
>  obj-$(CONFIG_USB_OHCI_HCD_LPC32XX)	+= ohci-nxp.o
> @@ -77,4 +79,3 @@ obj-$(CONFIG_USB_HCD_SSB)	+= ssb-hcd.o
>  obj-$(CONFIG_USB_FUSBH200_HCD)	+= fusbh200-hcd.o
>  obj-$(CONFIG_USB_FOTG210_HCD)	+= fotg210-hcd.o
>  obj-$(CONFIG_USB_MAX3421_HCD)	+= max3421-hcd.o
> -obj-$(CONFIG_USB_HCD_ST)	+= ehci-st.o ohci-st.o


Paul Bolle

