Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbaIPWIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:08:35 -0400
Received: from vidar.hosts.sieglitzhof.net ([62.113.200.140]:60288 "EHLO
	vidar.hosts.sieglitzhof.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324AbaIPWIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:08:30 -0400
From: Maximilian Eschenbacher <maximilian@eschenbacher.email>
To: linux-kernel@vger.kernel.org
Cc: valentina.manea.m@gmail.com, shuah.kh@samsung.com,
        gregkh@linuxfoundation.org,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Dominik Paulus <dominik.paulus@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>
Date: Tue, 16 Sep 2014 23:38:45 +0000
Message-Id: <1410910735-27929-9-git-send-email-maximilian@eschenbacher.email>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
X-SA-Exim-Connect-IP: 172.16.2.6
X-SA-Exim-Mail-From: maximilian@eschenbacher.email
Subject: [PATCH 08/18] usbip: Handle usbip being started as user
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on vidar.hosts.sieglitzhof.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usbip now prints an error message when started as user and requiring
root access. Also, some debug messages are changed to error messages so
the command line utilities now print less confusing (and more verbose)
error messages when not used correctly.

Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Signed-off-by: Fjodor Schelichow <fjodor.schelichow@hotmail.com>
Signed-off-by: Johannes Stadlinger <johannes.stadlinger@fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 tools/usb/usbip/src/usbip_attach.c | 3 +++
 tools/usb/usbip/src/usbip_bind.c   | 9 ++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/usb/usbip/src/usbip_attach.c b/tools/usb/usbip/src/usbip_attach.c
index 51c67a2..fcc3efb 100644
--- a/tools/usb/usbip/src/usbip_attach.c
+++ b/tools/usb/usbip/src/usbip_attach.c
@@ -210,6 +210,9 @@ int usbip_attach(int argc, char *argv[])
 	int opt;
 	int ret = -1;
 
+	if (geteuid() != 0)
+		err("not running as root?");
+
 	for (;;) {
 		opt = getopt_long(argc, argv, "r:b:", opts, NULL);
 
diff --git a/tools/usb/usbip/src/usbip_bind.c b/tools/usb/usbip/src/usbip_bind.c
index 3f8c7a3..6f5d3c2 100644
--- a/tools/usb/usbip/src/usbip_bind.c
+++ b/tools/usb/usbip/src/usbip_bind.c
@@ -102,19 +102,19 @@ static int unbind_other(char *busid)
 	/* Get the device. */
 	dev = udev_device_new_from_subsystem_sysname(udev, "usb", busid);
 	if (!dev) {
-		dbg("unable to find device with bus ID %s", busid);
+		err("unable to find device with bus ID %s", busid);
 		goto err_close_busid_dev;
 	}
 
 	/* Check what kind of device it is. */
 	bDevClass  = udev_device_get_sysattr_value(dev, "bDeviceClass");
 	if (!bDevClass) {
-		dbg("unable to get bDevClass device attribute");
+		err("unable to get bDevClass device attribute");
 		goto err_close_busid_dev;
 	}
 
 	if (!strncmp(bDevClass, "09", strlen(bDevClass))) {
-		dbg("skip unbinding of hub");
+		err("skip unbinding of hub");
 		goto err_close_busid_dev;
 	}
 
@@ -212,6 +212,9 @@ int usbip_bind(int argc, char *argv[])
 
 	allow[0] = 0;
 
+	if (geteuid() != 0)
+		err("not running as root?");
+
 	for (;;) {
 		opt = getopt_long(argc, argv, "a:b:", opts, NULL);
 
-- 
2.1.0

