Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab3KRSyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:54:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3KRSk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:40:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3.11 23/25] usb: fail on usb_hub_create_port_device() errors
Date: Mon, 18 Nov 2013 10:40:52 -0800
Message-Id: <20131118184039.408334088@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184032.248465920@linuxfoundation.org>
References: <20131118184032.248465920@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Mazur <krzysiek@podlesie.net>

commit e58547eb9561a8a72d46e2d411090a614d33ac0e upstream.

Ignoring usb_hub_create_port_device() errors cause later NULL pointer
deference when uninitialized hub->ports[i] entries are dereferenced
after port memory allocation error.

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1557,10 +1557,15 @@ static int hub_configure(struct usb_hub
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
 
@@ -1569,6 +1574,7 @@ static int hub_configure(struct usb_hub
 
 fail:
 	hdev->maxchild = 0;
+fail_keep_maxchild:
 	dev_err (hub_dev, "config failed, %s (err %d)\n",
 			message, ret);
 	/* hub_disconnect() frees urb and descriptor */


