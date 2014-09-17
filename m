Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbaIQPUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:20:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbaIQPUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:20:37 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Joe Lawrence <joe.lawrence@stratus.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v2 3/4] usb: hub: rename usb_kick_khubd() to usb_kick_hub_wq()
Date: Wed, 17 Sep 2014 17:19:09 +0200
Message-Id: <1410967150-25240-4-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1410967150-25240-1-git-send-email-pmladek@suse.cz>
References: <1410967150-25240-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB hub started to use a workqueue instead of kthread. Let's make it clear from
the function names.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 drivers/usb/core/hcd.c | 4 ++--
 drivers/usb/core/hub.c | 2 +-
 drivers/usb/core/usb.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

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
index b6b526a2e20d..8d86350cb0a2 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -597,7 +597,7 @@ static void kick_hub_wq(struct usb_hub *hub)
 	kref_put(&hub->kref, hub_release);
 }
 
-void usb_kick_khubd(struct usb_device *hdev)
+void usb_kick_hub_wq(struct usb_device *hdev)
 {
 	struct usb_hub *hub = usb_hub_to_struct_hub(hdev);
 
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

