Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3I1Rne (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 13:43:34 -0400
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:59261 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754545Ab3I1Rn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 13:43:26 -0400
X-RRZE-Submit-IP: 212.255.254.196
From: Dominik Paulus <dominik.paulus@fau.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>, linux-kernel@i4.cs.fau.de,
        devel@driverdev.osuosl.org, tobias.polzer@fau.de,
        Dominik Paulus <dominik.paulus@fau.de>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>
Subject: [PATCHv3  05/16] staging: usbip: Add support for ACLs in usbipd
Date: Sat, 28 Sep 2013 19:42:42 +0200
Message-Id: <1380390173-3746-5-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380390173-3746-1-git-send-email-dominik.paulus@fau.de>
References: <20130925233638.GA21396@kroah.com>
 <1380390173-3746-1-git-send-email-dominik.paulus@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interpret the ACLs stored in sysfs in usbipd and reject clients not
matching one of the ACLs.

Signed-off-by: Kurt Kanzenbach <ly80toro@cip.cs.fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 drivers/staging/usbip/userspace/src/Makefile.am |  2 +-
 drivers/staging/usbip/userspace/src/usbipd.c    | 79 +++++++++++++++++++++++++
 2 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/usbip/userspace/src/Makefile.am b/drivers/staging/usbip/userspace/src/Makefile.am
index a113003..5161bae 100644
--- a/drivers/staging/usbip/userspace/src/Makefile.am
+++ b/drivers/staging/usbip/userspace/src/Makefile.am
@@ -9,4 +9,4 @@ usbip_SOURCES := usbip.h utils.h usbip.c utils.c usbip_network.c \
 		 usbip_bind.c usbip_unbind.c
 
 
-usbipd_SOURCES := usbip_network.h usbipd.c usbip_network.c
+usbipd_SOURCES := usbip_network.h usbipd.c usbip_network.c utils.c
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index 8db2f27..bc1fd19 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -48,6 +48,7 @@
 #include "usbip_host_driver.h"
 #include "usbip_common.h"
 #include "usbip_network.h"
+#include "utils.h"
 
 #undef  PROGNAME
 #define PROGNAME "usbipd"
@@ -169,12 +170,69 @@ static void usbipd_help(void)
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
 	struct op_common reply;
 	struct usbip_exported_device *edev;
 	struct usbip_usb_device pdu_udev;
+	struct sysfs_attribute *usbip_acl;
+	char ip_attr_path[SYSFS_PATH_MAX];
 	int found = 0;
 	int error = 0;
 	int rc;
@@ -206,6 +264,27 @@ static int recv_request_import(int sockfd)
 		rc = usbip_host_export_device(edev, sockfd);
 		if (rc < 0)
 			error = 1;
+
+		/* check for allowed IPs */
+		snprintf(ip_attr_path, sizeof(ip_attr_path), "%s/%s:%d.%d/%s",
+			edev->udev.path, edev->udev.busid,
+			edev->udev.bConfigurationValue, 0, "usbip_acl");
+
+		usbip_acl = sysfs_open_attribute(ip_attr_path);
+		if (usbip_acl) {
+			rc = sysfs_read_attribute(usbip_acl);
+			if (rc < 0) {
+				err("Unable to open sysfs");
+				error = 1;
+			} else if (check_allowed(usbip_acl->value, sockfd) != 1) {
+				info("Access denied to device %s",
+					edev->udev.busid);
+				error = 1;
+			}
+			sysfs_close_attribute(usbip_acl);
+		} else {
+			err("failed to get ip list");
+		}
 	} else {
 		info("requested device not found: %s", req.busid);
 		error = 1;
-- 
1.8.4

