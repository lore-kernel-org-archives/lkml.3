Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189AbaGYJJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:09:06 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:61470 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760009AbaGYJJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:09:02 -0400
From: pramod.gurav.etc@gmail.com
X-Google-Original-From: pramod.gurav@smartplayin.com
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lejun Zhu <lejun.zhu@linux.intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH v2] Input: soc_button_array: Remove kfree on data allocated with devm_zalloc
Date: Fri, 25 Jul 2014 14:42:37 +0530
Message-Id: <1406279557-26754-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pramod Gurav <pramod.gurav@smartplayin.com>

This patch does below:
- Removes kfree done on data allocated with devm_zalloc in probe
  path of the driver.
- Adds a check on return value from devm_kzalloc which was missing
- Removes the error lables and instead releases resources and returns
  after failures

CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Lejun Zhu <lejun.zhu@linux.intel.com>
CC: Sachin Kamat <sachin.kamat@linaro.org>

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---

Changes since v1:
- Removes de_err logs on OOM cases which is not needed.

 drivers/input/misc/soc_button_array.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/input/misc/soc_button_array.c b/drivers/input/misc/soc_button_array.c
index 5a6334b..f421cf4 100644
--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -83,6 +83,11 @@ soc_button_device_create(struct pnp_dev *pdev,
 				       sizeof(*gpio_keys_pdata) +
 					sizeof(*gpio_keys) * MAX_NBUTTONS,
 				       GFP_KERNEL);
+	if (!gpio_keys_pdata) {
+		error = -ENOMEM;
+		return ERR_PTR(error);
+	}
+
 	gpio_keys = (void *)(gpio_keys_pdata + 1);
 
 	for (info = button_info; info->name; info++) {
@@ -104,7 +109,7 @@ soc_button_device_create(struct pnp_dev *pdev,
 
 	if (n_buttons == 0) {
 		error = -ENODEV;
-		goto err_free_mem;
+		return ERR_PTR(error);
 	}
 
 	gpio_keys_pdata->buttons = gpio_keys;
@@ -114,25 +119,23 @@ soc_button_device_create(struct pnp_dev *pdev,
 	pd = platform_device_alloc("gpio-keys", PLATFORM_DEVID_AUTO);
 	if (!pd) {
 		error = -ENOMEM;
-		goto err_free_mem;
+		return ERR_PTR(error);
 	}
 
 	error = platform_device_add_data(pd, gpio_keys_pdata,
 					 sizeof(*gpio_keys_pdata));
-	if (error)
-		goto err_free_pdev;
+	if (error) {
+		platform_device_put(pd);
+		return ERR_PTR(error);
+	}
 
 	error = platform_device_add(pd);
-	if (error)
-		goto err_free_pdev;
+	if (error) {
+		platform_device_put(pd);
+		return ERR_PTR(error);
+	}
 
 	return pd;
-
-err_free_pdev:
-	platform_device_put(pd);
-err_free_mem:
-	devm_kfree(&pdev->dev, gpio_keys_pdata);
-	return ERR_PTR(error);
 }
 
 static void soc_button_remove(struct pnp_dev *pdev)
-- 
1.7.9.5

