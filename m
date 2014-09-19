Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbaISPdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:33:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756002AbaISPdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:33:19 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Joe Lawrence <joe.lawrence@stratus.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v3 2/6] usb: hub: rename hub_events() to hub_event() and handle only one event there
Date: Fri, 19 Sep 2014 17:32:20 +0200
Message-Id: <1411140744-21424-3-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1411140744-21424-1-git-send-email-pmladek@suse.cz>
References: <1411140744-21424-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We would like to convert khubd kthread to a workqueue. As a result hub_events()
will handle only one event per call.

In fact, we could do this already now because there is another cycle in
hub_thread(). It calls hub_events() until hub_event_list is empty.

This patch renames the function to hub_event(), removes the while cycle, and
renames the goto targets from loop* to out*.

When touching the code, it fixes also formatting of dev_err() and dev_dbg()
calls to make checkpatch.pl happy :-)

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 drivers/usb/core/hub.c | 236 +++++++++++++++++++++++--------------------------
 1 file changed, 111 insertions(+), 125 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 8f35e5158daf..f1efd5a493ba 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4994,8 +4994,7 @@ static void port_event(struct usb_hub *hub, int port1)
 		hub_port_connect_change(hub, port1, portstatus, portchange);
 }
 
-
-static void hub_events(void)
+static void hub_event(void)
 {
 	struct list_head *tmp;
 	struct usb_device *hdev;
@@ -5006,144 +5005,131 @@ static void hub_events(void)
 	u16 hubchange;
 	int i, ret;
 
-	/*
-	 *  We restart the list every time to avoid a deadlock with
-	 * deleting hubs downstream from this one. This should be
-	 * safe since we delete the hub from the event list.
-	 * Not the most efficient, but avoids deadlocks.
-	 */
-	while (1) {
+	/* Grab the first entry at the beginning of the list */
+	spin_lock_irq(&hub_event_lock);
+	if (list_empty(&hub_event_list)) {
+		spin_unlock_irq(&hub_event_lock);
+		return;
+	}
 
-		/* Grab the first entry at the beginning of the list */
-		spin_lock_irq(&hub_event_lock);
-		if (list_empty(&hub_event_list)) {
-			spin_unlock_irq(&hub_event_lock);
-			break;
-		}
+	tmp = hub_event_list.next;
+	list_del_init(tmp);
 
-		tmp = hub_event_list.next;
-		list_del_init(tmp);
+	hub = list_entry(tmp, struct usb_hub, event_list);
+	kref_get(&hub->kref);
+	spin_unlock_irq(&hub_event_lock);
 
-		hub = list_entry(tmp, struct usb_hub, event_list);
-		kref_get(&hub->kref);
-		spin_unlock_irq(&hub_event_lock);
+	hdev = hub->hdev;
+	hub_dev = hub->intfdev;
+	intf = to_usb_interface(hub_dev);
+	dev_dbg(hub_dev, "state %d ports %d chg %04x evt %04x\n",
+			hdev->state, hdev->maxchild,
+			/* NOTE: expects max 15 ports... */
+			(u16) hub->change_bits[0],
+			(u16) hub->event_bits[0]);
+
+	/* Lock the device, then check to see if we were
+	 * disconnected while waiting for the lock to succeed. */
+	usb_lock_device(hdev);
+	if (unlikely(hub->disconnected))
+		goto out_disconnected;
+
+	/* If the hub has died, clean up after it */
+	if (hdev->state == USB_STATE_NOTATTACHED) {
+		hub->error = -ENODEV;
+		hub_quiesce(hub, HUB_DISCONNECT);
+		goto out;
+	}
+
+	/* Autoresume */
+	ret = usb_autopm_get_interface(intf);
+	if (ret) {
+		dev_dbg(hub_dev, "Can't autoresume: %d\n", ret);
+		goto out;
+	}
 
-		hdev = hub->hdev;
-		hub_dev = hub->intfdev;
-		intf = to_usb_interface(hub_dev);
-		dev_dbg(hub_dev, "state %d ports %d chg %04x evt %04x\n",
-				hdev->state, hdev->maxchild,
-				/* NOTE: expects max 15 ports... */
-				(u16) hub->change_bits[0],
-				(u16) hub->event_bits[0]);
-
-		/* Lock the device, then check to see if we were
-		 * disconnected while waiting for the lock to succeed. */
-		usb_lock_device(hdev);
-		if (unlikely(hub->disconnected))
-			goto loop_disconnected;
-
-		/* If the hub has died, clean up after it */
-		if (hdev->state == USB_STATE_NOTATTACHED) {
-			hub->error = -ENODEV;
-			hub_quiesce(hub, HUB_DISCONNECT);
-			goto loop;
-		}
+	/* If this is an inactive hub, do nothing */
+	if (hub->quiescing)
+		goto out_autopm;
+
+	if (hub->error) {
+		dev_dbg(hub_dev, "resetting for error %d\n", hub->error);
 
-		/* Autoresume */
-		ret = usb_autopm_get_interface(intf);
+		ret = usb_reset_device(hdev);
 		if (ret) {
-			dev_dbg(hub_dev, "Can't autoresume: %d\n", ret);
-			goto loop;
+			dev_dbg(hub_dev, "error resetting hub: %d\n", ret);
+			goto out_autopm;
 		}
 
-		/* If this is an inactive hub, do nothing */
-		if (hub->quiescing)
-			goto loop_autopm;
+		hub->nerrors = 0;
+		hub->error = 0;
+	}
 
-		if (hub->error) {
-			dev_dbg (hub_dev, "resetting for error %d\n",
-				hub->error);
+	/* deal with port status changes */
+	for (i = 1; i <= hdev->maxchild; i++) {
+		struct usb_port *port_dev = hub->ports[i - 1];
 
-			ret = usb_reset_device(hdev);
-			if (ret) {
-				dev_dbg (hub_dev,
-					"error resetting hub: %d\n", ret);
-				goto loop_autopm;
-			}
-
-			hub->nerrors = 0;
-			hub->error = 0;
+		if (test_bit(i, hub->event_bits)
+				|| test_bit(i, hub->change_bits)
+				|| test_bit(i, hub->wakeup_bits)) {
+			/*
+			 * The get_noresume and barrier ensure that if
+			 * the port was in the process of resuming, we
+			 * flush that work and keep the port active for
+			 * the duration of the port_event().  However,
+			 * if the port is runtime pm suspended
+			 * (powered-off), we leave it in that state, run
+			 * an abbreviated port_event(), and move on.
+			 */
+			pm_runtime_get_noresume(&port_dev->dev);
+			pm_runtime_barrier(&port_dev->dev);
+			usb_lock_port(port_dev);
+			port_event(hub, i);
+			usb_unlock_port(port_dev);
+			pm_runtime_put_sync(&port_dev->dev);
 		}
+	}
 
-		/* deal with port status changes */
-		for (i = 1; i <= hdev->maxchild; i++) {
-			struct usb_port *port_dev = hub->ports[i - 1];
-
-			if (test_bit(i, hub->event_bits)
-					|| test_bit(i, hub->change_bits)
-					|| test_bit(i, hub->wakeup_bits)) {
-				/*
-				 * The get_noresume and barrier ensure that if
-				 * the port was in the process of resuming, we
-				 * flush that work and keep the port active for
-				 * the duration of the port_event().  However,
-				 * if the port is runtime pm suspended
-				 * (powered-off), we leave it in that state, run
-				 * an abbreviated port_event(), and move on.
-				 */
-				pm_runtime_get_noresume(&port_dev->dev);
-				pm_runtime_barrier(&port_dev->dev);
-				usb_lock_port(port_dev);
-				port_event(hub, i);
-				usb_unlock_port(port_dev);
-				pm_runtime_put_sync(&port_dev->dev);
-			}
+	/* deal with hub status changes */
+	if (test_and_clear_bit(0, hub->event_bits) == 0)
+		;	/* do nothing */
+	else if (hub_hub_status(hub, &hubstatus, &hubchange) < 0)
+		dev_err(hub_dev, "get_hub_status failed\n");
+	else {
+		if (hubchange & HUB_CHANGE_LOCAL_POWER) {
+			dev_dbg(hub_dev, "power change\n");
+			clear_hub_feature(hdev, C_HUB_LOCAL_POWER);
+			if (hubstatus & HUB_STATUS_LOCAL_POWER)
+				/* FIXME: Is this always true? */
+				hub->limited_power = 1;
+			else
+				hub->limited_power = 0;
 		}
+		if (hubchange & HUB_CHANGE_OVERCURRENT) {
+			u16 status = 0;
+			u16 unused;
 
-		/* deal with hub status changes */
-		if (test_and_clear_bit(0, hub->event_bits) == 0)
-			;	/* do nothing */
-		else if (hub_hub_status(hub, &hubstatus, &hubchange) < 0)
-			dev_err (hub_dev, "get_hub_status failed\n");
-		else {
-			if (hubchange & HUB_CHANGE_LOCAL_POWER) {
-				dev_dbg (hub_dev, "power change\n");
-				clear_hub_feature(hdev, C_HUB_LOCAL_POWER);
-				if (hubstatus & HUB_STATUS_LOCAL_POWER)
-					/* FIXME: Is this always true? */
-					hub->limited_power = 1;
-				else
-					hub->limited_power = 0;
-			}
-			if (hubchange & HUB_CHANGE_OVERCURRENT) {
-				u16 status = 0;
-				u16 unused;
-
-				dev_dbg(hub_dev, "over-current change\n");
-				clear_hub_feature(hdev, C_HUB_OVER_CURRENT);
-				msleep(500);	/* Cool down */
-				hub_power_on(hub, true);
-				hub_hub_status(hub, &status, &unused);
-				if (status & HUB_STATUS_OVERCURRENT)
-					dev_err(hub_dev, "over-current "
-						"condition\n");
-			}
+			dev_dbg(hub_dev, "over-current change\n");
+			clear_hub_feature(hdev, C_HUB_OVER_CURRENT);
+			msleep(500);	/* Cool down */
+			hub_power_on(hub, true);
+			hub_hub_status(hub, &status, &unused);
+			if (status & HUB_STATUS_OVERCURRENT)
+				dev_err(hub_dev, "over-current condition\n");
 		}
+	}
 
- loop_autopm:
-		/* Balance the usb_autopm_get_interface() above */
-		usb_autopm_put_interface_no_suspend(intf);
- loop:
-		/* Balance the usb_autopm_get_interface_no_resume() in
-		 * kick_khubd() and allow autosuspend.
-		 */
-		usb_autopm_put_interface(intf);
- loop_disconnected:
-		usb_unlock_device(hdev);
-		kref_put(&hub->kref, hub_release);
-
-	} /* end while (1) */
+out_autopm:
+	/* Balance the usb_autopm_get_interface() above */
+	usb_autopm_put_interface_no_suspend(intf);
+out:
+	/* Balance the usb_autopm_get_interface_no_resume() in
+	 * kick_khubd() and allow autosuspend.
+	 */
+	usb_autopm_put_interface(intf);
+out_disconnected:
+	usb_unlock_device(hdev);
+	kref_put(&hub->kref, hub_release);
 }
 
 static int hub_thread(void *__unused)
@@ -5156,7 +5142,7 @@ static int hub_thread(void *__unused)
 	set_freezable();
 
 	do {
-		hub_events();
+		hub_event();
 		wait_event_freezable(khubd_wait,
 				!list_empty(&hub_event_list) ||
 				kthread_should_stop());
-- 
1.8.4

