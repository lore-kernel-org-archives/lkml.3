Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbaIQPT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:19:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712AbaIQPT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:19:56 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Joe Lawrence <joe.lawrence@stratus.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v2 1/4] usb: hub: convert khubd into workqueue
Date: Wed, 17 Sep 2014 17:19:07 +0200
Message-Id: <1410967150-25240-2-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1410967150-25240-1-git-send-email-pmladek@suse.cz>
References: <1410967150-25240-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to have separate kthread for handling USB hub events.
It is more elegant to use the workqueue framework.

The workqueue is allocated as freezable because the original thread was
freezable as well.

struct usb_hub is passed via the work item. Therefore we do not need
hub_event_list.

Also hub_thread() is not longer needed. It would call only hub_events().
The rest of the code did manipulate the kthread and it is handled by the
workqueue framework now.

Therefore the work item is proceed directly by hub_events(). Only one item
is manipulated in one call, so the function is renamed to hub_event().
The obsolete block from the while cycle will be removed in a followup patch.
It helps to see the real changes here.

kick_khubd is renamed to kick_hub_wq() to make the function clear. And the
protection against races is done another way, see below.

hub_event_lock has been removed. It cannot longer be used to protect struct
usb_hub between hub_event() and hub_disconnect(). Instead we need to get
hub->kref already in kick_hub_wq().

We would need to call also usb_get_dev() in kick_hub_wq(). But better
solution is to move this to hub_probe() where the struct hub is allocated.
As a result, usb_put_dev() is called in hub_release(). By other words,
it is handled the same way like usb_get_intf() and usb_put_intf().

But back to the lock. It is not really needed for the other scenarios as well.
queue_work() returns whether it succeeded. We could revert the needed operations
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

Thanks a lot Alan Stern <stern@rowland.harvard.edu> for very useful tips
and guidance.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 drivers/usb/core/hub.c | 163 +++++++++++++++++++------------------------------
 drivers/usb/core/hub.h |   2 +-
 2 files changed, 65 insertions(+), 100 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index d481c99a20d7..b67f454c1edb 100644
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
+	intf = to_usb_interface(hub->intfdev);
+	/*
+	 * Suppress autosuspend until the event is proceed.
+	 *
+	 * Be careful and make sure that the symmetric operation is
+	 * always called. We are here only when there is no pending
+	 * work for this hub. Therefore put the interface either when
+	 * the new work is called or when it is canceled.
+	 */
+	kref_get(&hub->kref);
+	usb_autopm_get_interface_no_resume(intf);
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
@@ -1634,6 +1640,7 @@ static void hub_release(struct kref *kref)
 {
 	struct usb_hub *hub = container_of(kref, struct usb_hub, kref);
 
+	usb_put_dev(hub->hdev);
 	usb_put_intf(to_usb_interface(hub->intfdev));
 	kfree(hub);
 }
@@ -1646,14 +1653,11 @@ static void hub_disconnect(struct usb_interface *intf)
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
@@ -1793,12 +1797,13 @@ descriptor_error:
 	}
 
 	kref_init(&hub->kref);
-	INIT_LIST_HEAD(&hub->event_list);
 	hub->intfdev = &intf->dev;
 	hub->hdev = hdev;
 	INIT_DELAYED_WORK(&hub->leds, led_work);
 	INIT_DELAYED_WORK(&hub->init_work, NULL);
+	INIT_WORK(&hub->events, hub_event);
 	usb_get_intf(intf);
+	usb_get_dev(hdev);
 
 	usb_set_intfdata (intf, hub);
 	intf->needs_remote_wakeup = 1;
@@ -4993,9 +4998,8 @@ static void port_event(struct usb_hub *hub, int port1)
 }
 
 
-static void hub_events(void)
+static void hub_event(struct work_struct *work)
 {
-	struct list_head *tmp;
 	struct usb_device *hdev;
 	struct usb_interface *intf;
 	struct usb_hub *hub;
@@ -5004,32 +5008,13 @@ static void hub_events(void)
 	u16 hubchange;
 	int i, ret;
 
-	/*
-	 *  We restart the list every time to avoid a deadlock with
-	 * deleting hubs downstream from this one. This should be
-	 * safe since we delete the hub from the event list.
-	 * Not the most efficient, but avoids deadlocks.
-	 */
-	while (1) {
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
-		kref_get(&hub->kref);
+	/* temporary keep the block to show real changes in this commit */
+	{
+		hub = container_of(work, struct usb_hub, events);
 		hdev = hub->hdev;
-		usb_get_dev(hdev);
-		spin_unlock_irq(&hub_event_lock);
-
 		hub_dev = hub->intfdev;
 		intf = to_usb_interface(hub_dev);
+
 		dev_dbg(hub_dev, "state %d ports %d chg %04x evt %04x\n",
 				hdev->state, hdev->maxchild,
 				/* NOTE: expects max 15 ports... */
@@ -5040,25 +5025,25 @@ static void hub_events(void)
 		 * disconnected while waiting for the lock to succeed. */
 		usb_lock_device(hdev);
 		if (unlikely(hub->disconnected))
-			goto loop_disconnected;
+			goto out_hdev_lock;
 
 		/* If the hub has died, clean up after it */
 		if (hdev->state == USB_STATE_NOTATTACHED) {
 			hub->error = -ENODEV;
 			hub_quiesce(hub, HUB_DISCONNECT);
-			goto loop;
+			goto out_hdev_lock;
 		}
 
 		/* Autoresume */
 		ret = usb_autopm_get_interface(intf);
 		if (ret) {
 			dev_dbg(hub_dev, "Can't autoresume: %d\n", ret);
-			goto loop;
+			goto out_hdev_lock;
 		}
 
 		/* If this is an inactive hub, do nothing */
 		if (hub->quiescing)
-			goto loop_autopm;
+			goto out_autopm;
 
 		if (hub->error) {
 			dev_dbg (hub_dev, "resetting for error %d\n",
@@ -5068,7 +5053,7 @@ static void hub_events(void)
 			if (ret) {
 				dev_dbg (hub_dev,
 					"error resetting hub: %d\n", ret);
-				goto loop_autopm;
+				goto out_autopm;
 			}
 
 			hub->nerrors = 0;
@@ -5130,40 +5115,15 @@ static void hub_events(void)
 			}
 		}
 
- loop_autopm:
+ out_autopm:
 		/* Balance the usb_autopm_get_interface() above */
 		usb_autopm_put_interface_no_suspend(intf);
- loop:
-		/* Balance the usb_autopm_get_interface_no_resume() in
-		 * kick_khubd() and allow autosuspend.
-		 */
-		usb_autopm_put_interface(intf);
- loop_disconnected:
+ out_hdev_lock:
 		usb_unlock_device(hdev);
-		usb_put_dev(hdev);
+		/* Ballance the stuff in kick_hub_wq() and allow autosuspend */
+		usb_autopm_put_interface(intf);
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
+	}
 }
 
 static const struct usb_device_id hub_id_table[] = {
@@ -5203,21 +5163,26 @@ int usb_hub_init(void)
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
+	hub_wq = alloc_workqueue("hub", WQ_FREEZABLE, 0);
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

