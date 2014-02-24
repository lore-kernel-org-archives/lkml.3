Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaBXCYa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 21:24:30 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:47826 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaBXCY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 21:24:28 -0500
From: minyard@acm.org
To: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Russ Anderson <rja@sgi.com>,
        Matthew Garrett <matthew.garrett@nebula.com>, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 2/3] ipmi: Turn off all activity on an idle ipmi interface
Date: Sun, 23 Feb 2014 20:23:35 -0600
Message-Id: <1393208616-16500-3-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393208616-16500-1-git-send-email-minyard@acm.org>
References: <1393208616-16500-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

The IPMI driver would wake up periodically looking for events and
watchdog pretimeouts.  If there is nothing waiting for these events,
it's really kind of pointless to be checking for them.  So modify
the driver so the message handler can pass down if it needs the
lower layer to be waiting for these.  Modify the system interface
lower layer to turn off all timer and thread activity if the upper
layer doesn't need anything and it is not currently handling messages.
And modify the message handler to not restart the timer if its timer
is not needed.

The timers and kthread will still be enabled if:
* The SI interface is handling a message.
* A user has enabled watching for events.
* The IPMI watchdog timer is in use (since it uses pretimeouts).
* The message handler is waiting on a remote response.
* A user has registered to receive commands.

This mostly affects interfaces without interrupts.  Interfaces
with interrupts already don't use CPU in the system interface
when the interface is idle.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_msghandler.c | 215 ++++++++++++++++++++++--------------
 drivers/char/ipmi/ipmi_si_intf.c    |  67 +++++++----
 include/linux/ipmi_smi.h            |   7 ++
 3 files changed, 187 insertions(+), 102 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index ec4e10f..f49b4c6 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -55,6 +55,7 @@ static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void);
 static int ipmi_init_msghandler(void);
 static void smi_recv_tasklet(unsigned long);
 static void handle_new_recv_msgs(ipmi_smi_t intf);
+static void need_waiter(ipmi_smi_t intf);
 
 static int initialized;
 
@@ -73,6 +74,20 @@ static struct proc_dir_entry *proc_ipmi_root;
  */
 #define MAX_MSG_TIMEOUT		60000
 
+/* Call every ~1000 ms. */
+#define IPMI_TIMEOUT_TIME	1000
+
+/* How many jiffies does it take to get to the timeout time. */
+#define IPMI_TIMEOUT_JIFFIES	((IPMI_TIMEOUT_TIME * HZ) / 1000)
+
+/*
+ * Request events from the queue every second (this is the number of
+ * IPMI_TIMEOUT_TIMES between event requests).  Hopefully, in the
+ * future, IPMI will add a way to know immediately if an event is in
+ * the queue and this silliness can go away.
+ */
+#define IPMI_REQUEST_EV_TIME	(1000 / (IPMI_TIMEOUT_TIME))
+
 /*
  * The main "user" data structure.
  */
@@ -383,6 +398,9 @@ struct ipmi_smi {
 	unsigned int     waiting_events_count; /* How many events in queue? */
 	char             delivering_events;
 	char             event_msg_printed;
+	atomic_t         event_waiters;
+	unsigned int     ticks_to_req_ev;
+	int              last_needs_timer;
 
 	/*
 	 * The event receiver for my BMC, only really used at panic
@@ -451,7 +469,6 @@ static DEFINE_MUTEX(ipmi_interfaces_mutex);
 static LIST_HEAD(smi_watchers);
 static DEFINE_MUTEX(smi_watchers_mutex);
 
-
 #define ipmi_inc_stat(intf, stat) \
 	atomic_inc(&(intf)->stats[IPMI_STAT_ ## stat])
 #define ipmi_get_stat(intf, stat) \
@@ -772,6 +789,7 @@ static int intf_next_seq(ipmi_smi_t           intf,
 		*seq = i;
 		*seqid = intf->seq_table[i].seqid;
 		intf->curr_seq = (i+1)%IPMI_IPMB_NUM_SEQ;
+		need_waiter(intf);
 	} else {
 		rv = -EAGAIN;
 	}
@@ -966,6 +984,11 @@ int ipmi_create_user(unsigned int          if_num,
 	spin_lock_irqsave(&intf->seq_lock, flags);
 	list_add_rcu(&new_user->link, &intf->users);
 	spin_unlock_irqrestore(&intf->seq_lock, flags);
+	if (handler->ipmi_watchdog_pretimeout) {
+		/* User wants pretimeouts, so make sure to watch for them. */
+		if (atomic_inc_return(&intf->event_waiters) == 1)
+			need_waiter(intf);
+	}
 	*user = new_user;
 	return 0;
 
@@ -1021,6 +1044,12 @@ int ipmi_destroy_user(ipmi_user_t user)
 
 	user->valid = 0;
 
+	if (user->handler->ipmi_watchdog_pretimeout)
+		atomic_dec(&intf->event_waiters);
+
+	if (user->gets_events)
+		atomic_dec(&intf->event_waiters);
+
 	/* Remove the user from the interface's sequence table. */
 	spin_lock_irqsave(&intf->seq_lock, flags);
 	list_del_rcu(&user->link);
@@ -1194,7 +1223,17 @@ int ipmi_set_gets_events(ipmi_user_t user, int val)
 	INIT_LIST_HEAD(&msgs);
 
 	spin_lock_irqsave(&intf->events_lock, flags);
-	user->gets_events = val;
+	if (user->gets_events == !!val)
+		goto out;
+
+	user->gets_events = !!val;
+
+	if (val) {
+		if (atomic_inc_return(&intf->event_waiters) == 1)
+			need_waiter(intf);
+	} else {
+		atomic_dec(&intf->event_waiters);
+	}
 
 	if (intf->delivering_events)
 		/*
@@ -1289,6 +1328,9 @@ int ipmi_register_for_cmd(ipmi_user_t   user,
 		goto out_unlock;
 	}
 
+	if (atomic_inc_return(&intf->event_waiters) == 1)
+		need_waiter(intf);
+
 	list_add_rcu(&rcvr->link, &intf->cmd_rcvrs);
 
  out_unlock:
@@ -1330,6 +1372,7 @@ int ipmi_unregister_for_cmd(ipmi_user_t   user,
 	mutex_unlock(&intf->cmd_rcvrs_mutex);
 	synchronize_rcu();
 	while (rcvrs) {
+		atomic_dec(&intf->event_waiters);
 		rcvr = rcvrs;
 		rcvrs = rcvr->next;
 		kfree(rcvr);
@@ -2876,6 +2919,8 @@ int ipmi_register_smi(struct ipmi_smi_handlers *handlers,
 		     (unsigned long) intf);
 	atomic_set(&intf->watchdog_pretimeouts_to_deliver, 0);
 	spin_lock_init(&intf->events_lock);
+	atomic_set(&intf->event_waiters, 0);
+	intf->ticks_to_req_ev = IPMI_REQUEST_EV_TIME;
 	INIT_LIST_HEAD(&intf->waiting_events);
 	intf->waiting_events_count = 0;
 	mutex_init(&intf->cmd_rcvrs_mutex);
@@ -3965,7 +4010,8 @@ smi_from_recv_msg(ipmi_smi_t intf, struct ipmi_recv_msg *recv_msg,
 
 static void check_msg_timeout(ipmi_smi_t intf, struct seq_table *ent,
 			      struct list_head *timeouts, long timeout_period,
-			      int slot, unsigned long *flags)
+			      int slot, unsigned long *flags,
+			      unsigned int *waiting_msgs)
 {
 	struct ipmi_recv_msg     *msg;
 	struct ipmi_smi_handlers *handlers;
@@ -3977,8 +4023,10 @@ static void check_msg_timeout(ipmi_smi_t intf, struct seq_table *ent,
 		return;
 
 	ent->timeout -= timeout_period;
-	if (ent->timeout > 0)
+	if (ent->timeout > 0) {
+		(*waiting_msgs)++;
 		return;
+	}
 
 	if (ent->retries_left == 0) {
 		/* The message has used all its retries. */
@@ -3995,6 +4043,8 @@ static void check_msg_timeout(ipmi_smi_t intf, struct seq_table *ent,
 		struct ipmi_smi_msg *smi_msg;
 		/* More retries, send again. */
 
+		(*waiting_msgs)++;
+
 		/*
 		 * Start with the max timer, set to normal timer after
 		 * the message is sent.
@@ -4040,117 +4090,118 @@ static void check_msg_timeout(ipmi_smi_t intf, struct seq_table *ent,
 	}
 }
 
-static void ipmi_timeout_handler(long timeout_period)
+static unsigned int ipmi_timeout_handler(ipmi_smi_t intf, long timeout_period)
 {
-	ipmi_smi_t           intf;
 	struct list_head     timeouts;
 	struct ipmi_recv_msg *msg, *msg2;
 	unsigned long        flags;
 	int                  i;
+	unsigned int         waiting_msgs = 0;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(intf, &ipmi_interfaces, link) {
-		tasklet_schedule(&intf->recv_tasklet);
-
-		/*
-		 * Go through the seq table and find any messages that
-		 * have timed out, putting them in the timeouts
-		 * list.
-		 */
-		INIT_LIST_HEAD(&timeouts);
-		spin_lock_irqsave(&intf->seq_lock, flags);
-		for (i = 0; i < IPMI_IPMB_NUM_SEQ; i++)
-			check_msg_timeout(intf, &(intf->seq_table[i]),
-					  &timeouts, timeout_period, i,
-					  &flags);
-		spin_unlock_irqrestore(&intf->seq_lock, flags);
+	/*
+	 * Go through the seq table and find any messages that
+	 * have timed out, putting them in the timeouts
+	 * list.
+	 */
+	INIT_LIST_HEAD(&timeouts);
+	spin_lock_irqsave(&intf->seq_lock, flags);
+	for (i = 0; i < IPMI_IPMB_NUM_SEQ; i++)
+		check_msg_timeout(intf, &(intf->seq_table[i]),
+				  &timeouts, timeout_period, i,
+				  &flags, &waiting_msgs);
+	spin_unlock_irqrestore(&intf->seq_lock, flags);
 
-		list_for_each_entry_safe(msg, msg2, &timeouts, link)
-			deliver_err_response(msg, IPMI_TIMEOUT_COMPLETION_CODE);
+	list_for_each_entry_safe(msg, msg2, &timeouts, link)
+		deliver_err_response(msg, IPMI_TIMEOUT_COMPLETION_CODE);
 
-		/*
-		 * Maintenance mode handling.  Check the timeout
-		 * optimistically before we claim the lock.  It may
-		 * mean a timeout gets missed occasionally, but that
-		 * only means the timeout gets extended by one period
-		 * in that case.  No big deal, and it avoids the lock
-		 * most of the time.
-		 */
+	/*
+	 * Maintenance mode handling.  Check the timeout
+	 * optimistically before we claim the lock.  It may
+	 * mean a timeout gets missed occasionally, but that
+	 * only means the timeout gets extended by one period
+	 * in that case.  No big deal, and it avoids the lock
+	 * most of the time.
+	 */
+	if (intf->auto_maintenance_timeout > 0) {
+		spin_lock_irqsave(&intf->maintenance_mode_lock, flags);
 		if (intf->auto_maintenance_timeout > 0) {
-			spin_lock_irqsave(&intf->maintenance_mode_lock, flags);
-			if (intf->auto_maintenance_timeout > 0) {
-				intf->auto_maintenance_timeout
-					-= timeout_period;
-				if (!intf->maintenance_mode
-				    && (intf->auto_maintenance_timeout <= 0)) {
-					intf->maintenance_mode_enable = 0;
-					maintenance_mode_update(intf);
-				}
+			intf->auto_maintenance_timeout
+				-= timeout_period;
+			if (!intf->maintenance_mode
+			    && (intf->auto_maintenance_timeout <= 0)) {
+				intf->maintenance_mode_enable = 0;
+				maintenance_mode_update(intf);
 			}
-			spin_unlock_irqrestore(&intf->maintenance_mode_lock,
-					       flags);
 		}
+		spin_unlock_irqrestore(&intf->maintenance_mode_lock,
+				       flags);
 	}
-	rcu_read_unlock();
+
+	tasklet_schedule(&intf->recv_tasklet);
+
+	return waiting_msgs;
 }
 
-static void ipmi_request_event(void)
+static void ipmi_request_event(ipmi_smi_t intf)
 {
-	ipmi_smi_t               intf;
 	struct ipmi_smi_handlers *handlers;
 
-	rcu_read_lock();
-	/*
-	 * Called from the timer, no need to check if handlers is
-	 * valid.
-	 */
-	list_for_each_entry_rcu(intf, &ipmi_interfaces, link) {
-		/* No event requests when in maintenance mode. */
-		if (intf->maintenance_mode_enable)
-			continue;
+	/* No event requests when in maintenance mode. */
+	if (intf->maintenance_mode_enable)
+		return;
 
-		handlers = intf->handlers;
-		if (handlers)
-			handlers->request_events(intf->send_info);
-	}
-	rcu_read_unlock();
+	handlers = intf->handlers;
+	if (handlers)
+		handlers->request_events(intf->send_info);
 }
 
 static struct timer_list ipmi_timer;
 
-/* Call every ~1000 ms. */
-#define IPMI_TIMEOUT_TIME	1000
-
-/* How many jiffies does it take to get to the timeout time. */
-#define IPMI_TIMEOUT_JIFFIES	((IPMI_TIMEOUT_TIME * HZ) / 1000)
-
-/*
- * Request events from the queue every second (this is the number of
- * IPMI_TIMEOUT_TIMES between event requests).  Hopefully, in the
- * future, IPMI will add a way to know immediately if an event is in
- * the queue and this silliness can go away.
- */
-#define IPMI_REQUEST_EV_TIME	(1000 / (IPMI_TIMEOUT_TIME))
-
 static atomic_t stop_operation;
-static unsigned int ticks_to_req_ev = IPMI_REQUEST_EV_TIME;
 
 static void ipmi_timeout(unsigned long data)
 {
+	ipmi_smi_t intf;
+	int nt = 0;
+
 	if (atomic_read(&stop_operation))
 		return;
 
-	ticks_to_req_ev--;
-	if (ticks_to_req_ev == 0) {
-		ipmi_request_event();
-		ticks_to_req_ev = IPMI_REQUEST_EV_TIME;
-	}
+	rcu_read_lock();
+	list_for_each_entry_rcu(intf, &ipmi_interfaces, link) {
+		int lnt = 0;
+
+		if (atomic_read(&intf->event_waiters)) {
+			intf->ticks_to_req_ev--;
+			if (intf->ticks_to_req_ev == 0) {
+				ipmi_request_event(intf);
+				intf->ticks_to_req_ev = IPMI_REQUEST_EV_TIME;
+			}
+			lnt++;
+		}
 
-	ipmi_timeout_handler(IPMI_TIMEOUT_TIME);
+		lnt += ipmi_timeout_handler(intf, IPMI_TIMEOUT_TIME);
 
-	mod_timer(&ipmi_timer, jiffies + IPMI_TIMEOUT_JIFFIES);
+		lnt = !!lnt;
+		if (lnt != intf->last_needs_timer &&
+					intf->handlers->set_need_watch)
+			intf->handlers->set_need_watch(intf->send_info, lnt);
+		intf->last_needs_timer = lnt;
+
+		nt += lnt;
+	}
+	rcu_read_unlock();
+
+	if (nt)
+		mod_timer(&ipmi_timer, jiffies + IPMI_TIMEOUT_JIFFIES);
 }
 
+static void need_waiter(ipmi_smi_t intf)
+{
+	/* Racy, but worst case we start the timer twice. */
+	if (!timer_pending(&ipmi_timer))
+		mod_timer(&ipmi_timer, jiffies + IPMI_TIMEOUT_JIFFIES);
+}
 
 static atomic_t smi_msg_inuse_count = ATOMIC_INIT(0);
 static atomic_t recv_msg_inuse_count = ATOMIC_INIT(0);
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 7b420e1..dd2bf2a 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -255,6 +255,9 @@ struct smi_info {
 	/* Used to gracefully stop the timer without race conditions. */
 	atomic_t            stop_operation;
 
+	/* Are we waiting for the events, pretimeouts, received msgs? */
+	atomic_t            need_watch;
+
 	/*
 	 * The driver will disable interrupts when it gets into a
 	 * situation where it cannot handle messages due to lack of
@@ -854,6 +857,27 @@ static enum si_sm_result smi_event_handler(struct smi_info *smi_info,
 	return si_sm_result;
 }
 
+static void check_start_timer_thread(struct smi_info *smi_info)
+{
+	if (smi_info->si_state == SI_NORMAL && smi_info->curr_msg == NULL) {
+		/*
+		 * last_timeout_jiffies is updated here to avoid
+		 * smi_timeout() handler passing very large time_diff
+		 * value to smi_event_handler() that causes
+		 * the send command to abort.
+		 */
+		smi_info->last_timeout_jiffies = jiffies;
+
+		mod_timer(&smi_info->si_timer, jiffies + SI_TIMEOUT_JIFFIES);
+
+		if (smi_info->thread)
+			wake_up_process(smi_info->thread);
+
+		start_next_msg(smi_info);
+		smi_event_handler(smi_info, 0);
+	}
+}
+
 static void sender(void                *send_info,
 		   struct ipmi_smi_msg *msg,
 		   int                 priority)
@@ -907,23 +931,7 @@ static void sender(void                *send_info,
 	else
 		list_add_tail(&msg->link, &smi_info->xmit_msgs);
 
-	if (smi_info->si_state == SI_NORMAL && smi_info->curr_msg == NULL) {
-		/*
-		 * last_timeout_jiffies is updated here to avoid
-		 * smi_timeout() handler passing very large time_diff
-		 * value to smi_event_handler() that causes
-		 * the send command to abort.
-		 */
-		smi_info->last_timeout_jiffies = jiffies;
-
-		mod_timer(&smi_info->si_timer, jiffies + SI_TIMEOUT_JIFFIES);
-
-		if (smi_info->thread)
-			wake_up_process(smi_info->thread);
-
-		start_next_msg(smi_info);
-		smi_event_handler(smi_info, 0);
-	}
+	check_start_timer_thread(smi_info);
 	spin_unlock_irqrestore(&smi_info->si_lock, flags);
 }
 
@@ -1012,9 +1020,15 @@ static int ipmi_thread(void *data)
 			; /* do nothing */
 		else if (smi_result == SI_SM_CALL_WITH_DELAY && busy_wait)
 			schedule();
-		else if (smi_result == SI_SM_IDLE)
-			schedule_timeout_interruptible(100);
-		else
+		else if (smi_result == SI_SM_IDLE) {
+			if (atomic_read(&smi_info->need_watch)) {
+				schedule_timeout_interruptible(100);
+			} else {
+				/* Wait to be woken up when we are needed. */
+				__set_current_state(TASK_INTERRUPTIBLE);
+				schedule();
+			}
+		} else
 			schedule_timeout_interruptible(1);
 	}
 	return 0;
@@ -1050,6 +1064,17 @@ static void request_events(void *send_info)
 	atomic_set(&smi_info->req_events, 1);
 }
 
+static void set_need_watch(void *send_info, int enable)
+{
+	struct smi_info *smi_info = send_info;
+	unsigned long flags;
+
+	atomic_set(&smi_info->need_watch, enable);
+	spin_lock_irqsave(&smi_info->si_lock, flags);
+	check_start_timer_thread(smi_info);
+	spin_unlock_irqrestore(&smi_info->si_lock, flags);
+}
+
 static int initialized;
 
 static void smi_timeout(unsigned long data)
@@ -1203,6 +1228,7 @@ static struct ipmi_smi_handlers handlers = {
 	.get_smi_info		= get_smi_info,
 	.sender			= sender,
 	.request_events		= request_events,
+	.set_need_watch		= set_need_watch,
 	.set_maintenance_mode   = set_maintenance_mode,
 	.set_run_to_completion  = set_run_to_completion,
 	.poll			= poll,
@@ -3347,6 +3373,7 @@ static int try_smi_init(struct smi_info *new_smi)
 
 	new_smi->interrupt_disabled = 1;
 	atomic_set(&new_smi->stop_operation, 0);
+	atomic_set(&new_smi->need_watch, 0);
 	new_smi->intf_num = smi_num;
 	smi_num++;
 
diff --git a/include/linux/ipmi_smi.h b/include/linux/ipmi_smi.h
index 8ea3fe0..2a7ff30 100644
--- a/include/linux/ipmi_smi.h
+++ b/include/linux/ipmi_smi.h
@@ -109,6 +109,13 @@ struct ipmi_smi_handlers {
 	   events from the BMC we are attached to. */
 	void (*request_events)(void *send_info);
 
+	/* Called by the upper layer when some user requires that the
+	   interface watch for events, received messages, watchdog
+	   pretimeouts, or not.  Used by the SMI to know if it should
+	   watch for these.  This may be NULL if the SMI does not
+	   implement it. */
+	void (*set_need_watch)(void *send_info, int enable);
+
 	/* Called when the interface should go into "run to
 	   completion" mode.  If this call sets the value to true, the
 	   interface should make sure that all messages are flushed
-- 
1.8.3.1

