Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912Ab3CHIWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 03:22:52 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:62279 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab3CHIWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 03:22:46 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAEufOVFbdWOb/2dsb2JhbABDxE2BWBZ0giwBBSdAEhBRVwYTiBe7JY8MB4NAA5ZLiWaHC4MK
X-IPAS-Result: Av8EAEufOVFbdWOb/2dsb2JhbABDxE2BWBZ0giwBBSdAEhBRVwYTiBe7JY8MB4NAA5ZLiWaHC4MK
X-IronPort-AV: E=Sophos;i="4.84,806,1355094000"; 
   d="scan'208";a="9268300"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 3/3] ipack: split ipack_device_register() in several functions
Date: Fri,  8 Mar 2013 09:21:47 +0100
Message-Id: <1362730907-10047-3-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362730907-10047-1-git-send-email-siglesias@igalia.com>
References: <512DCB33.6030500@igalia.com>
 <1362730907-10047-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One function is ipack_device_init(). If it fails, the caller should execute
ipack_put_device().

The second function is ipack_device_add that only adds the device. If
it fails, the caller should execute ipack_put_device().

Then the device is removed with refcount = 0, as device_register() kernel
documentation says.

ipack_device_del() is added to remove the device.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/carriers/tpci200.c |   14 +++++++++++++-
 drivers/ipack/ipack.c            |   24 +++++++++++++----------
 include/linux/ipack.h            |   39 ++++++++++++++++++++++++++++----------
 3 files changed, 56 insertions(+), 21 deletions(-)

diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tpci200.c
index 0246b1f..c276fde 100644
--- a/drivers/ipack/carriers/tpci200.c
+++ b/drivers/ipack/carriers/tpci200.c
@@ -480,6 +480,7 @@ static void tpci200_release_device(struct ipack_device *dev)
 
 static int tpci200_create_device(struct tpci200_board *tpci200, int i)
 {
+	int ret;
 	enum ipack_space space;
 	struct ipack_device *dev =
 		kzalloc(sizeof(struct ipack_device), GFP_KERNEL);
@@ -495,7 +496,18 @@ static int tpci200_create_device(struct tpci200_board *tpci200, int i)
 			+ tpci200_space_interval[space] * i;
 		dev->region[space].size = tpci200_space_size[space];
 	}
-	return ipack_device_register(dev);
+
+	ret = ipack_device_init(dev);
+	if (ret < 0) {
+		ipack_put_device(dev);
+		return ret;
+	}
+
+	ret = ipack_device_add(dev);
+	if (ret < 0)
+		ipack_put_device(dev);
+
+	return ret;
 }
 
 static int tpci200_pci_probe(struct pci_dev *pdev,
diff --git a/drivers/ipack/ipack.c b/drivers/ipack/ipack.c
index bdac7f6..a26f371 100644
--- a/drivers/ipack/ipack.c
+++ b/drivers/ipack/ipack.c
@@ -228,7 +228,7 @@ static int ipack_unregister_bus_member(struct device *dev, void *data)
 	struct ipack_bus_device *bus = data;
 
 	if (idev->bus == bus)
-		ipack_device_unregister(idev);
+		ipack_device_del(idev);
 
 	return 1;
 }
@@ -420,7 +420,7 @@ out:
 	return ret;
 }
 
-int ipack_device_register(struct ipack_device *dev)
+int ipack_device_init(struct ipack_device *dev)
 {
 	int ret;
 
@@ -429,6 +429,7 @@ int ipack_device_register(struct ipack_device *dev)
 	dev->dev.parent = dev->bus->parent;
 	dev_set_name(&dev->dev,
 		     "ipack-dev.%u.%u", dev->bus->bus_nr, dev->slot);
+	device_initialize(&dev->dev);
 
 	if (dev->bus->ops->set_clockrate(dev, 8))
 		dev_warn(&dev->dev, "failed to switch to 8 MHz operation for reading of device ID.\n");
@@ -448,19 +449,22 @@ int ipack_device_register(struct ipack_device *dev)
 			dev_err(&dev->dev, "failed to switch to 32 MHz operation.\n");
 	}
 
-	ret = device_register(&dev->dev);
-	if (ret < 0)
-		kfree(dev->id);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipack_device_init);
 
-	return ret;
+int ipack_device_add(struct ipack_device *dev)
+{
+	return device_add(&dev->dev);
 }
-EXPORT_SYMBOL_GPL(ipack_device_register);
+EXPORT_SYMBOL_GPL(ipack_device_add);
 
-void ipack_device_unregister(struct ipack_device *dev)
+void ipack_device_del(struct ipack_device *dev)
 {
-	device_unregister(&dev->dev);
+	device_del(&dev->dev);
+	ipack_put_device(dev);
 }
-EXPORT_SYMBOL_GPL(ipack_device_unregister);
+EXPORT_SYMBOL_GPL(ipack_device_del);
 
 void ipack_get_device(struct ipack_device *dev)
 {
diff --git a/include/linux/ipack.h b/include/linux/ipack.h
index def91fd..1888e06 100644
--- a/include/linux/ipack.h
+++ b/include/linux/ipack.h
@@ -207,19 +207,38 @@ int ipack_driver_register(struct ipack_driver *edrv, struct module *owner,
 void ipack_driver_unregister(struct ipack_driver *edrv);
 
 /**
- *	ipack_device_register -- register an IPack device with the kernel
- *	@dev: the new device to register.
+ *	ipack_device_init -- initialize an IPack device
+ * @dev: the new device to initialize.
  *
- *	Register a new IPack device ("module" in IndustryPack jargon). The call
- *	is done by the carrier driver.  The carrier should populate the fields
- *	bus and slot as well as the region array of @dev prior to calling this
- *	function.  The rest of the fields will be allocated and populated
- *	during registration.
+ * Initialize a new IPack device ("module" in IndustryPack jargon). The call
+ * is done by the carrier driver.  The carrier should populate the fields
+ * bus and slot as well as the region array of @dev prior to calling this
+ * function.  The rest of the fields will be allocated and populated
+ * during initalization.
  *
- *	Return zero on success or error code on failure.
+ * Return zero on success or error code on failure.
+ *
+ * NOTE: _Never_ directly free @dev after calling this function, even
+ * if it returned an error! Always use ipack_put_device() to give up the
+ * reference initialized in this function instead.
+ */
+int ipack_device_init(struct ipack_device *dev);
+
+/**
+ *	ipack_device_add -- Add an IPack device
+ * @dev: the new device to add.
+ *
+ * Add a new IPack device. The call is done by the carrier driver
+ * after calling ipack_device_init().
+ *
+ * Return zero on success or error code on failure.
+ *
+ * NOTE: _Never_ directly free @dev after calling this function, even
+ * if it returned an error! Always use ipack_put_device() to give up the
+ * reference initialized in this function instead.
  */
-int ipack_device_register(struct ipack_device *dev);
-void ipack_device_unregister(struct ipack_device *dev);
+int ipack_device_add(struct ipack_device *dev);
+void ipack_device_del(struct ipack_device *dev);
 
 void ipack_get_device(struct ipack_device *dev);
 void ipack_put_device(struct ipack_device *dev);
-- 
1.7.10.4

