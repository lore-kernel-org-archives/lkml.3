Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab3LWUFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 15:05:46 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:34152 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3LWUFp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 15:05:45 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Pawel Moll <pawel.moll@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1387815830-8794-13-git-send-email-pawel.moll@arm.com>
Cc: "Samuel Ortiz" <sameo@linux.intel.com>, "Arnd Bergmann" <arnd@arndb.de>,
        "Jon Medhurst" <tixy@linaro.org>, arm@kernel.org,
        "Olof Johansson" <olof@lixom.net>, "Pawel Moll" <pawel.moll@arm.com>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
 <1387815830-8794-13-git-send-email-pawel.moll@arm.com>
Message-ID: <20131223200538.25490.67340@quantum>
User-Agent: alot/0.3.5
Subject: Re: [RFC 12/18] clk: versatile: Split config options for sp810 and
 vexpress_osc
Date: Mon, 23 Dec 2013 12:05:38 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pawel Moll (2013-12-23 08:23:44)
> Move the Kconfig entry for Versatile (& Express) clock drivers
> into a separate file and add individual options for sp810
> and vexpress_osc drivers, as they are optional in some
> configurations and may have separate dependencies.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> Cc: Mike Turquette <mturquette@linaro.org>

Is there a reason to continue to expose these as user-visible config
options? I guess that with Device Tree we can just include clock nodes
(or not) for boards that use these clocks (or do not use them).

And it seems for many configurations COMMON_CLK_VERSATILE is always
selected, so what is the point of the other two sub-options?

Thanks,
Mike

> ---
>  drivers/clk/Kconfig            |  9 +--------
>  drivers/clk/versatile/Kconfig  | 26 ++++++++++++++++++++++++++
>  drivers/clk/versatile/Makefile |  5 +++--
>  3 files changed, 30 insertions(+), 10 deletions(-)
>  create mode 100644 drivers/clk/versatile/Kconfig
> 
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 5c51115..f5486a4 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -40,14 +40,7 @@ config COMMON_CLK_WM831X
>            Supports the clocking subsystem of the WM831x/2x series of
>           PMICs from Wolfson Microlectronics.
>  
> -config COMMON_CLK_VERSATILE
> -       bool "Clock driver for ARM Reference designs"
> -       depends on ARCH_INTEGRATOR || ARCH_REALVIEW || ARCH_VEXPRESS || ARM64
> -       ---help---
> -          Supports clocking on ARM Reference designs:
> -         - Integrator/AP and Integrator/CP
> -         - RealView PB1176, EB, PB11MP and PBX
> -         - Versatile Express
> +source "drivers/clk/versatile/Kconfig"
>  
>  config COMMON_CLK_MAX77686
>         tristate "Clock driver for Maxim 77686 MFD"
> diff --git a/drivers/clk/versatile/Kconfig b/drivers/clk/versatile/Kconfig
> new file mode 100644
> index 0000000..1530c93
> --- /dev/null
> +++ b/drivers/clk/versatile/Kconfig
> @@ -0,0 +1,26 @@
> +config COMMON_CLK_VERSATILE
> +       bool "Clock driver for ARM Reference designs"
> +       depends on ARCH_INTEGRATOR || ARCH_REALVIEW || ARCH_VEXPRESS || ARM64
> +       ---help---
> +          Supports clocking on ARM Reference designs:
> +         - Integrator/AP and Integrator/CP
> +         - RealView PB1176, EB, PB11MP and PBX
> +         - Versatile Express
> +
> +config CLK_SP810
> +       bool "Clock driver for ARM SP810 System Controller"
> +       depends on COMMON_CLK_VERSATILE
> +       default y if ARCH_VEXPRESS
> +       ---help---
> +         Supports clock muxing (REFCLK/TIMCLK to TIMERCLKEN0-3) capabilities
> +         of the ARM SP810 System Controller cell.
> +
> +config CLK_VEXPRESS_OSC
> +       bool "Clock driver for Versatile Express OSC clock generators"
> +       depends on COMMON_CLK_VERSATILE
> +       depends on VEXPRESS_CONFIG
> +       default y if ARCH_VEXPRESS
> +       ---help---
> +         Simple regmap-based driver driving clock generators on Versatile
> +         Express platforms hidden behind its configuration infrastructure,
> +         commonly known as OSCs.
> diff --git a/drivers/clk/versatile/Makefile b/drivers/clk/versatile/Makefile
> index c16ca78..fd449f9 100644
> --- a/drivers/clk/versatile/Makefile
> +++ b/drivers/clk/versatile/Makefile
> @@ -3,5 +3,6 @@ obj-$(CONFIG_ICST)              += clk-icst.o
>  obj-$(CONFIG_ARCH_INTEGRATOR)  += clk-integrator.o
>  obj-$(CONFIG_INTEGRATOR_IMPD1) += clk-impd1.o
>  obj-$(CONFIG_ARCH_REALVIEW)    += clk-realview.o
> -obj-$(CONFIG_ARCH_VEXPRESS)    += clk-vexpress.o clk-sp810.o
> -obj-$(CONFIG_VEXPRESS_CONFIG)  += clk-vexpress-osc.o
> +obj-$(CONFIG_ARCH_VEXPRESS)    += clk-vexpress.o
> +obj-$(CONFIG_CLK_SP810)                += clk-sp810.o
> +obj-$(CONFIG_CLK_VEXPRESS_OSC) += clk-vexpress-osc.o
> -- 
> 1.8.3.2
> 
> 
