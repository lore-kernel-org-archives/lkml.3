Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbaFSKWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 06:22:20 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:46970 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454AbaFSKWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:22:18 -0400
Message-ID: <53A2B9C3.1050906@gmail.com>
Date: Thu, 19 Jun 2014 12:21:55 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Riley <davidriley@chromium.org>,
        Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2] clocksource: exynos-mct: Register the timer for stable
 udelay
References: <1403167145-5267-1-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1403167145-5267-1-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

Please see my comments inline.

On 19.06.2014 10:39, Amit Daniel Kachhap wrote:
> This patch register the exynos mct clocksource as the current timer
> as it has constant clock rate. This will generate correct udelay for the
> exynos platform and avoid using unnecessary calibrated jiffies. This change
> has been tested on exynos5420 based board and udelay is very close to
> expected.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
> Changes in V2:
> * Added #defines for ARM and ARM64 as pointed by Doug Anderson.
> 
> Patches from David Riley confirmed that udelay is broken in exynos5420.
> Link to those patches are,
> 1) https://patchwork.kernel.org/patch/4344911/
> 2) https://patchwork.kernel.org/patch/4344881/
> 
>  drivers/clocksource/exynos_mct.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
> index f71d55f..02927e2 100644
> --- a/drivers/clocksource/exynos_mct.c
> +++ b/drivers/clocksource/exynos_mct.c
> @@ -195,10 +195,25 @@ static u64 notrace exynos4_read_sched_clock(void)
>  	return exynos4_frc_read(&mct_frc);
>  }
>  
> +static struct delay_timer exynos4_delay_timer;
> +
> +static unsigned long exynos4_read_current_timer(void)
> +{
> +#ifdef ARM
> +	return __raw_readl(reg_base + EXYNOS4_MCT_G_CNT_L);
> +#else /* ARM64, etc */
> +	return exynos4_frc_read(&mct_frc);
> +#endif
> +}
> +

No need for anything like this. Even if running on ARM64, the delay
timer code should be able to cope with different timer widths. For
delays, 32 bits are enough, so just always read the lower part.

Also use of raw accessors in drivers is discouraged - please use
readl_relaxed().

Btw. I don't even see support for this on ARM64 in mainline, where arch
timer is always used for delays and AFAIK this is a platform requirement.

>  static void __init exynos4_clocksource_init(void)
>  {
>  	exynos4_mct_frc_start();
>  
> +	exynos4_delay_timer.read_current_timer = &exynos4_read_current_timer;

nit: No need for & for function pointers.

Best regards,
Tomasz
