Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbbAZMpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:45:53 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:54821 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbbAZMps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:45:48 -0500
Date: Mon, 26 Jan 2015 12:45:31 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        sylvain.rochet@finsecur.com, peda@axentia.se,
        Patrice.VILCHEZ@atmel.com
Subject: Re: [PATCH 4/7] ARM: at91: enable the L2 Cache controller
Message-ID: <20150126124531.GH26493@n2100.arm.linux.org.uk>
References: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
 <1422266836-24592-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422266836-24592-1-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 06:07:16PM +0800, Wenyou Yang wrote:
> +#ifdef CONFIG_CACHE_L2X0
> +static void __init at91_init_l2cache(void)
> +{
> +	struct device_node *np;
> +	u32 reg;
> +
> +	np = of_find_compatible_node(NULL, NULL, "arm,pl310-cache");
> +	if (!np)
> +		return;
> +
> +	at91_l2cc_base = of_iomap(np, 0);
> +	if (!at91_l2cc_base)
> +		panic("unable to map l2cc cpu registers\n");
> +
> +	of_node_put(np);
> +
> +	/* Disable cache if it hasn't been done yet */
> +	if (readl_relaxed(at91_l2cc_base + L2X0_CTRL) & L2X0_CTRL_EN)
> +		writel_relaxed(~L2X0_CTRL_EN, at91_l2cc_base + L2X0_CTRL);
> +
> +	/* Prefetch Control */
> +	reg = readl_relaxed(at91_l2cc_base + L310_PREFETCH_CTRL);
> +	reg &= ~L310_PREFETCH_CTRL_OFFSET_MASK;
> +	reg |= 0x01;
> +	reg |= L310_PREFETCH_CTRL_DBL_LINEFILL_INCR;
> +	reg |= L310_PREFETCH_CTRL_PREFETCH_DROP;
> +	reg |= L310_PREFETCH_CTRL_DATA_PREFETCH;
> +	reg |= L310_PREFETCH_CTRL_INSTR_PREFETCH;
> +	reg |= L310_PREFETCH_CTRL_DBL_LINEFILL;
> +	writel_relaxed(reg, at91_l2cc_base + L310_PREFETCH_CTRL);
> +
> +	/* Power Control */
> +	reg = readl_relaxed(at91_l2cc_base + L310_POWER_CTRL);
> +	reg |= L310_STNDBY_MODE_EN;
> +	reg |= L310_DYNAMIC_CLK_GATING_EN;
> +	writel_relaxed(reg, at91_l2cc_base + L310_POWER_CTRL);
> +
> +	/* Disable interrupts */
> +	writel_relaxed(0x00, at91_l2cc_base + L2X0_INTR_MASK);
> +	writel_relaxed(0x01ff, at91_l2cc_base + L2X0_INTR_CLEAR);

Stop hacking around the core L2x0 code.  None of the above should be
necessary, and is in fact potentially dangerous if the cache was already
previously enabled.  Disabling an already enabled cache is a potential
data corrupting event.

Any of the above configuration should be performed by your boot loader
or board firmware, and if not, then we need DT properties for it.

The last thing we need is platforms buggering around in this way, so
consider this a firm NAK against this approach.

> +	l2x0_of_init(0, ~0UL);
> +}
> +#else
> +static inline void at91_init_l2cache(void) {}
> +#endif
> +
>  static void __init sama5_dt_device_init(void)
>  {
> +	at91_init_l2cache();
> +
>  	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
>  	at91_sam9x5_pm_init();
>  }
> -- 
> 1.7.9.5

In fact, none of this code is necessary.  If you set l2c_aux_mask and
l2c_aux_val (preferably to ~0 and 0 respectively) then the generic ARM
code will initialise the L2 cache in the appropriate way for you.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
