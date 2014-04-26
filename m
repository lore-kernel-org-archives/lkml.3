Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaDZAZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 20:25:11 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46188 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaDZAZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 20:25:07 -0400
Message-ID: <535AFCDF.20503@gmail.com>
Date: Sat, 26 Apr 2014 02:25:03 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com,
        t.figa@samsung.com
CC: sajjan.linux@gmail.com, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        arnd@arndb.de, marc.zyngier@arm.com, hyunhee.kim@samsung.com,
        sw0312.kim@samsung.com, linux-kernel@vger.kernel.org,
        yj44.cho@samsung.com, inki.dae@samsung.com, kyungmin.park@samsung.com,
        thomas.abraham@linaro.org, ben-linux@fluff.org, olof@lixom.net,
        chanho61.park@samsung.com, sachin.kamat@linaro.org,
        linux-arm-kernel@lists.infradead.org, tushar.behera@linaro.org
Subject: Re: [PATCHv4 4/7] ARM: EXYNOS: Enter a15 lowpower mode for Exynos3250
 based on Cortex-a7
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com> <1398388572-30239-5-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1398388572-30239-5-git-send-email-cw00.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 25.04.2014 03:16, Chanwoo Choi wrote:
> This patch decide proper lowpower mode of either a15 or a9 according to own ID
> from Main ID register.
>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Marc Zynigier <marc.zyngier@arm.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>   arch/arm/mach-exynos/hotplug.c | 19 ++++++++++++-------
>   1 file changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
> index 5eead53..acf3119 100644
> --- a/arch/arm/mach-exynos/hotplug.c
> +++ b/arch/arm/mach-exynos/hotplug.c
> @@ -135,16 +135,21 @@ void __ref exynos_cpu_die(unsigned int cpu)
>   	int primary_part = 0;
>
>   	/*
> -	 * we're ready for shutdown now, so do it.
> -	 * Exynos4 is A9 based while Exynos5 is A15; check the CPU part
> -	 * number by reading the Main ID register and then perform the
> -	 * appropriate sequence for entering low power.
> +	 * Prepare the CPU for shutting down. The required sequence of
> +	 * operations depends on core type. CPUID part number can be used to
> +	 * determine the right way.
>   	 */
> -	asm("mrc p15, 0, %0, c0, c0, 0" : "=r"(primary_part) : : "cc");
> -	if ((primary_part & 0xfff0) == 0xc0f0)
> +	primary_part = read_cpuid_part_number();
> +
> +	switch (primary_part) {
> +	case ARM_CPU_PART_CORTEX_A7:
> +	case ARM_CPU_PART_CORTEX_A15:
>   		cpu_enter_lowpower_a15();
> -	else
> +		break;
> +	default:
>   		cpu_enter_lowpower_a9();
> +		break;
> +	}
>
>   	platform_do_lowpower(cpu, &spurious);
>
>

I have noticed Leela Krishna Amudala's patch [1] that removes this 
distinction completely and simply uses generic code. Could you check if 
this works on Exynos3250 as well? If yes, then this patch could be 
dropped and Leela's one would be enough.

[1] 
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg29064.html

Best regards,
Tomasz
