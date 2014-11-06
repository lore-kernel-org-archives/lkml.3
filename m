Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaKFNuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:50:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51104 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbaKFNuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:50:21 -0500
Message-ID: <545B7C9A.8000309@suse.de>
Date: Thu, 06 Nov 2014 14:50:18 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "J. German Rivera" <German.Rivera@freescale.com>,
        gregkh@linuxfoundation.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org
CC: stuart.yoder@freescale.com, Kim.Phillips@freescale.com,
        scottwood@freescale.com, bhamciu1@freescale.com, R89243@freescale.com,
        Geoff.Thorpe@freescale.com, bhupesh.sharma@freescale.com,
        nir.erez@freescale.com, richard.schmitt@freescale.com
Subject: Re: [PATCH 2/3 v3] drivers/bus: Freescale Management Complex (fsl-mc)
 bus driver
References: <1412429015-30564-1-git-send-email-German.Rivera@freescale.com> <1412429015-30564-3-git-send-email-German.Rivera@freescale.com>
In-Reply-To: <1412429015-30564-3-git-send-email-German.Rivera@freescale.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04.10.14 15:23, J. German Rivera wrote:
> From: "J. German Rivera" <German.Rivera@freescale.com>
> 
> Platform device driver that sets up the basic bus infrastructure
> for the fsl-mc bus type, including support for adding/removing
> fsl-mc devices, register/unregister of fsl-mc drivers, and bus
> match support to bind devices to drivers.
> 
> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
> ---
> Changes in v3:
> - Addressed changes from Kim Phillips:
>   * Renamed files:
> 	drivers/bus/fsl-mc/fsl_mc_bus.c -> drivers/bus/fsl-mc/mc-bus.c
> 	include/linux/fsl_mc.h -> include/linux/fsl/mc.h
> 	include/linux/fsl_mc_private.h -> include/linux/fsl/mc-private.h
> 
> - Addressed comments from Timur Tabi:
>   * Changed all functions that had goto out/error when no common cleanup
>     was done, to just have multiple return points.
>   * Replaced error cleanup boolean flags with multiple exit points.
> 
> Changes in v2:
> - Addressed comment from Joe Perches:
>   * Changed pr_debug to dev_dbg in fsl_mc_bus_match
> 
> - Addressed comments from Kim Phillips and Alex Graf:
>   * Changed version check to allow the driver to run with MC
>     firmware that has major version number greater than or equal
>     to the driver's major version number.
>   * Removed minor version check
> 
> - Removed unused variable parent_dev in fsl_mc_device_remove
> 
>  drivers/bus/Kconfig            |    3 +
>  drivers/bus/Makefile           |    3 +
>  drivers/bus/fsl-mc/Kconfig     |   13 +
>  drivers/bus/fsl-mc/Makefile    |   14 +
>  drivers/bus/fsl-mc/mc-bus.c    |  566 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/fsl/mc-private.h |   33 +++
>  include/linux/fsl/mc.h         |  137 ++++++++++
>  7 files changed, 769 insertions(+)
>  create mode 100644 drivers/bus/fsl-mc/Kconfig
>  create mode 100644 drivers/bus/fsl-mc/Makefile
>  create mode 100644 drivers/bus/fsl-mc/mc-bus.c
>  create mode 100644 include/linux/fsl/mc-private.h
>  create mode 100644 include/linux/fsl/mc.h
> 
> diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
> index 603eb1b..2fbb1fd 100644
> --- a/drivers/bus/Kconfig
> +++ b/drivers/bus/Kconfig
> @@ -67,4 +67,7 @@ config VEXPRESS_CONFIG
>  	help
>  	  Platform configuration infrastructure for the ARM Ltd.
>  	  Versatile Express.
> +
> +source "drivers/bus/fsl-mc/Kconfig"
> +
>  endmenu
> diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
> index 2973c18..6abcab1 100644
> --- a/drivers/bus/Makefile
> +++ b/drivers/bus/Makefile
> @@ -15,3 +15,6 @@ obj-$(CONFIG_ARM_CCI)		+= arm-cci.o
>  obj-$(CONFIG_ARM_CCN)		+= arm-ccn.o
> 
>  obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o
> +
> +# Freescale Management Complex (MC) bus drivers
> +obj-$(CONFIG_FSL_MC_BUS)	+= fsl-mc/
> diff --git a/drivers/bus/fsl-mc/Kconfig b/drivers/bus/fsl-mc/Kconfig
> new file mode 100644
> index 0000000..e3226f9
> --- /dev/null
> +++ b/drivers/bus/fsl-mc/Kconfig
> @@ -0,0 +1,13 @@
> +#
> +# Freescale Management Complex (MC) bus drivers
> +#
> +# Copyright (C) 2014 Freescale Semiconductor, Inc.
> +#
> +# This file is released under the GPLv2
> +#
> +
> +config FSL_MC_BUS
> +	tristate "Freescale Management Complex (MC) bus driver"
> +	help
> +	  Driver to enable the bus infrastructure for the Freescale
> +          QorIQ Management Complex.

Isn't this missing some scope limitations? Should we really have the
driver enabled on x86 for example?

I would also make this slightly more verbose. People don't necessarily
know what the QorIQ Management Complex is. Give people some idea what
they're dealing with and preferably tell them hints that guide them from
"SoC name" to "should I enable this option?".

Also, usually the help text gives some guidance on what to do with the
option if you're not sure. In this case, I would say advise the user to
say N.


Alex
