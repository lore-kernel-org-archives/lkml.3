Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab3F0KFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:05:31 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:43468 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3F0KF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:05:29 -0400
From: navin patidar <navinp@cdac.in>
To: gregkh@linuxfoundation.org, mfm@muteddisk.com,
        sergei.shtylyov@cogentembedded.com, joe@perches.com
Cc: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navinp@cdac.in>
Subject: [PATCH v4] staging: usbip: replace pr_warning() with dev_warn().
Date: Thu, 27 Jun 2013 15:34:52 +0530
Message-Id: <1372327492-9099-1-git-send-email-navinp@cdac.in>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_warn() is preferred over pr_warning().

container_of() is used to get usb_driver pointer from usbip_device container
(stub_device or vhci_device), to get device structure required for dev_warn().

Signed-off-by: navin patidar <navinp@cdac.in>
---
 drivers/staging/usbip/usbip_event.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/staging/usbip/usbip_event.c
index 82123be..1f3a571 100644
--- a/drivers/staging/usbip/usbip_event.c
+++ b/drivers/staging/usbip/usbip_event.c
@@ -21,6 +21,8 @@
 #include <linux/export.h>

 #include "usbip_common.h"
+#include "stub.h"
+#include "vhci.h"

 static int event_handler(struct usbip_device *ud)
 {
@@ -85,7 +87,14 @@ int usbip_start_eh(struct usbip_device *ud)

 	ud->eh = kthread_run(event_handler_loop, ud, "usbip_eh");
 	if (IS_ERR(ud->eh)) {
-		pr_warning("Unable to start control thread\n");
+		struct device *dev;
+
+		if (ud->side == USBIP_STUB)
+			dev = &container_of(ud, struct stub_device, ud)->udev->dev;
+		else
+			dev = &container_of(ud, struct vhci_device, ud)->udev->dev;
+
+		dev_warn(dev, "Unable to start control thread\n");
 		return PTR_ERR(ud->eh);
 	}

--
1.7.10.4

