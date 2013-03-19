Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab3CSOam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:30:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36222 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007Ab3CSOal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:30:41 -0400
Message-ID: <51487681.7060301@ti.com>
Date: Tue, 19 Mar 2013 16:30:25 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <b-cousson@ti.com>, <linux@arm.linux.org.uk>,
        <rnayak@ti.com>, <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support for
 AUXCLKs
References: <1363703220-4777-1-git-send-email-rogerq@ti.com> <1363703220-4777-2-git-send-email-rogerq@ti.com>
In-Reply-To: <1363703220-4777-2-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 04:26 PM, Roger Quadros wrote:
> Register a device tree clock provider for AUX clocks
> on the OMAP4 SoC. Also provide the binding information.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  .../devicetree/bindings/clock/omap4-clock.txt      |   32 ++++++++++++++++++
>  arch/arm/boot/dts/omap4.dtsi                       |    5 +++
>  arch/arm/mach-omap2/board-generic.c                |    2 +-
>  arch/arm/mach-omap2/cclock44xx_data.c              |   35 ++++++++++++++++++++
>  arch/arm/mach-omap2/clock44xx.h                    |    1 +
>  arch/arm/mach-omap2/common.h                       |    9 +++++
>  arch/arm/mach-omap2/io.c                           |    6 +++
>  7 files changed, 89 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/omap4-clock.txt
> 
> diff --git a/Documentation/devicetree/bindings/clock/omap4-clock.txt b/Documentation/devicetree/bindings/clock/omap4-clock.txt
> new file mode 100644
> index 0000000..9d5448b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/omap4-clock.txt
> @@ -0,0 +1,32 @@
> +* Clock bindings for Texas Instruments OMAP4 SCRM clocks
> +
> +Required properties:
> +- compatible: Should be "ti,omap4-scrm"
> +- #clock-cells: Should be <1>
> +
> +The clock consumer should specify the desired clock by having the clock
> +ID in its "clocks" phandle cell.  The following is a full list of SCRM
> +clocks and IDs.
> +
> +	Clock		ID
> +	------------------
> +	auxclk0_ck	0
> +	auxclk1_ck	1
> +	auxclk1_ck	1
> +	auxclk1_ck	1
> +	auxclk1_ck	1

Argh! should be 2,3,4,5

> +
> +Example:
> +
> +aux_clks: scrmclks {
> +	compatible = "ti,omap4-scrm";
> +	#clock-cells = <1>;
> +};
> +
> +hsusb1_phy: hsusb1_phy {
> +	compatible = "usb-nop-xceiv";
> +	reset-supply = <&hsusb1_reset>;
> +	clocks = <&aux_clks 3>;
> +	clock-names = "main_clk";
> +	clock-frequency = <19200000>;
> +};
> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> index b7db1a2..97de56c 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -101,6 +101,11 @@
>  			ti,hwmods = "counter_32k";
>  		};
>  
> +		aux_clks: scrmclks {
> +			compatible = "ti,omap4-scrm";
> +			#clock-cells = <1>;
> +		};
> +
>  		omap4_pmx_core: pinmux@4a100040 {
>  			compatible = "ti,omap4-padconf", "pinctrl-single";
>  			reg = <0x4a100040 0x0196>;
> diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
> index 0274ff7..23f2064 100644
> --- a/arch/arm/mach-omap2/board-generic.c
> +++ b/arch/arm/mach-omap2/board-generic.c
> @@ -158,7 +158,7 @@ DT_MACHINE_START(OMAP4_DT, "Generic OMAP4 (Flattened Device Tree)")
>  	.init_irq	= omap_gic_of_init,
>  	.init_machine	= omap_generic_init,
>  	.init_late	= omap4430_init_late,
> -	.init_time	= omap4_local_timer_init,
> +	.init_time	= omap4_init_time,
>  	.dt_compat	= omap4_boards_compat,
>  	.restart	= omap44xx_restart,
>  MACHINE_END
> diff --git a/arch/arm/mach-omap2/cclock44xx_data.c b/arch/arm/mach-omap2/cclock44xx_data.c
> index 3d58f33..bfc46c1 100644
> --- a/arch/arm/mach-omap2/cclock44xx_data.c
> +++ b/arch/arm/mach-omap2/cclock44xx_data.c
> @@ -27,6 +27,7 @@
>  #include <linux/clk-private.h>
>  #include <linux/clkdev.h>
>  #include <linux/io.h>
> +#include <linux/of.h>
>  
>  #include "soc.h"
>  #include "iomap.h"
> @@ -1663,6 +1664,40 @@ static struct omap_clk omap44xx_clks[] = {
>  	CLK(NULL,	"cpufreq_ck",	&dpll_mpu_ck,	CK_443X),
>  };
>  
> +static struct clk *scrm_clks[] = {
> +	&auxclk0_ck,
> +	&auxclk1_ck,
> +	&auxclk2_ck,
> +	&auxclk3_ck,
> +	&auxclk4_ck,
> +	&auxclk5_ck,
> +};
> +
> +static struct clk_onecell_data scrm_data;
> +
> +#ifdef CONFIG_OF
> +int __init omap4_clk_init_dt(void)
> +{
> +	struct device_node *np;
> +
> +	np = of_find_compatible_node(NULL, NULL, "ti,omap4-scrm");
> +	if (np) {
> +		scrm_data.clks = scrm_clks;
> +		scrm_data.clk_num = ARRAY_SIZE(scrm_clks);
> +		of_clk_add_provider(np, of_clk_src_onecell_get,	&scrm_data);
> +	}
> +
> +	return 0;
> +}
> +
> +#else
> +
> +int __init omap4_clk_init_dt(void)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_OF */
> +
>  int __init omap4xxx_clk_init(void)
>  {
>  	u32 cpu_clkflg;
> diff --git a/arch/arm/mach-omap2/clock44xx.h b/arch/arm/mach-omap2/clock44xx.h
> index 287a46f..6395f63 100644
> --- a/arch/arm/mach-omap2/clock44xx.h
> +++ b/arch/arm/mach-omap2/clock44xx.h
> @@ -16,5 +16,6 @@
>  #define OMAP4430_REGM4XEN_MULT	4
>  
>  int omap4xxx_clk_init(void);
> +int omap4_clk_init_dt(void);
>  
>  #endif
> diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
> index 0a6b9c7..1941d1c 100644
> --- a/arch/arm/mach-omap2/common.h
> +++ b/arch/arm/mach-omap2/common.h
> @@ -98,6 +98,7 @@ void am35xx_init_early(void);
>  void ti81xx_init_early(void);
>  void am33xx_init_early(void);
>  void omap4430_init_early(void);
> +void omap4_init_time(void);
>  void omap5_init_early(void);
>  void omap3_init_late(void);	/* Do not use this one */
>  void omap4430_init_late(void);
> @@ -143,6 +144,14 @@ static inline void omap44xx_restart(char mode, const char *cmd)
>  }
>  #endif
>  
> +#ifdef CONFIG_ARCH_OMAP4
> +void omap4_init_time(void);
> +#else
> +static inline void omap4_init_time(void)
> +{
> +}
> +#endif
> +
>  /* This gets called from mach-omap2/io.c, do not call this */
>  void __init omap2_set_globals_tap(u32 class, void __iomem *tap);
>  
> diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
> index 2c3fdd6..c504363 100644
> --- a/arch/arm/mach-omap2/io.c
> +++ b/arch/arm/mach-omap2/io.c
> @@ -603,6 +603,12 @@ void __init omap4430_init_late(void)
>  	omap4_pm_init();
>  	omap2_clk_enable_autoidle_all();
>  }
> +
> +void __init omap4_init_time(void)
> +{
> +	omap4_clk_init_dt();
> +	omap4_local_timer_init();
> +}
>  #endif
>  
>  #ifdef CONFIG_SOC_OMAP5
> 

