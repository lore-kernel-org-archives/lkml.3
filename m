Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaGVH3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:29:06 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:51192 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbaGVH3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:29:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Matt Porter <mporter@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, Gregory Fong <gregory.0xf0@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v8 02/11] power: reset: Add reboot driver for brcmstb
Date: Tue, 22 Jul 2014 09:28:39 +0200
Message-ID: <62122849.RXJHvac7Iy@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405976886-27807-3-git-send-email-computersforpeace@gmail.com>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com> <1405976886-27807-3-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:AUqKyZrEmDLpxoxqQQz59iPMX/fHhulXzEq0OKbiyS/
 RI9Zkc5d5FE8Btrl9uE4MBDTuMa/0ToiSUiJgpgGt8BcwjIpKk
 EjjAUijD1ml4Ua7IqbOvXg4D76KGhj+LAyKFh9X2lnbqkZgAVL
 d3td1zLnUL9XkZZF4bKfJb/OSO2D+8/MDn7n3wFmlk1dGlFNfQ
 VpdT/gSbm2GxfP8owjz3lJvRaiSaFtQiiyGJzFSpStHW6NYEgh
 H8KhCshtKghgVE4RQP7FwDa5okSW56kZ0vG1WIuAyJUvSO30Sk
 1YUs5VyqTjW7uvEvJjP1bEyfp837XX9ZZCJKG5nG/KUW2oVkcL
 Yd7lhiiATH5JbqLaCQ54=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 July 2014 14:07:57 Brian Norris wrote:
> diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
> index 0073633e7699..9782e8d80647 100644
> --- a/arch/arm/mach-bcm/Kconfig
> +++ b/arch/arm/mach-bcm/Kconfig
> @@ -94,6 +94,7 @@ config ARCH_BRCMSTB
>         select MIGHT_HAVE_PCI
>         select HAVE_SMP
>         select HAVE_ARM_ARCH_TIMER
> +       select POWER_RESET_BRCMSTB
>         help
>           Say Y if you intend to run the kernel on a Broadcom ARM-based STB
>           chipset.
> diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> index bdcf5173e377..fcb9825debe5 100644
> --- a/drivers/power/reset/Kconfig
> +++ b/drivers/power/reset/Kconfig
> @@ -20,6 +20,16 @@ config POWER_RESET_AXXIA
>  
>           Say Y if you have an Axxia family SoC.
>  
> +config POWER_RESET_BRCMSTB
> +       bool "Broadcom STB reset driver"
> +       depends on POWER_RESET && ARCH_BRCMSTB
> +       help
> +         This driver provides restart support for ARM-based Broadcom STB
> +         boards.
> +
> +         Say Y here if you have an ARM-based Broadcom STB board and you wish
> +         to have restart support.
> +
>  config POWER_RESET_GPIO
>         bool "GPIO power-off driver"
>         depends on OF_GPIO && POWER_RESET
> 

(nitpicking)

You shouldn't have both a user-selectable option and 'select' it from
the platform, because it makes it inherently not selectable, in particular
in the combination with 'depends on ARCH_BRCMSTB'.

One way to solve this would be to change the dependency to

config POWER_RESET_BRCMSTB
	bool "Broadcom STB reset driver"
	depends on POWER_RESET && ARM
	depends on ARCH_BRCMSTB || COMPILE_TEST

which in effect would allow building it on any ARM machine as long as
COMPILE_TEST is set (which normally is not).

The same could be expressed using

config POWER_RESET_BRCMSTB
	bool "Broadcom STB reset driver" if COMPILE_TEST
	depends on POWER_RESET && ARM

My preference in this case however would be to just drop the 'select'
statement and add the driver to the defconfig file.

	Arnd
