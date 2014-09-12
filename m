Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbaILMVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:21:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57282 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbaILMVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:21:40 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Joe Lawrence <joe.lawrence@stratus.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 1/4] usb: hub: convert khubd into workqueue
Date: Fri, 12 Sep 2014 14:21:05 +0200
Message-Id: <1410524468-15232-2-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1410524468-15232-1-git-send-email-pmladek@suse.cz>
References: <1410524468-15232-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to have separate kthread for handling USB hub events.
It is more elegant to use the workqueue framework.

The workqueue is allocated as unbound, cpu intensive, and freezable.
There does not seem to be any big advantage to run it on the same CPU.
The handler is taking a lock and thus could block for a longer time.
And finally, the original thread was freezable as well.

struct usb_hub is passed via the work item. Therefore we do not need
hub_event_list.

hub_events() is modified to process the given work item. It is renamed to
hub_event(). The while cycle will be removed in a followup patch. It helps
to see the real change here.

One nice thing is that we do not need hub_event_lock any longer. It was needed
when doing operations with hub_event_list and for balancing the calls
usb_autopm_get_interface_no_resume() and usb_autopm_put_interface_no_suspend().
It still works because the workqueue operations have their own locking.
Also cancel_work_sync() tells us whether any work item was canceled.
It means that we could put the interface either in hub_event() handler or when
the work item was successfully canceled.

The rest of the changes should be pretty straightforward.

Note that the source file is still full of the obsolete "khubd" strings.
Let's remove them in a follow up patch to keep this one "simple".

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 drivers/usb/core/hub.c | 114 +++++++++++++++++--------------------------------
 drivers/usb/core/hub.h |   2 +-
 2 files changed, 41 insertions(+), 75 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 6afd79ee3340..1825af63c686 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -22,9 +22,8 @@
 #include <linux/usb/hcd.h>
 #include <linux/usb/otg.h>
 #include <linux/usb/quirks.h>
-#include <linux/kthread.h>
+#include <linux/workqueue.h>
 #include <linux/mutex.h>
-#include <linux/freezer.h>
 #include <linux/random.h>
 #include <linux/pm_qos.h>
 
@@ -41,14 +40,9 @@
  * change to USB_STATE_NOTATTACHED even when the semaphore isn't held. */
 static DEFINE_SPINLOCK(device_state_lock);
 
-/* khubd's worklist and its lock */
-static DEFINE_SPINLOCK(hub_event_lock);
-static LIST_HEAD(hub_event_list);	/* List of hubs needing servicing */
-
-/* Wakes up khubd */
-static DECLARE_WAIT_QUEUE_HEAD(khubd_wait);
-
-static struct task_struct *khubd_task;
+/* workqueue to process hub events */
+static struct workqueue_struct *hub_wq;
+static void hub_event(struct work_struct *work);
 
 /* synchronize hub-port add/remove and peering operations */
 DEFINE_MUTEX(usb_port_peer_mutex);
@@ -577,18 +571,20 @@ static int hub_port_status(struct usb_hub *hub, int port1,
 
 static void kick_khubd(struct usb_hub *hub)
 {
-	unsigned long	flags;
-
-	spin_lock_irqsave(&hub_event_lock, flags);
-	if (!hub->disconnected && list_empty(&hub->event_list)) {
-		list_add_tail(&hub->event_list, &hub_event_list);
-
-		/* Suppress autosuspend until khubd runs */
+	if (!hub->disconnected && !work_pending(&hub->events)) {
+		/*
+		 * Suppress autosuspend until the event is proceed.
+		 *
+		 * Be careful and make sure that the symmetric operation is
+		 * always called. We are here only when there is no pending
+		 * work for this hub. Therefore put the interface either when
+		 * the new work is called or when it is canceled.
+		 */
 		usb_autopm_get_interface_no_resume(
 				to_usb_interface(hub->intfdev));
-		wake_up(&khubd_wait);
+		INIT_WORK(&hub->events, hub_event);
+		queue_work(hub_wq, &hub->events);
 	}
-	spin_unlock_irqrestore(&hub_event_lock, flags);
 }
 
 void usb_kick_khubd(struct usb_device *hdev)
@@ -1647,13 +1643,9 @@ static void hub_disconnect(struct usb_interface *intf)
 	int port1;
 
 	/* Take the hub off the event list and don't let it be added again */
-	spin_lock_irq(&hub_event_lock);
-	if (!list_empty(&hub->event_list)) {
-		list_del_init(&hub->event_list);
+	if (cancel_work_sync(&hub->events))
 		usb_autopm_put_interface_no_suspend(intf);
-	}
 	hub->disconnected = 1;
-	spin_unlock_irq(&hub_event_lock);
 
 	/* Disconnect all children and quiesce the hub */
 	hub->error = 0;
@@ -1793,7 +1785,6 @@ descriptor_error:
 	}
 
 	kref_init(&hub->kref);
-	INIT_LIST_HEAD(&hub->event_list);
 	hub->intfdev = &intf->dev;
 	hub->hdev = hdev;
 	INIT_DELAYED_WORK(&hub->leds, led_work);
@@ -4993,9 +4984,8 @@ static void port_event(struct usb_hub *hub, int port1)
 }
 
 
-static void hub_events(void)
+static void hub_event(struct work_struct *work)
 {
-	struct list_head *tmp;
 	struct usb_device *hdev;
 	struct usb_interface *intf;
 	struct usb_hub *hub;
@@ -5004,29 +4994,13 @@ static void hub_events(void)
 	u16 hubchange;
 	int i, ret;
 
-	/*
-	 *  We restart the list every time to avoid a deadlock with
-	 * deleting hubs downstream from this one. This should be
-	 * safe since we delete the hub from the event list.
-	 * Not the most efficient, but avoids deadlocks.
-	 */
+	/* temporary keep the cycle to show real changes in this commit */
 	while (1) {
-
-		/* Grab the first entry at the beginning of the list */
-		spin_lock_irq(&hub_event_lock);
-		if (list_empty(&hub_event_list)) {
-			spin_unlock_irq(&hub_event_lock);
-			break;
-		}
-
-		tmp = hub_event_list.next;
-		list_del_init(tmp);
-
-		hub = list_entry(tmp, struct usb_hub, event_list);
+		hub = container_of(work, struct usb_hub, events);
 		kref_get(&hub->kref);
+
 		hdev = hub->hdev;
 		usb_get_dev(hdev);
-		spin_unlock_irq(&hub_event_lock);
 
 		hub_dev = hub->intfdev;
 		intf = to_usb_interface(hub_dev);
@@ -5134,36 +5108,21 @@ static void hub_events(void)
 		/* Balance the usb_autopm_get_interface() above */
 		usb_autopm_put_interface(intf);
  loop:
+ loop_disconnected:
 		/* Balance the usb_autopm_get_interface_no_resume() in
 		 * kick_khubd() and allow autosuspend.
+		 *
+		 * It has to be done even when the hub was disconnected
+		 * when waiting for hdev lock. This function is called
+		 * and it means that usb_disconnect() was late in removing
+		 * this work from hub_wq.
 		 */
 		usb_autopm_put_interface_no_suspend(intf);
- loop_disconnected:
 		usb_unlock_device(hdev);
 		usb_put_dev(hdev);
 		kref_put(&hub->kref, hub_release);
-
-	} /* end while (1) */
-}
-
-static int hub_thread(void *__unused)
-{
-	/* khubd needs to be freezable to avoid interfering with USB-PERSIST
-	 * port handover.  Otherwise it might see that a full-speed device
-	 * was gone before the EHCI controller had handed its port over to
-	 * the companion full-speed controller.
-	 */
-	set_freezable();
-
-	do {
-		hub_events();
-		wait_event_freezable(khubd_wait,
-				!list_empty(&hub_event_list) ||
-				kthread_should_stop());
-	} while (!kthread_should_stop() || !list_empty(&hub_event_list));
-
-	pr_debug("%s: khubd exiting\n", usbcore_name);
-	return 0;
+		break;
+	}
 }
 
 static const struct usb_device_id hub_id_table[] = {
@@ -5203,21 +5162,28 @@ int usb_hub_init(void)
 		return -1;
 	}
 
-	khubd_task = kthread_run(hub_thread, NULL, "khubd");
-	if (!IS_ERR(khubd_task))
+	/*
+	 * The workqueue needs to be freezable to avoid interfering with
+	 * USB-PERSIST port handover. Otherwise it might see that a full-speed
+	 * device was gone before the EHCI controller had handed its port
+	 * over to the companion full-speed controller.
+	 */
+	hub_wq = alloc_workqueue("hub",
+				 WQ_UNBOUND | WQ_CPU_INTENSIVE | WQ_FREEZABLE,
+				 0);
+	if (hub_wq)
 		return 0;
 
 	/* Fall through if kernel_thread failed */
 	usb_deregister(&hub_driver);
-	printk(KERN_ERR "%s: can't start khubd\n", usbcore_name);
+	pr_err("%s: can't allocate workqueue for hub\n", usbcore_name);
 
 	return -1;
 }
 
 void usb_hub_cleanup(void)
 {
-	kthread_stop(khubd_task);
-
+	destroy_workqueue(hub_wq);
 	/*
 	 * Hub resources are freed for us by usb_deregister. It calls
 	 * usb_driver_purge on every device which in turn calls that
diff --git a/drivers/usb/core/hub.h b/drivers/usb/core/hub.h
index c77d8778af4b..688817fb3246 100644
--- a/drivers/usb/core/hub.h
+++ b/drivers/usb/core/hub.h
@@ -41,7 +41,6 @@ struct usb_hub {
 	int			error;		/* last reported error */
 	int			nerrors;	/* track consecutive errors */
 
-	struct list_head	event_list;	/* hubs w/data or errs ready */
 	unsigned long		event_bits[1];	/* status change bitmask */
 	unsigned long		change_bits[1];	/* ports with logical connect
 							status change */
@@ -77,6 +76,7 @@ struct usb_hub {
 	u8			indicator[USB_MAXCHILDREN];
 	struct delayed_work	leds;
 	struct delayed_work	init_work;
+	struct work_struct      events;
 	struct usb_port		**ports;
 };
 
-- 
1.8.4

