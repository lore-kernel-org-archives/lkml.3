Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaKAWsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:48:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60210 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702AbaKAWja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:30 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Prarit Bhargava" <prarit@redhat.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Sharvil Nanavati" <sharvil@google.com>,
        "John Stultz" <john.stultz@linaro.org>,
        "Richard Cochran" <richardcochran@gmail.com>,
        "Richard Larocque" <rlarocque@google.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.242143890@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 047/102] alarmtimer: Return relative times in
 timer_gettime
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Larocque <rlarocque@google.com>

commit e86fea764991e00a03ff1e56409ec9cacdbda4c9 upstream.

Returns the time remaining for an alarm timer, rather than the time at
which it is scheduled to expire.  If the timer has already expired or it
is not currently scheduled, the it_value's members are set to zero.

This new behavior matches that of the other posix-timers and the POSIX
specifications.

This is a change in user-visible behavior, and may break existing
applications.  Hopefully, few users rely on the old incorrect behavior.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Sharvil Nanavati <sharvil@google.com>
Signed-off-by: Richard Larocque <rlarocque@google.com>
[jstultz: minor style tweak]
Signed-off-by: John Stultz <john.stultz@linaro.org>
[bwh: Backported to 3.2: Add definition of alarm_expires_remaining() from
 commit 6cffe00f7d4e ('alarmtimer: Add functions for timerfd support')]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/time/alarmtimer.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -226,6 +226,12 @@ static enum hrtimer_restart alarmtimer_f
 
 }
 
+ktime_t alarm_expires_remaining(const struct alarm *alarm)
+{
+	struct alarm_base *base = &alarm_bases[alarm->type];
+	return ktime_sub(alarm->node.expires, base->gettime());
+}
+
 #ifdef CONFIG_RTC_CLASS
 /**
  * alarmtimer_suspend - Suspend time callback
@@ -519,18 +525,22 @@ static int alarm_timer_create(struct k_i
  * @new_timer: k_itimer pointer
  * @cur_setting: itimerspec data to fill
  *
- * Copies the itimerspec data out from the k_itimer
+ * Copies out the current itimerspec data
  */
 static void alarm_timer_get(struct k_itimer *timr,
 				struct itimerspec *cur_setting)
 {
-	memset(cur_setting, 0, sizeof(struct itimerspec));
+	ktime_t relative_expiry_time =
+		alarm_expires_remaining(&(timr->it.alarm.alarmtimer));
+
+	if (ktime_to_ns(relative_expiry_time) > 0) {
+		cur_setting->it_value = ktime_to_timespec(relative_expiry_time);
+	} else {
+		cur_setting->it_value.tv_sec = 0;
+		cur_setting->it_value.tv_nsec = 0;
+	}
 
-	cur_setting->it_interval =
-			ktime_to_timespec(timr->it.alarm.interval);
-	cur_setting->it_value =
-		ktime_to_timespec(timr->it.alarm.alarmtimer.node.expires);
-	return;
+	cur_setting->it_interval = ktime_to_timespec(timr->it.alarm.interval);
 }
 
 /**
--- a/include/linux/alarmtimer.h
+++ b/include/linux/alarmtimer.h
@@ -48,6 +48,7 @@ int alarm_try_to_cancel(struct alarm *al
 int alarm_cancel(struct alarm *alarm);
 
 u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval);
+ktime_t alarm_expires_remaining(const struct alarm *alarm);
 
 /*
  * A alarmtimer is active, when it is enqueued into timerqueue or the

