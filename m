Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaAGE4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 23:56:51 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55562 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaAGE4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 23:56:50 -0500
From: RongJun Ying <rjying@gmail.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Barry Song <Barry.Song@csr.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Workgroup.linux@csr.com, Rongjun Ying <rongjun.ying@csr.com>
Subject: [PATCH v3] extcon: gpio: Add power resume support
Date: Tue,  7 Jan 2014 12:56:30 +0800
Message-Id: <1389070590-3139-1-git-send-email-rongjun.ying@csr.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rongjun Ying <rongjun.ying@csr.com>

When system on the suspend state, Some SoC can't get gpio interrupt.
After system resume, need send extcon uevent to userspace.

Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
Reviewed-by: Barry Song <Baohua.Song@csr.com>
---
 -v3:
 'check_on_resume' instead of 'load_sleep_irq' as Chanwoo Choi's proposal.

 drivers/extcon/extcon-gpio.c       |   20 ++++++++++++++++++++
 include/linux/extcon/extcon-gpio.h |    1 +
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 7e0dff5..fde52c1 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -40,6 +40,7 @@ struct gpio_extcon_data {
 	int irq;
 	struct delayed_work work;
 	unsigned long debounce_jiffies;
+	bool check_on_resume;
 };

 static void gpio_extcon_work(struct work_struct *work)
@@ -103,6 +104,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 	extcon_data->gpio_active_low = pdata->gpio_active_low;
 	extcon_data->state_on = pdata->state_on;
 	extcon_data->state_off = pdata->state_off;
+	extcon_data->check_on_resume = pdata->check_on_resume;
 	if (pdata->state_on && pdata->state_off)
 		extcon_data->edev.print_state = extcon_gpio_print_state;
 	if (pdata->debounce) {
@@ -159,12 +161,30 @@ static int gpio_extcon_remove(struct platform_device *pdev)
 	return 0;
 }

+#ifdef CONFIG_PM_SLEEP
+static int gpio_extcon_resume(struct device *dev)
+{
+	struct gpio_extcon_data *extcon_data;
+
+	extcon_data = dev_get_drvdata(dev);
+	if (extcon_data->check_on_resume)
+		queue_delayed_work(system_power_efficient_wq,
+			&extcon_data->work, extcon_data->debounce_jiffies);
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

diff --git a/include/linux/extcon/extcon-gpio.h b/include/linux/extcon/extcon-gpio.h
index 4195810..c7f0c3e 100644
--- a/include/linux/extcon/extcon-gpio.h
+++ b/include/linux/extcon/extcon-gpio.h
@@ -51,6 +51,7 @@ struct gpio_extcon_platform_data {
 	/* if NULL, "0" or "1" will be printed */
 	const char *state_on;
 	const char *state_off;
+	bool check_on_resume;
 };

 #endif /* __EXTCON_GPIO_H__ */
--
1.7.5.4

