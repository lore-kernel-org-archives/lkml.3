Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3LCOar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:30:47 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:60163 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab3LCO34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:29:56 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        haver@linux.vnet.ibm.com
Subject: [PATCH 5/6] GenWQE Sysfs interfaces
Date: Tue,  3 Dec 2013 15:28:22 +0100
Message-Id: <1386080903-27160-6-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1386080903-27160-1-git-send-email-haver@linux.vnet.ibm.com>
References: <1386080903-27160-1-git-send-email-haver@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120314-5024-0000-0000-000008047EAC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sysfs interfaces for the GenWQE card. There are attributes to query
the version of the bitstream as well as some for the driver. For
debugging, please also see the debugfs interfaces of this driver.

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
Co-authors: Joerg-Stephan Vogt <jsvogt@de.ibm.com>,
            Michael Jung <MIJUNG@de.ibm.com>,
            Michael Ruettger <michael@ibmra.de>
---
 Documentation/ABI/testing/sysfs-driver-genwqe |   50 +++++
 drivers/misc/genwqe/card_sysfs.c              |  260 +++++++++++++++++++++++++
 2 files changed, 310 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-genwqe
 create mode 100644 drivers/misc/genwqe/card_sysfs.c

diff --git a/Documentation/ABI/testing/sysfs-driver-genwqe b/Documentation/ABI/testing/sysfs-driver-genwqe
new file mode 100644
index 0000000..3e185bb
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-genwqe
@@ -0,0 +1,50 @@
+What:           /sys/class/genwqe/genwqe<n>_card/version
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Unique bitstream identification e.g.
+                '0000000330336283.00000000475a4950'.
+
+What:           /sys/class/genwqe/genwqe<n>_card/appid
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Identifies the currently active card application e.g. 'GZIP'
+                for compression/decompression.
+
+What:           /sys/class/genwqe/genwqe<n>_card/type
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Type of the card e.g. 'GenWQE5-A7'.
+
+What:           /sys/class/genwqe/genwqe<n>_card/curr_bitstream
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Currently active bitstream. 1 is default, 0 is backup.
+
+What:           /sys/class/genwqe/genwqe<n>_card/next_bitstream
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Interface to set the next bitstream to be used.
+
+What:           /sys/class/genwqe/genwqe<n>_card/tempsens
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Interface to read the cards temperature sense register.
+
+What:           /sys/class/genwqe/genwqe<n>_card/state
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    State of the card: "unused", "used", "error".
+
+What:           /sys/class/genwqe/genwqe<n>_card/base_clock
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Base clock frequency of the card.
+
+What:           /sys/class/genwqe/genwqe<n>_card/device/sriov_numvfs
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Enable VFs (1..15):
+                  sudo sh -c 'echo 15 > \
+                    /sys/bus/pci/devices/0000\:1b\:00.0/sriov_numvfs'
+                Disable VFs:
+                  Write a 0 into the same sysfs entry.
diff --git a/drivers/misc/genwqe/card_sysfs.c b/drivers/misc/genwqe/card_sysfs.c
new file mode 100644
index 0000000..02cd01a
--- /dev/null
+++ b/drivers/misc/genwqe/card_sysfs.c
@@ -0,0 +1,260 @@
+/**
+ * IBM Accelerator Family 'GenWQE'
+ *
+ * (C) Copyright IBM Corp. 2013
+ *
+ * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
+ * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
+ * Author: Michael Jung <mijung@de.ibm.com>
+ * Author: Michael Ruettger <michael@ibmra.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+/*
+ * Sysfs interfaces for the GenWQE card. There are attributes to query
+ * the version of the bitstream as well as some for the driver. For
+ * debugging, please also see the debugfs interfaces of this driver.
+ */
+
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/string.h>
+#include <linux/fs.h>
+#include <linux/sysfs.h>
+#include <linux/ctype.h>
+#include <linux/device.h>
+
+#include "card_base.h"
+#include "card_ddcb.h"
+
+static const char * const genwqe_types[] = {
+	[GENWQE_TYPE_ALTERA_230] = "GenWQE4-230",
+	[GENWQE_TYPE_ALTERA_530] = "GenWQE4-530",
+	[GENWQE_TYPE_ALTERA_A4]  = "GenWQE5-A4",
+	[GENWQE_TYPE_ALTERA_A7]  = "GenWQE5-A7",
+};
+
+static ssize_t status_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+	const char *cs[GENWQE_CARD_STATE_MAX] = { "unused", "used", "error" };
+
+	return sprintf(buf, "%s\n", cs[cd->card_state]);
+}
+static DEVICE_ATTR_RO(status);
+
+static ssize_t appid_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	char app_name[5];
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+
+	genwqe_read_app_id(cd, app_name, sizeof(app_name));
+	return sprintf(buf, "%s\n", app_name);
+}
+static DEVICE_ATTR_RO(appid);
+
+static ssize_t version_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	u64 slu_id, app_id;
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+
+	slu_id = __genwqe_readq(cd, IO_SLU_UNITCFG);
+	app_id = __genwqe_readq(cd, IO_APP_UNITCFG);
+
+	return sprintf(buf, "%016llx.%016llx\n", slu_id, app_id);
+}
+static DEVICE_ATTR_RO(version);
+
+static ssize_t type_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	u8 card_type;
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+
+	card_type = genwqe_card_type(cd);
+	return sprintf(buf, "%s\n", (card_type >= ARRAY_SIZE(genwqe_types)) ?
+		       "invalid" : genwqe_types[card_type]);
+}
+static DEVICE_ATTR_RO(type);
+
+static ssize_t driver_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	return sprintf(buf, "%s\n", DRV_VERS_STRING);
+}
+static DEVICE_ATTR_RO(driver);
+
+static ssize_t tempsens_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	u64 tempsens;
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+
+	tempsens = __genwqe_readq(cd, IO_SLU_TEMPERATURE_SENSOR);
+	return sprintf(buf, "%016llx\n", tempsens);
+}
+static DEVICE_ATTR_RO(tempsens);
+
+static ssize_t base_clock_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	u64 base_clock;
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+
+	base_clock = genwqe_base_clock_frequency(cd);
+	return sprintf(buf, "%lld\n", base_clock);
+}
+static DEVICE_ATTR_RO(base_clock);
+
+/**
+ * curr_bitstream_show() - Show the current bitstream id
+ *
+ * There is a bug in some old versions of the CPLD which selects the
+ * bitstream, which causes the IO_SLU_BITSTREAM register to report
+ * unreliable data in very rare cases. This makes this sysfs
+ * unreliable up to the point were a new CPLD version is being used.
+ *
+ * Unfortunately there is no automatic way yet to query the CPLD
+ * version, such that you need to manually ensure via programming
+ * tools that you have a recent version of the CPLD software.
+ *
+ * The proposed circumvention is to use a special recovery bitstream
+ * on the backup partition (0) to identify problems while loading the
+ * image.
+ */
+static ssize_t curr_bitstream_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	int curr_bitstream;
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+
+	curr_bitstream = __genwqe_readq(cd, IO_SLU_BITSTREAM) & 0x1;
+	return sprintf(buf, "%d\n", curr_bitstream);
+}
+static DEVICE_ATTR_RO(curr_bitstream);
+
+/**
+ * next_bitstream_show() - Show the next activated bitstream
+ *
+ * IO_SLC_CFGREG_SOFTRESET: This register can only be accessed by the PF.
+ */
+static ssize_t next_bitstream_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	int next_bitstream;
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+
+	switch ((cd->softreset & 0xc) >> 2) {
+	case 0x2:
+		next_bitstream =  0;
+		break;
+	case 0x3:
+		next_bitstream =  1;
+		break;
+	default:
+		next_bitstream = -1;
+		break;		/* error */
+	}
+	return sprintf(buf, "%d\n", next_bitstream);
+}
+
+static ssize_t next_bitstream_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	int partition;
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+
+	if (kstrtoint(buf, 0, &partition) < 0)
+		return -EINVAL;
+
+	switch (partition) {
+	case 0x0:
+		cd->softreset = 0x78;
+		break;
+	case 0x1:
+		cd->softreset = 0x7c;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	__genwqe_writeq(cd, IO_SLC_CFGREG_SOFTRESET, cd->softreset);
+	return count;
+}
+static DEVICE_ATTR_RW(next_bitstream);
+
+/*
+ * Create device_attribute structures / params: name, mode, show, store
+ * additional flag if valid in VF
+ */
+static struct attribute *genwqe_attributes[] = {
+	&dev_attr_tempsens.attr,
+	&dev_attr_next_bitstream.attr,
+	&dev_attr_curr_bitstream.attr,
+	&dev_attr_base_clock.attr,
+	&dev_attr_driver.attr,
+	&dev_attr_type.attr,
+	&dev_attr_version.attr,
+	&dev_attr_appid.attr,
+	&dev_attr_status.attr,
+	NULL,
+};
+
+static struct attribute *genwqe_normal_attributes[] = {
+	&dev_attr_driver.attr,
+	&dev_attr_type.attr,
+	&dev_attr_version.attr,
+	&dev_attr_appid.attr,
+	&dev_attr_status.attr,
+	NULL,
+};
+
+/**
+ * genwqe_is_visible() - Determine if sysfs attribute should be visible or not
+ *
+ * VFs have restricted mmio capabilities, so not all sysfs entries
+ * are allowed in VFs.
+ */
+static umode_t genwqe_is_visible(struct kobject *kobj,
+				 struct attribute *attr, int n)
+{
+	unsigned int j;
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+	umode_t mode = attr->mode;
+
+	if (genwqe_is_privileged(cd))
+		return mode;
+
+	for (j = 0; genwqe_normal_attributes[j] != NULL;  j++)
+		if (genwqe_normal_attributes[j] == attr)
+			return mode;
+
+	return 0;
+}
+
+static struct attribute_group genwqe_attribute_group = {
+	.is_visible = genwqe_is_visible,
+	.attrs      = genwqe_attributes,
+};
+
+const struct attribute_group *genwqe_attribute_groups[] = {
+	&genwqe_attribute_group,
+	NULL,
+};
-- 
1.7.1

