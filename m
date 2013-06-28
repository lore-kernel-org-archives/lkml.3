Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab3F1Tci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:32:38 -0400
Received: from mxout1.idt.com ([157.165.5.25]:42267 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab3F1TbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:31:04 -0400
X-Greylist: delayed 642 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jun 2013 15:30:57 EDT
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Andre van Herk <andre.van.herk@Prodrive.nl>,
        Micha Nelissen <micha.nelissen@Prodrive.nl>,
        Stef van Os <stef.van.os@Prodrive.nl>, Jean Delvare <jdelvare@suse.de>
Subject: [PATCH 6/7] rapidio: add udev notification
Date: Fri, 28 Jun 2013 15:18:55 -0400
Message-Id: <1372447136-5751-7-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1372447136-5751-1-git-send-email-alexandre.bounine@idt.com>
References: <1372447136-5751-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add RapidIO-specific modalias generation to enable udev notifications about
RapidIO-specific events.

The RapidIO modalias string format is shown below:

"rapidio:vNNNNdNNNNavNNNNadNNNN"

Where:
v  - Device Vendor ID (16 bit),
d  - Device ID (16 bit),
av - Assembly Vendor ID (16 bit),
ad - Assembly ID (16 bit),

as they are reported in corresponding Capability Registers (CARs)
of each RapidIO device.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
Cc: Stef van Os <stef.van.os@Prodrive.nl>
Cc: Jean Delvare <jdelvare@suse.de>
---
 drivers/rapidio/rio-driver.c      |   18 ++++++++++++++++++
 drivers/rapidio/rio-sysfs.c       |   10 ++++++++++
 include/linux/mod_devicetable.h   |   19 +++++++++++++++++++
 include/linux/rio.h               |   16 +---------------
 include/linux/rio_ids.h           |    2 --
 scripts/mod/devicetable-offsets.c |    6 ++++++
 scripts/mod/file2alias.c          |   20 ++++++++++++++++++++
 7 files changed, 74 insertions(+), 17 deletions(-)

diff --git a/drivers/rapidio/rio-driver.c b/drivers/rapidio/rio-driver.c
index a0c8755..3e9b6a7 100644
--- a/drivers/rapidio/rio-driver.c
+++ b/drivers/rapidio/rio-driver.c
@@ -199,6 +199,23 @@ static int rio_match_bus(struct device *dev, struct device_driver *drv)
       out:return 0;
 }
 
+static int rio_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	struct rio_dev *rdev;
+
+	if (!dev)
+		return -ENODEV;
+
+	rdev = to_rio_dev(dev);
+	if (!rdev)
+		return -ENODEV;
+
+	if (add_uevent_var(env, "MODALIAS=rapidio:v%04Xd%04Xav%04Xad%04X",
+			   rdev->vid, rdev->did, rdev->asm_vid, rdev->asm_did))
+		return -ENOMEM;
+	return 0;
+}
+
 struct device rio_bus = {
 	.init_name = "rapidio",
 };
@@ -210,6 +227,7 @@ struct bus_type rio_bus_type = {
 	.bus_attrs = rio_bus_attrs,
 	.probe = rio_device_probe,
 	.remove = rio_device_remove,
+	.uevent	= rio_uevent,
 };
 
 /**
diff --git a/drivers/rapidio/rio-sysfs.c b/drivers/rapidio/rio-sysfs.c
index 0c4473e..9331be6 100644
--- a/drivers/rapidio/rio-sysfs.c
+++ b/drivers/rapidio/rio-sysfs.c
@@ -84,6 +84,15 @@ static ssize_t lnext_show(struct device *dev,
 	return str - buf;
 }
 
+static ssize_t modalias_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct rio_dev *rdev = to_rio_dev(dev);
+
+	return sprintf(buf, "rapidio:v%04Xd%04Xav%04Xad%04X\n",
+		       rdev->vid, rdev->did, rdev->asm_vid, rdev->asm_did);
+}
+
 struct device_attribute rio_dev_attrs[] = {
 	__ATTR_RO(did),
 	__ATTR_RO(vid),
@@ -93,6 +102,7 @@ struct device_attribute rio_dev_attrs[] = {
 	__ATTR_RO(asm_rev),
 	__ATTR_RO(lprev),
 	__ATTR_RO(destid),
+	__ATTR_RO(modalias),
 	__ATTR_NULL,
 };
 
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index b508016..4b0ac9c 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -577,4 +577,23 @@ struct mei_cl_device_id {
 	kernel_ulong_t driver_info;
 };
 
+/* RapidIO */
+
+#define RIO_ANY_ID	0xffff
+
+/**
+ * struct rio_device_id - RIO device identifier
+ * @did: RapidIO device ID
+ * @vid: RapidIO vendor ID
+ * @asm_did: RapidIO assembly device ID
+ * @asm_vid: RapidIO assembly vendor ID
+ *
+ * Identifies a RapidIO device based on both the device/vendor IDs and
+ * the assembly device/vendor IDs.
+ */
+struct rio_device_id {
+	__u16 did, vid;
+	__u16 asm_did, asm_vid;
+};
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/include/linux/rio.h b/include/linux/rio.h
index 8d3db1b..e2faf7b 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -20,6 +20,7 @@
 #include <linux/errno.h>
 #include <linux/device.h>
 #include <linux/rio_regs.h>
+#include <linux/mod_devicetable.h>
 #ifdef CONFIG_RAPIDIO_DMA_ENGINE
 #include <linux/dmaengine.h>
 #endif
@@ -396,21 +397,6 @@ struct rio_driver {
 
 #define	to_rio_driver(drv) container_of(drv,struct rio_driver, driver)
 
-/**
- * struct rio_device_id - RIO device identifier
- * @did: RIO device ID
- * @vid: RIO vendor ID
- * @asm_did: RIO assembly device ID
- * @asm_vid: RIO assembly vendor ID
- *
- * Identifies a RIO device based on both the device/vendor IDs and
- * the assembly device/vendor IDs.
- */
-struct rio_device_id {
-	u16 did, vid;
-	u16 asm_did, asm_vid;
-};
-
 union rio_pw_msg {
 	struct {
 		u32 comptag;	/* Component Tag CSR */
diff --git a/include/linux/rio_ids.h b/include/linux/rio_ids.h
index b66d13d..2543bc1 100644
--- a/include/linux/rio_ids.h
+++ b/include/linux/rio_ids.h
@@ -13,8 +13,6 @@
 #ifndef LINUX_RIO_IDS_H
 #define LINUX_RIO_IDS_H
 
-#define RIO_ANY_ID			0xffff
-
 #define RIO_VID_FREESCALE		0x0002
 #define RIO_DID_MPC8560			0x0003
 
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index e66d4d2..bb5d115 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -177,5 +177,11 @@ int main(void)
 	DEVID(mei_cl_device_id);
 	DEVID_FIELD(mei_cl_device_id, name);
 
+	DEVID(rio_device_id);
+	DEVID_FIELD(rio_device_id, did);
+	DEVID_FIELD(rio_device_id, vid);
+	DEVID_FIELD(rio_device_id, asm_did);
+	DEVID_FIELD(rio_device_id, asm_vid);
+
 	return 0;
 }
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 45f9a33..d9e67b7 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1145,6 +1145,26 @@ static int do_mei_entry(const char *filename, void *symval,
 }
 ADD_TO_DEVTABLE("mei", mei_cl_device_id, do_mei_entry);
 
+/* Looks like: rapidio:vNdNavNadN */
+static int do_rio_entry(const char *filename,
+			void *symval, char *alias)
+{
+	DEF_FIELD(symval, rio_device_id, did);
+	DEF_FIELD(symval, rio_device_id, vid);
+	DEF_FIELD(symval, rio_device_id, asm_did);
+	DEF_FIELD(symval, rio_device_id, asm_vid);
+
+	strcpy(alias, "rapidio:");
+	ADD(alias, "v", vid != RIO_ANY_ID, vid);
+	ADD(alias, "d", did != RIO_ANY_ID, did);
+	ADD(alias, "av", asm_vid != RIO_ANY_ID, asm_vid);
+	ADD(alias, "ad", asm_did != RIO_ANY_ID, asm_did);
+
+	add_wildcard(alias);
+	return 1;
+}
+ADD_TO_DEVTABLE("rapidio", rio_device_id, do_rio_entry);
+
 /* Does namelen bytes of name exactly match the symbol? */
 static bool sym_is(const char *name, unsigned namelen, const char *symbol)
 {
-- 
1.7.8.4

