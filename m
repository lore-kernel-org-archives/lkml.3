Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3GIXUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 19:20:38 -0400
Received: from mail-yh0-f73.google.com ([209.85.213.73]:50696 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3GIXTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 19:19:30 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Olof Johansson <olof@lixom.net>, Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] mmc: dw_mmc: Add exynos resume_noirq callback to clear WAKEUP_INT
Date: Tue,  9 Jul 2013 16:19:19 -0700
Message-Id: <1373411961-23812-4-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1373411961-23812-1-git-send-email-dianders@chromium.org>
References: <1373391071-6312-1-git-send-email-dianders@chromium.org>
 <1373411961-23812-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the WAKEUP_INT is asserted at wakeup and not cleared, we'll end up
looping around forever.  This has been seen to happen on exynos5420
silicon despite the fact that we haven't enabled any wakeup events.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Use suspend_noirq as per James Hogan.

 drivers/mmc/host/dw_mmc-exynos.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
index f013e7e..36b9620 100644
--- a/drivers/mmc/host/dw_mmc-exynos.c
+++ b/drivers/mmc/host/dw_mmc-exynos.c
@@ -30,6 +30,7 @@
 #define SDMMC_CLKSEL_TIMING(x, y, z)	(SDMMC_CLKSEL_CCLK_SAMPLE(x) |	\
 					SDMMC_CLKSEL_CCLK_DRIVE(y) |	\
 					SDMMC_CLKSEL_CCLK_DIVIDER(z))
+#define SDMMC_CLKSEL_WAKEUP_INT		BIT(11)
 
 #define SDMMC_CMD_USE_HOLD_REG		BIT(29)
 
@@ -102,6 +103,27 @@ static int dw_mci_exynos_setup_clock(struct dw_mci *host)
 	return 0;
 }
 
+/**
+ * dw_mci_exynos_resume_noirq - Exynos-specific resume code
+ *
+ * We have seen cases (at least on the exynos5420) where turning off the INT
+ * power rail during suspend will leave the WAKEUP_INT bit in the CLKSEL
+ * register asserted.  This bit is 1 to indicate that it fired and we can
+ * clear it by writing a 1 back.  Clear it to prevent interrupts from going off
+ * constantly.
+ */
+
+static int dw_mci_exynos_resume_noirq(struct dw_mci *host)
+{
+	u32 clksel;
+
+	clksel = mci_readl(host, CLKSEL);
+	if (clksel & SDMMC_CLKSEL_WAKEUP_INT)
+		mci_writel(host, CLKSEL, clksel);
+
+	return 0;
+}
+
 static void dw_mci_exynos_prepare_command(struct dw_mci *host, u32 *cmdr)
 {
 	/*
@@ -165,6 +187,7 @@ static const struct dw_mci_drv_data exynos_drv_data = {
 	.caps			= exynos_dwmmc_caps,
 	.init			= dw_mci_exynos_priv_init,
 	.setup_clock		= dw_mci_exynos_setup_clock,
+	.resume_noirq		= dw_mci_exynos_resume_noirq,
 	.prepare_command	= dw_mci_exynos_prepare_command,
 	.set_ios		= dw_mci_exynos_set_ios,
 	.parse_dt		= dw_mci_exynos_parse_dt,
-- 
1.8.3

