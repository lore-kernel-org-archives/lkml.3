Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab3HVQT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:19:26 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:45801 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab3HVQTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:19:23 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Doug Anderson <dianders@chromium.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 1/3] mmc: dw_mmc: Add exynos resume_noirq callback to clear WAKEUP_INT
Date: Thu, 22 Aug 2013 09:19:06 -0700
Message-Id: <1377188348-3418-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1377188348-3418-1-git-send-email-dianders@chromium.org>
References: <1377188348-3418-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the WAKEUP_INT is asserted at wakeup and not cleared, we'll end up
looping around forever.  This has been seen to happen on exynos5420
silicon despite the fact that we haven't enabled any wakeup events due
to a silicon errata.  It is safe to do on all exynos variants.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v6:
- Took out TODO comment copied from main platform code.

Changes in v5:
- Cleaned up dw_mci_exynos_resume_noirq() comment as per Seungwon.
- Don't memcpy dev_pm_ops structure, define a new one.

Changes in v4:
- Take Seungwon's suggestion and don't add any dw_mmc-pltfm code.

Changes in v3:
- Add freeze/thaw and poweroff/restore noirq entries.

Changes in v2:
- Use suspend_noirq as per James Hogan.

 drivers/mmc/host/dw_mmc-exynos.c | 53 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
index 866edef..e8c6cc9 100644
--- a/drivers/mmc/host/dw_mmc-exynos.c
+++ b/drivers/mmc/host/dw_mmc-exynos.c
@@ -30,6 +30,7 @@
 #define SDMMC_CLKSEL_TIMING(x, y, z)	(SDMMC_CLKSEL_CCLK_SAMPLE(x) |	\
 					SDMMC_CLKSEL_CCLK_DRIVE(y) |	\
 					SDMMC_CLKSEL_CCLK_DIVIDER(z))
+#define SDMMC_CLKSEL_WAKEUP_INT		BIT(11)
 
 #define EXYNOS4210_FIXED_CIU_CLK_DIV	2
 #define EXYNOS4412_FIXED_CIU_CLK_DIV	4
@@ -100,6 +101,49 @@ static int dw_mci_exynos_setup_clock(struct dw_mci *host)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int dw_mci_exynos_suspend(struct device *dev)
+{
+	struct dw_mci *host = dev_get_drvdata(dev);
+
+	return dw_mci_suspend(host);
+}
+
+static int dw_mci_exynos_resume(struct device *dev)
+{
+	struct dw_mci *host = dev_get_drvdata(dev);
+
+	return dw_mci_resume(host);
+}
+
+/**
+ * dw_mci_exynos_resume_noirq - Exynos-specific resume code
+ *
+ * On exynos5420 there is a silicon errata that will sometimes leave the
+ * WAKEUP_INT bit in the CLKSEL register asserted.  This bit is 1 to indicate
+ * that it fired and we can clear it by writing a 1 back.  Clear it to prevent
+ * interrupts from going off constantly.
+ *
+ * We run this code on all exynos variants because it doesn't hurt.
+ */
+
+static int dw_mci_exynos_resume_noirq(struct device *dev)
+{
+	struct dw_mci *host = dev_get_drvdata(dev);
+	u32 clksel;
+
+	clksel = mci_readl(host, CLKSEL);
+	if (clksel & SDMMC_CLKSEL_WAKEUP_INT)
+		mci_writel(host, CLKSEL, clksel);
+
+	return 0;
+}
+#else
+#define dw_mci_exynos_suspend		NULL
+#define dw_mci_exynos_resume		NULL
+#define dw_mci_exynos_resume_noirq	NULL
+#endif /* CONFIG_PM_SLEEP */
+
 static void dw_mci_exynos_prepare_command(struct dw_mci *host, u32 *cmdr)
 {
 	/*
@@ -187,13 +231,20 @@ static int dw_mci_exynos_probe(struct platform_device *pdev)
 	return dw_mci_pltfm_register(pdev, drv_data);
 }
 
+const struct dev_pm_ops dw_mci_exynos_pmops = {
+	SET_SYSTEM_SLEEP_PM_OPS(dw_mci_exynos_suspend, dw_mci_exynos_resume)
+	.resume_noirq = dw_mci_exynos_resume_noirq,
+	.thaw_noirq = dw_mci_exynos_resume_noirq,
+	.restore_noirq = dw_mci_exynos_resume_noirq,
+};
+
 static struct platform_driver dw_mci_exynos_pltfm_driver = {
 	.probe		= dw_mci_exynos_probe,
 	.remove		= __exit_p(dw_mci_pltfm_remove),
 	.driver		= {
 		.name		= "dwmmc_exynos",
 		.of_match_table	= dw_mci_exynos_match,
-		.pm		= &dw_mci_pltfm_pmops,
+		.pm		= &dw_mci_exynos_pmops,
 	},
 };
 
-- 
1.8.3

