Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3EKAyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:54:09 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:57388 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab3EKAyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:54:07 -0400
From: Bernie Thompson <bhthompson@chromium.org>
To: rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dianders@chromium.org, Bernie Thompson <bhthompson@chromium.org>
Subject: [PATCH] rtc: add in ability to push out an existing wakealarm using sysfs
Date: Fri, 10 May 2013 17:53:31 -0700
Message-Id: <1368233611-1690-1-git-send-email-bhthompson@chromium.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds in the ability for the rtc sysfs code to handle += characters
at the beginning of a wakealarm setting string. This will allow the user to
attempt to push out an existing wakealarm by a provided amount.

In the case that the += characters are provided but the alarm is not active
-EVINVAL is returned.

Signed-off-by: Bernie Thompson <bhthompson@chromium.org>
---
 Documentation/rtc.txt   |  7 ++++---
 drivers/rtc/rtc-sysfs.c | 20 +++++++++++++++-----
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/Documentation/rtc.txt b/Documentation/rtc.txt
index 32aa400..596b60c 100644
--- a/Documentation/rtc.txt
+++ b/Documentation/rtc.txt
@@ -153,9 +153,10 @@ since_epoch:	 The number of seconds since the epoch according to the RTC
 time:		 RTC-provided time
 wakealarm:	 The time at which the clock will generate a system wakeup
 		 event. This is a one shot wakeup event, so must be reset
-		 after wake if a daily wakeup is required. Format is either
-		 seconds since the epoch or, if there's a leading +, seconds
-		 in the future.
+		 after wake if a daily wakeup is required. Format is seconds since
+		 the epoch by default, or if there's a leading +, seconds in the
+		 future, or if there is a leading +=, seconds ahead of the current
+		 alarm.
 
 IOCTL INTERFACE
 ---------------
diff --git a/drivers/rtc/rtc-sysfs.c b/drivers/rtc/rtc-sysfs.c
index b70e2bb..4b26f86 100644
--- a/drivers/rtc/rtc-sysfs.c
+++ b/drivers/rtc/rtc-sysfs.c
@@ -164,6 +164,7 @@ rtc_sysfs_set_wakealarm(struct device *dev, struct device_attribute *attr,
 {
 	ssize_t retval;
 	unsigned long now, alarm;
+	unsigned long push = 0;
 	struct rtc_wkalrm alm;
 	struct rtc_device *rtc = to_rtc_device(dev);
 	char *buf_ptr;
@@ -180,13 +181,17 @@ rtc_sysfs_set_wakealarm(struct device *dev, struct device_attribute *attr,
 	buf_ptr = (char *)buf;
 	if (*buf_ptr == '+') {
 		buf_ptr++;
-		adjust = 1;
+		if (*buf_ptr == '=') {
+			buf_ptr++;
+			push = 1;
+		} else
+			adjust = 1;
 	}
 	alarm = simple_strtoul(buf_ptr, NULL, 0);
 	if (adjust) {
 		alarm += now;
 	}
-	if (alarm > now) {
+	if (alarm > now || push) {
 		/* Avoid accidentally clobbering active alarms; we can't
 		 * entirely prevent that here, without even the minimal
 		 * locking from the /dev/rtcN api.
@@ -194,9 +199,14 @@ rtc_sysfs_set_wakealarm(struct device *dev, struct device_attribute *attr,
 		retval = rtc_read_alarm(rtc, &alm);
 		if (retval < 0)
 			return retval;
-		if (alm.enabled)
-			return -EBUSY;
-
+		if (alm.enabled) {
+			if (push) {
+				rtc_tm_to_time(&alm.time, &push);
+				alarm += push;
+			} else
+				return -EBUSY;
+		} else if (push)
+			return -EINVAL;
 		alm.enabled = 1;
 	} else {
 		alm.enabled = 0;
-- 
1.8.2.1

