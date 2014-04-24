Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbaDXI4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:56:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47180 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbaDXI4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:56:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Corey Minyard <cminyard@mvista.com>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, minyard@acm.org,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 179/182] ipmi: Fix a race restarting the timer
Date: Thu, 24 Apr 2014 09:51:44 +0100
Message-Id: <1398329507-5911-180-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

commit 48e8ac2979920ffa39117e2d725afa3a749bfe8d upstream.

With recent changes it is possible for the timer handler to detect an
idle interface and not start the timer, but the thread to start an
operation at the same time.  The thread will not start the timer in that
instance, resulting in the timer not running.

Instead, move all timer operations under the lock and start the timer in
the thread if it detect non-idle and the timer is not already running.
Moving under locks allows the last timeout to be set in both the thread
and the timer.  'Timer is not running' means that the timer is not
pending and smi_timeout() is not running.  So we need a flag to detect
this correctly.

Also fix a few other timeout bugs: setting the last timeout when the
interrupt has to be disabled and the timer started, and setting the last
timeout in check_start_timer_thread possibly racing with the timer

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: minyard@acm.org
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/ipmi/ipmi_si_intf.c | 46 ++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index af4b23f..40b3f75 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -244,6 +244,9 @@ struct smi_info {
 	/* The timer for this si. */
 	struct timer_list   si_timer;
 
+	/* This flag is set, if the timer is running (timer_pending() isn't enough) */
+	bool		    timer_running;
+
 	/* The time (in jiffies) the last timeout occurred at. */
 	unsigned long       last_timeout_jiffies;
 
@@ -427,6 +430,13 @@ static void start_clear_flags(struct smi_info *smi_info)
 	smi_info->si_state = SI_CLEARING_FLAGS;
 }
 
+static void smi_mod_timer(struct smi_info *smi_info, unsigned long new_val)
+{
+	smi_info->last_timeout_jiffies = jiffies;
+	mod_timer(&smi_info->si_timer, new_val);
+	smi_info->timer_running = true;
+}
+
 /*
  * When we have a situtaion where we run out of memory and cannot
  * allocate messages, we just leave them in the BMC and run the system
@@ -439,8 +449,7 @@ static inline void disable_si_irq(struct smi_info *smi_info)
 		start_disable_irq(smi_info);
 		smi_info->interrupt_disabled = 1;
 		if (!atomic_read(&smi_info->stop_operation))
-			mod_timer(&smi_info->si_timer,
-				  jiffies + SI_TIMEOUT_JIFFIES);
+			smi_mod_timer(smi_info, jiffies + SI_TIMEOUT_JIFFIES);
 	}
 }
 
@@ -900,15 +909,7 @@ static void sender(void                *send_info,
 		list_add_tail(&msg->link, &smi_info->xmit_msgs);
 
 	if (smi_info->si_state == SI_NORMAL && smi_info->curr_msg == NULL) {
-		/*
-		 * last_timeout_jiffies is updated here to avoid
-		 * smi_timeout() handler passing very large time_diff
-		 * value to smi_event_handler() that causes
-		 * the send command to abort.
-		 */
-		smi_info->last_timeout_jiffies = jiffies;
-
-		mod_timer(&smi_info->si_timer, jiffies + SI_TIMEOUT_JIFFIES);
+		smi_mod_timer(smi_info, jiffies + SI_TIMEOUT_JIFFIES);
 
 		if (smi_info->thread)
 			wake_up_process(smi_info->thread);
@@ -997,6 +998,17 @@ static int ipmi_thread(void *data)
 
 		spin_lock_irqsave(&(smi_info->si_lock), flags);
 		smi_result = smi_event_handler(smi_info, 0);
+
+		/*
+		 * If the driver is doing something, there is a possible
+		 * race with the timer.  If the timer handler see idle,
+		 * and the thread here sees something else, the timer
+		 * handler won't restart the timer even though it is
+		 * required.  So start it here if necessary.
+		 */
+		if (smi_result != SI_SM_IDLE && !smi_info->timer_running)
+			smi_mod_timer(smi_info, jiffies + SI_TIMEOUT_JIFFIES);
+
 		spin_unlock_irqrestore(&(smi_info->si_lock), flags);
 		busy_wait = ipmi_thread_busy_wait(smi_result, smi_info,
 						  &busy_until);
@@ -1066,10 +1078,6 @@ static void smi_timeout(unsigned long data)
 		     * SI_USEC_PER_JIFFY);
 	smi_result = smi_event_handler(smi_info, time_diff);
 
-	spin_unlock_irqrestore(&(smi_info->si_lock), flags);
-
-	smi_info->last_timeout_jiffies = jiffies_now;
-
 	if ((smi_info->irq) && (!smi_info->interrupt_disabled)) {
 		/* Running with interrupts, only do long timeouts. */
 		timeout = jiffies + SI_TIMEOUT_JIFFIES;
@@ -1091,7 +1099,10 @@ static void smi_timeout(unsigned long data)
 
  do_mod_timer:
 	if (smi_result != SI_SM_IDLE)
-		mod_timer(&(smi_info->si_timer), timeout);
+		smi_mod_timer(smi_info, timeout);
+	else
+		smi_info->timer_running = false;
+	spin_unlock_irqrestore(&(smi_info->si_lock), flags);
 }
 
 static irqreturn_t si_irq_handler(int irq, void *data)
@@ -1139,8 +1150,7 @@ static int smi_start_processing(void       *send_info,
 
 	/* Set up the timer that drives the interface. */
 	setup_timer(&new_smi->si_timer, smi_timeout, (long)new_smi);
-	new_smi->last_timeout_jiffies = jiffies;
-	mod_timer(&new_smi->si_timer, jiffies + SI_TIMEOUT_JIFFIES);
+	smi_mod_timer(new_smi, jiffies + SI_TIMEOUT_JIFFIES);
 
 	/*
 	 * Check if the user forcefully enabled the daemon.
-- 
1.9.1

