Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab3GRJpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 05:45:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35337 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831Ab3GRJpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 05:45:09 -0400
From: Oleksandr Kravchenko <x0199363@ti.com>
To: <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <jic23@cam.ac.uk>, <pmeerw@pmeerw.net>, <holler@ahsoftware.de>,
        <srinivas.pandruvada@intel.com>, <devicetree-discuss@lists.ozlabs.org>,
        <grygorii.strashko@ti.com>,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Subject: [PATCH 1/3] iio: core: implement devm_iio_device_alloc/devm_iio_device_free
Date: Thu, 18 Jul 2013 12:44:42 +0300
Message-ID: <1374140685-20549-1-git-send-email-x0199363@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

Add a resource managed devm_iio_device_alloc()/devm_iio_device_free()
to automatically clean up any allocations made by IIO drivers,
thus leading to simplified IIO drivers code.

In addition, this will allow IIO drivers to use other devm_*() API
(like devm_request_irq) and don't care about the race between
iio_device_free() and the release of resources by Device core
during driver removing.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
[o.v.kravchenko@globallogic.com: fix return value ib devm_iio_device_alloc
in case if devres_alloc failed, remove unused variable "rc"]
Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Tested-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
---
 drivers/iio/industrialio-core.c |   47 +++++++++++++++++++++++++++++++++++++++
 include/linux/iio/iio.h         |   25 +++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index e145931..d56d122 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -912,6 +912,53 @@ void iio_device_free(struct iio_dev *dev)
 }
 EXPORT_SYMBOL(iio_device_free);
 
+static void devm_iio_device_release(struct device *dev, void *res)
+{
+	iio_device_free(*(struct iio_dev **)res);
+}
+
+static int devm_iio_device_match(struct device *dev, void *res, void *data)
+{
+	struct iio_dev **r = res;
+	if (!r || !*r) {
+		WARN_ON(!r || !*r);
+		return 0;
+	}
+	return *r == data;
+}
+
+struct iio_dev *devm_iio_device_alloc(struct device *dev, int sizeof_priv)
+{
+	struct iio_dev **ptr, *iio_dev;
+
+	ptr = devres_alloc(devm_iio_device_release, sizeof(*ptr),
+			   GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	/* use raw alloc_dr for kmalloc caller tracing */
+	iio_dev = iio_device_alloc(sizeof_priv);
+	if (iio_dev) {
+		*ptr = iio_dev;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return iio_dev;
+}
+EXPORT_SYMBOL_GPL(devm_iio_device_alloc);
+
+void devm_iio_device_free(struct device *dev, struct iio_dev *iio_dev)
+{
+	int rc;
+
+	rc = devres_release(dev, devm_iio_device_release,
+			    devm_iio_device_match, iio_dev);
+	WARN_ON(rc);
+}
+EXPORT_SYMBOL_GPL(devm_iio_device_free);
+
 /**
  * iio_chrdev_open() - chrdev file open for buffer access and ioctls
  **/
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 8d171f4..f1d99f6 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -532,6 +532,31 @@ static inline struct iio_dev *iio_priv_to_dev(void *priv)
 void iio_device_free(struct iio_dev *indio_dev);
 
 /**
+ * devm_iio_device_alloc - Resource-managed iio_device_alloc()
+ * @dev: 		Device to allocate iio_dev for
+ * @sizeof_priv: 	Space to allocate for private structure.
+ *
+ * Managed iio_device_alloc.  iio_dev allocated with this function is
+ * automatically freed on driver detach.
+ *
+ * If an iio_dev allocated with this function needs to be freed separately,
+ * devm_iio_device_free() must be used.
+ *
+ * RETURNS:
+ * Pointer to allocated iio_dev on success, NULL on failure.
+ */
+struct iio_dev *devm_iio_device_alloc(struct device *dev, int sizeof_priv);
+
+/**
+ * devm_iio_device_free - Resource-managed iio_device_free()
+ * @dev:		Device this iio_dev belongs to
+ * @indio_dev: 		the iio_dev associated with the device
+ *
+ * Free indio_dev allocated with devm_iio_device_alloc().
+ */
+void devm_iio_device_free(struct device *dev, struct iio_dev *iio_dev);
+
+/**
  * iio_buffer_enabled() - helper function to test if the buffer is enabled
  * @indio_dev:		IIO device structure for device
  **/
-- 
1.7.9.5

