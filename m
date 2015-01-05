Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbbAERVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:21:14 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40814 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbbAERVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:21:12 -0500
Date: Mon, 5 Jan 2015 11:20:29 -0600
From: Nishanth Menon <nm@ti.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, <lauraa@codeaurora.org>,
        <linus.walleij@linaro.org>, <tony@atomide.com>, <drake@endlessm.com>,
        <loeliger@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        <khilman@linaro.org>
Subject: Re: [PATCH v11 2/9] ARM: l2c: use l2c_write_sec() for restoring
 latency and filter regs
Message-ID: <20150105172028.GA19579@kahuna>
References: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
 <1420460348-20302-3-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1420460348-20302-3-git-send-email-m.szyprowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:19-20150105, Marek Szyprowski wrote:
> All four register for latency and filter settings cannot be written in
> non-secure mode and they should go through l2c_write_sec(). More on this
> can be found in CoreLink Level 2 Cache Controller L2C-310 Technical
> Reference Manual, 3.2. Register summary, table 3.1. This have been checked
> the TRM for r3p3, but it should be uniform for all revisions.
> 
> Reported-by: Nishanth Menon <nm@ti.com>
> Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  arch/arm/mm/cache-l2x0.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
> index 5e65ca8dea62..0aeeaa95c42d 100644
> --- a/arch/arm/mm/cache-l2x0.c
> +++ b/arch/arm/mm/cache-l2x0.c
> @@ -623,14 +623,14 @@ static void l2c310_resume(void)
>  		unsigned revision;
>  
>  		/* restore pl310 setup */
> -		writel_relaxed(l2x0_saved_regs.tag_latency,
> -			       base + L310_TAG_LATENCY_CTRL);
> -		writel_relaxed(l2x0_saved_regs.data_latency,
> -			       base + L310_DATA_LATENCY_CTRL);
> -		writel_relaxed(l2x0_saved_regs.filter_end,
> -			       base + L310_ADDR_FILTER_END);
> -		writel_relaxed(l2x0_saved_regs.filter_start,
> -			       base + L310_ADDR_FILTER_START);
> +		l2c_write_sec(l2x0_saved_regs.tag_latency, base,
> +			      L310_TAG_LATENCY_CTRL);
> +		l2c_write_sec(l2x0_saved_regs.data_latency, base,
> +			      L310_DATA_LATENCY_CTRL);
> +		l2c_write_sec(l2x0_saved_regs.filter_end, base,
> +			      L310_ADDR_FILTER_END);
> +		l2c_write_sec(l2x0_saved_regs.filter_start, base,
> +			      L310_ADDR_FILTER_START);
>  
>  		revision = readl_relaxed(base + L2X0_CACHE_ID) &
>  				L2X0_CACHE_ID_RTL_MASK;
Do you need the following as well at this point in the patch series?
Agreed that the writes will disappear later in the series.

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 0aeeaa9..7afab37 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -1135,28 +1135,28 @@ static void __init l2c310_of_parse(const struct device_node *np,
 
 	of_property_read_u32_array(np, "arm,tag-latency", tag, ARRAY_SIZE(tag));
 	if (tag[0] && tag[1] && tag[2])
-		writel_relaxed(
+		l2c_write_sec(
 			L310_LATENCY_CTRL_RD(tag[0] - 1) |
 			L310_LATENCY_CTRL_WR(tag[1] - 1) |
 			L310_LATENCY_CTRL_SETUP(tag[2] - 1),
-			l2x0_base + L310_TAG_LATENCY_CTRL);
+			l2x0_base, L310_TAG_LATENCY_CTRL);
 
 	of_property_read_u32_array(np, "arm,data-latency",
 				   data, ARRAY_SIZE(data));
 	if (data[0] && data[1] && data[2])
-		writel_relaxed(
+		l2c_write_sec(
 			L310_LATENCY_CTRL_RD(data[0] - 1) |
 			L310_LATENCY_CTRL_WR(data[1] - 1) |
 			L310_LATENCY_CTRL_SETUP(data[2] - 1),
-			l2x0_base + L310_DATA_LATENCY_CTRL);
+			l2x0_base,  L310_DATA_LATENCY_CTRL);
 
 	of_property_read_u32_array(np, "arm,filter-ranges",
 				   filter, ARRAY_SIZE(filter));
 	if (filter[1]) {
-		writel_relaxed(ALIGN(filter[0] + filter[1], SZ_1M),
-			       l2x0_base + L310_ADDR_FILTER_END);
-		writel_relaxed((filter[0] & ~(SZ_1M - 1)) | L310_ADDR_FILTER_EN,
-			       l2x0_base + L310_ADDR_FILTER_START);
+		l2c_write_sec(ALIGN(filter[0] + filter[1], SZ_1M),
+			       l2x0_base, L310_ADDR_FILTER_END);
+		l2c_write_sec((filter[0] & ~(SZ_1M - 1)) | L310_ADDR_FILTER_EN,
+			       l2x0_base, L310_ADDR_FILTER_START);
 	}
 
 	ret = l2x0_cache_size_of_parse(np, aux_val, aux_mask, &assoc, SZ_512K);
 
-- 
Regards,
Nishanth Menon
