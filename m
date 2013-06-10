Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab3FJPJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:09:24 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49250 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab3FJPJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:09:23 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] mfd: vexpress: Make the driver optional for arm and arm64
Date: Mon, 10 Jun 2013 16:09:15 +0100
Message-Id: <1370876955-26050-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.1.2
X-OriginalArrivalTime: 10 Jun 2013 15:09:18.0206 (UTC) FILETIME=[7A7D91E0:01CE65EC]
X-MC-Unique: 113061016091909701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r5AF9V5J005264

The driver can be used on either arm or arm64 platforms, but
the latter doesn't have any platform-specific configuration
options, so it must be possible to manually enable the driver.

As the gpiolib is optional for arm64 arch, the gpio/led code
must be compiled conditionally.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/mfd/Kconfig           |  3 ++-
 drivers/mfd/vexpress-sysreg.c | 10 ++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

Hi Samuel,

Could you please queue this small change for 3.11?

Thanks!

Pawel

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index d54e985..6959b8d 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1144,7 +1144,8 @@ config MCP_UCB1200_TS
 endmenu
 
 config VEXPRESS_CONFIG
-	bool
+	bool "ARM Versatile Express platform infrastructure"
+	depends on ARM || ARM64
 	help
 	  Platform configuration infrastructure for the ARM Ltd.
 	  Versatile Express.
diff --git a/drivers/mfd/vexpress-sysreg.c b/drivers/mfd/vexpress-sysreg.c
index 96a020b..e2bbec5 100644
--- a/drivers/mfd/vexpress-sysreg.c
+++ b/drivers/mfd/vexpress-sysreg.c
@@ -351,6 +351,8 @@ void __init vexpress_sysreg_of_early_init(void)
 }
 
 
+#if defined(CONFIG_GPIOLIB)
+
 #define VEXPRESS_SYSREG_GPIO(_name, _reg, _value) \
 	[VEXPRESS_GPIO_##_name] = { \
 		.reg = _reg, \
@@ -445,6 +447,8 @@ struct gpio_led_platform_data vexpress_sysreg_leds_pdata = {
 	.leds = vexpress_sysreg_leds,
 };
 
+#endif
+
 
 static ssize_t vexpress_sysreg_sys_id_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
@@ -480,6 +484,9 @@ static int vexpress_sysreg_probe(struct platform_device *pdev)
 	setup_timer(&vexpress_sysreg_config_timer,
 			vexpress_sysreg_config_complete, 0);
 
+	vexpress_sysreg_dev = &pdev->dev;
+
+#if defined(CONFIG_GPIOLIB)
 	vexpress_sysreg_gpio_chip.dev = &pdev->dev;
 	err = gpiochip_add(&vexpress_sysreg_gpio_chip);
 	if (err) {
@@ -490,11 +497,10 @@ static int vexpress_sysreg_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	vexpress_sysreg_dev = &pdev->dev;
-
 	platform_device_register_data(vexpress_sysreg_dev, "leds-gpio",
 			PLATFORM_DEVID_AUTO, &vexpress_sysreg_leds_pdata,
 			sizeof(vexpress_sysreg_leds_pdata));
+#endif
 
 	device_create_file(vexpress_sysreg_dev, &dev_attr_sys_id);
 
-- 
1.8.1.2


