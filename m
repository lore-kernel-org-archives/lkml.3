Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaFEHzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:55:37 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:41455 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaFEHzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:55:36 -0400
MIME-Version: 1.0
In-Reply-To: <1401903034-20074-2-git-send-email-dianders@chromium.org>
References: <1401903034-20074-1-git-send-email-dianders@chromium.org> <1401903034-20074-2-git-send-email-dianders@chromium.org>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 5 Jun 2014 09:55:15 +0200
Message-ID: <CAKfTPtBeYMW7kOrAhVrqoWhTHfLAtcMeY9FXxZpm7CNAM7NdaA@mail.gmail.com>
Subject: Re: [PATCH 2/3] clocksource: exynos_mct: cache mct upper count
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Chirantan Ekbote <chirantan@chromium.org>,
        David Riley <davidriley@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 June 2014 19:30, Doug Anderson <dianders@chromium.org> wrote:
> From: Mandeep Singh Baines <msb@chromium.org>
>
> Saves one register read.  Note that the upper count only changes every
> ~178 seconds with a 24MHz source clock, so it's likely it hasn't
> changed from call to call.

Hi Doug,

Have you checked that the time saved in using a 32bits counter instead
of a 64bits one is not lost in the handle of the wrap of sched_clock
which occurs every 178s instead of never ?

sched_clock_poll function will be called every 178s

Regards,
Vincent


>
> Before: 1323852 us for 1000000 gettimeofday in userspace
> After:  1173084 us for 1000000 gettimeofday in userspace
>
> Note that even with this change the CPU is in exynos_frc_read() more
> than 2% of the time in real world profiles of ChromeOS.  That
> indicates that it's important to optimize.
>
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/clocksource/exynos_mct.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
> index ba3a683..7cbe4aa 100644
> --- a/drivers/clocksource/exynos_mct.c
> +++ b/drivers/clocksource/exynos_mct.c
> @@ -167,8 +167,8 @@ static void exynos4_mct_frc_start(u32 hi, u32 lo)
>
>  static inline cycle_t notrace _exynos4_frc_read(void)
>  {
> -       unsigned int lo, hi;
> -       u32 hi2 = __raw_readl(reg_base + EXYNOS4_MCT_G_CNT_U);
> +       u32 lo, hi;
> +       static u32 hi2;
>
>         do {
>                 hi = hi2;
> --
> 2.0.0.526.g5318336
>
