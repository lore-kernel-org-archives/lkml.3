Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaILVXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:23:11 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36639 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaILVWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:22:40 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Richard Larocque <rlarocque@google.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Sharvil Nanavati <sharvil@google.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3/4] alarmtimer: Do not signal SIGEV_NONE timers
Date: Fri, 12 Sep 2014 14:22:23 -0700
Message-Id: <1410556944-14944-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410556944-14944-1-git-send-email-john.stultz@linaro.org>
References: <1410556944-14944-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Larocque <rlarocque@google.com>

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

Cc: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Sharvil Nanavati <sharvil@google.com>
Signed-off-by: Richard Larocque <rlarocque@google.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/alarmtimer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index b4bce62..41a9253 100644
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
1.9.1

