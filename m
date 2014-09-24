Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaIXLOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:14:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36383 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124AbaIXLOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:14:50 -0400
Date: Wed, 24 Sep 2014 12:14:47 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "lauraa@codeaurora.org" <lauraa@codeaurora.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "drake@endlessm.com" <drake@endlessm.com>,
        "loeliger@gmail.com" <loeliger@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v5 4/7] ARM: l2c: Add support for overriding prefetch
 settings
Message-ID: <20140924111446.GE5729@leverpostej>
References: <1411556741-5810-1-git-send-email-m.szyprowski@samsung.com>
 <1411556741-5810-5-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411556741-5810-5-git-send-email-m.szyprowski@samsung.com>
Thread-Topic: [PATCH v5 4/7] ARM: l2c: Add support for overriding prefetch
 settings
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:05:38PM +0100, Marek Szyprowski wrote:
> From: Tomasz Figa <t.figa@samsung.com>
> 
> Firmware on certain boards (e.g. ODROID-U3) can leave incorrect L2C prefetch
> settings configured in registers leading to crashes if L2C is enabled
> without overriding them. This patch introduces bindings to enable
> prefetch settings to be specified from DT and necessary support in the
> driver.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  Documentation/devicetree/bindings/arm/l2cc.txt | 10 +++++++
>  arch/arm/mm/cache-l2x0.c                       | 39 ++++++++++++++++++++++++++
>  2 files changed, 49 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
> index af527ee111c2..3443d2d76788 100644
> --- a/Documentation/devicetree/bindings/arm/l2cc.txt
> +++ b/Documentation/devicetree/bindings/arm/l2cc.txt
> @@ -47,6 +47,16 @@ Optional properties:
>  - cache-id-part: cache id part number to be used if it is not present
>    on hardware
>  - wt-override: If present then L2 is forced to Write through mode
> +- arm,double-linefill : Override double linefill enable setting. Enable if
> +  non-zero, disable if zero.
> +- arm,double-linefill-incr : Override double linefill on INCR read. Enable
> +  if non-zero, disable if zero.
> +- arm,double-linefill-wrap : Override double linefill on WRAP read. Enable
> +  if non-zero, disable if zero.
> +- arm,prefetch-drop : Override prefetch drop enable setting. Enable if non-zero,
> +  disable if zero.

I'm not too keen on tristate properties. Is this level of flexibility
really required?

What exact overrides do you need for boards you know of? Why do these
cause crashes if not overridden?

Mark.

> +- arm,prefetch-offset : Override prefetch offset value. Valid values are
> +  0-7, 15, 23, and 31.
>  
>  Example:
>  
> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
> index 84c6c55ab896..af90a6ff6b49 100644
> --- a/arch/arm/mm/cache-l2x0.c
> +++ b/arch/arm/mm/cache-l2x0.c
> @@ -1059,6 +1059,8 @@ static void __init l2c310_of_parse(const struct device_node *np,
>  	u32 data[3] = { 0, 0, 0 };
>  	u32 tag[3] = { 0, 0, 0 };
>  	u32 filter[2] = { 0, 0 };
> +	u32 prefetch;
> +	u32 val;
>  
>  	of_property_read_u32_array(np, "arm,tag-latency", tag, ARRAY_SIZE(tag));
>  	if (tag[0] && tag[1] && tag[2])
> @@ -1083,6 +1085,43 @@ static void __init l2c310_of_parse(const struct device_node *np,
>  		l2x0_saved_regs.filter_start = (filter[0] & ~(SZ_1M - 1))
>  					| L310_ADDR_FILTER_EN;
>  	}
> +
> +	prefetch = l2x0_saved_regs.prefetch_ctrl;
> +
> +	if (!of_property_read_u32(np, "arm,double-linefill", &val)) {
> +		if (val)
> +			prefetch |= L310_PREFETCH_CTRL_DBL_LINEFILL;
> +		else
> +			prefetch &= ~L310_PREFETCH_CTRL_DBL_LINEFILL;
> +	}
> +
> +	if (!of_property_read_u32(np, "arm,double-linefill-incr", &val)) {
> +		if (val)
> +			prefetch |= L310_PREFETCH_CTRL_DBL_LINEFILL_INCR;
> +		else
> +			prefetch &= ~L310_PREFETCH_CTRL_DBL_LINEFILL_INCR;
> +	}
> +
> +	if (!of_property_read_u32(np, "arm,double-linefill-wrap", &val)) {
> +		if (!val)
> +			prefetch |= L310_PREFETCH_CTRL_DBL_LINEFILL_WRAP;
> +		else
> +			prefetch &= ~L310_PREFETCH_CTRL_DBL_LINEFILL_WRAP;
> +	}
> +
> +	if (!of_property_read_u32(np, "arm,prefetch-drop", &val)) {
> +		if (val)
> +			prefetch |= L310_PREFETCH_CTRL_PREFETCH_DROP;
> +		else
> +			prefetch &= ~L310_PREFETCH_CTRL_PREFETCH_DROP;
> +	}
> +
> +	if (!of_property_read_u32(np, "arm,prefetch-offset", &val)) {
> +		prefetch &= ~L310_PREFETCH_CTRL_OFFSET_MASK;
> +		prefetch |= val & L310_PREFETCH_CTRL_OFFSET_MASK;
> +	}
> +
> +	l2x0_saved_regs.prefetch_ctrl = prefetch;
>  }
>  
>  static const struct l2c_init_data of_l2c310_data __initconst = {
> -- 
> 1.9.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
