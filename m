Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaCXTpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:45:22 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:44480
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753931AbaCXTpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:45:17 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, valentina.manea.m@gmail.com,
        xypron.glpk@gmx.de
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/usbip: userspace - fix usbipd SIGSEGV from refresh_exported_devices()
Date: Mon, 24 Mar 2014 13:45:13 -0600
Message-Id: <1395690313-19068-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

refresh_exported_devices() doesn't check udev_device_new_from_syspath()
return value and passed in null dev to udev_device_get_driver() resulting
in a segmentation fault. Change it to check for null return value from
both udev_device_new_from_syspath() and udev_device_get_driver().

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
index c5bf60b..92caef7 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
@@ -118,6 +118,7 @@ static int refresh_exported_devices(void)
 	struct udev_list_entry *devices, *dev_list_entry;
 	struct udev_device *dev;
 	const char *path;
+	const char *driver;
 
 	enumerate = udev_enumerate_new(udev_context);
 	udev_enumerate_add_match_subsystem(enumerate, "usb");
@@ -128,10 +129,12 @@ static int refresh_exported_devices(void)
 	udev_list_entry_foreach(dev_list_entry, devices) {
 		path = udev_list_entry_get_name(dev_list_entry);
 		dev = udev_device_new_from_syspath(udev_context, path);
+		if (dev == NULL)
+			continue;
 
 		/* Check whether device uses usbip-host driver. */
-		if (!strcmp(udev_device_get_driver(dev),
-			    USBIP_HOST_DRV_NAME)) {
+		driver = udev_device_get_driver(dev);
+		if (driver != NULL && !strcmp(driver, USBIP_HOST_DRV_NAME)) {
 			edev = usbip_exported_device_new(path);
 			if (!edev) {
 				dbg("usbip_exported_device_new failed");
-- 
1.7.10.4

