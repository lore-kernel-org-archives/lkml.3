Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbbATQWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:22:21 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:50496 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbbATQWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:22:19 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Richard Henderson <rth@twiddle.net>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [RFC PATCH v3 2/8] rtc/test: Update driver to address y2038/y2106 issues
Date: Tue, 20 Jan 2015 16:21:33 +0000
Message-Id: <1421770899-4136-3-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421770899-4136-1-git-send-email-pang.xunlei@linaro.org>
References: <1421770899-4136-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has a number of y2038/y2106 issues.

This patch resolves them by:
- Repalce get_seconds() with ktime_get_real_seconds()
- Replace rtc_time_to_tm() with rtc_time64_to_tm()

Also add test_rtc_set_mmss64() for testing rtc_class_ops's
set_mmss64(), which can be activated by "test_mmss64" module
parameter.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/rtc-test.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
index 8f86fa9..3a2da4c 100644
--- a/drivers/rtc/rtc-test.c
+++ b/drivers/rtc/rtc-test.c
@@ -13,6 +13,10 @@
 #include <linux/rtc.h>
 #include <linux/platform_device.h>
 
+static int test_mmss64;
+module_param(test_mmss64, int, 0644);
+MODULE_PARM_DESC(test_mmss64, "Test struct rtc_class_ops.set_mmss64().");
+
 static struct platform_device *test0 = NULL, *test1 = NULL;
 
 static int test_rtc_read_alarm(struct device *dev,
@@ -30,7 +34,13 @@ static int test_rtc_set_alarm(struct device *dev,
 static int test_rtc_read_time(struct device *dev,
 	struct rtc_time *tm)
 {
-	rtc_time_to_tm(get_seconds(), tm);
+	rtc_time64_to_tm(ktime_get_real_seconds(), tm);
+	return 0;
+}
+
+static int test_rtc_set_mmss64(struct device *dev, time64_t secs)
+{
+	dev_info(dev, "%s, secs = %lld\n", __func__, (long long)secs);
 	return 0;
 }
 
@@ -55,7 +65,7 @@ static int test_rtc_alarm_irq_enable(struct device *dev, unsigned int enable)
 	return 0;
 }
 
-static const struct rtc_class_ops test_rtc_ops = {
+static struct rtc_class_ops test_rtc_ops = {
 	.proc = test_rtc_proc,
 	.read_time = test_rtc_read_time,
 	.read_alarm = test_rtc_read_alarm,
@@ -101,6 +111,11 @@ static int test_probe(struct platform_device *plat_dev)
 	int err;
 	struct rtc_device *rtc;
 
+	if (test_mmss64) {
+		test_rtc_ops.set_mmss64 = test_rtc_set_mmss64;
+		test_rtc_ops.set_mmss = NULL;
+	}
+
 	rtc = devm_rtc_device_register(&plat_dev->dev, "test",
 				&test_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
-- 
1.9.1

