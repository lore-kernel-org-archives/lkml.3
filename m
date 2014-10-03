Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbaJCXvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:51:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314AbaJCWD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Sharvil Nanavati <sharvil@google.com>,
        Richard Larocque <rlarocque@google.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3.16 292/357] alarmtimer: Do not signal SIGEV_NONE timers
Date: Fri,  3 Oct 2014 14:31:18 -0700
Message-Id: <20141003212942.254670549@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/alarmtimer.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -466,8 +466,10 @@ static enum alarmtimer_restart alarm_han
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


