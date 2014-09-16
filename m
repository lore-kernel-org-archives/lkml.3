Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbaIPVri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:47:38 -0400
Received: from vidar.hosts.sieglitzhof.net ([62.113.200.140]:60248 "EHLO
	vidar.hosts.sieglitzhof.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753884AbaIPVrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:47:12 -0400
From: Maximilian Eschenbacher <maximilian@eschenbacher.email>
To: linux-kernel@vger.kernel.org
Cc: valentina.manea.m@gmail.com, shuah.kh@samsung.com,
        gregkh@linuxfoundation.org, Dominik Paulus <dominik.paulus@fau.de>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>
Date: Tue, 16 Sep 2014 23:38:49 +0000
Message-Id: <1410910735-27929-13-git-send-email-maximilian@eschenbacher.email>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
X-SA-Exim-Connect-IP: 172.16.2.6
X-SA-Exim-Mail-From: maximilian@eschenbacher.email
Subject: [PATCH 12/18] usbip: Exchange session keys in userspace
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on vidar.hosts.sieglitzhof.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dominik Paulus <dominik.paulus@fau.de>

In preparation for the kernel crypto support, we exchange two - randomly
generated - session keys between usbip and usbipd to be used for
encrypting all traffic generated in kernelspace. We use two different
128-bit keys, one for sending and one for receiving. Both are generated
by the client (usbip, probably has more entropy available than the
server) and transferred over the already established TLS connection.

Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Signed-off-by: Fjodor Schelichow <fjodor.schelichow@hotmail.com>
Signed-off-by: Johannes Stadlinger <johannes.stadlinger@fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 tools/usb/usbip/libsrc/usbip_common.h      | 21 +++++++++++++++++++++
 tools/usb/usbip/libsrc/usbip_host_driver.c |  5 +++--
 tools/usb/usbip/libsrc/usbip_host_driver.h |  3 ++-
 tools/usb/usbip/libsrc/vhci_driver.c       | 19 +++++--------------
 tools/usb/usbip/libsrc/vhci_driver.h       |  9 +++------
 5 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/tools/usb/usbip/libsrc/usbip_common.h b/tools/usb/usbip/libsrc/usbip_common.h
index 824d5a5..86d21f2 100644
--- a/tools/usb/usbip/libsrc/usbip_common.h
+++ b/tools/usb/usbip/libsrc/usbip_common.h
@@ -115,6 +115,27 @@ struct usbip_usb_device {
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
diff --git a/tools/usb/usbip/libsrc/usbip_host_driver.c b/tools/usb/usbip/libsrc/usbip_host_driver.c
index bef08d5..f7c85da 100644
--- a/tools/usb/usbip/libsrc/usbip_host_driver.c
+++ b/tools/usb/usbip/libsrc/usbip_host_driver.c
@@ -221,7 +221,8 @@ int usbip_host_refresh_device_list(void)
 	return 0;
 }
 
-int usbip_host_export_device(struct usbip_exported_device *edev, int sockfd)
+int usbip_host_export_device(struct usbip_exported_device *edev,
+			     struct host_conf *conf)
 {
 	char attr_name[] = "usbip_sockfd";
 	char sockfd_attr_path[SYSFS_PATH_MAX];
@@ -247,7 +248,7 @@ int usbip_host_export_device(struct usbip_exported_device *edev, int sockfd)
 	snprintf(sockfd_attr_path, sizeof(sockfd_attr_path), "%s/%s",
 		 edev->udev.path, attr_name);
 
-	snprintf(sockfd_buff, sizeof(sockfd_buff), "%d\n", sockfd);
+	snprintf(sockfd_buff, sizeof(sockfd_buff), "%d\n", conf->sockfd);
 
 	ret = write_sysfs_attribute(sockfd_attr_path, sockfd_buff,
 				    strlen(sockfd_buff));
diff --git a/tools/usb/usbip/libsrc/usbip_host_driver.h b/tools/usb/usbip/libsrc/usbip_host_driver.h
index 2a31f85..ce4bd6f 100644
--- a/tools/usb/usbip/libsrc/usbip_host_driver.h
+++ b/tools/usb/usbip/libsrc/usbip_host_driver.h
@@ -43,7 +43,8 @@ int usbip_host_driver_open(void);
 void usbip_host_driver_close(void);
 
 int usbip_host_refresh_device_list(void);
-int usbip_host_export_device(struct usbip_exported_device *edev, int sockfd);
+int usbip_host_export_device(struct usbip_exported_device *edev,
+			     struct host_conf *conf);
 struct usbip_exported_device *usbip_host_get_device(int num);
 
 #endif /* __USBIP_HOST_DRIVER_H */
diff --git a/tools/usb/usbip/libsrc/vhci_driver.c b/tools/usb/usbip/libsrc/vhci_driver.c
index ad92047..c0928e2 100644
--- a/tools/usb/usbip/libsrc/vhci_driver.c
+++ b/tools/usb/usbip/libsrc/vhci_driver.c
@@ -298,8 +298,8 @@ int usbip_vhci_get_free_port(void)
 	return -1;
 }
 
-int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
-		uint32_t speed) {
+int usbip_vhci_attach_device(struct vhci_conf *conf)
+{
 	char buff[200]; /* what size should be ? */
 	char attach_attr_path[SYSFS_PATH_MAX];
 	char attr_attach[] = "attach";
@@ -307,7 +307,7 @@ int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
 	int ret;
 
 	snprintf(buff, sizeof(buff), "%u %d %u %u",
-			port, sockfd, devid, speed);
+			conf->port, conf->sockfd, conf->devid, conf->speed);
 	dbg("writing: %s", buff);
 
 	path = udev_device_get_syspath(vhci_driver->hc_device);
@@ -321,25 +321,16 @@ int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
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
 	char detach_attr_path[SYSFS_PATH_MAX];
diff --git a/tools/usb/usbip/libsrc/vhci_driver.h b/tools/usb/usbip/libsrc/vhci_driver.h
index fa2316c..20e6be4 100644
--- a/tools/usb/usbip/libsrc/vhci_driver.h
+++ b/tools/usb/usbip/libsrc/vhci_driver.h
@@ -45,15 +45,12 @@ int  usbip_vhci_refresh_device_list(void);
 
 
 int usbip_vhci_get_free_port(void);
-int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
-		uint32_t speed);
-
-/* will be removed */
-int usbip_vhci_attach_device(uint8_t port, int sockfd, uint8_t busnum,
-		uint8_t devnum, uint32_t speed);
+int usbip_vhci_attach_device(struct vhci_conf *conf);
 
 int usbip_vhci_detach_device(uint8_t port);
 
 int usbip_vhci_imported_device_dump(struct usbip_imported_device *idev);
 
+unsigned long get_devid(uint8_t busnum, uint8_t devnum);
+
 #endif /* __VHCI_DRIVER_H */
-- 
2.1.0

