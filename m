Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaILMWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:22:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbaILMWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:22:00 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Joe Lawrence <joe.lawrence@stratus.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 2/4] usb: hub: remove obsolete while cycle in hub_event()
Date: Fri, 12 Sep 2014 14:21:06 +0200
Message-Id: <1410524468-15232-3-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1410524468-15232-1-git-send-email-pmladek@suse.cz>
References: <1410524468-15232-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB hub events are proceed by workqueue instead of kthread now.
The result is that hub_event() function processes only one event.
The while cycle was not removed earlier to show the real changes when
switching to the workqueue.

This patch also consolidates the goto targets and rename them from "loop*"
to "out*".

When touching the code, it fixes also formatting of dev_err() and dev_dbg()
calls to make checkpatch.pl happy :-)

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 drivers/usb/core/hub.c | 199 +++++++++++++++++++++++--------------------------
 1 file changed, 95 insertions(+), 104 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 1825af63c686..b31eec65caf7 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4994,121 +4994,114 @@ static void hub_event(struct work_struct *work)
 	u16 hubchange;
 	int i, ret;
 
-	/* temporary keep the cycle to show real changes in this commit */
-	while (1) {
-		hub = container_of(work, struct usb_hub, events);
-		kref_get(&hub->kref);
-
-		hdev = hub->hdev;
-		usb_get_dev(hdev);
-
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
+	hub = container_of(work, struct usb_hub, events);
+	kref_get(&hub->kref);
 
-		/* Autoresume */
-		ret = usb_autopm_get_interface(intf);
-		if (ret) {
-			dev_dbg(hub_dev, "Can't autoresume: %d\n", ret);
-			goto loop;
-		}
-
-		/* If this is an inactive hub, do nothing */
-		if (hub->quiescing)
-			goto loop_autopm;
+	hdev = hub->hdev;
+	usb_get_dev(hdev);
+
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
+		goto out;
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
 
-		if (hub->error) {
-			dev_dbg (hub_dev, "resetting for error %d\n",
-				hub->error);
+	/* If this is an inactive hub, do nothing */
+	if (hub->quiescing)
+		goto out_autopm;
 
-			ret = usb_reset_device(hdev);
-			if (ret) {
-				dev_dbg (hub_dev,
-					"error resetting hub: %d\n", ret);
-				goto loop_autopm;
-			}
+	if (hub->error) {
+		dev_dbg(hub_dev, "resetting for error %d\n", hub->error);
 
-			hub->nerrors = 0;
-			hub->error = 0;
+		ret = usb_reset_device(hdev);
+		if (ret) {
+			dev_dbg(hub_dev, "error resetting hub: %d\n", ret);
+			goto out_autopm;
 		}
 
-		/* deal with port status changes */
-		for (i = 1; i <= hdev->maxchild; i++) {
-			struct usb_port *port_dev = hub->ports[i - 1];
+		hub->nerrors = 0;
+		hub->error = 0;
+	}
 
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
+	/* deal with port status changes */
+	for (i = 1; i <= hdev->maxchild; i++) {
+		struct usb_port *port_dev = hub->ports[i - 1];
+
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
 
- loop_autopm:
+			dev_dbg(hub_dev, "over-current change\n");
+			clear_hub_feature(hdev, C_HUB_OVER_CURRENT);
+			msleep(500);	/* Cool down */
+			hub_power_on(hub, true);
+			hub_hub_status(hub, &status, &unused);
+			if (status & HUB_STATUS_OVERCURRENT)
+				dev_err(hub_dev, "over-current condition\n");
+		}
+	}
+ out_autopm:
 		/* Balance the usb_autopm_get_interface() above */
 		usb_autopm_put_interface(intf);
- loop:
- loop_disconnected:
+ out:
 		/* Balance the usb_autopm_get_interface_no_resume() in
 		 * kick_khubd() and allow autosuspend.
 		 *
@@ -5121,8 +5114,6 @@ static void hub_event(struct work_struct *work)
 		usb_unlock_device(hdev);
 		usb_put_dev(hdev);
 		kref_put(&hub->kref, hub_release);
-		break;
-	}
 }
 
 static const struct usb_device_id hub_id_table[] = {
-- 
1.8.4

