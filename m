Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab3LTIK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 03:10:57 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:61705 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab3LTIK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 03:10:56 -0500
From: rjying <rjying@gmail.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Barry Song <21cnbao@gmail.com>,
        RongJun Ying <Rongjun.Ying@csr.com>,
        Binghua Duan <Binghua.Duan@csr.com>,
        Rongjun Ying <rongjun.ying@csr.com>
Subject: [PATCH 1/1] extcon: gpio: Add power resume support
Date: Fri, 20 Dec 2013 16:09:47 +0800
Message-Id: <1387526987-12455-1-git-send-email-rongjun.ying@csr.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rongjun Ying <rongjun.ying@csr.com>

After system resume, need send extcon uevent to userspace

Change-Id: I32a9e1c6646035f95765bba79a7acaccb8ce45a7

Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
---
 drivers/extcon/extcon-gpio.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 7e0dff5..d916522 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -159,12 +159,29 @@ static int gpio_extcon_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int gpio_extcon_resume(struct device *dev)
+{
+	struct gpio_extcon_data *extcon_data;
+
+	extcon_data = dev_get_drvdata(dev);
+	queue_delayed_work(system_power_efficient_wq, &extcon_data->work,
+			      extcon_data->debounce_jiffies);
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops gpio_extcon_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(NULL, gpio_extcon_resume)
+};
+
 static struct platform_driver gpio_extcon_driver = {
 	.probe		= gpio_extcon_probe,
 	.remove		= gpio_extcon_remove,
 	.driver		= {
 		.name	= "extcon-gpio",
 		.owner	= THIS_MODULE,
+		.pm = &gpio_extcon_pm_ops,
 	},
 };
 
-- 
1.7.5.4

