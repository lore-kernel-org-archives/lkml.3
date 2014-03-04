Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbaCDTNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:13:31 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:34521 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbaCDTLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:11:30 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        shuah.kh@samsung.com, ihadzic@research.bell-labs.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, firefly@lists.rosedu.org,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 07/12] staging: usbip: userspace: move sysfs_utils to libsrc
Date: Tue,  4 Mar 2014 21:10:47 +0200
Message-Id: <1393960252-21247-8-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it offers a API to both usbip tools and libusbip,
it is more appropriate to be place in the library.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/usbip/userspace/libsrc/Makefile.am |  3 +-
 .../staging/usbip/userspace/libsrc/sysfs_utils.c   | 36 ++++++++++++++++++++++
 .../staging/usbip/userspace/libsrc/sysfs_utils.h   |  8 +++++
 drivers/staging/usbip/userspace/src/Makefile.am    |  3 +-
 drivers/staging/usbip/userspace/src/sysfs_utils.c  | 36 ----------------------
 drivers/staging/usbip/userspace/src/sysfs_utils.h  |  8 -----
 6 files changed, 47 insertions(+), 47 deletions(-)
 create mode 100644 drivers/staging/usbip/userspace/libsrc/sysfs_utils.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/sysfs_utils.h
 delete mode 100644 drivers/staging/usbip/userspace/src/sysfs_utils.c
 delete mode 100644 drivers/staging/usbip/userspace/src/sysfs_utils.h

diff --git a/drivers/staging/usbip/userspace/libsrc/Makefile.am b/drivers/staging/usbip/userspace/libsrc/Makefile.am
index 294270b..b4c7631 100644
--- a/drivers/staging/usbip/userspace/libsrc/Makefile.am
+++ b/drivers/staging/usbip/userspace/libsrc/Makefile.am
@@ -5,4 +5,5 @@ libusbip_la_LDFLAGS  = -version-info @LIBUSBIP_VERSION@
 lib_LTLIBRARIES := libusbip.la
 libusbip_la_SOURCES := names.c names.h usbip_host_driver.c usbip_host_driver.h \
 		       usbip_common.c usbip_common.h vhci_driver.c vhci_driver.h \
-		       list.c list.h build_assert.h check_type.h container_of.h
+		       list.c list.h build_assert.h check_type.h container_of.h \
+		       sysfs_utils.c sysfs_utils.h
diff --git a/drivers/staging/usbip/userspace/libsrc/sysfs_utils.c b/drivers/staging/usbip/userspace/libsrc/sysfs_utils.c
new file mode 100644
index 0000000..2c362d1
--- /dev/null
+++ b/drivers/staging/usbip/userspace/libsrc/sysfs_utils.c
@@ -0,0 +1,36 @@
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <errno.h>
+
+#include "sysfs_utils.h"
+#include "usbip_common.h"
+
+int write_sysfs_attribute(const char *attr_path, const char *new_value,
+			  size_t len)
+{
+	int fd;
+	int length;
+
+	if (attr_path == NULL || new_value == NULL || len == 0) {
+		dbg("Invalid values provided for attribute %s.", attr_path);
+		errno = EINVAL;
+		return -1;
+	}
+
+	if ((fd = open(attr_path, O_WRONLY)) < 0) {
+		dbg("Error opening attribute %s.", attr_path);
+		return -1;
+	}
+
+	length = write(fd, new_value, len);
+	if (length < 0) {
+		dbg("Error writing to attribute %s.", attr_path);
+		close(fd);
+		return -1;
+	}
+
+	close(fd);
+
+	return 0;
+}
diff --git a/drivers/staging/usbip/userspace/libsrc/sysfs_utils.h b/drivers/staging/usbip/userspace/libsrc/sysfs_utils.h
new file mode 100644
index 0000000..32ac1d1
--- /dev/null
+++ b/drivers/staging/usbip/userspace/libsrc/sysfs_utils.h
@@ -0,0 +1,8 @@
+
+#ifndef __SYSFS_UTILS_H
+#define __SYSFS_UTILS_H
+
+int write_sysfs_attribute(const char *attr_path, const char *new_value,
+			  size_t len);
+
+#endif
diff --git a/drivers/staging/usbip/userspace/src/Makefile.am b/drivers/staging/usbip/userspace/src/Makefile.am
index 6c91bcb..b4f8c4b 100644
--- a/drivers/staging/usbip/userspace/src/Makefile.am
+++ b/drivers/staging/usbip/userspace/src/Makefile.am
@@ -6,8 +6,7 @@ sbin_PROGRAMS := usbip usbipd
 
 usbip_SOURCES := usbip.h utils.h usbip.c utils.c usbip_network.c \
 		 usbip_attach.c usbip_detach.c usbip_list.c \
-		 usbip_bind.c usbip_unbind.c usbip_port.c \
-		 sysfs_utils.c
+		 usbip_bind.c usbip_unbind.c usbip_port.c
 
 
 usbipd_SOURCES := usbip_network.h usbipd.c usbip_network.c
diff --git a/drivers/staging/usbip/userspace/src/sysfs_utils.c b/drivers/staging/usbip/userspace/src/sysfs_utils.c
deleted file mode 100644
index 2c362d1..0000000
--- a/drivers/staging/usbip/userspace/src/sysfs_utils.c
+++ /dev/null
@@ -1,36 +0,0 @@
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <errno.h>
-
-#include "sysfs_utils.h"
-#include "usbip_common.h"
-
-int write_sysfs_attribute(const char *attr_path, const char *new_value,
-			  size_t len)
-{
-	int fd;
-	int length;
-
-	if (attr_path == NULL || new_value == NULL || len == 0) {
-		dbg("Invalid values provided for attribute %s.", attr_path);
-		errno = EINVAL;
-		return -1;
-	}
-
-	if ((fd = open(attr_path, O_WRONLY)) < 0) {
-		dbg("Error opening attribute %s.", attr_path);
-		return -1;
-	}
-
-	length = write(fd, new_value, len);
-	if (length < 0) {
-		dbg("Error writing to attribute %s.", attr_path);
-		close(fd);
-		return -1;
-	}
-
-	close(fd);
-
-	return 0;
-}
diff --git a/drivers/staging/usbip/userspace/src/sysfs_utils.h b/drivers/staging/usbip/userspace/src/sysfs_utils.h
deleted file mode 100644
index 32ac1d1..0000000
--- a/drivers/staging/usbip/userspace/src/sysfs_utils.h
+++ /dev/null
@@ -1,8 +0,0 @@
-
-#ifndef __SYSFS_UTILS_H
-#define __SYSFS_UTILS_H
-
-int write_sysfs_attribute(const char *attr_path, const char *new_value,
-			  size_t len);
-
-#endif
-- 
1.8.1.2

