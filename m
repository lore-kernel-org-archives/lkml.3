Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843AbaLDRAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:00:11 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45590 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbaLDRAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:00:07 -0500
From: Nishanth Menon <nm@ti.com>
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>
CC: <linux-kernel@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH] hwmon: (gpio-fan) Add a shutdown handler to poweroff the fans
Date: Thu, 4 Dec 2014 10:58:56 -0600
Message-ID: <1417712336-31070-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Poweroff the fans when shutting down the system. Else,
echo '1' > /sys/class/hwmon/hwmon0/fan1_target; poweroff leaves the
fan running if the System power off does not drive the gpio expander
which might control the fan power supply.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
based on next-20141204 , but can rebase to required branch as needed.

 drivers/hwmon/gpio-fan.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index 7802eb2..36abf81 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -550,6 +550,14 @@ static int gpio_fan_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static void gpio_fan_shutdown(struct platform_device *pdev)
+{
+	struct gpio_fan_data *fan_data = dev_get_drvdata(&pdev->dev);
+
+	if (fan_data->ctrl)
+		set_fan_speed(fan_data, 0);
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int gpio_fan_suspend(struct device *dev)
 {
@@ -581,6 +589,7 @@ static SIMPLE_DEV_PM_OPS(gpio_fan_pm, gpio_fan_suspend, gpio_fan_resume);
 
 static struct platform_driver gpio_fan_driver = {
 	.probe		= gpio_fan_probe,
+	.shutdown	= gpio_fan_shutdown,
 	.driver	= {
 		.name	= "gpio-fan",
 		.pm	= GPIO_FAN_PM,
-- 
1.7.9.5

