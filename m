Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbaJ2Sgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:36:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:24939 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177AbaJ2Sgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:36:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,278,1413270000"; 
   d="scan'208";a="613606129"
Subject: [RFC PATCH 5/5] libata: Enabling Solid State Hybrid Drives (SSHDs)
 based on SATA 3.2 standard
From: "Jason B. Akers" <jason.b.akers@intel.com>
To: linux-ide@vger.kernel.org
Cc: axboe@fb.com, kapil.karkra@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Oct 2014 11:24:10 -0700
Message-ID: <20141029182410.4879.57701.stgit@stg-AndroidDev-VirtualBox>
In-Reply-To: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
User-Agent: StGit/0.17.1-4-g4a0c1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason B. Akers <jason.b.akers@intel.com>

Augment the libata to add support for SSHDs--hard disks with a
small embedded NAND memory in them. The hybrid information feature is
part of the SATA standard 3.2 that specifies a way for host drivers to
pass hints to the drives over the SATA interface to guide the placement
of data on either the NAND or spindle. A new module libata-hybrid adds
the atomic methods to initialize and translate the ioprio to a SATA
hybrid hint according to a default table. This default table can be
overridden with a new table through the firmware_update. The new table
can be applied on a per ata_device basis. The reasoning is that the
translation can be optimized for Seagate SSHDs differently from Western
Digital SSHDs.

The feature remains disabled by default. The reason is that there are
two types of SSHDs—self hinted and host hinted. Both Seagate and
Western Digital make low-end self-hinted SSHDs that place data on the
embedded NAND or spindle based on their LBA hit rate determined by
their drive firmware. The higher-end (>16GB NAND) SSHDs provide hosts
with a mechanism to provide hints to the SSHDs. Also note that 25
consecutive power cycles with any hints in the SATA FISes will cause
the SSHD to turn off host hinting and switch back to self-hinting mode.
This patch issues a GET_HYBRID_LOG at start to prevent that from
happening. When the feature is enabled, by default, every IO is tagged
with the MAX-1 priority and SSHD simply implements the LRU policy.
Ionicing a specific App will emphasize or de-emphasize the hybrid hints

The current implementation toggles enable/disable when anything is
echoed to /sys/class/ata_device/devX.0/hybrid.

Signed-off-by: Kapil Karkra <kapil.karkra@intel.com>
Signed-off-by: Jason B. Akers <jason.b.akers@intel.com>
---
 drivers/ata/Makefile           |    2 
 drivers/ata/libata-core.c      |   13 ++
 drivers/ata/libata-eh.c        |   11 ++
 drivers/ata/libata-hybrid.c    |  261 ++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-hybrid.h    |   14 ++
 drivers/ata/libata-scsi.c      |    4 -
 drivers/ata/libata-transport.c |   45 +++++++
 drivers/ata/libata.h           |    2 
 include/linux/ata.h            |    1 
 include/linux/libata.h         |    4 +
 10 files changed, 351 insertions(+), 6 deletions(-)
 create mode 100644 drivers/ata/libata-hybrid.c
 create mode 100644 drivers/ata/libata-hybrid.h

diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index ae41107..0caf0a2 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -111,7 +111,7 @@ obj-$(CONFIG_ATA_GENERIC)	+= ata_generic.o
 # Should be last libata driver
 obj-$(CONFIG_PATA_LEGACY)	+= pata_legacy.o
 
-libata-y	:= libata-core.o libata-scsi.o libata-eh.o libata-transport.o
+libata-y	:= libata-core.o libata-scsi.o libata-eh.o libata-transport.o libata-hybrid.o
 libata-$(CONFIG_ATA_SFF)	+= libata-sff.o
 libata-$(CONFIG_SATA_PMP)	+= libata-pmp.o
 libata-$(CONFIG_ATA_ACPI)	+= libata-acpi.o
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c5ba15a..582acfb 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -72,6 +72,7 @@
 
 #include "libata.h"
 #include "libata-transport.h"
+#include "libata-hybrid.h"
 
 /* debounce timing parameters in msecs { interval, duration, timeout } */
 const unsigned long sata_deb_timing_normal[]		= {   5,  100, 2000 };
@@ -747,7 +748,7 @@ u64 ata_tf_read_block(struct ata_taskfile *tf, struct ata_device *dev)
  */
 int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 		    u64 block, u32 n_block, unsigned int tf_flags,
-		    unsigned int tag)
+		    unsigned int tag, unsigned int ata_hybrid_hint)
 {
 	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf->flags |= tf_flags;
@@ -775,6 +776,7 @@ int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 		tf->lbah = (block >> 16) & 0xff;
 		tf->lbam = (block >> 8) & 0xff;
 		tf->lbal = block & 0xff;
+		tf->auxiliary |= (ata_hybrid_hint << 16);
 
 		tf->device = ATA_LBA;
 		if (tf->flags & ATA_TFLAG_FUA)
@@ -2389,6 +2391,12 @@ int ata_dev_configure(struct ata_device *dev)
 				}
 		}
 
+		if (ata_id_has_hybrid_cap(dev->id)) {
+			dev->hybrid_cap = true;
+			initialize_hybrid_drive(dev);
+		} else
+			dev->hybrid_cap = false;
+
 		dev->cdb_len = 16;
 	}
 
@@ -4494,7 +4502,8 @@ unsigned int ata_dev_set_feature(struct ata_device *dev, u8 enable, u8 feature)
 	unsigned int err_mask;
 
 	/* set up set-features taskfile */
-	DPRINTK("set features - SATA features\n");
+	DPRINTK("set features port:%d enable:0x%X feature:0x%X\n",
+				dev->link->ap->print_id, enable, feature);
 
 	ata_tf_init(dev, &tf);
 	tf.command = ATA_CMD_SET_FEATURES;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index dad83df..ecf3503 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -47,6 +47,7 @@
 #include <linux/libata.h>
 
 #include "libata.h"
+#include "libata-hybrid.h"
 
 enum {
 	/* speed down verdicts */
@@ -3096,6 +3097,16 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 		if (ehc->i.flags & ATA_EHI_DID_RESET)
 			readid_flags |= ATA_READID_POSTRESET;
 
+		/* enable host hints or self-pinning depending on ehi flag */
+		if (ehc->i.flags & ATA_EHI_SET_HYBRID &&
+				dev->hybrid_cap && !dev->hybrid_en)
+			set_hybrid_enabled(dev, 1, 0);
+		else if (ehc->i.flags & ATA_EHI_SET_HYBRID &&
+				dev->hybrid_cap && dev->hybrid_en)
+			set_hybrid_enabled(dev, 0, 0);
+		pr_info("ehc iflags = 0x%X, hybrid_cap = %d, hybrid_en = %d\n",
+				ehc->i.flags, dev->hybrid_cap, dev->hybrid_en);
+
 		if ((action & ATA_EH_REVALIDATE) && ata_dev_enabled(dev)) {
 			WARN_ON(dev->class == ATA_DEV_PMP);
 
diff --git a/drivers/ata/libata-hybrid.c b/drivers/ata/libata-hybrid.c
new file mode 100644
index 0000000..86ee66c
--- /dev/null
+++ b/drivers/ata/libata-hybrid.c
@@ -0,0 +1,261 @@
+/*
+ * Copyright(c) 2013-2014 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/*
+ * Libata Hybrid Information Feature from SATA standard 3.2.
+ *
+ * This file contains the methods and associated data that augment libata to
+ * support hybrid information feature as defined by the SATA standard revision
+ * 3.2. This feature enables the libata to hint the Solid State Hybrid Drives
+ * (SSHDs) that have a small embedded NAND and a large magnetic media. The hint
+ * conveys to the SSHD what data to place on the NAND portion and what to place
+ * on the spindle.An accurate hinting will realize the potential of SSHDs by
+ * giving SSD like performance and a hard disk like capacity at a $5 adder to
+ * the hard drive cost.
+ *
+ * At initialization, initialize_hybrid_drive is invoked that based on
+ * the availability of hybrid feature, loads a translation table for the
+ * solid state hybrid drive (SSHD)--either the default or via the
+ * update_firmware mechanism. This is done once per ata_device because this
+ * translation could be different based on the performance/power
+ * characteristics of the SSHD.
+ *
+ * Hybrid information feature can be enabled or disabled via sysfs. The methods
+ * in this module eventually perform the enable/disable at the ata_device level
+ *
+ * The only method that invoked in the IO path is get_ata_hybrid_hint. This
+ * method references a look-up table to plug in the hybrid hint
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/spinlock.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/interrupt.h>
+#include <linux/completion.h>
+#include <linux/suspend.h>
+#include <linux/workqueue.h>
+#include <linux/scatterlist.h>
+#include <linux/io.h>
+#include <linux/ioprio.h>
+#include <linux/async.h>
+#include <linux/log2.h>
+#include <linux/slab.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <linux/libata.h>
+#include <asm/byteorder.h>
+#include <linux/cdrom.h>
+#include <linux/ratelimit.h>
+#include <linux/pm_runtime.h>
+#include <linux/platform_device.h>
+#include <linux/firmware.h>
+
+#include "libata.h"
+#include "libata-transport.h"
+#include "libata-hybrid.h"
+
+static unsigned int max_priority;
+
+struct hybrid_info_translation {
+	unsigned char signature[5];
+	unsigned char dont_disturb;
+	unsigned char normal;
+	unsigned char will_need;
+	unsigned char dont_need;
+	unsigned char evict;
+};
+
+static struct hybrid_info_translation translation = {
+	{"sshd"}, 0x00, 0x21, 0x21, 0x20, 0x20};
+
+unsigned int get_ata_hybrid_hint (struct ata_queued_cmd *qc)
+{
+	unsigned int ioprio =  qc->scsicmd->request->ioprio;
+	unsigned int ata_hybrid_hint = translation.normal;
+
+	if (ioprio_advice_valid(ioprio)) {
+		switch (IOPRIO_ADVICE(ioprio)) {
+		default:
+		break;
+		case IOPRIO_ADV_EVICT:
+		ata_hybrid_hint = translation.evict;
+		break;
+		case IOPRIO_ADV_DONTNEED:
+		ata_hybrid_hint = translation.dont_need;
+		break;
+		case IOPRIO_ADV_NORMAL:
+		ata_hybrid_hint = translation.normal;
+		break;
+		case IOPRIO_ADV_WILLNEED:
+		ata_hybrid_hint = translation.will_need;
+		break;
+		}
+	}
+
+	return ata_hybrid_hint;
+}
+
+unsigned int update_hybrid_info_translation_table(struct ata_device *dev)
+{
+	int i = 0;
+	const struct firmware *fw = NULL;
+	struct hybrid_info_translation *new_translation;
+	unsigned char *data;
+
+	i = request_firmware(&fw, HYBRID_INFO_TABLE_NAME, &dev->tdev);
+	if (i < 0) {
+		pr_debug("%s: request_firmware failed %x\n", __func__, i);
+		release_firmware(fw);
+		return 1;
+	}
+
+	new_translation = (struct hybrid_info_translation *)fw->data;
+
+	if (strncmp(new_translation->signature, "sshd", 4) != 0) {
+		pr_warn("%s: bad firmware signature %x\n", __func__, i);
+		release_firmware(fw);
+		return 1;
+	}
+
+	pr_info("old table={%x, %x, %x, %x, %x}\n",
+			translation.dont_disturb,
+			translation.normal,
+			translation.will_need,
+			translation.dont_need,
+			translation.evict);
+
+	data = (unsigned char *)&new_translation->dont_disturb;
+
+	for (i = 0; i < 5; i++)
+		data[i] = (data[i] & (0x20|max_priority));
+
+	pr_info("new table={%x, %x, %x, %x, %x}\n",
+			new_translation->dont_disturb,
+			new_translation->normal,
+			new_translation->will_need,
+			new_translation->dont_need,
+			new_translation->evict);
+
+	translation = *new_translation;
+	release_firmware(fw);
+
+	return 0;
+}
+
+unsigned int initialize_hybrid_drive(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->link->ap;
+	u8 *inBuff = ap->sector_buf;
+	int k;
+	unsigned int err_mask;
+	int nvmSize;
+
+	err_mask = ata_read_log_page(dev,
+				      0x14,
+				      0,
+				      inBuff,
+				      1);
+	if (err_mask)
+		ata_dev_dbg(dev,
+				"failed to get Hybrid Info Log, Emask 0x%x\n",
+				err_mask);
+	else {
+		pr_info("SATA hybrid information log:\n");
+		k = 0;
+		pr_info("Number of Hybrid Descriptors=%d\n",
+				inBuff[k]&0xF);
+		k = 2;
+
+		if (inBuff[k])
+			dev->hybrid_en = true;
+		else
+			dev->hybrid_en = false;
+
+		pr_info("Enabled=%x\n", inBuff[k++]);
+		pr_info("Hybrid Health =%x\n", inBuff[k++]);
+		pr_info("Dirty Low Threshold =%x\n", inBuff[k++]);
+		pr_info("Dirty High Threshold =%x\n", inBuff[k++]);
+		pr_info("Optimal Write Granularity=%x\n", inBuff[k++]);
+
+		max_priority = inBuff[k]&0xF;
+
+		pr_info("Maximum Priority Level=%d\n", inBuff[k++]&0xF);
+		k = 16;
+		nvmSize = (inBuff[k] | (inBuff[k+1]<<8) |
+			(inBuff[k+2]<<16) | (inBuff[k+3]<<24));
+		pr_info("NVM Size=%x(%d GigaBytes)\n",
+				nvmSize, nvmSize/(2*1024*1024));
+
+		for (k = 64; k < 512; k += 16) {
+			if (inBuff[k]) {
+				pr_info("Hybrid Priority=%d\n",
+						inBuff[k]);
+				pr_info("Consumed NVM Size Fraction=%x\n",
+						inBuff[k+1]);
+				pr_info("Consumed Map Res Fraction=%x\n",
+						inBuff[k+2]);
+				pr_info("Consumed Siz Drty Fraction=%x\n",
+						inBuff[k+3]);
+				pr_info("Consumed Map Res Drty Frtn=%x\n",
+						inBuff[k+4]);
+			}
+		}
+	}
+
+
+	/* Keep the feature disabled but update the translation table from the
+	 * user space
+	 */
+	return update_hybrid_info_translation_table(dev);
+}
+
+unsigned int hybrid_is_enabled(struct ata_device *dev)
+{
+	return dev->hybrid_en;
+}
+
+unsigned int set_hybrid_enabled(struct ata_device *dev, unsigned int value,
+			unsigned int count)
+{
+	if (value == 1) {
+		/*enable the hybrid information feature*/
+		if (!ata_dev_set_feature(dev, 0x10, 0xA))
+			dev->hybrid_en = true;
+		else
+			pr_warn("%s: Failed to set hybrid feature\n",
+				__func__);
+		dev->link->eh_info.flags &= ~ATA_EHI_SET_HYBRID;
+		return 0;
+	} else if (value == 0) {
+		/*disable the hybrid information feature*/
+		if (!ata_dev_set_feature(dev, 0x90, 0xA))
+			dev->hybrid_en = false;
+		else
+			pr_warn("%s: Failed to set hybrid feature\n",
+				__func__);
+
+		dev->link->eh_info.flags &= ~ATA_EHI_SET_HYBRID;
+		return 0;
+	}
+	return -EINVAL;
+}
diff --git a/drivers/ata/libata-hybrid.h b/drivers/ata/libata-hybrid.h
new file mode 100644
index 0000000..54cf2ae
--- /dev/null
+++ b/drivers/ata/libata-hybrid.h
@@ -0,0 +1,14 @@
+#ifndef _LIBATA_HYBRID_H
+#define _LIBATA_HYBRID_H
+
+#define HYBRID_INFO_TABLE_NAME		"hybrid_information_table.bin"
+
+unsigned int get_ata_hybrid_hint(struct ata_queued_cmd *qc);
+unsigned int update_hybrid_info_translation_table(struct ata_device *dev);
+unsigned int initialize_hybrid_drive(struct ata_device *dev);
+unsigned int hybrid_is_enabled(struct ata_device *dev);
+unsigned int set_hybrid_enabled(struct ata_device *dev,
+				unsigned int value, unsigned int count);
+#define ata_id_has_hybrid_cap(id)	((id)[ATA_ID_FEATURE_SUPP] & (1 << 9))
+#define ata_id_has_hybrid_en(id)	((id)[ATA_ID_FEATURE_EN] & (1 << 9))
+#endif
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0586f66..07f68ee 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -53,6 +53,7 @@
 
 #include "libata.h"
 #include "libata-transport.h"
+#include "libata-hybrid.h"
 
 #define ATA_SCSI_RBUF_SIZE	4096
 
@@ -1170,6 +1171,7 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 	blk_queue_flush_queueable(q, false);
 
 	dev->sdev = sdev;
+
 	return 0;
 }
 
@@ -1721,7 +1723,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 	qc->nbytes = n_block * scmd->device->sector_size;
 
 	rc = ata_build_rw_tf(&qc->tf, qc->dev, block, n_block, tf_flags,
-			     qc->tag);
+			     qc->tag, get_ata_hybrid_hint(qc));
 	if (likely(rc == 0))
 		return 0;
 
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index e37413228..7d4c221 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -36,10 +36,11 @@
 
 #include "libata.h"
 #include "libata-transport.h"
+#include "libata-hybrid.h"
 
 #define ATA_PORT_ATTRS		3
 #define ATA_LINK_ATTRS		3
-#define ATA_DEV_ATTRS		9
+#define ATA_DEV_ATTRS		10
 
 struct scsi_transport_template;
 struct scsi_transport_template *ata_scsi_transport_template;
@@ -559,6 +560,47 @@ show_ata_dev_gscr(struct device *dev,
 
 static DEVICE_ATTR(gscr, S_IRUGO, show_ata_dev_gscr, NULL);
 
+static ssize_t
+show_ata_dev_hybrid(struct device *dev,
+		  struct device_attribute *attr, char *buf)
+{
+	struct ata_device *ata_dev = transport_class_to_dev(dev);
+
+	scnprintf(buf, PAGE_SIZE, "%d\n", hybrid_is_enabled(ata_dev));
+	return sizeof(unsigned int);
+}
+
+static ssize_t
+store_ata_dev_hybrid(struct device *dev,
+		  struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ata_device *ata_dev = transport_class_to_dev(dev);
+	struct ata_port *ata_port = ata_dev->link->ap;
+	unsigned long flags;
+	unsigned int value;
+
+	if (kstrtouint(buf, 0, &value) < 0)
+		return -EINVAL;
+
+	spin_lock_irqsave(ata_port->lock, flags);
+	if (value == 0 || value == 1)
+		ata_dev->link->eh_info.flags |= ATA_EHI_SET_HYBRID;
+	else {
+		pr_warn("invalid hybrid value: use 1 or 0\n");
+		return -EINVAL;
+	}
+
+	pr_info("set dev->flags hybrid: 0x%X\n",
+				ata_dev->link->eh_context.i.flags);
+	ata_port_schedule_eh(ata_port);
+
+	spin_unlock_irqrestore(ata_port->lock, flags);
+	return count;
+}
+
+static DEVICE_ATTR(hybrid, S_IRUGO | S_IWUSR, show_ata_dev_hybrid,
+						store_ata_dev_hybrid);
+
 static DECLARE_TRANSPORT_CLASS(ata_dev_class,
 			       "ata_device", NULL, NULL, NULL);
 
@@ -732,6 +774,7 @@ struct scsi_transport_template *ata_attach_transport(void)
 	SETUP_DEV_ATTRIBUTE(ering);
 	SETUP_DEV_ATTRIBUTE(id);
 	SETUP_DEV_ATTRIBUTE(gscr);
+	SETUP_TEMPLATE(dev_attrs, hybrid, S_IRUGO | S_IWUGO, 1);
 	BUG_ON(count > ATA_DEV_ATTRS);
 	i->dev_attrs[count] = NULL;
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 5f4e0cc..3713bb5 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -66,7 +66,7 @@ extern u64 ata_tf_to_lba48(const struct ata_taskfile *tf);
 extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev);
 extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 			   u64 block, u32 n_block, unsigned int tf_flags,
-			   unsigned int tag);
+			   unsigned int tag, unsigned int ata_hybrid_hint);
 extern u64 ata_tf_read_block(struct ata_taskfile *tf, struct ata_device *dev);
 extern unsigned ata_exec_internal(struct ata_device *dev,
 				  struct ata_taskfile *tf, const u8 *cdb,
diff --git a/include/linux/ata.h b/include/linux/ata.h
index f2f4d8d..0f9d8b3 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -80,6 +80,7 @@ enum {
 	ATA_ID_SATA_CAPABILITY	= 76,
 	ATA_ID_SATA_CAPABILITY_2	= 77,
 	ATA_ID_FEATURE_SUPP	= 78,
+	ATA_ID_FEATURE_EN = 79,
 	ATA_ID_MAJOR_VER	= 80,
 	ATA_ID_COMMAND_SET_1	= 82,
 	ATA_ID_COMMAND_SET_2	= 83,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index bd5fefe..1c0d1cf 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -371,6 +371,7 @@ enum {
 	ATA_EHI_PRINTINFO	= (1 << 18), /* print configuration info */
 	ATA_EHI_SETMODE		= (1 << 19), /* configure transfer mode */
 	ATA_EHI_POST_SETMODE	= (1 << 20), /* revalidating after setmode */
+	ATA_EHI_SET_HYBRID	= (1 << 21), /* changing hybrid mode */
 
 	ATA_EHI_DID_RESET	= ATA_EHI_DID_SOFTRESET | ATA_EHI_DID_HARDRESET,
 
@@ -716,6 +717,9 @@ struct ata_device {
 	int			spdn_cnt;
 	/* ering is CLEAR_END, read comment above CLEAR_END */
 	struct ata_ering	ering;
+
+	bool		hybrid_cap;	/* device capable of hybrid hints */
+	bool		hybrid_en;	/* host hints enabled on device */
 };
 
 /* Fields between ATA_DEVICE_CLEAR_BEGIN and ATA_DEVICE_CLEAR_END are

