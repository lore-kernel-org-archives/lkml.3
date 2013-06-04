Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab3FDPWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:22:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35353 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751416Ab3FDPWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:22:02 -0400
Date: Tue, 4 Jun 2013 11:22:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC 2/2] USB: host: make USB_ARCH_HAS_?HCI obsolete
In-Reply-To: <1810803.LEeYoES7nl@wuerfel>
Message-ID: <Pine.LNX.4.44L0.1306041107520.1093-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jun 2013, Arnd Bergmann wrote:

> The three options USB_ARCH_HAS_{EHCI,OHCI,XHCI} are all well beyond
> their recommended shelf life. They have caused numerous build failures
> over the years because they are never completely correct, and with
> the move to splitting out the platform specific back-ends out of the
> driver, there is no real need for them any more. Also, the use of making
> USB_ARCH_HAS_HCD depend on it is questionable since one can always enable
> dummy_hc these days.
> 
> This patch enables them unconditionally for all platforms and
> architectures, which means it is now possible to build host controller
> drivers for machines that are known not to come with this hardware,
> but that is just how we treat most other drivers.
> 
> In order to minimise the impact on existing architecture code and
> defconfig files, all the Kconfig are left present for now. All platforms
> that currently do 'select USB_ARCH_HAS_*' should subsequently be changed
> not to select that. All drivers depending on USB_ARCH_HAS_HCD should
> be changed to depend on USB_SUPPORT instead.

This is a good idea.

> diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
> index 92e1dc9..654cd81 100644
> --- a/drivers/usb/Kconfig
> +++ b/drivers/usb/Kconfig

> -# some non-PCI HCDs implement xHCI

> @@ -71,19 +27,8 @@ config USB_COMMON
>  	default y
>  	depends on USB || USB_GADGET
>  
> -# Host-side USB depends on having a host controller
> -# NOTE:  dummy_hcd is always an option, but it's ignored here ...
> -# NOTE:  SL-811 option should be board-specific ...
>  config USB_ARCH_HAS_HCD
> -	boolean
> -	default y if USB_ARCH_HAS_OHCI
> -	default y if USB_ARCH_HAS_EHCI
> -	default y if USB_ARCH_HAS_XHCI
> -	default y if PCMCIA && !M32R			# sl811_cs
> -	default y if ARM				# SL-811
> -	default y if BLACKFIN				# SL-811
> -	default y if SUPERH				# r8a66597-hcd
> -	default PCI
> +	def_bool HAS_IOMEM

Instead of doing this, it makes more sense to enable USB_ARCH_HAS_HCD
whenever host-side USB is enabled.  In other words,

	def_bool USB

The HAS_IOMEM won't matter, because USB is defined only when 
USB_SUPPORT is enabled, and USB_SUPPORT already depends on HAS_IOMEM.

Of course, it will then be necessary to remove the dependency on 
USB_ARCH_HAS_HCD from the "config USB" entry.  Which is exactly what 
you're trying to accomplish, anyway.

> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index e060ecf..045f9d27 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -17,7 +17,7 @@ config USB_C67X00_HCD
>  
>  config USB_XHCI_HCD
>  	tristate "xHCI HCD (USB 3.0) support"
> -	depends on USB_ARCH_HAS_XHCI
> +	depends on PCI

You probably don't want to add this dependency.  After all, one of the
comments removed above points out that there are non-PCI xHCI
controllers.

Alan Stern

