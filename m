Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaIVSD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:03:26 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:50161 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbaIVSDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:03:08 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, computersforpeace@gmail.com,
        thomas.petazzoni@free-electrons.com,
        linux-arm-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v3 2/2] bus: brcmstb_gisb: save and restore GISB timeout
Date: Mon, 22 Sep 2014 11:02:46 -0700
Message-Id: <1411408966-15390-3-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411408966-15390-1-git-send-email-f.fainelli@gmail.com>
References: <1411408966-15390-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the system enters S3, we will lose the GISB timeout value we have
configured, make sure that we do save this timeout value, and restore
this timeout value prior to re-enabling interrupts such that the GISB
timeout interrupt will fire with the expected timeout.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
- took the hunk that adds the saved_timeout here instead of in patch 1

 drivers/bus/brcmstb_gisb.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/bus/brcmstb_gisb.c b/drivers/bus/brcmstb_gisb.c
index 41b09418f515..e7ccd21a45c9 100644
--- a/drivers/bus/brcmstb_gisb.c
+++ b/drivers/bus/brcmstb_gisb.c
@@ -23,6 +23,7 @@
 #include <linux/list.h>
 #include <linux/of.h>
 #include <linux/bitops.h>
+#include <linux/pm.h>
 
 #include <asm/bug.h>
 #include <asm/signal.h>
@@ -48,6 +49,7 @@ struct brcmstb_gisb_arb_device {
 	struct list_head next;
 	u32 valid_mask;
 	const char *master_names[sizeof(u32) * BITS_PER_BYTE];
+	u32 saved_timeout;
 };
 
 static LIST_HEAD(brcmstb_gisb_arb_device_list);
@@ -264,6 +266,39 @@ static int brcmstb_gisb_arb_probe(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int brcmstb_gisb_arb_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct brcmstb_gisb_arb_device *gdev = platform_get_drvdata(pdev);
+
+	gdev->saved_timeout = ioread32(gdev->base + ARB_TIMER);
+
+	return 0;
+}
+
+/* Make sure we provide the same timeout value that was configured before, and
+ * do this before the GISB timeout interrupt handler has any chance to run.
+ */
+static int brcmstb_gisb_arb_resume_noirq(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct brcmstb_gisb_arb_device *gdev = platform_get_drvdata(pdev);
+
+	iowrite32(gdev->saved_timeout, gdev->base + ARB_TIMER);
+
+	return 0;
+}
+#else
+#define brcmstb_gisb_arb_suspend       NULL
+#define brcmstb_gisb_arb_resume_noirq  NULL
+#endif
+
+static const struct dev_pm_ops brcmstb_gisb_arb_pm_ops = {
+	.suspend	= brcmstb_gisb_arb_suspend,
+	.resume_noirq	= brcmstb_gisb_arb_resume_noirq,
+};
+
 static const struct of_device_id brcmstb_gisb_arb_of_match[] = {
 	{ .compatible = "brcm,gisb-arb" },
 	{ },
@@ -275,6 +310,7 @@ static struct platform_driver brcmstb_gisb_arb_driver = {
 		.name	= "brcm-gisb-arb",
 		.owner	= THIS_MODULE,
 		.of_match_table = brcmstb_gisb_arb_of_match,
+		.pm	= &brcmstb_gisb_arb_pm_ops,
 	},
 };
 
-- 
1.9.1

