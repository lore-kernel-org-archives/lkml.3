Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaFXN6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:58:48 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19790 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbaFXN5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:57:49 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-be-53a983da94ca
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 5/6] ARM: EXYNOS: Fix suspend/resume sequencies
Date: Tue, 24 Jun 2014 15:57:14 +0200
Message-id: <1403618235-19353-6-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLJMWRmVeSWpSXmKPExsVy+t/xq7q3mlcGGzw6LWPRu+Aqm8Wmx9dY
	LS7vmsNmMeP8PiaLtUfuslusn/GaxWLVrj+MDuweO2fdZffYvKTeo2/LKkaPz5vkAliiuGxS
	UnMyy1KL9O0SuDKmPprAVnCCt2LKAbMGxq9cXYwcHBICJhKPzwl1MXICmWISF+6tZ+ti5OIQ
	EljKKHH1SDsTSEJIoI9J4nBrAYjNJqAm8bnhERuILSKgKvG5bQE7iM0s8IRRYtZTNxBbWMBe
	onvNBUYQmwWo5vDfr2A2r4CTxO2361ghlslJ9G57wwxicwo4S+xs38YKsctJ4v/JJqYJjLwL
	GBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoQE0dcdjEuPWR1iFOBgVOLhrdixIliINbGs
	uDL3EKMEB7OSCO+NmpXBQrwpiZVVqUX58UWlOanFhxiZODilGhiVbu2/4Kghnr4rozXzcH+K
	umT0kgaO/1N6RV4rPnxk6P2tL7vRkOPxri9LTjC01We+vPmMP/Wcx4cdHrIpnZV9P42+dKXP
	4dcw1nv6uubaYZcp8x6sZzRevVMwIXvtjOodNUFF1x80qIsu5BNlqdT6yVMlF8x+7oXHHN8N
	t5Xvyjw87JEieE6JpTgj0VCLuag4EQDUkBt2AAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to recent consolidation of Exynos suspend and cpuidle code, some
parts of suspend and resume sequences are executed two times, once from
exynos_pm_syscore_ops and then from exynos_cpu_pm_notifier() and thus it
breaks suspend, at least on Exynos4-based boards.

This patch fixes the issue by removing exynos_pm_syscore_ops completely
and making the code rely only on CPU PM notifier.

Tested on Exynos4210-based Trats board.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/pm.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 87c0d34..98d4926 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -364,11 +364,6 @@ early_wakeup:
 	return;
 }
 
-static struct syscore_ops exynos_pm_syscore_ops = {
-	.suspend	= exynos_pm_suspend,
-	.resume		= exynos_pm_resume,
-};
-
 /*
  * Suspend Ops
  */
@@ -438,19 +433,13 @@ static int exynos_cpu_pm_notifier(struct notifier_block *self,
 
 	switch (cmd) {
 	case CPU_PM_ENTER:
-		if (cpu == 0) {
-			exynos_pm_central_suspend();
-			exynos_cpu_save_register();
-		}
+		if (cpu == 0)
+			exynos_pm_suspend();
 		break;
 
 	case CPU_PM_EXIT:
-		if (cpu == 0) {
-			if (!soc_is_exynos5250())
-				scu_enable(S5P_VA_SCU);
-			exynos_cpu_restore_register();
-			exynos_pm_central_resume();
-		}
+		if (cpu == 0)
+			exynos_pm_resume();
 		break;
 	}
 
@@ -475,6 +464,5 @@ void __init exynos_pm_init(void)
 	tmp |= ((0xFF << 8) | (0x1F << 1));
 	__raw_writel(tmp, S5P_WAKEUP_MASK);
 
-	register_syscore_ops(&exynos_pm_syscore_ops);
 	suspend_set_ops(&exynos_suspend_ops);
 }
-- 
1.9.3

