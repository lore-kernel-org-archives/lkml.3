Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaAGTGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 14:06:25 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:45535 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaAGTGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 14:06:18 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ly80toro@cip.cs.fau.de, standby24x7@gmail.com, alan@linux.intel.com,
        ihadzic@research.bell-labs.com, anthony.foiani@gmail.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, andy.grover@gmail.com,
        firefly@lists.rosedu.org,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH] staging: usbip: userspace: add support for viewing imported devices
Date: Tue,  7 Jan 2014 21:05:56 +0200
Message-Id: <1389121556-7465-1-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of Matt Mooney's major refactoring in 2011, usbip port
option was left out. Add support for this option in
a manner similar to the old implementation.

Sample output:

Imported USB devices
====================
Port 00: <Port in Use> at Full Speed(12Mbps)
       unknown vendor : unknown product (1687:6211)
       2-1 -> usbip://192.168.122.152:3240/1-1
           -> remote bus/dev 001/002

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
Reviewed-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
---
Resubmitting this patch as I still didn't get any reply from Greg
after 2 weeks.

 .../staging/usbip/userspace/libsrc/vhci_driver.c   | 67 ++++++++++++++++++++++
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |  2 +
 drivers/staging/usbip/userspace/src/Makefile.am    |  2 +-
 drivers/staging/usbip/userspace/src/usbip.c        |  6 ++
 drivers/staging/usbip/userspace/src/usbip.h        |  1 +
 drivers/staging/usbip/userspace/src/usbip_port.c   | 57 ++++++++++++++++++
 6 files changed, 134 insertions(+), 1 deletion(-)
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_port.c

diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
index 241006a..209df9b 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
@@ -4,6 +4,8 @@
 
 #include "usbip_common.h"
 #include "vhci_driver.h"
+#include <limits.h>
+#include <netdb.h>
 
 #undef  PROGNAME
 #define PROGNAME "libusbip"
@@ -337,6 +339,29 @@ err:
 	return -1;
 }
 
+static int read_record(int rhport, char *host, char *port, char *busid)
+{
+	FILE *file;
+	char path[PATH_MAX+1];
+
+	snprintf(path, PATH_MAX, VHCI_STATE_PATH"/port%d", rhport);
+
+	file = fopen(path, "r");
+	if (!file) {
+		err("fopen");
+		return -1;
+	}
+
+	if (fscanf(file, "%s %s %s\n", host, port, busid) != 3) {
+		err("fscanf");
+		fclose(file);
+		return -1;
+	}
+
+	fclose(file);
+
+	return 0;
+}
 
 /* ---------------------------------------------------------------------- */
 
@@ -535,3 +560,45 @@ int usbip_vhci_detach_device(uint8_t port)
 
 	return 0;
 }
+
+int usbip_vhci_imported_device_dump(struct usbip_imported_device *idev)
+{
+	char product_name[100];
+	char host[NI_MAXHOST] = "unknown host";
+	char serv[NI_MAXSERV] = "unknown port";
+	char remote_busid[SYSFS_BUS_ID_SIZE];
+	int ret;
+	int read_record_error = 0;
+
+	if (idev->status == VDEV_ST_NULL || idev->status == VDEV_ST_NOTASSIGNED)
+		return 0;
+
+	ret = read_record(idev->port, host, serv, remote_busid);
+	if (ret) {
+		err("read_record");
+		read_record_error = 1;
+	}
+
+	printf("Port %02d: <%s> at %s\n", idev->port,
+	       usbip_status_string(idev->status),
+	       usbip_speed_string(idev->udev.speed));
+
+	usbip_names_get_product(product_name, sizeof(product_name),
+				idev->udev.idVendor, idev->udev.idProduct);
+
+	printf("       %s\n",  product_name);
+
+	if (!read_record_error) {
+		printf("%10s -> usbip://%s:%s/%s\n", idev->udev.busid,
+		       host, serv, remote_busid);
+		printf("%10s -> remote bus/dev %03d/%03d\n", " ",
+		       idev->busnum, idev->devnum);
+	} else {
+		printf("%10s -> unknown host, remote port and remote busid\n",
+		       idev->udev.busid);
+		printf("%10s -> remote bus/dev %03d/%03d\n", " ",
+		       idev->busnum, idev->devnum);
+	}
+
+	return 0;
+}
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
index 89949aa..e071f80 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
@@ -64,4 +64,6 @@ int usbip_vhci_attach_device(uint8_t port, int sockfd, uint8_t busnum,
 
 int usbip_vhci_detach_device(uint8_t port);
 
+int usbip_vhci_imported_device_dump(struct usbip_imported_device *idev);
+
 #endif /* __VHCI_DRIVER_H */
diff --git a/drivers/staging/usbip/userspace/src/Makefile.am b/drivers/staging/usbip/userspace/src/Makefile.am
index a113003..b4f8c4b 100644
--- a/drivers/staging/usbip/userspace/src/Makefile.am
+++ b/drivers/staging/usbip/userspace/src/Makefile.am
@@ -6,7 +6,7 @@ sbin_PROGRAMS := usbip usbipd
 
 usbip_SOURCES := usbip.h utils.h usbip.c utils.c usbip_network.c \
 		 usbip_attach.c usbip_detach.c usbip_list.c \
-		 usbip_bind.c usbip_unbind.c
+		 usbip_bind.c usbip_unbind.c usbip_port.c
 
 
 usbipd_SOURCES := usbip_network.h usbipd.c usbip_network.c
diff --git a/drivers/staging/usbip/userspace/src/usbip.c b/drivers/staging/usbip/userspace/src/usbip.c
index 04a5f20..d7599d9 100644
--- a/drivers/staging/usbip/userspace/src/usbip.c
+++ b/drivers/staging/usbip/userspace/src/usbip.c
@@ -93,6 +93,12 @@ static const struct command cmds[] = {
 		.help  = "Unbind device from " USBIP_HOST_DRV_NAME ".ko",
 		.usage = usbip_unbind_usage
 	},
+	{
+		.name  = "port",
+		.fn    = usbip_port_show,
+		.help  = "Show imported USB devices",
+		.usage = NULL
+	},
 	{ NULL, NULL, NULL, NULL }
 };
 
diff --git a/drivers/staging/usbip/userspace/src/usbip.h b/drivers/staging/usbip/userspace/src/usbip.h
index 14d4a47..84fe66a 100644
--- a/drivers/staging/usbip/userspace/src/usbip.h
+++ b/drivers/staging/usbip/userspace/src/usbip.h
@@ -29,6 +29,7 @@ int usbip_detach(int argc, char *argv[]);
 int usbip_list(int argc, char *argv[]);
 int usbip_bind(int argc, char *argv[]);
 int usbip_unbind(int argc, char *argv[]);
+int usbip_port_show(int argc, char *argv[]);
 
 void usbip_attach_usage(void);
 void usbip_detach_usage(void);
diff --git a/drivers/staging/usbip/userspace/src/usbip_port.c b/drivers/staging/usbip/userspace/src/usbip_port.c
new file mode 100644
index 0000000..52aa168
--- /dev/null
+++ b/drivers/staging/usbip/userspace/src/usbip_port.c
@@ -0,0 +1,57 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include "vhci_driver.h"
+#include "usbip_common.h"
+
+static int list_imported_devices()
+{
+	int i;
+	struct usbip_imported_device *idev;
+	int ret;
+
+	ret = usbip_vhci_driver_open();
+	if (ret < 0) {
+		err("open vhci_driver");
+		return -1;
+	}
+
+	printf("Imported USB devices\n");
+	printf("====================\n");
+
+	for (i = 0; i < vhci_driver->nports; i++) {
+		idev = &vhci_driver->idev[i];
+
+		if (usbip_vhci_imported_device_dump(idev) < 0)
+			ret = -1;
+	}
+
+	usbip_vhci_driver_close();
+
+	return ret;
+
+}
+
+int usbip_port_show(__attribute__((unused)) int argc,
+		    __attribute__((unused)) char *argv[])
+{
+	int ret;
+
+	ret = list_imported_devices();
+	if (ret < 0)
+		err("list imported devices");
+
+	return ret;
+}
-- 
1.8.1.2

