Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab3IYNz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:55:57 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33346 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab3IYNz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:55:56 -0400
MIME-Version: 1.0
In-Reply-To: <1380108138-30402-2-git-send-email-l.majewski@samsung.com>
References: <1380108138-30402-1-git-send-email-l.majewski@samsung.com>
	<1380108138-30402-2-git-send-email-l.majewski@samsung.com>
Date: Wed, 25 Sep 2013 19:25:54 +0530
Message-ID: <CAKew6eW9-QHL5NKHV8roER_yuoLEiCoS53Gby8zC841fr=whqQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: exynos4x12: Use the common clock framework
 to set APLL clock rate
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lukasz,

On Wed, Sep 25, 2013 at 4:52 PM, Lukasz Majewski <l.majewski@samsung.com> wrote:
> In the exynos4x12_set_apll() function, the APLL frequency is set with
> direct register manipulation.
>
> Such approach is not allowed in the common clock framework. The frequency
> is changed, but the corresponding clock value is not updated. This causes
> wrong frequency read from cpufreq's cpuinfo_cur_freq sysfs attribute.
>

This patch looks incomplete, leaving the driver in untidy state, perhaps its
doesn't fix the above stated problem completely. what about
if (!exynos4x12_pms_change(old_index, new_index)) becomes true?

IMHO, this driver needs lot more work in addition to this patch to cleanly and
completely move the cpufreq driver to common clock framework.

For fixing this issue urgently, setting CLK_GET_RATE_NOCACHE for apll
in clk driver can also be quicker fix.

Regards,
Yadwinder

> Tested at:
> - Exynos4412 - Trats2 board (linux 3.12-rc1)
>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  drivers/cpufreq/exynos4x12-cpufreq.c |   23 ++++-------------------
>  1 file changed, 4 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/cpufreq/exynos4x12-cpufreq.c b/drivers/cpufreq/exynos4x12-cpufreq.c
> index 08b7477..b2f51c9 100644
> --- a/drivers/cpufreq/exynos4x12-cpufreq.c
> +++ b/drivers/cpufreq/exynos4x12-cpufreq.c
> @@ -128,9 +128,9 @@ static void exynos4x12_set_clkdiv(unsigned int div_index)
>
>  static void exynos4x12_set_apll(unsigned int index)
>  {
> -       unsigned int tmp, pdiv;
> +       unsigned int tmp, freq = apll_freq_4x12[index].freq;
>
> -       /* 1. MUX_CORE_SEL = MPLL, ARMCLK uses MPLL for lock time */
> +       /* MUX_CORE_SEL = MPLL, ARMCLK uses MPLL for lock time */
>         clk_set_parent(moutcore, mout_mpll);
>
>         do {
> @@ -140,24 +140,9 @@ static void exynos4x12_set_apll(unsigned int index)
>                 tmp &= 0x7;
>         } while (tmp != 0x2);
>
> -       /* 2. Set APLL Lock time */
> -       pdiv = ((apll_freq_4x12[index].mps >> 8) & 0x3f);
> +       clk_set_rate(mout_apll, freq * 1000);
>
> -       __raw_writel((pdiv * 250), EXYNOS4_APLL_LOCK);
> -
> -       /* 3. Change PLL PMS values */
> -       tmp = __raw_readl(EXYNOS4_APLL_CON0);
> -       tmp &= ~((0x3ff << 16) | (0x3f << 8) | (0x7 << 0));
> -       tmp |= apll_freq_4x12[index].mps;
> -       __raw_writel(tmp, EXYNOS4_APLL_CON0);
> -
> -       /* 4. wait_lock_time */
> -       do {
> -               cpu_relax();
> -               tmp = __raw_readl(EXYNOS4_APLL_CON0);
> -       } while (!(tmp & (0x1 << EXYNOS4_APLLCON0_LOCKED_SHIFT)));
> -
> -       /* 5. MUX_CORE_SEL = APLL */
> +       /* MUX_CORE_SEL = APLL */
>         clk_set_parent(moutcore, mout_apll);
>
>         do {
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
