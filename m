Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaFJOtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:49:03 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59712 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaFJOqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:46:23 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-df-53971a3c18bf
Message-id: <53971A2E.2010104@samsung.com>
Date: Tue, 10 Jun 2014 16:46:06 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, arnd@arndb.de
Subject: Re: [PATCH v3 6/6] ARM: EXYNOS: Refactoring to remove soc_is_exynos
 macros from exynos
References: <1399706287-13919-1-git-send-email-y@samsung.com>
 <1399706419-13976-1-git-send-email-pankaj.dubey@samsung.com>
 <1399706419-13976-7-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1399706419-13976-7-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xq7o2UtODDY7s0LX4O+kYu0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCwWbf3C7sDm8fvXJEaPzUvqPfq2rGL0+LxJLoAlissmJTUnsyy1
	SN8ugSuj6eA/toI1whWTPhxnbWB8w9/FyMkhIWAi8Xb5ShYIW0ziwr31bF2MXBxCAksZJX5f
	/MwM4XxmlJh9oAmsildAS2Lzls+MIDaLgKrEgQv/WUFsNgE1ic8Nj9hAbH6gmjVN14HqOThE
	BSIkHl8QgmgVlPgx+R4LyEwRgSmMEhd7ljGC1DALaEhcfeUPYgoLJErcW+YBsXY3o8SeY91M
	IL2cAp4St+8eYAexmQV0JPa3TmODsOUlNq95yzyBUXAWkhWzkJTNQlK2gJF5FaNoamlyQXFS
	eq6hXnFibnFpXrpecn7uJkZImH/Zwbj4mNUhRgEORiUeXg6dacFCrIllxZW5hxglOJiVRHjb
	/gKFeFMSK6tSi/Lji0pzUosPMTJxcEo1MPK4Xa1Qm7Dt3WqbLzODUt4734n+Yzg19q2lif+T
	pDntKnftrVre985P6VKz6Pf4vVFxqWiQ71O1HXPfBxa7Rqnc+qj8W2HZJ8/8W1ETYnyOPd3E
	n7W4PuTZ/fkZN4563zvosNdp44t5jz+uPf7mdtT5ucxTmS0+GPyUiWl4UjDTLzEj+KDSuelK
	LMUZiYZazEXFiQClLCGoUQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 10.05.2014 09:20, Pankaj Dubey wrote:
> This patch enables chipid driver for ARCH_EXYNOS and refactors
> machine code as well as exynos cpufreq driver code for using
> chipid driver for identification of SoC ID and SoC rev.
> 
> This patch also updates DT binding information in exynos4 and
> exynos5 dtsi file. As to differentiate product id bit-mask we need
> separate compatible string for exynos4 and exynos5. Hoping this will
> be helpful in future as bit-mask and bit-shift bit may differ.
> Added binding information as well.

[snip]

> diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
> index d0482c2..9d6ec84 100644
> --- a/arch/arm/mach-exynos/platsmp.c
> +++ b/arch/arm/mach-exynos/platsmp.c
> @@ -20,13 +20,13 @@
>  #include <linux/smp.h>
>  #include <linux/io.h>
>  #include <linux/of_address.h>
> +#include <linux/exynos-soc.h>
>  
>  #include <asm/cacheflush.h>
>  #include <asm/smp_plat.h>
>  #include <asm/smp_scu.h>
>  #include <asm/firmware.h>
>  
> -#include <plat/cpu.h>
>  #include <mach/map.h>
>  
>  #include "common.h"
> @@ -59,7 +59,8 @@ static void __init exynos_smp_prepare_sram(void)
>  
>  static inline void __iomem *cpu_boot_reg_base(void)
>  {
> -	if (soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_1_1)
> +	if (is_soc_id_compatible(EXYNOS4210) &&
> +			is_soc_rev_compatible(EXYNOS4210_REV_1_1))

Well, how is this any better than what is already there? When adding a
new SoC, you will likely have to add another series of "||"s or "&&"s
with specific SoC IDs, when using this kind of API. This is not the point.

For now, all those things can be replaced simply with
of_machine_is_compatible() (except checks for samsung_rev()), but in the
end they need to be properly abstracted. The goal is to be able to add
support for new SoC, which requires identical steps to perform certain
things as already supported SoCs, without explicitly stating this in
driver code.

E.g. Exynos5250 is already supported, while Exynos5251 shows up. Let's
say it has exactly the same secondary CPU boot-up method as Exynos5250,
but to enter suspend mode, the same steps as on Exynos5260 have to be
performed. With any kind of per-SoC check API, you will have to add
soc_is_exynos5251() or is_soc_id_compatible(EXYNOS5251) in CPU bring-up
code and low-level suspend code, even though all the functional code is
already there.

Best regards,
Tomasz
