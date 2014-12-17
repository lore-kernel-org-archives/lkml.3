Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaLQDRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 22:17:05 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:57993 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaLQDRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 22:17:04 -0500
X-Original-SENDERIP: 165.186.175.61
X-Original-MAILFROM: hyogi.gim@lge.com
Date: Wed, 17 Dec 2014 12:15:24 +0900
From: Hyogi Gim <hyogi.gim@lge.com>
To: a.zummo@towertech.it, akpm@linux-foundation.org
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/rtc/interface.c: check the error after
 __rtc_read_time()
Message-ID: <20141217031524.GA22361@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the verification code for returned __rtc_read_time() error in
rtc_update_irq_enable() and rtc_timer_do_work().

Signed-off-by: Hyogi Gim <hyogi.gim@lge.com>
---
 drivers/rtc/interface.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 45bfc28ee..fa1f119 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -489,7 +489,10 @@ int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 		struct rtc_time tm;
 		ktime_t now, onesec;
 
-		__rtc_read_time(rtc, &tm);
+		err = __rtc_read_time(rtc, &tm);
+		if (err < 0)
+			goto out;
+
 		onesec = ktime_set(1, 0);
 		now = rtc_tm_to_ktime(tm);
 		rtc->uie_rtctimer.node.expires = ktime_add(now, onesec);
@@ -867,13 +870,17 @@ void rtc_timer_do_work(struct work_struct *work)
 	struct timerqueue_node *next;
 	ktime_t now;
 	struct rtc_time tm;
+	int err = 0;
 
 	struct rtc_device *rtc =
 		container_of(work, struct rtc_device, irqwork);
 
 	mutex_lock(&rtc->ops_lock);
 again:
-	__rtc_read_time(rtc, &tm);
+	err = __rtc_read_time(rtc, &tm);
+	if (err < 0)
+		goto out;
+
 	now = rtc_tm_to_ktime(tm);
 	while ((next = timerqueue_getnext(&rtc->timerqueue))) {
 		if (next->expires.tv64 > now.tv64)
@@ -898,7 +905,6 @@ again:
 	/* Set next alarm */
 	if (next) {
 		struct rtc_wkalrm alarm;
-		int err;
 		int retry = 3;
 
 		alarm.time = rtc_ktime_to_tm(next->expires);
@@ -920,6 +926,7 @@ reprogram:
 	} else
 		rtc_alarm_disable(rtc);
 
+out:
 	pm_relax(rtc->dev.parent);
 	mutex_unlock(&rtc->ops_lock);
 }
-- 
1.8.3.2


-- 
Hyogi

