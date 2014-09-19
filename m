Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbaISPeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:34:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756767AbaISPel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:34:41 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Joe Lawrence <joe.lawrence@stratus.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v3 6/6] usb: hub: allow to process more usb hub events in parallel
Date: Fri, 19 Sep 2014 17:32:24 +0200
Message-Id: <1411140744-21424-7-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1411140744-21424-1-git-send-email-pmladek@suse.cz>
References: <1411140744-21424-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that only choose_devnum() was not ready to process more hub
events at the same time.

All should be fine if we take bus->usb_address0_mutex there. It will
make sure that more devnums will not be chosen for the given bus and
the related devices at the same time.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 drivers/usb/core/hub.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 6c1a79a50576..69f9f1c1d9c1 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2042,7 +2042,8 @@ static void choose_devnum(struct usb_device *udev)
 	int		devnum;
 	struct usb_bus	*bus = udev->bus;
 
-	/* If hub_wq ever becomes multithreaded, this will need a lock */
+	/* be safe when more hub events are proceed in parallel */
+	mutex_lock(&bus->usb_address0_mutex);
 	if (udev->wusb) {
 		devnum = udev->portnum + 1;
 		BUG_ON(test_bit(devnum, bus->devmap.devicemap));
@@ -2060,6 +2061,7 @@ static void choose_devnum(struct usb_device *udev)
 		set_bit(devnum, bus->devmap.devicemap);
 		udev->devnum = devnum;
 	}
+	mutex_unlock(&bus->usb_address0_mutex);
 }
 
 static void release_devnum(struct usb_device *udev)
@@ -5162,11 +5164,8 @@ int usb_hub_init(void)
 	 * USB-PERSIST port handover. Otherwise it might see that a full-speed
 	 * device was gone before the EHCI controller had handed its port
 	 * over to the companion full-speed controller.
-	 *
-	 * Also we use ordered workqueue because the code is not ready
-	 * for parallel execution of hub events, see choose_devnum().
 	 */
-	hub_wq = alloc_ordered_workqueue("usb_hub_wq", WQ_FREEZABLE);
+	hub_wq = alloc_workqueue("usb_hub_wq", WQ_FREEZABLE, 0);
 	if (hub_wq)
 		return 0;
 
-- 
1.8.4

