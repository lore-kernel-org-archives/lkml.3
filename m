Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab3AKXql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 18:46:41 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:64681 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab3AKXqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 18:46:37 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@google.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [RFC][PATCH 1/3] staging: alarm-dev: Drop pre Android 1.0 _OLD ioctls
Date: Fri, 11 Jan 2013 15:46:22 -0800
Message-Id: <1357947984-15611-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357947984-15611-1-git-send-email-john.stultz@linaro.org>
References: <1357947984-15611-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per Colin's comment:
"The "support old userspace code" comment for those two ioctls has
been there since pre-Android 1.0.  Those apis are not exposed to
Android apps, I don't see any problem deleting them."

Thus this patch removes the ANDROID_ALARM_SET_OLD and
ANDROID_ALARM_SET_AND_WAIT_OLD ioctl compatability
logic.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Colin Cross <ccross@google.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/alarm-dev.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index a9b293f..d423850 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -42,10 +42,6 @@ do {									\
 	ANDROID_ALARM_RTC_WAKEUP_MASK | \
 	ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP_MASK)
 
-/* support old userspace code */
-#define ANDROID_ALARM_SET_OLD               _IOW('a', 2, time_t) /* set alarm */
-#define ANDROID_ALARM_SET_AND_WAIT_OLD      _IOW('a', 3, time_t)
-
 static int alarm_opened;
 static DEFINE_SPINLOCK(alarm_slock);
 static struct wakeup_source alarm_wake_lock;
@@ -142,15 +138,6 @@ static long alarm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		spin_unlock_irqrestore(&alarm_slock, flags);
 		break;
 
-	case ANDROID_ALARM_SET_OLD:
-	case ANDROID_ALARM_SET_AND_WAIT_OLD:
-		if (get_user(new_alarm_time.tv_sec, (int __user *)arg)) {
-			rv = -EFAULT;
-			goto err1;
-		}
-		new_alarm_time.tv_nsec = 0;
-		goto from_old_alarm_set;
-
 	case ANDROID_ALARM_SET_AND_WAIT(0):
 	case ANDROID_ALARM_SET(0):
 		if (copy_from_user(&new_alarm_time, (void __user *)arg,
@@ -158,7 +145,6 @@ static long alarm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			rv = -EFAULT;
 			goto err1;
 		}
-from_old_alarm_set:
 		spin_lock_irqsave(&alarm_slock, flags);
 		alarm_dbg(IO, "alarm %d set %ld.%09ld\n",
 			  alarm_type,
@@ -167,8 +153,8 @@ from_old_alarm_set:
 		devalarm_start(&alarms[alarm_type],
 			timespec_to_ktime(new_alarm_time));
 		spin_unlock_irqrestore(&alarm_slock, flags);
-		if (ANDROID_ALARM_BASE_CMD(cmd) != ANDROID_ALARM_SET_AND_WAIT(0)
-		    && cmd != ANDROID_ALARM_SET_AND_WAIT_OLD)
+		if (ANDROID_ALARM_BASE_CMD(cmd) !=
+						ANDROID_ALARM_SET_AND_WAIT(0))
 			break;
 		/* fall though */
 	case ANDROID_ALARM_WAIT:
-- 
1.7.10.4

