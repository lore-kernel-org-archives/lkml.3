Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934840AbaFIW7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:59:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934016AbaFIWp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Doug Anderson <dianders@chromium.org>
Subject: [PATCH 3.10 09/40] hwmon: (ntc_thermistor) Fix dependencies
Date: Mon,  9 Jun 2014 15:48:40 -0700
Message-Id: <20140609224839.512565285@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224839.127615063@linuxfoundation.org>
References: <20140609224839.127615063@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <jdelvare@suse.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/Kconfig          |    2 +-
 drivers/hwmon/ntc_thermistor.c |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -944,7 +944,7 @@ config SENSORS_NCT6775
 
 config SENSORS_NTC_THERMISTOR
 	tristate "NTC thermistor support"
-	depends on (!OF && !IIO) || (OF && IIO)
+	depends on !OF || IIO=n || IIO
 	help
 	  This driver supports NTC thermistors sensor reading and its
 	  interpretation. The driver can also monitor the temperature and
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
@@ -223,6 +223,8 @@ ntc_thermistor_parse_dt(struct platform_
 	return NULL;
 }
 
+#define ntc_match	NULL
+
 static void ntc_iio_channel_release(struct ntc_thermistor_platform_data *pdata)
 { }
 #endif


