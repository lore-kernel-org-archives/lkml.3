Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaGKOJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:09:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59423 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbaGKOFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:05:08 -0400
X-AuditID: cbfee61a-f79e46d00000134f-95-53bfef12ab88
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v4 10/21] Documentation: leds: add exemplary asynchronous
 mux driver
Date: Fri, 11 Jul 2014 16:04:13 +0200
Message-id: <1405087464-13762-11-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQV2h9/uDDTbs5bPYOGM9q8XRnROZ
	LOYfOcdq0Xv1OaPF2aY37BaXd81hs9j6Zh2jRc+GrawWu3c9ZXXg9Ng56y67x575P1g9+ras
	YvT4vEkugCWKyyYlNSezLLVI3y6BK6N1y1XmgifCFT9PH2ZrYHwh0MXIySEhYCKx8vwcFghb
	TOLCvfVsXYxcHEIC0xklvvWvZ4dw2pkkHu28xQxSxSZgKPHzxWsmEFtEoFyi5/0zsA5mgdWM
	Ene2fmUFSQgLREnM6wLp5uRgEVCVaNxyHaiZg4NXwFPi5hYpEFNCQEFiziQbkApOoOjB/pts
	ILaQgIfEw7Un2Ccw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERxez6R2MK5ssDjE
	KMDBqMTDq7B+X7AQa2JZcWXuIUYJDmYlEd6rb/YHC/GmJFZWpRblxxeV5qQWH2KU5mBREuc9
	0GodKCSQnliSmp2aWpBaBJNl4uCUamAs0wjk1TCZdKBVltfhTeCRFWv+Fq448b9gq2Ge6+7j
	uSemsmhqXNb4asPeEeKzJXeuqTZrz43apOjFBybscO/W8b1y6EuJ6LoGNY17EmVHeTd+vnFy
	nseUvk//lb/253RM2ZT/UcVhwb8KPe1qi/JEFqdnM7QX3nvnWnmdZeKp8CcSLX0qwexKLMUZ
	iYZazEXFiQDoSdZzKwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exemplary driver showing usage of the Flash Manager API
for registering/unregistering asynchronous multiplexers

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 Documentation/leds/leds-async-mux.c |   65 +++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)
 create mode 100644 Documentation/leds/leds-async-mux.c

diff --git a/Documentation/leds/leds-async-mux.c b/Documentation/leds/leds-async-mux.c
new file mode 100644
index 0000000..ee35d2f
--- /dev/null
+++ b/Documentation/leds/leds-async-mux.c
@@ -0,0 +1,65 @@
+/*
+ * Exemplary driver showing usage of the Flash Manager API
+ * for registering/unregistering asynchronous multiplexers.
+ *
+ *	Copyright (C) 2014, Samsung Electronics Co., Ltd.
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/led-class-flash.h>
+#include <linux/led-flash-manager.h>
+#include <linux/leds.h>
+#include <linux/of.h>
+
+static int led_async_mux_select_line(u32 line_id, void *mux)
+{
+	pr_info("led_async_mux_select_line line_id: %d\n", line_id);
+	return 0;
+}
+
+struct led_flash_mux_ops mux_ops = {
+	.select_line = led_async_mux_select_line,
+};
+
+static int led_async_mux_probe(struct platform_device *pdev)
+{
+	struct led_flash_mux mux;
+
+	mux.ops = &mux_ops;
+	mux.owner = THIS_MODULE;
+	mux.node = pdev->dev->of_node;
+
+	return led_flash_manager_bind_async_mux(&mux);
+}
+
+static int led_async_mux_remove(struct platform_device *pdev)
+{
+	return led_flash_manager_unbind_async_mux(pdev->dev->of_node);
+}
+
+static struct of_device_id led_async_mux_dt_match[] = {
+	{.compatible = "led-async-mux"},
+	{},
+};
+
+static struct platform_driver led_async_mux_driver = {
+	.probe		= led_async_mux_probe,
+	.remove		= led_async_mux_remove,
+	.driver		= {
+		.name		= "led-async-mux",
+		.owner		= THIS_MODULE,
+		.of_match_table = led_async_mux_dt_match,
+	},
+};
+
+module_platform_driver(led_async_mux_driver);
+
+MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
+MODULE_DESCRIPTION("LED async mux");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

