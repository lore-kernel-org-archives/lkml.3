Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbbAMPvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:51:32 -0500
Received: from m15-111.126.com ([220.181.15.111]:38550 "EHLO m15-111.126.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbbAMPv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:51:29 -0500
From: Xunlei Pang <xlpang@126.com>
To: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 1/9] rtc: Provide y2038 safe rtc_class_ops.set_mmss() replacement
Date: Tue, 13 Jan 2015 23:44:49 +0800
Message-Id: <1421163897-8020-2-git-send-email-xlpang@126.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1421163897-8020-1-git-send-email-xlpang@126.com>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
X-CM-TRANSID: C8mowEAZEUVxPbVUBIRpDg--.692S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxZryktr1rCFyDZw13ur1fXrb_yoW5WFy3pF
	47CFyjkrW7KrWfKa1kGw1kuF4rKry8Ja47KryrKa4S9r1FqF15KFn7Ar1UtF15GF97CF43
	XF4Fk345uw1DG3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jyxRDUUUUU=
X-Originating-IP: [182.149.91.53]
X-CM-SenderInfo: p0ost0bj6rjloofrz/1tbimRiAv00vL4USOQAAsd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xunlei Pang <pang.xunlei@linaro.org>

Currently the rtc_class_op's set_mmss() function takes a 32bit second
value (on 32bit systems), which is problematic for dates past y2038.

This patch provides a safe version named set_mmss64() using y2038 safe
time64_t.

After this patch, set_mmss() is deprecated and all its users will be
fixed to use set_mmss64(), it can be removed when having no users.

Cc: John Stultz <john.stultz@linaro.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/interface.c | 9 ++++++++-
 drivers/rtc/systohc.c   | 5 ++++-
 include/linux/rtc.h     | 1 +
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 45bfc28ee..fca7882 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -72,7 +72,12 @@ int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm)
 		err = -ENODEV;
 	else if (rtc->ops->set_time)
 		err = rtc->ops->set_time(rtc->dev.parent, tm);
-	else if (rtc->ops->set_mmss) {
+	else if (rtc->ops->set_mmss64) {
+		time64_t secs64;
+
+		secs64 = rtc_tm_to_time64(tm);
+		err = rtc->ops->set_mmss64(rtc->dev.parent, secs64);
+	} else if (rtc->ops->set_mmss) {
 		unsigned long secs;
 		err = rtc_tm_to_time(tm, &secs);
 		if (err == 0)
@@ -98,6 +103,8 @@ int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs)
 
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


