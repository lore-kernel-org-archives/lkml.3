Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab3HTRfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:35:54 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:35690 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab3HTRfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:35:52 -0400
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Krzysztof Mazur <krzysiek@podlesie.net>
Subject: [PATCH 1/2] usb: fix cleanup after failure in hub_configure()
Date: Tue, 20 Aug 2013 19:24:35 +0200
Message-Id: <1377019476-7701-2-git-send-email-krzysiek@podlesie.net>
X-Mailer: git-send-email 1.8.4.rc1.409.gbd48715
In-Reply-To: <1377019476-7701-1-git-send-email-krzysiek@podlesie.net>
References: <1377019476-7701-1-git-send-email-krzysiek@podlesie.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the hub_configure() fails after setting the hdev->maxchild
the hub->ports might be NULL or point to uninitialized kzallocated
memory causing NULL pointer dereference in hub_quiesce() during cleanup.

Now after such error the hdev->maxchild is set to 0 to avoid cleanup
of uninitialized ports.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
---
 drivers/usb/core/hub.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 558313d..588c3a3 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1339,7 +1339,7 @@ static int hub_configure(struct usb_hub *hub,
 			     GFP_KERNEL);
 	if (!hub->ports) {
 		ret = -ENOMEM;
-		goto fail;
+		goto fail_maxchild;
 	}
 
 	wHubCharacteristics = le16_to_cpu(hub->descriptor->wHubCharacteristics);
@@ -1466,7 +1466,7 @@ static int hub_configure(struct usb_hub *hub,
 	ret = usb_get_status(hdev, USB_RECIP_DEVICE, 0, &hubstatus);
 	if (ret < 2) {
 		message = "can't get hub status";
-		goto fail;
+		goto fail_maxchild;
 	}
 	le16_to_cpus(&hubstatus);
 	hcd = bus_to_hcd(hdev->bus);
@@ -1512,14 +1512,14 @@ static int hub_configure(struct usb_hub *hub,
 				&hub->tt, GFP_KERNEL);
 		if (ret < 0) {
 			message = "can't update HCD hub info";
-			goto fail;
+			goto fail_maxchild;
 		}
 	}
 
 	ret = hub_hub_status(hub, &hubstatus, &hubchange);
 	if (ret < 0) {
 		message = "can't get hub status";
-		goto fail;
+		goto fail_maxchild;
 	}
 
 	/* local power status reports aren't always correct */
@@ -1547,7 +1547,7 @@ static int hub_configure(struct usb_hub *hub,
 	hub->urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!hub->urb) {
 		ret = -ENOMEM;
-		goto fail;
+		goto fail_maxchild;
 	}
 
 	usb_fill_int_urb(hub->urb, hdev, pipe, *hub->buffer, maxp, hub_irq,
@@ -1567,6 +1567,8 @@ static int hub_configure(struct usb_hub *hub,
 	hub_activate(hub, HUB_INIT);
 	return 0;
 
+fail_maxchild:
+	hdev->maxchild = 0;
 fail:
 	dev_err (hub_dev, "config failed, %s (err %d)\n",
 			message, ret);
-- 
1.8.4.rc1.409.gbd48715

