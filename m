Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab3IKQFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:05:01 -0400
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:35623 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755545Ab3IKQEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:04:53 -0400
X-RRZE-Submit-IP: 131.188.42.159
From: Dominik Paulus <dominik.paulus@fau.de>
To: linux-kernel@vger.kernel.org
Cc: Dominik Paulus <dominik.paulus@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>, Matt Mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        Stefan Reif <ke42caxa@cip.cs.fau.de>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@i4.cs.fau.de, devel@driverdev.osuosl.org
Subject: [PATCH 08/11] staging: usbip: Handle usbip being started as user
Date: Wed, 11 Sep 2013 18:06:54 +0200
Message-Id: <1378915617-29791-9-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1378915617-29791-1-git-send-email-dominik.paulus@fau.de>
References: <1378732471-5967-1-git-send-email-dominik.paulus@fau.de>
 <1378915617-29791-1-git-send-email-dominik.paulus@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usbip now prints an error message when started as user and requiring
root access. Also, some debug messages are changed to error messages so
the command line utilities now print less confusing (and more verbose)
error messages when not used correctly.

Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 drivers/staging/usbip/userspace/src/usbip_attach.c |  3 +++
 drivers/staging/usbip/userspace/src/usbip_bind.c   | 16 ++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_attach.c b/drivers/staging/usbip/userspace/src/usbip_attach.c
index 2a3f313..651e93a 100644
--- a/drivers/staging/usbip/userspace/src/usbip_attach.c
+++ b/drivers/staging/usbip/userspace/src/usbip_attach.c
@@ -210,6 +210,9 @@ int usbip_attach(int argc, char *argv[])
 	int opt;
 	int ret = -1;
 
+	if (geteuid() != 0)
+		err("not running as root?");
+
 	for (;;) {
 		opt = getopt_long(argc, argv, "r:b:", opts, NULL);
 
diff --git a/drivers/staging/usbip/userspace/src/usbip_bind.c b/drivers/staging/usbip/userspace/src/usbip_bind.c
index d2739fc..ab26b30f 100644
--- a/drivers/staging/usbip/userspace/src/usbip_bind.c
+++ b/drivers/staging/usbip/userspace/src/usbip_bind.c
@@ -158,7 +158,7 @@ static int unbind_other(char *busid)
 
 	busid_dev = sysfs_open_device(bus_type, busid);
 	if (!busid_dev) {
-		dbg("sysfs_open_device %s failed: %s", busid, strerror(errno));
+		err("sysfs_open_device %s failed: %s", busid, strerror(errno));
 		return -1;
 	}
 
@@ -166,7 +166,7 @@ static int unbind_other(char *busid)
 	bDevClass  = sysfs_get_device_attr(busid_dev, "bDeviceClass");
 	bNumIntfs  = sysfs_get_device_attr(busid_dev, "bNumInterfaces");
 	if (!bConfValue || !bDevClass || !bNumIntfs) {
-		dbg("problem getting device attributes: %s",
+		err("problem getting device attributes: %s",
 		    strerror(errno));
 		goto err_close_busid_dev;
 	}
@@ -181,7 +181,7 @@ static int unbind_other(char *busid)
 			 bConfValue->value, i);
 		intf_dev = sysfs_open_device(bus_type, intf_busid);
 		if (!intf_dev) {
-			dbg("could not open interface device: %s",
+			err("could not open interface device: %s",
 			    strerror(errno));
 			goto err_close_busid_dev;
 		}
@@ -202,14 +202,14 @@ static int unbind_other(char *busid)
 		/* unbinding */
 		intf_drv = sysfs_open_driver(bus_type, intf_dev->driver_name);
 		if (!intf_drv) {
-			dbg("could not open interface driver on %s: %s",
+			err("could not open interface driver on %s: %s",
 			    intf_dev->name, strerror(errno));
 			goto err_close_intf_dev;
 		}
 
 		unbind_attr = sysfs_get_driver_attr(intf_drv, "unbind");
 		if (!unbind_attr) {
-			dbg("problem getting interface driver attribute: %s",
+			err("problem getting interface driver attribute: %s",
 			    strerror(errno));
 			goto err_close_intf_drv;
 		}
@@ -218,7 +218,8 @@ static int unbind_other(char *busid)
 					   SYSFS_BUS_ID_SIZE);
 		if (rc < 0) {
 			/* NOTE: why keep unbinding other interfaces? */
-			dbg("unbind driver at %s failed", intf_dev->bus_id);
+			err("unbind driver at %s failed: %s", intf_dev->bus_id,
+					strerror(errno));
 			status = UNBIND_ST_FAILED;
 		}
 
@@ -287,6 +288,9 @@ int usbip_bind(int argc, char *argv[])
 
 	allow[0] = 0;
 
+	if (geteuid() != 0)
+		err("not running as root?");
+
 	for (;;) {
 		opt = getopt_long(argc, argv, "a:b:", opts, NULL);
 
-- 
1.8.4

