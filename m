Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbaGPKtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:49:40 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34650 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaGPKtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:49:36 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-06-53c658b52f3e
Message-id: <53C65890.8000500@samsung.com>
Date: Wed, 16 Jul 2014 12:48:48 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RESEND PATCH v2] ARM: exynos4: hotplug: Fix CPU idle clock down
 after CPU off
References: <1405499003-9975-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1405499003-9975-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xq7pbI44FG7ycqmWxccZ6VovXLwwt
	ehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8FmuP3GV34PRoae5h89i8pN6jb8sqRo/P
	m+QCWKK4bFJSczLLUov07RK4Mua+7WUpmMFVsfz0OpYGxmkcXYycHBICJhLLzhxjhbDFJC7c
	W8/WxcjFISSwlFGibcM0ZpCEkMBnRokX79VBbF4BLYkXJ++ygdgsAqoSN5ZNBathE1CT+Nzw
	CCzOD1Szpuk6SxcjB4eoQITE4wtCEK2CEj8m32MBmS8i8JJRYu/hCWAOs8AURonmSUuZQKqE
	BWIldvTMZ4RY7Cbxfc0pMJtTwF3i4OVfYDazgI7E/tZpbBC2vMTmNW+ZJzAKzkKyZBaSsllI
	yhYwMq9iFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECImBrzsYlx6zOsQowMGoxMPLMPtosBBr
	YllxZe4hRgkOZiURXgf/Y8FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGKeui/52WC1t8oTLn1tC
	tJj8xD/+0k45orjlHKN+YcaSp/2fYlZbnN2Zcdr/z6dz5Rcjt83fXNGTv3nyXXFl1uVhJ98E
	BWSdSXjd7Pruua7wlzNfdUV8gxLCI3tSRTLmOPcY53hPXtrnZdUxJ+efZmpoYQZTY84DFqWs
	rjeTEjcbiT2fdvKdmxJLcUaioRZzUXEiAINJ0HlfAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

Please see my comment below.

On 16.07.2014 10:23, Krzysztof Kozlowski wrote:
> On Exynos4 USE_DELAYED_RESET_ASSERTION must be set in
> ARM_COREx_OPTION register during CPU power down. This is the proper way
> of powering down CPU on Exynos4.
> 
> Additionally on Exynos4212 without this the CPU clock down feature won't
> work after powering down some CPU and the online CPUs will work at full
> frequency chosen by CPUfreq governor.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

[snip]

> @@ -36,6 +36,14 @@ static inline void cpu_leave_lowpower(void)
>  	  : "=&r" (v)
>  	  : "Ir" (CR_C), "Ir" (0x40)
>  	  : "cc");
> +
> +	if (soc_is_exynos4()) {
> +		unsigned int tmp;
> +
> +		tmp = __raw_readl(EXYNOS_ARM_CORE_OPTION(core_id));
> +		tmp &= ~(S5P_USE_DELAYED_RESET_ASSERTION);
> +		__raw_writel(tmp, EXYNOS_ARM_CORE_OPTION(core_id));
> +	}

This code is executed only if the CPU doesn't manage to power off before
already receiving a wake-up event. Otherwise the context is lost after
wfi(), as the core power is being cut down.

The normal wake-up path goes through platsmp's exynos_boot_secondary()
and I believe that setting of S5P_USE_DELAYED_RESET_ASSERTION should be
taken care there as well.

Best regards,
Tomasz
