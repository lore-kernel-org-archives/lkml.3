Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbaFWJEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:04:21 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55470 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 022/111] hwmon: (ntc_thermistor) Fix dependencies
Date: Mon, 23 Jun 2014 10:30:57 +0200
Message-Id: <f8239ad5b39162075371d9d8b445277ba40ea44b.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 59cf4243e557aa64ab2ef51280454aa1f3828e14 upstream.

In commit 9e8269de, support was added for ntc_thermistor devices being
declared in the device tree and implemented on top of IIO. With that
change, a dependency was added to the ntc_thermistor driver:

	depends on (!OF && !IIO) || (OF && IIO)

This construct has the drawback that the driver can no longer be
selected when OF is set and IIO isn't, nor when IIO is set and OF is
not. This is a regression for the original users of the driver.

As the new code depends on IIO and is useless without OF, include it
only if both are enabled, and set the dependencies accordingly. This
is clearer, more simple and more correct.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Fixes: 9e8269de hwmon: (ntc_thermistor) Add DT with IIO support to NTC thermistor driver
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hwmon/Kconfig          | 2 +-
 drivers/hwmon/ntc_thermistor.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index b3ab9d43bb3e..dea5e11cf53a 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -969,7 +969,7 @@ config SENSORS_NCT6775
 
 config SENSORS_NTC_THERMISTOR
 	tristate "NTC thermistor support"
-	depends on (!OF && !IIO) || (OF && IIO)
+	depends on !OF || IIO=n || IIO
 	help
 	  This driver supports NTC thermistors sensor reading and its
 	  interpretation. The driver can also monitor the temperature and
diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
index 8a17f01e8672..6b4413ce4d39 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -141,7 +141,7 @@ struct ntc_data {
 	char name[PLATFORM_NAME_SIZE];
 };
 
-#ifdef CONFIG_OF
+#if defined(CONFIG_OF) && IS_ENABLED(CONFIG_IIO)
 static int ntc_adc_iio_read(struct ntc_thermistor_platform_data *pdata)
 {
 	struct iio_channel *channel = pdata->chan;
@@ -223,6 +223,8 @@ ntc_thermistor_parse_dt(struct platform_device *pdev)
 	return NULL;
 }
 
+#define ntc_match	NULL
+
 static void ntc_iio_channel_release(struct ntc_thermistor_platform_data *pdata)
 { }
 #endif
-- 
2.0.0

