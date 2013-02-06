Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab3BFKzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:55:00 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:40021 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251Ab3BFKyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:54:54 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 14/49] regulator: ab8500: Init debug from regulator driver
Date: Wed,  6 Feb 2013 10:53:36 +0000
Message-Id: <1360148051-7560-15-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
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
index 48dd0ed..2b29ffa 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -962,6 +962,11 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
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
@@ -1012,6 +1017,11 @@ static int ab8500_regulator_remove(struct platform_device *pdev)
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
index 9a2da6a..094d24c 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -190,4 +190,18 @@ inline int ab8500_ext_regulator_exit(struct platform_device *pdev)
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
1.7.9.5

