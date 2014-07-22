Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbaGVVCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:02:42 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53354 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaGVVCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:02:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Brian Norris <computersforpeace@gmail.com>, devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>, Olof Johansson <olof@lixom.net>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v8 02/11] power: reset: Add reboot driver for brcmstb
Date: Tue, 22 Jul 2014 23:02:07 +0200
Message-ID: <5224854.YNJjMxFltp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140722200213.GF28323@ld-irv-0074>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com> <62122849.RXJHvac7Iy@wuerfel> <20140722200213.GF28323@ld-irv-0074>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:YnV/dN3NhyEAyoEA14z3xCxkiTMymq1DLSDvCgYUY0f
 unpeGTk1MQpZaDXWWA8NlLCs04xRpQDVE46F1q9fgTZk3lO1P3
 Sl11dGM1oZlUdRAz5SFVdsN0YyVoL0yJ19Zhh1+NxSBuaK/lzp
 SuIyIKhIdnKti0rSQnRXWLNNtFkDaBbJB1ylwFtdyBSSwepzEb
 IPq6AwRVe1FN3ehS6YzSTQ8oqud7nIDAIdqGMedWXAbJN1U2qW
 dmyMqGPa7ISiDMQAuxqslQ6UvSeg7mJ15qslgBOBHOHeb6n5OK
 0yGDHl4h1al5hL9WIj/x/z/qlo9wBXq+WKxSBnuFfb5iAJ2w0u
 Pzz40D+eri+frde3FzJM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2014 13:02:13 Brian Norris wrote:
> How about a third option, where we drop the 'select' statement and
> set POWER_RESET_BRCMSTB to be 'default y'? Then we don't have to modify
> the defconfig, and it gives the added bonus of choosing a sane default
> even if you're not based on the multi_v7_defconfig. i.e.:
> 
> diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
> index 58c01aed9752..634de7b7fd28 100644
> --- a/arch/arm/mach-bcm/Kconfig
> +++ b/arch/arm/mach-bcm/Kconfig
> @@ -94,7 +94,6 @@ config ARCH_BRCMSTB
>         select MIGHT_HAVE_PCI
>         select HAVE_SMP
>         select HAVE_ARM_ARCH_TIMER
> -       select POWER_RESET_BRCMSTB
>         select BRCMSTB_GISB_ARB
>         select BRCMSTB_L2_IRQ
>         help
> diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> index fcb9825debe5..ab5d57e2766d 100644
> --- a/drivers/power/reset/Kconfig
> +++ b/drivers/power/reset/Kconfig
> @@ -23,6 +23,7 @@ config POWER_RESET_AXXIA
>  config POWER_RESET_BRCMSTB
>         bool "Broadcom STB reset driver"
>         depends on POWER_RESET && ARCH_BRCMSTB
> +       default y
>         help
>           This driver provides restart support for ARM-based Broadcom STB
>           boards.

I don't like this too much. Why do you want to allow disabling the
driver if you make it 'default y' in the first place?

We try to avoid 'default y' for user-selectable drivers in general.
I noticed that in my example, I was missing the default. It should
have been 

config POWER_RESET_BRCMSTB
        bool "Broadcom STB reset driver" if COMPILE_TEST
        depends on POWER_RESET && ARM
	default ARCH_BRCMSTB

This way, it always gets selected when ARCH_BRCMSTB is on and
COMPILE_TEST is off. With COMPILE_TEST enabled, it defaults to
ARCH_BRCMSTB but can be enabled or disabled for the purpose
of compile testing.

	Arnd
