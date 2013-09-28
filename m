Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3I1Rn2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 13:43:28 -0400
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:56721 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754473Ab3I1RnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 13:43:24 -0400
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
Subject: [PATCHv3  02/16] staging: usbip: Add kernel support for client ACLs
Date: Sat, 28 Sep 2013 19:42:39 +0200
Message-Id: <1380390173-3746-2-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380390173-3746-1-git-send-email-dominik.paulus@fau.de>
References: <20130925233638.GA21396@kroah.com>
 <1380390173-3746-1-git-send-email-dominik.paulus@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the possibility to stored ACLs for allowed clients for
each stub device in sysfs. It adds a new sysfs entry called "usbip_acl"
for each stub device, containing a list of CIDR masks of allowed
clients. This file will be used by usbip and usbipd to store the ACL.

Signed-off-by: Kurt Kanzenbach <ly80toro@cip.cs.fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 drivers/staging/usbip/stub.h     |  5 +++
 drivers/staging/usbip/stub_dev.c | 68 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/usbip/stub.h b/drivers/staging/usbip/stub.h
index a73e437..cfe75d1 100644
--- a/drivers/staging/usbip/stub.h
+++ b/drivers/staging/usbip/stub.h
@@ -60,6 +60,11 @@ struct stub_device {
 	struct list_head unlink_free;
 
 	wait_queue_head_t tx_waitq;
+
+	/* list of allowed IP addrs */
+	char *acls;
+	/* for locking list operations */
+	spinlock_t ip_lock;
 };
 
 /* private data into urb->priv */
diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index 76a1ff0..3939b60 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -142,6 +142,62 @@ err:
 }
 static DEVICE_ATTR(usbip_sockfd, S_IWUSR, NULL, store_sockfd);
 
+/*
+ * This function replaces the current ACL list
+ */
+static ssize_t store_acl(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct stub_device *sdev = dev_get_drvdata(dev);
+	int retval = 0;
+
+	if (!sdev)
+		return -ENODEV;
+
+	if (count >= PAGE_SIZE)
+		/* Prevent storing oversized ACLs in kernel memory */
+		return -EINVAL;
+
+	/* Store ACL */
+	spin_lock_irq(&sdev->ip_lock);
+	kfree(sdev->acls);
+	sdev->acls = kstrdup(buf, GFP_KERNEL);
+	if (IS_ERR(sdev->acls)) {
+		retval = PTR_ERR(sdev->acls);
+		sdev->acls = NULL;
+	} else {
+		retval = strlen(sdev->acls);
+	}
+	spin_unlock_irq(&sdev->ip_lock);
+
+	return retval;
+}
+
+/*
+ * This functions prints all allowed IP addrs for this dev
+ */
+static ssize_t show_acl(struct device *dev, struct device_attribute *attr,
+		       char *buf)
+{
+	struct stub_device *sdev = dev_get_drvdata(dev);
+	int retval = 0;
+
+	if (!sdev)
+		return -ENODEV;
+
+	spin_lock_irq(&sdev->ip_lock);
+	if (sdev->acls == NULL) {
+		retval = 0;
+	} else {
+		strcpy(buf, sdev->acls);
+		retval = strlen(buf);
+	}
+	spin_unlock_irq(&sdev->ip_lock);
+
+	return retval;
+}
+static DEVICE_ATTR(usbip_acl, S_IWUSR | S_IRUGO, show_acl, store_acl);
+
 static int stub_add_files(struct device *dev)
 {
 	int err = 0;
@@ -157,9 +213,13 @@ static int stub_add_files(struct device *dev)
 	err = device_create_file(dev, &dev_attr_usbip_debug);
 	if (err)
 		goto err_debug;
+	err = device_create_file(dev, &dev_attr_usbip_acl);
+	if (err)
+		goto err_ip;
 
 	return 0;
-
+err_ip:
+	device_remove_file(dev, &dev_attr_usbip_debug);
 err_debug:
 	device_remove_file(dev, &dev_attr_usbip_sockfd);
 err_sockfd:
@@ -173,6 +233,7 @@ static void stub_remove_files(struct device *dev)
 	device_remove_file(dev, &dev_attr_usbip_status);
 	device_remove_file(dev, &dev_attr_usbip_sockfd);
 	device_remove_file(dev, &dev_attr_usbip_debug);
+	device_remove_file(dev, &dev_attr_usbip_acl);
 }
 
 static void stub_shutdown_connection(struct usbip_device *ud)
@@ -306,12 +367,14 @@ static struct stub_device *stub_device_alloc(struct usb_device *udev,
 	sdev->ud.status		= SDEV_ST_AVAILABLE;
 	spin_lock_init(&sdev->ud.lock);
 	sdev->ud.tcp_socket	= NULL;
+	sdev->acls = NULL;
 
 	INIT_LIST_HEAD(&sdev->priv_init);
 	INIT_LIST_HEAD(&sdev->priv_tx);
 	INIT_LIST_HEAD(&sdev->priv_free);
 	INIT_LIST_HEAD(&sdev->unlink_free);
 	INIT_LIST_HEAD(&sdev->unlink_tx);
+	spin_lock_init(&sdev->ip_lock);
 	spin_lock_init(&sdev->priv_lock);
 
 	init_waitqueue_head(&sdev->tx_waitq);
@@ -511,6 +574,9 @@ static void stub_disconnect(struct usb_interface *interface)
 	usb_put_dev(sdev->udev);
 	usb_put_intf(interface);
 
+	/* free ACL list */
+	kfree(sdev->acls);
+
 	/* free sdev */
 	busid_priv->sdev = NULL;
 	stub_device_free(sdev);
-- 
1.8.4

