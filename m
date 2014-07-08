Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbaGHIut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:50:49 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:61954 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaGHIur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:50:47 -0400
X-Original-SENDERIP: 165.186.175.61
X-Original-MAILFROM: hyogi.gim@lge.com
From: Hyogi Gim <hyogi.gim@lge.com>
To: John Stultz <john.stultz@linaro.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Hyogi Gim <hyogi.gim@lge.com>
Subject: [PATCH] alarmtimers: verify the alarmtimer_type value from clock2alarm()
Date: Tue,  8 Jul 2014 17:49:27 +0900
Message-Id: <1404809367-30207-1-git-send-email-hyogi.gim@lge.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clock2alarm() can return a minus value. so, we cannot use this
returned value for a index of an array. but, some functions use
this value directly as a index of an array:
 - alarm_clock_getres()
 - alarm_clock_get()
 - alarm_timer_create()
 - alarm_timer_nsleep()

add the verification code for the returned alarmtimer_type from
clock2alarm().

Signed-off-by: Hyogi Gim <hyogi.gim@lge.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/alarmtimer.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 88c9c65..0b117c6 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -487,7 +487,14 @@ static enum alarmtimer_restart alarm_handle_timer(struct alarm *alarm,
  */
 static int alarm_clock_getres(const clockid_t which_clock, struct timespec *tp)
 {
-	clockid_t baseid = alarm_bases[clock2alarm(which_clock)].base_clockid;
+	enum alarmtimer_type type;
+	clockid_t baseid;
+
+	type = clock2alarm(which_clock);
+	if (type < 0)
+		return -EINVAL;
+
+	baseid = alarm_bases[type].base_clockid;
 
 	if (!alarmtimer_get_rtcdev())
 		return -EINVAL;
@@ -504,7 +511,14 @@ static int alarm_clock_getres(const clockid_t which_clock, struct timespec *tp)
  */
 static int alarm_clock_get(clockid_t which_clock, struct timespec *tp)
 {
-	struct alarm_base *base = &alarm_bases[clock2alarm(which_clock)];
+	enum alarmtimer_type type;
+	struct alarm_base *base;
+
+	type = clock2alarm(which_clock);
+	if (type < 0)
+		return -EINVAL;
+
+	base = &alarm_bases[type];
 
 	if (!alarmtimer_get_rtcdev())
 		return -EINVAL;
@@ -531,6 +545,9 @@ static int alarm_timer_create(struct k_itimer *new_timer)
 		return -EPERM;
 
 	type = clock2alarm(new_timer->it_clock);
+	if (type < 0)
+		return -EINVAL;
+
 	base = &alarm_bases[type];
 	alarm_init(&new_timer->it.alarm.alarmtimer, type, alarm_handle_timer);
 	return 0;
@@ -721,7 +738,7 @@ out:
 static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
 		     struct timespec *tsreq, struct timespec __user *rmtp)
 {
-	enum  alarmtimer_type type = clock2alarm(which_clock);
+	enum alarmtimer_type type;
 	struct alarm alarm;
 	ktime_t exp;
 	int ret = 0;
@@ -733,6 +750,10 @@ static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
 	if (!capable(CAP_WAKE_ALARM))
 		return -EPERM;
 
+	type = clock2alarm(which_clock);
+	if (type < 0)
+		return -EINVAL;
+
 	alarm_init(&alarm, type, alarmtimer_nsleep_wakeup);
 
 	exp = timespec_to_ktime(*tsreq);
-- 
1.8.3.2

