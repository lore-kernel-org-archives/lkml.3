Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbaJCXKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:10:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852AbaJCWN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:13:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Sharvil Nanavati <sharvil@google.com>,
        Richard Larocque <rlarocque@google.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3.14 196/238] alarmtimer: Return relative times in timer_gettime
Date: Fri,  3 Oct 2014 14:31:51 -0700
Message-Id: <20141003212919.929767410@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/alarmtimer.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -541,18 +541,22 @@ static int alarm_timer_create(struct k_i
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
 
-	cur_setting->it_interval =
-			ktime_to_timespec(timr->it.alarm.interval);
-	cur_setting->it_value =
-		ktime_to_timespec(timr->it.alarm.alarmtimer.node.expires);
-	return;
+	if (ktime_to_ns(relative_expiry_time) > 0) {
+		cur_setting->it_value = ktime_to_timespec(relative_expiry_time);
+	} else {
+		cur_setting->it_value.tv_sec = 0;
+		cur_setting->it_value.tv_nsec = 0;
+	}
+
+	cur_setting->it_interval = ktime_to_timespec(timr->it.alarm.interval);
 }
 
 /**


