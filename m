Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbaGVUCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:02:19 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:63489 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663AbaGVUCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:02:17 -0400
Date: Tue, 22 Jul 2014 13:02:13 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
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
Message-ID: <20140722200213.GF28323@ld-irv-0074>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
 <1405976886-27807-3-git-send-email-computersforpeace@gmail.com>
 <62122849.RXJHvac7Iy@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62122849.RXJHvac7Iy@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 09:28:39AM +0200, Arnd Bergmann wrote:
> On Monday 21 July 2014 14:07:57 Brian Norris wrote:
> > diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
> > index 0073633e7699..9782e8d80647 100644
> > --- a/arch/arm/mach-bcm/Kconfig
> > +++ b/arch/arm/mach-bcm/Kconfig
> > @@ -94,6 +94,7 @@ config ARCH_BRCMSTB
> >         select MIGHT_HAVE_PCI
> >         select HAVE_SMP
> >         select HAVE_ARM_ARCH_TIMER
> > +       select POWER_RESET_BRCMSTB
> >         help
> >           Say Y if you intend to run the kernel on a Broadcom ARM-based STB
> >           chipset.
> > diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> > index bdcf5173e377..fcb9825debe5 100644
> > --- a/drivers/power/reset/Kconfig
> > +++ b/drivers/power/reset/Kconfig
> > @@ -20,6 +20,16 @@ config POWER_RESET_AXXIA
> >  
> >           Say Y if you have an Axxia family SoC.
> >  
> > +config POWER_RESET_BRCMSTB
> > +       bool "Broadcom STB reset driver"
> > +       depends on POWER_RESET && ARCH_BRCMSTB
> > +       help
> > +         This driver provides restart support for ARM-based Broadcom STB
> > +         boards.
> > +
> > +         Say Y here if you have an ARM-based Broadcom STB board and you wish
> > +         to have restart support.
> > +
> >  config POWER_RESET_GPIO
> >         bool "GPIO power-off driver"
> >         depends on OF_GPIO && POWER_RESET
> > 
> 
> (nitpicking)
> 
> You shouldn't have both a user-selectable option and 'select' it from
> the platform, because it makes it inherently not selectable, in particular
> in the combination with 'depends on ARCH_BRCMSTB'.

OK, thanks for the comment. Note that there is some precedent for this
bad Kconfig behavior in the same subsystem (POWER_RESET_GPIO and
POWER_RESET_VEXPRESS are both 'select'ed in arch/arm/mach-*/Kconfig).

[...]
> My preference in this case however would be to just drop the 'select'
> statement and add the driver to the defconfig file.

How about a third option, where we drop the 'select' statement and
set POWER_RESET_BRCMSTB to be 'default y'? Then we don't have to modify
the defconfig, and it gives the added bonus of choosing a sane default
even if you're not based on the multi_v7_defconfig. i.e.:

diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index 58c01aed9752..634de7b7fd28 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -94,7 +94,6 @@ config ARCH_BRCMSTB
 	select MIGHT_HAVE_PCI
 	select HAVE_SMP
 	select HAVE_ARM_ARCH_TIMER
-	select POWER_RESET_BRCMSTB
 	select BRCMSTB_GISB_ARB
 	select BRCMSTB_L2_IRQ
 	help
diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index fcb9825debe5..ab5d57e2766d 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -23,6 +23,7 @@ config POWER_RESET_AXXIA
 config POWER_RESET_BRCMSTB
 	bool "Broadcom STB reset driver"
 	depends on POWER_RESET && ARCH_BRCMSTB
+	default y
 	help
 	  This driver provides restart support for ARM-based Broadcom STB
 	  boards.

Brian
