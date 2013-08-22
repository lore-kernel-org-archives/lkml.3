Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab3HVMuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 08:50:51 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:54834 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3HVMty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 08:49:54 -0400
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        Krzysztof Mazur <krzysiek@podlesie.net>
Subject: [PATCH v3 2/3] usb: fail on usb_hub_create_port_device() errors
Date: Thu, 22 Aug 2013 14:49:39 +0200
Message-Id: <1377175780-10611-3-git-send-email-krzysiek@podlesie.net>
X-Mailer: git-send-email 1.8.4.rc4.527.g303b16c
In-Reply-To: <1377175780-10611-1-git-send-email-krzysiek@podlesie.net>
References: <1377175780-10611-1-git-send-email-krzysiek@podlesie.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignoring usb_hub_create_port_device() errors cause later NULL pointer
deference when uninitialized hub->ports[i] entries are dereferenced
after port memory allocation error.

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/core/hub.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index affed11..292ffa8 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1557,10 +1557,15 @@ static int hub_configure(struct usb_hub *hub,
 	if (hub->has_indicators && blinkenlights)
 		hub->indicator [0] = INDICATOR_CYCLE;
 
-	for (i = 0; i < hdev->maxchild; i++)
-		if (usb_hub_create_port_device(hub, i + 1) < 0)
+	for (i = 0; i < hdev->maxchild; i++) {
+		ret = usb_hub_create_port_device(hub, i + 1);
+		if (ret < 0) {
 			dev_err(hub->intfdev,
 				"couldn't create port%d device.\n", i + 1);
+			hdev->maxchild = i;
+			goto fail_keep_maxchild;
+		}
+	}
 
 	usb_hub_adjust_deviceremovable(hdev, hub->descriptor);
 
@@ -1569,6 +1574,7 @@ static int hub_configure(struct usb_hub *hub,
 
 fail:
 	hdev->maxchild = 0;
+fail_keep_maxchild:
 	dev_err (hub_dev, "config failed, %s (err %d)\n",
 			message, ret);
 	/* hub_disconnect() frees urb and descriptor */
-- 
1.8.4.rc4.527.g303b16c

