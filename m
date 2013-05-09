Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab3EIRJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 13:09:50 -0400
Received: from nm16.access.bullet.mail.sp2.yahoo.com ([98.139.44.143]:46664
	"EHLO nm16.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076Ab3EIRJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 13:09:48 -0400
X-Yahoo-Newman-Id: 618246.62117.bm@smtp104.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 63cK6BwVM1ktUNFF8o528TRLiJsCQIYV0qxv3bAUhbPmKjQ
 abx1V_iCWzBg1bUQVN_nu2UMJ3_QgZuCDCLZdpKfiBPSIqjpiS4jUqE4L6Gf
 5P8XjFpMQC8.l1NTFHLIbGg9guljlKW8.Krz0lh0PRW_It_riVSJaIqwgFsP
 75ESHfjfh.83VAx3nq5r_isOrjqY64kjxCQSGVp2VNDu5zrypweZ.uruWLHj
 a8pnBb_pYr3zXf8xRitILvolsZDB8tvIVbik8L.ZT367YnlfYGbOlqdojXQu
 drl_9bTN6M5yI1Cra2H92MTzg4GbY49A0aAUn1mRF8o_fmglPelOZiTLe3cf
 SWGLaMBztVhWc4Xp32ticp96W3wjMKw0FbHSYawSNcaZrD4jlcHEj5StVFn1
 azIkTv50DP3.tam6Nln3TrQ7xVVUJKkdkn6z78ThEqV8amMu0uLaH2FcOtd8
 tFhcNmH1IvByP2ymqzFQNGhNzE00AjbaFDijyfnjNF7yKdZEwXSCOa0QQPSb
 VaYzT6kBIkv2a4agwLBDDWNRHs419bEmurQMCV_VwlqJsoq7z6ui1FJPoK8k
 sZlmA21Lk6TZ.cG8Xqw--
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp104.sbc.mail.gq1.yahoo.com with SMTP; 09 May 2013 10:09:47 -0700 PDT
From: Guenter Roeck <linux@roeck-us.net>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Jean Delvare <khali@linux-fr.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jingoo Han <jg1.han@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 2/3] hwmon: (tmp102) Convert to use __pm instead of #ifdef CONFIG_PM
Date: Thu,  9 May 2013 10:09:50 -0700
Message-Id: <1368119391-13837-3-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1368119391-13837-1-git-send-email-linux@roeck-us.net>
References: <1368119391-13837-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change, code only needed is power management is active still
compiles if it is disabled, but does not consume space in the object file.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/tmp102.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
index 523dd89..8e5d267 100644
--- a/drivers/hwmon/tmp102.c
+++ b/drivers/hwmon/tmp102.c
@@ -236,8 +236,7 @@ static int tmp102_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int tmp102_suspend(struct device *dev)
+static int __pm tmp102_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	int config;
@@ -250,7 +249,7 @@ static int tmp102_suspend(struct device *dev)
 	return i2c_smbus_write_word_swapped(client, TMP102_CONF_REG, config);
 }
 
-static int tmp102_resume(struct device *dev)
+static int __pm tmp102_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	int config;
@@ -263,16 +262,11 @@ static int tmp102_resume(struct device *dev)
 	return i2c_smbus_write_word_swapped(client, TMP102_CONF_REG, config);
 }
 
-static const struct dev_pm_ops tmp102_dev_pm_ops = {
+static const struct dev_pm_ops __pm tmp102_dev_pm_ops = {
 	.suspend	= tmp102_suspend,
 	.resume		= tmp102_resume,
 };
 
-#define TMP102_DEV_PM_OPS (&tmp102_dev_pm_ops)
-#else
-#define	TMP102_DEV_PM_OPS NULL
-#endif /* CONFIG_PM */
-
 static const struct i2c_device_id tmp102_id[] = {
 	{ "tmp102", 0 },
 	{ }
@@ -281,7 +275,7 @@ MODULE_DEVICE_TABLE(i2c, tmp102_id);
 
 static struct i2c_driver tmp102_driver = {
 	.driver.name	= DRIVER_NAME,
-	.driver.pm	= TMP102_DEV_PM_OPS,
+	.driver.pm	= pm_ops_ptr(&tmp102_dev_pm_ops),
 	.probe		= tmp102_probe,
 	.remove		= tmp102_remove,
 	.id_table	= tmp102_id,
-- 
1.7.9.7

