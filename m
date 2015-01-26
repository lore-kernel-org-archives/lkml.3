Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbbAZKPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:15:21 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:36188 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbbAZKPN (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 26 Jan 2015 05:15:13 -0500
Message-ID: <1422267302.24914.15.camel@stgolabs.net>
Subject: [PATCH] drivers/staging: use current->state helpers
From: Davidlohr Bueso <dave@stgolabs.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        driverdev-devel@linuxdriverproject.org
Date: Mon, 26 Jan 2015 02:15:02 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call __set_current_state() instead of assigning the new state directly.
These interfaces also aid CONFIG_DEBUG_ATOMIC_SLEEP environments,
keeping track of who changed the state.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 drivers/staging/comedi/drivers/me_daq.c   | 2 +-
 drivers/staging/dgnc/dgnc_utils.c         | 2 +-
 drivers/staging/panel/panel.c             | 2 +-
 drivers/staging/speakup/selection.c       | 2 +-
 drivers/staging/unisys/include/timskmod.h | 4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index bffc161..92e2352 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -174,7 +174,7 @@ struct me_private_data {
 
 static inline void sleep(unsigned sec)
 {
-	current->state = TASK_INTERRUPTIBLE;
+	__set_current_state(TASK_INTERRUPTIBLE);
 	schedule_timeout(sec * HZ);
 }
 
diff --git a/drivers/staging/dgnc/dgnc_utils.c b/drivers/staging/dgnc/dgnc_utils.c
index 61efc13..80b5133 100644
--- a/drivers/staging/dgnc/dgnc_utils.c
+++ b/drivers/staging/dgnc/dgnc_utils.c
@@ -12,7 +12,7 @@
  */
 int dgnc_ms_sleep(ulong ms)
 {
-	current->state = TASK_INTERRUPTIBLE;
+	__set_current_state(TASK_INTERRUPTIBLE);
 	schedule_timeout((ms * HZ) / 1000);
 	return signal_pending(current);
 }
diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 9c68ccf..6ed35b6 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -780,7 +780,7 @@ static void long_sleep(int ms)
 	if (in_interrupt()) {
 		mdelay(ms);
 	} else {
-		current->state = TASK_INTERRUPTIBLE;
+		__set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout((ms * HZ + 999) / 1000);
 	}
 }
diff --git a/drivers/staging/speakup/selection.c b/drivers/staging/speakup/selection.c
index 507fc9a..a031570 100644
--- a/drivers/staging/speakup/selection.c
+++ b/drivers/staging/speakup/selection.c
@@ -157,7 +157,7 @@ static void __speakup_paste_selection(struct work_struct *work)
 		pasted += count;
 	}
 	remove_wait_queue(&vc->paste_wait, &wait);
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 
 	tty_buffer_unlock_exclusive(&vc->port);
 	tty_ldisc_deref(ld);
diff --git a/drivers/staging/unisys/include/timskmod.h b/drivers/staging/unisys/include/timskmod.h
index cff7983..4019a0d 100644
--- a/drivers/staging/unisys/include/timskmod.h
+++ b/drivers/staging/unisys/include/timskmod.h
@@ -133,7 +133,7 @@
  *  x - the number of seconds to sleep.
  */
 #define SLEEP(x)					     \
-	do { current->state = TASK_INTERRUPTIBLE;	     \
+	do { __set_current_state(TASK_INTERRUPTIBLE);        \
 		schedule_timeout((x)*HZ);		     \
 	} while (0)
 
@@ -141,7 +141,7 @@
  *  x - the number of jiffies to sleep.
  */
 #define SLEEPJIFFIES(x)						    \
-	do { current->state = TASK_INTERRUPTIBLE;		    \
+	do { __set_current_state(TASK_INTERRUPTIBLE);		    \
 		schedule_timeout(x);				    \
 	} while (0)
 
-- 
2.1.2



