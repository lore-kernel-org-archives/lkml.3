Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbaGOI1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:27:21 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58043 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaGOI1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:27:17 -0400
X-Original-SENDERIP: 165.186.175.61
X-Original-MAILFROM: hyogi.gim@lge.com
From: Hyogi Gim <hyogi.gim@lge.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Hyogi Gim <hyogi.gim@lge.com>
Subject: [PATCH] driver/rtc/class.c: check the error after rtc_read_time()
Date: Tue, 15 Jul 2014 17:25:23 +0900
Message-Id: <1405412723-10062-1-git-send-email-hyogi.gim@lge.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rtc_suspend() and rtc_resume(), the error after rtc_read_time() is not
checked. If rtc device fail to read time, we cannot guarantee the following
process.

Add the verification code for returned rtc_read_time() error.

Signed-off-by: Hyogi Gim <hyogi.gim@lge.com>
---
 drivers/rtc/class.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 589351e..38e26be 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -53,6 +53,7 @@ static int rtc_suspend(struct device *dev)
 	struct rtc_device	*rtc = to_rtc_device(dev);
 	struct rtc_time		tm;
 	struct timespec		delta, delta_delta;
+	int err;
 
 	if (has_persistent_clock())
 		return 0;
@@ -61,7 +62,12 @@ static int rtc_suspend(struct device *dev)
 		return 0;
 
 	/* snapshot the current RTC and system time at suspend*/
-	rtc_read_time(rtc, &tm);
+	err = rtc_read_time(rtc, &tm);
+	if (err < 0) {
+		pr_debug("%s:  fail to read rtc time\n", dev_name(&rtc->dev));
+		return 0;
+	}
+
 	getnstimeofday(&old_system);
 	rtc_tm_to_time(&tm, &old_rtc.tv_sec);
 
@@ -94,6 +100,7 @@ static int rtc_resume(struct device *dev)
 	struct rtc_time		tm;
 	struct timespec		new_system, new_rtc;
 	struct timespec		sleep_time;
+	int err;
 
 	if (has_persistent_clock())
 		return 0;
@@ -104,7 +111,12 @@ static int rtc_resume(struct device *dev)
 
 	/* snapshot the current rtc and system time at resume */
 	getnstimeofday(&new_system);
-	rtc_read_time(rtc, &tm);
+	err = rtc_read_time(rtc, &tm);
+	if (err < 0) {
+		pr_debug("%s:  fail to read rtc time\n", dev_name(&rtc->dev));
+		return 0;
+	}
+
 	if (rtc_valid_tm(&tm) != 0) {
 		pr_debug("%s:  bogus resume time\n", dev_name(&rtc->dev));
 		return 0;
-- 
1.8.3.2

