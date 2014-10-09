Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582AbaJIVXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:23:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59496 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721AbaJIVKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:10:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Sharvil Nanavati <sharvil@google.com>,
        Richard Larocque <rlarocque@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 064/163] alarmtimer: Do not signal SIGEV_NONE timers
Date: Thu,  9 Oct 2014 14:01:29 -0700
Message-Id: <1412888588-26755-65-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Larocque <rlarocque@google.com>

commit 265b81d23a46c39df0a735a3af4238954b41a4c2 upstream.

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

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Sharvil Nanavati <sharvil@google.com>
Signed-off-by: Richard Larocque <rlarocque@google.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/time/alarmtimer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 6745174..f7bdb14 100644
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

