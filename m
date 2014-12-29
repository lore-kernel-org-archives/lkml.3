Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaL2SYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 13:24:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45853 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbaL2SYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 13:24:08 -0500
Message-ID: <54A19C17.1020909@ti.com>
Date: Mon, 29 Dec 2014 12:23:19 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, <lauraa@codeaurora.org>,
        <linus.walleij@linaro.org>, <tony@atomide.com>, <drake@endlessm.com>,
        <loeliger@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        <khilman@linaro.org>
Subject: Re: [PATCH v10 2/8] ARM: l2c: Refactor the driver to use commit-like
 interface
References: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com> <1419331716-8972-3-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1419331716-8972-3-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2014 04:48 AM, Marek Szyprowski wrote:

> -static void l2c310_resume(void)
> +static void l2c310_configure(void __iomem *base)
>  {
> -	void __iomem *base = l2x0_base;
> +	unsigned revision;
>  
> -	if (!(readl_relaxed(base + L2X0_CTRL) & L2X0_CTRL_EN)) {
> -		unsigned revision;
> -
> -		/* restore pl310 setup */
> -		writel_relaxed(l2x0_saved_regs.tag_latency,
> -			       base + L310_TAG_LATENCY_CTRL);
> -		writel_relaxed(l2x0_saved_regs.data_latency,
> -			       base + L310_DATA_LATENCY_CTRL);
> -		writel_relaxed(l2x0_saved_regs.filter_end,
> -			       base + L310_ADDR_FILTER_END);
> -		writel_relaxed(l2x0_saved_regs.filter_start,
> -			       base + L310_ADDR_FILTER_START);
> -
> -		revision = readl_relaxed(base + L2X0_CACHE_ID) &
> -				L2X0_CACHE_ID_RTL_MASK;
> -
> -		if (revision >= L310_CACHE_ID_RTL_R2P0)
> -			l2c_write_sec(l2x0_saved_regs.prefetch_ctrl, base,
> -				      L310_PREFETCH_CTRL);
> -		if (revision >= L310_CACHE_ID_RTL_R3P0)
> -			l2c_write_sec(l2x0_saved_regs.pwr_ctrl, base,
> -				      L310_POWER_CTRL);
> -
> -		l2c_enable(base, l2x0_saved_regs.aux_ctrl, 8);
> -
> -		/* Re-enable full-line-of-zeros for Cortex-A9 */
> -		if (l2x0_saved_regs.aux_ctrl & L310_AUX_CTRL_FULL_LINE_ZERO)
> -			set_auxcr(get_auxcr() | BIT(3) | BIT(2) | BIT(1));
> -	}
> +	/* restore pl310 setup */
> +	writel_relaxed(l2x0_saved_regs.tag_latency,
> +		       base + L310_TAG_LATENCY_CTRL);
> +	writel_relaxed(l2x0_saved_regs.data_latency,
> +		       base + L310_DATA_LATENCY_CTRL);
> +	writel_relaxed(l2x0_saved_regs.filter_end,
> +		       base + L310_ADDR_FILTER_END);
> +	writel_relaxed(l2x0_saved_regs.filter_start,
> +		       base + L310_ADDR_FILTER_START);
> +

^^ The above change broke AM437xx. Looks like the change causes the
following behavior difference on AM437x. For some reason, touching any
of the above 4 registers(even with the values read from the same
registers) causes AM437x to go beserk. Comment the 4 writes and we
reach shell. looks like l2c310_resume is not invoked prior to this
series. :(.. now that we reuse that logic to actually do programming,
we start to see the problem.

one option might be to write only those registers that differ from
saved_registers (example: unmodified values dont need reprogramming).

Looks like the following also need addressing:
data->save is called twice (once more after l2cof_init)
l2c310_init_fns also needs l2c310_configure
will be nice to use l2x0_data only after we kmemdup data in __l2c_init

if you'd like to split this up in pieces, [1] might be nice - will go
good to change the pl310, aurora etc in each chunks to enable better
review.

[1]
https://github.com/nmenon/linux-2.6-playground/commits/temp/l2c-patch2-splitup

-- 
Regards,
Nishanth Menon
