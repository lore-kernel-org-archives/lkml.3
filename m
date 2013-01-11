Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3AKVtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:49:19 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44328 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab3AKVtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:49:17 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [RFC][PATCH 1/2] staging: alarm-dev: Refactor alarm-dev ioctl code in prep for compat_ioctl
Date: Fri, 11 Jan 2013 13:48:37 -0800
Message-Id: <1357940918-14941-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357940918-14941-1-git-send-email-john.stultz@linaro.org>
References: <1357940918-14941-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the Android alarm-dev driver's ioctl code to refactor it
in preparation for compat_ioctl support.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/alarm-dev.c |  242 +++++++++++++++++++++--------------
 1 file changed, 146 insertions(+), 96 deletions(-)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index a9b293f..12c570d 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -96,18 +96,116 @@ static void devalarm_cancel(struct devalarm *alrm)
 		hrtimer_cancel(&alrm->u.hrt);
 }
 
+static void alarm_clear(enum android_alarm_type alarm_type)
+{
+	uint32_t alarm_type_mask = 1U << alarm_type;
+	unsigned long flags;
 
-static long alarm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+	spin_lock_irqsave(&alarm_slock, flags);
+	alarm_dbg(IO, "alarm %d clear\n", alarm_type);
+	devalarm_try_to_cancel(&alarms[alarm_type]);
+	if (alarm_pending) {
+		alarm_pending &= ~alarm_type_mask;
+		if (!alarm_pending && !wait_pending)
+			__pm_relax(&alarm_wake_lock);
+	}
+	alarm_enabled &= ~alarm_type_mask;
+	spin_unlock_irqrestore(&alarm_slock, flags);
+
+}
+
+static void alarm_set(enum android_alarm_type alarm_type,
+							struct timespec *ts)
 {
-	int rv = 0;
+	uint32_t alarm_type_mask = 1U << alarm_type;
 	unsigned long flags;
-	struct timespec new_alarm_time;
-	struct timespec new_rtc_time;
-	struct timespec tmp_time;
+
+	spin_lock_irqsave(&alarm_slock, flags);
+	alarm_dbg(IO, "alarm %d set %ld.%09ld\n",
+			alarm_type, ts->tv_sec, ts->tv_nsec);
+	alarm_enabled |= alarm_type_mask;
+	devalarm_start(&alarms[alarm_type], timespec_to_ktime(*ts));
+	spin_unlock_irqrestore(&alarm_slock, flags);
+}
+
+static int alarm_wait(void)
+{
+	unsigned long flags;
+	int rv = 0;
+
+	spin_lock_irqsave(&alarm_slock, flags);
+	alarm_dbg(IO, "alarm wait\n");
+	if (!alarm_pending && wait_pending) {
+		__pm_relax(&alarm_wake_lock);
+		wait_pending = 0;
+	}
+	spin_unlock_irqrestore(&alarm_slock, flags);
+
+	rv = wait_event_interruptible(alarm_wait_queue, alarm_pending);
+	if (rv)
+		return rv;
+
+	spin_lock_irqsave(&alarm_slock, flags);
+	rv = alarm_pending;
+	wait_pending = 1;
+	alarm_pending = 0;
+	spin_unlock_irqrestore(&alarm_slock, flags);
+
+	return rv;
+}
+
+static int alarm_set_rtc(struct timespec *ts)
+{
 	struct rtc_time new_rtc_tm;
 	struct rtc_device *rtc_dev;
+	unsigned long flags;
+	int rv = 0;
+
+	rtc_time_to_tm(ts->tv_sec, &new_rtc_tm);
+	rtc_dev = alarmtimer_get_rtcdev();
+	rv = do_settimeofday(ts);
+	if (rv < 0)
+		return rv;
+	if (rtc_dev)
+		rv = rtc_set_time(rtc_dev, &new_rtc_tm);
+
+	spin_lock_irqsave(&alarm_slock, flags);
+	alarm_pending |= ANDROID_ALARM_TIME_CHANGE_MASK;
+	wake_up(&alarm_wait_queue);
+	spin_unlock_irqrestore(&alarm_slock, flags);
+
+	return rv;
+}
+
+static int alarm_get_time(enum android_alarm_type alarm_type,
+							struct timespec *ts)
+{
+	int rv = 0;
+
+	switch (alarm_type) {
+	case ANDROID_ALARM_RTC_WAKEUP:
+	case ANDROID_ALARM_RTC:
+		getnstimeofday(ts);
+		break;
+	case ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP:
+	case ANDROID_ALARM_ELAPSED_REALTIME:
+		get_monotonic_boottime(ts);
+		break;
+	case ANDROID_ALARM_SYSTEMTIME:
+		ktime_get_ts(ts);
+		break;
+	default:
+		rv = -EINVAL;
+	}
+	return rv;
+}
+
+static long alarm_do_ioctl(struct file *file, unsigned int cmd,
+							struct timespec *ts)
+{
+	int rv = 0;
+	unsigned long flags;
 	enum android_alarm_type alarm_type = ANDROID_ALARM_IOCTL_TO_TYPE(cmd);
-	uint32_t alarm_type_mask = 1U << alarm_type;
 
 	if (alarm_type >= ANDROID_ALARM_TYPE_COUNT)
 		return -EINVAL;
@@ -130,112 +228,64 @@ static long alarm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	switch (ANDROID_ALARM_BASE_CMD(cmd)) {
 	case ANDROID_ALARM_CLEAR(0):
-		spin_lock_irqsave(&alarm_slock, flags);
-		alarm_dbg(IO, "alarm %d clear\n", alarm_type);
-		devalarm_try_to_cancel(&alarms[alarm_type]);
-		if (alarm_pending) {
-			alarm_pending &= ~alarm_type_mask;
-			if (!alarm_pending && !wait_pending)
-				__pm_relax(&alarm_wake_lock);
-		}
-		alarm_enabled &= ~alarm_type_mask;
-		spin_unlock_irqrestore(&alarm_slock, flags);
+		alarm_clear(alarm_type);
 		break;
 
 	case ANDROID_ALARM_SET_OLD:
+	case ANDROID_ALARM_SET(0):
+		alarm_set(alarm_type, ts);
+		break;
 	case ANDROID_ALARM_SET_AND_WAIT_OLD:
-		if (get_user(new_alarm_time.tv_sec, (int __user *)arg)) {
-			rv = -EFAULT;
-			goto err1;
-		}
-		new_alarm_time.tv_nsec = 0;
-		goto from_old_alarm_set;
-
 	case ANDROID_ALARM_SET_AND_WAIT(0):
-	case ANDROID_ALARM_SET(0):
-		if (copy_from_user(&new_alarm_time, (void __user *)arg,
-		    sizeof(new_alarm_time))) {
-			rv = -EFAULT;
-			goto err1;
-		}
-from_old_alarm_set:
-		spin_lock_irqsave(&alarm_slock, flags);
-		alarm_dbg(IO, "alarm %d set %ld.%09ld\n",
-			  alarm_type,
-			  new_alarm_time.tv_sec, new_alarm_time.tv_nsec);
-		alarm_enabled |= alarm_type_mask;
-		devalarm_start(&alarms[alarm_type],
-			timespec_to_ktime(new_alarm_time));
-		spin_unlock_irqrestore(&alarm_slock, flags);
-		if (ANDROID_ALARM_BASE_CMD(cmd) != ANDROID_ALARM_SET_AND_WAIT(0)
-		    && cmd != ANDROID_ALARM_SET_AND_WAIT_OLD)
-			break;
+		alarm_set(alarm_type, ts);
 		/* fall though */
 	case ANDROID_ALARM_WAIT:
-		spin_lock_irqsave(&alarm_slock, flags);
-		alarm_dbg(IO, "alarm wait\n");
-		if (!alarm_pending && wait_pending) {
-			__pm_relax(&alarm_wake_lock);
-			wait_pending = 0;
-		}
-		spin_unlock_irqrestore(&alarm_slock, flags);
-		rv = wait_event_interruptible(alarm_wait_queue, alarm_pending);
-		if (rv)
-			goto err1;
-		spin_lock_irqsave(&alarm_slock, flags);
-		rv = alarm_pending;
-		wait_pending = 1;
-		alarm_pending = 0;
-		spin_unlock_irqrestore(&alarm_slock, flags);
+		rv = alarm_wait();
 		break;
 	case ANDROID_ALARM_SET_RTC:
-		if (copy_from_user(&new_rtc_time, (void __user *)arg,
-		    sizeof(new_rtc_time))) {
-			rv = -EFAULT;
-			goto err1;
-		}
-		rtc_time_to_tm(new_rtc_time.tv_sec, &new_rtc_tm);
-		rtc_dev = alarmtimer_get_rtcdev();
-		rv = do_settimeofday(&new_rtc_time);
-		if (rv < 0)
-			goto err1;
-		if (rtc_dev)
-			rv = rtc_set_time(rtc_dev, &new_rtc_tm);
-		spin_lock_irqsave(&alarm_slock, flags);
-		alarm_pending |= ANDROID_ALARM_TIME_CHANGE_MASK;
-		wake_up(&alarm_wait_queue);
-		spin_unlock_irqrestore(&alarm_slock, flags);
-		if (rv < 0)
-			goto err1;
+		rv = alarm_set_rtc(ts);
 		break;
 	case ANDROID_ALARM_GET_TIME(0):
-		switch (alarm_type) {
-		case ANDROID_ALARM_RTC_WAKEUP:
-		case ANDROID_ALARM_RTC:
-			getnstimeofday(&tmp_time);
-			break;
-		case ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP:
-		case ANDROID_ALARM_ELAPSED_REALTIME:
-			get_monotonic_boottime(&tmp_time);
-			break;
-		case ANDROID_ALARM_SYSTEMTIME:
-			ktime_get_ts(&tmp_time);
-			break;
-		default:
-			rv = -EINVAL;
-			goto err1;
-		}
-		if (copy_to_user((void __user *)arg, &tmp_time,
-		    sizeof(tmp_time))) {
-			rv = -EFAULT;
-			goto err1;
-		}
+		rv = alarm_get_time(alarm_type, ts);
 		break;
 
 	default:
 		rv = -EINVAL;
 	}
-err1:
+	return rv;
+}
+
+static long alarm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+
+	struct timespec ts;
+	int rv;
+
+	switch (ANDROID_ALARM_BASE_CMD(cmd)) {
+	case ANDROID_ALARM_SET_OLD:
+	case ANDROID_ALARM_SET_AND_WAIT_OLD:
+		if (get_user(ts.tv_sec, (int __user *)arg))
+			return -EFAULT;
+
+		ts.tv_nsec = 0;
+		break;
+	case ANDROID_ALARM_SET_AND_WAIT(0):
+	case ANDROID_ALARM_SET(0):
+	case ANDROID_ALARM_SET_RTC:
+		if (copy_from_user(&ts, (void __user *)arg, sizeof(ts)))
+			return -EFAULT;
+		break;
+	}
+
+	rv = alarm_do_ioctl(file, cmd, &ts);
+
+	switch (ANDROID_ALARM_BASE_CMD(cmd)) {
+	case ANDROID_ALARM_GET_TIME(0):
+		if (copy_to_user((void __user *)arg, &ts, sizeof(ts)))
+			return -EFAULT;
+		break;
+	}
+
 	return rv;
 }
 
-- 
1.7.10.4

