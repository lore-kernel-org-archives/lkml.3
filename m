Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbbAMPqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:46:43 -0500
Received: from m15-111.126.com ([220.181.15.111]:37354 "EHLO m15-111.126.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbbAMPqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:46:37 -0500
From: Xunlei Pang <xlpang@126.com>
To: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 3/9] rtc/test: Update driver to address y2038/y2106 issues
Date: Tue, 13 Jan 2015 23:44:51 +0800
Message-Id: <1421163897-8020-4-git-send-email-xlpang@126.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1421163897-8020-1-git-send-email-xlpang@126.com>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
X-CM-TRANSID: C8mowEAZEUVxPbVUBIRpDg--.692S6
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr45Cw1ruw45ur1kKFWfZrb_yoW8XFWfpa
	13Aas0kF4rta4fW3WkJF1kCFWYgws7Z3y8KF1xKwnY93WrJa4DtF1xGFyUtr1DJFZ5Ww13
	u3WYkFy5W3WUCaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07juwZcUUUUU=
X-Originating-IP: [182.149.91.53]
X-CM-SenderInfo: p0ost0bj6rjloofrz/1tbiJxCAv01sACyxzwAAs7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xunlei Pang <pang.xunlei@linaro.org>

This driver has a number of y2038/y2106 issues.

This patch resolves them by:
- Repalce get_seconds() with get_seconds64()
- Replace rtc_time_to_tm() with rtc_time64_to_tm()
- Change test_rtc_set_mmss() to use rtc_class_ops's set_mmss64()

After this patch, this driver should not have any remaining
y2038/y2106 issues.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/rtc-test.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
index 8f86fa9..056138b 100644
--- a/drivers/rtc/rtc-test.c
+++ b/drivers/rtc/rtc-test.c
@@ -30,13 +30,13 @@ static int test_rtc_set_alarm(struct device *dev,
 static int test_rtc_read_time(struct device *dev,
 	struct rtc_time *tm)
 {
-	rtc_time_to_tm(get_seconds(), tm);
+	rtc_time64_to_tm(get_seconds64(), tm);
 	return 0;
 }
 
-static int test_rtc_set_mmss(struct device *dev, unsigned long secs)
+static int test_rtc_set_mmss(struct device *dev, time64_t secs)
 {
-	dev_info(dev, "%s, secs = %lu\n", __func__, secs);
+	dev_info(dev, "%s, secs = %lld\n", __func__, (long long)secs);
 	return 0;
 }
 
@@ -60,7 +60,7 @@ static const struct rtc_class_ops test_rtc_ops = {
 	.read_time = test_rtc_read_time,
 	.read_alarm = test_rtc_read_alarm,
 	.set_alarm = test_rtc_set_alarm,
-	.set_mmss = test_rtc_set_mmss,
+	.set_mmss64 = test_rtc_set_mmss,
 	.alarm_irq_enable = test_rtc_alarm_irq_enable,
 };
 
-- 
1.9.1


