Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaF3QMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:12:23 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36248 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaF3QMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:12:21 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-c5-53b18c61f6d1
Message-id: <53B18C46.9010405@samsung.com>
Date: Mon, 30 Jun 2014 18:11:50 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
Subject: Re: [PATCH v5 1/5] ARM: EXYNOS: Add support for mapping PMU base
 address via DT
References: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
 <1403705032-14835-2-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1403705032-14835-2-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xK7qJPRuDDf7MVLFYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWq6FjGaHHz2XYmB26PluYeNo/N
	S+o9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK+Pg7I+sBdf4Kh42f2JtYLzI3cXIySEhYCLx
	/eB3FghbTOLCvfVsXYxcHEICSxklTp/exwzhfGaU+H1+ARNIFa+AlsTTny/ZQWwWAVWJO/OP
	soHYbAJqEp8bHoHZ/EA1a5quA03l4BAViJB4fEEIolVQ4sfkeywgM0UEpjFKXLx0mx3EYRZY
	wiixZ8YpRpAqYYEoiQVXusAGCQm0M0qcmq8JYnMKeEp8nfAUbDGzgI7E/tZpbBC2vMTmNW+Z
	JzAKzkKyZBaSsllIyhYwMq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECImMLzsYFx+zOsQo
	wMGoxMPbuGJDsBBrYllxZe4hRgkOZiUR3ps+G4OFeFMSK6tSi/Lji0pzUosPMTJxcEo1MM4+
	GJkhYH0+N+UIt7/t0mVipqGLXtawLrt94E70Y1e9ZVnSXFH+eeav1tgpszbMliic08V92/ro
	+rnZ2jZ3S/y/N0469ud3zsWJSpMZXE2DTcN3f9dyulsSJbZK8o1VsMTEb+uPf3qnWrpS16nd
	xGzWtRndl/ZXSxh8vfj0mcdMj0W3bPYWuSqxFGckGmoxFxUnAgAhZMJxagIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

In general the patch seems quite nice, but please see few comments inline.

On 25.06.2014 16:03, Pankaj Dubey wrote:
> Add support for mapping Samsung Power Management Unit (PMU)
> base address from device tree.
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  arch/arm/mach-exynos/common.h |    1 +
>  arch/arm/mach-exynos/exynos.c |   45 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 46 insertions(+)

[snip]

> +static void exynos_map_pmu(void)
> +{
> +	struct device_node *np = NULL;

nit: Unnecessary variable initialization.

> +
> +	np = of_find_matching_node(NULL, exynos_dt_pmu_match);
> +

nit: Unnecessary blank line.

> +	if (!np) {
> +		pr_err("Failed to find PMU node\n");
> +		return;

Returning here probably doesn't make too much sense, especially when you
just panic if the mapping fails and you remove the static mapping in
patch 2/5, so backwards compatibility isn't provided anyway.

So something like this might be a better idea:

	np = of_find_matching_node(NULL, exynos_dt_pmu_match);
	if (np)
		pmu_base_addr = of_iomap(np, 0);

	if (!pmu_base_addr)
		panic("failed to find exynos pmu register\n");

> +	}
> +
> +	pmu_base_addr = of_iomap(np, 0);
> +
> +	if (!pmu_base_addr)
> +		panic("failed to find exynos pmu register\n");
> +}
> +
> +static void __init exynos_init_time(void)
> +{
> +	/* Nothing to do timer specific.
> +	 * Since platsmp.c needs pmu base address by the time
> +	 * DT is not unflatten so we can't use DT APIs before
> +	 * init_time
> +	 */
> +	exynos_map_pmu();

Would moving this to .init_irq() callback work too? There are more
things happening in .init_time() so it seems more fragile and some
platforms (e.g. mach-tegra) do such platform-specific initialization in
.init_irq() instead.

Best regards,
Tomasz
