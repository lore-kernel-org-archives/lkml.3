Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab3JIMJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:09:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20196 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186Ab3JIMI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:08:59 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-00-5255475adeab
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v2 1/2] cpufreq: exynos4x12: Use the common clock framework to
 set APLL clock rate
Date: Wed, 09 Oct 2013 14:08:42 +0200
Message-id: <1381320523-28183-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1381320523-28183-1-git-send-email-l.majewski@samsung.com>
References: <1380108138-30402-1-git-send-email-l.majewski@samsung.com>
 <1381320523-28183-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t9jQd0o99Agg8alMhYbZ6xntXja9IPd
	ovPsE2aLN4+4Ld483MxocXnXHDaLz71HGC1uN65gszhz+hKrxfoZr1ksNn71sJj7u5HVgcdj
	56y77B53ru1h81g37S2zx5ar7SwefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlbHmwimmgtUq
	FW2tj1kbGM/JdjFyckgImEi8Xv2aFcIWk7hwbz1bFyMXh5DAdEaJpikTwRJCAl1MEt92V4DY
	bAJ6Ep/vPmUCsUUEQiWOTv3KDmIzCxxnlvi53BTEFhZIkdj+/B1YL4uAqsTj9SuAajg4eAXc
	JG59CILYJS/x9H4fG0iYU8Bd4uI3CYi1zYwSLyfuZJnAyLuAkWEVo2hqQXJBcVJ6rqFecWJu
	cWleul5yfu4mRnAoPpPawbiyweIQowAHoxIP7wP+kCAh1sSy4srcQ4wSHMxKIry+FqFBQrwp
	iZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhg7jlp/WhN+Zd2z
	C0Est9Vr06dvZChZOe3Cwp1JWyZqb1XS3iixuOlKhHD8WokGDm919d5iz8xPSm82dAQGX1M6
	XXO5Kd6j+Ptu+0/P5kzxkM46UpE9+Z3D1uWJU0wd750Of9jWzHlyz7LC5ED9/59Mb0+dNDlv
	t2Cs66/YP9Py775k+Pe2q1ZViaU4I9FQi7moOBEA+QxXuEECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the exynos4x12_set_apll() function, the APLL frequency is set with
direct register manipulation.

Such approach is not allowed in the common clock framework. The frequency
is changed, but the corresponding clock value is not updated. This causes
wrong frequency read from cpufreq's cpuinfo_cur_freq sysfs attribute.

Also direct manipulation with PLL's S parameter has been removed. It is
already done at PLL35xx code.

Tested at:
- Exynos4412 - Trats2 board (linux 3.12-rc4)

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Changes for v2:
- Remove PLL's S parameter setting via registers. It is now done with PLL35xx
  code.
- Remove exynos4x12_pms_change() function.

Change-Id: I6c32d6fd7f634ff8d07cbaa0ebe0e21614f9f3c9
---
 drivers/cpufreq/exynos4x12-cpufreq.c |   69 ++++------------------------------
 1 file changed, 8 insertions(+), 61 deletions(-)

diff --git a/drivers/cpufreq/exynos4x12-cpufreq.c b/drivers/cpufreq/exynos4x12-cpufreq.c
index 08b7477..8683304 100644
--- a/drivers/cpufreq/exynos4x12-cpufreq.c
+++ b/drivers/cpufreq/exynos4x12-cpufreq.c
@@ -128,9 +128,9 @@ static void exynos4x12_set_clkdiv(unsigned int div_index)
 
 static void exynos4x12_set_apll(unsigned int index)
 {
-	unsigned int tmp, pdiv;
+	unsigned int tmp, freq = apll_freq_4x12[index].freq;
 
-	/* 1. MUX_CORE_SEL = MPLL, ARMCLK uses MPLL for lock time */
+	/* MUX_CORE_SEL = MPLL, ARMCLK uses MPLL for lock time */
 	clk_set_parent(moutcore, mout_mpll);
 
 	do {
@@ -140,24 +140,9 @@ static void exynos4x12_set_apll(unsigned int index)
 		tmp &= 0x7;
 	} while (tmp != 0x2);
 
-	/* 2. Set APLL Lock time */
-	pdiv = ((apll_freq_4x12[index].mps >> 8) & 0x3f);
+	clk_set_rate(mout_apll, freq * 1000);
 
-	__raw_writel((pdiv * 250), EXYNOS4_APLL_LOCK);
-
-	/* 3. Change PLL PMS values */
-	tmp = __raw_readl(EXYNOS4_APLL_CON0);
-	tmp &= ~((0x3ff << 16) | (0x3f << 8) | (0x7 << 0));
-	tmp |= apll_freq_4x12[index].mps;
-	__raw_writel(tmp, EXYNOS4_APLL_CON0);
-
-	/* 4. wait_lock_time */
-	do {
-		cpu_relax();
-		tmp = __raw_readl(EXYNOS4_APLL_CON0);
-	} while (!(tmp & (0x1 << EXYNOS4_APLLCON0_LOCKED_SHIFT)));
-
-	/* 5. MUX_CORE_SEL = APLL */
+	/* MUX_CORE_SEL = APLL */
 	clk_set_parent(moutcore, mout_apll);
 
 	do {
@@ -167,52 +152,15 @@ static void exynos4x12_set_apll(unsigned int index)
 	} while (tmp != (0x1 << EXYNOS4_CLKSRC_CPU_MUXCORE_SHIFT));
 }
 
-static bool exynos4x12_pms_change(unsigned int old_index, unsigned int new_index)
-{
-	unsigned int old_pm = apll_freq_4x12[old_index].mps >> 8;
-	unsigned int new_pm = apll_freq_4x12[new_index].mps >> 8;
-
-	return (old_pm == new_pm) ? 0 : 1;
-}
-
 static void exynos4x12_set_frequency(unsigned int old_index,
 				  unsigned int new_index)
 {
-	unsigned int tmp;
-
 	if (old_index > new_index) {
-		if (!exynos4x12_pms_change(old_index, new_index)) {
-			/* 1. Change the system clock divider values */
-			exynos4x12_set_clkdiv(new_index);
-			/* 2. Change just s value in apll m,p,s value */
-			tmp = __raw_readl(EXYNOS4_APLL_CON0);
-			tmp &= ~(0x7 << 0);
-			tmp |= apll_freq_4x12[new_index].mps & 0x7;
-			__raw_writel(tmp, EXYNOS4_APLL_CON0);
-
-		} else {
-			/* Clock Configuration Procedure */
-			/* 1. Change the system clock divider values */
-			exynos4x12_set_clkdiv(new_index);
-			/* 2. Change the apll m,p,s value */
-			exynos4x12_set_apll(new_index);
-		}
+		exynos4x12_set_clkdiv(new_index);
+		exynos4x12_set_apll(new_index);
 	} else if (old_index < new_index) {
-		if (!exynos4x12_pms_change(old_index, new_index)) {
-			/* 1. Change just s value in apll m,p,s value */
-			tmp = __raw_readl(EXYNOS4_APLL_CON0);
-			tmp &= ~(0x7 << 0);
-			tmp |= apll_freq_4x12[new_index].mps & 0x7;
-			__raw_writel(tmp, EXYNOS4_APLL_CON0);
-			/* 2. Change the system clock divider values */
-			exynos4x12_set_clkdiv(new_index);
-		} else {
-			/* Clock Configuration Procedure */
-			/* 1. Change the apll m,p,s value */
-			exynos4x12_set_apll(new_index);
-			/* 2. Change the system clock divider values */
-			exynos4x12_set_clkdiv(new_index);
-		}
+		exynos4x12_set_apll(new_index);
+		exynos4x12_set_clkdiv(new_index);
 	}
 }
 
@@ -250,7 +198,6 @@ int exynos4x12_cpufreq_init(struct exynos_dvfs_info *info)
 	info->volt_table = exynos4x12_volt_table;
 	info->freq_table = exynos4x12_freq_table;
 	info->set_freq = exynos4x12_set_frequency;
-	info->need_apll_change = exynos4x12_pms_change;
 
 	return 0;
 
-- 
1.7.10.4

