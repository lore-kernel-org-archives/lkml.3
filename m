Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990Ab3D2Wsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 18:48:36 -0400
Received: from relais.videotron.ca ([24.201.245.36]:55018 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758583Ab3D2Wsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 18:48:35 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Mon, 29 Apr 2013 18:48:34 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brown <davidb@codeaurora.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org
Subject: Re: MFD: move ssbi driver into drivers/mfd
In-reply-to: <201304300000.19488.arnd@arndb.de>
Message-id: <alpine.LFD.2.03.1304291848080.17372@syhkavp.arg>
References: <20130429162115.GA6893@kroah.com>
 <8yafvy92gfs.fsf@huya.qualcomm.com>
 <CA+55aFxaMP+=uMLLvnLHz_E0GStrDf_zO3XhVCDGHbk=tV6CqA@mail.gmail.com>
 <201304300000.19488.arnd@arndb.de>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013, Arnd Bergmann wrote:

> There is no reason for ssbi to have its own top-level driver directory
> when the only users of this interface are all MFD drivers. The only
> mainline driver using it at the moment (PM8921) is marked broken and in
> fact does not compile. I have verified that fixing the trivial build
> breakage in pm8921 links in the new ssbi code just fine, but that
> can be a separate patch.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>

Acked-by: Nicolas Pitre <nico@linaro.org>


> ---
>  drivers/Kconfig              |  2 --
>  drivers/Makefile             |  1 -
>  drivers/mfd/Kconfig          |  3 ++-
>  drivers/mfd/Makefile         |  2 +-
>  drivers/{ssbi => mfd}/ssbi.c |  0
>  drivers/ssbi/Kconfig         | 16 ----------------
>  drivers/ssbi/Makefile        |  1 -
>  7 files changed, 3 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 78a956e..202fa6d 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -52,8 +52,6 @@ source "drivers/i2c/Kconfig"
>  
>  source "drivers/spi/Kconfig"
>  
> -source "drivers/ssbi/Kconfig"
> -
>  source "drivers/hsi/Kconfig"
>  
>  source "drivers/pps/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 33360de..3c200a2 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -114,7 +114,6 @@ obj-y				+= firmware/
>  obj-$(CONFIG_CRYPTO)		+= crypto/
>  obj-$(CONFIG_SUPERH)		+= sh/
>  obj-$(CONFIG_ARCH_SHMOBILE)	+= sh/
> -obj-$(CONFIG_SSBI)		+= ssbi/
>  ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
>  obj-y				+= clocksource/
>  endif
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index ca86581..5150833 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -991,7 +991,8 @@ config MFD_PM8XXX
>  
>  config MFD_PM8921_CORE
>  	tristate "Qualcomm PM8921 PMIC chip"
> -	depends on SSBI && BROKEN
> +	depends on (ARCH_MSM || HEXAGON)
> +	depends on BROKEN
>  	select MFD_CORE
>  	select MFD_PM8XXX
>  	help
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index b90409c..3b95b47 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -133,7 +133,7 @@ obj-$(CONFIG_MFD_VX855)		+= vx855.o
>  obj-$(CONFIG_MFD_WL1273_CORE)	+= wl1273-core.o
>  obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
>  obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o omap-usb-tll.o
> -obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o
> +obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o ssbi.o
>  obj-$(CONFIG_MFD_PM8XXX_IRQ) 	+= pm8xxx-irq.o
>  obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
>  obj-$(CONFIG_MFD_TPS65090)	+= tps65090.o
> diff --git a/drivers/ssbi/ssbi.c b/drivers/mfd/ssbi.c
> similarity index 100%
> rename from drivers/ssbi/ssbi.c
> rename to drivers/mfd/ssbi.c
> diff --git a/drivers/ssbi/Kconfig b/drivers/ssbi/Kconfig
> deleted file mode 100644
> index 1ae4040a..0000000
> --- a/drivers/ssbi/Kconfig
> +++ /dev/null
> @@ -1,16 +0,0 @@
> -#
> -# SSBI bus support
> -#
> -
> -menu "Qualcomm MSM SSBI bus support"
> -
> -config SSBI
> -	tristate "Qualcomm Single-wire Serial Bus Interface (SSBI)"
> -	help
> -	  If you say yes to this option, support will be included for the
> -	  built-in SSBI interface on Qualcomm MSM family processors.
> -
> -	  This is required for communicating with Qualcomm PMICs and
> -	  other devices that have the SSBI interface.
> -
> -endmenu
> diff --git a/drivers/ssbi/Makefile b/drivers/ssbi/Makefile
> deleted file mode 100644
> index 38fb70c..0000000
> --- a/drivers/ssbi/Makefile
> +++ /dev/null
> @@ -1 +0,0 @@
> -obj-$(CONFIG_SSBI) += ssbi.o
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
