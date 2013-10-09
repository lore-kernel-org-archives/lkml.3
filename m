Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab3JIMLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:11:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20245 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3JIMLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:11:08 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-8d-5255475e5e0e
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
Subject: [PATCH v2 2/2] cpufreq: exynos4210: Use the common clock framework to
 set APLL clock rate
Date: Wed, 09 Oct 2013 14:08:43 +0200
Message-id: <1381320523-28183-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1381320523-28183-1-git-send-email-l.majewski@samsung.com>
References: <1380108138-30402-1-git-send-email-l.majewski@samsung.com>
 <1381320523-28183-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t9jQd1499AggwN7GS02zljPavG06Qe7
	RefZJ8wWbx5xW7x5uJnR4vKuOWwWn3uPMFrcblzBZnHm9CVWi/UzXrNYbPzqYTH3dyOrA4/H
	zll32T3uXNvD5rFu2ltmjy1X21k8+rasYvT4vEkugC2KyyYlNSezLLVI3y6BK6NrwiXGgs9K
	Fd8vpTQwrpXpYuTkkBAwkXjft58NwhaTuHBvPZgtJDCdUaLtvXIXIxeQ3cUk0fnsHAtIgk1A
	T+Lz3adMILaIQKjE0alf2UFsZoHjzBI/l5uC2MICKRIv5n8EG8QioCpx+8FSsHpeATeJr80T
	oZbJSzy93wdkc3BwCrhLXPwmAbGrmVHi5cSdLBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L
	10vOz93ECA7FZ9I7GFc1WBxiFOBgVOLhfcAfEiTEmlhWXJl7iFGCg1lJhNfXIjRIiDclsbIq
	tSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA2PyApGi9BNfXxgrnkjm
	8bi5xchzVotJ5qXLd2TmPjx0RdLBIvT49jXC+bc3esk2Bx9IP3r66IfiMp02zxxNhcXZD0IF
	5xcc5bghf3AN15wj7rN1580OW9MvVPP3mUPNKy/matsCpjzn5BmeEucsNO/sPt6UbL2mm2m3
	as68+QVp647JL7BSrFdiKc5INNRiLipOBAAeMiHKQQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the exynos4210_set_apll() function, the APLL frequency is set with
direct register manipulation.

Such approach is not allowed in the common clock framework. The frequency
is changed, but the corresponding clock value is not updated. This causes
wrong frequency read from cpufreq's cpuinfo_cur_freq sysfs attribute.

Also direct manipulation with PLL's S parameter has been removed. It is
already done at PLL35xx code.

Tested at:
- Exynos4210 - Trats board (linux 3.12-rc4)

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>

Changes for v2:
- Remove PLL's S parameter setting via registers. It is now done with PLL35xx
  code.
- Remove exynos4210_pms_change() function

Change-Id: Ie5fb3c7946ba77b6f3d5e91af72eef2fd06770c1
---
 drivers/cpufreq/exynos4210-cpufreq.c |   67 ++++------------------------------
 1 file changed, 8 insertions(+), 59 deletions(-)

diff --git a/drivers/cpufreq/exynos4210-cpufreq.c b/drivers/cpufreq/exynos4210-cpufreq.c
index add7fbe..f2c7506 100644
--- a/drivers/cpufreq/exynos4210-cpufreq.c
+++ b/drivers/cpufreq/exynos4210-cpufreq.c
@@ -81,9 +81,9 @@ static void exynos4210_set_clkdiv(unsigned int div_index)
 
 static void exynos4210_set_apll(unsigned int index)
 {
-	unsigned int tmp;
+	unsigned int tmp, freq = apll_freq_4210[index].freq;
 
-	/* 1. MUX_CORE_SEL = MPLL, ARMCLK uses MPLL for lock time */
+	/* MUX_CORE_SEL = MPLL, ARMCLK uses MPLL for lock time */
 	clk_set_parent(moutcore, mout_mpll);
 
 	do {
@@ -92,21 +92,9 @@ static void exynos4210_set_apll(unsigned int index)
 		tmp &= 0x7;
 	} while (tmp != 0x2);
 
-	/* 2. Set APLL Lock time */
-	__raw_writel(EXYNOS4_APLL_LOCKTIME, EXYNOS4_APLL_LOCK);
-
-	/* 3. Change PLL PMS values */
-	tmp = __raw_readl(EXYNOS4_APLL_CON0);
-	tmp &= ~((0x3ff << 16) | (0x3f << 8) | (0x7 << 0));
-	tmp |= apll_freq_4210[index].mps;
-	__raw_writel(tmp, EXYNOS4_APLL_CON0);
+	clk_set_rate(mout_apll, freq * 1000);
 
-	/* 4. wait_lock_time */
-	do {
-		tmp = __raw_readl(EXYNOS4_APLL_CON0);
-	} while (!(tmp & (0x1 << EXYNOS4_APLLCON0_LOCKED_SHIFT)));
-
-	/* 5. MUX_CORE_SEL = APLL */
+	/* MUX_CORE_SEL = APLL */
 	clk_set_parent(moutcore, mout_apll);
 
 	do {
@@ -115,53 +103,15 @@ static void exynos4210_set_apll(unsigned int index)
 	} while (tmp != (0x1 << EXYNOS4_CLKSRC_CPU_MUXCORE_SHIFT));
 }
 
-static bool exynos4210_pms_change(unsigned int old_index, unsigned int new_index)
-{
-	unsigned int old_pm = apll_freq_4210[old_index].mps >> 8;
-	unsigned int new_pm = apll_freq_4210[new_index].mps >> 8;
-
-	return (old_pm == new_pm) ? 0 : 1;
-}
-
 static void exynos4210_set_frequency(unsigned int old_index,
 				     unsigned int new_index)
 {
-	unsigned int tmp;
-
 	if (old_index > new_index) {
-		if (!exynos4210_pms_change(old_index, new_index)) {
-			/* 1. Change the system clock divider values */
-			exynos4210_set_clkdiv(new_index);
-
-			/* 2. Change just s value in apll m,p,s value */
-			tmp = __raw_readl(EXYNOS4_APLL_CON0);
-			tmp &= ~(0x7 << 0);
-			tmp |= apll_freq_4210[new_index].mps & 0x7;
-			__raw_writel(tmp, EXYNOS4_APLL_CON0);
-		} else {
-			/* Clock Configuration Procedure */
-			/* 1. Change the system clock divider values */
-			exynos4210_set_clkdiv(new_index);
-			/* 2. Change the apll m,p,s value */
-			exynos4210_set_apll(new_index);
-		}
+		exynos4210_set_clkdiv(new_index);
+		exynos4210_set_apll(new_index);
 	} else if (old_index < new_index) {
-		if (!exynos4210_pms_change(old_index, new_index)) {
-			/* 1. Change just s value in apll m,p,s value */
-			tmp = __raw_readl(EXYNOS4_APLL_CON0);
-			tmp &= ~(0x7 << 0);
-			tmp |= apll_freq_4210[new_index].mps & 0x7;
-			__raw_writel(tmp, EXYNOS4_APLL_CON0);
-
-			/* 2. Change the system clock divider values */
-			exynos4210_set_clkdiv(new_index);
-		} else {
-			/* Clock Configuration Procedure */
-			/* 1. Change the apll m,p,s value */
-			exynos4210_set_apll(new_index);
-			/* 2. Change the system clock divider values */
-			exynos4210_set_clkdiv(new_index);
-		}
+		exynos4210_set_apll(new_index);
+		exynos4210_set_clkdiv(new_index);
 	}
 }
 
@@ -194,7 +144,6 @@ int exynos4210_cpufreq_init(struct exynos_dvfs_info *info)
 	info->volt_table = exynos4210_volt_table;
 	info->freq_table = exynos4210_freq_table;
 	info->set_freq = exynos4210_set_frequency;
-	info->need_apll_change = exynos4210_pms_change;
 
 	return 0;
 
-- 
1.7.10.4

