Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3IYLWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 07:22:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44015 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3IYLWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 07:22:40 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-d7-5242c77e48b0
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
Subject: [PATCH 2/2] cpufreq: exynos4210: Use the common clock framework to set
 APLL clock rate
Date: Wed, 25 Sep 2013 13:22:18 +0200
Message-id: <1380108138-30402-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380108138-30402-1-git-send-email-l.majewski@samsung.com>
References: <1380108138-30402-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jQd26405BBi8mWFpsnLGe1aJ3wVU2
	i/7Hr5kt3jzitnjzcDOjxeVdc9gsPvceYbSYcX4fk8XtxhVAFQt7mSzWz3jNYrHxq4cDj8em
	VZ1sHneu7WHzWDftLbNH35ZVjB6PFrcwenzeJBfAFsVlk5Kak1mWWqRvl8CVMWFvfcF7vooL
	W8+wNzDO4eli5OSQEDCRePDjODOELSZx4d56ti5GLg4hgemMEmsurWOHcLqYJF71rWIFqWIT
	0JP4fPcpE4gtIuArsfbxZUaQImaBBcwSS05tAysSFkiU+PL7FtAoDg4WAVWJp/PjQcK8Am4S
	e2/dZITYJi/x9H4fG4jNKeAusXz9arBWIaCaIxfvsExg5F3AyLCKUTS1ILmgOCk911CvODG3
	uDQvXS85P3cTIzgYn0ntYFzZYHGIUYCDUYmHV+CoY5AQa2JZcWXuIUYJDmYlEd7wxU5BQrwp
	iZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhg3Osw8vmLj1hkN
	zAv8Gp784PV6LWP7d9IqA7u19ZddjxdL1nCL9J0wqdt2stQ9bZ3JxHZpnQkW1+95vD4j9Wj5
	IsVG4wqG+yV2D2zUg/6V8L3qkP8p8nvTy2bvSTtmNBiqfGqZOv+WhqjupOL3LM+0dCSC1yw2
	TPdqnHIsKX8Raz2/mhHvciYlluKMREMt5qLiRABa/bZ8QgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the exynos4210_set_apll() function, the APLL frequency is set with
direct register manipulation.

Such approach is not allowed in the common clock framework. The frequency
is changed, but the corresponding clock value is not updated. This causes
wrong frequency read from cpufreq's cpuinfo_cur_freq sysfs attribute.

Tested at:
- Exynos4210 - Trats board (linux 3.12-rc1)

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 drivers/cpufreq/exynos4210-cpufreq.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/cpufreq/exynos4210-cpufreq.c b/drivers/cpufreq/exynos4210-cpufreq.c
index add7fbe..363c658 100644
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
-
-	/* 4. wait_lock_time */
-	do {
-		tmp = __raw_readl(EXYNOS4_APLL_CON0);
-	} while (!(tmp & (0x1 << EXYNOS4_APLLCON0_LOCKED_SHIFT)));
+	clk_set_rate(mout_apll, freq * 1000);
 
-	/* 5. MUX_CORE_SEL = APLL */
+	/* MUX_CORE_SEL = APLL */
 	clk_set_parent(moutcore, mout_apll);
 
 	do {
-- 
1.7.10.4

