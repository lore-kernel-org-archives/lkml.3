Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaFOVSO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 17:18:14 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52778 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaFOVSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 17:18:09 -0400
Message-ID: <539E0D8E.9080706@linaro.org>
Date: Sun, 15 Jun 2014 23:18:06 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
CC: Vincent Guittot <vincent.guittot@linaro.org>,
        Chirantan Ekbote <chirantan@chromium.org>,
        David Riley <davidriley@chromium.org>, olof@lixom.net,
        linux-samsung-soc@vger.kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] clocksource: exynos_mct: Fix ftrace
References: <1401903034-20074-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1401903034-20074-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 07:30 PM, Doug Anderson wrote:
> In (93bfb76 clocksource: exynos_mct: register sched_clock callback) we
> supported using the MCT as a scheduler clock.  We properly marked
> exynos4_read_sched_clock() as notrace.  However, we then went and
> called another function that _wasn't_ notrace.  That means if you do:
>
>    cd /sys/kernel/debug/tracing/
>    echo function_graph > current_tracer
>
> You'll get a crash.
>
> Fix this (but still let other readers of the MCT be trace-enabled) by
> adding an extra function.  It's important to keep other users of MCT
> traceable because the MCT is actually quite slow.


Hi Doug,

could you elaborate ? I don't get the 'because the MCT ... slow'

Thanks

   -- Daniel

> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>   drivers/clocksource/exynos_mct.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
> index 8d64200..ba3a683 100644
> --- a/drivers/clocksource/exynos_mct.c
> +++ b/drivers/clocksource/exynos_mct.c
> @@ -165,7 +165,7 @@ static void exynos4_mct_frc_start(u32 hi, u32 lo)
>   	exynos4_mct_write(reg, EXYNOS4_MCT_G_TCON);
>   }
>
> -static cycle_t exynos4_frc_read(struct clocksource *cs)
> +static inline cycle_t notrace _exynos4_frc_read(void)
>   {
>   	unsigned int lo, hi;
>   	u32 hi2 = __raw_readl(reg_base + EXYNOS4_MCT_G_CNT_U);
> @@ -179,6 +179,11 @@ static cycle_t exynos4_frc_read(struct clocksource *cs)
>   	return ((cycle_t)hi << 32) | lo;
>   }
>
> +static cycle_t exynos4_frc_read(struct clocksource *cs)
> +{
> +	return _exynos4_frc_read();
> +}
> +
>   static void exynos4_frc_resume(struct clocksource *cs)
>   {
>   	exynos4_mct_frc_start(0, 0);
> @@ -195,7 +200,7 @@ struct clocksource mct_frc = {
>
>   static u64 notrace exynos4_read_sched_clock(void)
>   {
> -	return exynos4_frc_read(&mct_frc);
> +	return _exynos4_frc_read();
>   }
>
>   static void __init exynos4_clocksource_init(void)
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

