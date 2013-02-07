Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab3BGMjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:39:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44916 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab3BGMjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:39:31 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <khilman@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>
CC: <afzal@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, <hvaibhav@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH v2 4/4] mtd: nand: omap2: Low power transition support
Date: Thu, 7 Feb 2013 18:06:58 +0530
Message-ID: <1360240618-11094-5-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360240618-11094-1-git-send-email-avinashphilip@ti.com>
References: <1360240618-11094-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Low power transition support in nand driver. Also
ensures the current transaction finishes before going to low power mode
with _suspend support in mtd layer.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 drivers/mtd/nand/omap2.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 8e820dd..790215b 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -2103,9 +2103,28 @@ static int omap_nand_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int omap_nand_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct mtd_info *mtd = platform_get_drvdata(pdev);
+
+	mtd->_suspend(mtd);
+	return 0;
+}
+
+static int omap_nand_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+#endif
+
 static struct platform_driver omap_nand_driver = {
 	.probe		= omap_nand_probe,
 	.remove		= omap_nand_remove,
+#ifdef CONFIG_PM
+	.suspend	= omap_nand_suspend,
+	.resume		= omap_nand_resume,
+#endif
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
-- 
1.7.9.5

