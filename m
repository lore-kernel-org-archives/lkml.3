Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaDNOrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:47:13 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:36068 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaDNOrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:47:09 -0400
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 7/7] ipmi: boolify some things
Date: Mon, 14 Apr 2014 09:46:56 -0500
Message-Id: <1397486816-18045-8-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1397486816-18045-1-git-send-email-minyard@acm.org>
References: <1397486816-18045-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Convert some ints to bools.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_msghandler.c | 22 ++++++++--------
 drivers/char/ipmi/ipmi_si_intf.c    | 50 ++++++++++++++++++-------------------
 include/linux/ipmi_smi.h            |  6 ++---
 3 files changed, 38 insertions(+), 40 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 872c4ec..e6db938 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -94,8 +94,8 @@ static struct proc_dir_entry *proc_ipmi_root;
 struct ipmi_user {
 	struct list_head link;
 
-	/* Set to "0" when the user is destroyed. */
-	int valid;
+	/* Set to false when the user is destroyed. */
+	bool valid;
 
 	struct kref refcount;
 
@@ -413,7 +413,7 @@ struct ipmi_smi {
 
 	/* For handling of maintenance mode. */
 	int maintenance_mode;
-	int maintenance_mode_enable;
+	bool maintenance_mode_enable;
 	int auto_maintenance_timeout;
 	spinlock_t maintenance_mode_lock; /* Used in a timer... */
 
@@ -980,7 +980,7 @@ int ipmi_create_user(unsigned int          if_num,
 	 */
 	mutex_unlock(&ipmi_interfaces_mutex);
 
-	new_user->valid = 1;
+	new_user->valid = true;
 	spin_lock_irqsave(&intf->seq_lock, flags);
 	list_add_rcu(&new_user->link, &intf->users);
 	spin_unlock_irqrestore(&intf->seq_lock, flags);
@@ -1042,7 +1042,7 @@ int ipmi_destroy_user(ipmi_user_t user)
 	struct cmd_rcvr  *rcvr;
 	struct cmd_rcvr  *rcvrs = NULL;
 
-	user->valid = 0;
+	user->valid = false;
 
 	if (user->handler->ipmi_watchdog_pretimeout)
 		atomic_dec(&intf->event_waiters);
@@ -1184,25 +1184,23 @@ int ipmi_set_maintenance_mode(ipmi_user_t user, int mode)
 	if (intf->maintenance_mode != mode) {
 		switch (mode) {
 		case IPMI_MAINTENANCE_MODE_AUTO:
-			intf->maintenance_mode = mode;
 			intf->maintenance_mode_enable
 				= (intf->auto_maintenance_timeout > 0);
 			break;
 
 		case IPMI_MAINTENANCE_MODE_OFF:
-			intf->maintenance_mode = mode;
-			intf->maintenance_mode_enable = 0;
+			intf->maintenance_mode_enable = false;
 			break;
 
 		case IPMI_MAINTENANCE_MODE_ON:
-			intf->maintenance_mode = mode;
-			intf->maintenance_mode_enable = 1;
+			intf->maintenance_mode_enable = true;
 			break;
 
 		default:
 			rv = -EINVAL;
 			goto out_unlock;
 		}
+		intf->maintenance_mode = mode;
 
 		maintenance_mode_update(intf);
 	}
@@ -1578,7 +1576,7 @@ static int i_ipmi_request(ipmi_user_t          user,
 				= IPMI_MAINTENANCE_MODE_TIMEOUT;
 			if (!intf->maintenance_mode
 			    && !intf->maintenance_mode_enable) {
-				intf->maintenance_mode_enable = 1;
+				intf->maintenance_mode_enable = true;
 				maintenance_mode_update(intf);
 			}
 			spin_unlock_irqrestore(&intf->maintenance_mode_lock,
@@ -4129,7 +4127,7 @@ static unsigned int ipmi_timeout_handler(ipmi_smi_t intf, long timeout_period)
 				-= timeout_period;
 			if (!intf->maintenance_mode
 			    && (intf->auto_maintenance_timeout <= 0)) {
-				intf->maintenance_mode_enable = 0;
+				intf->maintenance_mode_enable = false;
 				maintenance_mode_update(intf);
 			}
 		}
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 444ea54..1c4bb4f 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -217,7 +217,7 @@ struct smi_info {
 	unsigned char       msg_flags;
 
 	/* Does the BMC have an event buffer? */
-	char		    has_event_buffer;
+	bool		    has_event_buffer;
 
 	/*
 	 * If set to true, this will request events the next time the
@@ -230,7 +230,7 @@ struct smi_info {
 	 * call.  Generally used after a panic to make sure stuff goes
 	 * out.
 	 */
-	int                 run_to_completion;
+	bool                run_to_completion;
 
 	/* The I/O port of an SI interface. */
 	int                 port;
@@ -266,7 +266,7 @@ struct smi_info {
 	 * memory.  Once that situation clears up, it will re-enable
 	 * interrupts.
 	 */
-	int interrupt_disabled;
+	bool interrupt_disabled;
 
 	/* From the get device id response... */
 	struct ipmi_device_id device_id;
@@ -279,7 +279,7 @@ struct smi_info {
 	 * True if we allocated the device, false if it came from
 	 * someplace else (like PCI).
 	 */
-	int dev_registered;
+	bool dev_registered;
 
 	/* Slave address, could be reported from DMI. */
 	unsigned char slave_addr;
@@ -303,19 +303,19 @@ struct smi_info {
 static int force_kipmid[SI_MAX_PARMS];
 static int num_force_kipmid;
 #ifdef CONFIG_PCI
-static int pci_registered;
+static bool pci_registered;
 #endif
 #ifdef CONFIG_ACPI
-static int pnp_registered;
+static bool pnp_registered;
 #endif
 #ifdef CONFIG_PARISC
-static int parisc_registered;
+static bool parisc_registered;
 #endif
 
 static unsigned int kipmid_max_busy_us[SI_MAX_PARMS];
 static int num_max_busy_us;
 
-static int unload_when_empty = 1;
+static bool unload_when_empty = true;
 
 static int add_smi(struct smi_info *smi);
 static int try_smi_init(struct smi_info *smi);
@@ -457,7 +457,7 @@ static inline void disable_si_irq(struct smi_info *smi_info)
 {
 	if ((smi_info->irq) && (!smi_info->interrupt_disabled)) {
 		start_disable_irq(smi_info);
-		smi_info->interrupt_disabled = 1;
+		smi_info->interrupt_disabled = true;
 		if (!atomic_read(&smi_info->stop_operation))
 			smi_mod_timer(smi_info, jiffies + SI_TIMEOUT_JIFFIES);
 	}
@@ -467,7 +467,7 @@ static inline void enable_si_irq(struct smi_info *smi_info)
 {
 	if ((smi_info->irq) && (smi_info->interrupt_disabled)) {
 		start_enable_irq(smi_info);
-		smi_info->interrupt_disabled = 0;
+		smi_info->interrupt_disabled = false;
 	}
 }
 
@@ -712,7 +712,7 @@ static void handle_transaction_done(struct smi_info *smi_info)
 			dev_warn(smi_info->dev,
 				 "Maybe ok, but ipmi might run very slowly.\n");
 		} else
-			smi_info->interrupt_disabled = 0;
+			smi_info->interrupt_disabled = false;
 		smi_info->si_state = SI_NORMAL;
 		break;
 	}
@@ -935,7 +935,7 @@ static void sender(void                *send_info,
 	spin_unlock_irqrestore(&smi_info->si_lock, flags);
 }
 
-static void set_run_to_completion(void *send_info, int i_run_to_completion)
+static void set_run_to_completion(void *send_info, bool i_run_to_completion)
 {
 	struct smi_info   *smi_info = send_info;
 	enum si_sm_result result;
@@ -1050,7 +1050,7 @@ static void poll(void *send_info)
 {
 	struct smi_info *smi_info = send_info;
 	unsigned long flags = 0;
-	int run_to_completion = smi_info->run_to_completion;
+	bool run_to_completion = smi_info->run_to_completion;
 
 	/*
 	 * Make sure there is some delay in the poll loop so we can
@@ -1075,7 +1075,7 @@ static void request_events(void *send_info)
 	atomic_set(&smi_info->req_events, 1);
 }
 
-static void set_need_watch(void *send_info, int enable)
+static void set_need_watch(void *send_info, bool enable)
 {
 	struct smi_info *smi_info = send_info;
 	unsigned long flags;
@@ -1223,7 +1223,7 @@ static int get_smi_info(void *send_info, struct ipmi_smi_info *data)
 	return 0;
 }
 
-static void set_maintenance_mode(void *send_info, int enable)
+static void set_maintenance_mode(void *send_info, bool enable)
 {
 	struct smi_info   *smi_info = send_info;
 
@@ -1364,7 +1364,7 @@ module_param_array(force_kipmid, int, &num_force_kipmid, 0);
 MODULE_PARM_DESC(force_kipmid, "Force the kipmi daemon to be enabled (1) or"
 		 " disabled(0).  Normally the IPMI driver auto-detects"
 		 " this, but the value may be overridden by this parm.");
-module_param(unload_when_empty, int, 0);
+module_param(unload_when_empty, bool, 0);
 MODULE_PARM_DESC(unload_when_empty, "Unload the module if no interfaces are"
 		 " specified or found, default is 1.  Setting to 0"
 		 " is useful for hot add of devices using hotmod.");
@@ -3372,11 +3372,11 @@ static int try_smi_init(struct smi_info *new_smi)
 	INIT_LIST_HEAD(&(new_smi->hp_xmit_msgs));
 	new_smi->curr_msg = NULL;
 	atomic_set(&new_smi->req_events, 0);
-	new_smi->run_to_completion = 0;
+	new_smi->run_to_completion = false;
 	for (i = 0; i < SI_NUM_STATS; i++)
 		atomic_set(&new_smi->stats[i], 0);
 
-	new_smi->interrupt_disabled = 1;
+	new_smi->interrupt_disabled = true;
 	atomic_set(&new_smi->stop_operation, 0);
 	atomic_set(&new_smi->need_watch, 0);
 	new_smi->intf_num = smi_num;
@@ -3384,7 +3384,7 @@ static int try_smi_init(struct smi_info *new_smi)
 
 	rv = try_enable_event_buffer(new_smi);
 	if (rv == 0)
-		new_smi->has_event_buffer = 1;
+		new_smi->has_event_buffer = true;
 
 	/*
 	 * Start clearing the flags before we enable interrupts or the
@@ -3418,7 +3418,7 @@ static int try_smi_init(struct smi_info *new_smi)
 			       rv);
 			goto out_err;
 		}
-		new_smi->dev_registered = 1;
+		new_smi->dev_registered = true;
 	}
 
 	rv = ipmi_register_smi(&handlers,
@@ -3467,7 +3467,7 @@ static int try_smi_init(struct smi_info *new_smi)
 	wait_for_timer_and_thread(new_smi);
 
  out_err:
-	new_smi->interrupt_disabled = 1;
+	new_smi->interrupt_disabled = true;
 
 	if (new_smi->intf) {
 		ipmi_unregister_smi(new_smi->intf);
@@ -3503,7 +3503,7 @@ static int try_smi_init(struct smi_info *new_smi)
 
 	if (new_smi->dev_registered) {
 		platform_device_unregister(new_smi->pdev);
-		new_smi->dev_registered = 0;
+		new_smi->dev_registered = false;
 	}
 
 	return rv;
@@ -3558,14 +3558,14 @@ static int init_ipmi_si(void)
 			printk(KERN_ERR PFX "Unable to register "
 			       "PCI driver: %d\n", rv);
 		else
-			pci_registered = 1;
+			pci_registered = true;
 	}
 #endif
 
 #ifdef CONFIG_ACPI
 	if (si_tryacpi) {
 		pnp_register_driver(&ipmi_pnp_driver);
-		pnp_registered = 1;
+		pnp_registered = true;
 	}
 #endif
 
@@ -3581,7 +3581,7 @@ static int init_ipmi_si(void)
 
 #ifdef CONFIG_PARISC
 	register_parisc_driver(&ipmi_parisc_driver);
-	parisc_registered = 1;
+	parisc_registered = true;
 	/* poking PC IO addresses will crash machine, don't do it */
 	si_trydefaults = 0;
 #endif
diff --git a/include/linux/ipmi_smi.h b/include/linux/ipmi_smi.h
index 2a7ff30..bd34924 100644
--- a/include/linux/ipmi_smi.h
+++ b/include/linux/ipmi_smi.h
@@ -114,14 +114,14 @@ struct ipmi_smi_handlers {
 	   pretimeouts, or not.  Used by the SMI to know if it should
 	   watch for these.  This may be NULL if the SMI does not
 	   implement it. */
-	void (*set_need_watch)(void *send_info, int enable);
+	void (*set_need_watch)(void *send_info, bool enable);
 
 	/* Called when the interface should go into "run to
 	   completion" mode.  If this call sets the value to true, the
 	   interface should make sure that all messages are flushed
 	   out and that none are pending, and any new requests are run
 	   to completion immediately. */
-	void (*set_run_to_completion)(void *send_info, int run_to_completion);
+	void (*set_run_to_completion)(void *send_info, bool run_to_completion);
 
 	/* Called to poll for work to do.  This is so upper layers can
 	   poll for operations during things like crash dumps. */
@@ -132,7 +132,7 @@ struct ipmi_smi_handlers {
 	   setting.  The message handler does the mode handling.  Note
 	   that this is called from interrupt context, so it cannot
 	   block. */
-	void (*set_maintenance_mode)(void *send_info, int enable);
+	void (*set_maintenance_mode)(void *send_info, bool enable);
 
 	/* Tell the handler that we are using it/not using it.  The
 	   message handler get the modules that this handler belongs
-- 
1.8.3.1

