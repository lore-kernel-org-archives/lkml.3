Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab3AaKfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:35:01 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59173 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab3AaKe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:34:56 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@avionic-design.de, gregkh@linuxfoundation.org,
        sachin.kamat@linaro.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 2/3] Input: tegra-kbc- Convert to devm_ioremap_resource()
Date: Thu, 31 Jan 2013 15:55:38 +0530
Message-Id: <1359627939-2685-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359627939-2685-1-git-send-email-sachin.kamat@linaro.org>
References: <1359627939-2685-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced devm_ioremap_resource() instead of
devm_request_and_ioremap() which provides more consistent error handling.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
---
Compile tested with linux-next (20130128)
---
 drivers/input/keyboard/tegra-kbc.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index 46e8ad2..016d931 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/input/tegra_kbc.h>
 #include <linux/clk/tegra.h>
+#include <linux/err.h>
 
 #define KBC_MAX_DEBOUNCE_CNT	0x3ffu
 
@@ -615,10 +616,10 @@ static int tegra_kbc_probe(struct platform_device *pdev)
 	spin_lock_init(&kbc->lock);
 	setup_timer(&kbc->timer, tegra_kbc_keypress_timer, (unsigned long)kbc);
 
-	kbc->mmio = devm_request_and_ioremap(&pdev->dev, res);
-	if (!kbc->mmio) {
+	kbc->mmio = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(kbc->mmio)) {
 		dev_err(&pdev->dev, "Cannot request memregion/iomap address\n");
-		return -EBUSY;
+		return PTR_ERR(kbc->mmio);
 	}
 
 	kbc->clk = devm_clk_get(&pdev->dev, NULL);
-- 
1.7.4.1

