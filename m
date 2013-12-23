Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab3LWQ1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:27:13 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39601 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711Ab3LWQYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:24:09 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [RFC 09/18] power/reset: vexpress: Use regmap instead of custom interface
Date: Mon, 23 Dec 2013 16:23:41 +0000
Message-Id: <1387815830-8794-10-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
X-OriginalArrivalTime: 23 Dec 2013 16:24:04.0947 (UTC) FILETIME=[65C2EA30:01CEFFFB]
X-MC-Unique: 113122316240707901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBNGS2rH026650

This patch makes the Versatile Express reboot/reset driver
use regmap interface, instead of custom vexpress config
one. It will request the regmap resource associated
with the device, which makes it pretty much hardware
agnostic.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/reset/Kconfig             | 2 +-
 drivers/power/reset/vexpress-poweroff.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index 9b3ea53..98f64dc 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -40,7 +40,7 @@ config POWER_RESET_RESTART
 config POWER_RESET_VEXPRESS
 	bool "ARM Versatile Express power-off and reset driver"
 	depends on ARM || ARM64
-	depends on POWER_RESET && VEXPRESS_CONFIG
+	depends on POWER_RESET && REGMAP
 	help
 	  Power off and reset support for the ARM Ltd. Versatile
 	  Express boards.
diff --git a/drivers/power/reset/vexpress-poweroff.c b/drivers/power/reset/vexpress-poweroff.c
index d752233..a7fc882 100644
--- a/drivers/power/reset/vexpress-poweroff.c
+++ b/drivers/power/reset/vexpress-poweroff.c
@@ -15,6 +15,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 #include <linux/sched.h>
 #include <linux/stat.h>
 #include <linux/vexpress.h>
@@ -24,13 +25,12 @@
 static void vexpress_reset_do(struct device *dev, const char *what)
 {
 	int err = -ENOENT;
-	struct vexpress_config_func *func =
-			vexpress_config_func_get_by_dev(dev);
+	struct regmap *reg = dev_get_regmap(dev, NULL);
 
-	if (func) {
+	if (reg) {
 		unsigned long long timeout_ns;
 
-		err = vexpress_config_write(func, 0, 0);
+		err = regmap_write(reg, 0, 0);
 
 		timeout_ns = sched_clock() + 50000000;
 		while (!err && time_before64(sched_clock(), timeout_ns))
-- 
1.8.3.2


