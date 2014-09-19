Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbaISPdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:33:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757818AbaISPdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:33:41 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Joe Lawrence <joe.lawrence@stratus.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v3 3/6] usb: hub: convert khubd into workqueue
Date: Fri, 19 Sep 2014 17:32:21 +0200
Message-Id: <1411140744-21424-4-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1411140744-21424-1-git-send-email-pmladek@suse.cz>
References: <1411140744-21424-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to have separate kthread for handling USB hub events.
It is more elegant to use the workqueue framework.

The workqueue is allocated as freezable because the original thread was
freezable as well.

Also it is allocated as ordered because the code is not ready for parallel
processing of hub events, see choose_devnum().

struct usb_hub is passed via the work item. Therefore we do not need
hub_event_list.

Also hub_thread() is not longer needed. It would call only hub_event().
The rest of the code did manipulate the kthread and it is handled by the
workqueue framework now.

kick_khubd is renamed to kick_hub_wq() to make the function clear. And the
protection against races is done another way, see below.

hub_event_lock has been removed. It cannot longer be used to protect struct
usb_hub between hub_event() and hub_disconnect(). Instead we need to get
hub->kref already in kick_hub_wq().

The lock is not really needed for the other scenarios as well. queue_work()
returns whether it succeeded. We could revert the needed operations
accordingly. This is enough to avoid duplicity and inconsistencies.

Yes, the removed lock causes that there is not longer such a strong
synchronization between scheduling the work and manipulating
hub->disconnected.

But kick_hub_wq() must never be called together with hub_disconnect()
otherwise even the original code would have failed. Any callers are
responsible for this.

Therefore the only problem is that hub_disconnect() could be called in parallel
with hub_event(). But this was possible even in the past. struct usb_hub is
still guarded by hub->kref and released in hub_events() when needed.

Note that the source file is still full of the obsolete "khubd" strings.
Let's remove them in a follow up patch. This patch already is complex enough.

Thanks a lot Alan Stern <stern@rowland.harvard.edu> for code review, many useful
tips and guidance. Also thanks to Tejun Heo <tj@kernel.org> for hints how to
allocate the workqueue.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 drivers/usb/core/hub.c | 143 +++++++++++++++++++++----------------------------
 drivers/usb/core/hub.h |   2 +-
 2 files changed, 61 insertions(+), 84 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index f1efd5a493ba..193f58988535 100644
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
@@ -104,6 +98,7 @@ EXPORT_SYMBOL_GPL(ehci_cf_port_reset_rwsem);
 #define HUB_DEBOUNCE_STEP	  25
 #define HUB_DEBOUNCE_STABLE	 100
 
+static void hub_release(struct kref *kref);
 static int usb_reset_and_verify_device(struct usb_device *udev);
 
 static inline char *portspeed(struct usb_hub *hub, int portstatus)
@@ -575,20 +570,31 @@ static int hub_port_status(struct usb_hub *hub, int port1,
 	return ret;
 }
 
-static void kick_khubd(struct usb_hub *hub)
+static void kick_hub_wq(struct usb_hub *hub)
 {
-	unsigned long	flags;
+	struct usb_interface *intf;
 
-	spin_lock_irqsave(&hub_event_lock, flags);
-	if (!hub->disconnected && list_empty(&hub->event_list)) {
-		list_add_tail(&hub->event_list, &hub_event_list);
+	if (hub->disconnected || work_pending(&hub->events))
+		return;
 
-		/* Suppress autosuspend until khubd runs */
-		usb_autopm_get_interface_no_resume(
-				to_usb_interface(hub->intfdev));
-		wake_up(&khubd_wait);
-	}
-	spin_unlock_irqrestore(&hub_event_lock, flags);
+	/*
+	 * Suppress autosuspend until the event is proceed.
+	 *
+	 * Be careful and make sure that the symmetric operation is
+	 * always called. We are here only when there is no pending
+	 * work for this hub. Therefore put the interface either when
+	 * the new work is called or when it is canceled.
+	 */
+	intf = to_usb_interface(hub->intfdev);
+	usb_autopm_get_interface_no_resume(intf);
+	kref_get(&hub->kref);
+
+	if (queue_work(hub_wq, &hub->events))
+		return;
+
+	/* the work has already been scheduled */
+	usb_autopm_put_interface_async(intf);
+	kref_put(&hub->kref, hub_release);
 }
 
 void usb_kick_khubd(struct usb_device *hdev)
@@ -596,7 +602,7 @@ void usb_kick_khubd(struct usb_device *hdev)
 	struct usb_hub *hub = usb_hub_to_struct_hub(hdev);
 
 	if (hub)
-		kick_khubd(hub);
+		kick_hub_wq(hub);
 }
 
 /*
@@ -618,7 +624,7 @@ void usb_wakeup_notification(struct usb_device *hdev,
 	hub = usb_hub_to_struct_hub(hdev);
 	if (hub) {
 		set_bit(portnum, hub->wakeup_bits);
-		kick_khubd(hub);
+		kick_hub_wq(hub);
 	}
 }
 EXPORT_SYMBOL_GPL(usb_wakeup_notification);
@@ -658,7 +664,7 @@ static void hub_irq(struct urb *urb)
 	hub->nerrors = 0;
 
 	/* Something happened, let khubd figure it out */
-	kick_khubd(hub);
+	kick_hub_wq(hub);
 
 resubmit:
 	if (hub->quiescing)
@@ -972,7 +978,7 @@ static void hub_port_logical_disconnect(struct usb_hub *hub, int port1)
 	 */
 
 	set_bit(port1, hub->change_bits);
-	kick_khubd(hub);
+	kick_hub_wq(hub);
 }
 
 /**
@@ -1240,7 +1246,7 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 				&hub->leds, LED_CYCLE_PERIOD);
 
 	/* Scan all ports that need attention */
-	kick_khubd(hub);
+	kick_hub_wq(hub);
 
 	/* Allow autosuspend if it was suppressed */
 	if (type <= HUB_INIT3)
@@ -1647,14 +1653,11 @@ static void hub_disconnect(struct usb_interface *intf)
 	struct usb_device *hdev = interface_to_usbdev(intf);
 	int port1;
 
-	/* Take the hub off the event list and don't let it be added again */
-	spin_lock_irq(&hub_event_lock);
-	if (!list_empty(&hub->event_list)) {
-		list_del_init(&hub->event_list);
-		usb_autopm_put_interface_no_suspend(intf);
-	}
+	/*
+	 * Stop adding new hub events. We do not want to block here and thus
+	 * will not try to remove any pending work item.
+	 */
 	hub->disconnected = 1;
-	spin_unlock_irq(&hub_event_lock);
 
 	/* Disconnect all children and quiesce the hub */
 	hub->error = 0;
@@ -1794,11 +1797,11 @@ descriptor_error:
 	}
 
 	kref_init(&hub->kref);
-	INIT_LIST_HEAD(&hub->event_list);
 	hub->intfdev = &intf->dev;
 	hub->hdev = hdev;
 	INIT_DELAYED_WORK(&hub->leds, led_work);
 	INIT_DELAYED_WORK(&hub->init_work, NULL);
+	INIT_WORK(&hub->events, hub_event);
 	usb_get_intf(intf);
 	usb_get_dev(hdev);
 
@@ -4994,9 +4997,8 @@ static void port_event(struct usb_hub *hub, int port1)
 		hub_port_connect_change(hub, port1, portstatus, portchange);
 }
 
-static void hub_event(void)
+static void hub_event(struct work_struct *work)
 {
-	struct list_head *tmp;
 	struct usb_device *hdev;
 	struct usb_interface *intf;
 	struct usb_hub *hub;
@@ -5005,23 +5007,11 @@ static void hub_event(void)
 	u16 hubchange;
 	int i, ret;
 
-	/* Grab the first entry at the beginning of the list */
-	spin_lock_irq(&hub_event_lock);
-	if (list_empty(&hub_event_list)) {
-		spin_unlock_irq(&hub_event_lock);
-		return;
-	}
-
-	tmp = hub_event_list.next;
-	list_del_init(tmp);
-
-	hub = list_entry(tmp, struct usb_hub, event_list);
-	kref_get(&hub->kref);
-	spin_unlock_irq(&hub_event_lock);
-
+	hub = container_of(work, struct usb_hub, events);
 	hdev = hub->hdev;
 	hub_dev = hub->intfdev;
 	intf = to_usb_interface(hub_dev);
+
 	dev_dbg(hub_dev, "state %d ports %d chg %04x evt %04x\n",
 			hdev->state, hdev->maxchild,
 			/* NOTE: expects max 15 ports... */
@@ -5032,20 +5022,20 @@ static void hub_event(void)
 	 * disconnected while waiting for the lock to succeed. */
 	usb_lock_device(hdev);
 	if (unlikely(hub->disconnected))
-		goto out_disconnected;
+		goto out_hdev_lock;
 
 	/* If the hub has died, clean up after it */
 	if (hdev->state == USB_STATE_NOTATTACHED) {
 		hub->error = -ENODEV;
 		hub_quiesce(hub, HUB_DISCONNECT);
-		goto out;
+		goto out_hdev_lock;
 	}
 
 	/* Autoresume */
 	ret = usb_autopm_get_interface(intf);
 	if (ret) {
 		dev_dbg(hub_dev, "Can't autoresume: %d\n", ret);
-		goto out;
+		goto out_hdev_lock;
 	}
 
 	/* If this is an inactive hub, do nothing */
@@ -5122,34 +5112,12 @@ static void hub_event(void)
 out_autopm:
 	/* Balance the usb_autopm_get_interface() above */
 	usb_autopm_put_interface_no_suspend(intf);
-out:
-	/* Balance the usb_autopm_get_interface_no_resume() in
-	 * kick_khubd() and allow autosuspend.
-	 */
-	usb_autopm_put_interface(intf);
-out_disconnected:
+out_hdev_lock:
 	usb_unlock_device(hdev);
-	kref_put(&hub->kref, hub_release);
-}
 
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
-		hub_event();
-		wait_event_freezable(khubd_wait,
-				!list_empty(&hub_event_list) ||
-				kthread_should_stop());
-	} while (!kthread_should_stop() || !list_empty(&hub_event_list));
-
-	pr_debug("%s: khubd exiting\n", usbcore_name);
-	return 0;
+	/* Balance the stuff in kick_hub_wq() and allow autosuspend */
+	usb_autopm_put_interface(intf);
+	kref_put(&hub->kref, hub_release);
 }
 
 static const struct usb_device_id hub_id_table[] = {
@@ -5189,20 +5157,29 @@ int usb_hub_init(void)
 		return -1;
 	}
 
-	khubd_task = kthread_run(hub_thread, NULL, "khubd");
-	if (!IS_ERR(khubd_task))
+	/*
+	 * The workqueue needs to be freezable to avoid interfering with
+	 * USB-PERSIST port handover. Otherwise it might see that a full-speed
+	 * device was gone before the EHCI controller had handed its port
+	 * over to the companion full-speed controller.
+	 *
+	 * Also we use ordered workqueue because the code is not ready
+	 * for parallel execution of hub events, see choose_devnum().
+	 */
+	hub_wq = alloc_ordered_workqueue("usb_hub_wq", WQ_FREEZABLE);
+	if (hub_wq)
 		return 0;
 
 	/* Fall through if kernel_thread failed */
 	usb_deregister(&hub_driver);
-	printk(KERN_ERR "%s: can't start khubd\n", usbcore_name);
+	pr_err("%s: can't allocate workqueue for usb hub\n", usbcore_name);
 
 	return -1;
 }
 
 void usb_hub_cleanup(void)
 {
-	kthread_stop(khubd_task);
+	destroy_workqueue(hub_wq);
 
 	/*
 	 * Hub resources are freed for us by usb_deregister. It calls
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

