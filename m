Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab3BGMiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:38:55 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54556 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3BGMix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:38:53 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <khilman@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>
CC: <afzal@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, <hvaibhav@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH v2 2/4] arm: gpmc: Low power transition support
Date: Thu, 7 Feb 2013 18:06:56 +0530
Message-ID: <1360240618-11094-3-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360240618-11094-1-git-send-email-avinashphilip@ti.com>
References: <1360240618-11094-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With GPMC converted to platform driver recently, adds low power
transition support in driver itself.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
Changes since v1:
	Module disable & enable added using pm_runtime support.

 arch/arm/mach-omap2/gpmc.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index b1cd6c1..cc57988 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1361,9 +1361,29 @@ static __devexit int gpmc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int gpmc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	omap3_gpmc_save_context();
+	pm_runtime_put_sync(&pdev->dev);
+	return 0;
+}
+
+static int gpmc_resume(struct platform_device *pdev)
+{
+	pm_runtime_get_sync(&pdev->dev);
+	omap3_gpmc_restore_context();
+	return 0;
+}
+#endif
+
 static struct platform_driver gpmc_driver = {
 	.probe		= gpmc_probe,
 	.remove		= __devexit_p(gpmc_remove),
+#ifdef CONFIG_PM
+	.suspend	= gpmc_suspend,
+	.resume		= gpmc_resume,
+#endif
 	.driver		= {
 		.name	= DEVICE_NAME,
 		.owner	= THIS_MODULE,
-- 
1.7.9.5

