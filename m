Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbaGYLbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:31:04 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:64464 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760091AbaGYLbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:31:01 -0400
From: pramod.gurav.etc@gmail.com
X-Google-Original-From: pramod.gurav@smartplayin.com
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lejun Zhu <lejun.zhu@linux.intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH v2] Input: soc_button_array: Remove kfree on data allocated with devm_zalloc
Date: Fri, 25 Jul 2014 17:04:34 +0530
Message-Id: <1406288074-28725-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pramod Gurav <pramod.gurav@smartplayin.com>

This patch does below:
- Removes kfree done on data allocated with devm_zalloc in probe
  path of the driver.
- Adds a check on return value from devm_kzalloc which was missing

CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Lejun Zhu <lejun.zhu@linux.intel.com>
CC: Sachin Kamat <sachin.kamat@linaro.org>

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/input/misc/soc_button_array.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/input/misc/soc_button_array.c b/drivers/input/misc/soc_button_array.c
index 5a6334b..fc64ec6 100644
--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -83,6 +83,9 @@ soc_button_device_create(struct pnp_dev *pdev,
 				       sizeof(*gpio_keys_pdata) +
 					sizeof(*gpio_keys) * MAX_NBUTTONS,
 				       GFP_KERNEL);
+	if (!gpio_keys_pdata)
+		return ERR_PTR(-ENOMEM);
+
 	gpio_keys = (void *)(gpio_keys_pdata + 1);
 
 	for (info = button_info; info->name; info++) {
@@ -102,20 +105,16 @@ soc_button_device_create(struct pnp_dev *pdev,
 		n_buttons++;
 	}
 
-	if (n_buttons == 0) {
-		error = -ENODEV;
-		goto err_free_mem;
-	}
+	if (n_buttons == 0)
+		return ERR_PTR(-ENODEV);
 
 	gpio_keys_pdata->buttons = gpio_keys;
 	gpio_keys_pdata->nbuttons = n_buttons;
 	gpio_keys_pdata->rep = autorepeat;
 
 	pd = platform_device_alloc("gpio-keys", PLATFORM_DEVID_AUTO);
-	if (!pd) {
-		error = -ENOMEM;
-		goto err_free_mem;
-	}
+	if (!pd)
+		return ERR_PTR(-ENOMEM);
 
 	error = platform_device_add_data(pd, gpio_keys_pdata,
 					 sizeof(*gpio_keys_pdata));
@@ -130,8 +129,6 @@ soc_button_device_create(struct pnp_dev *pdev,
 
 err_free_pdev:
 	platform_device_put(pd);
-err_free_mem:
-	devm_kfree(&pdev->dev, gpio_keys_pdata);
 	return ERR_PTR(error);
 }
 
-- 
1.7.9.5

