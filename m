Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaCHM6N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 07:58:13 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:61695 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaCHMyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 07:54:02 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        shuah.kh@samsung.com, ihadzic@research.bell-labs.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, firefly@lists.rosedu.org,
        andy.grover@gmail.com, Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 05/18] staging: usbip: userspace: re-add interface information listing
Date: Sat,  8 Mar 2014 14:53:23 +0200
Message-Id: <1394283216-1277-6-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1394283216-1277-1-git-send-email-valentina.manea.m@gmail.com>
References: <1394283216-1277-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was deleted in the driver conversion patch. It didn't need
to be deleted; showing more information is ok.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
Reviewed-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/staging/usbip/userspace/src/usbip_list.c | 20 +++++++++++++++++++-
 drivers/staging/usbip/userspace/src/usbipd.c     | 16 +++++++++++++++-
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_list.c b/drivers/staging/usbip/userspace/src/usbip_list.c
index 54178b7..d5ce34a 100644
--- a/drivers/staging/usbip/userspace/src/usbip_list.c
+++ b/drivers/staging/usbip/userspace/src/usbip_list.c
@@ -52,8 +52,9 @@ static int get_exported_devices(char *host, int sockfd)
 	struct op_devlist_reply reply;
 	uint16_t code = OP_REP_DEVLIST;
 	struct usbip_usb_device udev;
+	struct usbip_usb_interface uintf;
 	unsigned int i;
-	int rc;
+	int rc, j;
 
 	rc = usbip_net_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
 	if (rc < 0) {
@@ -103,6 +104,23 @@ static int get_exported_devices(char *host, int sockfd)
 		printf("%11s: %s\n", "", udev.path);
 		printf("%11s: %s\n", "", class_name);
 
+		for (j = 0; j < udev.bNumInterfaces; j++) {
+			rc = usbip_net_recv(sockfd, &uintf, sizeof(uintf));
+			if (rc < 0) {
+				err("usbip_net_recv failed: usbip_usb_intf[%d]",
+						j);
+
+				return -1;
+			}
+			usbip_net_pack_usb_interface(0, &uintf);
+
+			usbip_names_get_class(class_name, sizeof(class_name),
+					uintf.bInterfaceClass,
+					uintf.bInterfaceSubClass,
+					uintf.bInterfaceProtocol);
+			printf("%11s: %2d - %s\n", "", j, class_name);
+		}
+
 		printf("\n");
 	}
 
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index c2b3ced..771d6c2 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -159,8 +159,9 @@ static int send_reply_devlist(int connfd)
 {
 	struct usbip_exported_device *edev;
 	struct usbip_usb_device pdu_udev;
+	struct usbip_usb_interface pdu_uinf;
 	struct op_devlist_reply reply;
-	int rc;
+	int rc, i;
 
 	reply.ndev = 0;
 	/* number of exported devices */
@@ -194,6 +195,19 @@ static int send_reply_devlist(int connfd)
 			dbg("usbip_net_send failed: pdu_udev");
 			return -1;
 		}
+
+		for (i = 0; i < edev->udev.bNumInterfaces; i++) {
+			dump_usb_interface(&edev->uinf[i]);
+			memcpy(&pdu_uinf, &edev->uinf[i], sizeof(pdu_uinf));
+			usbip_net_pack_usb_interface(1, &pdu_uinf);
+
+			rc = usbip_net_send(connfd, &pdu_uinf,
+					sizeof(pdu_uinf));
+			if (rc < 0) {
+				err("usbip_net_send failed: pdu_uinf");
+				return -1;
+			}
+		}
 	}
 
 	return 0;
-- 
1.8.1.2

