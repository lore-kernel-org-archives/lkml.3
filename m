Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbaLWQUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:20:19 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:54692 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaLWQUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:20:17 -0500
From: Dmitry Osipenko <digetx@gmail.com>
To: digetx@gmail.com, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: <stable@vger.kernel.org>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] soc: tegra: pmc: Use syscore PM ops
Date: Tue, 23 Dec 2014 19:15:37 +0300
Message-Id: <1419351358-6201-1-git-send-email-digetx@gmail.com>
X-Mailer: git-send-email 2.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7232398abc6a ("ARM: tegra: Convert PMC to a driver") changed tegra_resume()
location storing from late to early and as result broke suspend on Tegra20.
PMC scratch register 41 is used by tegra LP1 resume code for retrieving stored
physical memory address of common resume function and in the same time used by
Tegra20 cpuidle driver for storing cpu1 "resettable" status, it implies strict
order of scratch register use. Fix it by making PMC driver use syscore PM ops to
ensure that tegra_resume() location is stored after cpuidle driver suspend and
before resume respectively.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Fixes: 7232398abc6a (ARM: tegra: Convert PMC to a driver)
Cc: <stable@vger.kernel.org> # v3.17+
---
 drivers/soc/tegra/pmc.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
index a2c0ceb..4ebd94a 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -33,6 +33,7 @@
 #include <linux/reset.h>
 #include <linux/seq_file.h>
 #include <linux/spinlock.h>
+#include <linux/syscore_ops.h>
 
 #include <soc/tegra/common.h>
 #include <soc/tegra/fuse.h>
@@ -703,6 +704,23 @@ static void tegra_pmc_init(struct tegra_pmc *pmc)
 	tegra_pmc_writel(value, PMC_CNTRL);
 }
 
+static int tegra_pmc_suspend(void)
+{
+	tegra_pmc_writel(virt_to_phys(tegra_resume), PMC_SCRATCH41);
+
+	return 0;
+}
+
+static void tegra_pmc_resume(void)
+{
+	tegra_pmc_writel(0x0, PMC_SCRATCH41);
+}
+
+static struct syscore_ops tegra_pmc_syscore_ops = {
+	.suspend = tegra_pmc_suspend,
+	.resume = tegra_pmc_resume,
+};
+
 static int tegra_pmc_probe(struct platform_device *pdev)
 {
 	void __iomem *base = pmc->base;
@@ -736,27 +754,11 @@ static int tegra_pmc_probe(struct platform_device *pdev)
 			return err;
 	}
 
-	return 0;
-}
-
-#ifdef CONFIG_PM_SLEEP
-static int tegra_pmc_suspend(struct device *dev)
-{
-	tegra_pmc_writel(virt_to_phys(tegra_resume), PMC_SCRATCH41);
+	register_syscore_ops(&tegra_pmc_syscore_ops);
 
 	return 0;
 }
 
-static int tegra_pmc_resume(struct device *dev)
-{
-	tegra_pmc_writel(0x0, PMC_SCRATCH41);
-
-	return 0;
-}
-#endif
-
-static SIMPLE_DEV_PM_OPS(tegra_pmc_pm_ops, tegra_pmc_suspend, tegra_pmc_resume);
-
 static const char * const tegra20_powergates[] = {
 	[TEGRA_POWERGATE_CPU] = "cpu",
 	[TEGRA_POWERGATE_3D] = "3d",
@@ -894,7 +896,6 @@ static struct platform_driver tegra_pmc_driver = {
 		.name = "tegra-pmc",
 		.suppress_bind_attrs = true,
 		.of_match_table = tegra_pmc_match,
-		.pm = &tegra_pmc_pm_ops,
 	},
 	.probe = tegra_pmc_probe,
 };
-- 
2.2.0

