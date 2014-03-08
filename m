Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaCHMyg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 07:54:36 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:41186 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaCHMy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 07:54:26 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        shuah.kh@samsung.com, ihadzic@research.bell-labs.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, firefly@lists.rosedu.org,
        andy.grover@gmail.com, Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 17/18] staging: usbip: userspace: don't throw error when trying to read configuration specific attributes
Date: Sat,  8 Mar 2014 14:53:35 +0200
Message-Id: <1394283216-1277-18-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1394283216-1277-1-git-send-email-valentina.manea.m@gmail.com>
References: <1394283216-1277-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a device has just been bound to usbip-host but the client hasn't
set a configuration on it, certain attributes will not exist. Don't
treat this as an error.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/usbip/userspace/libsrc/usbip_common.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.c b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
index 998c11c..238bf5b 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
@@ -127,10 +127,23 @@ int read_attr_value(struct udev_device *dev, const char *name,
 		goto err;
 	}
 
+	/* The client chooses the device configuration
+	 * when attaching it so right after being bound
+	 * to usbip-host on the server the device will
+	 * have no configuration.
+	 * Therefore, attributes such as bConfigurationValue
+	 * and bNumInterfaces will not exist and sscanf will
+	 * fail. Check for these cases and don't treat them
+	 * as errors.
+	 */
+
 	ret = sscanf(attr, format, &num);
 	if (ret < 1) {
-		err("sscanf failed");
-		goto err;
+		if (strcmp(name, "bConfigurationValue") &&
+				strcmp(name, "bNumInterfaces")) {
+			err("sscanf failed for attribute %s", name);
+			goto err;
+		}
 	}
 
 err:
-- 
1.8.1.2

