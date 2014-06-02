Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbaFBNP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:15:28 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:41781 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbaFBNPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:15:24 -0400
Message-ID: <538C78DB.1060809@gmail.com>
Date: Mon, 02 Jun 2014 15:15:07 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 7/7] ARM: EXYNOS: cpuidle: add secure firmware support
 to AFTR mode code
References: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com> <1401712543-14281-8-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1401712543-14281-8-git-send-email-b.zolnierkie@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02.06.2014 14:35, Bartlomiej Zolnierkiewicz wrote:
> * Use do_idle firmware method instead of cpu_do_idle() on boards with
>   secure firmware enabled.
> 
> * Use sysram_ns_base_addr + 0x24 address for exynos_boot_vector_addr()
>   and sysram_ns_base_addr + 0x20 one for exynos_boot_vector_flag() on
>   boards with secure firmware enabled.
> 
> This patch fixes hang on an attempt to enter AFTR mode for TRATS2
> board (which uses EXYNOS4412 SoC with secure firmware enabled).
> 
> This patch shouldn't cause any functionality changes on boards that
> don't use secure firmware.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/mach-exynos/pm.c        | 8 ++++++--
>  drivers/cpuidle/cpuidle-exynos.c | 7 ++++++-
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> index 0fb9a5a..62a0a5e 100644
> --- a/arch/arm/mach-exynos/pm.c
> +++ b/arch/arm/mach-exynos/pm.c
> @@ -169,7 +169,9 @@ int exynos_cluster_power_state(int cluster)
>  
>  static inline void __iomem *exynos_boot_vector_addr(void)
>  {
> -	if (samsung_rev() == EXYNOS4210_REV_1_1)
> +	if (firmware_run())
> +		return sysram_ns_base_addr + 0x24;
> +	else if (samsung_rev() == EXYNOS4210_REV_1_1)

Aha, so this is the use case for the function added by patch 1/7.

Well, I don't see the need to do it this way and complicate the API. As
I mentioned in my comments to patches 2/7 and 5/7, more general firmware
operations should be taking care of setting those registers to
appropriate values and so there shouldn't be any need to use them
directly outside the implementation of firmware ops.

[snip]

>  static int idle_finisher(unsigned long flags)
>  {
>  	exynos_enter_aftr();
> -	cpu_do_idle();
> +	if (firmware_run())
> +		/* no need to check the return value on EXYNOS SoCs */
> +		call_firmware_op(do_idle, FW_DO_IDLE_AFTR);
> +	else
> +		cpu_do_idle();

This could be done just by

	if (call_firmware_op(do_idle, FW_DO_IDLE_AFTR) == -ENOSYS)
		cpu_do_idle();

which is 3 lines less than with a function that is suppose to simplify
the code.

Best regards,
Tomasz
