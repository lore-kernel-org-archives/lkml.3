Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaIJBbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 21:31:36 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:54027 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaIJBbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 21:31:34 -0400
From: Richard Larocque <rlarocque@google.com>
To: tglx@linutronix.de, john.stultz@linaro.org
Cc: linux-kernel@vger.kernel.org, Richard Larocque <rlarocque@google.com>
Subject: [PATCH 2/3] alarmtimer: Do not signal SIGEV_NONE timers
Date: Tue,  9 Sep 2014 18:31:04 -0700
Message-Id: <1410312665-25381-3-git-send-email-rlarocque@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410312665-25381-1-git-send-email-rlarocque@google.com>
References: <1410312665-25381-1-git-send-email-rlarocque@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoids sending a signal to alarm timers created with sigev_notify set to
SIGEV_NONE by checking for that special case in the timeout callback.

The regular posix timers avoid sending signals to SIGEV_NONE timers by
not scheduling any callbacks for them in the first place.  Although it
would be possible to do something similar for alarm timers, it's simpler
to handle this as a special case in the timeout.

Prior to this patch, the alarm timer would ignore the sigev_notify value
and try to deliver signals to the process anyway.  Even worse, the
sanity check for the value of sigev_signo is skipped when SIGEV_NONE was
specified, so the signal number could be bogus.  If sigev_signo was an
unitialized value (as it often would be if SIGEV_NONE is used), then
it's hard to predict which signal will be sent.

Signed-off-by: Richard Larocque <rlarocque@google.com>
---
 kernel/time/alarmtimer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index cb31fd0..091d660 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -466,8 +466,10 @@ static enum alarmtimer_restart alarm_handle_timer(struct alarm *alarm,
 {
 	struct k_itimer *ptr = container_of(alarm, struct k_itimer,
 						it.alarm.alarmtimer);
-	if (posix_timer_event(ptr, 0) != 0)
-		ptr->it_overrun++;
+	if ((ptr->it_sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_NONE) {
+		if (posix_timer_event(ptr, 0) != 0)
+			ptr->it_overrun++;
+	}
 
 	/* Re-add periodic timers */
 	if (ptr->it.alarm.interval.tv64) {
-- 
2.1.0.rc2.206.gedb03e5

