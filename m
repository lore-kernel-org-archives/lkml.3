Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaANPUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:20:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaANPUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:20:36 -0500
Date: Tue, 14 Jan 2014 07:20:48 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: rogerable@realtek.com
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>, Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        driverdev-devel@linuxdriverproject.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn
Subject: Re: [PATCH 1/3] mfd: Add realtek USB card reader driver
Message-ID: <20140114152048.GB6512@kroah.com>
References: <1389685656-880-1-git-send-email-rogerable@realtek.com>
 <1389685656-880-2-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389685656-880-2-git-send-email-rogerable@realtek.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 03:47:34PM +0800, rogerable@realtek.com wrote:
> From: Roger Tseng <rogerable@realtek.com>
> 
> Realtek USB card reader provides a channel to transfer command or data to flash
> memory cards. This driver exports host instances for mmc and memstick subsystems
> and handles basic works.
> 
> Signed-off-by: Roger Tseng <rogerable@realtek.com>
> ---
>  drivers/mfd/Kconfig          |  10 +
>  drivers/mfd/Makefile         |   1 +
>  drivers/mfd/rtsx_usb.c       | 788 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/rtsx_usb.h | 619 +++++++++++++++++++++++++++++++++
>  4 files changed, 1418 insertions(+)
>  create mode 100644 drivers/mfd/rtsx_usb.c
>  create mode 100644 include/linux/mfd/rtsx_usb.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index b7c74a7..4c99ebd 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -507,6 +507,16 @@ config MFD_RTSX_PCI
>  	  types of memory cards, such as Memory Stick, Memory Stick Pro,
>  	  Secure Digital and MultiMediaCard.
>  
> +config MFD_RTSX_USB
> +	tristate "Realtek USB card reader"
> +	depends on USB
> +	select MFD_CORE
> +	help
> +	Select this option to get support for Realtek USB 2.0 card readers
> +	including RTS5129, RTS5139, RTS5179 and RTS5170.
> +	Realtek card reader supports access to many types of memory cards,
> +	such as Memory Stick Pro, Secure Digital and MultiMediaCard.
> +
>  config MFD_RC5T583
>  	bool "Ricoh RC5T583 Power Management system device"
>  	depends on I2C=y
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 8a28dc9..33b8de6 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -14,6 +14,7 @@ obj-$(CONFIG_MFD_CROS_EC_SPI)	+= cros_ec_spi.o
>  
>  rtsx_pci-objs			:= rtsx_pcr.o rts5209.o rts5229.o rtl8411.o rts5227.o rts5249.o
>  obj-$(CONFIG_MFD_RTSX_PCI)	+= rtsx_pci.o
> +obj-$(CONFIG_MFD_RTSX_USB)	+= rtsx_usb.o
>  
>  obj-$(CONFIG_HTC_EGPIO)		+= htc-egpio.o
>  obj-$(CONFIG_HTC_PASIC3)	+= htc-pasic3.o
> diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
> new file mode 100644
> index 0000000..905ec8d
> --- /dev/null
> +++ b/drivers/mfd/rtsx_usb.c
> @@ -0,0 +1,788 @@
> +/* Driver for Realtek USB card reader
> + *
> + * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2, or (at your option) any
> + * later version.

Do you really mean "any later version"?  (sorry, I have to ask.)

Same goes for the other files you add with this specific license
wording.

> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/mutex.h>
> +#include <linux/usb.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/core.h>
> +#include <asm/unaligned.h>

Why is this file neded?

thanks,

greg k-h
