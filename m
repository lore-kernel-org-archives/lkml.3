Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423105Ab3CWCYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 22:24:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34138 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422725Ab3CWCYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 22:24:53 -0400
Message-ID: <514D1273.8070902@wwwdotorg.org>
Date: Fri, 22 Mar 2013 20:24:51 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        linux-rpi-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: Add Broadcom BCM2708 watchdog timer driver
References: <1363956907-5644-1-git-send-email-lkundrak@v3.sk>
In-Reply-To: <1363956907-5644-1-git-send-email-lkundrak@v3.sk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 06:55 AM, Lubomir Rintel wrote:
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

A commit description would be useful.

>  arch/arm/configs/bcm2835_defconfig |    4 +
>  drivers/watchdog/Kconfig           |   11 +++
>  drivers/watchdog/Makefile          |    1 +
>  drivers/watchdog/bcm2835_wdt.c     |  158 ++++++++++++++++++++++++++++++++++++

The changes to bcm2835_defconfig should be a separate patch, since they
would be applied in the BCM2835 ARM sub-arch tree, whereas the driver
patch would be applied to the watchdog driver tree.

> diff --git a/arch/arm/configs/bcm2835_defconfig b/arch/arm/configs/bcm2835_defconfig

> +CONFIG_BCM2835_WDT=y
> +
>  CONFIG_MMC=y

That blank line is a little odd; was this defconfig change created using
"make savedefconfig"?

> diff --git a/drivers/watchdog/bcm2835_wdt.c b/drivers/watchdog/bcm2835_wdt.c

> +static int heartbeat = -1;
> +static bool nowayout = WATCHDOG_NOWAYOUT;
> +static void __iomem *wdt_regs;
> +static DEFINE_SPINLOCK(wdog_lock);

Can these be stored in a dynamically-allocated structure, stored in the
device's drvdata?

> +static struct platform_driver bcm2835_wdt_driver = {
...
> +};
> +
> +module_platform_driver(bcm2835_wdt_driver);

I believe it's typical not to leave a blank line before
module_platform_driver();

A couple of general comments:

1)

This driver touches the same registers that
arch/arm/mach-bcm2835/bcm2835.c uses to implement reboot and "power
off". Some co-ordination might be necessary.

The implementation of bcm2835_power_off() could easily be moved into
this driver, to avoid some of the need for co-ordination.

Moving bcm2835_restart() would be more tricky, since the ARM machine
descriptor needs a pointer to that function. I guess the kernel probably
ensures that none of the code in this watchdog driver is running by the
time bcm2835_restart() is called, although perhaps it'd be better to
have mach-bcm2835/bcm2835.c and this driver share a lock?

2)

I'm curious where you got the documentation to write this driver; this
HW module isn't described in BCM2835-ARM-Peripherals.pdf. I assume this
is based on the downstream kernel driver? If so, at least some credit in
the commit description might be appropriate. At least the relevant
commit downstream already has an appropriate Signed-off-by line:-)
