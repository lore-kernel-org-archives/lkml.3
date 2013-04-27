Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3D0NOt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 09:14:49 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:52386 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab3D0NOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 09:14:47 -0400
Date: Sat, 27 Apr 2013 06:14:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Richard L Maliszewski <richard.l.maliszewski@intel.com>,
        Shane Wang <shane.wang@intel.com>, Gang Wei <gang.wei@intel.com>,
        linux-kernel@vger.kernel.org, Xiaoyan Zhang <xiaoyan.zhang@intel.com>
Subject: Re: [PATCH 1/5] driver: add TXT driver in kernel
Message-ID: <20130427131443.GA32432@kroah.com>
References: <1367074580-16530-1-git-send-email-qiaowei.ren@intel.com>
 <1367074580-16530-2-git-send-email-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367074580-16530-2-git-send-email-qiaowei.ren@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 10:56:16PM +0800, Qiaowei Ren wrote:
> TXT driver is expected to be a better tool to access below resources:
> TXT config space, TXT heap, TXT log and SMX parameter.

You are adding new sysfs files, so that means you need to add
Documentation/ABI files as well.  Please respin this series with those
added so we have a hint as to how this driver is interacting with
userspace.

> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
> Signed-off-by: Gang Wei <gang.wei@intel.com>
> ---
>  drivers/char/Kconfig         |    2 ++
>  drivers/char/Makefile        |    1 +
>  drivers/char/txt/Kconfig     |   18 ++++++++++++++++++
>  drivers/char/txt/Makefile    |    5 +++++
>  drivers/char/txt/txt-sysfs.c |   41 +++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 67 insertions(+)
>  create mode 100644 drivers/char/txt/Kconfig
>  create mode 100644 drivers/char/txt/Makefile
>  create mode 100644 drivers/char/txt/txt-sysfs.c
> 
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index 3bb6fa3..9309e89 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -565,6 +565,8 @@ config UV_MMTIMER
>  
>  source "drivers/char/tpm/Kconfig"
>  
> +source "drivers/char/txt/Kconfig"
> +
>  config TELCLOCK
>  	tristate "Telecom clock driver for ATCA SBC"
>  	depends on X86
> diff --git a/drivers/char/Makefile b/drivers/char/Makefile
> index 7ff1d0d..301d5b4 100644
> --- a/drivers/char/Makefile
> +++ b/drivers/char/Makefile
> @@ -55,6 +55,7 @@ obj-$(CONFIG_PCMCIA)		+= pcmcia/
>  
>  obj-$(CONFIG_HANGCHECK_TIMER)	+= hangcheck-timer.o
>  obj-$(CONFIG_TCG_TPM)		+= tpm/
> +obj-$(CONFIG_TXT)		+= txt/
>  
>  obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
>  
> diff --git a/drivers/char/txt/Kconfig b/drivers/char/txt/Kconfig
> new file mode 100644
> index 0000000..2e57ef6
> --- /dev/null
> +++ b/drivers/char/txt/Kconfig
> @@ -0,0 +1,18 @@
> +#
> +# intel TXT driver configuration
> +#
> +
> +config INTEL_TXT_DRIVER
> +       tristate "INTEL TXT sysfs driver"

Why isn't this a drivers/platform/x86/ driver?

> +       default m
> +       depends on INTEL_TXT
> +       select SECURITYFS

Or even better yet, a drivers/security/ driver?

> +       ---help---
> +         TXT Driver is expected to be a better tool to access below resources:
> +           - TXT config space
> +           - TXT heap
> +           - Tboot log mem
> +           - SMX parameter
> +
> +         To compile this driver as a module, choose M here; the module will be
> +         called txt.
> diff --git a/drivers/char/txt/Makefile b/drivers/char/txt/Makefile
> new file mode 100644
> index 0000000..3148bb8
> --- /dev/null
> +++ b/drivers/char/txt/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for the intel TXT drivers.
> +#
> +obj-$(CONFIG_TXT) += txt.o
> +txt-y := txt-sysfs.o
> diff --git a/drivers/char/txt/txt-sysfs.c b/drivers/char/txt/txt-sysfs.c
> new file mode 100644
> index 0000000..c56bfe3
> --- /dev/null
> +++ b/drivers/char/txt/txt-sysfs.c
> @@ -0,0 +1,41 @@
> +/*
> + * txt-sysfs.c
> + *
> + * This module is expected to be a better tool to access below resources
> + *   - TXT config space
> + *   - TXT heap
> + *   - Tboot log mem
> + *   - SMX parameter
> + *
> + * Data is currently found below
> + *   /sys/devices/platform/txt/...
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/sysfs.h>
> +
> +#define DEV_NAME "txt"

That's a _very_ generic name.

> +struct platform_device *pdev;

That's a _very_ generic global variable you just created.  Don't.

> +static int __init txt_sysfs_init(void)
> +{
> +	pdev = platform_device_register_simple(DEV_NAME, -1, NULL, 0);
> +	if (IS_ERR(pdev))
> +		return PTR_ERR(pdev);
> +
> +	pr_info("Loading TXT module successfully\n");

We don't care that your driver was loaded, don't be noisy.

> +	return 0;
> +}
> +
> +static void __exit txt_sysfs_exit(void)
> +{
> +	platform_device_unregister(pdev);
> +	pr_info("Unloading TXT module successfully\n");

Same thing here.

Also, isn't there a module_platform_driver() macro you can use intead?

thanks,

greg k-h
