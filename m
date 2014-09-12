Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbaILMWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:22:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbaILMWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:22:20 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Joe Lawrence <joe.lawrence@stratus.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 3/4] usb: hub: rename *kick_khubd to *kick_hub_wq
Date: Fri, 12 Sep 2014 14:21:07 +0200
Message-Id: <1410524468-15232-4-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1410524468-15232-1-git-send-email-pmladek@suse.cz>
References: <1410524468-15232-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB hub started to use a workqueue instead of kthread. Let's make it clear from
the function names.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 drivers/usb/core/hcd.c |  4 ++--
 drivers/usb/core/hub.c | 16 ++++++++--------
 drivers/usb/core/usb.h |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 487abcfcccd8..4bec044a786c 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2386,7 +2386,7 @@ void usb_hc_died (struct usb_hcd *hcd)
 		/* make khubd clean up old urbs and devices */
 		usb_set_device_state (hcd->self.root_hub,
 				USB_STATE_NOTATTACHED);
-		usb_kick_khubd (hcd->self.root_hub);
+		usb_kick_hub_wq(hcd->self.root_hub);
 	}
 	if (usb_hcd_is_primary_hcd(hcd) && hcd->shared_hcd) {
 		hcd = hcd->shared_hcd;
@@ -2396,7 +2396,7 @@ void usb_hc_died (struct usb_hcd *hcd)
 			/* make khubd clean up old urbs and devices */
 			usb_set_device_state(hcd->self.root_hub,
 					USB_STATE_NOTATTACHED);
-			usb_kick_khubd(hcd->self.root_hub);
+			usb_kick_hub_wq(hcd->self.root_hub);
 		}
 	}
 	spin_unlock_irqrestore (&hcd_root_hub_lock, flags);
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index b31eec65caf7..e5883c8e77c7 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -569,7 +569,7 @@ static int hub_port_status(struct usb_hub *hub, int port1,
 	return ret;
 }
 
-static void kick_khubd(struct usb_hub *hub)
+static void kick_hub_wq(struct usb_hub *hub)
 {
 	if (!hub->disconnected && !work_pending(&hub->events)) {
 		/*
@@ -587,12 +587,12 @@ static void kick_khubd(struct usb_hub *hub)
 	}
 }
 
-void usb_kick_khubd(struct usb_device *hdev)
+void usb_kick_hub_wq(struct usb_device *hdev)
 {
 	struct usb_hub *hub = usb_hub_to_struct_hub(hdev);
 
 	if (hub)
-		kick_khubd(hub);
+		kick_hub_wq(hub);
 }
 
 /*
@@ -614,7 +614,7 @@ void usb_wakeup_notification(struct usb_device *hdev,
 	hub = usb_hub_to_struct_hub(hdev);
 	if (hub) {
 		set_bit(portnum, hub->wakeup_bits);
-		kick_khubd(hub);
+		kick_hub_wq(hub);
 	}
 }
 EXPORT_SYMBOL_GPL(usb_wakeup_notification);
@@ -654,7 +654,7 @@ static void hub_irq(struct urb *urb)
 	hub->nerrors = 0;
 
 	/* Something happened, let khubd figure it out */
-	kick_khubd(hub);
+	kick_hub_wq(hub);
 
 resubmit:
 	if (hub->quiescing)
@@ -968,7 +968,7 @@ static void hub_port_logical_disconnect(struct usb_hub *hub, int port1)
 	 */
 
 	set_bit(port1, hub->change_bits);
-	kick_khubd(hub);
+	kick_hub_wq(hub);
 }
 
 /**
@@ -1236,7 +1236,7 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 				&hub->leds, LED_CYCLE_PERIOD);
 
 	/* Scan all ports that need attention */
-	kick_khubd(hub);
+	kick_hub_wq(hub);
 
 	/* Allow autosuspend if it was suppressed */
 	if (type <= HUB_INIT3)
@@ -5103,7 +5103,7 @@ static void hub_event(struct work_struct *work)
 		usb_autopm_put_interface(intf);
  out:
 		/* Balance the usb_autopm_get_interface_no_resume() in
-		 * kick_khubd() and allow autosuspend.
+		 * kick_hub_wq() and allow autosuspend.
 		 *
 		 * It has to be done even when the hub was disconnected
 		 * when waiting for hdev lock. This function is called
diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index d9d08720c386..b1b34d0557c9 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -48,7 +48,7 @@ static inline unsigned usb_get_max_power(struct usb_device *udev,
 	return c->desc.bMaxPower * mul;
 }
 
-extern void usb_kick_khubd(struct usb_device *dev);
+extern void usb_kick_hub_wq(struct usb_device *dev);
 extern int usb_match_one_id_intf(struct usb_device *dev,
 				 struct usb_host_interface *intf,
 				 const struct usb_device_id *id);
-- 
1.8.4

