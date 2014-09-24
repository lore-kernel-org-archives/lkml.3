Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaIXNzC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:55:02 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:64083 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbaIXNy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:54:57 -0400
Date: Wed, 24 Sep 2014 09:54:53 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        "David A. Long" <dave.long@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, Vinayak Kale <vkale@apm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2] ARM: cacheflush: Fix v7_exit_coherency_flush exynos
 build breakage on ARMv6
In-Reply-To: <1411547222-677-1-git-send-email-k.kozlowski@samsung.com>
Message-ID: <alpine.LFD.2.11.1409240954220.8647@knanqh.ubzr>
References: <1411547222-677-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, Krzysztof Kozlowski wrote:

> This fixes build breakage of platsmp.c if ARMv6 was chosen for compile
> time options (e.g. by building allmodconfig):
> 
> $ make allmodconfig
> $ make
>   CC      arch/arm/mach-exynos/platsmp.o
> /tmp/ccdQM0Eg.s: Assembler messages:
> /tmp/ccdQM0Eg.s:432: Error: selected processor does not support ARM mode `isb '
> /tmp/ccdQM0Eg.s:437: Error: selected processor does not support ARM mode `isb '
> /tmp/ccdQM0Eg.s:438: Error: selected processor does not support ARM mode `dsb '
> make[1]: *** [arch/arm/mach-exynos/platsmp.o] Error 1
> 
> The error was introduced in commit "ARM: EXYNOS: Move code from
> hotplug.c to platsmp.c".  Previously code using
> v7_exit_coherency_flush() macro was built with '-march=armv7-a' flag but
> this flag dissapeared during the movement.
> 
> Fix this by annotating the v7_exit_coherency_flush() asm code with
> armv7-a architecture.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Reported-by: Mark Brown <broonie@kernel.org>
> Link: http://www.spinics.net/lists/linux-samsung-soc/msg36790.html

Acked-by: Nicolas Pitre <nico@linaro.org>


> 
> ---
> 
> Changes since v1:
> 1. Use armv7-a arch annotation instead replacing isb/dsb with macros.
>    Suggsted by Nicolas Pitre.
> ---
>  arch/arm/include/asm/cacheflush.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
> index 79ecb4f34ffb..10e78d00a0bb 100644
> --- a/arch/arm/include/asm/cacheflush.h
> +++ b/arch/arm/include/asm/cacheflush.h
> @@ -466,6 +466,7 @@ static inline void __sync_cache_range_r(volatile void *p, size_t size)
>   */
>  #define v7_exit_coherency_flush(level) \
>  	asm volatile( \
> +	".arch	armv7-a \n\t" \
>  	"stmfd	sp!, {fp, ip} \n\t" \
>  	"mrc	p15, 0, r0, c1, c0, 0	@ get SCTLR \n\t" \
>  	"bic	r0, r0, #"__stringify(CR_C)" \n\t" \
> -- 
> 1.9.1
> 
> 
