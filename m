Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbaISPdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:33:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756926AbaISPc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:32:59 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Joe Lawrence <joe.lawrence@stratus.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v3 1/6] usb: hub: keep hub->dev reference all the time when struct usb_hub lives
Date: Fri, 19 Sep 2014 17:32:19 +0200
Message-Id: <1411140744-21424-2-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1411140744-21424-1-git-send-email-pmladek@suse.cz>
References: <1411140744-21424-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a small optimization of the fix from the commit c605f3cdff53a743f6
("usb: hub: take hub->hdev reference when processing from eventlist).

We do not need to take the reference for each event. Instead we could get it
when struct usb_hub is allocated and put it when it is released. By other words,
we could handle it the same way as the reference for hub->intfdev.

The motivation is that it will make the life easier when switching from khubd
kthread to a workqueue.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 drivers/usb/core/hub.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index d481c99a20d7..8f35e5158daf 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1634,6 +1634,7 @@ static void hub_release(struct kref *kref)
 {
 	struct usb_hub *hub = container_of(kref, struct usb_hub, kref);
 
+	usb_put_dev(hub->hdev);
 	usb_put_intf(to_usb_interface(hub->intfdev));
 	kfree(hub);
 }
@@ -1799,6 +1800,7 @@ descriptor_error:
 	INIT_DELAYED_WORK(&hub->leds, led_work);
 	INIT_DELAYED_WORK(&hub->init_work, NULL);
 	usb_get_intf(intf);
+	usb_get_dev(hdev);
 
 	usb_set_intfdata (intf, hub);
 	intf->needs_remote_wakeup = 1;
@@ -5024,10 +5026,9 @@ static void hub_events(void)
 
 		hub = list_entry(tmp, struct usb_hub, event_list);
 		kref_get(&hub->kref);
-		hdev = hub->hdev;
-		usb_get_dev(hdev);
 		spin_unlock_irq(&hub_event_lock);
 
+		hdev = hub->hdev;
 		hub_dev = hub->intfdev;
 		intf = to_usb_interface(hub_dev);
 		dev_dbg(hub_dev, "state %d ports %d chg %04x evt %04x\n",
@@ -5140,7 +5141,6 @@ static void hub_events(void)
 		usb_autopm_put_interface(intf);
  loop_disconnected:
 		usb_unlock_device(hdev);
-		usb_put_dev(hdev);
 		kref_put(&hub->kref, hub_release);
 
 	} /* end while (1) */
-- 
1.8.4

