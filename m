Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab3HURxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:53:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:32339 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab3HURw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:52:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,929,1367996400"; 
   d="scan'208";a="366352459"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        Asias He <asias@redhat.com>
Cc: Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH v3 3/7] Intel MIC Host Driver, card OS state management.
Date: Wed, 21 Aug 2013 10:52:33 -0700
Message-Id: <2ca5d48eff4605b98b22450e22b4ca0a09292b31.1377104309.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1377104309.git.sudeep.dutt@intel.com>
References: <cover.1377104309.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1377104309.git.sudeep.dutt@intel.com>
References: <cover.1377104309.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the following features:
a) Boots and shuts down the card via sysfs entries.
b) Allocates and maps a device page for communication with the
   card driver and updates the device page address via scratchpad
   registers.
c) Provides sysfs entries for shutdown status, kernel command line,
   ramdisk and log buffer information.

Co-author: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Caz Yokoyama <Caz.Yokoyama@intel.com>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Signed-off-by: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
Acked-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Reviewed-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
---
 Documentation/ABI/testing/sysfs-class-mic.txt | 113 ++++++++
 drivers/misc/mic/common/mic_device.h          |   7 +
 drivers/misc/mic/host/Makefile                |   2 +
 drivers/misc/mic/host/mic_boot.c              | 184 +++++++++++++
 drivers/misc/mic/host/mic_debugfs.c           | 356 ++++++++++++++++++++++++
 drivers/misc/mic/host/mic_device.h            |  60 +++++
 drivers/misc/mic/host/mic_main.c              | 129 ++++++++-
 drivers/misc/mic/host/mic_sysfs.c             | 371 ++++++++++++++++++++++++++
 drivers/misc/mic/host/mic_x100.c              | 251 +++++++++++++++++
 drivers/misc/mic/host/mic_x100.h              |  12 +
 include/uapi/linux/Kbuild                     |   1 +
 include/uapi/linux/mic_common.h               |  74 +++++
 12 files changed, 1556 insertions(+), 4 deletions(-)
 create mode 100644 drivers/misc/mic/host/mic_boot.c
 create mode 100644 drivers/misc/mic/host/mic_debugfs.c
 create mode 100644 include/uapi/linux/mic_common.h

diff --git a/Documentation/ABI/testing/sysfs-class-mic.txt b/Documentation/ABI/testing/sysfs-class-mic.txt
index 09eb3c6..82cdad3 100644
--- a/Documentation/ABI/testing/sysfs-class-mic.txt
+++ b/Documentation/ABI/testing/sysfs-class-mic.txt
@@ -32,3 +32,116 @@ Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
 Description:
 		Provides information about the silicon stepping for an Intel
 		MIC device. For example - "A0" or "B0"
+
+What:		/sys/class/mic/mic(x)/state
+Date:		August 2013
+KernelVersion:	3.11
+Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
+Description:
+		When read, this entry provides the current state of an Intel
+		MIC device in the context of the card OS. Possible values that
+		will be read are:
+		"offline" - The MIC device is ready to boot the card OS.
+		"online" - The MIC device has initiated booting a card OS.
+		"shutting_down" - The card OS is shutting down.
+		"reset_failed" - The MIC device has failed to reset.
+
+		When written, this sysfs entry triggers different state change
+		operations depending upon the current state of the card OS.
+		Acceptable values are:
+		"boot" - Boot the card OS image specified by the combination
+			 of firmware, ramdisk, cmdline and bootmode
+			sysfs entries.
+		"reset" - Initiates device reset.
+		"shutdown" - Initiates card OS shutdown.
+
+What:		/sys/class/mic/mic(x)/shutdown_status
+Date:		August 2013
+KernelVersion:	3.11
+Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
+Description:
+		An Intel MIC device runs a Linux OS during its operation. This
+		OS can shutdown because of various reasons. When read, this
+		entry provides the status on why the card OS was shutdown.
+		Possible values are:
+		"nop" -  shutdown status is not applicable, when the card OS is
+			"online"
+		"crashed" - Shutdown because of a HW or SW crash.
+		"halted" - Shutdown because of a halt command.
+		"poweroff" - Shutdown because of a poweroff command.
+		"restart" - Shutdown because of a restart command.
+
+What:		/sys/class/mic/mic(x)/cmdline
+Date:		August 2013
+KernelVersion:	3.11
+Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
+Description:
+		An Intel MIC device runs a Linux OS during its operation. Before
+		booting this card OS, it is possible to pass kernel command line
+		options to configure various features in it, similar to
+		self-bootable machines. When read, this entry provides
+		information about the current kernel command line options set to
+		boot the card OS. This entry can be written to change the
+		existing kernel command line options. Typically, the user would
+		want to read the current command line options, append new ones
+		or modify existing ones and then write the whole kernel command
+		line back to this entry.
+
+What:		/sys/class/mic/mic(x)/firmware
+Date:		August 2013
+KernelVersion:	3.11
+Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
+Description:
+		When read, this sysfs entry provides the path name under
+		/lib/firmware/ where the firmware image to be booted on the
+		card can be found. The entry can be written to change the
+		firmware image location under /lib/firmware/.
+
+What:		/sys/class/mic/mic(x)/ramdisk
+Date:		August 2013
+KernelVersion:	3.11
+Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
+Description:
+		When read, this sysfs entry provides the path name under
+		/lib/firmware/ where the ramdisk image to be used during card
+		OS boot can be found. The entry can be written to change
+		the ramdisk image location under /lib/firmware/.
+
+What:		/sys/class/mic/mic(x)/bootmode
+Date:		August 2013
+KernelVersion:	3.11
+Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
+Description:
+		When read, this sysfs entry provides the current bootmode for
+		the card. This sysfs entry can be written with the following
+		valid strings:
+		a) linux - Boot a Linux image.
+		b) elf - Boot an elf image for flash updates.
+
+What:		/sys/class/mic/mic(x)/log_buf_addr
+Date:		August 2013
+KernelVersion:	3.11
+Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
+Description:
+		An Intel MIC device runs a Linux OS during its operation. For
+		debugging purpose and early kernel boot messages, the user can
+		access the card OS log buffer via debugfs. When read, this entry
+		provides the kernel virtual address of the buffer where the card
+		OS log buffer can be read. This entry is written by the host
+		configuration daemon to set the log buffer address. The correct
+		log buffer address to be written can be found in the System.map
+		file of the card OS.
+
+What:		/sys/class/mic/mic(x)/log_buf_len
+Date:		August 2013
+KernelVersion:	3.11
+Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
+Description:
+		An Intel MIC device runs a Linux OS during its operation. For
+		debugging purpose and early kernel boot messages, the user can
+		access the card OS log buffer via debugfs. When read, this entry
+		provides the kernel virtual address where the card OS log buffer
+		length can be read. This entry is written by host configuration
+		daemon to set the log buffer length address. The correct log
+		buffer length address to be written can be found in the
+		System.map file of the card OS.
diff --git a/drivers/misc/mic/common/mic_device.h b/drivers/misc/mic/common/mic_device.h
index f02262e..6440e9d 100644
--- a/drivers/misc/mic/common/mic_device.h
+++ b/drivers/misc/mic/common/mic_device.h
@@ -34,4 +34,11 @@ struct mic_mw {
 	resource_size_t len;
 };
 
+/*
+ * Scratch pad register offsets used by the host to communicate
+ * device page DMA address to the card.
+ */
+#define MIC_DPLO_SPAD 14
+#define MIC_DPHI_SPAD 15
+
 #endif
diff --git a/drivers/misc/mic/host/Makefile b/drivers/misc/mic/host/Makefile
index 3702d2a..98bf565 100644
--- a/drivers/misc/mic/host/Makefile
+++ b/drivers/misc/mic/host/Makefile
@@ -7,3 +7,5 @@ mic_host-objs := mic_main.o
 mic_host-objs += mic_x100.o
 mic_host-objs += mic_sysfs.o
 mic_host-objs += mic_smpt.o
+mic_host-objs += mic_boot.o
+mic_host-objs += mic_debugfs.o
diff --git a/drivers/misc/mic/host/mic_boot.c b/drivers/misc/mic/host/mic_boot.c
new file mode 100644
index 0000000..936fc58
--- /dev/null
+++ b/drivers/misc/mic/host/mic_boot.c
@@ -0,0 +1,184 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/interrupt.h>
+
+#include <linux/mic_common.h>
+#include "../common/mic_device.h"
+#include "mic_device.h"
+#include "mic_smpt.h"
+
+/**
+ * mic_reset - Reset the MIC device.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_reset(struct mic_device *mdev)
+{
+	int i;
+
+#define MIC_RESET_TO (45)
+
+	mdev->ops->reset_fw_ready(mdev);
+	mdev->ops->reset(mdev);
+
+	for (i = 0; i < MIC_RESET_TO; i++) {
+		if (mdev->ops->is_fw_ready(mdev))
+			return;
+		/*
+		 * Resets typically take 10s of seconds to complete.
+		 * Since an MMIO read is required to check if the
+		 * firmware is ready or not, a 1 second delay works nicely.
+		 */
+		msleep(1000);
+	}
+	mic_set_state(mdev, MIC_RESET_FAILED);
+}
+
+/* Initialize the MIC bootparams */
+void mic_bootparam_init(struct mic_device *mdev)
+{
+	struct mic_bootparam *bootparam = mdev->dp;
+
+	bootparam->magic = MIC_MAGIC;
+	bootparam->c2h_shutdown_db = mdev->shutdown_db;
+	bootparam->h2c_shutdown_db = -1;
+	bootparam->h2c_config_db = -1;
+	bootparam->shutdown_status = 0;
+	bootparam->shutdown_card = 0;
+}
+
+/**
+ * mic_start - Start the MIC.
+ * @mdev: pointer to mic_device instance
+ * @buf: buffer containing boot string including firmware/ramdisk path.
+ *
+ * This function prepares an MIC for boot and initiates boot.
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+int mic_start(struct mic_device *mdev, const char *buf)
+{
+	int rc;
+	mutex_lock(&mdev->mic_mutex);
+retry:
+	if (MIC_OFFLINE != mdev->state) {
+		rc = -EINVAL;
+		goto unlock_ret;
+	}
+	if (!mdev->ops->is_fw_ready(mdev)) {
+		mic_reset(mdev);
+		/*
+		 * The state will either be MIC_OFFLINE if the reset succeeded
+		 * or MIC_RESET_FAILED if the firmware reset failed.
+		 */
+		goto retry;
+	}
+	rc = mdev->ops->load_mic_fw(mdev, buf);
+	if (rc)
+		goto unlock_ret;
+	mic_smpt_restore(mdev);
+	mic_intr_restore(mdev);
+	mdev->intr_ops->enable_interrupts(mdev);
+	mdev->ops->write_spad(mdev, MIC_DPLO_SPAD, mdev->dp_dma_addr);
+	mdev->ops->write_spad(mdev, MIC_DPHI_SPAD, mdev->dp_dma_addr >> 32);
+	mdev->ops->send_firmware_intr(mdev);
+	mic_set_state(mdev, MIC_ONLINE);
+unlock_ret:
+	mutex_unlock(&mdev->mic_mutex);
+	return rc;
+}
+
+/**
+ * mic_stop - Prepare the MIC for reset and trigger reset.
+ * @mdev: pointer to mic_device instance
+ * @force: force a MIC to reset even if it is already offline.
+ *
+ * RETURNS: None.
+ */
+void mic_stop(struct mic_device *mdev, bool force)
+{
+	mutex_lock(&mdev->mic_mutex);
+	if (MIC_OFFLINE != mdev->state || force) {
+		mic_bootparam_init(mdev);
+		mic_reset(mdev);
+		if (MIC_RESET_FAILED == mdev->state)
+			goto unlock;
+		mic_set_shutdown_status(mdev, MIC_NOP);
+		mic_set_state(mdev, MIC_OFFLINE);
+	}
+unlock:
+	mutex_unlock(&mdev->mic_mutex);
+}
+
+/**
+ * mic_shutdown - Initiate MIC shutdown.
+ * @mdev: pointer to mic_device instance
+ *
+ * RETURNS: None.
+ */
+void mic_shutdown(struct mic_device *mdev)
+{
+	struct mic_bootparam *bootparam = mdev->dp;
+	s8 db = bootparam->h2c_shutdown_db;
+
+	mutex_lock(&mdev->mic_mutex);
+	if (MIC_ONLINE == mdev->state && db != -1) {
+		bootparam->shutdown_card = 1;
+		mdev->ops->send_intr(mdev, db);
+		mic_set_state(mdev, MIC_SHUTTING_DOWN);
+	}
+	mutex_unlock(&mdev->mic_mutex);
+}
+
+/**
+ * mic_shutdown_work - Handle shutdown interrupt from MIC.
+ * @work: The work structure.
+ *
+ * This work is scheduled whenever the host has received a shutdown
+ * interrupt from the MIC.
+ */
+void mic_shutdown_work(struct work_struct *work)
+{
+	struct mic_device *mdev = container_of(work, struct mic_device,
+			shutdown_work);
+	struct mic_bootparam *bootparam = mdev->dp;
+
+	mutex_lock(&mdev->mic_mutex);
+	mic_set_shutdown_status(mdev, bootparam->shutdown_status);
+	bootparam->shutdown_status = 0;
+	if (MIC_SHUTTING_DOWN != mdev->state)
+		mic_set_state(mdev, MIC_SHUTTING_DOWN);
+	mutex_unlock(&mdev->mic_mutex);
+}
+
+/**
+ * mic_reset_trigger_work - Trigger MIC reset.
+ * @work: The work structure.
+ *
+ * This work is scheduled whenever the host wants to reset the MIC.
+ */
+void mic_reset_trigger_work(struct work_struct *work)
+{
+	struct mic_device *mdev = container_of(work, struct mic_device,
+			reset_trigger_work);
+
+	mic_stop(mdev, false);
+}
diff --git a/drivers/misc/mic/host/mic_debugfs.c b/drivers/misc/mic/host/mic_debugfs.c
new file mode 100644
index 0000000..904374e
--- /dev/null
+++ b/drivers/misc/mic/host/mic_debugfs.c
@@ -0,0 +1,356 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#include <linux/debugfs.h>
+#include <linux/pci.h>
+#include <linux/seq_file.h>
+
+#include <linux/mic_common.h>
+#include "../common/mic_device.h"
+#include "mic_device.h"
+#include "mic_x100.h"
+#include "mic_smpt.h"
+
+/* Debugfs parent dir */
+static struct dentry *mic_dbg;
+
+/**
+ * mic_log_buf_show - Display MIC kernel log buffer.
+ *
+ * log_buf addr/len is read from System.map by user space
+ * and populated in sysfs entries.
+ */
+static int mic_log_buf_show(struct seq_file *s, void *unused)
+{
+	void __iomem *log_buf_va;
+	int __iomem *log_buf_len_va;
+	struct mic_device *mdev = s->private;
+	void *kva;
+	int size;
+	unsigned long aper_offset;
+
+	if (!mdev || !mdev->log_buf_addr || !mdev->log_buf_len)
+		goto done;
+	/*
+	 * Card kernel will never be relocated and any kernel text/data mapping
+	 * can be translated to phys address by subtracting __START_KERNEL_map.
+	 */
+	aper_offset = (unsigned long)mdev->log_buf_len - __START_KERNEL_map;
+	log_buf_len_va = mdev->aper.va + aper_offset;
+	aper_offset = (unsigned long)mdev->log_buf_addr - __START_KERNEL_map;
+	log_buf_va = mdev->aper.va + aper_offset;
+	size = ioread32(log_buf_len_va);
+
+	kva = kmalloc(size, GFP_KERNEL);
+	if (!kva)
+		goto done;
+	mutex_lock(&mdev->mic_mutex);
+	memcpy_fromio(kva, log_buf_va, size);
+	switch (mdev->state) {
+	case MIC_ONLINE:
+		/* Fall through */
+	case MIC_SHUTTING_DOWN:
+		seq_write(s, kva, size);
+		break;
+	default:
+		break;
+	}
+	mutex_unlock(&mdev->mic_mutex);
+	kfree(kva);
+done:
+	return 0;
+}
+
+static int mic_log_buf_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mic_log_buf_show, inode->i_private);
+}
+
+static int mic_log_buf_release(struct inode *inode, struct file *file)
+{
+	return single_release(inode, file);
+}
+
+static const struct file_operations log_buf_ops = {
+	.owner   = THIS_MODULE,
+	.open    = mic_log_buf_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = mic_log_buf_release
+};
+
+static int mic_smpt_show(struct seq_file *s, void *pos)
+{
+	int i;
+	struct mic_device *mdev = s->private;
+	unsigned long flags;
+
+	seq_printf(s, "MIC %-2d |%-10s| %-14s %-10s\n",
+		mdev->id, "SMPT entry", "SW DMA addr", "RefCount");
+	seq_puts(s, "====================================================\n");
+
+	if (mdev->smpt) {
+		struct mic_smpt_info *smpt_info = mdev->smpt;
+		spin_lock_irqsave(&smpt_info->smpt_lock, flags);
+		for (i = 0; i < smpt_info->info.num_reg; i++) {
+			seq_printf(s, "%9s|%-10d| %-#14llx %-10lld\n",
+				" ",  i, smpt_info->entry[i].dma_addr,
+				smpt_info->entry[i].ref_count);
+		}
+		spin_unlock_irqrestore(&smpt_info->smpt_lock, flags);
+	}
+	seq_puts(s, "====================================================\n");
+	return 0;
+}
+
+static int mic_smpt_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mic_smpt_show, inode->i_private);
+}
+
+static int mic_smpt_debug_release(struct inode *inode, struct file *file)
+{
+	return single_release(inode, file);
+}
+
+static const struct file_operations smpt_file_ops = {
+	.owner   = THIS_MODULE,
+	.open    = mic_smpt_debug_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = mic_smpt_debug_release
+};
+
+static int mic_soft_reset_show(struct seq_file *s, void *pos)
+{
+	struct mic_device *mdev = s->private;
+
+	mic_stop(mdev, true);
+	return 0;
+}
+
+static int mic_soft_reset_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mic_soft_reset_show, inode->i_private);
+}
+
+static int mic_soft_reset_debug_release(struct inode *inode, struct file *file)
+{
+	return single_release(inode, file);
+}
+
+static const struct file_operations soft_reset_ops = {
+	.owner   = THIS_MODULE,
+	.open    = mic_soft_reset_debug_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = mic_soft_reset_debug_release
+};
+
+static int mic_post_code_show(struct seq_file *s, void *pos)
+{
+	struct mic_device *mdev = s->private;
+	u32 reg = mdev->ops->get_postcode(mdev);
+
+	seq_printf(s, "%c%c", reg & 0xff, (reg >> 8) & 0xff);
+	return 0;
+}
+
+static int mic_post_code_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mic_post_code_show, inode->i_private);
+}
+
+static int mic_post_code_debug_release(struct inode *inode, struct file *file)
+{
+	return single_release(inode, file);
+}
+
+static const struct file_operations post_code_ops = {
+	.owner   = THIS_MODULE,
+	.open    = mic_post_code_debug_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = mic_post_code_debug_release
+};
+
+static int mic_dp_show(struct seq_file *s, void *pos)
+{
+	struct mic_device *mdev = s->private;
+	struct mic_bootparam *bootparam = mdev->dp;
+
+	seq_printf(s, "Bootparam: magic 0x%x\n",
+		bootparam->magic);
+	seq_printf(s, "Bootparam: h2c_shutdown_db %d\n",
+		bootparam->h2c_shutdown_db);
+	seq_printf(s, "Bootparam: h2c_config_db %d\n",
+		bootparam->h2c_config_db);
+	seq_printf(s, "Bootparam: c2h_shutdown_db %d\n",
+		bootparam->c2h_shutdown_db);
+	seq_printf(s, "Bootparam: shutdown_status %d\n",
+		bootparam->shutdown_status);
+	seq_printf(s, "Bootparam: shutdown_card %d\n",
+		bootparam->shutdown_card);
+
+	return 0;
+}
+
+static int mic_dp_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mic_dp_show, inode->i_private);
+}
+
+static int mic_dp_debug_release(struct inode *inode, struct file *file)
+{
+	return single_release(inode, file);
+}
+
+static const struct file_operations dp_ops = {
+	.owner   = THIS_MODULE,
+	.open    = mic_dp_debug_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = mic_dp_debug_release
+};
+
+static int mic_msi_irq_info_show(struct seq_file *s, void *pos)
+{
+	struct mic_device *mdev  = s->private;
+	int reg;
+	int i, j;
+	u16 entry;
+	u16 vector;
+	struct pci_dev *pdev = container_of(mdev->sdev->parent,
+		struct pci_dev, dev);
+
+	if (pci_dev_msi_enabled(pdev)) {
+		for (i = 0; i < mdev->irq_info.num_vectors; i++) {
+			if (pdev->msix_enabled) {
+				entry = mdev->irq_info.msix_entries[i].entry;
+				vector = mdev->irq_info.msix_entries[i].vector;
+			} else {
+				entry = 0;
+				vector = pdev->irq;
+			}
+
+			reg = mdev->intr_ops->read_msi_to_src_map(mdev, entry);
+
+			seq_printf(s, "%s %-10d %s %-10d MXAR[%d]: %08X\n",
+				"IRQ:", vector, "Entry:", entry, i, reg);
+
+			seq_printf(s, "%-10s", "offset:");
+			for (j = (MIC_NUM_OFFSETS - 1); j >= 0; j--)
+				seq_printf(s, "%4d ", j);
+			seq_puts(s, "\n");
+
+
+			seq_printf(s, "%-10s", "count:");
+			for (j = (MIC_NUM_OFFSETS - 1); j >= 0; j--)
+				seq_printf(s, "%4d ",
+				(mdev->irq_info.mic_msi_map[i] & BIT(j)) ?
+					1 : 0);
+			seq_puts(s, "\n\n");
+		}
+	} else {
+		seq_puts(s, "MSI/MSIx interrupts not enabled\n");
+	}
+
+	return 0;
+
+}
+
+static int mic_msi_irq_info_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mic_msi_irq_info_show, inode->i_private);
+}
+
+static int
+mic_msi_irq_info_debug_release(struct inode *inode, struct file *file)
+{
+	return single_release(inode, file);
+}
+
+static const struct file_operations msi_irq_info_ops = {
+	.owner   = THIS_MODULE,
+	.open    = mic_msi_irq_info_debug_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = mic_msi_irq_info_debug_release
+};
+
+/**
+ * mic_create_debug_dir - Initialize MIC debugfs entries.
+ */
+void mic_create_debug_dir(struct mic_device *mdev)
+{
+	if (!mic_dbg)
+		return;
+
+	mdev->dbg_dir = debugfs_create_dir(dev_name(mdev->sdev), mic_dbg);
+	if (!mdev->dbg_dir)
+		return;
+
+	debugfs_create_file("log_buf", 0444, mdev->dbg_dir,
+		mdev, &log_buf_ops);
+
+	debugfs_create_file("smpt", 0444, mdev->dbg_dir,
+		mdev, &smpt_file_ops);
+
+	debugfs_create_file("soft_reset", 0444, mdev->dbg_dir,
+		mdev, &soft_reset_ops);
+
+	debugfs_create_file("post_code", 0444, mdev->dbg_dir,
+		mdev, &post_code_ops);
+
+	debugfs_create_file("dp", 0444, mdev->dbg_dir,
+		mdev, &dp_ops);
+
+	debugfs_create_file("msi_irq_info", 0444, mdev->dbg_dir,
+		mdev, &msi_irq_info_ops);
+}
+
+/**
+ * mic_delete_debug_dir - Uninitialize MIC debugfs entries.
+ */
+void mic_delete_debug_dir(struct mic_device *mdev)
+{
+	if (!mdev->dbg_dir)
+		return;
+
+	debugfs_remove_recursive(mdev->dbg_dir);
+}
+
+/**
+ * mic_init_debugfs - Initialize global debugfs entry.
+ */
+void __init mic_init_debugfs(void)
+{
+	mic_dbg = debugfs_create_dir(KBUILD_MODNAME, NULL);
+	if (!mic_dbg)
+		pr_err("can't create debugfs dir\n");
+}
+
+/**
+ * mic_exit_debugfs - Uninitialize global debugfs entry
+ */
+void mic_exit_debugfs(void)
+{
+	debugfs_remove(mic_dbg);
+}
diff --git a/drivers/misc/mic/host/mic_device.h b/drivers/misc/mic/host/mic_device.h
index 0ccb2da..c2ca811 100644
--- a/drivers/misc/mic/host/mic_device.h
+++ b/drivers/misc/mic/host/mic_device.h
@@ -139,6 +139,23 @@ struct mic_irq;
  * @smpt: MIC SMPT information.
  * @intr_info: H/W specific interrupt information.
  * @irq_info: The OS specific irq information
+ * @dbg_dir: debugfs directory of this MIC device.
+ * @cmdline: Kernel command line.
+ * @firmware: Firmware file name.
+ * @ramdisk: Ramdisk file name.
+ * @bootmode: Boot mode i.e. "linux" or "elf" for flash updates.
+ * @bootaddr: MIC boot address.
+ * @reset_trigger_work: Work for triggering reset requests.
+ * @shutdown_work: Work for handling shutdown interrupts.
+ * @state: MIC state.
+ * @shutdown_status: MIC status reported by card for shutdown/crashes.
+ * @state_sysfs: Sysfs dirent for notifying ring 3 about MIC state changes.
+ * @log_buf_addr: Log buffer address for MIC.
+ * @log_buf_len: Log buffer length address for MIC.
+ * @dp: virtio device page
+ * @dp_dma_addr: virtio device page DMA address.
+ * @shutdown_db: shutdown doorbell.
+ * @shutdown_cookie: shutdown cookie.
  */
 struct mic_device {
 	struct mic_mw mmio;
@@ -155,6 +172,23 @@ struct mic_device {
 	struct mic_smpt_info *smpt;
 	struct mic_intr_info *intr_info;
 	struct mic_irq_info irq_info;
+	struct dentry *dbg_dir;
+	char *cmdline;
+	char *firmware;
+	char *ramdisk;
+	char *bootmode;
+	u32 bootaddr;
+	struct work_struct reset_trigger_work;
+	struct work_struct shutdown_work;
+	u8 state;
+	u8 shutdown_status;
+	struct sysfs_dirent *state_sysfs;
+	void *log_buf_addr;
+	int *log_buf_len;
+	void *dp;
+	dma_addr_t dp_dma_addr;
+	int shutdown_db;
+	struct mic_irq *shutdown_cookie;
 };
 
 /**
@@ -186,6 +220,13 @@ struct mic_hw_intr_ops {
  * @send_intr: Send an interrupt for a particular doorbell on the card.
  * @ack_interrupt: Hardware specific operations to ack the h/w on
  * receipt of an interrupt.
+ * @reset: Reset the remote processor.
+ * @reset_fw_ready: Reset firmware ready field.
+ * @is_fw_ready: Check if firmware is ready for OS download.
+ * @send_firmware_intr: Send an interrupt to the card firmware.
+ * @load_mic_fw: Load firmware segments required to boot the card
+ * into card memory. This includes the kernel, command line, ramdisk etc.
+ * @get_postcode: Get post code status from firmware.
  */
 struct mic_hw_ops {
 	u8 aper_bar;
@@ -194,6 +235,12 @@ struct mic_hw_ops {
 	void (*write_spad)(struct mic_device *mdev, unsigned int idx, u32 val);
 	void (*send_intr)(struct mic_device *mdev, int doorbell);
 	u32 (*ack_interrupt)(struct mic_device *mdev);
+	void (*reset)(struct mic_device *mdev);
+	void (*reset_fw_ready)(struct mic_device *mdev);
+	bool (*is_fw_ready)(struct mic_device *mdev);
+	void (*send_firmware_intr)(struct mic_device *mdev);
+	int (*load_mic_fw)(struct mic_device *mdev, const char *buf);
+	u32 (*get_postcode)(struct mic_device *mdev);
 };
 
 /**
@@ -232,4 +279,17 @@ struct mic_irq *mic_request_irq(struct mic_device *mdev,
 void mic_free_irq(struct mic_device *mdev,
 		struct mic_irq *cookie, void *data);
 void mic_intr_restore(struct mic_device *mdev);
+int mic_start(struct mic_device *mdev, const char *buf);
+void mic_stop(struct mic_device *mdev, bool force);
+void mic_shutdown(struct mic_device *mdev);
+void mic_reset_delayed_work(struct work_struct *work);
+void mic_reset_trigger_work(struct work_struct *work);
+void mic_shutdown_work(struct work_struct *work);
+void mic_bootparam_init(struct mic_device *mdev);
+void mic_set_state(struct mic_device *mdev, u8 state);
+void mic_set_shutdown_status(struct mic_device *mdev, u8 status);
+void mic_create_debug_dir(struct mic_device *dev);
+void mic_delete_debug_dir(struct mic_device *dev);
+void __init mic_init_debugfs(void);
+void mic_exit_debugfs(void);
 #endif
diff --git a/drivers/misc/mic/host/mic_main.c b/drivers/misc/mic/host/mic_main.c
index 3103842..2f34a26 100644
--- a/drivers/misc/mic/host/mic_main.c
+++ b/drivers/misc/mic/host/mic_main.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 
+#include <linux/mic_common.h>
 #include "../common/mic_device.h"
 #include "mic_device.h"
 #include "mic_x100.h"
@@ -64,6 +65,60 @@ static struct class *g_mic_class;
 /* Base device node number for MIC devices */
 static dev_t g_mic_devno;
 
+/* Initialize the device page */
+static int mic_dp_init(struct mic_device *mdev)
+{
+	mdev->dp = kzalloc(MIC_DP_SIZE, GFP_KERNEL);
+	if (!mdev->dp) {
+		dev_err(mdev->sdev->parent, "%s %d err %d\n",
+			__func__, __LINE__, -ENOMEM);
+		return -ENOMEM;
+	}
+
+	mdev->dp_dma_addr = mic_map_single(mdev,
+		mdev->dp, MIC_DP_SIZE);
+	if (mic_map_error(mdev->dp_dma_addr)) {
+		kfree(mdev->dp);
+		dev_err(mdev->sdev->parent, "%s %d err %d\n",
+			__func__, __LINE__, -ENOMEM);
+		return -ENOMEM;
+	}
+	mdev->ops->write_spad(mdev, MIC_DPLO_SPAD, mdev->dp_dma_addr);
+	mdev->ops->write_spad(mdev, MIC_DPHI_SPAD, mdev->dp_dma_addr >> 32);
+	return 0;
+}
+
+/* Uninitialize the device page */
+static void mic_dp_uninit(struct mic_device *mdev)
+{
+	mic_unmap_single(mdev, mdev->dp_dma_addr, MIC_DP_SIZE);
+	kfree(mdev->dp);
+}
+
+/**
+ * mic_shutdown_db - Shutdown doorbell interrupt handler.
+ */
+static irqreturn_t mic_shutdown_db(int irq, void *data)
+{
+	struct mic_device *mdev = data;
+	struct mic_bootparam *bootparam = mdev->dp;
+
+	mdev->ops->ack_interrupt(mdev);
+
+	switch (bootparam->shutdown_status) {
+	case MIC_HALTED:
+	case MIC_POWER_OFF:
+	case MIC_RESTART:
+		/* Fall through */
+	case MIC_CRASHED:
+		schedule_work(&mdev->shutdown_work);
+		break;
+	default:
+		break;
+	};
+	return IRQ_HANDLED;
+}
+
 /*
  * mic_invoke_callback - Invoke callback functions registered for
  * the corresponding source id.
@@ -757,6 +812,26 @@ mic_device_init(struct mic_device *mdev, struct pci_dev *pdev)
 	mic_sysfs_init(mdev);
 	mutex_init(&mdev->mic_mutex);
 	mdev->irq_info.next_avail_src = 0;
+	INIT_WORK(&mdev->reset_trigger_work, mic_reset_trigger_work);
+	INIT_WORK(&mdev->shutdown_work, mic_shutdown_work);
+}
+
+/**
+ * mic_device_uninit - Frees resources allocated during mic_device_init(..)
+ *
+ * @mdev: pointer to mic_device instance
+ *
+ * returns none
+ */
+static void mic_device_uninit(struct mic_device *mdev)
+{
+	/* The cmdline sysfs entry might have allocated cmdline */
+	kfree(mdev->cmdline);
+	kfree(mdev->firmware);
+	kfree(mdev->ramdisk);
+	kfree(mdev->bootmode);
+	flush_work(&mdev->reset_trigger_work);
+	flush_work(&mdev->shutdown_work);
 }
 
 /**
@@ -791,7 +866,7 @@ static int mic_probe(struct pci_dev *pdev,
 	rc = pci_enable_device(pdev);
 	if (rc) {
 		dev_err(&pdev->dev, "failed to enable pci device.\n");
-		goto ida_remove;
+		goto uninit_device;
 	}
 
 	pci_set_master(pdev);
@@ -849,7 +924,40 @@ static int mic_probe(struct pci_dev *pdev,
 			"device_create_with_groups failed rc %d\n", rc);
 		goto smpt_uninit;
 	}
+	mdev->state_sysfs = sysfs_get_dirent(mdev->sdev->kobj.sd,
+		NULL, "state");
+	if (!mdev->state_sysfs) {
+		rc = -ENODEV;
+		dev_err(&pdev->dev, "sysfs_get_dirent failed rc %d\n", rc);
+		goto destroy_device;
+	}
+
+	rc = mic_dp_init(mdev);
+	if (rc) {
+		dev_err(&pdev->dev, "mic_dp_init failed rc %d\n", rc);
+		goto sysfs_put;
+	}
+	mutex_lock(&mdev->mic_mutex);
+
+	mdev->shutdown_db = mic_next_db(mdev);
+	mdev->shutdown_cookie = mic_request_irq(mdev, mic_shutdown_db,
+		"shutdown-interrupt", mdev, mdev->shutdown_db, MIC_INTR_DB);
+	if (IS_ERR(mdev->shutdown_cookie)) {
+		rc = PTR_ERR(mdev->shutdown_cookie);
+		mutex_unlock(&mdev->mic_mutex);
+		goto dp_uninit;
+	}
+	mutex_unlock(&mdev->mic_mutex);
+	mic_bootparam_init(mdev);
+
+	mic_create_debug_dir(mdev);
 	return 0;
+dp_uninit:
+	mic_dp_uninit(mdev);
+sysfs_put:
+	sysfs_put(mdev->state_sysfs);
+destroy_device:
+	device_destroy(g_mic_class, MKDEV(MAJOR(g_mic_devno), mdev->id));
 smpt_uninit:
 	mic_smpt_uninit(mdev);
 free_interrupts:
@@ -862,7 +970,8 @@ release_regions:
 	pci_release_regions(pdev);
 disable_device:
 	pci_disable_device(pdev);
-ida_remove:
+uninit_device:
+	mic_device_uninit(mdev);
 	ida_simple_remove(&g_mic_ida, mdev->id);
 ida_fail:
 	kfree(mdev);
@@ -886,11 +995,20 @@ static void mic_remove(struct pci_dev *pdev)
 	if (!mdev)
 		return;
 
+	mic_stop(mdev, false);
+	mic_delete_debug_dir(mdev);
+	mutex_lock(&mdev->mic_mutex);
+	mic_free_irq(mdev, mdev->shutdown_cookie, mdev);
+	mutex_unlock(&mdev->mic_mutex);
+	flush_work(&mdev->shutdown_work);
+	mic_dp_uninit(mdev);
+	sysfs_put(mdev->state_sysfs);
 	device_destroy(g_mic_class, MKDEV(MAJOR(g_mic_devno), mdev->id));
 	mic_smpt_uninit(mdev);
 	mic_free_interrupts(mdev, pdev);
 	iounmap(mdev->mmio.va);
 	iounmap(mdev->aper.va);
+	mic_device_uninit(mdev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	ida_simple_remove(&g_mic_ida, mdev->id);
@@ -921,14 +1039,16 @@ static int __init mic_init(void)
 		goto cleanup_chrdev;
 	}
 
+	mic_init_debugfs();
 	ida_init(&g_mic_ida);
 	ret = pci_register_driver(&mic_driver);
 	if (ret) {
 		pr_err("pci_register_driver failed ret %d\n", ret);
-		goto class_destroy;
+		goto cleanup_debugfs;
 	}
 	return ret;
-class_destroy:
+cleanup_debugfs:
+	mic_exit_debugfs();
 	class_destroy(g_mic_class);
 cleanup_chrdev:
 	unregister_chrdev_region(g_mic_devno, MIC_MAX_NUM_DEVS);
@@ -940,6 +1060,7 @@ static void __exit mic_exit(void)
 {
 	pci_unregister_driver(&mic_driver);
 	ida_destroy(&g_mic_ida);
+	mic_exit_debugfs();
 	class_destroy(g_mic_class);
 	unregister_chrdev_region(g_mic_devno, MIC_MAX_NUM_DEVS);
 }
diff --git a/drivers/misc/mic/host/mic_sysfs.c b/drivers/misc/mic/host/mic_sysfs.c
index 972c182..53175eb 100644
--- a/drivers/misc/mic/host/mic_sysfs.c
+++ b/drivers/misc/mic/host/mic_sysfs.c
@@ -20,9 +20,52 @@
  */
 #include <linux/pci.h>
 
+#include <linux/mic_common.h>
 #include "../common/mic_device.h"
 #include "mic_device.h"
 
+/*
+ * A state-to-string lookup table, for exposing a human readable state
+ * via sysfs. Always keep in sync with enum mic_states
+ */
+static const char * const mic_state_string[] = {
+	[MIC_OFFLINE] = "offline",
+	[MIC_ONLINE] = "online",
+	[MIC_SHUTTING_DOWN] = "shutting_down",
+	[MIC_RESET_FAILED] = "reset_failed",
+};
+
+/*
+ * A shutdown-status-to-string lookup table, for exposing a human
+ * readable state via sysfs. Always keep in sync with enum mic_shutdown_status
+ */
+static const char * const mic_shutdown_status_string[] = {
+	[MIC_NOP] = "nop",
+	[MIC_CRASHED] = "crashed",
+	[MIC_HALTED] = "halted",
+	[MIC_POWER_OFF] = "poweroff",
+	[MIC_RESTART] = "restart",
+};
+
+void mic_set_shutdown_status(struct mic_device *mdev, u8 shutdown_status)
+{
+	WARN_ON(!mutex_is_locked(&mdev->mic_mutex));
+	dev_dbg(mdev->sdev->parent, "Shutdown Status %s -> %s\n",
+		mic_shutdown_status_string[mdev->shutdown_status],
+		mic_shutdown_status_string[shutdown_status]);
+	mdev->shutdown_status = shutdown_status;
+}
+
+void mic_set_state(struct mic_device *mdev, u8 state)
+{
+	WARN_ON(!mutex_is_locked(&mdev->mic_mutex));
+	dev_dbg(mdev->sdev->parent, "State %s -> %s\n",
+		mic_state_string[mdev->state],
+		mic_state_string[state]);
+	mdev->state = state;
+	sysfs_notify_dirent(mdev->state_sysfs);
+}
+
 static ssize_t
 mic_show_family(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -75,9 +118,337 @@ mic_show_stepping(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR(stepping, S_IRUGO, mic_show_stepping, NULL);
 
+static ssize_t
+mic_show_state(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+
+	if (!mdev || mdev->state >= MIC_LAST)
+		return -EINVAL;
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n",
+		mic_state_string[mdev->state]);
+}
+
+static ssize_t
+mic_store_state(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	int rc = 0;
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+	if (!mdev)
+		return -EINVAL;
+	if (sysfs_streq(buf, "boot")) {
+		rc = mic_start(mdev, buf);
+		if (rc) {
+			dev_err(mdev->sdev->parent,
+				"mic_boot failed rc %d\n", rc);
+			count = rc;
+		}
+		goto done;
+	}
+
+	if (sysfs_streq(buf, "reset")) {
+		schedule_work(&mdev->reset_trigger_work);
+		goto done;
+	}
+
+	if (sysfs_streq(buf, "shutdown")) {
+		mic_shutdown(mdev);
+		goto done;
+	}
+
+	count = -EINVAL;
+done:
+	return count;
+}
+static DEVICE_ATTR(state, S_IRUGO|S_IWUSR, mic_show_state, mic_store_state);
+
+static ssize_t mic_show_shutdown_status(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+
+	if (!mdev || mdev->shutdown_status >= MIC_STATUS_LAST)
+		return -EINVAL;
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n",
+		mic_shutdown_status_string[mdev->shutdown_status]);
+}
+static DEVICE_ATTR(shutdown_status, S_IRUGO|S_IWUSR,
+	mic_show_shutdown_status, NULL);
+
+static ssize_t
+mic_show_cmdline(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+	char *cmdline;
+
+	if (!mdev)
+		return -EINVAL;
+
+	cmdline = mdev->cmdline;
+
+	if (cmdline)
+		return scnprintf(buf, PAGE_SIZE, "%s\n", cmdline);
+	return 0;
+}
+
+static ssize_t
+mic_store_cmdline(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+
+	if (!mdev)
+		return -EINVAL;
+
+	mutex_lock(&mdev->mic_mutex);
+	kfree(mdev->cmdline);
+
+	mdev->cmdline = kmalloc(count + 1, GFP_KERNEL);
+	if (!mdev->cmdline) {
+		count = -ENOMEM;
+		goto unlock;
+	}
+
+	strncpy(mdev->cmdline, buf, count);
+
+	if (mdev->cmdline[count - 1] == '\n')
+		mdev->cmdline[count - 1] = '\0';
+	else
+		mdev->cmdline[count] = '\0';
+unlock:
+	mutex_unlock(&mdev->mic_mutex);
+	return count;
+}
+static DEVICE_ATTR(cmdline, S_IRUGO | S_IWUSR,
+	mic_show_cmdline, mic_store_cmdline);
+
+static ssize_t
+mic_show_firmware(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+	char *firmware;
+
+	if (!mdev)
+		return -EINVAL;
+
+	firmware = mdev->firmware;
+
+	if (firmware)
+		return scnprintf(buf, PAGE_SIZE, "%s\n", firmware);
+	return 0;
+}
+
+static ssize_t
+mic_store_firmware(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+
+	if (!mdev)
+		return -EINVAL;
+
+	mutex_lock(&mdev->mic_mutex);
+	kfree(mdev->firmware);
+
+	mdev->firmware = kmalloc(count + 1, GFP_KERNEL);
+	if (!mdev->firmware) {
+		count = -ENOMEM;
+		goto unlock;
+	}
+	strncpy(mdev->firmware, buf, count);
+
+	if (mdev->firmware[count - 1] == '\n')
+		mdev->firmware[count - 1] = '\0';
+	else
+		mdev->firmware[count] = '\0';
+unlock:
+	mutex_unlock(&mdev->mic_mutex);
+	return count;
+}
+static DEVICE_ATTR(firmware, S_IRUGO | S_IWUSR,
+	mic_show_firmware, mic_store_firmware);
+
+static ssize_t
+mic_show_ramdisk(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+	char *ramdisk;
+
+	if (!mdev)
+		return -EINVAL;
+
+	ramdisk = mdev->ramdisk;
+
+	if (ramdisk)
+		return scnprintf(buf, PAGE_SIZE, "%s\n", ramdisk);
+	return 0;
+}
+
+static ssize_t
+mic_store_ramdisk(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+
+	if (!mdev)
+		return -EINVAL;
+
+	mutex_lock(&mdev->mic_mutex);
+	kfree(mdev->ramdisk);
+
+	mdev->ramdisk = kmalloc(count + 1, GFP_KERNEL);
+	if (!mdev->ramdisk) {
+		count = -ENOMEM;
+		goto unlock;
+	}
+
+	strncpy(mdev->ramdisk, buf, count);
+
+	if (mdev->ramdisk[count - 1] == '\n')
+		mdev->ramdisk[count - 1] = '\0';
+	else
+		mdev->ramdisk[count] = '\0';
+unlock:
+	mutex_unlock(&mdev->mic_mutex);
+	return count;
+}
+static DEVICE_ATTR(ramdisk, S_IRUGO | S_IWUSR,
+	mic_show_ramdisk, mic_store_ramdisk);
+
+static ssize_t
+mic_show_bootmode(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+	char *bootmode;
+
+	if (!mdev)
+		return -EINVAL;
+
+	bootmode = mdev->bootmode;
+
+	if (bootmode)
+		return scnprintf(buf, PAGE_SIZE, "%s\n", bootmode);
+	return 0;
+}
+
+static ssize_t
+mic_store_bootmode(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+
+	if (!mdev)
+		return -EINVAL;
+
+	if (!sysfs_streq(buf, "linux") && !sysfs_streq(buf, "elf"))
+		return -EINVAL;
+
+	mutex_lock(&mdev->mic_mutex);
+	kfree(mdev->bootmode);
+
+	mdev->bootmode = kmalloc(count + 1, GFP_KERNEL);
+	if (!mdev->bootmode) {
+		count = -ENOMEM;
+		goto unlock;
+	}
+
+	strncpy(mdev->bootmode, buf, count);
+
+	if (mdev->bootmode[count - 1] == '\n')
+		mdev->bootmode[count - 1] = '\0';
+	else
+		mdev->bootmode[count] = '\0';
+unlock:
+	mutex_unlock(&mdev->mic_mutex);
+	return count;
+}
+static DEVICE_ATTR(bootmode, S_IRUGO | S_IWUSR,
+	mic_show_bootmode, mic_store_bootmode);
+
+static ssize_t
+mic_show_log_buf_addr(struct device *dev, struct device_attribute *attr,
+	char *buf)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+
+	if (!mdev)
+		return -EINVAL;
+
+	return scnprintf(buf, PAGE_SIZE, "%p\n", mdev->log_buf_addr);
+}
+
+static ssize_t
+mic_store_log_buf_addr(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+	int ret;
+	unsigned long addr;
+
+	if (!mdev)
+		return -EINVAL;
+
+	ret = kstrtoul(buf, 16, &addr);
+	if (ret)
+		goto exit;
+
+	mdev->log_buf_addr = (void *)addr;
+	ret = count;
+exit:
+	return ret;
+}
+static DEVICE_ATTR(log_buf_addr, S_IRUGO | S_IWUSR,
+	mic_show_log_buf_addr, mic_store_log_buf_addr);
+
+static ssize_t
+mic_show_log_buf_len(struct device *dev, struct device_attribute *attr,
+	char *buf)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+
+	if (!mdev)
+		return -EINVAL;
+
+	return scnprintf(buf, PAGE_SIZE, "%p\n", mdev->log_buf_len);
+}
+
+static ssize_t
+mic_store_log_buf_len(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+	int ret;
+	unsigned long addr;
+
+	if (!mdev)
+		return -EINVAL;
+
+	ret = kstrtoul(buf, 16, &addr);
+	if (ret)
+		goto exit;
+
+	mdev->log_buf_len = (int *)addr;
+	ret = count;
+exit:
+	return ret;
+}
+static DEVICE_ATTR(log_buf_len, S_IRUGO | S_IWUSR,
+	mic_show_log_buf_len, mic_store_log_buf_len);
+
 static struct attribute *mic_default_attrs[] = {
 	&dev_attr_family.attr,
 	&dev_attr_stepping.attr,
+	&dev_attr_state.attr,
+	&dev_attr_shutdown_status.attr,
+	&dev_attr_cmdline.attr,
+	&dev_attr_firmware.attr,
+	&dev_attr_ramdisk.attr,
+	&dev_attr_bootmode.attr,
+	&dev_attr_log_buf_addr.attr,
+	&dev_attr_log_buf_len.attr,
 
 	NULL
 };
diff --git a/drivers/misc/mic/host/mic_x100.c b/drivers/misc/mic/host/mic_x100.c
index a7d41fd..d32ea8b 100644
--- a/drivers/misc/mic/host/mic_x100.c
+++ b/drivers/misc/mic/host/mic_x100.c
@@ -20,6 +20,9 @@
  */
 #include <linux/fs.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
+#include <linux/firmware.h>
+#include <linux/delay.h>
 
 #include "../common/mic_device.h"
 #include "mic_device.h"
@@ -256,6 +259,248 @@ mic_x100_program_msi_to_src_map(struct mic_device *mdev,
 	mic_mmio_write(mw, reg, mxar);
 }
 
+/*
+ * mic_x100_reset_fw_ready - Reset Firmware ready status field.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_x100_reset_fw_ready(struct mic_device *mdev)
+{
+	mdev->ops->write_spad(mdev, MIC_X100_DOWNLOAD_INFO, 0);
+}
+
+/*
+ * mic_x100_is_fw_ready - Check if firmware is ready.
+ * @mdev: pointer to mic_device instance
+ */
+static bool mic_x100_is_fw_ready(struct mic_device *mdev)
+{
+	u32 scratch2 = mdev->ops->read_spad(mdev, MIC_X100_DOWNLOAD_INFO);
+	return MIC_X100_SPAD2_DOWNLOAD_STATUS(scratch2) ? true : false;
+}
+
+/**
+ * mic_x100_get_apic_id - Get bootstrap APIC ID.
+ * @mdev: pointer to mic_device instance
+ */
+static u32 mic_x100_get_apic_id(struct mic_device *mdev)
+{
+	u32 scratch2 = 0;
+
+	scratch2 = mdev->ops->read_spad(mdev, MIC_X100_DOWNLOAD_INFO);
+	return MIC_X100_SPAD2_APIC_ID(scratch2);
+}
+
+/**
+ * mic_x100_send_firmware_intr - Send an interrupt to the firmware on MIC.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_x100_send_firmware_intr(struct mic_device *mdev)
+{
+	u32 apicicr_low;
+	u64 apic_icr_offset = MIC_X100_SBOX_APICICR7;
+	int vector = MIC_X100_BSP_INTERRUPT_VECTOR;
+	struct mic_mw *mw = &mdev->mmio;
+
+	/*
+	 * For MIC we need to make sure we "hit"
+	 * the send_icr bit (13).
+	 */
+	apicicr_low = (vector | (1 << 13));
+
+	mic_mmio_write(mw, mic_x100_get_apic_id(mdev),
+		MIC_X100_SBOX_BASE_ADDRESS + apic_icr_offset + 4);
+
+	/* Ensure that the interrupt is ordered w.r.t. previous stores. */
+	wmb();
+	mic_mmio_write(mw, apicicr_low,
+		MIC_X100_SBOX_BASE_ADDRESS + apic_icr_offset);
+}
+
+/**
+ * mic_x100_hw_reset - Reset the MIC device.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_x100_hw_reset(struct mic_device *mdev)
+{
+	u32 reset_reg;
+	u32 rgcr = MIC_X100_SBOX_BASE_ADDRESS + MIC_X100_SBOX_RGCR;
+	struct mic_mw *mw = &mdev->mmio;
+
+	/* Ensure that the reset is ordered w.r.t. previous loads and stores */
+	mb();
+	/* Trigger reset */
+	reset_reg = mic_mmio_read(mw, rgcr);
+	reset_reg |= 0x1;
+	mic_mmio_write(mw, reset_reg, rgcr);
+	/*
+	 * It seems we really want to delay at least 1 second
+	 * after touching reset to prevent a lot of problems.
+	 */
+	msleep(1000);
+}
+
+/**
+ * mic_x100_load_command_line - Load command line to MIC.
+ * @mdev: pointer to mic_device instance
+ * @fw: the firmware image
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+static int
+mic_x100_load_command_line(struct mic_device *mdev, const struct firmware *fw)
+{
+	u32 len = 0;
+	u32 boot_mem;
+	char *buf;
+	void __iomem *cmd_line_va = mdev->aper.va + mdev->bootaddr + fw->size;
+#define CMDLINE_SIZE 2048
+
+	boot_mem = mdev->aper.len >> 20;
+	buf = kzalloc(CMDLINE_SIZE, GFP_KERNEL);
+	if (!buf) {
+		dev_err(mdev->sdev->parent,
+			"%s %d allocation failed\n", __func__, __LINE__);
+		return -ENOMEM;
+	}
+	len += snprintf(buf, CMDLINE_SIZE - len,
+		" mem=%dM", boot_mem);
+	if (mdev->cmdline)
+		snprintf(buf + len, CMDLINE_SIZE - len,
+				" %s", mdev->cmdline);
+	memcpy_toio(cmd_line_va, buf, strlen(buf) + 1);
+	kfree(buf);
+	return 0;
+}
+
+/**
+ * mic_x100_load_ramdisk - Load ramdisk to MIC.
+ * @mdev: pointer to mic_device instance
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+static int
+mic_x100_load_ramdisk(struct mic_device *mdev)
+{
+	const struct firmware *fw;
+	int rc;
+	struct boot_params __iomem *bp = mdev->aper.va + mdev->bootaddr;
+
+	rc = request_firmware(&fw,
+			mdev->ramdisk, mdev->sdev->parent);
+	if (rc < 0) {
+		dev_err(mdev->sdev->parent,
+			"ramdisk request_firmware failed: %d %s\n",
+			rc, mdev->ramdisk);
+		goto error;
+	}
+	/*
+	 * Typically the bootaddr for card OS is 64M
+	 * so copy over the ramdisk @ 128M.
+	 */
+	memcpy_toio(mdev->aper.va + (mdev->bootaddr << 1),
+		fw->data, fw->size);
+	iowrite32(cpu_to_le32(mdev->bootaddr << 1), &bp->hdr.ramdisk_image);
+	iowrite32(cpu_to_le32(fw->size), &bp->hdr.ramdisk_size);
+	release_firmware(fw);
+error:
+	return rc;
+}
+
+/**
+ * mic_x100_get_boot_addr - Get MIC boot address.
+ * @mdev: pointer to mic_device instance
+ *
+ * This function is called during firmware load to determine
+ * the address at which the OS should be downloaded in card
+ * memory i.e. GDDR.
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+static int
+mic_x100_get_boot_addr(struct mic_device *mdev)
+{
+	u32 scratch2, boot_addr;
+	int rc = 0;
+
+	scratch2 = mdev->ops->read_spad(mdev, MIC_X100_DOWNLOAD_INFO);
+	boot_addr = MIC_X100_SPAD2_DOWNLOAD_ADDR(scratch2);
+	dev_dbg(mdev->sdev->parent, "%s %d boot_addr 0x%x\n",
+		__func__, __LINE__, boot_addr);
+	if (boot_addr > (1 << 31)) {
+		dev_err(mdev->sdev->parent,
+			"incorrect bootaddr 0x%x\n",
+			boot_addr);
+		rc = -EINVAL;
+		goto error;
+	}
+	mdev->bootaddr = boot_addr;
+error:
+	return rc;
+}
+
+/**
+ * mic_x100_load_firmware - Load firmware to MIC.
+ * @mdev: pointer to mic_device instance
+ * @buf: buffer containing boot string including firmware/ramdisk path.
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+static int
+mic_x100_load_firmware(struct mic_device *mdev, const char *buf)
+{
+	int rc;
+	const struct firmware *fw;
+
+	rc = mic_x100_get_boot_addr(mdev);
+	if (rc)
+		goto error;
+	/* load OS */
+	rc = request_firmware(&fw, mdev->firmware, mdev->sdev->parent);
+	if (rc < 0) {
+		dev_err(mdev->sdev->parent,
+			"ramdisk request_firmware failed: %d %s\n",
+			rc, mdev->firmware);
+		goto error;
+	}
+	if (mdev->bootaddr > mdev->aper.len - fw->size) {
+		rc = -EINVAL;
+		dev_err(mdev->sdev->parent, "%s %d rc %d bootaddr 0x%x\n",
+			__func__, __LINE__, rc, mdev->bootaddr);
+		release_firmware(fw);
+		goto error;
+	}
+	memcpy_toio(mdev->aper.va + mdev->bootaddr, fw->data, fw->size);
+	mdev->ops->write_spad(mdev, MIC_X100_FW_SIZE, fw->size);
+	if (!strcmp(mdev->bootmode, "elf"))
+		goto done;
+	/* load command line */
+	rc = mic_x100_load_command_line(mdev, fw);
+	if (rc) {
+		dev_err(mdev->sdev->parent, "%s %d rc %d\n",
+			__func__, __LINE__, rc);
+		goto error;
+	}
+	release_firmware(fw);
+	/* load ramdisk */
+	if (mdev->ramdisk)
+		rc = mic_x100_load_ramdisk(mdev);
+error:
+	dev_dbg(mdev->sdev->parent, "%s %d rc %d\n",
+			__func__, __LINE__, rc);
+done:
+	return rc;
+}
+
+/**
+ * mic_x100_get_postcode - Get postcode status from firmware.
+ * @mdev: pointer to mic_device instance
+ *
+ * RETURNS: postcode.
+ */
+static u32 mic_x100_get_postcode(struct mic_device *mdev)
+{
+	return mic_mmio_read(&mdev->mmio, MIC_X100_POSTCODE);
+}
+
 /**
  * mic_x100_smpt_set - Update an SMPT entry with a DMA address.
  * @mdev: pointer to mic_device instance
@@ -311,6 +556,12 @@ struct mic_hw_ops mic_x100_ops = {
 	.write_spad = mic_x100_write_spad,
 	.send_intr = mic_x100_send_intr,
 	.ack_interrupt = mic_x100_ack_interrupt,
+	.reset = mic_x100_hw_reset,
+	.reset_fw_ready = mic_x100_reset_fw_ready,
+	.is_fw_ready = mic_x100_is_fw_ready,
+	.send_firmware_intr = mic_x100_send_firmware_intr,
+	.load_mic_fw = mic_x100_load_firmware,
+	.get_postcode = mic_x100_get_postcode,
 };
 
 struct mic_hw_intr_ops mic_x100_intr_ops = {
diff --git a/drivers/misc/mic/host/mic_x100.h b/drivers/misc/mic/host/mic_x100.h
index fd98b2b..227f73b 100644
--- a/drivers/misc/mic/host/mic_x100.h
+++ b/drivers/misc/mic/host/mic_x100.h
@@ -70,6 +70,15 @@
 #define MIC_X100_NUM_RDMASR_IRQ 8
 #define MIC_X100_RDMASR_IRQ_BASE 17
 #define MIC_NUM_OFFSETS 32
+#define MIC_X100_SPAD2_DOWNLOAD_STATUS(x) ((x) & 0x1)
+#define MIC_X100_SPAD2_APIC_ID(x)	(((x) >> 1) & 0x1ff)
+#define MIC_X100_SPAD2_DOWNLOAD_ADDR(x) ((x) & 0xfffff000)
+#define MIC_X100_SBOX_APICICR7 0x0000AA08
+#define MIC_X100_SBOX_RGCR 0x00004010
+#define MIC_X100_SBOX_SDBIC0 0x0000CC90
+#define MIC_X100_DOWNLOAD_INFO 2
+#define MIC_X100_FW_SIZE 5
+#define MIC_X100_POSTCODE 0x242c
 
 static const u16 mic_x100_intr_init[] = {
 		MIC_X100_DOORBELL_IDX_START,
@@ -80,6 +89,9 @@ static const u16 mic_x100_intr_init[] = {
 		MIC_X100_NUM_ERR,
 };
 
+/* Host->Card(bootstrap) Interrupt Vector */
+#define MIC_X100_BSP_INTERRUPT_VECTOR 229
+
 extern struct mic_hw_ops mic_x100_ops;
 extern struct mic_smpt_ops mic_x100_smpt_ops;
 extern struct mic_hw_intr_ops mic_x100_intr_ops;
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 997f9f2..e3f7b37 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -240,6 +240,7 @@ header-y += media.h
 header-y += mei.h
 header-y += mempolicy.h
 header-y += meye.h
+header-y += mic_common.h
 header-y += mii.h
 header-y += minix_fs.h
 header-y += mman.h
diff --git a/include/uapi/linux/mic_common.h b/include/uapi/linux/mic_common.h
new file mode 100644
index 0000000..a9091e5
--- /dev/null
+++ b/include/uapi/linux/mic_common.h
@@ -0,0 +1,74 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC driver.
+ *
+ */
+#ifndef __MIC_COMMON_H_
+#define __MIC_COMMON_H_
+
+#include <linux/types.h>
+
+/**
+ * struct mic_bootparam: Virtio device independent information in device page
+ *
+ * @magic: A magic value used by the card to ensure it can see the host
+ * @c2h_shutdown_db: Card to Host shutdown doorbell set by host
+ * @h2c_shutdown_db: Host to Card shutdown doorbell set by card
+ * @h2c_config_db: Host to Card Virtio config doorbell set by card
+ * @shutdown_status: Card shutdown status set by card
+ * @shutdown_card: Set to 1 by the host when a card shutdown is initiated
+ */
+struct mic_bootparam {
+	__u32 magic;
+	__s8 c2h_shutdown_db;
+	__s8 h2c_shutdown_db;
+	__s8 h2c_config_db;
+	__u8 shutdown_status;
+	__u8 shutdown_card;
+} __aligned(8);
+
+/* Device page size */
+#define MIC_DP_SIZE 4096
+
+#define MIC_MAGIC 0xc0ffee00
+
+/**
+ * enum mic_states - MIC states.
+ */
+enum mic_states {
+	MIC_OFFLINE = 0,
+	MIC_ONLINE,
+	MIC_SHUTTING_DOWN,
+	MIC_RESET_FAILED,
+	MIC_LAST
+};
+
+/**
+ * enum mic_status - MIC status reported by card after
+ * a host or card initiated shutdown or a card crash.
+ */
+enum mic_status {
+	MIC_NOP = 0,
+	MIC_CRASHED,
+	MIC_HALTED,
+	MIC_POWER_OFF,
+	MIC_RESTART,
+	MIC_STATUS_LAST
+};
+
+#endif
-- 
1.8.2.1

