Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab3BAKRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:17:16 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:45433 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab3BAKRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:17:12 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, thierry.reding@avionic-design.de,
        sachin.kamat@linaro.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH v2 1/2] Input: tegra-kbc- Convert to devm_ioremap_resource()
Date: Fri,  1 Feb 2013 15:37:56 +0530
Message-Id: <1359713277-14228-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced devm_ioremap_resource() instead of
devm_request_and_ioremap() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages; so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
---
 Patch based & compile tested on linux-next tree (20130128).
 Changes since v1:
 * Dropped the error message as it is now handled by devm_ioremap_resource()
 itself.
---
 drivers/input/keyboard/tegra-kbc.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index 46e8ad2..fc43806 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/input/tegra_kbc.h>
 #include <linux/clk/tegra.h>
+#include <linux/err.h>
 
 #define KBC_MAX_DEBOUNCE_CNT	0x3ffu
 
@@ -615,11 +616,9 @@ static int tegra_kbc_probe(struct platform_device *pdev)
 	spin_lock_init(&kbc->lock);
 	setup_timer(&kbc->timer, tegra_kbc_keypress_timer, (unsigned long)kbc);
 
-	kbc->mmio = devm_request_and_ioremap(&pdev->dev, res);
-	if (!kbc->mmio) {
-		dev_err(&pdev->dev, "Cannot request memregion/iomap address\n");
-		return -EBUSY;
-	}
+	kbc->mmio = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(kbc->mmio))
+		return PTR_ERR(kbc->mmio);
 
 	kbc->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(kbc->clk)) {
-- 
1.7.4.1

