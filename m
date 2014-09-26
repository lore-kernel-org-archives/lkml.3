Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbaIZQu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 12:50:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34958 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955AbaIZQu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:50:27 -0400
From: Colin King <colin.king@canonical.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/rtc/interface.c: ignore expired times when enqueing new timers
Date: Fri, 26 Sep 2014 17:50:23 +0100
Message-Id: <1411750223-18954-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The current enqueuing does not trigger an alarm if there are any
expired timers on the timerqueue. This can occur when a RTC wake alarm
is used to wake a machine out of hibernate and the resumed state has
old expired timers that have not been removed from the timer queue.

This fix skips over any expired timers and will trigger an
alarm if there are no other pending timers on the timerqueue.

The bug was found running the example RTC timer program from
Documentation/rtc.txt; it runs fine before a hibernate but will block
forever on RTC reads after a resume from a hibernate that is woken
up using a RTC wakealarm.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/rtc/interface.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 5b2717f..ca9d9fc 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -780,9 +780,23 @@ EXPORT_SYMBOL_GPL(rtc_irq_set_freq);
  */
 static int rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
 {
+	struct timerqueue_node *next = timerqueue_getnext(&rtc->timerqueue);
+	struct rtc_time tm;
+	ktime_t now;
+
 	timer->enabled = 1;
+	__rtc_read_time(rtc, &tm);
+	now = rtc_tm_to_ktime(tm);
+
+	/* Skip over expired timers */
+	while (next) {
+		if (next->expires.tv64 >= now.tv64)
+			break;
+		next = timerqueue_iterate_next(next);
+	}
+
 	timerqueue_add(&rtc->timerqueue, &timer->node);
-	if (&timer->node == timerqueue_getnext(&rtc->timerqueue)) {
+	if (!next) {
 		struct rtc_wkalrm alarm;
 		int err;
 		alarm.time = rtc_ktime_to_tm(timer->node.expires);
-- 
2.1.0

