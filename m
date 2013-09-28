Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3I1RpH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 13:45:07 -0400
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:33133 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754913Ab3I1Rna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 13:43:30 -0400
X-RRZE-Submit-IP: 212.255.254.196
From: Dominik Paulus <dominik.paulus@fau.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>, linux-kernel@i4.cs.fau.de,
        devel@driverdev.osuosl.org, tobias.polzer@fau.de,
        Dominik Paulus <dominik.paulus@fau.de>
Subject: [PATCHv3  11/16] staging: usbip: Exchange session keys in userspace
Date: Sat, 28 Sep 2013 19:42:48 +0200
Message-Id: <1380390173-3746-11-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380390173-3746-1-git-send-email-dominik.paulus@fau.de>
References: <20130925233638.GA21396@kroah.com>
 <1380390173-3746-1-git-send-email-dominik.paulus@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for the kernel crypto support, we exchange two - randomly
generated - session keys between usbip and usbipd to be used for
encrypting all traffic generated in kernelspace. We use two different
128-bit keys, one for sending and one for receiving. Both are generated
by the client (usbip, probably has more entropy available than the
server) and transferred over the already established TLS connection.

Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 .../staging/usbip/userspace/libsrc/usbip_common.h  | 21 ++++++++++
 .../usbip/userspace/libsrc/usbip_host_driver.c     |  5 ++-
 .../usbip/userspace/libsrc/usbip_host_driver.h     |  3 +-
 .../staging/usbip/userspace/libsrc/vhci_driver.c   | 19 +++------
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |  9 ++---
 drivers/staging/usbip/userspace/src/usbip_attach.c | 47 +++++++++++++++++++++-
 drivers/staging/usbip/userspace/src/usbipd.c       | 32 ++++++++++++---
 7 files changed, 105 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
index 938ad1c..f804c04 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
@@ -127,6 +127,27 @@ struct usbip_usb_device {
 	uint8_t bNumInterfaces;
 } __attribute__((packed));
 
+
+/*
+ * These structs contain the configuration
+ * data to be passed to the kernel
+ */
+struct host_conf {
+	int sockfd;
+	uint8_t use_crypto;
+	uint8_t key1[16];
+	uint8_t key2[16];
+};
+struct vhci_conf {
+	uint8_t port;
+	int sockfd;
+	uint32_t devid;
+	uint32_t speed;
+	uint8_t use_crypto;
+	uint8_t key1[16];
+	uint8_t key2[16];
+};
+
 #define to_string(s)	#s
 
 void dump_usb_interface(struct usbip_usb_interface *);
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
index 71a449c..dd93493 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
@@ -332,7 +332,8 @@ int usbip_host_refresh_device_list(void)
 	return 0;
 }
 
-int usbip_host_export_device(struct usbip_exported_device *edev, int sockfd)
+int usbip_host_export_device(struct usbip_exported_device *edev,
+			     struct host_conf *conf)
 {
 	char attr_name[] = "usbip_sockfd";
 	char attr_path[SYSFS_PATH_MAX];
@@ -366,7 +367,7 @@ int usbip_host_export_device(struct usbip_exported_device *edev, int sockfd)
 		return -1;
 	}
 
-	snprintf(sockfd_buff, sizeof(sockfd_buff), "%d\n", sockfd);
+	snprintf(sockfd_buff, sizeof(sockfd_buff), "%d\n", conf->sockfd);
 	dbg("write: %s", sockfd_buff);
 
 	ret = sysfs_write_attribute(attr, sockfd_buff, strlen(sockfd_buff));
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h
index 34fd14c..b76e41c 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h
@@ -42,7 +42,8 @@ int usbip_host_driver_open(void);
 void usbip_host_driver_close(void);
 
 int usbip_host_refresh_device_list(void);
-int usbip_host_export_device(struct usbip_exported_device *edev, int sockfd);
+int usbip_host_export_device(struct usbip_exported_device *edev,
+			     struct host_conf *conf);
 struct usbip_exported_device *usbip_host_get_device(int num);
 
 #endif /* __USBIP_HOST_DRIVER_H */
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
index 1091bb2..d1d45bb 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
@@ -467,8 +467,8 @@ int usbip_vhci_get_free_port(void)
 	return -1;
 }
 
-int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
-		uint32_t speed) {
+int usbip_vhci_attach_device(struct vhci_conf *conf)
+{
 	struct sysfs_attribute *attr_attach;
 	char buff[200]; /* what size should be ? */
 	int ret;
@@ -481,7 +481,7 @@ int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
 	}
 
 	snprintf(buff, sizeof(buff), "%u %u %u %u",
-			port, sockfd, devid, speed);
+			conf->port, conf->sockfd, conf->devid, conf->speed);
 	dbg("writing: %s", buff);
 
 	ret = sysfs_write_attribute(attr_attach, buff, strlen(buff));
@@ -490,25 +490,16 @@ int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
 		return -1;
 	}
 
-	dbg("attached port: %d", port);
+	dbg("attached port: %d", conf->port);
 
 	return 0;
 }
 
-static unsigned long get_devid(uint8_t busnum, uint8_t devnum)
+unsigned long get_devid(uint8_t busnum, uint8_t devnum)
 {
 	return (busnum << 16) | devnum;
 }
 
-/* will be removed */
-int usbip_vhci_attach_device(uint8_t port, int sockfd, uint8_t busnum,
-		uint8_t devnum, uint32_t speed)
-{
-	int devid = get_devid(busnum, devnum);
-
-	return usbip_vhci_attach_device2(port, sockfd, devid, speed);
-}
-
 int usbip_vhci_detach_device(uint8_t port)
 {
 	struct sysfs_attribute  *attr_detach;
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
index 89949aa..325d0fa 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
@@ -55,13 +55,10 @@ int  usbip_vhci_refresh_device_list(void);
 
 
 int usbip_vhci_get_free_port(void);
-int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
-		uint32_t speed);
-
-/* will be removed */
-int usbip_vhci_attach_device(uint8_t port, int sockfd, uint8_t busnum,
-		uint8_t devnum, uint32_t speed);
+int usbip_vhci_attach_device(struct vhci_conf *conf);
 
 int usbip_vhci_detach_device(uint8_t port);
 
+unsigned long get_devid(uint8_t busnum, uint8_t devnum);
+
 #endif /* __VHCI_DRIVER_H */
diff --git a/drivers/staging/usbip/userspace/src/usbip_attach.c b/drivers/staging/usbip/userspace/src/usbip_attach.c
index 25c68e2..e339a05 100644
--- a/drivers/staging/usbip/userspace/src/usbip_attach.c
+++ b/drivers/staging/usbip/userspace/src/usbip_attach.c
@@ -29,6 +29,13 @@
 #include <unistd.h>
 #include <errno.h>
 
+#include "../config.h"
+
+#ifdef HAVE_GNUTLS
+#include <gnutls/gnutls.h>
+#include <gnutls/crypto.h>
+#endif
+
 #include "vhci_driver.h"
 #include "usbip_common.h"
 #include "usbip_network.h"
@@ -91,6 +98,38 @@ static int import_device(struct usbip_connection *conn,
 {
 	int rc;
 	int port;
+	struct vhci_conf conf;
+
+	conf.use_crypto = 0;
+#ifdef HAVE_GNUTLS
+	if (conn->have_crypto) {
+		dbg("Generating session key and sending it to client");
+
+		rc = gnutls_rnd(GNUTLS_RND_RANDOM, conf.key1,
+				sizeof(conf.key1));
+		if (rc < 0) {
+			err("Session key generation failed: %s",
+					gnutls_strerror(rc));
+			return -1;
+		}
+		rc = gnutls_rnd(GNUTLS_RND_RANDOM, conf.key2,
+				sizeof(conf.key2));
+		if (rc < 0) {
+			err("Session key generation failed: %s",
+					gnutls_strerror(rc));
+			return -1;
+		}
+
+		if (usbip_net_send(conn, (void *) conf.key1, sizeof(conf.key1))
+				< 0 || usbip_net_send(conn, (void *) conf.key2,
+					sizeof(conf.key2)) < 0) {
+			err("Unable to send session key to client");
+			return -1;
+		}
+
+		conf.use_crypto = 1;
+	}
+#endif
 
 	rc = usbip_vhci_driver_open();
 	if (rc < 0) {
@@ -106,9 +145,13 @@ static int import_device(struct usbip_connection *conn,
 	}
 
 	usbip_net_bye(conn);
-	rc = usbip_vhci_attach_device(port, conn->sockfd, udev->busnum,
-				      udev->devnum, udev->speed);
 
+	conf.port = port;
+	conf.sockfd = conn->sockfd;
+	conf.devid = get_devid(udev->busnum, udev->devnum);
+	conf.speed = udev->speed;
+
+	rc = usbip_vhci_attach_device(&conf);
 	if (rc < 0) {
 		err("import device");
 		usbip_vhci_driver_close();
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index 6bd97a0..1a80bb6 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -245,13 +245,33 @@ static int recv_request_import(struct usbip_connection *conn)
 		return -1;
 	}
 
-	usbip_net_bye(conn);
+	if (found) {
+		struct host_conf conf = {
+			.sockfd = conn->sockfd,
+			.use_crypto = 0
+		};
 
-	/* export device needs a TCP/IP socket descriptor */
-	rc = usbip_host_export_device(edev, conn->sockfd);
-	if (rc < 0) {
-		err("usbip_host_export_device");
-		return -1;
+#ifdef HAVE_GNUTLS
+		if (conn->have_crypto) {
+			if (usbip_net_recv(conn, (void *) conf.key1,
+						sizeof(conf.key1)) < 0 ||
+					usbip_net_recv(conn, (void *) conf.key2,
+						sizeof(conf.key2)) < 0) {
+				err("Unable to receive session key");
+				return -1;
+			}
+			conf.use_crypto = 1;
+		}
+#endif
+
+		usbip_net_bye(conn);
+		/* export device needs a TCP/IP socket descriptor */
+		conf.sockfd = conn->sockfd;
+		rc = usbip_host_export_device(edev, &conf);
+		if (rc < 0) {
+			err("usbip_host_export_device");
+			return -1;
+		}
 	}
 
 	dbg("import request busid %s: complete", req.busid);
-- 
1.8.4

