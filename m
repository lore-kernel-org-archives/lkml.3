Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3JSOjX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 10:39:23 -0400
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:53332 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803Ab3JSOjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org,>);
	Sat, 19 Oct 2013 10:39:20 -0400
X-RRZE-Submit-IP: 212.255.122.85
From: Dominik Paulus <dominik.paulus@fau.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dominik Paulus <dominik.paulus@fau.de>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anthony Foiani <anthony.foiani@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de, linux-kernel@vger.kernel.org,
        tobias.polzer@fau.de, Ilija Hadzic <ihadzic@research.bell-labs.com>
Subject: [PATCHv4 02/16] staging: usbip: Add kernel support for client ACLs
Date: Sat, 19 Oct 2013 16:39:05 +0200
Message-Id: <1382193559-12549-3-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382193559-12549-1-git-send-email-dominik.paulus@fau.de>
References: <20130930123821.GI6192@mwanda>
 <1382193559-12549-1-git-send-email-dominik.paulus@fau.de>
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
 drivers/staging/usbip/stub.h     |  5 ++++
 drivers/staging/usbip/stub_dev.c | 61 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 65 insertions(+), 1 deletion(-)

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
index 76a1ff0..0e33542 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -142,6 +142,56 @@ err:
 }
 static DEVICE_ATTR(usbip_sockfd, S_IWUSR, NULL, store_sockfd);
 
+/*
+ * This function replaces the current ACL list
+ */
+static ssize_t store_acl(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct stub_device *sdev = dev_get_drvdata(dev);
+	int retval;
+
+	if (count >= PAGE_SIZE)
+		return -EINVAL;
+
+	spin_lock_irq(&sdev->ip_lock);
+	kfree(sdev->acls);
+	sdev->acls = kstrdup(buf, GFP_KERNEL);
+	if (!sdev->acls) {
+		retval = -ENOMEM;
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
+	int retval;
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
@@ -157,9 +207,13 @@ static int stub_add_files(struct device *dev)
 	err = device_create_file(dev, &dev_attr_usbip_debug);
 	if (err)
 		goto err_debug;
+	err = device_create_file(dev, &dev_attr_usbip_acl);
+	if (err)
+		goto err_acl;
 
 	return 0;
-
+err_acl:
+	device_remove_file(dev, &dev_attr_usbip_debug);
 err_debug:
 	device_remove_file(dev, &dev_attr_usbip_sockfd);
 err_sockfd:
@@ -173,6 +227,7 @@ static void stub_remove_files(struct device *dev)
 	device_remove_file(dev, &dev_attr_usbip_status);
 	device_remove_file(dev, &dev_attr_usbip_sockfd);
 	device_remove_file(dev, &dev_attr_usbip_debug);
+	device_remove_file(dev, &dev_attr_usbip_acl);
 }
 
 static void stub_shutdown_connection(struct usbip_device *ud)
@@ -312,6 +367,7 @@ static struct stub_device *stub_device_alloc(struct usb_device *udev,
 	INIT_LIST_HEAD(&sdev->priv_free);
 	INIT_LIST_HEAD(&sdev->unlink_free);
 	INIT_LIST_HEAD(&sdev->unlink_tx);
+	spin_lock_init(&sdev->ip_lock);
 	spin_lock_init(&sdev->priv_lock);
 
 	init_waitqueue_head(&sdev->tx_waitq);
@@ -511,6 +567,9 @@ static void stub_disconnect(struct usb_interface *interface)
 	usb_put_dev(sdev->udev);
 	usb_put_intf(interface);
 
+	/* free ACL list */
+	kfree(sdev->acls);
+
 	/* free sdev */
 	busid_priv->sdev = NULL;
 	stub_device_free(sdev);
-- 
1.8.4.1

