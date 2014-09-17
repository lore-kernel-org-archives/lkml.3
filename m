Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbaIQPUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:20:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773AbaIQPUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:20:17 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Joe Lawrence <joe.lawrence@stratus.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v2 2/4] usb: hub: remove obsolete while cycle in hub_event()
Date: Wed, 17 Sep 2014 17:19:08 +0200
Message-Id: <1410967150-25240-3-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1410967150-25240-1-git-send-email-pmladek@suse.cz>
References: <1410967150-25240-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB hub events are proceed by workqueue instead of kthread now.
The result is that hub_event() function processes only one event.
The block from the while cycle was not removed earlier to show the real
 changes when switching to the workqueue.

When touching the code, it fixes also formatting of dev_err() and dev_dbg()
calls to make checkpatch.pl happy :-)

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 drivers/usb/core/hub.c | 199 ++++++++++++++++++++++++-------------------------
 1 file changed, 96 insertions(+), 103 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index b67f454c1edb..b6b526a2e20d 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4997,7 +4997,6 @@ static void port_event(struct usb_hub *hub, int port1)
 		hub_port_connect_change(hub, port1, portstatus, portchange);
 }
 
-
 static void hub_event(struct work_struct *work)
 {
 	struct usb_device *hdev;
@@ -5008,122 +5007,116 @@ static void hub_event(struct work_struct *work)
 	u16 hubchange;
 	int i, ret;
 
-	/* temporary keep the block to show real changes in this commit */
-	{
-		hub = container_of(work, struct usb_hub, events);
-		hdev = hub->hdev;
-		hub_dev = hub->intfdev;
-		intf = to_usb_interface(hub_dev);
-
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
-			goto out_hdev_lock;
-
-		/* If the hub has died, clean up after it */
-		if (hdev->state == USB_STATE_NOTATTACHED) {
-			hub->error = -ENODEV;
-			hub_quiesce(hub, HUB_DISCONNECT);
-			goto out_hdev_lock;
-		}
+	hub = container_of(work, struct usb_hub, events);
+	hdev = hub->hdev;
+	hub_dev = hub->intfdev;
+	intf = to_usb_interface(hub_dev);
+
+	dev_dbg(hub_dev, "state %d ports %d chg %04x evt %04x\n",
+		hdev->state, hdev->maxchild,
+		/* NOTE: expects max 15 ports... */
+		(u16) hub->change_bits[0],
+		(u16) hub->event_bits[0]);
+
+	/* Lock the device, then check to see if we were
+	 * disconnected while waiting for the lock to succeed. */
+	usb_lock_device(hdev);
+	if (unlikely(hub->disconnected))
+		goto out_hdev_lock;
+
+	/* If the hub has died, clean up after it */
+	if (hdev->state == USB_STATE_NOTATTACHED) {
+		hub->error = -ENODEV;
+		hub_quiesce(hub, HUB_DISCONNECT);
+		goto out_hdev_lock;
+	}
+
+	/* Autoresume */
+	ret = usb_autopm_get_interface(intf);
+	if (ret) {
+		dev_dbg(hub_dev, "Can't autoresume: %d\n", ret);
+		goto out_hdev_lock;
+	}
 
-		/* Autoresume */
-		ret = usb_autopm_get_interface(intf);
-		if (ret) {
-			dev_dbg(hub_dev, "Can't autoresume: %d\n", ret);
-			goto out_hdev_lock;
-		}
+	/* If this is an inactive hub, do nothing */
+	if (hub->quiescing)
+		goto out_autopm;
+
+	if (hub->error) {
+		dev_dbg(hub_dev, "resetting for error %d\n", hub->error);
 
-		/* If this is an inactive hub, do nothing */
-		if (hub->quiescing)
+		ret = usb_reset_device(hdev);
+		if (ret) {
+			dev_dbg(hub_dev, "error resetting hub: %d\n", ret);
 			goto out_autopm;
+		}
 
-		if (hub->error) {
-			dev_dbg (hub_dev, "resetting for error %d\n",
-				hub->error);
+		hub->nerrors = 0;
+		hub->error = 0;
+	}
 
-			ret = usb_reset_device(hdev);
-			if (ret) {
-				dev_dbg (hub_dev,
-					"error resetting hub: %d\n", ret);
-				goto out_autopm;
-			}
+	/* deal with port status changes */
+	for (i = 1; i <= hdev->maxchild; i++) {
+		struct usb_port *port_dev = hub->ports[i - 1];
 
-			hub->nerrors = 0;
-			hub->error = 0;
+		if (test_bit(i, hub->event_bits)
+		    || test_bit(i, hub->change_bits)
+		    || test_bit(i, hub->wakeup_bits)) {
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
 
  out_autopm:
-		/* Balance the usb_autopm_get_interface() above */
-		usb_autopm_put_interface_no_suspend(intf);
+	/* Balance the usb_autopm_get_interface() above */
+	usb_autopm_put_interface_no_suspend(intf);
  out_hdev_lock:
-		usb_unlock_device(hdev);
-		/* Ballance the stuff in kick_hub_wq() and allow autosuspend */
-		usb_autopm_put_interface(intf);
-		kref_put(&hub->kref, hub_release);
-	}
+	usb_unlock_device(hdev);
+	/* Ballance the stuff in kick_hub_wq() and allow autosuspend */
+	usb_autopm_put_interface(intf);
+	kref_put(&hub->kref, hub_release);
 }
 
 static const struct usb_device_id hub_id_table[] = {
-- 
1.8.4

