Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab3FYMGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:06:47 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:50632 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3FYMGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:06:45 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: warning: PINCTRL_BAYTRAIL etc. selects IRQ_DOMAIN which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS)
To: Linus Walleij <linus.walleij@linaro.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, kbuild-all@01.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <CACxGe6tHb4BKKi4XccM3RaJoippHygKtMyB4gf+p79Reg572pw@mail.gmail.com>
References: <51c3565e.4pKZ3AC1Ra7xI3K/%fengguang.wu@intel.com> <20130621014637.GB16693@localhost> <CACRpkdYfNe0av3-U7KEiqOQNCkM=YTrgHTwq4oMkoCXQ1Y0Dgw@mail.gmail.com> <20130624142826.AA34E3E0A89@localhost> <CACxGe6tHb4BKKi4XccM3RaJoippHygKtMyB4gf+p79Reg572pw@mail.gmail.com>
Date: Tue, 25 Jun 2013 13:06:40 +0100
Message-Id: <20130625120640.428FF3E113B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jun 2013 15:41:46 +0100, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, Jun 24, 2013 at 3:28 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> > On Mon, 24 Jun 2013 13:44:34 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> >> On Fri, Jun 21, 2013 at 3:46 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> >>
> >> config: make ARCH=s390 allmodconfig
> >> (...)
> >> > warning: (ARM_GIC && ARM_VIC && ORION_IRQCHIP && RENESAS_INTC_IRQPIN && RENESAS_IRQC && VERSATILE_FPGA_IRQ && REGMAP && PINCTRL_BAYTRAIL && GPIO_LYNXPOINT && GPIO_GRGPIO && GPIO_PCF857X && GPIO_LANGWELL && MFD_CORE && MFD_MAX77686 && MFD_MAX8997 && AB8500_CORE && MFD_LP8788 && MFD_TPS65910 && TWL4030_CORE && MFD_WM831X_I2C && MFD_WM831X_SPI && EXTCON_MAX77693) selects IRQ_DOMAIN which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS)
> >>
> >> Hm I wonder how you actually fix this...
> >>
> >> This must be the offending Kconfig fragment:
> >>
> >> config PINCTRL_BAYTRAIL
> >>         bool "Intel Baytrail GPIO pin control"
> >>         depends on GPIOLIB && ACPI && X86
> >>         select IRQ_DOMAIN
> >
> > I get that warning on gpio/next which doesn't have the PINCTRL_BAYTRAIL
> > defined. I don't think this is caused by that hunk. The problem exists
> > in mainline (v3.10-rc7) also.
> >
> > g.
> 
> It bisects down to the following commit, but reverting it doesn't
> solve the problem. I haven't looked deeper, but I expect that further
> patches have done something similar of pulling in IRQ_DOMAIN, quite
> possibly other MFD drivers, but not necessarily.
> 
> g.

I've tracked it down to the following config args:

CONFIG_REGMAP_IRQ
CONFIG_MFD_CORE

Both unconditionally select IRQ_DOMAIN, which would be fine except that
IRQ_DOMAIN depends on HAVE_GENERIC_HARDIRQS.

s390 is the only architecture that does not enable
CONFIG_HAVE_GENERIC_HARDIRQS... maybe it's time to fix that.

g.

> 
> commit 5a324acfce6f7f05ab2a044f7d0ece5f44e812c6
> Author: David Rientjes <rientjes@google.com>
> Date:   Thu Mar 21 12:08:33 2013 -0700
> 
>     mfd: cros_ec: Add MFD_CORE dependency
> 
>     CONFIG_MFD_CROS_EC requires CONFIG_MFD_CORE for a couple of functions that
>     are declared but not defined:
> 
>         ERROR: "mfd_remove_devices" [drivers/mfd/cros_ec.ko] undefined!
>         ERROR: "mfd_add_devices" [drivers/mfd/cros_ec.ko] undefined!
> 
>     Fix it by selecting CONFIG_MFD_CORE anytime CONFIG_MFD_CROS_EC is enabled.
> 
>     Signed-off-by: David Rientjes <rientjes@google.com>
>     Acked-by: Simon Glass <sjg@chromium.org>
>     Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 94b4547..67e56dc 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -23,6 +23,7 @@ config MFD_88PM860X
> 
>  config MFD_CROS_EC
>         tristate "Support ChromeOS Embedded Controller"
> +       select MFD_CORE
>         help
>           If you say Y here you get support for the ChromeOS Embedded
>           Controller (EC) providing keyboard, battery and power services.

-- 
email sent from notmuch.vim plugin
