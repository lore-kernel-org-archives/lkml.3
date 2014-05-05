Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbaEELAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 07:00:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53486 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468AbaEEK76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 06:59:58 -0400
X-AuditID: cbfee61b-b7f766d00000646c-d0-53676f2dc39a
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
Subject: [PATCH 6/7] ARM: EXYNOS: PM: fix register setup on EXYNOS4x12 for AFTR
 mode code
Date: Mon, 05 May 2014 12:57:18 +0200
Message-id: <1399287439-31376-7-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1399287439-31376-1-git-send-email-b.zolnierkie@samsung.com>
References: <1399287439-31376-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAV3d/PRgg5Y2KYuNM9azWsz7LGvR
	u+Aqm8XZpjfsFu8PPWO22PT4GqvF5V1z2Cw+9x5htJhxfh+TxZnTl1gtTv7pZbRYP+M1i8XG
	rx4OvB53ru1h89i8pN7j9r/HzB5brrazePRtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfGzJtf
	2AvmclTMm/CbqYHxNlsXIyeHhICJxMnmT8wQtpjEhXvrgeJcHEICixglPs46CuV0MUlc3DUX
	rIpNwEpiYvsqRhBbREBNomfxVkaQImaBvcwSS7s3sYMkhAWiJdb9amDpYuTgYBFQlfi4ORQk
	zCvgITGnbSkTxDZFie5nE8Cu4BTwlFi6+THYfCGgmg1v29kmMPIuYGRYxSiaWpBcUJyUnmuk
	V5yYW1yal66XnJ+7iREcls+kdzCuarA4xCjAwajEw5vAnB4sxJpYVlyZe4hRgoNZSYQ3OxEo
	xJuSWFmVWpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJg1OqgTFd5EuiguKz
	zbH21bI+PM7z9ws8eJu5NumXRo1F5q9N3lnaxd0vPjoWfmqIivzWXJc/oas5eM4H27xk7Q7H
	xf9X835dfHfV/P2f13OZ+p6y9f3JeoZZw+PpiifOPyrqW+vNOm96P1l9enXcLePjr55NnjOn
	YcfnSp+9JmLh1TlL4vddf+hy6b4SS3FGoqEWc1FxIgAEjLC8RwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add S5P_CENTRAL_SEQ_OPTION register setup for EXYNOS4x12 to AFTR
mode code.  Without this setup AFTR mode doesn't show any benefit
over WFI one.  When this setup is applied AFTR mode reduces power
consumption by ~12% (as measured on Trats2 board).

This change is a preparation for adding secure firmware support to
EXYNOS cpuidle driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 arch/arm/mach-exynos/pm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 18f6bf8..3922968 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -391,6 +391,10 @@ static int exynos_cpu_pm_notifier(struct notifier_block *self,
 	case CPU_PM_ENTER:
 		if (cpu == 0) {
 			exynos_pm_central_suspend();
+			if (soc_is_exynos4212() || soc_is_exynos4412())
+				__raw_writel(S5P_USE_STANDBY_WFI0 |
+					     S5P_USE_STANDBY_WFE0,
+					     S5P_CENTRAL_SEQ_OPTION);
 			exynos_cpu_save_register();
 		}
 		break;
-- 
1.8.2.3

