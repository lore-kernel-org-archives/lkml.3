Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965820AbaDJJv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:51:27 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:59026 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965642AbaDJJvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:51:23 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "kgene.kim\@samsung.com" <kgene.kim@samsung.com>,
        "t.figa\@samsung.com" <t.figa@samsung.com>,
        "linux-samsung-soc\@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "hyunhee.kim\@samsung.com" <hyunhee.kim@samsung.com>,
        "sw0312.kim\@samsung.com" <sw0312.kim@samsung.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yj44.cho\@samsung.com" <yj44.cho@samsung.com>,
        "inki.dae\@samsung.com" <inki.dae@samsung.com>,
        "kyungmin.park\@samsung.com" <kyungmin.park@samsung.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 06/27] ARM: EXYNOS:: Enter a15 lowpower mode for Exynos3250 based on Cortex-a7
In-Reply-To: <1397122124-15690-7-git-send-email-cw00.choi@samsung.com>
	(Chanwoo Choi's message of "Thu, 10 Apr 2014 10:28:23 +0100")
Organization: ARM Ltd
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
	<1397122124-15690-7-git-send-email-cw00.choi@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Thu, 10 Apr 2014 10:51:15 +0100
Message-ID: <87d2gp3430.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10 2014 at 10:28:23 am BST, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> This patch decide proper lowpower mode of either a15 or a9 according to own ID
> from Main ID register.
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/mach-exynos/hotplug.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
> index 5eead53..36d3db6 100644
> --- a/arch/arm/mach-exynos/hotplug.c
> +++ b/arch/arm/mach-exynos/hotplug.c
> @@ -135,13 +135,20 @@ void __ref exynos_cpu_die(unsigned int cpu)
>  	int primary_part = 0;
>  
>  	/*
> -	 * we're ready for shutdown now, so do it.
> -	 * Exynos4 is A9 based while Exynos5 is A15; check the CPU part
> +	 * we're ready for shutdown now, so do it. Exynos4 is A9 based
> +	 * while Exynos5 is A15/Exynos7 is A7; check the CPU part
>  	 * number by reading the Main ID register and then perform the
>  	 * appropriate sequence for entering low power.
>  	 */
>  	asm("mrc p15, 0, %0, c0, c0, 0" : "=r"(primary_part) : : "cc");

While you're touching that code, how about using:

      primary_part = read_cpuid(CPUID_ID);

> -	if ((primary_part & 0xfff0) == 0xc0f0)
> +
> +	/*
> +	 * Main ID register of Cortex series
> +	 * - Cortex-a7  : 0x410F_C07x
> +	 * - Cortex-a15 : 0x410F_C0Fx
> +	 */
> +	primary_part = primary_part & 0xfff0;
> +	if (primary_part == 0xc0f0 || primary_part == 0xc070)

ARM_CPU_PART_CORTEX_A15, ARM_CPU_PART_CORTEX_A7

>  		cpu_enter_lowpower_a15();
>  	else
>  		cpu_enter_lowpower_a9();

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
