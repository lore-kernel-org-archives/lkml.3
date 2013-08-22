Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab3HVMt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 08:49:57 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:54836 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab3HVMty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 08:49:54 -0400
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        Krzysztof Mazur <krzysiek@podlesie.net>
Subject: [PATCH v3 1/3] usb: fix cleanup after failure in hub_configure()
Date: Thu, 22 Aug 2013 14:49:38 +0200
Message-Id: <1377175780-10611-2-git-send-email-krzysiek@podlesie.net>
X-Mailer: git-send-email 1.8.4.rc4.527.g303b16c
In-Reply-To: <1377175780-10611-1-git-send-email-krzysiek@podlesie.net>
References: <1377175780-10611-1-git-send-email-krzysiek@podlesie.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the hub_configure() fails after setting the hdev->maxchild
the hub->ports might be NULL or point to uninitialized kzallocated
memory causing NULL pointer dereference in hub_quiesce() during cleanup.

Now after such error the hdev->maxchild is set to 0 to avoid cleanup
of uninitialized ports.

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/core/hub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 558313d..affed11 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1568,6 +1568,7 @@ static int hub_configure(struct usb_hub *hub,
 	return 0;
 
 fail:
+	hdev->maxchild = 0;
 	dev_err (hub_dev, "config failed, %s (err %d)\n",
 			message, ret);
 	/* hub_disconnect() frees urb and descriptor */
-- 
1.8.4.rc4.527.g303b16c

