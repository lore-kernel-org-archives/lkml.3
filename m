Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707AbaGPNGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:06:39 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9936 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801AbaGPNGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:06:37 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-c9-53c678daf9f8
Message-id: <53C678B5.7080304@samsung.com>
Date: Wed, 16 Jul 2014 15:05:57 +0200
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
Subject: Re: [PATCH v3] ARM: exynos4: hotplug: Fix CPU idle clock down after
 CPU off
References: <1405512467-27269-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1405512467-27269-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xq7q3Ko4FG0xt0bDYOGM9q8XrF4YW
	vQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei7VH7rI7cHq0NPeweWxeUu/Rt2UVo8fn
	TXIBLFFcNimpOZllqUX6dglcGR/vrWEq+MRV8b7zD2MD432OLkZODgkBE4lrCw4zQdhiEhfu
	rWfrYuTiEBJYyijx4v1pRgjnM5Cz5Sk7SBWvgJbElNXbGEFsFgFViU2PtrCC2GwCahKfGx6x
	gdj8QDVrmq6zdDFycIgKREg8viAE0Soo8WPyPRaQmSICLxkl9h6eAOYwC0xhlGietJQJpEFY
	IEzizjtJkAYhAXeJX0dB5nBycAp4SHy9fw3MZhbQkdjfOo0NwpaX2LzmLfMERsFZSHbMQlI2
	C0nZAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghMfB1B+PSY1aHGAU4GJV4eBlmHw0W
	Yk0sK67MPcQowcGsJMLr4H8sWIg3JbGyKrUoP76oNCe1+BAjEwenVAPjgT12k6cwaudyxmja
	JKlI3kj7z2dt+qClL0w7xPJ8z3szjcLM2QkiU3YYvD7r08m623lGoMbVHbu/xbDzOu5j2bn6
	nP+SKN41HbpLtkqzPagLXfr3WEs912pp/0Cpn+skTHpWuG/1fSV5JurmOYUzh/YpK5gm/ZRf
	s99PJPHYVPGz3nfzliYqsRRnJBpqMRcVJwIAirdAu18CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 16.07.2014 14:07, Krzysztof Kozlowski wrote:

[snip]

> +#ifdef CONFIG_SMP
> +extern void exynos_clear_delayed_reset_assertion(u32 core_id);
> +#endif

Is the ifdef really needed? The only difference it makes if the function
is used but not compiled in is that with it the compilation will fail,
while without it the kernel won't link.

> +
>  extern void exynos_cpu_resume(void);
>  
>  extern struct smp_operations exynos_smp_ops;

[snip]

> +/*
> + * Clear the USE_DELAYED_RESET_ASSERTION option, set on Exynos4 SoCs
> + * during hot-unplugging CPUx.
> + *
> + * It won't harm if this is called during first boot of secondary CPU.
> + *
> + * Exynos4 SoCs require setting USE_DELAYED_RESET_ASSERTION so the CPU idle
> + * clock down feature could properly detect global idle state when
> + * CPUx is off.
> + */
> +void exynos_clear_delayed_reset_assertion(u32 core_id)
> +{
> +	if (soc_is_exynos4()) {
> +		unsigned int tmp;
> +
> +		tmp = __raw_readl(EXYNOS_ARM_CORE_OPTION(core_id));
> +		tmp &= ~(S5P_USE_DELAYED_RESET_ASSERTION);
> +		__raw_writel(tmp, EXYNOS_ARM_CORE_OPTION(core_id));
> +	}
> +}

The idea to make this a helper function is quite nice, but maybe it
could be extended into exynos_set_delayed_reset_assertion() and disable
or enable delayed assertion depending on another argument?

Best regards,
Tomasz
