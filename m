Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab3BDMLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:11:34 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56944 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab3BDL4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:31 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 23/73] regulator: ab8500: Init debug from regulator driver
Date: Mon,  4 Feb 2013 11:53:38 +0000
Message-Id: <1359978868-28736-24-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to guarantee that ab8500-debug will
record the regulator registers before they are modified by the
ab8500 regulator driver.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/regulator/ab8500.c       |   10 ++++++++++
 include/linux/regulator/ab8500.h |   14 ++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 0e3dd64..406c561 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -998,6 +998,11 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
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
@@ -1048,6 +1053,11 @@ static int ab8500_regulator_remove(struct platform_device *pdev)
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

