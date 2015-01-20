Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbbATQYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:24:09 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:39394 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbbATQWT (ORCPT
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
Subject: [RFC PATCH v3 1/8] rtc: Provide y2038 safe rtc_class_ops.set_mmss() replacement
Date: Tue, 20 Jan 2015 16:21:32 +0000
Message-Id: <1421770899-4136-2-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421770899-4136-1-git-send-email-pang.xunlei@linaro.org>
References: <1421770899-4136-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the rtc_class_op's set_mmss() function takes a 32bit second
value (on 32bit systems), which is problematic for dates past y2038.

This patch provides a safe version named set_mmss64() using y2038 safe
time64_t.

After this patch, set_mmss() is deprecated and all its users will be
fixed to use set_mmss64(), it can be removed when having no users.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/interface.c | 7 ++++++-
 drivers/rtc/systohc.c   | 5 ++++-
 include/linux/rtc.h     | 1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 45bfc28ee..db44df8 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -72,7 +72,10 @@ int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm)
 		err = -ENODEV;
 	else if (rtc->ops->set_time)
 		err = rtc->ops->set_time(rtc->dev.parent, tm);
-	else if (rtc->ops->set_mmss) {
+	else if (rtc->ops->set_mmss64) {
+		time64_t secs64 = rtc_tm_to_time64(tm);
+		err = rtc->ops->set_mmss64(rtc->dev.parent, secs64);
+	} else if (rtc->ops->set_mmss) {
 		unsigned long secs;
 		err = rtc_tm_to_time(tm, &secs);
 		if (err == 0)
@@ -98,6 +101,8 @@ int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs)
 
 	if (!rtc->ops)
 		err = -ENODEV;
+	else if (rtc->ops->set_mmss64)
+		err = rtc->ops->set_mmss64(rtc->dev.parent, secs);
 	else if (rtc->ops->set_mmss)
 		err = rtc->ops->set_mmss(rtc->dev.parent, secs);
 	else if (rtc->ops->read_time && rtc->ops->set_time) {
diff --git a/drivers/rtc/systohc.c b/drivers/rtc/systohc.c
index bf3e242..e34a07b 100644
--- a/drivers/rtc/systohc.c
+++ b/drivers/rtc/systohc.c
@@ -35,7 +35,10 @@ int rtc_set_ntp_time(struct timespec now)
 	if (rtc) {
 		/* rtc_hctosys exclusively uses UTC, so we call set_time here,
 		 * not set_mmss. */
-		if (rtc->ops && (rtc->ops->set_time || rtc->ops->set_mmss))
+		if (rtc->ops &&
+		    (rtc->ops->set_time ||
+		     rtc->ops->set_mmss64 ||
+		     rtc->ops->set_mmss))
 			err = rtc_set_time(rtc, &tm);
 		rtc_class_close(rtc);
 	}
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 6d6be09..29093da 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -77,6 +77,7 @@ struct rtc_class_ops {
 	int (*read_alarm)(struct device *, struct rtc_wkalrm *);
 	int (*set_alarm)(struct device *, struct rtc_wkalrm *);
 	int (*proc)(struct device *, struct seq_file *);
+	int (*set_mmss64)(struct device *, time64_t secs);
 	int (*set_mmss)(struct device *, unsigned long secs);
 	int (*read_callback)(struct device *, int data);
 	int (*alarm_irq_enable)(struct device *, unsigned int enabled);
-- 
1.9.1

