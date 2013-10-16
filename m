Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684Ab3JPWqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:46:53 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61499 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753730Ab3JPWqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:46:51 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v2 2/2] cpufreq: exynos4210: Use the common clock framework to set APLL clock rate
Date: Thu, 17 Oct 2013 00:58:42 +0200
Message-ID: <1627215.GFg6tQENRA@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1381320523-28183-3-git-send-email-l.majewski@samsung.com>
References: <1380108138-30402-1-git-send-email-l.majewski@samsung.com> <1381320523-28183-1-git-send-email-l.majewski@samsung.com> <1381320523-28183-3-git-send-email-l.majewski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 09, 2013 02:08:43 PM Lukasz Majewski wrote:
> In the exynos4210_set_apll() function, the APLL frequency is set with
> direct register manipulation.
> 
> Such approach is not allowed in the common clock framework. The frequency
> is changed, but the corresponding clock value is not updated. This causes
> wrong frequency read from cpufreq's cpuinfo_cur_freq sysfs attribute.
> 
> Also direct manipulation with PLL's S parameter has been removed. It is
> already done at PLL35xx code.
> 
> Tested at:
> - Exynos4210 - Trats board (linux 3.12-rc4)
> 
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>

I need an ACK or Reviewed-by from someone in the CC list here.

Thanks!

> Changes for v2:
> - Remove PLL's S parameter setting via registers. It is now done with PLL35xx
>   code.
> - Remove exynos4210_pms_change() function
> 
> Change-Id: Ie5fb3c7946ba77b6f3d5e91af72eef2fd06770c1
> ---
>  drivers/cpufreq/exynos4210-cpufreq.c |   67 ++++------------------------------
>  1 file changed, 8 insertions(+), 59 deletions(-)
> 
> diff --git a/drivers/cpufreq/exynos4210-cpufreq.c b/drivers/cpufreq/exynos4210-cpufreq.c
> index add7fbe..f2c7506 100644
> --- a/drivers/cpufreq/exynos4210-cpufreq.c
> +++ b/drivers/cpufreq/exynos4210-cpufreq.c
> @@ -81,9 +81,9 @@ static void exynos4210_set_clkdiv(unsigned int div_index)
>  
>  static void exynos4210_set_apll(unsigned int index)
>  {
> -	unsigned int tmp;
> +	unsigned int tmp, freq = apll_freq_4210[index].freq;
>  
> -	/* 1. MUX_CORE_SEL = MPLL, ARMCLK uses MPLL for lock time */
> +	/* MUX_CORE_SEL = MPLL, ARMCLK uses MPLL for lock time */
>  	clk_set_parent(moutcore, mout_mpll);
>  
>  	do {
> @@ -92,21 +92,9 @@ static void exynos4210_set_apll(unsigned int index)
>  		tmp &= 0x7;
>  	} while (tmp != 0x2);
>  
> -	/* 2. Set APLL Lock time */
> -	__raw_writel(EXYNOS4_APLL_LOCKTIME, EXYNOS4_APLL_LOCK);
> -
> -	/* 3. Change PLL PMS values */
> -	tmp = __raw_readl(EXYNOS4_APLL_CON0);
> -	tmp &= ~((0x3ff << 16) | (0x3f << 8) | (0x7 << 0));
> -	tmp |= apll_freq_4210[index].mps;
> -	__raw_writel(tmp, EXYNOS4_APLL_CON0);
> +	clk_set_rate(mout_apll, freq * 1000);
>  
> -	/* 4. wait_lock_time */
> -	do {
> -		tmp = __raw_readl(EXYNOS4_APLL_CON0);
> -	} while (!(tmp & (0x1 << EXYNOS4_APLLCON0_LOCKED_SHIFT)));
> -
> -	/* 5. MUX_CORE_SEL = APLL */
> +	/* MUX_CORE_SEL = APLL */
>  	clk_set_parent(moutcore, mout_apll);
>  
>  	do {
> @@ -115,53 +103,15 @@ static void exynos4210_set_apll(unsigned int index)
>  	} while (tmp != (0x1 << EXYNOS4_CLKSRC_CPU_MUXCORE_SHIFT));
>  }
>  
> -static bool exynos4210_pms_change(unsigned int old_index, unsigned int new_index)
> -{
> -	unsigned int old_pm = apll_freq_4210[old_index].mps >> 8;
> -	unsigned int new_pm = apll_freq_4210[new_index].mps >> 8;
> -
> -	return (old_pm == new_pm) ? 0 : 1;
> -}
> -
>  static void exynos4210_set_frequency(unsigned int old_index,
>  				     unsigned int new_index)
>  {
> -	unsigned int tmp;
> -
>  	if (old_index > new_index) {
> -		if (!exynos4210_pms_change(old_index, new_index)) {
> -			/* 1. Change the system clock divider values */
> -			exynos4210_set_clkdiv(new_index);
> -
> -			/* 2. Change just s value in apll m,p,s value */
> -			tmp = __raw_readl(EXYNOS4_APLL_CON0);
> -			tmp &= ~(0x7 << 0);
> -			tmp |= apll_freq_4210[new_index].mps & 0x7;
> -			__raw_writel(tmp, EXYNOS4_APLL_CON0);
> -		} else {
> -			/* Clock Configuration Procedure */
> -			/* 1. Change the system clock divider values */
> -			exynos4210_set_clkdiv(new_index);
> -			/* 2. Change the apll m,p,s value */
> -			exynos4210_set_apll(new_index);
> -		}
> +		exynos4210_set_clkdiv(new_index);
> +		exynos4210_set_apll(new_index);
>  	} else if (old_index < new_index) {
> -		if (!exynos4210_pms_change(old_index, new_index)) {
> -			/* 1. Change just s value in apll m,p,s value */
> -			tmp = __raw_readl(EXYNOS4_APLL_CON0);
> -			tmp &= ~(0x7 << 0);
> -			tmp |= apll_freq_4210[new_index].mps & 0x7;
> -			__raw_writel(tmp, EXYNOS4_APLL_CON0);
> -
> -			/* 2. Change the system clock divider values */
> -			exynos4210_set_clkdiv(new_index);
> -		} else {
> -			/* Clock Configuration Procedure */
> -			/* 1. Change the apll m,p,s value */
> -			exynos4210_set_apll(new_index);
> -			/* 2. Change the system clock divider values */
> -			exynos4210_set_clkdiv(new_index);
> -		}
> +		exynos4210_set_apll(new_index);
> +		exynos4210_set_clkdiv(new_index);
>  	}
>  }
>  
> @@ -194,7 +144,6 @@ int exynos4210_cpufreq_init(struct exynos_dvfs_info *info)
>  	info->volt_table = exynos4210_volt_table;
>  	info->freq_table = exynos4210_freq_table;
>  	info->set_freq = exynos4210_set_frequency;
> -	info->need_apll_change = exynos4210_pms_change;
>  
>  	return 0;
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
