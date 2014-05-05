Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbaEEK7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 06:59:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53373 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaEEK7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 06:59:08 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-b7-53676ef10155
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH 2/7] ARM: EXYNOS: add support for firmware-assisted c15resume
Date: Mon, 05 May 2014 12:57:14 +0200
Message-id: <1399287439-31376-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1399287439-31376-1-git-send-email-b.zolnierkie@samsung.com>
References: <1399287439-31376-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAd2PeenBBpP/6lhsnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLM6cvsRqcfJPL6PF+hmvWSw2
	fvVw4PW4c20Pm8fmJfUet/89ZvbYcrWdxaNvyypGj8+b5ALYorhsUlJzMstSi/TtErgyVq99
	z1Lwiqfi/ed+pgbGe1xdjJwcEgImEn1v7zBC2GISF+6tZ+ti5OIQEljEKNHfs5wdwulikti0
	8jUbSBWbgJXExPZVYB0iAmoSPYu3MoIUMQvsZZZY2r2JHSQhLOAr8fXUJTCbRUBVYsvEj0BF
	HBy8Ah4SDcsEILYpSnQ/mwA2k1PAU2Lp5sfMILYQUMmGt+1sExh5FzAyrGIUTS1ILihOSs81
	1CtOzC0uzUvXS87P3cQIDstnUjsYVzZYHGIU4GBU4uFNYE4PFmJNLCuuzD3EKMHBrCTCm50I
	FOJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cA454B3/4VV
	U3Wcmr88ObFoz5PMswrt7Jem8E2Y1LHxotLEtcfLp35csCfBdwpnaeytqU+MUvZ8zFt89XRO
	xkrFQ2fMvjxbayayPn2uurZd6r/c+d8UWbOeSLWXdoY8Sns/T8iw5WL1QgHGv//3xXiZV2tb
	T1s0W85LT2vpS6YFwUUfvsxe5h9XrMRSnJFoqMVcVJwIAGf3/HpHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

This change is a preparation for adding secure firmware support to
EXYNOS cpuidle driver.

This patch shouldn't cause any functionality changes.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
[bzolnier: splitted out from bigger patch]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 arch/arm/include/asm/firmware.h | 4 ++++
 arch/arm/mach-exynos/firmware.c | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm/include/asm/firmware.h b/arch/arm/include/asm/firmware.h
index c72ec47..70883c7 100644
--- a/arch/arm/include/asm/firmware.h
+++ b/arch/arm/include/asm/firmware.h
@@ -41,6 +41,10 @@ struct firmware_ops {
 	 * Initializes L2 cache
 	 */
 	int (*l2x0_init)(void);
+	/*
+	 * Restores coprocessor 15 registers
+	 */
+	int (*c15resume)(u32 *regs);
 };
 
 /* Global pointer for current firmware_ops structure, can't be NULL. */
diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index 932129e..581c7bf 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -40,10 +40,18 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
 	return 0;
 }
 
+static int exynos_c15resume(u32 *regs)
+{
+	exynos_smc(SMC_CMD_C15RESUME, regs[0], regs[1], 0);
+
+	return 0;
+}
+
 static const struct firmware_ops exynos_firmware_ops = {
 	.do_idle		= exynos_do_idle,
 	.set_cpu_boot_addr	= exynos_set_cpu_boot_addr,
 	.cpu_boot		= exynos_cpu_boot,
+	.c15resume	= exynos_c15resume,
 };
 
 void __init exynos_firmware_init(void)
-- 
1.8.2.3

