Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbaIPWLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:11:09 -0400
Received: from vidar.hosts.sieglitzhof.net ([62.113.200.140]:60284 "EHLO
	vidar.hosts.sieglitzhof.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbaIPWIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:08:23 -0400
From: Maximilian Eschenbacher <maximilian@eschenbacher.email>
To: linux-kernel@vger.kernel.org
Cc: valentina.manea.m@gmail.com, shuah.kh@samsung.com,
        gregkh@linuxfoundation.org, Dominik Paulus <dominik.paulus@fau.de>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>
Date: Tue, 16 Sep 2014 23:38:43 +0000
Message-Id: <1410910735-27929-7-git-send-email-maximilian@eschenbacher.email>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
X-SA-Exim-Connect-IP: 172.16.2.6
X-SA-Exim-Mail-From: maximilian@eschenbacher.email
Subject: [PATCH 06/18] usbip: Add support for ACLs in usbipd
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on vidar.hosts.sieglitzhof.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dominik Paulus <dominik.paulus@fau.de>

Interpret the ACLs stored in sysfs in usbipd and reject clients not
matching one of the ACLs.

Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Signed-off-by: Fjodor Schelichow <fjodor.schelichow@hotmail.com>
Signed-off-by: Johannes Stadlinger <johannes.stadlinger@fau.de>
Signed-off-by: Kurt Kanzenbach <ly80toro@cip.cs.fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 tools/usb/usbip/libsrc/usbip_common.h |  1 +
 tools/usb/usbip/src/Makefile.am       |  2 +-
 tools/usb/usbip/src/usbip_bind.c      |  2 +-
 tools/usb/usbip/src/usbipd.c          | 73 +++++++++++++++++++++++++++++++++++
 4 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/tools/usb/usbip/libsrc/usbip_common.h b/tools/usb/usbip/libsrc/usbip_common.h
index 15fe792..824d5a5 100644
--- a/tools/usb/usbip/libsrc/usbip_common.h
+++ b/tools/usb/usbip/libsrc/usbip_common.h
@@ -38,6 +38,7 @@
 
 #define SYSFS_PATH_MAX		256
 #define SYSFS_BUS_ID_SIZE	32
+#define SYSFS_IP_ACLS_MAX	4096
 
 extern int usbip_use_syslog;
 extern int usbip_use_stderr;
diff --git a/tools/usb/usbip/src/Makefile.am b/tools/usb/usbip/src/Makefile.am
index e81a4eb..c100273 100644
--- a/tools/usb/usbip/src/Makefile.am
+++ b/tools/usb/usbip/src/Makefile.am
@@ -8,4 +8,4 @@ usbip_SOURCES := usbip.h utils.h usbip.c utils.c usbip_network.c \
 		 usbip_attach.c usbip_detach.c usbip_list.c \
 		 usbip_bind.c usbip_unbind.c usbip_port.c
 
-usbipd_SOURCES := usbip_network.h usbipd.c usbip_network.c
+usbipd_SOURCES := usbip_network.h usbipd.c usbip_network.c utils.c
diff --git a/tools/usb/usbip/src/usbip_bind.c b/tools/usb/usbip/src/usbip_bind.c
index b888ea3..3f8c7a3 100644
--- a/tools/usb/usbip/src/usbip_bind.c
+++ b/tools/usb/usbip/src/usbip_bind.c
@@ -206,7 +206,7 @@ int usbip_bind(int argc, char *argv[])
 	};
 
 	int opt, rc;
-	char allow[4096];
+	char allow[SYSFS_IP_ACLS_MAX];
 	char *device = NULL;
 	struct subnet subnet;
 
diff --git a/tools/usb/usbip/src/usbipd.c b/tools/usb/usbip/src/usbipd.c
index 23c15d7..7c0a46d 100644
--- a/tools/usb/usbip/src/usbipd.c
+++ b/tools/usb/usbip/src/usbipd.c
@@ -49,6 +49,8 @@
 #include "usbip_common.h"
 #include "usbip_network.h"
 #include "list.h"
+#include "utils.h"
+#include "sysfs_utils.h"
 
 #undef  PROGNAME
 #define PROGNAME "usbipd"
@@ -100,6 +102,61 @@ static void usbipd_help(void)
 	printf("%s\n", usbipd_help_string);
 }
 
+/*
+ * Checks whether client IP matches at least one
+ * ACL entry
+ *
+ * Returns:
+ *		1  if matches
+ *		0  if not
+ *		-1 on error
+ */
+static int check_allowed(char *acls, int sockfd)
+{
+	int rc, match;
+	struct sockaddr_storage sa;
+	char *acl_cpy, *iter, *saveptr;
+	socklen_t sa_len = sizeof(sa);
+
+	rc = getpeername(sockfd, (struct sockaddr *) &sa, &sa_len);
+	if (rc || sa_len > sizeof(sa)) {
+		err("getpeername failed: %s", strerror(errno));
+		return -1;
+	}
+
+	/*
+	 * We are going to modify our argument,
+	 * thus, we need to duplicate it.
+	 */
+	acl_cpy = strdup(acls);
+	if (!acl_cpy) {
+		err("strdup(): %s", strerror(errno));
+		return -1;
+	}
+
+	match = 0;
+	iter = strtok_r(acl_cpy, "\n", &saveptr);
+	/*
+	 * Iterate over ACL entries and check for
+	 * matching one.
+	 */
+	while (iter) {
+		struct subnet net;
+
+		if (parse_cidr(iter, &net) < 0) {
+			dbg("parse_cidr() failed");
+		} else if (in_range(&sa, net)) {
+			match = 1;
+			break;
+		}
+
+		iter = strtok_r(NULL, "\n", &saveptr);
+	}
+
+	free(acl_cpy);
+	return match;
+}
+
 static int recv_request_import(int sockfd)
 {
 	struct op_import_request req;
@@ -107,6 +164,8 @@ static int recv_request_import(int sockfd)
 	struct usbip_exported_device *edev;
 	struct usbip_usb_device pdu_udev;
 	struct list_head *i;
+	char sysfs_attr[SYSFS_IP_ACLS_MAX];
+	char ip_attr_path[SYSFS_PATH_MAX];
 	int found = 0;
 	int error = 0;
 	int rc;
@@ -138,6 +197,20 @@ static int recv_request_import(int sockfd)
 		rc = usbip_host_export_device(edev, sockfd);
 		if (rc < 0)
 			error = 1;
+
+		/* check for allowed IPs */
+		snprintf(ip_attr_path, sizeof(ip_attr_path), "%s/%s",
+			 edev->udev.path, "usbip_acl");
+
+		rc = read_sysfs_attribute(ip_attr_path, sysfs_attr,
+					   sizeof(sysfs_attr));
+		if (rc == -1)
+			err("failed to get ip list");
+		else if (check_allowed(sysfs_attr, conn->sockfd) != 1) {
+			info("Access denied to device %s",
+			     edev->udev.busid);
+			error = ERR_PERM;
+		}
 	} else {
 		info("requested device not found: %s", req.busid);
 		error = 1;
-- 
2.1.0

