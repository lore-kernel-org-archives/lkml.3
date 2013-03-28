Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab3C1QM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:12:26 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:46324 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859Ab3C1QML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:11 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/33] regulator: ab8500: Init debug from regulator driver
Date: Thu, 28 Mar 2013 16:11:09 +0000
Message-Id: <1364487093-19551-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to guarantee that ab8500-debug will
record the regulator registers before they are modified by the
ab8500 regulator driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c       |   10 ++++++++++
 include/linux/regulator/ab8500.h |   14 ++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 4d88a60..bf34c4c 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -911,6 +911,11 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	/* initialize debug (initial state is recorded with this call) */
+	err = ab8500_regulator_debug_init(pdev);
+	if (err)
+		return err;
+
 	/* initialize registers */
 	for (i = 0; i < pdata->num_reg_init; i++) {
 		int id, mask, value;
@@ -961,6 +966,11 @@ static int ab8500_regulator_remove(struct platform_device *pdev)
 	if (err)
 		return err;
 
+	/* remove regulator debug */
+	err = ab8500_regulator_debug_exit(pdev);
+	if (err)
+		return err;
+
 	return 0;
 }
 
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index b86e089..592a3f3 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -178,4 +178,18 @@ inline int ab8500_ext_regulator_exit(struct platform_device *pdev)
 }
 #endif
 
+#ifdef CONFIG_REGULATOR_AB8500_DEBUG
+int ab8500_regulator_debug_init(struct platform_device *pdev);
+int ab8500_regulator_debug_exit(struct platform_device *pdev);
+#else
+static inline int ab8500_regulator_debug_init(struct platform_device *pdev)
+{
+	return 0;
+}
+static inline int ab8500_regulator_debug_exit(struct platform_device *pdev)
+{
+	return 0;
+}
+#endif
+
 #endif
-- 
1.7.10.4

