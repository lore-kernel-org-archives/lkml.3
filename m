Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3IYLWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 07:22:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44008 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3IYLWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 07:22:35 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-d0-5242c77a6364
From: Lukasz Majewski <l.majewski@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org
Subject: [PATCH 1/2] cpufreq: exynos4x12: Use the common clock framework to set
 APLL clock rate
Date: Wed, 25 Sep 2013 13:22:17 +0200
Message-id: <1380108138-30402-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380108138-30402-1-git-send-email-l.majewski@samsung.com>
References: <1380108138-30402-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t9jQd2q405BBjdmqllsnLGe1aJ3wVU2
	i/7Hr5kt3jzitnjzcDOjxeVdc9gsPvceYbSYcX4fk8XtxhVAFQt7mSzWz3jNYrHxq4cDj8em
	VZ1sHneu7WHzWDftLbNH35ZVjB6PFrcwenzeJBfAFsVlk5Kak1mWWqRvl8CVsf7OXqaC9QIV
	z+8+YmxgPMDbxcjJISFgInHs/HlGCFtM4sK99WxdjFwcQgLTGSWe7zwM5XQxSazrOQNWxSag
	J/H57lMmEFtEwFdi7ePLjCBFzAILmCWWnNrGCpIQFkiUuLhuClgDi4CqxIV939hAbF4BN4m3
	WzaxQKyTl3h6vw8szingLrF8/WqwXiGgmiMX77BMYORdwMiwilE0tSC5oDgpPddQrzgxt7g0
	L10vOT93EyM4IJ9J7WBc2WBxiFGAg1GJh1fgqGOQEGtiWXFl7iFGCQ5mJRHe8MVOQUK8KYmV
	ValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoYmVgW6Py87lE+m71E
	P/CPs/WUVVv2vN9VusCuQvintXDWKndukydtzc6epYvrc6S8jaZ+PH7/1J2Xu233lSp/LVB9
	xv5tpmbZRga/l81HuqUnN8xmemCs42N4ZMIih2+LTjcefpj73/b7Tv9W+TNL5zU+1L6y+35/
	AW/FmTdn75j8CFKXPWbxSYmlOCPRUIu5qDgRADapT7xEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the exynos4x12_set_apll() function, the APLL frequency is set with
direct register manipulation.

Such approach is not allowed in the common clock framework. The frequency
is changed, but the corresponding clock value is not updated. This causes
wrong frequency read from cpufreq's cpuinfo_cur_freq sysfs attribute.

Tested at:
- Exynos4412 - Trats2 board (linux 3.12-rc1)

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 drivers/cpufreq/exynos4x12-cpufreq.c |   23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/cpufreq/exynos4x12-cpufreq.c b/drivers/cpufreq/exynos4x12-cpufreq.c
index 08b7477..b2f51c9 100644
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
-- 
1.7.10.4

