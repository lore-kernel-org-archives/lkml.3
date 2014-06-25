Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbaFYLxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:53:38 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61325 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaFYLxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:53:36 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-c8-53aab83d67b0
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v2 5/6] ARM: EXYNOS: Fix suspend/resume sequences
Date: Wed, 25 Jun 2014 13:52:55 +0200
Message-id: <1403697175-13476-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xq7q2O1YFG/Q2Glqs+atk0bvgKpvF
	psfXWC0u75rDZjHj/D4mi7VH7rJbrJ/xmsVi1a4/jA4cHjtn3WX32Lyk3qNvyypGj8+b5AJY
	orhsUlJzMstSi/TtErgy1j1dxljwla/iw+o1LA2Mf7i7GDk5JARMJK6dbmGBsMUkLtxbz9bF
	yMUhJLCUUWL1vt3MEE4fk8T5txMZQarYBNQkPjc8YgOxRQRUJT63LWAHKWIWmMokcWXzA1aQ
	hLCAo8Tv5sVMIDYLUNG5qbfBbF4BJ4lDy86wQ6yTk+jd9oYZxOYUcJbY2b4NrFcIqOb/ySam
	CYy8CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKEBNWXHYyLj1kdYhTgYFTi4Q3gWRUs
	xJpYVlyZe4hRgoNZSYS3fgNQiDclsbIqtSg/vqg0J7X4ECMTB6dUA2P+RfNZSq6J5f1/pph9
	lLqcvb3s0LqHSXp5M7jXrLS9GsiZt634j4p2fvmkm04+tl4ts588fCIa99lw2ZdlLx6Z2Xe8
	erNmw55LR39u2zZvCue6yEcP5Cbe7ey3uFm60syu3Jt9w8FYlv88Dxe51Go+vjL/wJ55b4/y
	HZf7EHaa9/yRMM3U2lV3lViKMxINtZiLihMB+N7QFAgCAAA=
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
 arch/arm/mach-exynos/pm.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

Changes since v1:
 - rebased onto Kukjin's fixes branch.

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 202ca73..f23cc77 100644
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
@@ -438,22 +433,13 @@ static int exynos_cpu_pm_notifier(struct notifier_block *self,
 
 	switch (cmd) {
 	case CPU_PM_ENTER:
-		if (cpu == 0) {
-			exynos_pm_central_suspend();
-			if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9)
-				exynos_cpu_save_register();
-		}
+		if (cpu == 0)
+			exynos_pm_suspend();
 		break;
 
 	case CPU_PM_EXIT:
-		if (cpu == 0) {
-			if (read_cpuid_part_number() ==
-					ARM_CPU_PART_CORTEX_A9) {
-				scu_enable(S5P_VA_SCU);
-				exynos_cpu_restore_register();
-			}
-			exynos_pm_central_resume();
-		}
+		if (cpu == 0)
+			exynos_pm_resume();
 		break;
 	}
 
@@ -478,6 +464,5 @@ void __init exynos_pm_init(void)
 	tmp |= ((0xFF << 8) | (0x1F << 1));
 	__raw_writel(tmp, S5P_WAKEUP_MASK);
 
-	register_syscore_ops(&exynos_pm_syscore_ops);
 	suspend_set_ops(&exynos_suspend_ops);
 }
-- 
1.9.3

