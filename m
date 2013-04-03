Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab3DCXmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 19:42:51 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51369 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761794Ab3DCXms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 19:42:48 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+ptITpGikQPWHtBUNA8IwF
Date: Wed, 3 Apr 2013 16:42:43 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: b-cousson@ti.com, linux@arm.linux.org.uk, rnayak@ti.com, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Paul Walmsley <paul@pwsan.com>
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support
 for AUXCLKs
Message-ID: <20130403234242.GE10155@atomide.com>
References: <1363703220-4777-1-git-send-email-rogerq@ti.com>
 <1363703220-4777-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363703220-4777-2-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Roger Quadros <rogerq@ti.com> [130319 07:31]:
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
...

> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/omap4-clock.txt

Is this really specific to omap4 and auxclk only?

Shouldn't it be just omap-clock.txt?

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

Hmm I don't like the idea of specifying the auxclk both in the
cclock44xx_data.c and in DT..

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

.. and I'm not too keen on adding driver specific stuff to this file.

How about just add a minimal drivers/clk/omap/clk-xyz.c that takes
the configuration from DT and is based on the binding we already have in
Documentation/devicetree/bindings/clock/clock-bindings.txt?

Then as we add new bindings there we can drop them from current
cclock44xx_data.c, no? That is after omap4 is DT only..

Regards,

Tony
