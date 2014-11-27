Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaK0Iro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:47:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:41764 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbaK0Irm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:47:42 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Larocque <rlarocque@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Sharvil Nanavati <sharvil@google.com>,
        John Stultz <john.stultz@linaro.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 38/91] alarmtimer: Do not signal SIGEV_NONE timers
Date: Thu, 27 Nov 2014 16:42:21 +0800
Message-Id: <1417077794-9299-38-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Larocque <rlarocque@google.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 kernel/time/alarmtimer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index c72d3dd..c870118 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -456,8 +456,10 @@ static enum alarmtimer_restart alarm_handle_timer(struct alarm *alarm,
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

