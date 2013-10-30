Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3J3Jg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 05:36:58 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:44262 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3J3Jgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 05:36:50 -0400
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        haver@linux.vnet.ibm.com, Frank Haverkamp <haver@vnet.ibm.com>
Subject: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
Date: Wed, 30 Oct 2013 10:32:58 +0100
Message-Id: <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103009-4966-0000-0000-00000756D891
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Haverkamp <haver@vnet.ibm.com>

The GenWQE card itself provides access to a generic work queue into
which the work can be put, which should be executed, e.g. compression
or decompression request, or whatever the card was configured to do.

Each request comes with a set of input data (ASV) and will produce some
output data (ASIV). The request will also contain a sequence number,
some timestamps and a command code/subcode plus some fields for hardware-/
software-interaction.

A request can contain references to blocks of memory. Since the card
requires DMA-addresses of that memory, the driver provides two ways to
solve that task:
  1) The drivers mmap() will allocate some DMAable memory for the user.
     The driver has a lookup table such that the virtual userspace
     address can properly be replaced and checked.
  2) The user allocates memory and the driver will pin/unpin that
     memory and setup a scatter gatherlist with matching DMA addresses.

Currently work requests are synchronous.

The genwqe driver has a user-space interface described in
linux/include/genwqe/genwqe_card.h. There are several ioctls which can
be used to talk to the driver.

In addition there are some sysfs entries where information can be
exchanged with user-space. The sysfs interface is described in
Documentation/ABI/testing/sysfs-driver-genwqe.

Now the driver has also a debugfs interface. This is described in
Documentation/ABI/testing/debugfs-driver-genwqe.

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
Co-authors: Joerg-Stephan Vogt <jsvogt@de.ibm.com>,
            Michael Jung <MIJUNG@de.ibm.com>,
            Michael Ruettger <michael@ibmra.de>
---
 Documentation/ABI/testing/debugfs-driver-genwqe |   57 +
 Documentation/ABI/testing/sysfs-driver-genwqe   |   46 +
 drivers/misc/Kconfig                            |    1 +
 drivers/misc/Makefile                           |    1 +
 drivers/misc/genwqe/Kconfig                     |   23 +
 drivers/misc/genwqe/Makefile                    |    8 +
 drivers/misc/genwqe/card_base.c                 | 1238 +++++++++++++++++++
 drivers/misc/genwqe/card_base.h                 |  569 +++++++++
 drivers/misc/genwqe/card_ddcb.c                 | 1380 +++++++++++++++++++++
 drivers/misc/genwqe/card_ddcb.h                 |  188 +++
 drivers/misc/genwqe/card_debugfs.c              |  566 +++++++++
 drivers/misc/genwqe/card_dev.c                  | 1499 +++++++++++++++++++++++
 drivers/misc/genwqe/card_sysfs.c                |  306 +++++
 drivers/misc/genwqe/card_utils.c                |  983 +++++++++++++++
 drivers/misc/genwqe/genwqe_driver.h             |   75 ++
 include/linux/genwqe/genwqe_card.h              |  559 +++++++++
 16 files changed, 7499 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-driver-genwqe
 create mode 100644 Documentation/ABI/testing/sysfs-driver-genwqe
 create mode 100644 drivers/misc/genwqe/Kconfig
 create mode 100644 drivers/misc/genwqe/Makefile
 create mode 100644 drivers/misc/genwqe/card_base.c
 create mode 100644 drivers/misc/genwqe/card_base.h
 create mode 100644 drivers/misc/genwqe/card_ddcb.c
 create mode 100644 drivers/misc/genwqe/card_ddcb.h
 create mode 100644 drivers/misc/genwqe/card_debugfs.c
 create mode 100644 drivers/misc/genwqe/card_dev.c
 create mode 100644 drivers/misc/genwqe/card_sysfs.c
 create mode 100644 drivers/misc/genwqe/card_utils.c
 create mode 100644 drivers/misc/genwqe/genwqe_driver.h
 create mode 100644 include/linux/genwqe/genwqe_card.h

diff --git a/Documentation/ABI/testing/debugfs-driver-genwqe b/Documentation/ABI/testing/debugfs-driver-genwqe
new file mode 100644
index 0000000..c3503a4
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-driver-genwqe
@@ -0,0 +1,57 @@
+What:           /sys/kernel/debug/genwqe/genwqe<n>_card/ddcb_info
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    DDCB queue dump used for debugging queueing problems.
+
+What:           /sys/kernel/debug/genwqe/genwqe<n>_card/curr_regs
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Dump of the current error registers.
+
+What:           /sys/kernel/debug/genwqe/genwqe<n>_card/curr_uid0
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Internal chip state of UID0 (unit id 0).
+
+What:           /sys/kernel/debug/genwqe/genwqe<n>_card/curr_uid1
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Internal chip state of UID1.
+
+What:           /sys/kernel/debug/genwqe/genwqe<n>_card/curr_uid2
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Internal chip state of UID2.
+
+What:           /sys/kernel/debug/genwqe/genwqe<n>_card/prev_regs
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Dump of the error registers before the last reset of
+                the card occured.
+
+What:           /sys/kernel/debug/genwqe/genwqe<n>_card/prev_uid0
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Internal chip state of UID0 before card was reset.
+
+What:           /sys/kernel/debug/genwqe/genwqe<n>_card/prev_uid1
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Internal chip state of UID1 before card was reset.
+
+What:           /sys/kernel/debug/genwqe/genwqe<n>_card/prev_uid2
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Internal chip state of UID2 before card was reset.
+
+What:           /sys/kernel/debug/genwqe/genwqe<n>_card/info
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Comprehensive summary of bitstream version and software
+                version. Used bitstream and bitstream clocking information.
+
+What:           /sys/kernel/debug/genwqe/genwqe<n>_card/err_inject
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Possibility to inject error cases to ensure that the drivers
+                error handling code works well.
diff --git a/Documentation/ABI/testing/sysfs-driver-genwqe b/Documentation/ABI/testing/sysfs-driver-genwqe
new file mode 100644
index 0000000..d85c076
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-genwqe
@@ -0,0 +1,46 @@
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
+What:           /sys/class/genwqe/genwqe<n>_card/cpld_version
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Version id of the cards CPLD.
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
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 8dacd4c..92142cf 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -537,4 +537,5 @@ source "drivers/misc/carma/Kconfig"
 source "drivers/misc/altera-stapl/Kconfig"
 source "drivers/misc/mei/Kconfig"
 source "drivers/misc/vmw_vmci/Kconfig"
+source "drivers/misc/genwqe/Kconfig"
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index c235d5b..62a3dfb 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -53,3 +53,4 @@ obj-$(CONFIG_INTEL_MEI)		+= mei/
 obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
 obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
 obj-$(CONFIG_SRAM)		+= sram.o
+obj-$(CONFIG_GENWQE)		+= genwqe/
diff --git a/drivers/misc/genwqe/Kconfig b/drivers/misc/genwqe/Kconfig
new file mode 100644
index 0000000..bbf137d
--- /dev/null
+++ b/drivers/misc/genwqe/Kconfig
@@ -0,0 +1,23 @@
+#
+# IBM Accelerator Family 'GenWQE'
+#
+
+menuconfig GENWQE
+	tristate "GenWQE PCIe Accelerator"
+	depends on PCI && 64BIT
+	select CRC_ITU_T
+	default n
+	help
+	  Enables PCIe card driver for IBM GenWQE accelerators.
+          The user-space interface is described in
+          include/linux/genwqe/genwqe_card.h.
+
+if GENWQE
+
+config GENWQE_DEVNAME
+        string "Name for sysfs and device nodes"
+	default "genwqe"
+        help
+          Select alternate name for sysfs and device nodes.
+
+endif
diff --git a/drivers/misc/genwqe/Makefile b/drivers/misc/genwqe/Makefile
new file mode 100644
index 0000000..b6af308
--- /dev/null
+++ b/drivers/misc/genwqe/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for GenWQE driver
+#
+
+# card driver
+obj-$(CONFIG_GENWQE) := genwqe_card.o
+genwqe_card-objs := card_base.o card_dev.o card_ddcb.o card_sysfs.o \
+	card_debugfs.o card_utils.o
diff --git a/drivers/misc/genwqe/card_base.c b/drivers/misc/genwqe/card_base.c
new file mode 100644
index 0000000..271d957
--- /dev/null
+++ b/drivers/misc/genwqe/card_base.c
@@ -0,0 +1,1238 @@
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
+ * Module initialization and PCIe setup. Card health monitoring and
+ * recovery functionality. Character device creation and deletion are
+ * controlled from here.
+ *
+ * Please use the new sysfs interfaces to enable the VFs after PF
+ * driver loading.
+ *
+ * Enable VFs:
+ *   sudo sh -c 'echo 15 > /sys/bus/pci/devices/0000\:1b\:00.0/sriov_numvfs'
+ * or
+ *   sudo sh -c 'echo 15 > /sys/class/genwqe/genwqe0_card/device/sriov_numvfs'
+ * Disable VFs:
+ *   Write a 0 into the same sysfs entries.
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/err.h>
+#include <linux/aer.h>
+#include <linux/string.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/device.h>
+#include <linux/log2.h>
+#include <linux/genwqe/genwqe_card.h>
+
+#include "card_base.h"
+#include "card_ddcb.h"
+
+MODULE_AUTHOR("Frank Haverkamp <haver@linux.vnet.ibm.com>");
+MODULE_AUTHOR("Michael Ruettger <michael@ibmra.de>");
+MODULE_AUTHOR("Joerg-Stephan Vogt <jsvogt@de.ibm.com>");
+MODULE_AUTHOR("Michal Jung <mijung@de.ibm.com>");
+
+MODULE_DESCRIPTION("GenWQE Card");
+MODULE_VERSION(DRV_VERS_STRING);
+MODULE_LICENSE("GPL");
+
+/*
+ * We like to be able to disable the health checking entirely in some
+ * cases e.g. if a card is broken and needs to be analyzed. I
+ * considered using debugfs/sysfs attributes, but I did not see a way
+ * to prevent the thread from being started at driver load time other
+ * than starting it later manually, what I did not like either
+ * in this case (e.g. like the new SRIOV enablement).
+ */
+static int genwqe_health_check_interval = 4;   /* <= 0: disabled */
+module_param(genwqe_health_check_interval, int, 0644);  /* read/writeable */
+MODULE_PARM_DESC(genwqe_health_check_interval,
+		 "check card health every N seconds (0 = disabled)");
+
+/*
+ * GenWQE Driver: Need SLC timeout set to 250ms (temporary setting for
+ * testing of 1000ms due to decompressor testcase failing)
+ *
+ * There is a requirement by the card users that the timeout must not
+ * exceed the 250ms.
+ *
+ * In this case the settings must be done before any interaction to
+ * the device can be done, since we cannot change the settings without
+ * stopping the queues.
+ */
+int genwqe_vf_jobtimeout_msec = 250;
+module_param(genwqe_vf_jobtimeout_msec, int, 0444); /* readable */
+MODULE_PARM_DESC(genwqe_vf_jobtimeout_msec,
+		 "Job timeout for virtual functions");
+
+int genwqe_pf_jobtimeout_msec = 8000;	/* 8sec should be ok */
+module_param(genwqe_pf_jobtimeout_msec, int, 0444); /* readable */
+MODULE_PARM_DESC(genwqe_pf_jobtimeout_msec,
+		 "Job timeout for physical function");
+
+static char genwqe_driver_name[] = GENWQE_DEVNAME;
+static struct class *class_genwqe;
+static struct dentry *debugfs_genwqe;
+static struct genwqe_dev *genwqe_devices[GENWQE_CARD_NO_MAX];
+
+/* PCI structure for identifying device by PCI vendor and device ID */
+static DEFINE_PCI_DEVICE_TABLE(genwqe_device_table) = {
+	{ .vendor      = PCI_VENDOR_ID_IBM,
+	  .device      = PCI_DEVICE_GENWQE,
+	  .subvendor   = PCI_SUBVENDOR_ID_IBM,
+	  .subdevice   = PCI_SUBSYSTEM_ID_GENWQE5,
+	  .class       = (PCI_CLASSCODE_GENWQE5 << 8),
+	  .class_mask  = ~0,
+	  .driver_data = 0 },
+
+	/* Initial SR-IOV bring-up image */
+	{ .vendor      = PCI_VENDOR_ID_IBM,
+	  .device      = PCI_DEVICE_GENWQE,
+	  .subvendor   = PCI_SUBVENDOR_ID_IBM_SRIOV,
+	  .subdevice   = PCI_SUBSYSTEM_ID_GENWQE5_SRIOV,
+	  .class       = (PCI_CLASSCODE_GENWQE5_SRIOV << 8),
+	  .class_mask  = ~0,
+	  .driver_data = 0 },
+
+	{ .vendor      = PCI_VENDOR_ID_IBM,  /* VF Vendor ID */
+	  .device      = 0x0000,  /* VF Device ID */
+	  .subvendor   = PCI_SUBVENDOR_ID_IBM_SRIOV,
+	  .subdevice   = PCI_SUBSYSTEM_ID_GENWQE5_SRIOV,
+	  .class       = (PCI_CLASSCODE_GENWQE5_SRIOV << 8),
+	  .class_mask  = ~0,
+	  .driver_data = 0 },
+
+	/* Fixed up image */
+	{ .vendor      = PCI_VENDOR_ID_IBM,
+	  .device      = PCI_DEVICE_GENWQE,
+	  .subvendor   = PCI_SUBVENDOR_ID_IBM_SRIOV,
+	  .subdevice   = PCI_SUBSYSTEM_ID_GENWQE5,
+	  .class       = (PCI_CLASSCODE_GENWQE5_SRIOV << 8),
+	  .class_mask  = ~0,
+	  .driver_data = 0 },
+
+	{ .vendor      = PCI_VENDOR_ID_IBM,  /* VF Vendor ID */
+	  .device      = 0x0000,  /* VF Device ID */
+	  .subvendor   = PCI_SUBVENDOR_ID_IBM_SRIOV,
+	  .subdevice   = PCI_SUBSYSTEM_ID_GENWQE5,
+	  .class       = (PCI_CLASSCODE_GENWQE5_SRIOV << 8),
+	  .class_mask  = ~0,
+	  .driver_data = 0 },
+
+	/* Even one more ... */
+	{ .vendor      = PCI_VENDOR_ID_IBM,
+	  .device      = PCI_DEVICE_GENWQE,
+	  .subvendor   = PCI_SUBVENDOR_ID_IBM,
+	  .subdevice   = PCI_SUBSYSTEM_ID_GENWQE5_NEW,
+	  .class       = (PCI_CLASSCODE_GENWQE5 << 8),
+	  .class_mask  = ~0,
+	  .driver_data = 0 },
+
+	{ 0, }			/* 0 terminated list. */
+};
+
+MODULE_DEVICE_TABLE(pci, genwqe_device_table);
+
+/**
+ * genwqe_dev_alloc() - Create and prepare a new card descriptor
+ *
+ * Return: Pointer to card descriptor, or ERR_PTR(err) on error
+ */
+static struct genwqe_dev *genwqe_dev_alloc(void)
+{
+	int i = 0;
+	struct genwqe_dev *cd;
+
+	for (i = 0; i < GENWQE_CARD_NO_MAX; i++) {
+		if (genwqe_devices[i] == NULL)
+			break;
+	}
+	if (i >= GENWQE_CARD_NO_MAX)
+		return ERR_PTR(-ENODEV);
+
+	cd = kzalloc(sizeof(struct genwqe_dev), GFP_KERNEL);
+	if (!cd)
+		return ERR_PTR(-ENOMEM);
+
+	cd->card_idx = i;
+	cd->class_genwqe = class_genwqe;
+	cd->debugfs_genwqe = debugfs_genwqe;
+
+	init_waitqueue_head(&cd->queue_waitq);
+
+	spin_lock_init(&cd->file_lock);
+	INIT_LIST_HEAD(&cd->file_list);
+
+	cd->card_state = GENWQE_CARD_UNUSED;
+	spin_lock_init(&cd->print_lock);
+
+	cd->ddcb_software_timeout = genwqe_ddcb_software_timeout;
+	cd->kill_timeout = genwqe_kill_timeout;
+
+	genwqe_devices[i] = cd;
+	return cd;
+}
+
+static void genwqe_dev_free(struct genwqe_dev *cd)
+{
+	if (!cd)
+		return;
+
+	genwqe_devices[cd->card_idx] = NULL;
+	kfree(cd);
+}
+
+/**
+ * genwqe_bus_reset() - Card recovery
+ *
+ * pci_reset_function() will recover the device and ensure that the
+ * registers are accessible again when it completes with success. If
+ * not, the card will stay dead and registers will be unaccessible
+ * still.
+ */
+static int genwqe_bus_reset(struct genwqe_dev *cd)
+{
+	int bars, rc = 0;
+	struct pci_dev *pci_dev = cd->pci_dev;
+	void __iomem *mmio;
+
+	if (cd->err_inject & GENWQE_INJECT_BUS_RESET_FAILURE)
+		return -EIO;
+
+	mmio = cd->mmio;
+	cd->mmio = NULL;
+	pci_iounmap(pci_dev, mmio);
+
+	bars = pci_select_bars(pci_dev, IORESOURCE_MEM);
+	pci_release_selected_regions(pci_dev, bars);
+
+	/*
+	 * Firmware/BIOS might change memory mapping during bus reset.
+	 * Settings like enable bus-mastering, ... are backuped and
+	 * restored by the pci_reset_function().
+	 */
+	dev_dbg(&pci_dev->dev, "[%s] pci_reset function ...\n", __func__);
+	rc = pci_reset_function(pci_dev);
+	if (rc) {
+		dev_err(&pci_dev->dev,
+			"[%s] err: failed reset func (rc %d)\n", __func__, rc);
+		return rc;
+	}
+	dev_dbg(&pci_dev->dev, "[%s] done with rc=%d\n", __func__, rc);
+
+	/*
+	 * Here is the right spot to clear the register read
+	 * failure. pci_bus_reset() does this job in real systems.
+	 */
+	cd->err_inject &= ~(GENWQE_INJECT_HARDWARE_FAILURE |
+			    GENWQE_INJECT_GFIR_FATAL |
+			    GENWQE_INJECT_GFIR_INFO);
+
+	rc = pci_request_selected_regions(pci_dev, bars, genwqe_driver_name);
+	if (rc) {
+		dev_err(&pci_dev->dev,
+			"[%s] err: request bars failed (%d)\n", __func__, rc);
+		return -EIO;
+	}
+
+	cd->mmio = pci_iomap(pci_dev, 0, 0);
+	if (cd->mmio == NULL) {
+		dev_err(&pci_dev->dev,
+			"[%s] err: mapping BAR0 failed\n", __func__);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+/*
+ * Hardware circumvention section. Certain bitstreams in our test-lab
+ * had different kinds of problems. Here is where we adjust those
+ * bitstreams to function will with this version of our device driver.
+ *
+ * Thise circumventions are applied to the physical function only.
+ * The magical numbers below are identifying development/manufacturing
+ * versions of the bitstream used on the card.
+ *
+ * Turn off error reporting for old/manufacturing images.
+ */
+
+bool genwqe_need_err_masking(struct genwqe_dev *cd)
+{
+	return (cd->slu_unitcfg & 0xFFFF0ull) < 0x32170ull;
+}
+
+static void genwqe_tweak_hardware(struct genwqe_dev *cd)
+{
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	/* Mask FIRs for development images */
+	if (((cd->slu_unitcfg & 0xFFFF0ull) >= 0x32000ull) &&
+	    ((cd->slu_unitcfg & 0xFFFF0ull) <= 0x33250ull)) {
+		dev_warn(&pci_dev->dev,
+			 "FIRs masked due to bitstream %016llx.%016llx\n",
+			 cd->slu_unitcfg, cd->app_unitcfg);
+
+		__genwqe_writeq(cd, IO_APP_SEC_LEM_DEBUG_OVR,
+				0xFFFFFFFFFFFFFFFFull);
+
+		__genwqe_writeq(cd, IO_APP_ERR_ACT_MASK,
+				0x0000000000000000ull);
+	}
+}
+
+/**
+ * genwqe_recovery_on_fatal_gfir_required() - Version depended actions
+ *
+ * Bitstreams older than 2013-02-17 have a bug where fatal GFIRs must
+ * be ignored. This is e.g. true for the bitstream we gave to the card
+ * manufacturer, but also for some old bitstreams we released to our
+ * test-lab.
+ */
+int genwqe_recovery_on_fatal_gfir_required(struct genwqe_dev *cd)
+{
+	return ((cd->slu_unitcfg & 0xFFFF0ull) >= 0x32170ull);
+}
+
+int genwqe_flash_readback_fails(struct genwqe_dev *cd)
+{
+	return ((cd->slu_unitcfg & 0xFFFF0ull) < 0x32170ull);
+}
+
+/**
+ * genwqe_T_psec() - Calculate PF/VF timeout register content
+ *
+ * Note: From a design perspective it turned out to be a bad idea to
+ * use codes here to specifiy the frequency/speed values. An old
+ * driver cannot understand new codes and is therefore always a
+ * problem. Better is to measure out the value or put the
+ * speed/frequency directly into a register which is always a valid
+ * value for old as well as for new software.
+ */
+/* T = 1/f */
+static int genwqe_T_psec(struct genwqe_dev *cd)
+{
+	u16 speed;	/* 1/f -> 250,  200,  166,  175 */
+	static const int T[] = { 4000, 5000, 6000, 5714 };
+
+	speed = (u16)((cd->slu_unitcfg >> 28) & 0x0full);
+	if (speed >= ARRAY_SIZE(T))
+		return -1;	/* illegal value */
+
+	return T[speed];
+}
+
+/**
+ * genwqe_setup_jtimer() - Setup PF/VF hardware timeouts for DDCB execution
+ *
+ * Do this _after_ card_reset() is called. Otherwise the values will
+ * vanish. The settings need to be done when the queues are inactive.
+ *
+ * The max. timeout value is 2^(10+x) * T (6ns for 166MHz) * 15/16.
+ * The min. timeout value is 2^(10+x) * T (6ns for 166MHz) * 14/16.
+ */
+static int genwqe_setup_jtimer(struct genwqe_dev *cd)
+{
+	int vf;
+	u32 T = genwqe_T_psec(cd);
+	u64 x;
+
+	if (genwqe_pf_jobtimeout_msec != -1) {
+		/* PF: large value needed, due to flash update 2sec
+		   per block */
+		x = ilog2(genwqe_pf_jobtimeout_msec *
+			  16000000000uL/(T * 15)) - 10;
+		genwqe_write_jtimer(cd, 0, (0xff00 | (x & 0xff)));
+	}
+
+	if (genwqe_vf_jobtimeout_msec != -1) {
+		if (cd->num_vfs < 0)
+			return cd->num_vfs;
+
+		x = ilog2(genwqe_vf_jobtimeout_msec *
+			  16000000000uL/(T * 15)) - 10;
+
+		for (vf = 0; vf < cd->num_vfs; vf++)
+			genwqe_write_jtimer(cd, vf + 1, (0xff00 | (x & 0xff)));
+	}
+
+	return 0;
+}
+
+static int genwqe_ffdc_buffs_alloc(struct genwqe_dev *cd)
+{
+	unsigned int type, e = 0;
+
+	for (type = 0; type < GENWQE_DBG_UNITS; type++) {
+		switch (type) {
+		case GENWQE_DBG_UNIT0:
+			e = genwqe_ffdc_buff_size(cd, 0);
+			break;
+		case GENWQE_DBG_UNIT1:
+			e = genwqe_ffdc_buff_size(cd, 1);
+			break;
+		case GENWQE_DBG_UNIT2:
+			e = genwqe_ffdc_buff_size(cd, 2);
+			break;
+		case GENWQE_DBG_REGS:
+			e = GENWQE_FFDC_REGS;
+			break;
+		}
+
+		/* currently support only the debug units mentioned here */
+		cd->ffdc[type].entries = e;
+		cd->ffdc[type].regs = kmalloc(e * sizeof(struct genwqe_reg),
+					      GFP_KERNEL);
+		/*
+		 * regs == NULL is ok, the using code treats this as no regs,
+		 * Printing warning is ok in this case.
+		 */
+	}
+	return 0;
+}
+
+static void genwqe_ffdc_buffs_free(struct genwqe_dev *cd)
+{
+	unsigned int type;
+
+	for (type = 0; type < GENWQE_DBG_UNITS; type++) {
+		kfree(cd->ffdc[type].regs);
+		cd->ffdc[type].regs = NULL;
+	}
+}
+
+static int genwqe_read_ids(struct genwqe_dev *cd)
+{
+	int err = 0;
+	int slu_id;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	cd->slu_unitcfg = __genwqe_readq(cd, IO_SLU_UNITCFG);
+	if (cd->slu_unitcfg == IO_ILLEGAL_VALUE) {
+		dev_err(&pci_dev->dev,
+			"err: SLUID=%016llx\n", cd->slu_unitcfg);
+		err = -EIO;
+		goto out_err;
+	}
+
+	slu_id = genwqe_get_slu_id(cd);
+	if (slu_id < GENWQE_SLU_ARCH_REQ || slu_id == 0xff) {
+		dev_err(&pci_dev->dev,
+			"err: incompatible SLU Architecture %u\n", slu_id);
+		err = -ENOENT;
+		goto out_err;
+	}
+
+	cd->app_unitcfg = __genwqe_readq(cd, IO_APP_UNITCFG);
+	if (cd->app_unitcfg == IO_ILLEGAL_VALUE) {
+		dev_err(&pci_dev->dev,
+			"err: APPID=%016llx\n", cd->app_unitcfg);
+		err = -EIO;
+		goto out_err;
+	}
+	genwqe_read_app_id(cd, cd->app_name, sizeof(cd->app_name));
+
+	/*
+	 * Is access to all registers possible? If we are a VF the
+	 * answer is obvious. If we run fully virtualized, we need to
+	 * check if we can access all registers. If we do not have
+	 * full access we will cause an UR and some informational FIRs
+	 * in the PF, but that should not harm.
+	 */
+	if (pci_dev->is_virtfn)
+		cd->is_privileged = 0;
+	else
+		cd->is_privileged = (__genwqe_readq(cd, IO_SLU_BITSTREAM)
+				     != IO_ILLEGAL_VALUE);
+
+ out_err:
+	return err;
+}
+
+static int genwqe_start(struct genwqe_dev *cd)
+{
+	int err;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	err = genwqe_read_ids(cd);
+	if (err)
+		return err;
+
+	if (genwqe_is_privileged(cd)) {
+		/* do this after the tweaks. alloc fail is acceptable */
+		genwqe_ffdc_buffs_alloc(cd);
+		genwqe_stop_traps(cd);
+
+		/* Collect registers e.g. FIRs, UNITIDs, traces ... */
+		genwqe_read_ffdc_regs(cd, cd->ffdc[GENWQE_DBG_REGS].regs,
+				      cd->ffdc[GENWQE_DBG_REGS].entries, 0);
+
+		genwqe_ffdc_buff_read(cd, GENWQE_DBG_UNIT0,
+				      cd->ffdc[GENWQE_DBG_UNIT0].regs,
+				      cd->ffdc[GENWQE_DBG_UNIT0].entries);
+
+		genwqe_ffdc_buff_read(cd, GENWQE_DBG_UNIT1,
+				      cd->ffdc[GENWQE_DBG_UNIT1].regs,
+				      cd->ffdc[GENWQE_DBG_UNIT1].entries);
+
+		genwqe_ffdc_buff_read(cd, GENWQE_DBG_UNIT2,
+				      cd->ffdc[GENWQE_DBG_UNIT2].regs,
+				      cd->ffdc[GENWQE_DBG_UNIT2].entries);
+
+		genwqe_start_traps(cd);
+
+		if (cd->card_state == GENWQE_CARD_FATAL_ERROR) {
+			dev_warn(&pci_dev->dev,
+				 "[%s] chip reload/recovery!\n", __func__);
+
+			/*
+			 * Stealth Mode: Reload chip on either hot
+			 * reset or PERST.
+			 */
+			cd->softreset = 0x7Cull;
+			__genwqe_writeq(cd, IO_SLC_CFGREG_SOFTRESET,
+				       cd->softreset);
+
+			err = genwqe_bus_reset(cd);
+			if (err != 0) {
+				dev_err(&pci_dev->dev,
+					"[%s] err: bus reset failed!\n",
+					__func__);
+				goto out;
+			}
+
+			/*
+			 * Re-read the IDs because
+			 * it could happen that the bitstream load
+			 * failed!
+			 */
+			err = genwqe_read_ids(cd);
+			if (err)
+				goto out;
+		}
+	}
+
+	err = genwqe_setup_service_layer(cd);  /* does a reset to the card */
+	if (err != 0) {
+		dev_err(&pci_dev->dev,
+			"[%s] err: could not setup servicelayer!\n", __func__);
+		err = -ENODEV;
+		goto out;
+	}
+
+	if (genwqe_is_privileged(cd)) {	 /* code is running _after_ reset */
+		genwqe_tweak_hardware(cd);
+		genwqe_setup_jtimer(cd);	 /* queues must not run */
+	}
+
+	err = genwqe_device_create(cd);
+	if (err < 0) {
+		dev_err(&pci_dev->dev,
+			"err: chdev init failed! (err=%d)\n", err);
+		goto out_release_service_layer;
+	}
+	return 0;
+
+ out_release_service_layer:
+	genwqe_release_service_layer(cd);
+ out:
+	if (genwqe_is_privileged(cd))
+		genwqe_ffdc_buffs_free(cd);
+	return -EIO;
+}
+
+/**
+ * genwqe_stop() - Stop card operation
+ *
+ * Recovery notes:
+ *   As long as genwqe_thread runs we might access registers during
+ *   error data capture. Same is with the genwqe_health_thread.
+ *   When genwqe_bus_reset() fails this function might called two times:
+ *   first by the genwqe_health_thread() and later by genwqe_remove() to
+ *   unbind the device. We must be able to survive that.
+ *
+ * This function must be robust enough to be called twice.
+ */
+static int genwqe_stop(struct genwqe_dev *cd)
+{
+	genwqe_finish_queue(cd);	    /* no register access */
+	genwqe_device_remove(cd);	    /* device removed, procs killed */
+	genwqe_release_service_layer(cd);   /* here genwqe_thread is stopped */
+
+	if (genwqe_is_privileged(cd)) {
+		pci_disable_sriov(cd->pci_dev);	/* access pci config space */
+		genwqe_ffdc_buffs_free(cd);
+	}
+
+	return 0;
+}
+
+/**
+ * genwqe_recover_card() - Try to recover the card if it is possible
+ *
+ * If fatal_err is set no register access is possible anymore. It is
+ * likely that genwqe_start fails in that situation. Proper error
+ * handling is required in this case.
+ *
+ * genwqe_bus_reset() will cause the pci code to call genwqe_remove()
+ * and later genwqe_probe() for all virtual functions.
+ */
+static int genwqe_recover_card(struct genwqe_dev *cd, int fatal_err)
+{
+	int rc;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	genwqe_stop(cd);
+
+	/*
+	 * Make sure chip is not reloaded to maintain FFDC. Write SLU
+	 * Reset Register, CPLDReset field to 0.
+	 */
+	if (!fatal_err) {
+		cd->softreset = 0x70ull;
+		__genwqe_writeq(cd, IO_SLC_CFGREG_SOFTRESET, cd->softreset);
+	}
+
+	rc = genwqe_bus_reset(cd);
+	if (rc != 0) {
+		dev_err(&pci_dev->dev,
+			"[%s] err: card recovery impossible!\n", __func__);
+		return rc;
+	}
+
+	rc = genwqe_start(cd);
+	if (rc < 0) {
+		dev_err(&pci_dev->dev,
+			"[%s] err: failed to launch device!\n", __func__);
+		return rc;
+	}
+	return 0;
+}
+
+static int genwqe_health_check_cond(struct genwqe_dev *cd, u64 *gfir)
+{
+	*gfir = __genwqe_readq(cd, IO_SLC_CFGREG_GFIR);
+	return (*gfir & GFIR_ERR_TRIGGER) &&
+		genwqe_recovery_on_fatal_gfir_required(cd);
+}
+
+/**
+ * genwqe_fir_checking() - Check the fault isolation registers of the card
+ *
+ * If this code works ok, can be tried out with help of the genwqe_poke tool:
+ *   sudo ./tools/genwqe_poke 0x8 0xfefefefefef
+ *
+ * Now the relevant FIRs/sFIRs should be printed out and the driver should
+ * invoke recovery (devices are removed and readded).
+ */
+static u64 genwqe_fir_checking(struct genwqe_dev *cd)
+{
+	int j, iterations = 0;
+	u64 mask, fir, fec, uid, gfir, gfir_masked, sfir, sfec;
+	u32 fir_addr, fir_clr_addr, fec_addr, sfir_addr, sfec_addr;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+ healthMonitor:
+	iterations++;
+	if (iterations > 16) {
+		dev_err(&pci_dev->dev, "* exit looping after %d times\n",
+			iterations);
+		goto fatal_error;
+	}
+
+	gfir = __genwqe_readq(cd, IO_SLC_CFGREG_GFIR);
+	if (gfir != 0x0)
+		dev_err(&pci_dev->dev, "* 0x%08x 0x%016llx\n",
+				    IO_SLC_CFGREG_GFIR, gfir);
+	if (gfir == IO_ILLEGAL_VALUE)
+		goto fatal_error;
+
+	/*
+	 * Avoid printing when to GFIR bit is on prevents contignous
+	 * printout e.g. for the following bug:
+	 *   FIR set without a 2ndary FIR/FIR cannot be cleared
+	 * Comment out the following if to get the prints:
+	 */
+	if (gfir == 0)
+		return 0;
+
+	gfir_masked = gfir & GFIR_ERR_TRIGGER;  /* fatal errors */
+
+	for (uid = 0; uid < GENWQE_MAX_UNITS; uid++) { /* 0..2 in zEDC */
+
+		/* read the primary FIR (pfir) */
+		fir_addr = (uid << 24) + 0x08;
+		fir = __genwqe_readq(cd, fir_addr);
+		if (fir == 0x0)
+			continue;  /* no error in this unit */
+
+		dev_err(&pci_dev->dev, "* 0x%08x 0x%016llx\n", fir_addr, fir);
+		if (fir == IO_ILLEGAL_VALUE)
+			goto fatal_error;
+
+		/* read primary FEC */
+		fec_addr = (uid << 24) + 0x18;
+		fec = __genwqe_readq(cd, fec_addr);
+
+		dev_err(&pci_dev->dev, "* 0x%08x 0x%016llx\n", fec_addr, fec);
+		if (fec == IO_ILLEGAL_VALUE)
+			goto fatal_error;
+
+		for (j = 0, mask = 1ULL; j < 64; j++, mask <<= 1) {
+
+			/* secondary fir empty, skip it */
+			if ((fir & mask) == 0x0)
+				continue;
+
+			sfir_addr = (uid << 24) + 0x100 + 0x08 * j;
+			sfir = __genwqe_readq(cd, sfir_addr);
+
+			if (sfir == IO_ILLEGAL_VALUE)
+				goto fatal_error;
+			dev_err(&pci_dev->dev,
+				"* 0x%08x 0x%016llx\n", sfir_addr, sfir);
+
+			sfec_addr = (uid << 24) + 0x300 + 0x08 * j;
+			sfec = __genwqe_readq(cd, sfec_addr);
+
+			if (sfec == IO_ILLEGAL_VALUE)
+				goto fatal_error;
+			dev_err(&pci_dev->dev,
+				"* 0x%08x 0x%016llx\n", sfec_addr, sfec);
+
+			gfir = __genwqe_readq(cd, IO_SLC_CFGREG_GFIR);
+			if (gfir == IO_ILLEGAL_VALUE)
+				goto fatal_error;
+
+			/* gfir turned on during routine! get out and
+			   start over. */
+			if ((gfir_masked == 0x0) &&
+			    (gfir & GFIR_ERR_TRIGGER)) {
+				goto healthMonitor;
+			}
+
+			/* do not clear if we entered with a fatal gfir */
+			if (gfir_masked == 0x0) {
+
+				/* NEW clear by mask the logged bits */
+				sfir_addr = (uid << 24) + 0x100 + 0x08 * j;
+				__genwqe_writeq(cd, sfir_addr, sfir);
+
+				dev_dbg(&pci_dev->dev,
+					"[HM] Clearing  2ndary FIR 0x%08x "
+					"with 0x%016llx\n", sfir_addr, sfir);
+
+				/*
+				 * note, these cannot be error-Firs
+				 * since gfir_masked is 0 after sfir
+				 * was read. Also, it is safe to do
+				 * this write if sfir=0. Still need to
+				 * clear the primary. This just means
+				 * there is no secondary FIR.
+				 */
+
+				/* clear by mask the logged bit. */
+				fir_clr_addr = (uid << 24) + 0x10;
+				__genwqe_writeq(cd, fir_clr_addr, mask);
+
+				dev_dbg(&pci_dev->dev,
+					"[HM] Clearing primary FIR 0x%08x "
+					"with 0x%016llx\n", fir_clr_addr,
+					mask);
+			}
+		}
+	}
+	gfir = __genwqe_readq(cd, IO_SLC_CFGREG_GFIR);
+	if (gfir == IO_ILLEGAL_VALUE)
+		goto fatal_error;
+
+	if ((gfir_masked == 0x0) && (gfir & GFIR_ERR_TRIGGER)) {
+		/*
+		 * Check once more that it didn't go on after all the
+		 * FIRS were cleared.
+		 */
+		dev_dbg(&pci_dev->dev, "ACK! Another FIR! Recursing %d!\n",
+			iterations);
+		goto healthMonitor;
+	}
+	return gfir_masked;
+
+ fatal_error:
+	return IO_ILLEGAL_VALUE;
+}
+
+/**
+ * genwqe_health_thread() - Health checking thread
+ *
+ * This thread is only started for the PF of the card.
+ *
+ * This thread monitors the health of the card. A critical situation
+ * is when we read registers which contain -1 (IO_ILLEGAL_VALUE). In
+ * this case we need to be recovered from outside. Writing to
+ * registers will very likely not work either.
+ *
+ * This thread must only exit if kthread_should_stop() becomes true.
+ *
+ * Testing bind/unbind with:
+ *   sudo sh -c "echo -n 0000:20:00.0 > /sys/bus/pci/drivers/genwqe/unbind"
+ *   sudo sh -c "echo -n 0000:20:00.0 > /sys/bus/pci/drivers/genwqe/bind"
+ *
+ * Condition for the health-thread to trigger:
+ *   a) when a kthread_stop() request comes in or
+ *   b) a critical GFIR occured
+ *
+ * Informational GFIRs are checked and potentially printed in
+ * health_check_interval seconds.
+ *
+ * Testcase to trigger this code:
+ *   Fatal GFIR:
+ *     sudo ./tools/genwqe_poke -C0 0x00000008 0x001
+ *   Info GFIR by writing to VF:
+ *     sudo ./tools/genwqe_poke -C2 0x00020020 0x800
+ */
+static int genwqe_health_thread(void *data)
+{
+	int rc, should_stop = 0;
+	struct genwqe_dev *cd = data;
+	struct pci_dev *pci_dev = cd->pci_dev;
+	u64 gfir, gfir_masked, slu_unitcfg, app_unitcfg;
+
+	while (!kthread_should_stop()) {
+		rc = wait_event_interruptible_timeout(cd->health_waitq,
+			 (genwqe_health_check_cond(cd, &gfir) ||
+			  (should_stop = kthread_should_stop())),
+				genwqe_health_check_interval * HZ);
+
+		if (should_stop)
+			break;
+
+		if (gfir == IO_ILLEGAL_VALUE) {
+			dev_err(&pci_dev->dev,
+				"[%s] GFIR=%016llx\n", __func__, gfir);
+			goto fatal_error;
+		}
+
+		slu_unitcfg = __genwqe_readq(cd, IO_SLU_UNITCFG);
+		if (slu_unitcfg == IO_ILLEGAL_VALUE) {
+			dev_err(&pci_dev->dev,
+				"[%s] SLU_UNITCFG=%016llx\n",
+				__func__, slu_unitcfg);
+			goto fatal_error;
+		}
+
+		app_unitcfg = __genwqe_readq(cd, IO_APP_UNITCFG);
+		if (app_unitcfg == IO_ILLEGAL_VALUE) {
+			dev_err(&pci_dev->dev,
+				"[%s] APP_UNITCFG=%016llx\n",
+				__func__, app_unitcfg);
+			goto fatal_error;
+		}
+
+		gfir = __genwqe_readq(cd, IO_SLC_CFGREG_GFIR);
+		if (gfir == IO_ILLEGAL_VALUE) {
+			dev_err(&pci_dev->dev,
+				"[%s] %s: GFIR=%016llx\n", __func__,
+				(gfir & GFIR_ERR_TRIGGER) ? "err" : "info",
+				gfir);
+			goto fatal_error;
+		}
+
+		gfir_masked = genwqe_fir_checking(cd);
+		if (gfir_masked == IO_ILLEGAL_VALUE)
+			goto fatal_error;
+
+		/*
+		 * GFIR ErrorTrigger bits set => reset the card!
+		 * Never do this for old/manufacturing images!
+		 */
+		if ((gfir_masked) && !cd->skip_recovery &&
+		    genwqe_recovery_on_fatal_gfir_required(cd)) {
+
+			cd->card_state = GENWQE_CARD_FATAL_ERROR;
+
+			rc = genwqe_recover_card(cd, 0);
+			if (rc < 0) {
+				/* FIXME Card is unusable and needs unbind! */
+				goto fatal_error;
+			}
+		}
+
+		cd->last_gfir = gfir;
+		cond_resched();
+	}
+
+	return 0;
+
+ fatal_error:
+	dev_err(&pci_dev->dev,
+		"[%s] card unusable. Please trigger unbind!\n", __func__);
+
+	/* Bring down logical devices to inform user space via udev remove. */
+	cd->card_state = GENWQE_CARD_FATAL_ERROR;
+	genwqe_stop(cd);
+
+	/* genwqe_bus_reset failed(). Now wait for genwqe_remove(). */
+	while (!kthread_should_stop())
+		cond_resched();
+
+	return -EIO;
+}
+
+static int genwqe_health_check_start(struct genwqe_dev *cd)
+{
+	int rc;
+
+	if (genwqe_health_check_interval <= 0)
+		return 0;	/* valid for disabling the service */
+
+	/* moved before request_irq() */
+	/* init_waitqueue_head(&cd->health_waitq); */
+
+	cd->health_thread = kthread_run(genwqe_health_thread, cd,
+					GENWQE_DEVNAME "%d_health",
+					cd->card_idx);
+	if (IS_ERR(cd->health_thread)) {
+		rc = PTR_ERR(cd->health_thread);
+		cd->health_thread = NULL;
+		return rc;
+	}
+	return 0;
+}
+
+static int genwqe_health_thread_running(struct genwqe_dev *cd)
+{
+	return (cd->health_thread != NULL);
+}
+
+static int genwqe_health_check_stop(struct genwqe_dev *cd)
+{
+	int rc;
+
+	if (!genwqe_health_thread_running(cd))
+		return -EIO;
+
+	rc = kthread_stop(cd->health_thread);
+	cd->health_thread = NULL;
+	return 0;
+}
+
+/**
+ * genwqe_pci_setup() - Allocate PCIe related resources for our card
+ */
+static int genwqe_pci_setup(struct genwqe_dev *cd)
+{
+	int err, bars;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	bars = pci_select_bars(pci_dev, IORESOURCE_MEM);
+	err = pci_enable_device_mem(pci_dev);
+	if (err) {
+		dev_err(&pci_dev->dev,
+			"err: failed to enable pci memory (err=%d)\n", err);
+		goto err_out;
+	}
+
+	/* Reserve PCI I/O and memory resources */
+	err = pci_request_selected_regions(pci_dev, bars, genwqe_driver_name);
+	if (err) {
+		dev_err(&pci_dev->dev,
+			"[%s] err: request bars failed (%d)\n", __func__, err);
+		err = -EIO;
+		goto err_disable_device;
+	}
+
+	/* check for 64-bit DMA address supported (DAC) */
+	if (!pci_set_dma_mask(pci_dev, DMA_BIT_MASK(64))) {
+		err = pci_set_consistent_dma_mask(pci_dev, DMA_BIT_MASK(64));
+		if (err) {
+			dev_err(&pci_dev->dev,
+				"err: DMA64 consistent mask error\n");
+			err = -EIO;
+			goto out_release_resources;
+		}
+	/* check for 32-bit DMA address supported (SAC) */
+	} else if (!pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32))) {
+		err = pci_set_consistent_dma_mask(pci_dev, DMA_BIT_MASK(32));
+		if (err) {
+			dev_err(&pci_dev->dev,
+				"err: DMA32 consistent mask error\n");
+			err = -EIO;
+			goto out_release_resources;
+		}
+	} else {
+		dev_err(&pci_dev->dev,
+			"err: neither DMA32 nor DMA64 supported\n");
+		err = -EIO;
+		goto out_release_resources;
+	}
+
+	pci_set_master(pci_dev);
+	pci_enable_pcie_error_reporting(pci_dev);
+
+	/* request complete BAR-0 space (length = 0) */
+	cd->mmio_len = pci_resource_len(pci_dev, 0);
+	cd->mmio = pci_iomap(pci_dev, 0, 0);
+	if (cd->mmio == NULL) {
+		dev_err(&pci_dev->dev,
+			"[%s] err: mapping BAR0 failed\n", __func__);
+		err = -ENOMEM;
+		goto out_release_resources;
+	}
+
+	cd->num_vfs = pci_sriov_get_totalvfs(pci_dev);
+
+	err = genwqe_read_ids(cd);
+	if (err)
+		goto out_iounmap;
+
+	return 0;
+
+ out_iounmap:
+	pci_iounmap(pci_dev, cd->mmio);
+ out_release_resources:
+	pci_release_selected_regions(pci_dev, bars);
+ err_disable_device:
+	pci_disable_device(pci_dev);
+ err_out:
+	return err;
+}
+
+/**
+ * genwqe_pci_remove() - Free PCIe related resources for our card
+ */
+static void genwqe_pci_remove(struct genwqe_dev *cd)
+{
+	int bars;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	if (cd->mmio)
+		pci_iounmap(pci_dev, cd->mmio);
+
+	bars = pci_select_bars(pci_dev, IORESOURCE_MEM);
+	pci_release_selected_regions(pci_dev, bars);
+	pci_disable_device(pci_dev);
+}
+
+/**
+ * genwqe_probe() - Device initialization
+ * @pdev:	PCI device information struct
+ *
+ * Callable for multiple cards. This function is called on bind.
+ *
+ * Return: 0 if succeeded, < 0 when failed
+ */
+static int genwqe_probe(struct pci_dev *pci_dev,
+			const struct pci_device_id *id)
+{
+	int err;
+	struct genwqe_dev *cd;
+
+	init_crc32();
+
+	cd = genwqe_dev_alloc();
+	if (IS_ERR(cd)) {
+		dev_err(&pci_dev->dev, "err: could not alloc mem (err=%d)!\n",
+			(int)PTR_ERR(cd));
+		return PTR_ERR(cd);
+	}
+
+	dev_set_drvdata(&pci_dev->dev, cd);
+	cd->pci_dev = pci_dev;
+
+	err = genwqe_pci_setup(cd);
+	if (err < 0) {
+		dev_err(&pci_dev->dev,
+			"err: problems with PCI setup (err=%d)\n", err);
+		goto out_free_dev;
+	}
+
+	err = genwqe_start(cd);
+	if (err < 0) {
+		dev_err(&pci_dev->dev,
+			"err: cannot start card services! (err=%d)\n", err);
+		goto out_pci_remove;
+	}
+
+	if (genwqe_is_privileged(cd)) {
+		err = genwqe_health_check_start(cd);
+		if (err < 0) {
+			dev_err(&pci_dev->dev,
+				"err: cannot start health checking! "
+				"(err=%d)\n", err);
+			goto out_stop_services;
+		}
+	}
+	return 0;
+
+ out_stop_services:
+	genwqe_stop(cd);
+ out_pci_remove:
+	genwqe_pci_remove(cd);
+ out_free_dev:
+	genwqe_dev_free(cd);
+	return err;
+}
+
+/**
+ * genwqe_remove() - Called when device is removed (hot-plugable)
+ *
+ * Or when driver is unloaded respecitively when unbind is done.
+ */
+static void genwqe_remove(struct pci_dev *pci_dev)
+{
+	struct genwqe_dev *cd = dev_get_drvdata(&pci_dev->dev);
+
+	genwqe_health_check_stop(cd);
+
+	/*
+	 * genwqe_stop() must survive if it is called twice
+	 * sequentially. This happens when the health thread calls it
+	 * and fails on genwqe_bus_reset().
+	 */
+	genwqe_stop(cd);
+	genwqe_pci_remove(cd);
+	genwqe_dev_free(cd);
+}
+
+/*
+ * genwqe_err_error_detected() - Error detection callback
+ *
+ * This callback is called by the PCI subsystem whenever a PCI bus
+ * error is detected.
+ */
+static pci_ers_result_t genwqe_err_error_detected(struct pci_dev *pci_dev,
+						 enum pci_channel_state state)
+{
+	struct genwqe_dev *cd;
+
+	dev_err(&pci_dev->dev, "[%s] state=%d\n", __func__, state);
+
+	if (pci_dev == NULL)
+		return PCI_ERS_RESULT_NEED_RESET;
+
+	cd = dev_get_drvdata(&pci_dev->dev);
+	if (cd == NULL)
+		return PCI_ERS_RESULT_NEED_RESET;
+
+	switch (state) {
+	case pci_channel_io_normal:
+		return PCI_ERS_RESULT_CAN_RECOVER;
+	case pci_channel_io_frozen:
+		return PCI_ERS_RESULT_NEED_RESET;
+	case pci_channel_io_perm_failure:
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+static pci_ers_result_t genwqe_err_result_none(struct pci_dev *dev)
+{
+	return PCI_ERS_RESULT_NONE;
+}
+
+static void genwqe_err_resume(struct pci_dev *dev)
+{
+}
+
+static int genwqe_sriov_configure(struct pci_dev *dev, int numvfs)
+{
+	if (numvfs > 0) {
+		pci_enable_sriov(dev, numvfs);
+		return numvfs;
+	}
+	if (numvfs == 0) {
+		pci_disable_sriov(dev);
+		return 0;
+	}
+	return 0;
+}
+
+static struct pci_error_handlers genwqe_err_handler = {
+	.error_detected = genwqe_err_error_detected,
+	.mmio_enabled	= genwqe_err_result_none,
+	.link_reset	= genwqe_err_result_none,
+	.slot_reset	= genwqe_err_result_none,
+	.resume		= genwqe_err_resume,
+};
+
+static struct pci_driver genwqe_driver = {
+	.name	  = genwqe_driver_name,
+	.id_table = genwqe_device_table,
+	.probe	  = genwqe_probe,
+	.remove	  = genwqe_remove,
+	.sriov_configure = genwqe_sriov_configure,
+	.err_handler = &genwqe_err_handler,
+};
+
+/**
+ * genwqe_init_module() - Driver registration and initialization
+ */
+static int __init genwqe_init_module(void)
+{
+	int rc;
+
+	class_genwqe = class_create(THIS_MODULE, GENWQE_DEVNAME);
+	if (IS_ERR(class_genwqe)) {
+		pr_err("[%s] create class failed\n", __func__);
+		return -ENOMEM;
+	}
+
+	debugfs_genwqe = debugfs_create_dir(GENWQE_DEVNAME, NULL);
+	if (!debugfs_genwqe) {
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
+	rc = pci_register_driver(&genwqe_driver);
+	if (rc != 0) {
+		pr_err("[%s] pci_reg_driver (rc=%d)\n", __func__, rc);
+		goto err_out0;
+	}
+
+	return rc;
+
+ err_out0:
+	debugfs_remove(debugfs_genwqe);
+ err_out:
+	class_destroy(class_genwqe);
+	return rc;
+}
+
+/**
+ * genwqe_exit_module() - Driver exit
+ */
+static void __exit genwqe_exit_module(void)
+{
+	pci_unregister_driver(&genwqe_driver);
+	debugfs_remove(debugfs_genwqe);
+	class_destroy(class_genwqe);
+}
+
+module_init(genwqe_init_module);
+module_exit(genwqe_exit_module);
diff --git a/drivers/misc/genwqe/card_base.h b/drivers/misc/genwqe/card_base.h
new file mode 100644
index 0000000..62c2356
--- /dev/null
+++ b/drivers/misc/genwqe/card_base.h
@@ -0,0 +1,569 @@
+#ifndef __CARD_BASE_H__
+#define __CARD_BASE_H__
+
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
+ * Interfaces within the GenWQE module. Defines genwqe_card and
+ * ddcb_queue as well as ddcb_requ.
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/cdev.h>
+#include <linux/stringify.h>
+#include <linux/pci.h>
+#include <linux/semaphore.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/version.h>
+#include <linux/debugfs.h>
+
+#include <linux/genwqe/genwqe_card.h>
+#include "genwqe_driver.h"
+
+#define GENWQE_MSI_IRQS			4  /* Just one supported, no MSIx */
+#define GENWQE_FLAG_MSI_ENABLED		(1 << 0)
+
+#define GENWQE_MAX_FUNCS		16 /* 1 PF and 15 VFs */
+#define GENWQE_CARD_NO_MAX		(16 * GENWQE_MAX_FUNCS)
+
+/* Compile parameters, some of them appear in debugfs for later adjustment */
+#define genwqe_ddcb_max			32 /* DDCBs on the work-queue */
+#define genwqe_polling_enabled		0  /* in case of irqs not working */
+#define genwqe_ddcb_software_timeout	10 /* timeout per DDCB in seconds */
+#define genwqe_kill_timeout		8  /* time until process gets killed */
+
+/* Module parameters */
+extern int genwqe_pf_jobtimeout_msec;
+extern int genwqe_vf_jobtimeout_msec;
+
+/*
+ * Config space for Genwqe5 A7:
+ * 00:[14 10 4b 04]40 00 10 00[00 00 00 12]00 00 00 00
+ * 10: 0c 00 00 f0 07 3c 00 00 00 00 00 00 00 00 00 00
+ * 20: 00 00 00 00 00 00 00 00 00 00 00 00[14 10 4b 04]
+ * 30: 00 00 00 00 50 00 00 00 00 00 00 00 00 00 00 00
+ */
+#define PCI_DEVICE_GENWQE		0x044b /* Genwqe DeviceID */
+
+#define PCI_SUBSYSTEM_ID_GENWQE5	0x035f /* Genwqe A5 Subsystem-ID */
+#define PCI_SUBSYSTEM_ID_GENWQE5_NEW	0x044b /* Genwqe A5 Subsystem-ID */
+#define PCI_CLASSCODE_GENWQE5		0x1200 /* UNKNOWN */
+
+#define PCI_SUBVENDOR_ID_IBM_SRIOV	0x0000
+#define PCI_SUBSYSTEM_ID_GENWQE5_SRIOV	0x0000 /* Genwqe A5 Subsystem-ID */
+#define PCI_CLASSCODE_GENWQE5_SRIOV	0x1200 /* UNKNOWN */
+
+#define	GENWQE_SLU_ARCH_REQ		2 /* Required SLU architecture level */
+
+/*
+ * Flags for extended output (dbg_print)
+ *   We define different levels of debugging for the appropriate unit.
+ */
+#define dbg_card			0x00000001
+#define dbg_card_ddcb			0x00000004
+#define dbg_card_regs			0x00000008
+#define dbg_card_sglist			0x00000400
+#define dbg_card_pinning		0x00000800
+
+#define genwqe_dprintk(_cd, dbg_unit, fmt, ...) do {			\
+		struct genwqe_dev *__cd = (_cd);			\
+		if ((_cd)->debug & (dbg_unit))				\
+			dev_info(&__cd->pci_dev->dev, fmt,		\
+				 ## __VA_ARGS__);			\
+	} while (0)
+
+/**
+ * struct genwqe_reg - Genwqe data dump functionality
+ */
+struct genwqe_reg {
+	uint32_t addr;
+	uint32_t idx;
+	uint64_t val;
+};
+
+/*
+ * enum genwqe_dbg_type - Specify chip unit to dump/debug
+ */
+enum genwqe_dbg_type {
+	GENWQE_DBG_UNIT0 = 0,  /* captured before prev errs cleared */
+	GENWQE_DBG_UNIT1 = 1,
+	GENWQE_DBG_UNIT2 = 2,
+	GENWQE_DBG_UNIT3 = 3,
+	GENWQE_DBG_UNIT4 = 4,
+	GENWQE_DBG_UNIT5 = 5,
+	GENWQE_DBG_UNIT6 = 6,
+	GENWQE_DBG_UNIT7 = 7,
+	GENWQE_DBG_REGS  = 8,
+	GENWQE_DBG_DMA   = 9,
+	GENWQE_DBG_UNITS = 10, /* max number of possible debug units  */
+};
+
+/* Software error injection to simulate card failures */
+#define GENWQE_INJECT_HARDWARE_FAILURE	0x00000001 /* injects -1 reg reads */
+#define GENWQE_INJECT_BUS_RESET_FAILURE 0x00000002 /* pci_bus_reset fail */
+#define GENWQE_INJECT_GFIR_FATAL	0x00000004 /* GFIR = 0x0000ffff */
+#define GENWQE_INJECT_GFIR_INFO		0x00000008 /* GFIR = 0xffff0000 */
+
+/*
+ * Genwqe card description and management data.
+ *
+ * Error-handling in case of card malfunction
+ * ------------------------------------------
+ *
+ * If the card is detected to be defective the outside environment
+ * will cause the PCI layer to call deinit (the cleanup function for
+ * probe). This is the same effect like doing a unbind/bind operation
+ * on the card.
+ *
+ * The genwqe card driver implements a health checking thread which
+ * verifies the card function. If this detects a problem the cards
+ * device is being shutdown and restarted again, along with a reset of
+ * the card and queue.
+ *
+ * All functions accessing the card device return either -EIO or -ENODEV
+ * code to indicate the malfunction to the user. The user has to close
+ * the file descriptor and open a new one, once the card becomes
+ * available again.
+ *
+ * If the open file descriptor is setup to receive SIGIO, the signal is
+ * genereated for the application which has to provide a handler to
+ * react on it. If the application does not close the open
+ * file descriptor a SIGKILL is send to enforce freeing the cards
+ * resources.
+ *
+ * I did not find a different way to prevent kernel problems due to
+ * reference counters for the cards character devices getting out of
+ * sync. The character device deallocation does not block, even if
+ * there is still an open file descriptor pending. If this pending
+ * descriptor is closed, the data structures used by the character
+ * device is reinstantiated, which will lead to the reference counter
+ * dropping below the allowed values.
+ *
+ * Card recovery
+ * -------------
+ *
+ * To test the internal driver recovery the following command can be used:
+ *   sudo sh -c 'echo 0xfffff > /sys/class/genwqe/genwqe0_card/err_inject'
+ */
+
+
+/**
+ * struct dma_mapping_type - Mapping type definition
+ *
+ * To avoid memcpying data arround we use user memory directly. To do
+ * this we need to pin/swap-in the memory and request a DMA address
+ * for it.
+ */
+enum dma_mapping_type {
+	GENWQE_MAPPING_RAW = 0,		/* contignous memory buffer */
+	GENWQE_MAPPING_SGL_TEMP,	/* sglist dynamically used */
+	GENWQE_MAPPING_SGL_PINNED,	/* sglist used with pinning */
+};
+
+/**
+ * struct dma_mapping - Information about memory mappings done by the driver
+ */
+struct dma_mapping {
+	enum dma_mapping_type type;
+
+	void *u_vaddr;			/* user-space vaddr/non-aligned */
+	void *k_vaddr;			/* kernel-space vaddr/non-aligned */
+	dma_addr_t dma_addr;		/* physical DMA address */
+
+	struct page **page_list;	/* list of pages used by user buff */
+	dma_addr_t *dma_list;		/* list of dma addresses per page */
+	unsigned int nr_pages;		/* number of pages */
+	unsigned int size;		/* size in bytes */
+
+	struct list_head card_list;	/* list of usr_maps for card */
+	struct list_head pin_list;	/* list of pinned memory for dev */
+};
+
+static inline void genwqe_mapping_init(struct dma_mapping *m,
+				       enum dma_mapping_type type)
+{
+	memset(m, 0, sizeof(*m));
+	m->type = type;
+}
+
+/**
+ * struct ddcb_queue - DDCB queue data
+ * @ddcb_max:          Number of DDCBs on the queue
+ * @ddcb_next:         Next free DDCB
+ * @ddcb_act:          Next DDCB supposed to finish
+ * @ddcb_seq:          Sequence number of last DDCB
+ * @ddcbs_in_flight:   Currently enqueued DDCBs
+ * @ddcbs_completed:   Number of already completed DDCBs
+ * @busy:              Number of -EBUSY returns
+ * @ddcb_daddr:        DMA address of first DDCB in the queue
+ * @ddcb_vaddr:        Kernel virtual address of first DDCB in the queue
+ * @ddcb_req:          Associated requests (one per DDCB)
+ * @ddcb_waitqs:       Associated wait queues (one per DDCB)
+ * @ddcb_lock:         Lock to protect queuing operations
+ * @ddcb_waitq:        Wait on next DDCB finishing
+ */
+
+struct ddcb_queue {
+	int ddcb_max;			/* amount of DDCBs  */
+	int ddcb_next;			/* next available DDCB num */
+	int ddcb_act;			/* DDCB to be processed */
+	u16 ddcb_seq;			/* slc seq num */
+	unsigned int ddcbs_in_flight;	/* number of ddcbs in processing */
+	unsigned int ddcbs_completed;
+	unsigned int ddcbs_max_in_flight;
+	unsigned int busy;		/* how many times -EBUSY? */
+
+	dma_addr_t ddcb_daddr;		/* DMA address */
+	struct ddcb *ddcb_vaddr;	/* kernel virtual addr for DDCBs */
+	struct ddcb_requ **ddcb_req;	/* ddcb processing parameter */
+	wait_queue_head_t *ddcb_waitqs; /* waitqueue per ddcb */
+
+	spinlock_t ddcb_lock;		/* exclusive access to queue */
+	wait_queue_head_t ddcb_waitq;	/* wait for ddcb processing */
+
+	/* registers or the respective queue to be used */
+	u32 IO_QUEUE_CONFIG;
+	u32 IO_QUEUE_STATUS;
+	u32 IO_QUEUE_SEGMENT;
+	u32 IO_QUEUE_INITSQN;
+	u32 IO_QUEUE_WRAP;
+	u32 IO_QUEUE_OFFSET;
+	u32 IO_QUEUE_WTIME;
+	u32 IO_QUEUE_ERRCNTS;
+	u32 IO_QUEUE_LRW;
+};
+
+/*
+ * GFIR, SLU_UNITCFG, APP_UNITCFG
+ *   8 Units with FIR/FEC + 64 * 2ndary FIRS/FEC.
+ */
+#define GENWQE_FFDC_REGS	(3 + (8 * (2 + 2 * 64)))
+
+struct genwqe_ffdc {
+	unsigned int entries;
+	struct genwqe_reg *regs;
+};
+
+/**
+ * struct genwqe_dev - GenWQE device information
+ * @card_state:       Card operation state, see above
+ * @ffdc:             First Failure Data Capture buffers for each unit
+ * @card_thread:      Working thread to operate the DDCB queue
+ * @card_waitq:       Wait queue used in card_thread
+ * @queue:            DDCB queue
+ * @health_thread:    Card monitoring thread (only for PFs)
+ * @health_waitq:     Wait queue used in health_thread
+ * @pci_dev:          Associated PCI device (function)
+ * @mmio:             Base address of 64-bit register space
+ * @mmio_len:         Length of register area
+ * @file_lock:        Lock to protect access to file_list
+ * @file_list:        List of all processes with open GenWQE file descriptors
+ *
+ * This struct contains all information needed to communicate with a
+ * GenWQE card. It is initialized when a GenWQE device is found and
+ * destroyed when it goes away. It holds data to maintain the queue as
+ * well as data needed to feed the user interfaces.
+ */
+struct genwqe_dev {
+	enum genwqe_card_state card_state;
+	spinlock_t print_lock;
+
+	int card_idx;			/* card index 0..CARD_NO_MAX-1 */
+	u64 flags;			/* general flags */
+
+	/* FFDC data gathering */
+	struct genwqe_ffdc ffdc[GENWQE_DBG_UNITS];
+
+	/* DDCB workqueue */
+	struct task_struct *card_thread;
+	wait_queue_head_t queue_waitq;
+	struct ddcb_queue queue;	/* genwqe DDCB queue */
+	unsigned int irqs_processed;
+
+	/* Card health checking thread */
+	struct task_struct *health_thread;
+	wait_queue_head_t health_waitq;
+
+	/* char device */
+	dev_t  devnum_genwqe;		/* major/minor num card */
+	struct class *class_genwqe;	/* reference to class object */
+	struct device *dev;		/* for device creation */
+	struct cdev cdev_genwqe;	/* char device for card */
+
+	struct dentry *debugfs_root;	/* debugfs card root directory */
+	struct dentry *debugfs_genwqe;	/* debugfs driver root directory */
+
+	/* pci resources */
+	struct pci_dev *pci_dev;	/* PCI device */
+	void __iomem *mmio;		/* BAR-0 MMIO start */
+	unsigned long mmio_len;
+	u16 num_vfs;
+	int is_privileged;		/* access to all regs possible */
+
+	/* config regs which we need often */
+	u64 slu_unitcfg;
+	u64 app_unitcfg;
+	u64 softreset;
+	u64 err_inject;
+	u64 last_gfir;
+	char app_name[5];
+
+	spinlock_t file_lock;		/* lock for open files */
+	struct list_head file_list;	/* list of open files */
+
+	/* debugfs parameters */
+	u64 debug;			/* debug flag per card */
+	int ddcb_software_timeout;	/* wait until DDCB times out */
+	int skip_recovery;		/* circumvention if recovery fails */
+	int kill_timeout;		/* wait after sending SIGKILL */
+};
+
+/**
+ * enum genwqe_requ_state - State of a DDCB execution request
+ */
+enum genwqe_requ_state {
+	GENWQE_REQU_NEW      = 0,
+	GENWQE_REQU_ENQUEUED = 1,
+	GENWQE_REQU_TAPPED   = 2,
+	GENWQE_REQU_FINISHED = 3,
+	GENWQE_REQU_STATE_MAX,
+};
+
+/**
+ * struct ddcb_requ - Kernel internal representation of the DDCB request
+ * @cmd:          User space representation of the DDCB execution request
+ */
+struct ddcb_requ {
+	/* kernel specific content */
+	enum genwqe_requ_state req_state; /* request status */
+	int num;			  /* ddcb_no for this request */
+	struct ddcb_queue *queue;	  /* associated queue */
+
+	struct dma_mapping  dma_mappings[DDCB_FIXUPS];
+	struct sg_entry     *sgl[DDCB_FIXUPS];
+	dma_addr_t	    sgl_dma_addr[DDCB_FIXUPS];
+	size_t		    sgl_size[DDCB_FIXUPS];
+
+	/* kernel/user shared content */
+	struct genwqe_ddcb_cmd cmd;	/* ddcb_no for this request */
+	struct genwqe_debug_data debug_data;
+};
+
+/**
+ * struct genwqe_file - Information for open GenWQE devices
+ */
+struct genwqe_file {
+	struct genwqe_dev *cd;
+	struct genwqe_driver *client;
+	struct file *filp;
+
+	struct fasync_struct *async_queue;
+	struct task_struct *owner;
+	struct list_head list;		/* entry in list of open files */
+
+	spinlock_t map_lock;		/* lock for dma_mappings */
+	struct list_head map_list;	/* list of dma_mappings */
+
+	spinlock_t pin_lock;		/* lock for pinned memory */
+	struct list_head pin_list;	/* list of pinned memory */
+};
+
+int  genwqe_setup_service_layer(struct genwqe_dev *cd); /* for PF only */
+int  genwqe_finish_queue(struct genwqe_dev *cd);
+int  genwqe_release_service_layer(struct genwqe_dev *cd);
+
+/**
+ * genwqe_get_slu_id() - Read Service Layer Unit Id
+ * Return: 0x00: Development code
+ *         0x01: SLC1 (old)
+ *         0x02: SLC2 (sept2012)
+ *         0x03: SLC2 (feb2013, generic driver)
+ */
+static inline int genwqe_get_slu_id(struct genwqe_dev *cd)
+{
+	return (int)((cd->slu_unitcfg >> 32) & 0xff);
+}
+
+int  genwqe_ddcbs_in_flight(struct genwqe_dev *cd);
+
+u8   genwqe_card_type(struct genwqe_dev *cd);
+int  genwqe_card_reset(struct genwqe_dev *cd);
+int  genwqe_set_interrupt_capability(struct genwqe_dev *cd, int count);
+void genwqe_reset_interrupt_capability(struct genwqe_dev *cd);
+
+int  genwqe_device_create(struct genwqe_dev *cd);
+int  genwqe_device_remove(struct genwqe_dev *cd);
+
+/* sysfs */
+int  create_card_sysfs(struct genwqe_dev *cd);
+void remove_card_sysfs(struct genwqe_dev *cd);
+
+/* debugfs */
+int genwqe_init_debugfs(struct genwqe_dev *cd);
+void genqwe_exit_debugfs(struct genwqe_dev *cd);
+
+int  genwqe_read_softreset(struct genwqe_dev *cd);
+
+/* Hardware Circumventions */
+int  genwqe_recovery_on_fatal_gfir_required(struct genwqe_dev *cd);
+int  genwqe_flash_readback_fails(struct genwqe_dev *cd);
+
+/**
+ * genwqe_write_jtimer() - Write to job timer register
+ * @cd:    genwqe device
+ * @func:  0: PF, 1: VF0, ..., 15: VF14
+ */
+int  genwqe_write_jtimer(struct genwqe_dev *cd, int func, u64 val);
+
+/**
+ * genwqe_read_jtimer() - Read job timer register
+ * @cd:    genwqe device
+ * @func:  0: PF, 1: VF0, ..., 15: VF14
+ */
+u64  genwqe_read_jtimer(struct genwqe_dev *cd, int func);
+
+/* FFDC Buffer Management */
+int  genwqe_ffdc_buff_size(struct genwqe_dev *cd, int unit_id);
+int  genwqe_ffdc_buff_read(struct genwqe_dev *cd, int unit_id,
+			  struct genwqe_reg *regs, unsigned int max_regs);
+int  genwqe_read_ffdc_regs(struct genwqe_dev *cd, struct genwqe_reg *regs,
+			  unsigned int max_regs, int all);
+int genwqe_ffdc_dump_dma(struct genwqe_dev *cd,
+			 struct genwqe_reg *regs, unsigned int max_regs);
+
+int  genwqe_init_debug_data(struct genwqe_dev *cd,
+			    struct genwqe_debug_data *d);
+
+void init_crc32(void);
+int  genwqe_read_app_id(struct genwqe_dev *cd, char *app_name, int len);
+
+/* Memory allocation/deallocation; dma address handling */
+int  user_vmap(struct genwqe_dev *cd, struct dma_mapping *m,
+	       void *uaddr, unsigned long size,
+	       struct ddcb_requ *req);
+
+int  user_vunmap(struct genwqe_dev *cd, struct dma_mapping *m,
+		 struct ddcb_requ *req);
+
+struct sg_entry *genwqe_alloc_sgl(struct genwqe_dev *cd, int num_pages,
+				 dma_addr_t *dma_addr, size_t *sgl_size);
+
+void genwqe_free_sgl(struct genwqe_dev *cd, struct sg_entry *sg_list,
+		    dma_addr_t dma_addr, size_t size);
+
+int genwqe_setup_sgl(struct genwqe_dev *cd,
+		    unsigned long offs,
+		    unsigned long size,
+		    struct sg_entry *sgl, /* genwqe sgl */
+		    dma_addr_t dma_addr, size_t sgl_size,
+		    dma_addr_t *dma_list, int page_offs, int num_pages);
+
+int genwqe_check_sgl(struct genwqe_dev *cd, struct sg_entry *sg_list,
+		     int size);
+
+static inline bool dma_mapping_used(struct dma_mapping *m)
+{
+	if (!m)
+		return 0;
+	return (m->size != 0);
+}
+
+/**
+ * __genwqe_execute_ddcb() - Execute DDCB request with addr translation
+ *
+ * This function will do the address translation changes to the DDCBs
+ * according to the definitions required by the ATS field. It looks up
+ * the memory allocation buffer or does vmap/vunmap for the respective
+ * user-space buffers, inclusive page pinning and scatter gather list
+ * buildup and teardown.
+ */
+int  __genwqe_execute_ddcb(struct genwqe_dev *cd,
+			   struct genwqe_ddcb_cmd *cmd);
+
+/**
+ * __genwqe_execute_raw_ddcb() - Execute DDCB request without addr translation
+ *
+ * This version will not do address translation or any modifcation of
+ * the DDCB data. It is used e.g. for the MoveFlash DDCB which is
+ * entirely prepared by the driver itself. That means the appropriate
+ * DMA addresses are already in the DDCB and do not need any
+ * modification.
+ */
+int  __genwqe_execute_raw_ddcb(struct genwqe_dev *cd,
+			       struct genwqe_ddcb_cmd *cmd);
+
+int  __genwqe_enqueue_ddcb(struct genwqe_dev *cd, struct ddcb_requ *req);
+int  __genwqe_wait_ddcb(struct genwqe_dev *cd, struct ddcb_requ *req);
+int  __genwqe_purge_ddcb(struct genwqe_dev *cd, struct ddcb_requ *req);
+
+/* register access */
+int __genwqe_writeq(struct genwqe_dev *cd, u64 byte_offs, u64 val);
+u64 __genwqe_readq(struct genwqe_dev *cd, u64 byte_offs);
+int __genwqe_writel(struct genwqe_dev *cd, u64 byte_offs, u32 val);
+u32 __genwqe_readl(struct genwqe_dev *cd, u64 byte_offs);
+
+void *__genwqe_alloc_consistent(struct genwqe_dev *cd, size_t size,
+				 dma_addr_t *dma_handle);
+void __genwqe_free_consistent(struct genwqe_dev *cd, size_t size,
+			      void *vaddr, dma_addr_t dma_handle);
+
+/* Base clock frequency in MHz */
+int  genwqe_base_clock_frequency(struct genwqe_dev *cd);
+
+/* Before FFDC is captured the traps should be stopped. */
+void genwqe_stop_traps(struct genwqe_dev *cd);
+void genwqe_start_traps(struct genwqe_dev *cd);
+
+/* Hardware circumvention */
+bool genwqe_need_err_masking(struct genwqe_dev *cd);
+
+/**
+ * genwqe_is_privileged() - Determine operation mode for PCI function
+ *
+ * On Intel with SRIOV support we see:
+ *   PF: is_physfn = 1 is_virtfn = 0
+ *   VF: is_physfn = 0 is_virtfn = 1
+ *
+ * On Systems with no SRIOV support _and_ virtualized systems we get:
+ *       is_physfn = 0 is_virtfn = 0
+ *
+ * Other vendors have individual pci device ids to distinguish between
+ * virtual function drivers and physical function drivers. GenWQE
+ * unfortunately has just on pci device id for both, VFs and PF.
+ *
+ * The following code is used to distinguish if the card is running in
+ * privileged mode, either as true PF or in a virtualized system with
+ * full register access e.g. currently on PowerPC.
+ *
+ * if (pci_dev->is_virtfn)
+ *          cd->is_privileged = 0;
+ *  else
+ *          cd->is_privileged = (__genwqe_readq(cd, IO_SLU_BITSTREAM)
+ *				 != IO_ILLEGAL_VALUE);
+ */
+static inline int genwqe_is_privileged(struct genwqe_dev *cd)
+{
+	return cd->is_privileged;
+}
+
+#endif	/* __CARD_BASE_H__ */
diff --git a/drivers/misc/genwqe/card_ddcb.c b/drivers/misc/genwqe/card_ddcb.c
new file mode 100644
index 0000000..3d4d212
--- /dev/null
+++ b/drivers/misc/genwqe/card_ddcb.c
@@ -0,0 +1,1380 @@
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
+ * Device Driver Control Block (DDCB) queue support. Definition of
+ * interrupt handlers for queue support as well as triggering the
+ * health monitor code in case of problems. The current hardware uses
+ * an MSI interrupt which is shared between error handling and
+ * functional code.
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/pci.h>
+#include <linux/string.h>
+#include <linux/dma-mapping.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/crc-itu-t.h>
+
+#include "card_ddcb.h"
+
+/*
+ * N: next DDCB, this is where the next DDCB will be put.
+ * A: active DDCB, this is where the code will look for the next completion.
+ * x: DDCB is enqueued, we are waiting for its completion.
+
+ * Situation (1): Empty queue
+ *  +---+---+---+---+---+---+---+---+
+ *  | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
+ *  |   |   |   |   |   |   |   |   |
+ *  +---+---+---+---+---+---+---+---+
+ *           A/N
+ *  enqueued_ddcbs = A - N = 2 - 2 = 0
+ *
+ * Situation (2): Wrapped, N > A
+ *  +---+---+---+---+---+---+---+---+
+ *  | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
+ *  |   |   | x | x |   |   |   |   |
+ *  +---+---+---+---+---+---+---+---+
+ *            A       N
+ *  enqueued_ddcbs = N - A = 4 - 2 = 2
+ *
+ * Situation (3): Queue wrapped, A > N
+ *  +---+---+---+---+---+---+---+---+
+ *  | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
+ *  | x | x |   |   | x | x | x | x |
+ *  +---+---+---+---+---+---+---+---+
+ *            N       A
+ *  enqueued_ddcbs = queue_max  - (A - N) = 8 - (4 - 2) = 6
+ *
+ * Situation (4a): Queue full N > A
+ *  +---+---+---+---+---+---+---+---+
+ *  | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
+ *  | x | x | x | x | x | x | x |   |
+ *  +---+---+---+---+---+---+---+---+
+ *    A                           N
+ *
+ *  enqueued_ddcbs = N - A = 7 - 0 = 7
+ *
+ * Situation (4a): Queue full A > N
+ *  +---+---+---+---+---+---+---+---+
+ *  | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
+ *  | x | x | x |   | x | x | x | x |
+ *  +---+---+---+---+---+---+---+---+
+ *                N   A
+ *  enqueued_ddcbs = queue_max - (A - N) = 8 - (4 - 3) = 7
+ */
+
+static int queue_empty(struct ddcb_queue *queue)
+{
+	return (queue->ddcb_next == queue->ddcb_act);
+}
+
+static int queue_enqueued_ddcbs(struct ddcb_queue *queue)
+{
+	if (queue->ddcb_next >= queue->ddcb_act)
+		return queue->ddcb_next - queue->ddcb_act;
+
+	return queue->ddcb_max - (queue->ddcb_act - queue->ddcb_next);
+}
+
+static int queue_free_ddcbs(struct ddcb_queue *queue)
+{
+	int free_ddcbs = queue->ddcb_max - queue_enqueued_ddcbs(queue) - 1;
+
+	if (WARN_ON_ONCE(free_ddcbs < 0)) { /* must never ever happen! */
+		return 0;
+	}
+	return free_ddcbs;
+}
+
+/*
+ * Use of the PRIV field in the DDCB for queue debugging:
+ *
+ * (1) Trying to get rid of a DDCB which saw a timeout:
+ *     pddcb->priv[6] = 0xcc;   # cleared
+ *
+ * (2) Append a DDCB via NEXT bit:
+ *     pddcb->priv[7] = 0xaa;	# appended
+ *
+ * (3) DDCB needed tapping:
+ *     pddcb->priv[7] = 0xbb;   # tapped
+ *
+ * (4) DDCB marked as correctly finished:
+ *     pddcb->priv[6] = 0xff;	# finished
+ */
+
+static inline void ddcb_mark_tapped(struct ddcb *pddcb)
+{
+	pddcb->priv[7] = 0xbb;  /* tapped */
+}
+
+static inline void ddcb_mark_appended(struct ddcb *pddcb)
+{
+	pddcb->priv[7] = 0xaa;	/* appended */
+}
+
+static inline void ddcb_mark_cleared(struct ddcb *pddcb)
+{
+	pddcb->priv[6] = 0xcc; /* cleared */
+}
+
+static inline void ddcb_mark_finished(struct ddcb *pddcb)
+{
+	pddcb->priv[6] = 0xff;	/* finished */
+}
+
+static inline void ddcb_mark_unused(struct ddcb *pddcb)
+{
+	pddcb->priv_64 = cpu_to_be64(0); /* not tapped */
+}
+
+/**
+ * genwqe_crc16() - Generate 16-bit crc as required for DDCBs
+ * @buff:       pointer to data buffer
+ * @len:        length of data for calculation
+ * @init:       initial crc (0xffff at start)
+ *
+ * Polynomial = x^16 + x^12 + x^5 + 1   (0x1021)
+ * Example: 4 bytes 0x01 0x02 0x03 0x04 with init = 0xffff
+ *          should result in a crc16 of 0x89c3
+ *
+ * Return: crc16 checksum in big endian format !
+ */
+static inline u16 genwqe_crc16(const u8 *buff, size_t len, u16 init)
+{
+	return crc_itu_t(init, buff, len);
+}
+
+static void print_ddcb_info(struct genwqe_dev *cd, struct ddcb_queue *queue)
+{
+	int i;
+	struct ddcb *pddcb;
+	unsigned long flags;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	spin_lock_irqsave(&cd->print_lock, flags);
+
+	dev_info(&pci_dev->dev,
+		 "DDCB list for card #%d (ddcb_act=%d / ddcb_next=%d):\n",
+		 cd->card_idx, queue->ddcb_act, queue->ddcb_next);
+
+	pddcb = queue->ddcb_vaddr;
+	for (i = 0; i < queue->ddcb_max; i++) {
+		dev_err(&pci_dev->dev,
+			"  %c %-3d: RETC=%03x SEQ=%04x "
+			"HSI=%02X SHI=%02x PRIV=%06llx CMD=%03x\n",
+			i == queue->ddcb_act ? '>' : ' ',
+			i,
+			be16_to_cpu(pddcb->retc_16),
+			be16_to_cpu(pddcb->seqnum_16),
+			pddcb->hsi,
+			pddcb->shi,
+			be64_to_cpu(pddcb->priv_64),
+			pddcb->cmd);
+		pddcb++;
+	}
+	spin_unlock_irqrestore(&cd->print_lock, flags);
+}
+
+struct genwqe_ddcb_cmd *ddcb_requ_alloc(void)
+{
+	struct ddcb_requ *req;
+
+	req = kzalloc(sizeof(*req), GFP_ATOMIC);
+	if (!req)
+		return NULL;
+
+	return &req->cmd;
+}
+
+void ddcb_requ_free(struct genwqe_ddcb_cmd *cmd)
+{
+	struct ddcb_requ *req = container_of(cmd, struct ddcb_requ, cmd);
+	kfree(req);
+}
+
+static inline enum genwqe_requ_state ddcb_requ_get_state(struct ddcb_requ *req)
+{
+	return req->req_state;
+}
+
+static inline void ddcb_requ_set_state(struct ddcb_requ *req,
+				       enum genwqe_requ_state new_state)
+{
+	req->req_state = new_state;
+}
+
+static inline int ddcb_requ_collect_debug_data(struct ddcb_requ *req)
+{
+	return (req->cmd.debug_data != NULL);
+}
+
+/**
+ * ddcb_requ_finished() - Returns the hardware state of the associated DDCB
+ * @cd:          pointer to genwqe device descriptor
+ * @req:         DDCB work request
+ *
+ * Status of ddcb_requ mirrors this hardware state, but is copied in
+ * the ddcb_requ on interrupt/polling function. The lowlevel code
+ * should check the hardware state directly, the higher level code
+ * should check the copy.
+ *
+ * This function will also return true if the state of the queue is
+ * not GENWQE_CARD_USED. This enables us to purge all DDCBs in the
+ * shutdown case.
+ */
+static int ddcb_requ_finished(struct genwqe_dev *cd, struct ddcb_requ *req)
+{
+	return ((ddcb_requ_get_state(req) == GENWQE_REQU_FINISHED) ||
+		(cd->card_state != GENWQE_CARD_USED));
+}
+
+/**
+ * enqueue_ddcb() - Enqueue a DDCB
+ * @cd:         pointer to genwqe device descriptor
+ * @queue:	queue this operation should be done on
+ * @ddcb_no:    pointer to ddcb number being tapped
+ *
+ * Start execution of DDCB by tapping or append to queue via NEXT
+ * bit. This is done by an atomic 'compare and swap' instruction and
+ * checking SHI and HSI of the previous DDCB.
+ *
+ * This function must only be called with ddcb_lock held.
+ *
+ * Return: 1 if new DDCB is appended to previous
+ *         2 if DDCB queue is tapped via register/simulation
+ */
+#define RET_DDCB_APPENDED 1
+#define RET_DDCB_TAPPED   2
+
+static int enqueue_ddcb(struct genwqe_dev *cd, struct ddcb_queue *queue,
+			struct ddcb *pddcb, int ddcb_no)
+{
+	unsigned int try;
+	int prev_no;
+	struct ddcb *prev_ddcb;
+	u32 old, new, icrc_hsi_shi;
+	u64 num;
+
+	/*
+	 * For performance checks a Dispatch Timestamp can be put into
+	 * DDCB It is supposed to use the SLU's free running counter,
+	 * but this requires PCIe cycles.
+	 */
+	ddcb_mark_unused(pddcb);
+
+	/* check previous DDCB if already fetched */
+	prev_no = (ddcb_no == 0) ? queue->ddcb_max - 1 : ddcb_no - 1;
+	prev_ddcb = &queue->ddcb_vaddr[prev_no];
+
+	/*
+	 * It might have happened that the HSI.FETCHED bit is
+	 * set. Retry in this case. Therefore I expect maximum 2 times
+	 * trying.
+	 */
+	ddcb_mark_appended(pddcb);
+	for (try = 0; try < 2; try++) {
+		old = prev_ddcb->icrc_hsi_shi_32; /* read SHI/HSI in BE32 */
+
+		/* try to append via NEXT bit if prev DDCB is not completed */
+		if ((old & DDCB_COMPLETED_BE32) != 0x00000000)
+			break;
+
+		new = (old | DDCB_NEXT_BE32);
+		icrc_hsi_shi = cmpxchg(&prev_ddcb->icrc_hsi_shi_32, old, new);
+
+		if (icrc_hsi_shi == old)
+			return RET_DDCB_APPENDED; /* appended to queue */
+	}
+
+	/* Queue must be re-started by updating QUEUE_OFFSET */
+	ddcb_mark_tapped(pddcb);
+	num = (u64)ddcb_no << 8;
+	__genwqe_writeq(cd, queue->IO_QUEUE_OFFSET, num); /* start queue */
+
+	return RET_DDCB_TAPPED;
+}
+
+/**
+ * copy_ddcb_results() - Copy output state from real DDCB to request
+ *
+ * Copy DDCB ASV to request struct. There is no endian
+ * conversion made, since data structure in ASV is still
+ * unknown here.
+ *
+ * This is needed by:
+ *   - genwqe_purge_ddcb()
+ *   - genwqe_check_ddcb_queue()
+ */
+static void copy_ddcb_results(struct ddcb_requ *req, int ddcb_no)
+{
+	struct ddcb_queue *queue = req->queue;
+	struct ddcb *pddcb = &queue->ddcb_vaddr[req->num];
+
+	memcpy(&req->cmd.asv[0], &pddcb->asv[0], DDCB_ASV_LENGTH);
+
+	/* copy status flags of the variant part */
+	req->cmd.vcrc     = be16_to_cpu(pddcb->vcrc_16);
+	req->cmd.deque_ts = be64_to_cpu(pddcb->deque_ts_64);
+	req->cmd.cmplt_ts = be64_to_cpu(pddcb->cmplt_ts_64);
+
+	req->cmd.attn     = be16_to_cpu(pddcb->attn_16);
+	req->cmd.progress = be32_to_cpu(pddcb->progress_32);
+	req->cmd.retc     = be16_to_cpu(pddcb->retc_16);
+
+	if (ddcb_requ_collect_debug_data(req)) {
+		int prev_no = (ddcb_no == 0) ?
+			queue->ddcb_max - 1 : ddcb_no - 1;
+		struct ddcb *prev_pddcb = &queue->ddcb_vaddr[prev_no];
+
+		memcpy(&req->debug_data.ddcb_finished, pddcb,
+		       sizeof(req->debug_data.ddcb_finished));
+		memcpy(&req->debug_data.ddcb_prev, prev_pddcb,
+		       sizeof(req->debug_data.ddcb_prev));
+	}
+}
+
+/**
+ * genwqe_check_ddcb_queue() - Checks DDCB queue for completed work equests.
+ * @cd:         pointer to genwqe device descriptor
+ *
+ * Return: Number of DDCBs which were finished
+ */
+static int genwqe_check_ddcb_queue(struct genwqe_dev *cd,
+				   struct ddcb_queue *queue)
+{
+	unsigned long flags;
+	int ddcbs_finished = 0;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	spin_lock_irqsave(&queue->ddcb_lock, flags);
+
+	/* FIXME avoid soft locking CPU */
+	while (!queue_empty(queue) && (ddcbs_finished < queue->ddcb_max)) {
+
+		struct ddcb *pddcb;
+		struct ddcb_requ *req;
+		u16 vcrc, vcrc_16, retc_16;
+
+		pddcb = &queue->ddcb_vaddr[queue->ddcb_act];
+
+		if ((pddcb->icrc_hsi_shi_32 & DDCB_COMPLETED_BE32) ==
+		    0x00000000)
+			goto go_home; /* not completed, continue waiting */
+
+		/* Note: DDCB could be purged */
+
+		req = queue->ddcb_req[queue->ddcb_act];
+		if (req == NULL) {
+			/* this occurs if DDCB is purged, not an error */
+			/* Move active DDCB further; Nothing to do anymore. */
+			goto pick_next_one;
+		}
+
+		/*
+		 * HSI=0x44 (fetched and completed), but RETC is
+		 * 0x101, or even worse 0x000.
+		 *
+		 * In case of seeing the queue in inconsistent state
+		 * we read the errcnts and the queue status to provide
+		 * a trigger for our PCIe analyzer stop capturing.
+		 */
+		retc_16 = be16_to_cpu(pddcb->retc_16);
+		if ((pddcb->hsi == 0x44) && (retc_16 <= 0x101)) {
+			u64 errcnts, status;
+			u64 ddcb_offs = (u64)pddcb - (u64)queue->ddcb_vaddr;
+
+			errcnts = __genwqe_readq(cd, queue->IO_QUEUE_ERRCNTS);
+			status  = __genwqe_readq(cd, queue->IO_QUEUE_STATUS);
+
+			dev_err(&pci_dev->dev,
+				"[%s] SEQN=%04x HSI=%02x RETC=%03x "
+				" Q_ERRCNTS=%016llx Q_STATUS=%016llx\n"
+				" DDCB_DMA_ADDR=%016llx\n",
+				__func__, be16_to_cpu(pddcb->seqnum_16),
+				pddcb->hsi, retc_16, errcnts, status,
+				queue->ddcb_daddr + ddcb_offs);
+		}
+
+		copy_ddcb_results(req, queue->ddcb_act);
+		queue->ddcb_req[queue->ddcb_act] = NULL; /* take from queue */
+
+		if (cd->debug & dbg_card_ddcb) {
+			genwqe_dprintk(cd, dbg_card_ddcb, "FINISHED DDCB#%d\n",
+				       req->num);
+			genwqe_hexdump(pci_dev, pddcb, sizeof(*pddcb));
+		}
+
+		ddcb_mark_finished(pddcb);
+
+		/* calculate CRC_16 to see if VCRC is correct */
+		vcrc = genwqe_crc16(pddcb->asv,
+				   VCRC_LENGTH(req->cmd.asv_length),
+				   0xffff);
+		vcrc_16 = be16_to_cpu(pddcb->vcrc_16);
+		if (vcrc != vcrc_16) {
+			printk_ratelimited(KERN_ERR
+				"%s %s: err: wrong VCRC pre=%02x vcrc_len=%d "
+				"bytes vcrc_data=%04x is not vcrc_card=%04x\n",
+				GENWQE_DEVNAME, dev_name(&pci_dev->dev),
+				pddcb->pre, VCRC_LENGTH(req->cmd.asv_length),
+				vcrc, vcrc_16);
+		}
+
+		ddcb_requ_set_state(req, GENWQE_REQU_FINISHED);
+		queue->ddcbs_completed++;
+		queue->ddcbs_in_flight--;
+
+		/* wake up process waiting for this DDCB */
+		wake_up_interruptible(&queue->ddcb_waitqs[queue->ddcb_act]);
+
+pick_next_one:
+		queue->ddcb_act = (queue->ddcb_act + 1) % queue->ddcb_max;
+		ddcbs_finished++;
+	}
+
+ go_home:
+	spin_unlock_irqrestore(&queue->ddcb_lock, flags);
+	return ddcbs_finished;
+}
+
+/**
+ * __genwqe_wait_ddcb(): Waits until DDCB is completed
+ * @cd:         pointer to genwqe device descriptor
+ * @req:        pointer to requsted DDCB parameters
+ *
+ * The Service Layer will update the RETC in DDCB when processing is
+ * pending or done.
+ *
+ * Return: > 0 remaining jiffies, DDCB completed
+ *           -ETIMEDOUT	when timeout
+ *           -ERESTARTSYS when ^C
+ *           -EINVAL when unknown error condition
+ *
+ * When an error is returned the called needs to ensure that
+ * purge_ddcb() is being called to get the &req removed from the
+ * queue.
+ */
+int __genwqe_wait_ddcb(struct genwqe_dev *cd, struct ddcb_requ *req)
+{
+	int rc;
+	unsigned int ddcb_no;
+	struct ddcb_queue *queue;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	if (req == NULL)
+		return -EINVAL;
+
+	queue = req->queue;
+	if (queue == NULL)
+		return -EINVAL;
+
+	ddcb_no = req->num;
+	if (ddcb_no >= queue->ddcb_max)
+		return -EINVAL;
+
+	rc = wait_event_interruptible_timeout(queue->ddcb_waitqs[ddcb_no],
+				ddcb_requ_finished(cd, req),
+				genwqe_ddcb_software_timeout * HZ);
+
+	/*
+	 * We need to distinguish 3 cases here:
+	 *   1. rc == 0              timeout occured
+	 *   2. rc == -ERESTARTSYS   signal received
+	 *   3. rc > 0               remaining jiffies condition is true
+	 */
+	if (rc == 0) {
+		struct ddcb_queue *queue = req->queue;
+
+		/*
+		 * Timeout may be caused by long task switching time.
+		 * When timeout happens, check if the request has
+		 * meanwhile completed.
+		 */
+		genwqe_check_ddcb_queue(cd, req->queue);
+		if (ddcb_requ_finished(cd, req))
+			return rc;
+
+		dev_err(&pci_dev->dev,
+			"[%s] err: DDCB#%d timeout rc=%d state=%d req @ %p\n",
+			__func__, req->num, rc,	ddcb_requ_get_state(req),
+			req);
+		dev_err(&pci_dev->dev,
+			"[%s]      IO_QUEUE_STATUS=0x%016llx\n", __func__,
+			__genwqe_readq(cd, queue->IO_QUEUE_STATUS));
+
+		if (cd->debug & dbg_card_ddcb) {
+			struct ddcb *pddcb = &queue->ddcb_vaddr[req->num];
+			genwqe_hexdump(pci_dev, pddcb, sizeof(*pddcb));
+		}
+		print_ddcb_info(cd, req->queue);
+		return -ETIMEDOUT;
+
+	} else if (rc == -ERESTARTSYS) {
+		return rc;
+		/*
+		 * EINTR:       Stops the application
+		 * ERESTARTSYS: Restartable systemcall; called again
+		 */
+
+	} else if (rc < 0) {
+		dev_err(&pci_dev->dev,
+			"[%s] err: DDCB#%d unknown result (rc=%d) %d!\n",
+			__func__, req->num, rc, ddcb_requ_get_state(req));
+		return -EINVAL;
+	}
+
+	/* Severe error occured. Driver is forced to stop operation */
+	if (cd->card_state != GENWQE_CARD_USED) {
+		dev_err(&pci_dev->dev,
+			"[%s] err: DDCB#%d forced to stop (rc=%d)\n",
+			__func__, req->num, rc);
+		return -EIO;
+	}
+	return rc;
+}
+
+/**
+ * get_next_ddcb() - Get next available DDCB
+ * @cd:         pointer to genwqe device descriptor
+ *
+ * DDCB's content is completely cleared but presets for PRE and
+ * SEQNUM. This function must only be called when ddcb_lock is held.
+ *
+ * Return: NULL if no empty DDCB available otherwise ptr to next DDCB.
+ */
+static struct ddcb *get_next_ddcb(struct genwqe_dev *cd,
+				  struct ddcb_queue *queue,
+				  int *num)
+{
+	u64 *pu64;
+	struct ddcb *pddcb;
+
+	if (queue_free_ddcbs(queue) == 0) /* queue is  full */
+		return NULL;
+
+	/* find new ddcb */
+	pddcb = &queue->ddcb_vaddr[queue->ddcb_next];
+
+	/* if it is not completed, we are not allowed to use it */
+	/* barrier(); */
+	if ((pddcb->icrc_hsi_shi_32 & DDCB_COMPLETED_BE32) == 0x00000000)
+		return NULL;
+
+	*num = queue->ddcb_next;	/* internal DDCB number */
+	queue->ddcb_next = (queue->ddcb_next + 1) % queue->ddcb_max;
+
+	/* clear important DDCB fields */
+	pu64 = (u64 *)pddcb;
+	pu64[0] = 0ULL;		/* offs 0x00 (ICRC,HSI,SHI,...) */
+	pu64[1] = 0ULL;		/* offs 0x01 (ACFUNC,CMD...) */
+
+	/* destroy previous results in ASV */
+	pu64[0x80/8] = 0ULL;	/* offs 0x80 (ASV + 0) */
+	pu64[0x88/8] = 0ULL;	/* offs 0x88 (ASV + 0x08) */
+	pu64[0x90/8] = 0ULL;	/* offs 0x90 (ASV + 0x10) */
+	pu64[0x98/8] = 0ULL;	/* offs 0x98 (ASV + 0x18) */
+	pu64[0xd0/8] = 0ULL;	/* offs 0xd0 (RETC,ATTN...) */
+
+	pddcb->pre = DDCB_PRESET_PRE; /* 128 */
+	pddcb->seqnum_16 = cpu_to_be16(queue->ddcb_seq++);
+	return pddcb;
+}
+
+/**
+ * __genwqe_purge_ddcb() - Remove a DDCB from the workqueue
+ * @cd:         genwqe device descriptor
+ * @req:        DDCB request
+ *
+ * This will fail when the request was already FETCHED. In this case
+ * we need to wait until it is finished. Else the DDCB can be
+ * reused. This function also ensures that the request data structure
+ * is removed from ddcb_req[].
+ *
+ * Do not forget to call this function when genwqe_wait_ddcb() fails,
+ * such that the request gets really removed from ddcb_req[].
+ *
+ * Return: 0 success
+ */
+int __genwqe_purge_ddcb(struct genwqe_dev *cd, struct ddcb_requ *req)
+{
+	struct ddcb *pddcb = NULL;
+	unsigned int t;
+	unsigned long flags;
+	struct ddcb_queue *queue = req->queue;
+	struct pci_dev *pci_dev = cd->pci_dev;
+	u32 icrc_hsi_shi = 0x0000;
+	u64 queue_status;
+	u32 old, new;
+
+	/* unsigned long flags; */
+	if (genwqe_ddcb_software_timeout <= 0) {
+		dev_err(&pci_dev->dev,
+			"[%s] err: software timeout is not set!\n", __func__);
+		return -EFAULT;
+	}
+
+	pddcb = &queue->ddcb_vaddr[req->num];
+
+	for (t = 0; t < genwqe_ddcb_software_timeout * 10; t++) {
+
+		spin_lock_irqsave(&queue->ddcb_lock, flags);
+
+		/* Check if req was meanwhile finished */
+		if (ddcb_requ_get_state(req) == GENWQE_REQU_FINISHED)
+			goto go_home;
+
+		/* try to set PURGE bit if FETCHED/COMPLETED are not set */
+		old = pddcb->icrc_hsi_shi_32;	/* read SHI/HSI in BE32 */
+		if ((old & DDCB_FETCHED_BE32) == 0x00000000) {
+
+			new = (old | DDCB_PURGE_BE32);
+			icrc_hsi_shi = cmpxchg(&pddcb->icrc_hsi_shi_32,
+					       old, new);
+			if (icrc_hsi_shi == old)
+				goto finish_ddcb;
+		}
+
+		/* normal finish with HSI bit */
+		barrier();
+		icrc_hsi_shi = pddcb->icrc_hsi_shi_32;
+		if (icrc_hsi_shi & DDCB_COMPLETED_BE32)
+			goto finish_ddcb;
+
+		spin_unlock_irqrestore(&queue->ddcb_lock, flags);
+
+		/*
+		 * Here the check_ddcb() function will most likely
+		 * discover this DDCB to be finished some point in
+		 * time. It will mark the req finished and free it up
+		 * in the list.
+		 */
+
+		copy_ddcb_results(req, req->num); /* for the failing case */
+		msleep(100); /* sleep for 1/10 second and try again */
+		continue;
+
+finish_ddcb:
+		copy_ddcb_results(req, req->num);
+		ddcb_requ_set_state(req, GENWQE_REQU_FINISHED);
+		queue->ddcbs_in_flight--;
+		queue->ddcb_req[req->num] = NULL; /* delete from array */
+		ddcb_mark_cleared(pddcb);
+
+		/* Move active DDCB further; Nothing to do here anymore. */
+
+		/*
+		 * We need to ensure that there is at least one free
+		 * DDCB in the queue. To do that, we must update
+		 * ddcb_act only if the COMPLETED bit is set for the
+		 * DDCB we are working on else we treat that DDCB even
+		 * if we PURGED it as occupied (hardware is supposed
+		 * to set the COMPLETED bit yet!).
+		 */
+		icrc_hsi_shi = pddcb->icrc_hsi_shi_32;
+		if ((icrc_hsi_shi & DDCB_COMPLETED_BE32) &&
+		    (queue->ddcb_act == req->num)) {
+			queue->ddcb_act = ((queue->ddcb_act + 1) %
+					   queue->ddcb_max);
+		}
+go_home:
+		spin_unlock_irqrestore(&queue->ddcb_lock, flags);
+		return 0;
+	}
+
+	/*
+	 * If the card is dead and the queue is forced to stop, we
+	 * might see this in the queue status register.
+	 */
+	queue_status = __genwqe_readq(cd, queue->IO_QUEUE_STATUS);
+
+	if (cd->debug & dbg_card_ddcb) {
+		genwqe_dprintk(cd, dbg_card_ddcb, "UN/FINISHED DDCB#%d\n",
+			       req->num);
+		genwqe_hexdump(pci_dev, pddcb, sizeof(*pddcb));
+	}
+	dev_err(&pci_dev->dev,
+		"[%s] err: DDCB#%d not purged and not completed "
+		"after %d seconds QSTAT=%016llx!!\n",
+		__func__, req->num, genwqe_ddcb_software_timeout,
+		queue_status);
+
+	print_ddcb_info(cd, req->queue);
+
+	return -EFAULT;
+}
+
+int genwqe_init_debug_data(struct genwqe_dev *cd, struct genwqe_debug_data *d)
+{
+	int len;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	if (d == NULL) {
+		dev_err(&pci_dev->dev,
+			"[%s] err: invalid memory for debug data!\n",
+			__func__);
+		return -EFAULT;
+	}
+
+	len  = sizeof(d->driver_version);
+	snprintf(d->driver_version, len, "%s", DRV_VERS_STRING);
+	d->slu_unitcfg = cd->slu_unitcfg;
+	d->app_unitcfg = cd->app_unitcfg;
+	return 0;
+}
+
+/**
+ * __genwqe_enqueue_ddcb() - Enqueue a DDCB
+ * @cd:          pointer to genwqe device descriptor
+ * @req:         pointer to DDCB execution request
+ *
+ * Return: 0 if enqueuing succeeded
+ *         -EIO if card is unusable/PCIe problems
+ *         -EBUSY if enqueuing failed
+ */
+int __genwqe_enqueue_ddcb(struct genwqe_dev *cd, struct ddcb_requ *req)
+{
+	struct ddcb *pddcb;
+	unsigned long flags;
+	struct ddcb_queue *queue;
+	struct pci_dev *pci_dev = cd->pci_dev;
+	u16 icrc;
+
+	if (cd->card_state != GENWQE_CARD_USED) {
+		printk_ratelimited(KERN_ERR
+			"%s %s: [%s] Card is unusable/PCIe problem Req#%d\n",
+			GENWQE_DEVNAME, dev_name(&pci_dev->dev),
+			__func__, req->num);
+		return -EIO;
+	}
+
+	queue = req->queue = &cd->queue;
+
+	/* FIXME circumvention to improve performance when no irq is
+	 * there.
+	 */
+	if (genwqe_polling_enabled)
+		genwqe_check_ddcb_queue(cd, queue);
+
+	/*
+	 * It must be ensured to process all DDCBs in successive
+	 * order. Use a lock here in order to prevent nested DDCB
+	 * enqueuing.
+	 */
+	spin_lock_irqsave(&queue->ddcb_lock, flags);
+
+	pddcb = get_next_ddcb(cd, queue, &req->num);	/* get ptr and num */
+	if (pddcb == NULL) {
+		spin_unlock_irqrestore(&queue->ddcb_lock, flags);
+		queue->busy++;
+		return -EBUSY;
+	}
+
+	if (queue->ddcb_req[req->num] != NULL) {
+		spin_unlock_irqrestore(&queue->ddcb_lock, flags);
+
+		dev_err(&pci_dev->dev,
+			"[%s] picked DDCB %d with req=%p still in use!!\n",
+			__func__, req->num, req);
+		return -EFAULT;
+	}
+	ddcb_requ_set_state(req, GENWQE_REQU_ENQUEUED);
+	queue->ddcb_req[req->num] = req;
+
+	pddcb->cmdopts_16 = cpu_to_be16(req->cmd.cmdopts);
+	pddcb->cmd = req->cmd.cmd;
+	pddcb->acfunc = req->cmd.acfunc;	/* functional unit */
+
+	/*
+	 * We know that we can get retc 0x104 with CRC error, do not
+	 * stop the queue in those cases for this command. XDIR = 1
+	 * does not work for old SLU versions.
+	 *
+	 * Last bitstream with the old XDIR behavior had SLU_ID
+	 * 0x34199.
+	 */
+	if ((cd->slu_unitcfg & 0xFFFF0ull) > 0x34199ull)
+		pddcb->xdir = 0x1;
+	else
+		pddcb->xdir = 0x0;
+
+
+	pddcb->psp = (((req->cmd.asiv_length / 8) << 4) |
+		      ((req->cmd.asv_length  / 8)));
+	pddcb->disp_ts_64 = cpu_to_be64(req->cmd.disp_ts);
+
+	/*
+	 * If copying the whole DDCB_ASIV_LENGTH is impacting
+	 * performance we need to change it to
+	 * req->cmd.asiv_length. But simulation benefits from some
+	 * non-architectured bits behind the architectured content.
+	 *
+	 * How much data is copied depends on the availability of the
+	 * ATS field, which was introduced late. If the ATS field is
+	 * supported ASIV is 8 bytes shorter than it used to be. Since
+	 * the ATS field is copied too, the code should do exactly
+	 * what it did before, but I wanted to make copying of the ATS
+	 * field very explicit.
+	 */
+	if (genwqe_get_slu_id(cd) <= 0x2) {
+		memcpy(&pddcb->__asiv[0],	/* destination */
+		       &req->cmd.__asiv[0],	/* source */
+		       DDCB_ASIV_LENGTH);	/* req->cmd.asiv_length */
+	} else {
+		pddcb->n.ats_64 = req->cmd.ats;
+		memcpy(&pddcb->n.asiv[0],		/* destination */
+			&req->cmd.asiv[0],	/* source */
+			DDCB_ASIV_LENGTH_ATS);	/* req->cmd.asiv_length */
+	}
+
+	pddcb->icrc_hsi_shi_32 = cpu_to_be32(0x00000000); /* for crc */
+
+	/*
+	 * Calculate CRC_16 for corresponding range PSP(7:4). Include
+	 * empty 4 bytes prior to the data.
+	 */
+	icrc = genwqe_crc16((const u8 *)pddcb,
+			   ICRC_LENGTH(req->cmd.asiv_length), 0xffff);
+	pddcb->icrc_hsi_shi_32 = cpu_to_be32((u32)icrc << 16);
+
+	/* enable DDCB completion irq */
+	if (!genwqe_polling_enabled)
+		pddcb->icrc_hsi_shi_32 |= DDCB_INTR_BE32;
+
+	if (cd->debug & dbg_card_ddcb) {
+		genwqe_dprintk(cd, dbg_card_ddcb, "INPUT DDCB#%d\n", req->num);
+		genwqe_hexdump(pci_dev, pddcb, sizeof(*pddcb));
+	}
+
+	if (ddcb_requ_collect_debug_data(req)) {
+		/* use the kernel copy of debug data. copying back to
+		   user buffer happens later */
+
+		genwqe_init_debug_data(cd, &req->debug_data);
+		memcpy(&req->debug_data.ddcb_before, pddcb,
+		       sizeof(req->debug_data.ddcb_before));
+	}
+
+	enqueue_ddcb(cd, queue, pddcb, req->num);
+	queue->ddcbs_in_flight++;
+
+	if (queue->ddcbs_in_flight > queue->ddcbs_max_in_flight)
+		queue->ddcbs_max_in_flight = queue->ddcbs_in_flight;
+
+	ddcb_requ_set_state(req, GENWQE_REQU_TAPPED);
+	spin_unlock_irqrestore(&queue->ddcb_lock, flags);
+	wake_up_interruptible(&cd->queue_waitq);
+
+	return 0;
+}
+
+/**
+ * __genwqe_execute_raw_ddcb() - Setup and execute DDCB
+ * @cd:         pointer to genwqe device descriptor
+ * @req:        user provided DDCB request
+ */
+int __genwqe_execute_raw_ddcb(struct genwqe_dev *cd,
+			     struct genwqe_ddcb_cmd *cmd)
+{
+	int rc = 0;
+	struct pci_dev *pci_dev = cd->pci_dev;
+	struct ddcb_requ *req = container_of(cmd, struct ddcb_requ, cmd);
+
+	if (cmd->asiv_length > DDCB_ASIV_LENGTH) {
+		dev_err(&pci_dev->dev, "[%s] err: wrong asiv_length of %d\n",
+			__func__, cmd->asiv_length);
+		return -EINVAL;
+	}
+	if (cmd->asv_length > DDCB_ASV_LENGTH) {
+		dev_err(&pci_dev->dev, "[%s] err: wrong asv_length of %d\n",
+			__func__, cmd->asiv_length);
+		return -EINVAL;
+	}
+	rc = __genwqe_enqueue_ddcb(cd, req);
+	if (rc != 0)
+		return rc;
+
+	rc = __genwqe_wait_ddcb(cd, req);
+	if (rc < 0)		/* error or signal interrupt */
+		goto err_exit;
+
+	if (ddcb_requ_collect_debug_data(req)) {
+		if (copy_to_user(cmd->debug_data, &req->debug_data,
+				 sizeof(*cmd->debug_data))) {
+			return -EFAULT;
+		}
+	}
+
+	/*
+	 * Higher values than 0x102 indicate completion with faults,
+	 * lower values than 0x102 indicate processing faults. Note
+	 * that DDCB might have been purged. E.g. Cntl+C.
+	 */
+	if (cmd->retc != DDCB_RETC_COMPLETE) {
+		/* This might happen e.g. flash read, and needs to be
+		   handled by the upper layer code. */
+		rc = -EBADMSG;	/* not processed/error retc */
+	}
+
+	return rc;
+
+ err_exit:
+	__genwqe_purge_ddcb(cd, req);
+
+	if (ddcb_requ_collect_debug_data(req)) {
+		if (copy_to_user(cmd->debug_data, &req->debug_data,
+				 sizeof(*cmd->debug_data))) {
+			return -EFAULT;
+		}
+	}
+	return rc;
+}
+
+/**
+ * genwqe_next_ddcb_ready() - Figure out if the next DDCB is already finished
+ *
+ * We use this as condition for our wait-queue code.
+ */
+static int genwqe_next_ddcb_ready(struct genwqe_dev *cd)
+{
+	unsigned long flags;
+	struct ddcb *pddcb;
+	struct ddcb_queue *queue = &cd->queue;
+
+	spin_lock_irqsave(&queue->ddcb_lock, flags);
+
+	if (queue_empty(queue)) { /* emtpy queue */
+		spin_unlock_irqrestore(&queue->ddcb_lock, flags);
+		return 0;
+	}
+
+	pddcb = &queue->ddcb_vaddr[queue->ddcb_act];
+	if (pddcb->icrc_hsi_shi_32 & DDCB_COMPLETED_BE32) { /* ddcb ready */
+		spin_unlock_irqrestore(&queue->ddcb_lock, flags);
+		return 1;
+	}
+
+	spin_unlock_irqrestore(&queue->ddcb_lock, flags);
+	return 0;
+}
+
+/**
+ * genwqe_ddcbs_in_flight() - Check how many DDCBs are in flight
+ *
+ * Keep track on the number of DDCBs which ware currently in the
+ * queue. This is needed for statistics as well as conditon if we want
+ * to wait or better do polling in case of no interrupts available.
+ */
+int genwqe_ddcbs_in_flight(struct genwqe_dev *cd)
+{
+	unsigned long flags;
+	int ddcbs_in_flight = 0;
+	struct ddcb_queue *queue = &cd->queue;
+
+	spin_lock_irqsave(&queue->ddcb_lock, flags);
+	ddcbs_in_flight += queue->ddcbs_in_flight;
+	spin_unlock_irqrestore(&queue->ddcb_lock, flags);
+
+	return ddcbs_in_flight;
+}
+
+static int setup_ddcb_queue(struct genwqe_dev *cd, struct ddcb_queue *queue)
+{
+	int rc, i;
+	struct ddcb *pddcb;
+	u64 val64;
+	unsigned int queue_size;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	if (genwqe_ddcb_max < 2)
+		return -EINVAL;
+
+	queue_size = roundup(genwqe_ddcb_max * sizeof(struct ddcb), PAGE_SIZE);
+
+	queue->ddcbs_in_flight = 0;  /* statistics */
+	queue->ddcbs_max_in_flight = 0;
+	queue->ddcbs_completed = 0;
+	queue->busy = 0;
+
+	queue->ddcb_seq	  = 0x100; /* start sequence number */
+	queue->ddcb_max	  = genwqe_ddcb_max; /* module parameter */
+	queue->ddcb_vaddr = __genwqe_alloc_consistent(cd, queue_size,
+						&queue->ddcb_daddr);
+	if (queue->ddcb_vaddr == NULL) {
+		dev_err(&pci_dev->dev,
+			"[%s] **err: could not allocate DDCB **\n", __func__);
+		return -ENOMEM;
+	}
+	memset(queue->ddcb_vaddr, 0, queue_size);
+
+	queue->ddcb_req = kzalloc(sizeof(struct ddcb_requ *) *
+				  queue->ddcb_max, GFP_KERNEL);
+	if (!queue->ddcb_req) {
+		rc = -ENOMEM;
+		goto free_ddcbs;
+	}
+
+	queue->ddcb_waitqs = kzalloc(sizeof(wait_queue_head_t) *
+				     queue->ddcb_max, GFP_KERNEL);
+	if (!queue->ddcb_waitqs) {
+		rc = -ENOMEM;
+		goto free_requs;
+	}
+
+	for (i = 0; i < queue->ddcb_max; i++) {
+		pddcb = &queue->ddcb_vaddr[i];		     /* DDCBs */
+		pddcb->icrc_hsi_shi_32 = DDCB_COMPLETED_BE32;
+		pddcb->retc_16 = cpu_to_be16(0xfff);
+
+		queue->ddcb_req[i] = NULL;		     /* requests */
+		init_waitqueue_head(&queue->ddcb_waitqs[i]); /* waitqueues */
+	}
+
+	queue->ddcb_act  = 0;
+	queue->ddcb_next = 0;	/* queue is empty */
+
+	spin_lock_init(&queue->ddcb_lock);
+	init_waitqueue_head(&queue->ddcb_waitq);
+
+	val64 = ((u64)(queue->ddcb_max - 1) <<  8); /* lastptr */
+	__genwqe_writeq(cd, queue->IO_QUEUE_CONFIG,  0x07);  /* iCRC/vCRC */
+	__genwqe_writeq(cd, queue->IO_QUEUE_SEGMENT, queue->ddcb_daddr);
+	__genwqe_writeq(cd, queue->IO_QUEUE_INITSQN, queue->ddcb_seq);
+	__genwqe_writeq(cd, queue->IO_QUEUE_WRAP,    val64);
+	return 0;
+
+ free_requs:
+	kfree(queue->ddcb_req);
+	queue->ddcb_req = NULL;
+ free_ddcbs:
+	__genwqe_free_consistent(cd, queue_size, queue->ddcb_vaddr,
+				queue->ddcb_daddr);
+	queue->ddcb_vaddr = NULL;
+	queue->ddcb_daddr = 0ull;
+	return -ENODEV;
+
+}
+
+static int ddcb_queue_initialized(struct ddcb_queue *queue)
+{
+	return (queue->ddcb_vaddr != NULL);
+}
+
+static void free_ddcb_queue(struct genwqe_dev *cd, struct ddcb_queue *queue)
+{
+	unsigned int queue_size;
+
+	queue_size = roundup(queue->ddcb_max * sizeof(struct ddcb), PAGE_SIZE);
+
+	kfree(queue->ddcb_req);
+	queue->ddcb_req = NULL;
+
+	if (queue->ddcb_vaddr) {
+		__genwqe_free_consistent(cd, queue_size, queue->ddcb_vaddr,
+					queue->ddcb_daddr);
+		queue->ddcb_vaddr = NULL;
+		queue->ddcb_daddr = 0ull;
+	}
+}
+
+static irqreturn_t genwqe_pf_isr(int irq, void *dev_id)
+{
+	u64 gfir;
+	struct genwqe_dev *cd = (struct genwqe_dev *)dev_id;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	/*
+	 * In case of fatal FIR error the queue is stopped, such that
+	 * we can safely check it without risking anything.
+	 */
+	cd->irqs_processed++;
+	wake_up_interruptible(&cd->queue_waitq);
+
+	/*
+	 * Checking for errors before kicking the queue might be
+	 * safer, but slower for the good-case ... See above.
+	 */
+	gfir = __genwqe_readq(cd, IO_SLC_CFGREG_GFIR);
+	if ((gfir & GFIR_ERR_TRIGGER) != 0x0) {
+
+		wake_up_interruptible(&cd->health_waitq);
+
+		/*
+		 * By default GFIRs causes recovery actions. This
+		 * count is just for debug when recovery is masked.
+		 */
+		printk_ratelimited(KERN_ERR
+				   "%s %s: [%s] GFIR=%016llx\n",
+				   GENWQE_DEVNAME, dev_name(&pci_dev->dev),
+				   __func__, gfir);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t genwqe_vf_isr(int irq, void *dev_id)
+{
+	struct genwqe_dev *cd = (struct genwqe_dev *)dev_id;
+
+	cd->irqs_processed++;
+	wake_up_interruptible(&cd->queue_waitq);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * genwqe_card_thread() - Work thread for the DDCB queue
+ *
+ * The idea is to check if there are DDCBs in processing. If there are
+ * some finished DDCBs, we process them and wakeup the
+ * requestors. Otherwise we give other processes time using
+ * cond_resched().
+ */
+static int genwqe_card_thread(void *data)
+{
+	int should_stop = 0, rc = 0;
+	struct genwqe_dev *cd = (struct genwqe_dev *)data;
+
+	while (!kthread_should_stop()) {
+
+		genwqe_check_ddcb_queue(cd, &cd->queue);
+
+		if (genwqe_polling_enabled) {
+			rc = wait_event_interruptible_timeout(
+				cd->queue_waitq,
+				genwqe_ddcbs_in_flight(cd) ||
+				(should_stop = kthread_should_stop()), 1);
+		} else {
+			rc = wait_event_interruptible_timeout(
+				cd->queue_waitq,
+				genwqe_next_ddcb_ready(cd) ||
+				(should_stop = kthread_should_stop()), HZ);
+		}
+		if (should_stop)
+			break;
+
+		/*
+		 * Avoid soft lockups on heavy loads; we do not want
+		 * to disable our interrupts.
+		 */
+		cond_resched();
+	}
+	return 0;
+}
+
+/**
+ * genwqe_setup_service_layer() - Setup DDCB queue
+ * @cd:         pointer to genwqe device descriptor
+ *
+ * Allocate DDCBs. Configure Service Layer Controller (SLC).
+ *
+ * Return: 0 success
+ */
+int genwqe_setup_service_layer(struct genwqe_dev *cd)
+{
+	int rc;
+	struct ddcb_queue *queue;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	if (genwqe_is_privileged(cd)) {
+		rc = genwqe_card_reset(cd);
+		if (rc < 0) {
+			dev_err(&pci_dev->dev,
+				"[%s] err: reset failed.\n", __func__);
+			return rc;
+		}
+		genwqe_read_softreset(cd);
+	}
+
+	queue = &cd->queue;
+	queue->IO_QUEUE_CONFIG  = IO_SLC_QUEUE_CONFIG;
+	queue->IO_QUEUE_STATUS  = IO_SLC_QUEUE_STATUS;
+	queue->IO_QUEUE_SEGMENT = IO_SLC_QUEUE_SEGMENT;
+	queue->IO_QUEUE_INITSQN = IO_SLC_QUEUE_INITSQN;
+	queue->IO_QUEUE_OFFSET  = IO_SLC_QUEUE_OFFSET;
+	queue->IO_QUEUE_WRAP    = IO_SLC_QUEUE_WRAP;
+	queue->IO_QUEUE_WTIME   = IO_SLC_QUEUE_WTIME;
+	queue->IO_QUEUE_ERRCNTS = IO_SLC_QUEUE_ERRCNTS;
+	queue->IO_QUEUE_LRW     = IO_SLC_QUEUE_LRW;
+
+	rc = setup_ddcb_queue(cd, queue);
+	if (rc != 0) {
+		rc = -ENODEV;
+		goto err_out;
+	}
+
+	init_waitqueue_head(&cd->queue_waitq);
+	cd->card_thread = kthread_run(genwqe_card_thread, cd,
+				      GENWQE_DEVNAME "%d_thread",
+				      cd->card_idx);
+	if (IS_ERR(cd->card_thread)) {
+		rc = PTR_ERR(cd->card_thread);
+		cd->card_thread = NULL;
+		goto stop_free_queue;
+	}
+
+	rc = genwqe_set_interrupt_capability(cd, GENWQE_MSI_IRQS);
+	if (rc > 0)
+		rc = genwqe_set_interrupt_capability(cd, rc);
+	if (rc != 0) {
+		rc = -ENODEV;
+		goto stop_kthread;
+	}
+
+	/*
+	 * We must have all wait-queues initialized when we enable the
+	 * interrupts. Otherwise we might crash if we get an early
+	 * irq.
+	 */
+	init_waitqueue_head(&cd->health_waitq);
+
+	if (genwqe_is_privileged(cd)) {
+		rc = request_irq(pci_dev->irq, genwqe_pf_isr, IRQF_SHARED,
+				 GENWQE_DEVNAME, cd);
+	} else {
+		rc = request_irq(pci_dev->irq, genwqe_vf_isr, IRQF_SHARED,
+				 GENWQE_DEVNAME, cd);
+	}
+	if (rc < 0) {
+		dev_err(&pci_dev->dev, "irq %d not free.\n", pci_dev->irq);
+		goto stop_irq_cap;
+	}
+
+	cd->card_state = GENWQE_CARD_USED;
+	return 0;
+
+ stop_irq_cap:
+	genwqe_reset_interrupt_capability(cd);
+ stop_kthread:
+	kthread_stop(cd->card_thread);
+	cd->card_thread = NULL;
+ stop_free_queue:
+	free_ddcb_queue(cd, queue);
+ err_out:
+	return rc;
+}
+
+/**
+ * queue_wake_up_all() - Handles fatal error case
+ *
+ * The PCI device got unusable and we have to stop all pending
+ * requests as fast as we can. The code after this must purge the
+ * DDCBs in question and ensure that all mappings are freed.
+ */
+static int queue_wake_up_all(struct genwqe_dev *cd)
+{
+	unsigned int i;
+	unsigned long flags;
+	struct ddcb_queue *queue = &cd->queue;
+
+	spin_lock_irqsave(&queue->ddcb_lock, flags);
+
+	for (i = 0; i < queue->ddcb_max; i++)
+		wake_up_interruptible(&queue->ddcb_waitqs[queue->ddcb_act]);
+
+	spin_unlock_irqrestore(&queue->ddcb_lock, flags);
+
+	return 0;
+}
+
+/**
+ * genwqe_finish_queue() - Remove any genwqe devices and user-interfaces
+ *
+ * Relies on the pre-condition that there are no users of the card
+ * device anymore e.g. with open file-descriptors.
+ *
+ * This function must be robust enough to be called twice.
+ */
+int genwqe_finish_queue(struct genwqe_dev *cd)
+{
+	int i, rc, in_flight;
+	int waitmax = genwqe_ddcb_software_timeout;
+	struct pci_dev *pci_dev = cd->pci_dev;
+	struct ddcb_queue *queue = &cd->queue;
+
+	if (!ddcb_queue_initialized(queue))
+		return 0;
+
+	/* Do not wipe out the error state. */
+	if (cd->card_state == GENWQE_CARD_USED)
+		cd->card_state = GENWQE_CARD_UNUSED;
+
+	/* Wake up all requests in the DDCB queue such that they
+	   should be removed nicely. */
+	queue_wake_up_all(cd);
+
+	/* We must wait to get rid of the DDCBs in flight */
+	for (i = 0; i < waitmax; i++) {
+		in_flight = genwqe_ddcbs_in_flight(cd);
+
+		if (in_flight == 0)
+			break;
+
+		dev_info(&pci_dev->dev,
+			 "  DEBUG [%d/%d] waiting for queue to get empty: "
+			 "%d requests!\n", i, waitmax, in_flight);
+
+		/*
+		 * Severe severe error situation: The card itself has
+		 * 16 DDCB queues, each queue has e.g. 32 entries,
+		 * each DDBC has a hardware timeout of currently 250
+		 * msec but the PFs have a hardware timeout of 8 sec
+		 * ... so I take something large.
+		 */
+		msleep(1000);
+	}
+	if (i == waitmax) {
+		dev_err(&pci_dev->dev, "  [%s] err: queue is not empty!!\n",
+			__func__);
+		rc = -EIO;
+	}
+	return rc;
+}
+
+/**
+ * genwqe_release_service_layer() - Shutdown DDCB queue
+ * @cd:       genwqe device descriptor
+ *
+ * This function must be robust enough to be called twice.
+ */
+int genwqe_release_service_layer(struct genwqe_dev *cd)
+{
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	if (!ddcb_queue_initialized(&cd->queue))
+		return 1;
+
+	free_irq(pci_dev->irq, cd);
+	genwqe_reset_interrupt_capability(cd);
+
+	if (cd->card_thread != NULL) {
+		kthread_stop(cd->card_thread);
+		cd->card_thread = NULL;
+	}
+
+	free_ddcb_queue(cd, &cd->queue);
+	return 0;
+}
diff --git a/drivers/misc/genwqe/card_ddcb.h b/drivers/misc/genwqe/card_ddcb.h
new file mode 100644
index 0000000..c4f2672
--- /dev/null
+++ b/drivers/misc/genwqe/card_ddcb.h
@@ -0,0 +1,188 @@
+#ifndef __CARD_DDCB_H__
+#define __CARD_DDCB_H__
+
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
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
+#include "genwqe_driver.h"
+#include "card_base.h"
+
+/**
+ * struct ddcb - Device Driver Control Block DDCB
+ * @hsi:        Hardware software interlock
+ * @shi:        Software hardware interlock. Hsi and shi are used to interlock
+ *              software and hardware activities. We are using a compare and
+ *              swap operation to ensure that there are no races when
+ *              activating new DDCBs on the queue, or when we need to
+ *              purge a DDCB from a running queue.
+ * @acfunc:     Accelerator function addresses a unit within the chip
+ * @cmd:        Command to work on
+ * @cmdopts_16: Options for the command
+ * @asiv:       Input data
+ * @asv:        Output data
+ *
+ * The DDCB data format is big endian. Multiple consequtive DDBCs form
+ * a DDCB queue.
+ */
+#define ASIV_LENGTH		104 /* Old specification without ATS field */
+#define ASIV_LENGTH_ATS		96  /* New specification with ATS field */
+#define ASV_LENGTH		64
+
+struct ddcb {
+	union {
+		__be32 icrc_hsi_shi_32;	/* iCRC, Hardware/SW interlock */
+		struct {
+			__be16	icrc_16;
+			u8	hsi;
+			u8	shi;
+		};
+	};
+	u8  pre;		/* Preamble */
+	u8  xdir;		/* Execution Directives */
+	__be16 seqnum_16;	/* Sequence Number */
+
+	u8  acfunc;		/* Accelerator Function.. */
+	u8  cmd;		/* Command. */
+	__be16 cmdopts_16;	/* Command Options */
+	u8  sur;		/* Status Update Rate */
+	u8  psp;		/* Protection Section Pointer */
+	__be16 rsvd_0e_16;	/* Reserved invariant */
+
+	__be64 fwiv_64;		/* Firmware Invariant. */
+
+	union {
+		struct {
+			__be64 ats_64;  /* Address Translation Spec */
+			u8     asiv[ASIV_LENGTH_ATS]; /* New ASIV */
+		} n;
+		u8  __asiv[ASIV_LENGTH];	/* obsolete */
+	};
+	u8     asv[ASV_LENGTH];	/* Appl Spec Variant */
+
+	__be16 rsvd_c0_16;	/* Reserved Variant */
+	__be16 vcrc_16;		/* Variant CRC */
+	__be32 rsvd_32;		/* Reserved unprotected */
+
+	__be64 deque_ts_64;	/* Deque Time Stamp. */
+
+	__be16 retc_16;		/* Return Code */
+	__be16 attn_16;		/* Attention/Extended Error Codes */
+	__be32 progress_32;	/* Progress indicator. */
+
+	__be64 cmplt_ts_64;	/* Completion Time Stamp. */
+
+	/* The following layout matches the new service layer format */
+	__be32 ibdc_32;		/* Inbound Data Count  (* 256) */
+	__be32 obdc_32;		/* Outbound Data Count (* 256) */
+
+	__be64 rsvd_SLH_64;	/* Reserved for hardware */
+	union {			/* private data for driver */
+		u8	priv[8];
+		__be64	priv_64;
+	};
+	__be64 disp_ts_64;	/* Dispatch TimeStamp */
+} __attribute__((__packed__));
+
+/* CRC polynomials for DDCB */
+#define CRC16_POLYNOMIAL	0x1021
+
+/*
+ * SHI: Software to Hardware Interlock
+ *   This 1 byte field is written by software to interlock the
+ *   movement of one queue entry to another with the hardware in the
+ *   chip.
+ */
+#define DDCB_SHI_INTR		0x04 /* Bit 2 */
+#define DDCB_SHI_PURGE		0x02 /* Bit 1 */
+#define DDCB_SHI_NEXT		0x01 /* Bit 0 */
+
+/*
+ * HSI: Hardware to Software interlock
+ * This 1 byte field is written by hardware to interlock the movement
+ * of one queue entry to another with the software in the chip.
+ */
+#define DDCB_HSI_COMPLETED	0x40 /* Bit 6 */
+#define DDCB_HSI_FETCHED	0x04 /* Bit 2 */
+
+/*
+ * Accessing HSI/SHI is done 32-bit wide
+ *   Normally 16-bit access would work too, but on some platforms the
+ *   16 compare and swap operation is not supported. Therefore
+ *   switching to 32-bit such that those platforms will work too.
+ *
+ *                                         iCRC HSI/SHI
+ */
+#define DDCB_INTR_BE32		cpu_to_be32(0x00000004)
+#define DDCB_PURGE_BE32		cpu_to_be32(0x00000002)
+#define DDCB_NEXT_BE32		cpu_to_be32(0x00000001)
+#define DDCB_COMPLETED_BE32	cpu_to_be32(0x00004000)
+#define DDCB_FETCHED_BE32	cpu_to_be32(0x00000400)
+
+/* Definitions of DDCB presets */
+#define DDCB_PRESET_PRE		0x80
+#define ICRC_LENGTH(n)		((n) + 8 + 8 + 8)  /* used ASIV + hdr fields */
+#define VCRC_LENGTH(n)		((n))		   /* used ASV */
+
+/*
+ * Genwqe Scatter Gather list
+ *   Each element has up to 8 entries.
+ *   The chaining element is element 0 cause of prefetching needs.
+ */
+
+/*
+ * 0b0110 Chained descriptor. The descriptor is describing the next
+ * descriptor list.
+ */
+#define SG_CHAINED		(0x6)
+
+/*
+ * 0b0010 First entry of a descriptor list. Start from a Buffer-Empty
+ * condition.
+ */
+#define SG_DATA			(0x2)
+
+/*
+ * 0b0000 Early terminator. This is the last entry on the list
+ * irregardless of the length indicated.
+ */
+#define SG_END_LIST		(0x0)
+
+/**
+ * struct sglist - Scatter gather list
+ * @target_addr:       Either a dma addr of memory to work on or a
+ *                     dma addr or a subsequent sglist block.
+ * @len:               Length of the data block.
+ * @flags:             See above.
+ *
+ * Depending on the command the GenWQE card can use a scatter gather
+ * list to describe the memory it works on. Always 8 sg_entry's form
+ * a block.
+ */
+struct sg_entry {
+	__be64 target_addr;
+	__be32 len;
+	__be32 flags;
+};
+
+#endif /* __CARD_DDCB_H__ */
diff --git a/drivers/misc/genwqe/card_debugfs.c b/drivers/misc/genwqe/card_debugfs.c
new file mode 100644
index 0000000..6a048a1
--- /dev/null
+++ b/drivers/misc/genwqe/card_debugfs.c
@@ -0,0 +1,566 @@
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
+ * Debugfs interfaces for the GenWQE card. Help to debug potential
+ * problems. Dump internal chip state for debugging and failure
+ * determination.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+
+#include "card_base.h"
+#include "card_ddcb.h"
+
+static void DBG_UIDn_show(struct seq_file *s, struct genwqe_reg *regs,
+			 int entries)
+{
+	unsigned int i;
+	u32 v_hi, v_lo;
+
+	for (i = 0; i < entries; i++) {
+		v_hi = (regs[i].val >> 32) & 0xffffffff;
+		v_lo = (regs[i].val)       & 0xffffffff;
+
+		seq_printf(s, "  0x%08x 0x%08x 0x%08x 0x%08x EXT_ERR_REC\n",
+			   regs[i].addr, regs[i].idx, v_hi, v_lo);
+	}
+}
+
+static int curr_DBG_UIDn_show(struct seq_file *s, void *unused, int uid)
+{
+	struct genwqe_dev *cd = s->private;
+	int entries;
+	struct genwqe_reg *regs;
+
+	entries = genwqe_ffdc_buff_size(cd, uid);
+	if (entries < 0)
+		return -EINVAL;
+
+	if (entries == 0)
+		return 0;
+
+	regs = kzalloc(entries * sizeof(*regs), GFP_ATOMIC);
+	if (regs == NULL)
+		return -ENOMEM;
+
+	genwqe_stop_traps(cd); /* halt the traps while dumping data */
+	genwqe_ffdc_buff_read(cd, uid, regs, entries);
+	genwqe_start_traps(cd);
+
+	DBG_UIDn_show(s, regs, entries);
+	kfree(regs);
+	return 0;
+}
+
+static int genwqe_curr_DBG_UID0_show(struct seq_file *s, void *unused)
+{
+	return curr_DBG_UIDn_show(s, unused, 0);
+}
+
+static int genwqe_curr_DBG_UID0_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, genwqe_curr_DBG_UID0_show, inode->i_private);
+}
+
+static const struct file_operations genwqe_curr_DBG_UID0_fops = {
+	.open = genwqe_curr_DBG_UID0_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int genwqe_curr_DBG_UID1_show(struct seq_file *s, void *unused)
+{
+	return curr_DBG_UIDn_show(s, unused, 1);
+}
+
+static int genwqe_curr_DBG_UID1_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, genwqe_curr_DBG_UID1_show, inode->i_private);
+}
+
+static const struct file_operations genwqe_curr_DBG_UID1_fops = {
+	.open = genwqe_curr_DBG_UID1_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int genwqe_curr_DBG_UID2_show(struct seq_file *s, void *unused)
+{
+	return curr_DBG_UIDn_show(s, unused, 2);
+}
+
+static int genwqe_curr_DBG_UID2_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, genwqe_curr_DBG_UID2_show, inode->i_private);
+}
+
+static const struct file_operations genwqe_curr_DBG_UID2_fops = {
+	.open = genwqe_curr_DBG_UID2_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int prev_DBG_UIDn_show(struct seq_file *s, void *unused, int uid)
+{
+	struct genwqe_dev *cd = s->private;
+
+	DBG_UIDn_show(s, cd->ffdc[uid].regs,  cd->ffdc[uid].entries);
+	return 0;
+}
+
+static int genwqe_prev_DBG_UID0_show(struct seq_file *s, void *unused)
+{
+	return prev_DBG_UIDn_show(s, unused, 0);
+}
+
+static int genwqe_prev_DBG_UID0_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, genwqe_prev_DBG_UID0_show, inode->i_private);
+}
+
+static const struct file_operations genwqe_prev_DBG_UID0_fops = {
+	.open = genwqe_prev_DBG_UID0_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int genwqe_prev_DBG_UID1_show(struct seq_file *s, void *unused)
+{
+	return prev_DBG_UIDn_show(s, unused, 1);
+}
+
+static int genwqe_prev_DBG_UID1_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, genwqe_prev_DBG_UID1_show, inode->i_private);
+}
+
+static const struct file_operations genwqe_prev_DBG_UID1_fops = {
+	.open = genwqe_prev_DBG_UID1_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int genwqe_prev_DBG_UID2_show(struct seq_file *s, void *unused)
+{
+	return prev_DBG_UIDn_show(s, unused, 2);
+}
+
+static int genwqe_prev_DBG_UID2_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, genwqe_prev_DBG_UID2_show, inode->i_private);
+}
+
+static const struct file_operations genwqe_prev_DBG_UID2_fops = {
+	.open = genwqe_prev_DBG_UID2_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int genwqe_curr_regs_show(struct seq_file *s, void *unused)
+{
+	struct genwqe_dev *cd = s->private;
+	unsigned int i;
+	struct genwqe_reg *regs;
+
+	regs = kzalloc(GENWQE_FFDC_REGS * sizeof(*regs), GFP_ATOMIC);
+	if (regs == NULL)
+		return -ENOMEM;
+
+	genwqe_stop_traps(cd);
+	genwqe_read_ffdc_regs(cd, regs, GENWQE_FFDC_REGS, 1);
+	genwqe_start_traps(cd);
+
+	for (i = 0; i < GENWQE_FFDC_REGS; i++) {
+		if (regs[i].addr == 0xffffffff)
+			break;  /* invalid entries */
+
+		if (regs[i].val == 0x0ull)
+			continue;  /* do not print 0x0 FIRs */
+
+		seq_printf(s, "  0x%08x 0x%016llx\n",
+			   regs[i].addr, regs[i].val);
+	}
+	return 0;
+}
+
+static int genwqe_curr_regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, genwqe_curr_regs_show, inode->i_private);
+}
+
+static const struct file_operations genwqe_curr_regs_fops = {
+	.open = genwqe_curr_regs_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int genwqe_prev_regs_show(struct seq_file *s, void *unused)
+{
+	struct genwqe_dev *cd = s->private;
+	unsigned int i;
+	struct genwqe_reg *regs = cd->ffdc[GENWQE_DBG_REGS].regs;
+
+	if (regs == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < GENWQE_FFDC_REGS; i++) {
+		if (regs[i].addr == 0xffffffff)
+			break;  /* invalid entries */
+
+		if (regs[i].val == 0x0ull)
+			continue;  /* do not print 0x0 FIRs */
+
+		seq_printf(s, "  0x%08x 0x%016llx\n",
+			   regs[i].addr, regs[i].val);
+	}
+	return 0;
+}
+
+static int genwqe_prev_regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, genwqe_prev_regs_show, inode->i_private);
+}
+
+static const struct file_operations genwqe_prev_regs_fops = {
+	.open = genwqe_prev_regs_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int genwqe_jtimer_show(struct seq_file *s, void *unused)
+{
+	struct genwqe_dev *cd = s->private;
+	unsigned int vf_num;
+	u64 jtimer;
+
+	jtimer = genwqe_read_jtimer(cd, 0);
+	seq_printf(s, "  PF   0x%016llx %d msec\n", jtimer,
+		   genwqe_pf_jobtimeout_msec);
+
+	for (vf_num = 0; vf_num < cd->num_vfs; vf_num++) {
+		jtimer = genwqe_read_jtimer(cd, vf_num + 1);
+		seq_printf(s, "  VF%-2d 0x%016llx %d msec\n", vf_num, jtimer,
+			   genwqe_vf_jobtimeout_msec);
+	}
+	return 0;
+}
+
+static int genwqe_jtimer_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, genwqe_jtimer_show, inode->i_private);
+}
+
+static const struct file_operations genwqe_jtimer_fops = {
+	.open = genwqe_jtimer_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int genwqe_ddcb_info_show(struct seq_file *s, void *unused)
+{
+	struct genwqe_dev *cd = s->private;
+	unsigned int i;
+	struct ddcb_queue *queue;
+	struct ddcb *pddcb;
+
+	queue = &cd->queue;
+	seq_puts(s, "DDCB QUEUE:\n");
+	seq_printf(s, "  ddcb_max:            %d\n"
+		   "  ddcb_daddr:          %016llx - %016llx\n"
+		   "  ddcb_vaddr:          %016llx\n"
+		   "  ddcbs_in_flight:     %u\n"
+		   "  ddcbs_max_in_flight: %u\n"
+		   "  ddcbs_completed:     %u\n"
+		   "  busy:                %u\n"
+		   "  irqs_processed:      %u\n",
+		   queue->ddcb_max, (long long)queue->ddcb_daddr,
+		   (long long)queue->ddcb_daddr +
+		   (queue->ddcb_max * DDCB_LENGTH),
+		   (long long)queue->ddcb_vaddr, queue->ddcbs_in_flight,
+		   queue->ddcbs_max_in_flight, queue->ddcbs_completed,
+		   queue->busy, cd->irqs_processed);
+
+	/* Hardware State */
+	seq_printf(s, "  0x%08x 0x%016llx IO_QUEUE_CONFIG\n"
+		   "  0x%08x 0x%016llx IO_QUEUE_STATUS\n"
+		   "  0x%08x 0x%016llx IO_QUEUE_SEGMENT\n"
+		   "  0x%08x 0x%016llx IO_QUEUE_INITSQN\n"
+		   "  0x%08x 0x%016llx IO_QUEUE_WRAP\n"
+		   "  0x%08x 0x%016llx IO_QUEUE_OFFSET\n"
+		   "  0x%08x 0x%016llx IO_QUEUE_WTIME\n"
+		   "  0x%08x 0x%016llx IO_QUEUE_ERRCNTS\n"
+		   "  0x%08x 0x%016llx IO_QUEUE_LRW\n",
+		   queue->IO_QUEUE_CONFIG,
+		   __genwqe_readq(cd, queue->IO_QUEUE_CONFIG),
+		   queue->IO_QUEUE_STATUS,
+		   __genwqe_readq(cd, queue->IO_QUEUE_STATUS),
+		   queue->IO_QUEUE_SEGMENT,
+		   __genwqe_readq(cd, queue->IO_QUEUE_SEGMENT),
+		   queue->IO_QUEUE_INITSQN,
+		   __genwqe_readq(cd, queue->IO_QUEUE_INITSQN),
+		   queue->IO_QUEUE_WRAP,
+		   __genwqe_readq(cd, queue->IO_QUEUE_WRAP),
+		   queue->IO_QUEUE_OFFSET,
+		   __genwqe_readq(cd, queue->IO_QUEUE_OFFSET),
+		   queue->IO_QUEUE_WTIME,
+		   __genwqe_readq(cd, queue->IO_QUEUE_WTIME),
+		   queue->IO_QUEUE_ERRCNTS,
+		   __genwqe_readq(cd, queue->IO_QUEUE_ERRCNTS),
+		   queue->IO_QUEUE_LRW,
+		   __genwqe_readq(cd, queue->IO_QUEUE_LRW));
+
+	seq_printf(s, "DDCB list (ddcb_act=%d/ddcb_next=%d):\n",
+		   queue->ddcb_act, queue->ddcb_next);
+
+	pddcb = queue->ddcb_vaddr;
+	for (i = 0; i < queue->ddcb_max; i++) {
+		seq_printf(s, "  %-3d: RETC=%03x SEQ=%04x HSI/SHI=%02x/%02x ",
+			   i, be16_to_cpu(pddcb->retc_16),
+			   be16_to_cpu(pddcb->seqnum_16),
+			   pddcb->hsi, pddcb->shi);
+		seq_printf(s, "PRIV=%06llx CMD=%02x\n",
+			   be64_to_cpu(pddcb->priv_64), pddcb->cmd);
+		pddcb++;
+	}
+	return 0;
+}
+
+static int genwqe_ddcb_info_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, genwqe_ddcb_info_show, inode->i_private);
+}
+
+static const struct file_operations genwqe_ddcb_info_fops = {
+	.open = genwqe_ddcb_info_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+
+static int genwqe_info_show(struct seq_file *s, void *unused)
+{
+	struct genwqe_dev *cd = s->private;
+	u16 val16, type;
+	u64 app_id, slu_id, bitstream = -1;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	slu_id = __genwqe_readq(cd, IO_SLU_UNITCFG);
+	app_id = __genwqe_readq(cd, IO_APP_UNITCFG);
+
+	if (genwqe_is_privileged(cd))
+		bitstream = __genwqe_readq(cd, IO_SLU_BITSTREAM);
+
+	val16 = (u16)(slu_id & 0x0fLLU);
+	type  = (u16)((slu_id >> 20) & 0xffLLU);
+
+	seq_printf(s, "%s driver version: %s\n"
+		   "    Device Name/Type: %s %s CardIdx: %d\n"
+		   "    SLU/APP Config  : 0x%016llx/0x%016llx\n"
+		   "    Build Date      : %u/%x/%u\n"
+		   "    Base Clock      : %u MHz\n"
+		   "    Arch/SVN Release: %u/%llx\n"
+		   "    Bitstream       : %llx\n",
+		   GENWQE_DEVNAME, DRV_VERS_STRING, dev_name(&pci_dev->dev),
+		   genwqe_is_privileged(cd) ?
+		   "Physical" : "Virtual or no SR-IOV",
+		   cd->card_idx, slu_id, app_id,
+		   (u16)((slu_id >> 12) & 0x0fLLU),	   /* month */
+		   (u16)((slu_id >>  4) & 0xffLLU),	   /* day */
+		   (u16)((slu_id >> 16) & 0x0fLLU) + 2010, /* year */
+		   genwqe_base_clock_frequency(cd),
+		   (u16)((slu_id >> 32) & 0xffLLU), slu_id >> 40,
+		   bitstream);
+
+	return 0;
+}
+
+static int genwqe_info_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, genwqe_info_show, inode->i_private);
+}
+
+static const struct file_operations genwqe_info_fops = {
+	.open = genwqe_info_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+int genwqe_init_debugfs(struct genwqe_dev *cd)
+{
+	struct dentry *root;
+	struct dentry *file;
+	int ret, priv;
+	char card_name[64];
+
+	sprintf(card_name, "%s%u_card", GENWQE_DEVNAME, cd->card_idx);
+
+	root = debugfs_create_dir(card_name, cd->debugfs_genwqe);
+	if (!root) {
+		ret = -ENOMEM;
+		goto err0;
+	}
+	priv = genwqe_is_privileged(cd);
+
+	/* non privileged interfaces are done here */
+	file = debugfs_create_file("ddcb_info", S_IRUGO, root, cd,
+				   &genwqe_ddcb_info_fops);
+	if (!file) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	file = debugfs_create_file("info", S_IRUGO, root, cd,
+				   &genwqe_info_fops);
+	if (!file) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	file = debugfs_create_x64("debug", 0666, root, &cd->debug);
+	if (!file) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	file = debugfs_create_x64("err_inject", 0666, root, &cd->err_inject);
+	if (!file) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	file = debugfs_create_u32("ddcb_software_timeout", 0666, root,
+				  &cd->ddcb_software_timeout);
+	if (!file) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	file = debugfs_create_u32("kill_timeout", 0666, root,
+				  &cd->kill_timeout);
+	if (!file) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	/* privileged interfaces follow here */
+	if (!priv) {
+		cd->debugfs_root = root;
+		return 0;
+	}
+
+	file = debugfs_create_file("curr_regs", S_IRUGO, root, cd,
+				   &genwqe_curr_regs_fops);
+	if (!file) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	file = debugfs_create_file("curr_dbg_uid0", S_IRUGO, root, cd,
+				   &genwqe_curr_DBG_UID0_fops);
+	if (!file) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	file = debugfs_create_file("curr_dbg_uid1", S_IRUGO, root, cd,
+				   &genwqe_curr_DBG_UID1_fops);
+	if (!file) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	file = debugfs_create_file("curr_dbg_uid2", S_IRUGO, root, cd,
+				   &genwqe_curr_DBG_UID2_fops);
+	if (!file) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	file = debugfs_create_file("prev_regs", S_IRUGO, root, cd,
+				   &genwqe_prev_regs_fops);
+	if (!file) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	file = debugfs_create_file("prev_dbg_uid0", S_IRUGO, root, cd,
+				   &genwqe_prev_DBG_UID0_fops);
+	if (!file) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	file = debugfs_create_file("prev_dbg_uid1", S_IRUGO, root, cd,
+				   &genwqe_prev_DBG_UID1_fops);
+	if (!file) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	file = debugfs_create_file("prev_dbg_uid2", S_IRUGO, root, cd,
+				   &genwqe_prev_DBG_UID2_fops);
+	if (!file) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	file = debugfs_create_file("jobtimer", S_IRUGO, root, cd,
+				   &genwqe_jtimer_fops);
+	if (!file) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	file = debugfs_create_u32("skip_recovery", 0666, root,
+				  &cd->skip_recovery);
+	if (!file) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	cd->debugfs_root = root;
+	return 0;
+err1:
+	debugfs_remove_recursive(root);
+err0:
+	return ret;
+}
+
+void genqwe_exit_debugfs(struct genwqe_dev *cd)
+{
+	debugfs_remove_recursive(cd->debugfs_root);
+}
diff --git a/drivers/misc/genwqe/card_dev.c b/drivers/misc/genwqe/card_dev.c
new file mode 100644
index 0000000..9faab2b
--- /dev/null
+++ b/drivers/misc/genwqe/card_dev.c
@@ -0,0 +1,1499 @@
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
+ * Character device representation of the GenWQE device. This allows
+ * user-space applications to communicate with the card.
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/string.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/delay.h>
+#include <linux/atomic.h>
+
+#include "card_base.h"
+#include "card_ddcb.h"
+
+static int genwqe_open_files(struct genwqe_dev *cd)
+{
+	int rc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cd->file_lock, flags);
+	rc = list_empty(&cd->file_list);
+	spin_unlock_irqrestore(&cd->file_lock, flags);
+	return !rc;
+}
+
+static void genwqe_add_file(struct genwqe_dev *cd, struct genwqe_file *cfile)
+{
+	unsigned long flags;
+
+	cfile->owner = current;
+	spin_lock_irqsave(&cd->file_lock, flags);
+	list_add(&cfile->list, &cd->file_list);
+	spin_unlock_irqrestore(&cd->file_lock, flags);
+}
+
+static int genwqe_del_file(struct genwqe_dev *cd, struct genwqe_file *cfile)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cd->file_lock, flags);
+	list_del(&cfile->list);
+	spin_unlock_irqrestore(&cd->file_lock, flags);
+
+	return 0;
+}
+
+static void genwqe_add_pin(struct genwqe_file *cfile, struct dma_mapping *m)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cfile->pin_lock, flags);
+	list_add(&m->pin_list, &cfile->pin_list);
+	spin_unlock_irqrestore(&cfile->pin_lock, flags);
+}
+
+static int genwqe_del_pin(struct genwqe_file *cfile, struct dma_mapping *m)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cfile->pin_lock, flags);
+	list_del(&m->pin_list);
+	spin_unlock_irqrestore(&cfile->pin_lock, flags);
+
+	return 0;
+}
+
+/**
+ * genwqe_search_pin() - Search for the mapping for a userspace address
+ * @cfile:	Descriptor of opened file
+ * @u_addr:	User virtual address
+ * @size:	Size of buffer
+ * @dma_addr:	DMA address to be updated
+ *
+ * Return: Pointer to the corresponding mapping	NULL if not found
+ */
+static struct dma_mapping *genwqe_search_pin(struct genwqe_file *cfile,
+					    unsigned long u_addr,
+					    unsigned int size,
+					    void **virt_addr)
+{
+	unsigned long flags;
+	struct dma_mapping *m;
+
+	spin_lock_irqsave(&cfile->pin_lock, flags);
+
+	list_for_each_entry(m, &cfile->pin_list, pin_list) {
+		if ((((u64)m->u_vaddr) <= (u_addr)) &&
+		    (((u64)m->u_vaddr + m->size) >= (u_addr + size))) {
+
+			if (virt_addr)
+				*virt_addr = m->k_vaddr +
+					(u_addr - (u64)m->u_vaddr);
+
+			spin_unlock_irqrestore(&cfile->pin_lock, flags);
+			return m;
+		}
+	}
+	spin_unlock_irqrestore(&cfile->pin_lock, flags);
+	return NULL;
+}
+
+static void __genwqe_add_mapping(struct genwqe_file *cfile,
+			      struct dma_mapping *dma_map)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cfile->map_lock, flags);
+	list_add(&dma_map->card_list, &cfile->map_list);
+	spin_unlock_irqrestore(&cfile->map_lock, flags);
+}
+
+static void __genwqe_del_mapping(struct genwqe_file *cfile,
+			      struct dma_mapping *dma_map)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cfile->map_lock, flags);
+	list_del(&dma_map->card_list);
+	spin_unlock_irqrestore(&cfile->map_lock, flags);
+}
+
+
+/**
+ * __genwqe_search_mapping() - Search for the mapping for a userspace address
+ * @cfile:	descriptor of opened file
+ * @u_addr:	user virtual address
+ * @size:	size of buffer
+ * @dma_addr:	DMA address to be updated
+ * Return: Pointer to the corresponding mapping	NULL if not found
+ */
+static struct dma_mapping *__genwqe_search_mapping(struct genwqe_file *cfile,
+						   unsigned long u_addr,
+						   unsigned int size,
+						   dma_addr_t *dma_addr,
+						   void **virt_addr)
+{
+	unsigned long flags;
+	struct dma_mapping *m;
+	struct pci_dev *pci_dev = cfile->cd->pci_dev;
+
+	spin_lock_irqsave(&cfile->map_lock, flags);
+	list_for_each_entry(m, &cfile->map_list, card_list) {
+
+		if ((((u64)m->u_vaddr) <= (u_addr)) &&
+		    (((u64)m->u_vaddr + m->size) >= (u_addr + size))) {
+
+			/* match found: current is as expected and
+			   addr is in range */
+			if (dma_addr)
+				*dma_addr = m->dma_addr +
+					(u_addr - (u64)m->u_vaddr);
+
+			if (virt_addr)
+				*virt_addr = m->k_vaddr +
+					(u_addr - (u64)m->u_vaddr);
+
+			spin_unlock_irqrestore(&cfile->map_lock, flags);
+			return m;
+		}
+	}
+	spin_unlock_irqrestore(&cfile->map_lock, flags);
+
+	dev_err(&pci_dev->dev,
+		"[%s] Entry not found: u_addr=%lx, size=%x\n",
+		__func__, u_addr, size);
+
+	return NULL;
+}
+
+static void genwqe_remove_mappings(struct genwqe_file *cfile)
+{
+	int i = 0;
+	struct list_head *node, *next;
+	struct dma_mapping *dma_map;
+	struct genwqe_dev *cd = cfile->cd;
+	struct pci_dev *pci_dev = cfile->cd->pci_dev;
+
+	list_for_each_safe(node, next, &cfile->map_list) {
+		dma_map = list_entry(node, struct dma_mapping, card_list);
+
+		list_del_init(&dma_map->card_list);
+
+		/*
+		 * This is really a bug, because those things should
+		 * have been already tidied up.
+		 *
+		 * GENWQE_MAPPING_RAW should have been removed via mmunmap().
+		 * GENWQE_MAPPING_SGL_TEMP should be removed by tidy up code.
+		 */
+		dev_err(&pci_dev->dev,
+			"[%s] %d. cleanup mapping: u_vaddr=%p "
+			"u_kaddr=%016lx dma_addr=%llx\n", __func__, i++,
+			dma_map->u_vaddr, (unsigned long)dma_map->k_vaddr,
+			dma_map->dma_addr);
+
+		if (dma_map->type == GENWQE_MAPPING_RAW) {
+			/* we allocated this dynamically */
+			__genwqe_free_consistent(cd, dma_map->size,
+						dma_map->k_vaddr,
+						dma_map->dma_addr);
+			kfree(dma_map);
+		} else if (dma_map->type == GENWQE_MAPPING_SGL_TEMP) {
+			/* we use dma_map statically from the request */
+			user_vunmap(cd, dma_map, NULL);
+		}
+	}
+}
+
+static void genwqe_remove_pinnings(struct genwqe_file *cfile)
+{
+	int i = 0;
+	struct list_head *node, *next;
+	struct dma_mapping *dma_map;
+	struct genwqe_dev *cd = cfile->cd;
+
+	list_for_each_safe(node, next, &cfile->pin_list) {
+		dma_map = list_entry(node, struct dma_mapping, pin_list);
+
+		/*
+		 * This is not a bug, because a killed processed might
+		 * not call the unpin ioctl, which is supposed to free
+		 * the resources.
+		 *
+		 * Pinnings are dymically allocated and need to be
+		 * deleted.
+		 */
+		list_del_init(&dma_map->pin_list);
+
+		genwqe_dprintk(cd, dbg_card_pinning,
+			       "[%s] %d. not all pinnings removed: "
+			       "u_vaddr=%p size=%08x u_kaddr=%016lx "
+			       "dma_addr=%llx\n", __func__, i++,
+			       dma_map->u_vaddr, dma_map->size,
+			       (unsigned long)dma_map->k_vaddr,
+			       dma_map->dma_addr);
+
+		user_vunmap(cd, dma_map, NULL);
+		kfree(dma_map);
+	}
+}
+
+/**
+ * genwqe_kill_fasync() - Send signal to all processes with open GenWQE files
+ *
+ * E.g. genwqe_send_signal(cd, SIGIO);
+ */
+static int genwqe_kill_fasync(struct genwqe_dev *cd, int sig)
+{
+	unsigned int files = 0;
+	unsigned long flags;
+	struct genwqe_file *cfile;
+
+	spin_lock_irqsave(&cd->file_lock, flags);
+	list_for_each_entry(cfile, &cd->file_list, list) {
+		if (cfile->async_queue)
+			kill_fasync(&cfile->async_queue, sig, POLL_HUP);
+		files++;
+	}
+	spin_unlock_irqrestore(&cd->file_lock, flags);
+	return files;
+}
+
+static int genwqe_force_sig(struct genwqe_dev *cd, int sig)
+{
+	unsigned int files = 0;
+	unsigned long flags;
+	struct genwqe_file *cfile;
+
+	spin_lock_irqsave(&cd->file_lock, flags);
+	list_for_each_entry(cfile, &cd->file_list, list) {
+		force_sig(sig, cfile->owner);
+		files++;
+	}
+	spin_unlock_irqrestore(&cd->file_lock, flags);
+	return files;
+}
+
+/**
+ * genwqe_open() - file open
+ * @inode:      file system information
+ * @filp:	file handle
+ *
+ * This function is executed whenever an application calls
+ * open("/dev/genwqe",..).
+ *
+ * Return: 0 if successful or <0 if errors
+ */
+static int genwqe_open(struct inode *inode, struct file *filp)
+{
+	struct genwqe_dev *cd;
+	struct genwqe_file *cfile;
+	struct pci_dev *pci_dev;
+
+	cfile = kzalloc(sizeof(*cfile), GFP_KERNEL);
+	if (cfile == NULL)
+		return -ENOMEM;
+
+	cd = container_of(inode->i_cdev, struct genwqe_dev, cdev_genwqe);
+	pci_dev = cd->pci_dev;
+	cfile->cd = cd;
+	cfile->filp = filp;
+	cfile->client = NULL;
+
+	spin_lock_init(&cfile->map_lock);  /* list of raw memory allocations */
+	INIT_LIST_HEAD(&cfile->map_list);
+
+	spin_lock_init(&cfile->pin_lock);  /* list of user pinned memory */
+	INIT_LIST_HEAD(&cfile->pin_list);
+
+	filp->private_data = cfile;
+
+	genwqe_add_file(cd, cfile);
+	return 0;
+}
+
+/**
+ * genwqe_fasync() - Setup process to receive SIGIO.
+ * @fd:        file descriptor
+ * @filp:      file handle
+ * @mode:      file mode
+ *
+ * Sending a signal is working as following:
+ *
+ * if (cdev->async_queue)
+ *         kill_fasync(&cdev->async_queue, SIGIO, POLL_IN);
+ *
+ * Some devices also implement asynchronous notification to indicate
+ * when the device can be written; in this case, of course,
+ * kill_fasync must be called with a mode of POLL_OUT.
+ */
+static int genwqe_fasync(int fd, struct file *filp, int mode)
+{
+	struct genwqe_file *cdev = (struct genwqe_file *)filp->private_data;
+	return fasync_helper(fd, filp, mode, &cdev->async_queue);
+}
+
+
+/**
+ * genwqe_release() - file close
+ * @inode:      file system information
+ * @filp:       file handle
+ *
+ * This function is executed whenever an application calls 'close(fd_genwqe)'
+ *
+ * Return: always 0
+ */
+static int genwqe_release(struct inode *inode, struct file *filp)
+{
+	struct genwqe_file *cfile = (struct genwqe_file *)filp->private_data;
+	struct genwqe_dev *cd = cfile->cd;
+
+	/* there must be no entries in these lists! */
+	genwqe_remove_mappings(cfile);
+	genwqe_remove_pinnings(cfile);
+
+	/* remove this filp from the asynchronously notified filp's */
+	genwqe_fasync(-1, filp, 0);
+
+	/*
+	 * For this to work we must not release cd when this cfile is
+	 * not yet released, otherwise the list entry is invalid,
+	 * because the list itself gets reinstantiated!
+	 */
+	genwqe_del_file(cd, cfile);
+	kfree(cfile);
+	return 0;
+}
+
+static void genwqe_vma_open(struct vm_area_struct *vma)
+{
+	/* nothing ... */
+}
+
+/**
+ * genwqe_vma_close() - Called each time when vma is unmapped
+ *
+ * Free memory which got allocated by GenWQE mmap().
+ */
+static void genwqe_vma_close(struct vm_area_struct *vma)
+{
+	unsigned long vsize = vma->vm_end - vma->vm_start;
+	struct inode *inode = vma->vm_file->f_dentry->d_inode;
+	struct dma_mapping *dma_map;
+	struct genwqe_dev *cd = container_of(inode->i_cdev, struct genwqe_dev,
+					    cdev_genwqe);
+	struct pci_dev *pci_dev = cd->pci_dev;
+	dma_addr_t d_addr = 0;
+	struct genwqe_file *cfile = vma->vm_private_data;
+
+	dma_map = __genwqe_search_mapping(cfile, vma->vm_start, vsize,
+					 &d_addr, NULL);
+	if (dma_map == NULL) {
+		dev_err(&pci_dev->dev,
+			"  [%s] err: mapping not found: v=%lx, p=%lx s=%lx\n",
+			__func__, vma->vm_start, vma->vm_pgoff << PAGE_SHIFT,
+			vsize);
+		return;
+	}
+	__genwqe_del_mapping(cfile, dma_map);
+	__genwqe_free_consistent(cd, dma_map->size, dma_map->k_vaddr,
+				 dma_map->dma_addr);
+	kfree(dma_map);
+}
+
+static struct vm_operations_struct genwqe_vma_ops = {
+	.open   = genwqe_vma_open,
+	.close  = genwqe_vma_close,
+};
+
+/**
+ * genwqe_mmap() - Provide contignous buffers to userspace
+ *
+ * We use mmap() to allocate contignous buffers used for DMA
+ * transfers. After the buffer is allocated we remap it to user-space
+ * and remember a reference to our dma_mapping data structure, where
+ * we store the associated DMA address and allocated size.
+ *
+ * When we receive a DDCB execution request with the ATS bits set to
+ * plain buffer, we lookup our dma_mapping list to find the
+ * corresponding DMA address for the associated user-space address.
+ */
+static int genwqe_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	int rc;
+	unsigned long pfn, vsize = vma->vm_end - vma->vm_start;
+	struct genwqe_file *cfile = (struct genwqe_file *)filp->private_data;
+	struct genwqe_dev *cd = cfile->cd;
+	struct dma_mapping *dma_map;
+
+	if (vsize == 0)
+		return -EINVAL;
+
+	if (get_order(vsize) > MAX_ORDER)
+		return -ENOMEM;
+
+	dma_map = kzalloc(sizeof(struct dma_mapping), GFP_ATOMIC);
+	if (dma_map == NULL)
+		return -ENOMEM;
+
+	genwqe_mapping_init(dma_map, GENWQE_MAPPING_RAW);
+	dma_map->u_vaddr = (void *)vma->vm_start;
+	dma_map->size = vsize;
+	dma_map->nr_pages = DIV_ROUND_UP(vsize, PAGE_SIZE);
+	dma_map->k_vaddr = __genwqe_alloc_consistent(cd, vsize,
+						     &dma_map->dma_addr);
+	if (dma_map->k_vaddr == NULL) {
+		rc = -ENOMEM;
+		goto free_dma_map;
+	}
+
+	if (capable(CAP_SYS_ADMIN) && (vsize > sizeof(dma_addr_t)))
+		*(dma_addr_t *)dma_map->k_vaddr = dma_map->dma_addr;
+
+	pfn = virt_to_phys(dma_map->k_vaddr) >> PAGE_SHIFT;
+	rc = remap_pfn_range(vma,
+			     vma->vm_start,
+			     pfn,
+			     vsize,
+			     vma->vm_page_prot);
+	if (rc != 0) {
+		rc = -EFAULT;
+		goto free_dma_mem;
+	}
+
+	vma->vm_private_data = cfile;
+	vma->vm_ops = &genwqe_vma_ops;
+	__genwqe_add_mapping(cfile, dma_map);
+
+	return 0;
+
+ free_dma_mem:
+	__genwqe_free_consistent(cd, dma_map->size,
+				dma_map->k_vaddr,
+				dma_map->dma_addr);
+ free_dma_map:
+	kfree(dma_map);
+	return rc;
+}
+
+/**
+ * do_flash_update() - Excute flash update (write image or CVPD)
+ * @cd:        genwqe device
+ * @load:      details about image load
+ *
+ * Return: 0 if successful
+ */
+
+#define	FLASH_BLOCK	0x40000	/* we use 256k blocks */
+
+static int do_flash_update(struct genwqe_file *cfile,
+			   struct chip_bitstream *load)
+{
+	int rc = 0;
+	int blocks_to_flash;
+	u64 dma_addr, flash = 0;
+	size_t tocopy = 0;
+	u8 __user *buf;
+	u8 *xbuf;
+	u32 crc;
+	u8 cmdopts;
+	struct genwqe_dev *cd = cfile->cd;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	if ((load->size & 0x3) != 0) {
+		dev_err(&pci_dev->dev,
+			"err: buf %d bytes not 4 bytes aligned!\n",
+			load->size);
+		return -EINVAL;
+	}
+	if (((unsigned long)(load->pdata) & ~PAGE_MASK) != 0) {
+		dev_err(&pci_dev->dev,
+			"err: buf is not page aligned!\n");
+		return -EINVAL;
+	}
+
+	/* FIXME Bits have changed for new service layer! */
+	switch ((char)load->partition) {
+	case '0':
+		cmdopts = 0x14;
+		break;		/* download/erase_first/part_0 */
+	case '1':
+		cmdopts = 0x1C;
+		break;		/* download/erase_first/part_1 */
+	case 'v':		/* cmdopts = 0x0c (VPD) */
+	default:
+		dev_err(&pci_dev->dev,
+			"err: invalid partition %02x!\n", load->partition);
+		return -EINVAL;
+	}
+	dev_info(&pci_dev->dev,
+		 "[%s] start flash update UID: 0x%x size: %u bytes part: %c\n",
+		 __func__, load->uid, load->size, (char)load->partition);
+
+	buf = load->pdata;
+	xbuf = __genwqe_alloc_consistent(cd, FLASH_BLOCK, &dma_addr);
+	if (xbuf == NULL) {
+		dev_err(&pci_dev->dev, "err: no memory\n");
+		return -ENOMEM;
+	}
+
+	blocks_to_flash = load->size / FLASH_BLOCK;
+	while (load->size) {
+		struct genwqe_ddcb_cmd *req;
+
+		/*
+		 * We must be 4 byte aligned. Buffer must be 0 appened
+		 * to have defined values when calculating CRC.
+		 */
+		tocopy = min_t(size_t, load->size, FLASH_BLOCK);
+
+		rc = copy_from_user(xbuf, buf, tocopy);
+		if (rc) {
+			dev_err(&pci_dev->dev,
+				"err: could not copy all data rc=%d\n", rc);
+			goto free_buffer;
+		}
+		crc = genwqe_crc32(xbuf, tocopy, 0xffffffff);
+
+		dev_info(&pci_dev->dev,
+			 "[%s] DMA: 0x%llx CRC: %08x SZ: %ld %d\n",
+			__func__, dma_addr, crc, tocopy, blocks_to_flash);
+
+		/* prepare DDCB for SLU process */
+		req = ddcb_requ_alloc();
+		if (req == NULL) {
+			rc = -ENOMEM;
+			goto free_buffer;
+		}
+
+		req->cmd = SLCMD_MOVE_FLASH;
+		req->cmdopts = cmdopts;
+
+		/* prepare invariant values */
+		if (genwqe_get_slu_id(cd) <= 0x2) {
+			*(u64 *)&req->__asiv[0]  = cpu_to_be64(dma_addr);
+			*(u64 *)&req->__asiv[8]  = cpu_to_be64(tocopy);
+			*(u64 *)&req->__asiv[16] = cpu_to_be64(flash);
+			*(u32 *)&req->__asiv[24] = cpu_to_be32(0);
+			req->__asiv[24]	       = load->uid;
+			*(u32 *)&req->__asiv[28] = cpu_to_be32(crc);
+
+			/* for simulation only */
+			*(u64 *)&req->__asiv[88] = cpu_to_be64(load->slu_id);
+			*(u64 *)&req->__asiv[96] = cpu_to_be64(load->app_id);
+			req->asiv_length = 32; /* bytes included in crc calc */
+		} else {	/* setup DDCB for ATS architecture */
+			*(u64 *)&req->asiv[0]  = cpu_to_be64(dma_addr);
+			*(u32 *)&req->asiv[8]  = cpu_to_be32(tocopy);
+			*(u32 *)&req->asiv[12] = cpu_to_be32(0); /* resvd */
+			*(u64 *)&req->asiv[16] = cpu_to_be64(flash);
+			*(u32 *)&req->asiv[24] = cpu_to_be32(load->uid<<24);
+			*(u32 *)&req->asiv[28] = cpu_to_be32(crc);
+
+			/* for simulation only */
+			*(u64 *)&req->asiv[80] = cpu_to_be64(load->slu_id);
+			*(u64 *)&req->asiv[88] = cpu_to_be64(load->app_id);
+
+			req->ats = cpu_to_be64(0x4ULL << 44);	/* Rd only */
+			req->asiv_length = 40; /* bytes included in crc calc */
+		}
+		req->asv_length  = 8;
+
+		/* For Genwqe5 we get back the calculated CRC */
+		*(u64 *)&req->asv[0] = 0ULL;			/* 0x80 */
+
+		rc = __genwqe_execute_raw_ddcb(cd, req);
+
+		load->retc = req->retc;
+		load->attn = req->attn;
+		load->progress = req->progress;
+
+		if (rc < 0) {
+			dev_err(&pci_dev->dev,
+				"  [%s] DDCB returned (RETC=%x ATTN=%x "
+				"PROG=%x rc=%d)\n", __func__, req->retc,
+				req->attn, req->progress, rc);
+
+			ddcb_requ_free(req);
+			goto free_buffer;
+		}
+
+		if (req->retc != DDCB_RETC_COMPLETE) {
+			dev_info(&pci_dev->dev,
+				 "  [%s] DDCB returned (RETC=%x ATTN=%x "
+				 "PROG=%x)\n", __func__, req->retc,
+				 req->attn, req->progress);
+
+			rc = -EIO;
+			ddcb_requ_free(req);
+			goto free_buffer;
+		}
+
+		load->size  -= tocopy;
+		flash += tocopy;
+		buf += tocopy;
+		blocks_to_flash--;
+		ddcb_requ_free(req);
+	}
+
+ free_buffer:
+	__genwqe_free_consistent(cd, FLASH_BLOCK, xbuf, dma_addr);
+	return rc;
+}
+
+static int do_flash_read(struct genwqe_file *cfile,
+			 struct chip_bitstream *load)
+{
+	int rc, blocks_to_flash;
+	u64 dma_addr, flash = 0;
+	size_t tocopy = 0;
+	u8 __user *buf;
+	u8 *xbuf;
+	u8 cmdopts;
+	struct genwqe_dev *cd = cfile->cd;
+	struct pci_dev *pci_dev = cd->pci_dev;
+	struct genwqe_ddcb_cmd *cmd;
+
+	if ((load->size & 0x3) != 0) {
+		dev_err(&pci_dev->dev,
+			"err: buf size %d bytes not 4 bytes aligned!\n",
+			load->size);
+		return -EINVAL;
+	}
+	if (((unsigned long)(load->pdata) & ~PAGE_MASK) != 0) {
+		dev_err(&pci_dev->dev, "err: buf is not page aligned!\n");
+		return -EINVAL;
+	}
+
+	/* FIXME Bits have changed for new service layer! */
+	switch ((char)load->partition) {
+	case '0':
+		cmdopts = 0x12;
+		break;		/* upload/part_0 */
+	case '1':
+		cmdopts = 0x1A;
+		break;		/* upload/part_1 */
+	case 'v':
+	default:
+		dev_err(&pci_dev->dev,
+			"err: invalid partition %02x!\n", load->partition);
+		return -EINVAL;
+	}
+	dev_info(&pci_dev->dev,
+		 "[%s] start flash read UID: 0x%x size: %u bytes part: %c\n",
+		 __func__, load->uid, load->size, (char)load->partition);
+
+	buf = load->pdata;
+	xbuf = __genwqe_alloc_consistent(cd, FLASH_BLOCK, &dma_addr);
+	if (xbuf == NULL) {
+		dev_err(&pci_dev->dev, "err: no memory\n");
+		return -ENOMEM;
+	}
+
+	blocks_to_flash = load->size / FLASH_BLOCK;
+	while (load->size) {
+		/*
+		 * We must be 4 byte aligned. Buffer must be 0 appened
+		 * to have defined values when calculating CRC.
+		 */
+		tocopy = min_t(size_t, load->size, FLASH_BLOCK);
+
+		dev_info(&pci_dev->dev,
+			 "[%s] DMA: 0x%llx SZ: %ld %d\n",
+			 __func__, dma_addr, tocopy, blocks_to_flash);
+
+		/* prepare DDCB for SLU process */
+		cmd = ddcb_requ_alloc();
+		if (cmd == NULL) {
+			rc = -ENOMEM;
+			goto free_buffer;
+		}
+		cmd->cmd = SLCMD_MOVE_FLASH;
+		cmd->cmdopts = cmdopts;
+
+		/* prepare invariant values */
+		if (genwqe_get_slu_id(cd) <= 0x2) {
+			*(u64 *)&cmd->__asiv[0]  = cpu_to_be64(dma_addr);
+			*(u64 *)&cmd->__asiv[8]  = cpu_to_be64(tocopy);
+			*(u64 *)&cmd->__asiv[16] = cpu_to_be64(flash);
+			*(u32 *)&cmd->__asiv[24] = cpu_to_be32(0);
+			cmd->__asiv[24] = load->uid;
+			*(u32 *)&cmd->__asiv[28] = cpu_to_be32(0)  /* CRC */;
+			cmd->asiv_length = 32; /* bytes included in crc calc */
+		} else {	/* setup DDCB for ATS architecture */
+			*(u64 *)&cmd->asiv[0]  = cpu_to_be64(dma_addr);
+			*(u32 *)&cmd->asiv[8]  = cpu_to_be32(tocopy);
+			*(u32 *)&cmd->asiv[12] = cpu_to_be32(0); /* resvd */
+			*(u64 *)&cmd->asiv[16] = cpu_to_be64(flash);
+			*(u32 *)&cmd->asiv[24] = cpu_to_be32(load->uid<<24);
+			*(u32 *)&cmd->asiv[28] = cpu_to_be32(0); /* CRC */
+			cmd->ats = cpu_to_be64(0x5ULL << 44);	/* rd/wr */
+			cmd->asiv_length = 40; /* bytes included in crc calc */
+		}
+		cmd->asv_length  = 8;
+
+		/* we only get back the calculated CRC */
+		*(u64 *)&cmd->asv[0] = 0ULL;	/* 0x80 */
+
+		rc = __genwqe_execute_raw_ddcb(cd, cmd);
+
+		load->retc = cmd->retc;
+		load->attn = cmd->attn;
+		load->progress = cmd->progress;
+
+		if ((rc < 0) && (rc != -EBADMSG)) {
+			dev_err(&pci_dev->dev,
+				"  [%s] DDCB returned (RETC=%x ATTN=%x "
+				"PROG=%x rc=%d)\n", __func__, cmd->retc,
+				cmd->attn, cmd->progress, rc);
+			ddcb_requ_free(cmd);
+			goto free_buffer;
+		}
+
+		rc = copy_to_user(buf, xbuf, tocopy);
+		if (rc) {
+			dev_err(&pci_dev->dev,
+				"  [%s] copy data to user failed rc=%d\n",
+				__func__, rc);
+			rc = -EIO;
+			ddcb_requ_free(cmd);
+			goto free_buffer;
+		}
+
+		/* We know that we can get retc 0x104 with CRC err */
+		if (((cmd->retc == DDCB_RETC_FAULT) &&
+		     (cmd->attn != 0x02)) ||  /* Normally ignore CRC error */
+		    ((cmd->retc == DDCB_RETC_COMPLETE) &&
+		     (cmd->attn != 0x00))) {  /* Everything was fine */
+			dev_err(&pci_dev->dev,
+				"  [%s] DDCB returned (RETC=%x ATTN=%x "
+				"PROG=%x rc=%d)\n", __func__, cmd->retc,
+				cmd->attn, cmd->progress, rc);
+			rc = -EIO;
+			ddcb_requ_free(cmd);
+			goto free_buffer;
+		}
+
+		load->size  -= tocopy;
+		flash += tocopy;
+		buf += tocopy;
+		blocks_to_flash--;
+		ddcb_requ_free(cmd);
+	}
+	rc = 0;
+
+ free_buffer:
+	__genwqe_free_consistent(cd, FLASH_BLOCK, xbuf, dma_addr);
+	return rc;
+}
+
+static int genwqe_pin_mem(struct genwqe_file *cfile, struct genwqe_mem *m)
+{
+	int rc;
+	struct genwqe_dev *cd = cfile->cd;
+	struct pci_dev *pci_dev = cfile->cd->pci_dev;
+	struct dma_mapping *dma_map;
+	unsigned long map_addr;
+	unsigned long map_size;
+
+	if ((m->addr == 0x0) || (m->size == 0))
+		return -EINVAL;
+
+	map_addr = (m->addr & PAGE_MASK);
+	map_size = round_up(m->size + (m->addr & ~PAGE_MASK), PAGE_SIZE);
+
+	genwqe_dprintk(cd, dbg_card_pinning,
+		       "[%s] pinning user memory %016lx %ld bytes w=%d\n",
+		       __func__, map_addr, map_size, m->direction);
+
+	dma_map = kzalloc(sizeof(struct dma_mapping), GFP_ATOMIC);
+	if (dma_map == NULL)
+		return -ENOMEM;
+
+	genwqe_mapping_init(dma_map, GENWQE_MAPPING_SGL_PINNED);
+	rc = user_vmap(cd, dma_map, (void *)map_addr, map_size, NULL);
+	if (rc != 0) {
+		dev_err(&pci_dev->dev,
+			"[%s] user_vmap rc=%d\n", __func__, rc);
+		return rc;
+	}
+
+	genwqe_add_pin(cfile, dma_map);
+	return 0;
+}
+
+static int genwqe_unpin_mem(struct genwqe_file *cfile, struct genwqe_mem *m)
+{
+	struct genwqe_dev *cd = cfile->cd;
+	struct dma_mapping *dma_map;
+	unsigned long map_addr;
+	unsigned long map_size;
+
+	if (m->addr == 0x0)
+		return -EINVAL;
+
+	map_addr = (m->addr & PAGE_MASK);
+	map_size = round_up(m->size + (m->addr & ~PAGE_MASK), PAGE_SIZE);
+
+	genwqe_dprintk(cd, dbg_card_pinning,
+		       "[%s] unpinning user memory %016lx %ld bytes\n",
+		       __func__, map_addr, map_size);
+
+	dma_map = genwqe_search_pin(cfile, map_addr, map_size, NULL);
+	if (dma_map == NULL)
+		return -ENOENT;
+
+	genwqe_del_pin(cfile, dma_map);
+	user_vunmap(cd, dma_map, NULL);
+	kfree(dma_map);
+	return 0;
+}
+
+/**
+ * ddcb_cmd_cleanup() - Remove dynamically created fixup entries
+ *
+ * Only if there are any. Pinnings are not removed.
+ */
+static int ddcb_cmd_cleanup(struct genwqe_file *cfile, struct ddcb_requ *req)
+{
+	unsigned int i;
+	struct dma_mapping *dma_map;
+	struct genwqe_dev *cd = cfile->cd;
+
+	for (i = 0; i < DDCB_FIXUPS; i++) {
+		dma_map = &req->dma_mappings[i];
+
+		if (dma_mapping_used(dma_map)) {
+			__genwqe_del_mapping(cfile, dma_map);
+			user_vunmap(cd, dma_map, req);
+		}
+		if (req->sgl[i] != NULL) {
+			genwqe_free_sgl(cd, req->sgl[i],
+				       req->sgl_dma_addr[i],
+				       req->sgl_size[i]);
+			req->sgl[i] = NULL;
+			req->sgl_dma_addr[i] = 0x0;
+			req->sgl_size[i] = 0;
+		}
+
+	}
+	return 0;
+}
+
+/**
+ * ddcb_cmd_fixups() - Establish DMA fixups/sglists for user memory references
+ *
+ * Before the DDCB gets executed we need to handle the fixups. We
+ * replace the user-space addresses with DMA addresses or do
+ * additional setup work e.g. generating a scatter-gather list which
+ * is used to describe the memory referred to in the fixup.
+ */
+static int ddcb_cmd_fixups(struct genwqe_file *cfile, struct ddcb_requ *req)
+{
+	int rc;
+	unsigned int asiv_offs, i;
+	struct genwqe_dev *cd = cfile->cd;
+	struct genwqe_ddcb_cmd *cmd = &req->cmd;
+	struct dma_mapping *m;
+	struct pci_dev *pci_dev = cd->pci_dev;
+	const char *type = "UNKNOWN";
+
+	for (i = 0, asiv_offs = 0x00; asiv_offs <= 0x58;
+	     i++, asiv_offs += 0x08) {
+
+		u64 u_addr, d_addr;
+		u32 u_size = 0;
+		unsigned long ats_flags;
+
+		ats_flags = ATS_GET_FLAGS(be64_to_cpu(cmd->ats), asiv_offs);
+
+		switch (ats_flags) {
+
+		case ATS_TYPE_DATA:
+			break;	/* nothing to do here */
+
+		case ATS_TYPE_FLAT_RDWR:
+		case ATS_TYPE_FLAT_RD: {
+			u_addr = be64_to_cpu(*((u64 *)&cmd->
+					       asiv[asiv_offs]));
+			u_size = be32_to_cpu(*((u32 *)&cmd->
+					       asiv[asiv_offs + 0x08]));
+
+			/*
+			 * No data available. Ignore u_addr in this
+			 * case and set addr to 0. Hardware must not
+			 * fetch the buffer.
+			 */
+			if (u_size == 0x0) {
+				*((u64 *)&cmd->asiv[asiv_offs]) =
+					cpu_to_be64(0x0);
+				break;
+			}
+
+			m = __genwqe_search_mapping(cfile, u_addr, u_size,
+						   &d_addr, NULL);
+			if (m == NULL) {
+				rc = -EFAULT;
+				goto err_out;
+			}
+
+			*((u64 *)&cmd->asiv[asiv_offs]) = cpu_to_be64(d_addr);
+			break;
+		}
+
+		case ATS_TYPE_SGL_RDWR:
+		case ATS_TYPE_SGL_RD: {
+			int page_offs, nr_pages, offs;
+
+			u_addr = be64_to_cpu(*((u64 *)&cmd->asiv[asiv_offs]));
+			u_size = be32_to_cpu(*((u32 *)&cmd->asiv[asiv_offs +
+								 0x08]));
+
+			/*
+			 * No data available. Ignore u_addr in this
+			 * case and set addr to 0. Hardware must not
+			 * fetch the empty sgl.
+			 */
+			if (u_size == 0x0) {
+				*((u64 *)&cmd->asiv[asiv_offs]) =
+					cpu_to_be64(0x0);
+				break;
+			}
+
+			m = genwqe_search_pin(cfile, u_addr, u_size, NULL);
+			if (m != NULL) {
+				type = "PINNING";
+				page_offs = (u_addr -
+					     (u64)m->u_vaddr)/PAGE_SIZE;
+			} else {
+				type = "MAPPING";
+				m = &req->dma_mappings[i];
+
+				genwqe_mapping_init(m,
+						    GENWQE_MAPPING_SGL_TEMP);
+				rc = user_vmap(cd, m, (void *)u_addr, u_size,
+					       req);
+				if (rc != 0)
+					goto err_out;
+
+				__genwqe_add_mapping(cfile, m);
+				page_offs = 0;
+			}
+
+			offs = offset_in_page(u_addr);
+			nr_pages = DIV_ROUND_UP(offs + u_size, PAGE_SIZE);
+
+			genwqe_dprintk(cd, dbg_card_pinning,
+				       "[%s] %s for %016llx/%08x: "
+				       "addr=%p/size=%08x page_start=%d "
+				       "offs=%08x num_pages=%d "
+				       "new/n_pages=%d\n", __func__,
+				       type, u_addr, u_size, m->u_vaddr,
+				       m->size, page_offs, offs, m->nr_pages,
+				       nr_pages);
+
+			/* create genwqe style scatter gather list */
+			req->sgl[i] = genwqe_alloc_sgl(cd, m->nr_pages,
+						      &req->sgl_dma_addr[i],
+						      &req->sgl_size[i]);
+			if (req->sgl[i] == NULL) {
+				rc = -ENOMEM;
+				goto err_out;
+			}
+			genwqe_setup_sgl(cd, offs, u_size,
+					req->sgl[i],
+					req->sgl_dma_addr[i],
+					req->sgl_size[i],
+					m->dma_list,
+					page_offs,
+					nr_pages);
+
+			*((u64 *)&cmd->asiv[asiv_offs]) =
+				cpu_to_be64(req->sgl_dma_addr[i]);
+
+			break;
+		}
+		default:
+			dev_err(&pci_dev->dev,
+				"[%s] err: invalid ATS flags %01lx\n",
+				__func__, ats_flags);
+			rc = -EINVAL;
+			goto err_out;
+		}
+	}
+	return 0;
+
+ err_out:
+	dev_err(&pci_dev->dev, "[%s] err: rc=%d\n", __func__, rc);
+	ddcb_cmd_cleanup(cfile, req);
+	return rc;
+}
+
+/**
+ * genwqe_execute_ddcb() - Execute DDCB using userspace address fixups
+ *
+ * The code will build up the translation tables or lookup the
+ * contignous memory allocation table to find the right translations
+ * and DMA addresses.
+ */
+static int genwqe_execute_ddcb(struct genwqe_file *cfile,
+			       struct genwqe_ddcb_cmd *cmd)
+{
+	int rc;
+	struct genwqe_dev *cd = cfile->cd;
+	struct ddcb_requ *req = container_of(cmd, struct ddcb_requ, cmd);
+
+	rc = ddcb_cmd_fixups(cfile, req);
+	if (rc != 0) {
+		genwqe_dprintk(cd, dbg_card_ddcb,
+			       "[%s] err: fixups rc=%d\n", __func__, rc);
+		return rc;
+	}
+	rc = __genwqe_execute_raw_ddcb(cd, cmd);
+
+	ddcb_cmd_cleanup(cfile, req);
+	return rc;
+}
+
+static int do_execute_ddcb(struct genwqe_file *cfile,
+			   unsigned long arg, int raw)
+{
+	int rc;
+	struct genwqe_ddcb_cmd *cmd;
+	struct ddcb_requ *req;
+	struct genwqe_dev *cd = cfile->cd;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	cmd = ddcb_requ_alloc();
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	req = container_of(cmd, struct ddcb_requ, cmd);
+
+	if (copy_from_user(cmd, (void __user *)arg, sizeof(*cmd))) {
+		dev_err(&pci_dev->dev,
+			"err: could not copy params from user\n");
+		ddcb_requ_free(cmd);
+		return -EFAULT;
+	}
+
+	if (!raw)
+		rc = genwqe_execute_ddcb(cfile, cmd);
+	else
+		rc = __genwqe_execute_raw_ddcb(cd, cmd);
+
+	/* Copy back only the modifed fields. Do not copy ASIV
+	   back since the copy got modified by the driver. */
+	if (copy_to_user((void __user *)arg, cmd,
+			 sizeof(*cmd) - DDCB_ASIV_LENGTH)) {
+		dev_err(&pci_dev->dev,
+			"err: could not copy params to user\n");
+		ddcb_requ_free(cmd);
+		return -EFAULT;
+	}
+
+	ddcb_requ_free(cmd);
+	return rc;
+}
+
+/**
+ * genwqe_ioctl() - IO control
+ * @filp:       file handle
+ * @cmd:        command identifier (passed from user)
+ * @arg:        argument (passed from user)
+ *
+ * Return: 0 success
+ */
+static long genwqe_ioctl(struct file *filp, unsigned int cmd,
+			 unsigned long arg)
+{
+	int rc = 0;
+	struct genwqe_file *cfile = (struct genwqe_file *)filp->private_data;
+	struct genwqe_dev *cd = cfile->cd;
+	struct regs_io __user *io;
+	u64 u64_val;
+	u32 reg_offs, u32_val;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	if (_IOC_TYPE(cmd) != GENWQE_IOC_CODE) {
+		dev_err(&pci_dev->dev, "err: ioctl code does not match!\n");
+		return -EINVAL;
+	}
+
+	switch (cmd) {
+
+	case GENWQE_GET_CARD_STATE:
+		put_user(cd->card_state, (enum genwqe_card_state __user *)arg);
+		return 0;
+
+		/* Register access */
+	case GENWQE_READ_REG64: {
+		io = (struct regs_io __user *)arg;
+
+		if (get_user(reg_offs, &io->num)) {
+			dev_err(&pci_dev->dev, "err: reg read64\n");
+			return -EFAULT;
+		}
+		if ((reg_offs >= cd->mmio_len) || (reg_offs & 0x7))
+			return -EINVAL;
+
+		u64_val = __genwqe_readq(cd, reg_offs);
+		put_user(u64_val, &io->val64);
+		return 0;
+	}
+
+	case GENWQE_WRITE_REG64: {
+		io = (struct regs_io __user *)arg;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if ((filp->f_flags & O_ACCMODE) == O_RDONLY)
+			return -EPERM;
+
+		if (get_user(reg_offs, &io->num)) {
+			dev_err(&pci_dev->dev, "err: reg write64\n");
+			return -EFAULT;
+		}
+		if ((reg_offs >= cd->mmio_len) || (reg_offs & 0x7))
+			return -EINVAL;
+
+		if (get_user(u64_val, &io->val64)) {
+			dev_err(&pci_dev->dev, "err: reg write64\n");
+			return -EFAULT;
+		}
+		__genwqe_writeq(cd, reg_offs, u64_val);
+		return 0;
+	}
+
+	case GENWQE_READ_REG32: {
+		io = (struct regs_io __user *)arg;
+
+		if (get_user(reg_offs, &io->num)) {
+			dev_err(&pci_dev->dev, "err: reg read32\n");
+			return -EFAULT;
+		}
+		if ((reg_offs >= cd->mmio_len) || (reg_offs & 0x3))
+			return -EINVAL;
+
+		u32_val = __genwqe_readl(cd, reg_offs);
+		put_user(u32_val, &io->val32);
+		return 0;
+	}
+
+	case GENWQE_WRITE_REG32: {
+		io = (struct regs_io __user *)arg;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if ((filp->f_flags & O_ACCMODE) == O_RDONLY)
+			return -EPERM;
+
+		if (get_user(reg_offs, &io->num)) {
+			dev_err(&pci_dev->dev, "err: reg write32\n");
+			return -EFAULT;
+		}
+		if ((reg_offs >= cd->mmio_len) || (reg_offs & 0x3))
+			return -EINVAL;
+
+		if (get_user(u32_val, &io->val32)) {
+			dev_err(&pci_dev->dev, "err: reg write32\n");
+			return -EFAULT;
+		}
+		__genwqe_writel(cd, reg_offs, u32_val);
+		return 0;
+	}
+
+		/* Flash update/reading */
+	case GENWQE_SLU_UPDATE: {
+		struct chip_bitstream load;
+
+		if (!genwqe_is_privileged(cd))
+			return -EPERM;
+
+		if ((filp->f_flags & O_ACCMODE) == O_RDONLY)
+			return -EPERM;
+
+		if (copy_from_user(&load, (void __user *)arg, sizeof(load))) {
+			dev_err(&pci_dev->dev,
+				"err: could not copy params from user\n");
+			return -EFAULT;
+		}
+		rc = do_flash_update(cfile, &load);
+
+		if (copy_to_user((void __user *)arg, &load, sizeof(load))) {
+			dev_err(&pci_dev->dev,
+				"err: could not copy params to user\n");
+			return -EFAULT;
+		}
+		dev_info(&pci_dev->dev, "[%s] rc=%d\n", __func__, rc);
+		return rc;
+	}
+
+	case GENWQE_SLU_READ: {
+		struct chip_bitstream load;
+
+		if (!genwqe_is_privileged(cd))
+			return -EPERM;
+
+		if (genwqe_flash_readback_fails(cd))
+			return -ENOSPC;	 /* known to fail for old versions */
+
+		if (copy_from_user(&load, (void __user *)arg, sizeof(load))) {
+			dev_err(&pci_dev->dev,
+				"err: could not copy params from user\n");
+			return -EFAULT;
+		}
+		rc = do_flash_read(cfile, &load);
+
+		if (copy_to_user((void __user *)arg, &load, sizeof(load))) {
+			dev_err(&pci_dev->dev,
+				"err: could not copy params to user\n");
+			return -EFAULT;
+		}
+		dev_info(&pci_dev->dev, "[%s] rc=%d\n", __func__, rc);
+		return rc;
+	}
+
+		/* memory pinning and unpinning */
+	case GENWQE_PIN_MEM: {
+		struct genwqe_mem m;
+
+		if (copy_from_user(&m, (void __user *)arg, sizeof(m))) {
+			dev_err(&pci_dev->dev,
+				"err: could not copy params from user\n");
+			return -EFAULT;
+		}
+		return genwqe_pin_mem(cfile, &m);
+	}
+
+	case GENWQE_UNPIN_MEM: {
+		struct genwqe_mem m;
+
+		if (copy_from_user(&m, (void __user *)arg, sizeof(m))) {
+			dev_err(&pci_dev->dev,
+				"err: could not copy params from user\n");
+			return -EFAULT;
+		}
+		return genwqe_unpin_mem(cfile, &m);
+	}
+
+		/* launch an DDCB and wait for completion */
+	case GENWQE_EXECUTE_DDCB:
+		return do_execute_ddcb(cfile, arg, 0);
+
+	case GENWQE_EXECUTE_RAW_DDCB: {
+
+		if (!capable(CAP_SYS_ADMIN)) {
+			dev_err(&pci_dev->dev,
+				"err: must be superuser execute raw DDCB!\n");
+			return -EPERM;
+		}
+		return do_execute_ddcb(cfile, arg, 1);
+	}
+
+	default:
+		pr_err("unknown ioctl %x/%lx**\n", cmd, arg);
+		return -EINVAL;
+	}
+
+	return rc;
+}
+
+static const struct file_operations genwqe_fops = {
+	.owner		= THIS_MODULE,
+	.open		= genwqe_open,
+	.fasync		= genwqe_fasync,
+	.mmap		= genwqe_mmap,
+	.unlocked_ioctl	= genwqe_ioctl,
+	.release	= genwqe_release,
+};
+
+static int genwqe_device_initialized(struct genwqe_dev *cd)
+{
+	return (cd->dev != NULL);
+}
+
+/**
+ * genwqe_device_create() - Create and configure genwqe char device
+ * @cd:      genwqe device descriptor
+ *
+ * This function must be called before we create any more genwqe
+ * character devices, because it is allocating the major and minor
+ * number which are supposed to be used by the client drivers.
+ */
+int genwqe_device_create(struct genwqe_dev *cd)
+{
+	int rc;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	/*
+	 * Here starts the individual setup per client. It must
+	 * initialize its own cdev data structure with its own fops.
+	 * The appropriate devnum needs to be created. The ranges must
+	 * not overlap.
+	 */
+	rc = alloc_chrdev_region(&cd->devnum_genwqe, 0,
+				 GENWQE_MAX_MINOR, GENWQE_DEVNAME);
+	if (rc < 0) {
+		dev_err(&pci_dev->dev, "err: alloc_chrdev_region failed\n");
+		goto err_dev;
+	}
+
+	cdev_init(&cd->cdev_genwqe, &genwqe_fops);
+	cd->cdev_genwqe.owner = THIS_MODULE;
+
+	rc = cdev_add(&cd->cdev_genwqe, cd->devnum_genwqe, 1);
+	if (rc < 0) {
+		dev_err(&pci_dev->dev, "err: cdev_add failed\n");
+		goto err_add;
+	}
+
+	/*
+	 * Finally the device in /dev/... must be created. The rule is
+	 * to use card%d_clientname for each created device.
+	 */
+	cd->dev = device_create(cd->class_genwqe, &cd->pci_dev->dev,
+				cd->devnum_genwqe, NULL,
+				GENWQE_DEVNAME "%u_card", cd->card_idx);
+	if (cd->dev == NULL) {
+		rc = -ENODEV;
+		goto err_cdev;
+	}
+	dev_set_drvdata(cd->dev, cd);
+
+	rc = create_card_sysfs(cd);
+	if (rc != 0)
+		goto err_sysfs;
+
+	rc = genwqe_init_debugfs(cd);
+	if (rc != 0)
+		goto err_debugfs;
+
+	return 0;
+
+ err_debugfs:
+	remove_card_sysfs(cd);
+ err_sysfs:
+	device_destroy(cd->class_genwqe, cd->devnum_genwqe);
+ err_cdev:
+	cdev_del(&cd->cdev_genwqe);
+ err_add:
+	unregister_chrdev_region(cd->devnum_genwqe, GENWQE_MAX_MINOR);
+ err_dev:
+	cd->dev = NULL;
+	return rc;
+}
+
+static int genwqe_inform_and_stop_processes(struct genwqe_dev *cd)
+{
+	int rc;
+	unsigned int i;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	if (!genwqe_open_files(cd))
+		return 0;
+
+	dev_warn(&pci_dev->dev, "[%s] send SIGIO and wait ...\n", __func__);
+
+	rc = genwqe_kill_fasync(cd, SIGIO);
+	if (rc > 0) {
+		/* give kill_timeout seconds to close file descriptors ... */
+		for (i = 0; (i < genwqe_kill_timeout) &&
+			     genwqe_open_files(cd); i++) {
+			dev_info(&pci_dev->dev, "  %d sec ...", i);
+
+			cond_resched();
+			msleep(1000);
+		}
+
+		/* if no open files we can safely continue, else ... */
+		if (!genwqe_open_files(cd))
+			return 0;
+
+		dev_warn(&pci_dev->dev,
+			 "[%s] send SIGKILL and wait ...\n", __func__);
+
+		rc = genwqe_force_sig(cd, SIGKILL); /* force terminate */
+		if (rc) {
+			/* Give kill_timout more seconds to end processes */
+			for (i = 0; (i < genwqe_kill_timeout) &&
+				     genwqe_open_files(cd); i++) {
+				dev_warn(&pci_dev->dev, "  %d sec ...", i);
+
+				cond_resched();
+				msleep(1000);
+			}
+		}
+	}
+	return 0;
+}
+
+/**
+ * genwqe_device_remove() - Remove genwqe's char device
+ *
+ * This function must be called after the client devices are removed
+ * because it will free the major/minor number range for the genwqe
+ * drivers.
+ *
+ * This function must be robust enough to be called twice.
+ */
+int genwqe_device_remove(struct genwqe_dev *cd)
+{
+	int rc;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	if (!genwqe_device_initialized(cd))
+		return 1;
+
+	genwqe_inform_and_stop_processes(cd);
+
+	/*
+	 * We currently do wait until all filedescriptors are
+	 * closed. This leads to a problem when we abort the
+	 * application which will decrease this reference from
+	 * 1/unused to 0/illegal and not from 2/used 1/empty.
+	 */
+	rc = atomic_read(&cd->cdev_genwqe.kobj.kref.refcount);
+	if (rc != 1) {
+		dev_err(&pci_dev->dev,
+			"[%s] err: cdev_genwqe...refcount=%d\n", __func__, rc);
+		panic("Fatal err: cannot free resources with pending references!");
+	}
+
+	genqwe_exit_debugfs(cd);
+	remove_card_sysfs(cd);
+	device_destroy(cd->class_genwqe, cd->devnum_genwqe);
+	cdev_del(&cd->cdev_genwqe);
+	unregister_chrdev_region(cd->devnum_genwqe, GENWQE_MAX_MINOR);
+	cd->dev = NULL;
+
+	return 0;
+}
diff --git a/drivers/misc/genwqe/card_sysfs.c b/drivers/misc/genwqe/card_sysfs.c
new file mode 100644
index 0000000..cac2e06
--- /dev/null
+++ b/drivers/misc/genwqe/card_sysfs.c
@@ -0,0 +1,306 @@
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
+ * the version of the bitstream as well as some for the
+ * driver. Additionally there are some attributes which help to debug
+ * potential problems.
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
+static ssize_t show_card_status(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	ssize_t len = 0;
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+	const char *cs[GENWQE_CARD_STATE_MAX] = { "unused", "used", "error" };
+
+	len += scnprintf(&buf[len], PAGE_SIZE - len,
+			 "%s\n", cs[cd->card_state]);
+	return len;
+}
+
+static ssize_t show_card_appid(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	ssize_t len = 0;
+	char app_name[5];
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+
+	genwqe_read_app_id(cd, app_name, sizeof(app_name));
+	len += scnprintf(&buf[len], PAGE_SIZE - len,
+			 "%s\n", app_name);
+	return len;
+}
+
+static ssize_t show_card_version(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	ssize_t len = 0;
+	u64 slu_id, app_id;
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+
+	slu_id = __genwqe_readq(cd, IO_SLU_UNITCFG);
+	app_id = __genwqe_readq(cd, IO_APP_UNITCFG);
+
+	len += scnprintf(&buf[len], PAGE_SIZE - len,
+			 "%016llx.%016llx\n", slu_id, app_id);
+	return len;
+}
+
+/**
+ * FIXME Implement me!
+ */
+static ssize_t show_cpld_version(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	ssize_t len = 0;
+	len += scnprintf(&buf[len], PAGE_SIZE - len,
+			 "unknown (FIXME)\n");
+	return len;
+}
+
+static ssize_t show_card_type(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	ssize_t len = 0;
+	u8 card_type;
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+
+	card_type = genwqe_card_type(cd);
+	len += scnprintf(&buf[len], PAGE_SIZE - len,
+			 "%s\n", (card_type >= ARRAY_SIZE(genwqe_types)) ?
+			 "invalid" : genwqe_types[card_type]);
+	return len;
+}
+
+static ssize_t show_card_driver(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	ssize_t len = 0;
+	len += scnprintf(&buf[len], PAGE_SIZE - len,
+			 "%s\n", DRV_VERS_STRING);
+	return len;
+}
+
+static ssize_t show_card_tempsens(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	ssize_t len = 0;
+	u64 tempsens;
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+
+	tempsens = __genwqe_readq(cd, IO_SLU_TEMPERATURE_SENSOR);
+	len += scnprintf(&buf[len], PAGE_SIZE - len,
+			 "%016llx\n", tempsens);
+	return len;
+}
+
+static ssize_t show_card_base_clock(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	ssize_t len = 0;
+	u64 base_clock;
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+
+	base_clock = genwqe_base_clock_frequency(cd);
+	len += scnprintf(&buf[len], PAGE_SIZE - len,
+			 "%lld\n", base_clock);
+	return len;
+}
+
+/**
+ * show_card_curr_bitstream() - Show the current bitstream id
+ *
+ * There is a bug in some old versions of the CPLD which selects the
+ * bitstream, which causes the IO_SLU_BITSTREAM register to report
+ * unreliable data in very rare cases. This makes this sysfs
+ * unreliable up to the point were a new CPLD version is being used.
+ *
+ * Unfortunately there is no automatic way yet to query the CPLD
+ * version (See show_cpld_version() ;-)), such that you need to
+ * manually ensure via programming tools that you have a recent
+ * version of the CPLD software.
+ *
+ * The proposed circumvention is to use a special recovery bitstream
+ * on the backup partition (0) to identify problems while loading the
+ * image.
+ */
+static ssize_t show_card_curr_bitstream(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	ssize_t len = 0;
+	int curr_bitstream;
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+
+	curr_bitstream = __genwqe_readq(cd, IO_SLU_BITSTREAM) & 0x1;
+	len += scnprintf(&buf[len], PAGE_SIZE - len,
+			 "%d\n", curr_bitstream);
+	return len;
+}
+
+/**
+ * show_card_next_bitstream() - Show the next activated bitstream
+ *
+ * IO_SLC_CFGREG_SOFTRESET: This register can only be accessed by the PF.
+ */
+static ssize_t show_card_next_bitstream(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	ssize_t len = 0;
+	int next_bitstream;
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+
+	switch ((cd->softreset & 0xCull) >> 2) {
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
+	len += scnprintf(&buf[len], PAGE_SIZE - len,
+			 "%d\n", next_bitstream);
+	return len;
+}
+
+static ssize_t store_card_next_bitstream(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	u64 partition;
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+
+	if (kstrtoull(buf, 0, &partition) < 0)
+		return -EINVAL;
+
+	switch (partition) {
+	case 0x0:
+		cd->softreset = 0x78ull;
+		break;
+	case 0x1:
+		cd->softreset = 0x7cull;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	__genwqe_writeq(cd, IO_SLC_CFGREG_SOFTRESET, cd->softreset);
+	return count;
+}
+
+/*
+ * Create device_attribute structures / params: name, mode, show, store
+ * additional flag if valid in VF
+ */
+struct genwqe_dev_attrib {
+	struct device_attribute att;	/* sysfs entry attributes */
+	int vf;				/* may exist in VF or not */
+};
+
+static struct genwqe_dev_attrib dev_attr_tab[] = {
+	{__ATTR(tempsens,       S_IRUGO, show_card_tempsens, NULL), 0},
+	{__ATTR(next_bitstream, (S_IRUGO | S_IWUSR),
+		show_card_next_bitstream, store_card_next_bitstream), 0},
+	{__ATTR(curr_bitstream, S_IRUGO, show_card_curr_bitstream, NULL), 0},
+	{__ATTR(cpld_version,   S_IRUGO, show_cpld_version, NULL), 0},
+	{__ATTR(base_clock,	S_IRUGO, show_card_base_clock, NULL), 0},
+
+	{__ATTR(driver,		S_IRUGO, show_card_driver, NULL), 1},
+	{__ATTR(type,		S_IRUGO, show_card_type, NULL), 1},
+	{__ATTR(version,	S_IRUGO, show_card_version, NULL), 1},
+	{__ATTR(appid,		S_IRUGO, show_card_appid, NULL), 1},
+	{__ATTR(status,		S_IRUGO, show_card_status, NULL), 1},
+};
+
+/**
+ * create_card_sysfs() - Setup sysfs entries of the card device
+ *
+ * VFs have restricted mmio capabilities, so not all sysfs entries
+ * are allowed in VFs.
+ */
+int create_card_sysfs(struct genwqe_dev *cd)
+{
+	int rc, priv;
+	unsigned int i;
+
+	priv = genwqe_is_privileged(cd);
+	for (i = 0; i < ARRAY_SIZE(dev_attr_tab); i++) {
+		struct genwqe_dev_attrib *dev_attr = &dev_attr_tab[i];
+		if (dev_attr->vf || priv) {
+			rc = device_create_file(cd->dev, &dev_attr->att);
+			if (rc != 0)
+				goto err_exit;
+		}
+	}
+	return 0;
+
+ err_exit:
+	return -ENXIO;
+}
+
+/**
+ * remove_card_sysfs() - Remove sysfs entries
+ */
+void remove_card_sysfs(struct genwqe_dev *cd)
+{
+	int priv;
+	unsigned int i;
+
+	priv = genwqe_is_privileged(cd);
+	for (i = 0; i < ARRAY_SIZE(dev_attr_tab); i++) {
+		struct genwqe_dev_attrib *dev_attr = &dev_attr_tab[i];
+		if (dev_attr->vf || priv)
+			device_remove_file(cd->dev, &dev_attr->att);
+	}
+}
diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
new file mode 100644
index 0000000..5037e28
--- /dev/null
+++ b/drivers/misc/genwqe/card_utils.c
@@ -0,0 +1,983 @@
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
+ * Miscelanous functionality used in the other GenWQE driver parts.
+ */
+
+#include <linux/kernel.h>
+#include <linux/dma-mapping.h>
+#include <linux/sched.h>
+#include <linux/vmalloc.h>
+#include <linux/page-flags.h>
+#include <linux/scatterlist.h>
+#include <linux/hugetlb.h>
+#include <linux/iommu.h>
+#include <linux/delay.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include <linux/ctype.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <asm/pgtable.h>
+
+#include "genwqe_driver.h"
+#include "card_base.h"
+#include "card_ddcb.h"
+
+/**
+ * __genwqe_writeq() - Write 64-bit register
+ * @cd:	        genwqe device descriptor
+ * @byte_offs:  byte offset within BAR
+ * @val:        64-bit value
+ *
+ * Return: 0 if success; < 0 if error
+ */
+int __genwqe_writeq(struct genwqe_dev *cd, u64 byte_offs, u64 val)
+{
+	genwqe_dprintk(cd, dbg_card_regs,
+		   "  genwqe_writeq: reg=%08llx val=%016llx\n",
+		   byte_offs, val);
+
+	if (cd->err_inject & GENWQE_INJECT_HARDWARE_FAILURE)
+		return -EIO;
+
+	if (cd->mmio == NULL)
+		return -EIO;
+
+	__raw_writeq(cpu_to_be64((val)), (cd->mmio + byte_offs));
+	return 0;
+}
+
+/**
+ * __genwqe_readq() - Read 64-bit register
+ * @cd:         genwqe device descriptor
+ * @byte_offs:  offset within BAR
+ *
+ * Return: value from register
+ */
+u64 __genwqe_readq(struct genwqe_dev *cd, u64 byte_offs)
+{
+	u64 val;
+
+	if (cd->err_inject & GENWQE_INJECT_HARDWARE_FAILURE)
+		return 0xffffffffffffffffull;
+
+	if ((cd->err_inject & GENWQE_INJECT_GFIR_FATAL) &&
+	    (byte_offs == IO_SLC_CFGREG_GFIR))
+		return 0x000000000000ffffull;
+
+	if ((cd->err_inject & GENWQE_INJECT_GFIR_INFO) &&
+	    (byte_offs == IO_SLC_CFGREG_GFIR))
+		return 0x00000000ffff0000ull;
+
+	if (cd->mmio == NULL)
+		return 0xffffffffffffffffull;
+
+	val = be64_to_cpu(__raw_readq(cd->mmio + byte_offs));
+
+	genwqe_dprintk(cd, dbg_card_regs,
+		       "  genwqe_readq:  reg=%08llx val=%016llx\n",
+		       byte_offs, val);
+
+	return val;
+}
+
+/**
+ * __genwqe_writel() - Write 32-bit register
+ * @cd:	        genwqe device descriptor
+ * @byte_offs:  byte offset within BAR
+ * @val:        32-bit value
+ *
+ * Return: 0 if success; < 0 if error
+ */
+int __genwqe_writel(struct genwqe_dev *cd, uint64_t byte_offs, u32 val)
+{
+	genwqe_dprintk(cd, dbg_card_regs,
+		       "  genwqe_writel: reg=%08llx val=%08x\n",
+		       byte_offs, val);
+
+	if (cd->err_inject & GENWQE_INJECT_HARDWARE_FAILURE)
+		return -EIO;
+
+	if (cd->mmio == NULL)
+		return -EIO;
+
+	__raw_writel(cpu_to_be32((val)), cd->mmio + byte_offs);
+	return 0;
+}
+
+/**
+ * __genwqe_readl() - Read 32-bit register
+ * @cd:         genwqe device descriptor
+ * @byte_offs:  offset within BAR
+ *
+ * Return: Value from register
+ */
+u32 __genwqe_readl(struct genwqe_dev *cd, uint64_t byte_offs)
+{
+	if (cd->err_inject & GENWQE_INJECT_HARDWARE_FAILURE)
+		return 0xffffffff;
+
+	if (cd->mmio == NULL)
+		return 0xffffffff;
+
+	return be32_to_cpu(__raw_readl(cd->mmio + byte_offs));
+}
+
+/**
+ * genwqe_read_app_id() - Extract app_id
+ *
+ * app_unitcfg need to be filled with valid data first
+ */
+int genwqe_read_app_id(struct genwqe_dev *cd, char *app_name, int len)
+{
+	int i, j;
+	u32 app_id = (u32)cd->app_unitcfg;
+
+	memset(app_name, 0, len);
+	for (i = 0, j = 0; j < min(len, 4); j++) {
+		char ch = (char)((app_id >> (24 - j*8)) & 0xff);
+		if (ch == ' ')
+			continue;
+		app_name[i++] = isprint(ch) ? ch : 'X';
+	}
+	return i;
+}
+
+/**
+ * init_crc32() - Prepare a lookup table for fast crc32 calculations
+ *
+ * Existing kernel functions seem to use a different polynom,
+ * therefore we could not use them here.
+ *
+ * Genwqe's Polynomial = 0x20044009
+ */
+#define CRC32_POLYNOMIAL	0x20044009
+static u32 crc32_tab[256];	/* crc32 lookup table */
+
+void init_crc32(void)
+{
+	int i, j;
+	u32 crc;
+
+	for (i = 0;  i < 256;  i++) {
+		crc = i << 24;
+		for (j = 0;  j < 8;  j++) {
+			if (crc & 0x80000000)
+				crc = (crc << 1) ^ CRC32_POLYNOMIAL;
+			else
+				crc = (crc << 1);
+		}
+		crc32_tab[i] = crc;
+	}
+}
+
+/**
+ * genwqe_crc32() - Generate 32-bit crc as required for DDCBs
+ * @buff:       pointer to data buffer
+ * @len:        length of data for calculation
+ * @init:       initial crc (0xffffffff at start)
+ *
+ * polynomial = x^32 * + x^29 + x^18 + x^14 + x^3 + 1 (0x20044009)
+
+ * Example: 4 bytes 0x01 0x02 0x03 0x04 with init=0xffffffff should
+ * result in a crc32 of 0xf33cb7d3.
+ *
+ * The existing kernel crc functions did not cover this polynom yet.
+ *
+ * Return: crc32 checksum.
+ */
+u32 genwqe_crc32(u8 *buff, size_t len, u32 init)
+{
+	int i;
+	u32 crc;
+
+	crc = init;
+	while (len--) {
+		i = ((crc >> 24) ^ *buff++) & 0xFF;
+		crc = (crc << 8) ^ crc32_tab[i];
+	}
+	return crc;
+}
+
+void *__genwqe_alloc_consistent(struct genwqe_dev *cd, size_t size,
+			       dma_addr_t *dma_handle)
+{
+	if (get_order(size) > MAX_ORDER)
+		return NULL;
+
+	return pci_alloc_consistent(cd->pci_dev, size, dma_handle);
+}
+
+void __genwqe_free_consistent(struct genwqe_dev *cd, size_t size,
+			     void *vaddr, dma_addr_t dma_handle)
+{
+	if (vaddr == NULL)
+		return;
+	pci_free_consistent(cd->pci_dev, size, vaddr, dma_handle);
+}
+
+static void genwqe_unmap_pages(struct genwqe_dev *cd, dma_addr_t *dma_list,
+			      int num_pages)
+{
+	int i;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	for (i = 0; (i < num_pages) && (dma_list[i] != 0x0); i++) {
+		pci_unmap_page(pci_dev, dma_list[i],
+			       PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
+		dma_list[i] = 0x0;
+	}
+}
+
+static int genwqe_map_pages(struct genwqe_dev *cd,
+			   struct page **page_list, int num_pages,
+			   dma_addr_t *dma_list)
+{
+	int i;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	/* establish DMA mapping for requested pages */
+	for (i = 0; i < num_pages; i++) {
+		dma_addr_t daddr;
+
+		dma_list[i] = 0x0;
+		daddr = pci_map_page(pci_dev, page_list[i],
+				     0,	 /* map_offs */
+				     PAGE_SIZE,
+				     PCI_DMA_BIDIRECTIONAL);  /* FIXME rd/rw */
+
+		if (pci_dma_mapping_error(pci_dev, daddr)) {
+			dev_err(&pci_dev->dev,
+				"[%s] err: no dma addr daddr=%016llx!\n",
+				__func__, (long long)daddr);
+			goto err;
+		}
+
+		dma_list[i] = daddr;
+	}
+	return 0;
+
+ err:
+	genwqe_unmap_pages(cd, dma_list, num_pages);
+	return -EIO;
+}
+
+static int genwqe_sgl_size(int num_pages)
+{
+	int len, num_tlb = num_pages / 7;
+
+	len = sizeof(struct sg_entry) * (num_pages+num_tlb + 1);
+	return roundup(len, PAGE_SIZE);
+}
+
+struct sg_entry *genwqe_alloc_sgl(struct genwqe_dev *cd, int num_pages,
+				  dma_addr_t *dma_addr, size_t *sgl_size)
+{
+	struct pci_dev *pci_dev = cd->pci_dev;
+	struct sg_entry *sgl;
+
+	*sgl_size = genwqe_sgl_size(num_pages);
+	if (get_order(*sgl_size) > MAX_ORDER) {
+		dev_err(&pci_dev->dev,
+			"[%s] err: too much memory requested!\n", __func__);
+		return NULL;
+	}
+
+	sgl = __genwqe_alloc_consistent(cd, *sgl_size, dma_addr);
+	if (sgl == NULL) {
+		dev_err(&pci_dev->dev,
+			"[%s] err: no memory available!\n", __func__);
+		return NULL;
+	}
+
+	return sgl;
+}
+
+static void genwqe_dump_sgl(struct genwqe_dev *cd, struct sg_entry *sgl,
+		    size_t sgl_size)
+{
+	unsigned int i, j;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	for (j = 0, i = 0; i < sgl_size/sizeof(struct sg_entry); i++, j++) {
+		if (j == 8) {
+			dev_info(&pci_dev->dev, "  --\n");
+			j = 0;
+		}
+		dev_info(&pci_dev->dev, "  %016llx %08x %08x %s\n",
+			 be64_to_cpu(sgl[i].target_addr),
+			 be32_to_cpu(sgl[i].len),
+			 be32_to_cpu(sgl[i].flags),
+			 (be32_to_cpu(sgl[i].len) > PAGE_SIZE) ? "C" : "");
+
+		if (be32_to_cpu(sgl[i].flags) == SG_END_LIST)
+			break;
+	}
+}
+
+int genwqe_setup_sgl(struct genwqe_dev *cd,
+		    unsigned long offs,
+		    unsigned long size,
+		    struct sg_entry *sgl, /* genwqe sgl */
+		    dma_addr_t dma_addr, size_t sgl_size,
+		    dma_addr_t *dma_list, int page_offs, int num_pages)
+{
+	int i = 0, j = 0, p;
+	unsigned long dma_offs, map_offs;
+	struct pci_dev *pci_dev = cd->pci_dev;
+	dma_addr_t prev_daddr = 0;
+	struct sg_entry *s, *last_s = NULL;
+
+	/* sanity checks */
+	if (offs > PAGE_SIZE) {
+		dev_err(&pci_dev->dev,
+			"[%s] too large start offs %08lx\n", __func__, offs);
+		return -EFAULT;
+	}
+	if (sgl_size < genwqe_sgl_size(num_pages)) {
+		dev_err(&pci_dev->dev,
+			"[%s] sgl_size too small %08lx for %d pages\n",
+			__func__, sgl_size, num_pages);
+		return -EFAULT;
+	}
+
+	dma_offs = 128;		/* next block if needed/dma_offset */
+	map_offs = offs;	/* offset in first page */
+
+	s = &sgl[0];		/* first set of 8 entries */
+	p = 0;			/* page */
+	while (p < num_pages) {
+		dma_addr_t daddr;
+		unsigned int size_to_map;
+
+		/* always write the chaining entry, cleanup is done later */
+		j = 0;
+		s[j].target_addr = cpu_to_be64(dma_addr + dma_offs);
+		s[j].len	 = cpu_to_be32(128);
+		s[j].flags	 = cpu_to_be32(SG_CHAINED);
+		j++;
+
+		while (j < 8) {
+			/* DMA mapping for requested page, offs, size */
+			size_to_map = min(size, PAGE_SIZE - map_offs);
+			daddr = dma_list[page_offs + p] + map_offs;
+			size -= size_to_map;
+			map_offs = 0;
+
+			if (prev_daddr == daddr) {
+				u32 prev_len = be32_to_cpu(last_s->len);
+
+				/* pr_info("daddr combining: "
+					"%016llx/%08x -> %016llx\n",
+					prev_daddr, prev_len, daddr); */
+
+				last_s->len = cpu_to_be32(prev_len +
+							  size_to_map);
+
+				p++; /* process next page */
+				if (p == num_pages)
+					goto fixup;  /* nothing to do */
+
+				prev_daddr = daddr + size_to_map;
+				continue;
+			}
+
+			/* start new entry */
+			s[j].target_addr = cpu_to_be64(daddr);
+			s[j].len	 = cpu_to_be32(size_to_map);
+			s[j].flags	 = cpu_to_be32(SG_DATA);
+			prev_daddr = daddr + size_to_map;
+			last_s = &s[j];
+			j++;
+
+			p++;	/* process next page */
+			if (p == num_pages)
+				goto fixup;  /* nothing to do */
+		}
+		dma_offs += 128;
+		s += 8;		/* continue 8 elements further */
+	}
+ fixup:
+	if (j == 1) {		/* combining happend on last entry! */
+		s -= 8;		/* full shift needed on previous sgl block */
+		j =  7;		/* shift all elements */
+	}
+
+	for (i = 0; i < j; i++)	/* move elements 1 up */
+		s[i] = s[i + 1];
+
+	s[i].target_addr = cpu_to_be64(0);
+	s[i].len	 = cpu_to_be32(0);
+	s[i].flags	 = cpu_to_be32(SG_END_LIST);
+
+	if (cd->debug & dbg_card_sglist) {
+		genwqe_dprintk(cd, dbg_card_sglist,
+			       " genwqe_sglist %d/sgl poffs=%d %d\n",
+			       j, page_offs, num_pages);
+		genwqe_dump_sgl(cd, sgl, sgl_size);
+	}
+	return 0;
+}
+
+void genwqe_free_sgl(struct genwqe_dev *cd, struct sg_entry *sg_list,
+		    dma_addr_t dma_addr, size_t size)
+{
+	__genwqe_free_consistent(cd, size, sg_list, dma_addr);
+}
+
+/**
+ * free_user_pages() - Give pinned pages back
+ *
+ * Documentation of get_user_pages is in mm/memory.c:
+ *
+ * If the page is written to, set_page_dirty (or set_page_dirty_lock,
+ * as appropriate) must be called after the page is finished with, and
+ * before put_page is called.
+ */
+static int free_user_pages(struct page **page_list, unsigned int nr_pages,
+			   int dirty)
+{
+	unsigned int i;
+
+	for (i = 0; i < nr_pages; i++) {
+		if (page_list[i] != NULL) {
+			if (dirty)
+				set_page_dirty_lock(page_list[i]);
+			put_page(page_list[i]);
+		}
+	}
+	return 0;
+}
+
+/**
+ * user_vmap() - Map user-space memory to virtual kernel memory
+ * @cd:         pointer to genwqe device
+ * @m:          mapping params
+ * @uaddr:      user virtual address
+ * @size:       size of memory to be mapped
+ *
+ * We need to think about how we could speed this up. Of course it is
+ * not a good idea to do this over and over again, like we are
+ * currently doing it. Nevertheless, I am curious where on the path
+ * the performance is spend. Most probably within the memory
+ * allocation functions, but maybe also in the DMA mapping code.
+ *
+ * Restrictions: The maximum size of the possible mapping currently depends
+ *               on the amount of memory we can get using kzalloc() for the
+ *               page_list and pci_alloc_coherent for the sg_list.
+ *               The sg_list is currently itself not scattered, which could
+ *               be fixed with some effort. The page_list must be split into
+ *               PAGE_SIZE chunks too. All that will make the complicated
+ *               code more complicated.
+ *
+ * Return: 0 if success
+ */
+int user_vmap(struct genwqe_dev *cd, struct dma_mapping *m, void *uaddr,
+	      unsigned long size, struct ddcb_requ *req)
+{
+	int rc = -EINVAL;
+	unsigned long data, offs;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	if ((uaddr == NULL) || (size == 0)) {
+		m->size = 0;	/* mark unused and not added */
+		return -EINVAL;
+	}
+	m->u_vaddr = uaddr;
+	m->size    = size;
+
+	/* determine space needed for page_list. */
+	data = (unsigned long)uaddr;
+	offs = offset_in_page(data);
+	m->nr_pages = DIV_ROUND_UP(offs + size, PAGE_SIZE);
+
+	m->page_list = kcalloc(m->nr_pages,
+			       sizeof(struct page *) + sizeof(dma_addr_t),
+			       GFP_KERNEL);
+	if (!m->page_list) {
+		dev_err(&pci_dev->dev, "err: alloc page_list failed\n");
+		m->nr_pages = 0;
+		m->u_vaddr = NULL;
+		m->size = 0;	/* mark unused and not added */
+		return -ENOMEM;
+	}
+	m->dma_list = (dma_addr_t *)(m->page_list + m->nr_pages);
+
+	/* pin user pages in memory */
+	rc = get_user_pages_fast(data & PAGE_MASK, /* page aligned addr */
+				 m->nr_pages,
+				 1,		/* write by caller */
+				 m->page_list);	/* ptrs to pages */
+
+	/* assumption: get_user_pages can be killed by signals. */
+	if (rc < m->nr_pages) {
+		free_user_pages(m->page_list, rc, 0);
+		rc = -EFAULT;
+		goto fail_get_user_pages;
+	}
+
+	rc = genwqe_map_pages(cd, m->page_list, m->nr_pages, m->dma_list);
+	if (rc != 0)
+		goto fail_free_user_pages;
+
+	return 0;
+
+ fail_free_user_pages:
+	free_user_pages(m->page_list, m->nr_pages, 0);
+
+ fail_get_user_pages:
+	kfree(m->page_list);
+	m->page_list = NULL;
+	m->dma_list = NULL;
+	m->nr_pages = 0;
+	m->u_vaddr = NULL;
+	m->size = 0;		/* mark unused and not added */
+	return rc;
+}
+
+/**
+ * user_vunmap() - Undo mapping of user-space memory to virtual kernel memory
+ * @cd:         pointer to genwqe device
+ * @m:          mapping params
+ */
+int user_vunmap(struct genwqe_dev *cd, struct dma_mapping *m,
+		struct ddcb_requ *req)
+{
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	if (!dma_mapping_used(m)) {
+		dev_err(&pci_dev->dev, "[%s] err: mapping %p not used!\n",
+			__func__, m);
+		return -EINVAL;
+	}
+
+	if (m->dma_list)
+		genwqe_unmap_pages(cd, m->dma_list, m->nr_pages);
+
+	if (m->page_list) {
+		free_user_pages(m->page_list, m->nr_pages, 1);
+
+		kfree(m->page_list);
+		m->page_list = NULL;
+		m->dma_list = NULL;
+		m->nr_pages = 0;
+	}
+
+	m->u_vaddr = NULL;
+	m->size = 0;		/* mark as unused and not added */
+	return 0;
+}
+
+/**
+ * genwqe_card_type() - Get chip type SLU Configuration Register
+ * @cd:         pointer to the genwqe device descriptor
+ * Return: 0: Altera Stratix-IV 230
+ *         1: Altera Stratix-IV 530
+ *         2: Altera Stratix-V A4
+ *         3: Altera Stratix-V A7
+ */
+u8 genwqe_card_type(struct genwqe_dev *cd)
+{
+	u64 card_type = cd->slu_unitcfg;
+	return (u8)((card_type & SLU_UNITCFG_TYPE_MASK) >> 20);
+}
+
+/**
+ * genwqe_card_reset() - Reset the card
+ * @cd:         pointer to the genwqe device descriptor
+ */
+int genwqe_card_reset(struct genwqe_dev *cd)
+{
+	u64 softrst;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	if (!genwqe_is_privileged(cd))
+		return -ENODEV;
+
+	/* new SL */
+	__genwqe_writeq(cd, IO_SLC_CFGREG_SOFTRESET, 0x1ull);
+	msleep(1000);
+	__genwqe_readq(cd, IO_HSU_FIR_CLR);
+	__genwqe_readq(cd, IO_APP_FIR_CLR);
+	__genwqe_readq(cd, IO_SLU_FIR_CLR);
+
+	/*
+	 * Read-modify-write to preserve the stealth bits
+	 *
+	 * For SL >= 039, Stealth WE bit allows removing
+	 * the read-modify-wrote.
+	 * r-m-w may require a mask 0x3C to avoid hitting hard
+	 * reset again for error reset (should be 0, chicken).
+	 */
+	softrst = __genwqe_readq(cd, IO_SLC_CFGREG_SOFTRESET) & 0x3cull;
+	__genwqe_writeq(cd, IO_SLC_CFGREG_SOFTRESET, softrst | 0x2ull);
+
+	/* give ERRORRESET some time to finish */
+	msleep(50);
+
+	if (genwqe_need_err_masking(cd)) {
+		dev_info(&pci_dev->dev,
+			 "[%s] masking errors for old bitstreams\n", __func__);
+		__genwqe_writeq(cd, IO_SLC_MISC_DEBUG, 0x0aull);
+	}
+	return 0;
+}
+
+int genwqe_read_softreset(struct genwqe_dev *cd)
+{
+	u64 bitstream;
+
+	if (!genwqe_is_privileged(cd))
+		return -ENODEV;
+
+	bitstream = __genwqe_readq(cd, IO_SLU_BITSTREAM) & 0x1;
+	cd->softreset = (bitstream == 0) ? 0x8ull : 0xcull;
+	return 0;
+}
+
+/**
+ * genwqe_set_interrupt_capability() - Configure MSI capability structure
+ * @cd:         pointer to the device
+ * Return: 0 if no error
+ */
+int genwqe_set_interrupt_capability(struct genwqe_dev *cd, int count)
+{
+	int rc;
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	rc = pci_enable_msi_block(pci_dev, count);
+	if (rc == 0)
+		cd->flags |= GENWQE_FLAG_MSI_ENABLED;
+	return rc;
+}
+
+/**
+ * genwqe_reset_interrupt_capability() - Undo genwqe_set_interrupt_capability()
+ * @cd:         pointer to the device
+ */
+void genwqe_reset_interrupt_capability(struct genwqe_dev *cd)
+{
+	struct pci_dev *pci_dev = cd->pci_dev;
+
+	if (cd->flags & GENWQE_FLAG_MSI_ENABLED) {
+		pci_disable_msi(pci_dev);
+		cd->flags &= ~GENWQE_FLAG_MSI_ENABLED;
+	}
+}
+
+/**
+ * set_reg_idx() - Fill array with data. Ignore illegal offsets.
+ * @cd:         card device
+ * @r:          debug register array
+ * @i:          index to desired entry
+ * @m:          maximum possible entries
+ * @addr:       addr which is read
+ * @index:      index in debug array
+ * @val:        read value
+ */
+static int set_reg_idx(struct genwqe_dev *cd, struct genwqe_reg *r,
+		       unsigned int *i, unsigned int m, u32 addr, u32 idx,
+		       u64 val)
+{
+	if (WARN_ON_ONCE(*i >= m))
+		return -EFAULT;
+
+	r[*i].addr = addr;
+	r[*i].idx = idx;
+	r[*i].val = val;
+	++*i;
+	return 0;
+}
+
+static int set_reg(struct genwqe_dev *cd, struct genwqe_reg *r,
+		   unsigned int *i, unsigned int m, u32 addr, u64 val)
+{
+	return set_reg_idx(cd, r, i, m, addr, 0, val);
+}
+
+int genwqe_read_ffdc_regs(struct genwqe_dev *cd, struct genwqe_reg *regs,
+			 unsigned int max_regs, int all)
+{
+	unsigned int i, j, idx = 0;
+	u32 ufir_addr, ufec_addr, sfir_addr, sfec_addr;
+	u64 gfir, sluid, appid, ufir, ufec, sfir, sfec;
+
+	/* Global FIR */
+	gfir = __genwqe_readq(cd, IO_SLC_CFGREG_GFIR);
+	set_reg(cd, regs, &idx, max_regs, IO_SLC_CFGREG_GFIR, gfir);
+
+	/* UnitCfg for SLU */
+	sluid = __genwqe_readq(cd, IO_SLU_UNITCFG); /* 0x00000000 */
+	set_reg(cd, regs, &idx, max_regs, IO_SLU_UNITCFG, sluid);
+
+	/* UnitCfg for APP */
+	appid = __genwqe_readq(cd, IO_APP_UNITCFG); /* 0x02000000 */
+	set_reg(cd, regs, &idx, max_regs, IO_APP_UNITCFG, appid);
+
+	/* Check all chip Units */
+	for (i = 0; i < GENWQE_MAX_UNITS; i++) {
+
+		/* Unit FIR */
+		ufir_addr = (i << 24) | 0x008;
+		ufir = __genwqe_readq(cd, ufir_addr);
+		set_reg(cd, regs, &idx, max_regs, ufir_addr, ufir);
+
+		/* Unit FEC */
+		ufec_addr = (i << 24) | 0x018;
+		ufec = __genwqe_readq(cd, ufec_addr);
+		set_reg(cd, regs, &idx, max_regs, ufec_addr, ufec);
+
+		for (j = 0; j < 64; j++) {
+			/* wherever there is a primary 1, read the 2ndary */
+			if (!all && (!(ufir & (1ull << j))))
+				continue;
+
+			sfir_addr = (i << 24) | (0x100 + 8 * j);
+			sfir = __genwqe_readq(cd, sfir_addr);
+			set_reg(cd, regs, &idx, max_regs, sfir_addr, sfir);
+
+			sfec_addr = (i << 24) | (0x300 + 8 * j);
+			sfec = __genwqe_readq(cd, sfec_addr);
+			set_reg(cd, regs, &idx, max_regs, sfec_addr, sfec);
+		}
+	}
+
+	/* fill with invalid data until end */
+	for (i = idx; i < max_regs; i++) {
+		regs[i].addr = 0xffffffff;
+		regs[i].val = 0xffffffffffffffffull;
+	}
+	return idx;
+}
+
+/**
+ * genwqe_ffdc_buff_size() - Calculates the number of dump registers
+ */
+int genwqe_ffdc_buff_size(struct genwqe_dev *cd, int uid)
+{
+	int entries = 0, ring, traps, traces, trace_entries;
+	uint32_t eevptr_addr, l_addr, d_len, d_type;
+	uint64_t eevptr, val, addr;
+
+	eevptr_addr = UID_OFFS(uid) | IO_EXTENDED_ERROR_POINTER;
+	eevptr = __genwqe_readq(cd, eevptr_addr);
+
+	if ((eevptr != 0x0) && (eevptr != -1ull)) {
+		l_addr = UID_OFFS(uid) | eevptr;
+
+		while (1) {
+			val = __genwqe_readq(cd, l_addr);
+
+			if ((val == 0x0) || (val == -1ull))
+				break;
+
+			/* 38:24 */
+			d_len  = (val & 0x0000007fff000000ull) >> 24;
+
+			/* 39 */
+			d_type = (val & 0x0000008000000000ull) >> 36;
+
+			if (d_type) {	/* repeat */
+				entries += d_len;
+			} else {	/* size in bytes! */
+				entries += d_len >> 3;
+			}
+
+			l_addr += 8;
+		}
+	}
+
+	for (ring = 0; ring < 8; ring++) {
+		addr = UID_OFFS(uid) | IO_EXTENDED_DIAG_MAP(ring);
+		val = __genwqe_readq(cd, addr);
+
+		if ((val == 0x0ull) || (val == -1ull))
+			continue;
+
+		traps = (val >> 24) & 0xff;
+		traces = (val >> 16) & 0xff;
+		trace_entries = val & 0xffff;
+
+		entries += traps + (traces * trace_entries);
+	}
+	return entries;
+}
+
+/**
+ * genwqe_ffdc_buff_read() - Implements LogoutExtendedErrorRegisters procedure
+ */
+int genwqe_ffdc_buff_read(struct genwqe_dev *cd, int uid,
+			  struct genwqe_reg *regs, unsigned int max_regs)
+{
+	int i, traps, traces, trace, trace_entries, trace_entry, ring;
+	unsigned int idx = 0;
+	uint32_t eevptr_addr, l_addr, d_addr, d_len, d_type;
+	uint64_t eevptr, e, val, addr;
+
+	eevptr_addr = UID_OFFS(uid) | IO_EXTENDED_ERROR_POINTER;
+	eevptr = __genwqe_readq(cd, eevptr_addr);
+
+	if ((eevptr != 0x0) && (eevptr != 0xffffffffffffffffull)) {
+		l_addr = UID_OFFS(uid) | eevptr;
+		while (1) {
+			e = __genwqe_readq(cd, l_addr);
+			if ((e == 0x0) || (e == 0xffffffffffffffffull))
+				break;
+
+			d_addr = (e & 0x0000000000ffffffull);	    /* 23:0 */
+			d_len  = (e & 0x0000007fff000000ull) >> 24; /* 38:24 */
+			d_type = (e & 0x0000008000000000ull) >> 36; /* 39 */
+			d_addr |= UID_OFFS(uid);
+
+			if (d_type) {
+				for (i = 0; i < (int)d_len; i++) {
+					val = __genwqe_readq(cd, d_addr);
+					set_reg_idx(cd, regs, &idx, max_regs,
+						    d_addr, i, val);
+				}
+			} else {
+				d_len >>= 3; /* Size in bytes! */
+				for (i = 0; i < (int)d_len; i++, d_addr += 8) {
+					val = __genwqe_readq(cd, d_addr);
+					set_reg_idx(cd, regs, &idx, max_regs,
+						    d_addr, 0, val);
+				}
+			}
+			l_addr += 8;
+		}
+	}
+
+	/*
+	 * To save time, there are only 6 traces poplulated on Uid=2,
+	 * Ring=1. each with iters=512.
+	 */
+	for (ring = 0; ring < 8; ring++) { /* 0 is fls, 1 is fds,
+					      2...7 are ASI rings */
+		addr = UID_OFFS(uid) | IO_EXTENDED_DIAG_MAP(ring);
+		val = __genwqe_readq(cd, addr);
+
+		if ((val == 0x0ull) || (val == -1ull))
+			continue;
+
+		traps = (val >> 24) & 0xff;	/* Number of Traps	*/
+		traces = (val >> 16) & 0xff;	/* Number of Traces	*/
+		trace_entries = val & 0xffff;	/* Entries per trace	*/
+
+		/* Note: This is a combined loop that dumps both the traps */
+		/* (for the trace == 0 case) as well as the traces 1 to    */
+		/* 'traces'.						   */
+		for (trace = 0; trace <= traces; trace++) {
+			uint32_t diag_sel =
+				EXTENDED_DIAG_SELECTOR(ring, trace);
+
+			addr = UID_OFFS(uid) | IO_EXTENDED_DIAG_SELECTOR;
+			__genwqe_writeq(cd, addr, diag_sel);
+
+			for (trace_entry = 0;
+			     trace_entry < (trace ? trace_entries : traps);
+			     trace_entry++) {
+				addr = UID_OFFS(uid)|IO_EXTENDED_DIAG_READ_MBX;
+				val = __genwqe_readq(cd, addr);
+				set_reg_idx(cd, regs, &idx, max_regs, addr,
+					    (diag_sel<<16) | trace_entry, val);
+			}
+		}
+	}
+	return 0;
+}
+
+/**
+ * genwqe_write_jtimer() - Write jobtimeout register
+ *
+ * Sets the jobtimeout and heartbeat rate timers for this queue.
+ * Note, this register is accessible only to the PF through the
+ * VF-window. It is not intended for the VF to initialize this.
+ *
+ * It is an error to write to this register while the queue is active,
+ * i.e. when Queue Status(7:6) != 0.
+ */
+int genwqe_write_jtimer(struct genwqe_dev *cd, int func, u64 jtimer)
+{
+	__genwqe_writeq(cd, IO_PF_SLC_VIRTUAL_WINDOW, func & 0xf);
+	__genwqe_writeq(cd, IO_SLC_VF_APPJOB_TIMEOUT, jtimer);
+	return 0;
+}
+
+u64 genwqe_read_jtimer(struct genwqe_dev *cd, int func)
+{
+	u64 jtimer;
+
+	__genwqe_writeq(cd, IO_PF_SLC_VIRTUAL_WINDOW, func & 0xf);
+	jtimer = __genwqe_readq(cd, IO_SLC_VF_APPJOB_TIMEOUT);
+
+	return jtimer;
+}
+
+/**
+ * genwqe_base_clock_frequency() - Deteremine base clock frequency of the card
+ *
+ * Note: From a design perspective it turned out to be a bad idea to
+ * use codes here to specifiy the frequency/speed values. An old
+ * driver cannot understand new codes and is therefore always a
+ * problem. Better is to measure out the value or put the
+ * speed/frequency directly into a register which is always a valid
+ * value for old as well as for new software.
+ *
+ * Return: Card clock in MHz
+ */
+int genwqe_base_clock_frequency(struct genwqe_dev *cd)
+{
+	u16 speed;		/*         MHz  MHz  MHz  MHz */
+	static const int speed_grade[] = { 250, 200, 166, 175 };
+
+	speed = (u16)((cd->slu_unitcfg >> 28) & 0x0full);
+	if (speed >= ARRAY_SIZE(speed_grade))
+		return 0;	/* illegal value */
+
+	return speed_grade[speed];
+}
+
+/**
+ * genwqe_stop_traps() - Stop traps
+ *
+ * Before reading out the analysis data, we need to stop the traps.
+ */
+void genwqe_stop_traps(struct genwqe_dev *cd)
+{
+	/* Halt the traps while dumping FFDC. */
+	__genwqe_writeq(cd, IO_SLC_MISC_DEBUG_SET, 0xcull);
+}
+
+/**
+ * genwqe_start_traps() - Start traps
+ *
+ * After having read the data, we can/must enable the traps again.
+ */
+void genwqe_start_traps(struct genwqe_dev *cd)
+{
+	/* Restart the traps. */
+	__genwqe_writeq(cd, IO_SLC_MISC_DEBUG_CLR, 0xcull);
+
+	if (genwqe_need_err_masking(cd))
+		__genwqe_writeq(cd, IO_SLC_MISC_DEBUG, 0x0aull);
+}
diff --git a/drivers/misc/genwqe/genwqe_driver.h b/drivers/misc/genwqe/genwqe_driver.h
new file mode 100644
index 0000000..c8601c9
--- /dev/null
+++ b/drivers/misc/genwqe/genwqe_driver.h
@@ -0,0 +1,75 @@
+#ifndef __GENWQE_DRIVER_H__
+#define __GENWQE_DRIVER_H__
+
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
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/cdev.h>
+#include <linux/list.h>
+#include <linux/kthread.h>
+#include <linux/scatterlist.h>
+#include <linux/iommu.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <asm/byteorder.h>
+
+#include <linux/genwqe/genwqe_card.h>
+
+#define DRV_VERS_STRING		"1.1.35"
+
+/*
+ * Static minor number assignement, until we decide/implement
+ * something dynamic.
+ */
+#define GENWQE_MAX_MINOR	128 /* up to 128 possible genwqe devices */
+
+/**
+ * genwqe_requ_alloc() - Allocate a new DDCB execution request
+ *
+ * This data structure contains the user visiable fields of the DDCB
+ * to be executed.
+ *
+ * Return: ptr to genwqe_ddcb_cmd data structure
+ */
+struct genwqe_ddcb_cmd *ddcb_requ_alloc(void);
+
+/**
+ * ddcb_requ_free() - Free DDCB execution request.
+ * @req:       ptr to genwqe_ddcb_cmd data structure.
+ */
+void ddcb_requ_free(struct genwqe_ddcb_cmd *req);
+
+u32  genwqe_crc32(u8 *buff, size_t len, u32 init);
+
+static inline void genwqe_hexdump(struct pci_dev *pci_dev,
+				  const void *buff, unsigned int size)
+{
+	char prefix[32];
+
+	scnprintf(prefix, sizeof(prefix), "%s %s: ",
+		  GENWQE_DEVNAME, pci_name(pci_dev));
+	print_hex_dump(KERN_INFO, prefix,
+		       DUMP_PREFIX_OFFSET, 16, 1, buff, size, true);
+}
+
+#endif	/* __GENWQE_DRIVER_H__ */
diff --git a/include/linux/genwqe/genwqe_card.h b/include/linux/genwqe/genwqe_card.h
new file mode 100644
index 0000000..2c33db1
--- /dev/null
+++ b/include/linux/genwqe/genwqe_card.h
@@ -0,0 +1,559 @@
+#ifndef __GENWQE_CARD_H__
+#define __GENWQE_CARD_H__
+
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
+ * User-space API for the GenWQE card. For debugging and test purposes
+ * the register addresses are included here too.
+ */
+
+#ifdef __KERNEL__
+#  include <linux/types.h>
+#  include <linux/ioctl.h>
+#else
+#  include <stdint.h>
+#  include <asm/ioctl.h>
+#  include <stddef.h>
+#  include <string.h>
+#
+#  ifndef __user
+#    define __user
+#  endif
+#endif
+
+/* Basename of sysfs, debugfs and /dev interfaces */
+#if defined(CONFIG_GENWQE_DEVNAME)
+#  define GENWQE_DEVNAME CONFIG_GENWQE_DEVNAME
+#else
+#  define GENWQE_DEVNAME "genwqe"
+#endif
+
+#define GENWQE_TYPE_ALTERA_230		0x00 /* GenWQE4 Stratix-IV-230 */
+#define GENWQE_TYPE_ALTERA_530		0x01 /* GenWQE4 Stratix-IV-530 */
+#define GENWQE_TYPE_ALTERA_A4		0x02 /* GenWQE5 A4 Stratix-V-A4 */
+#define GENWQE_TYPE_ALTERA_A7		0x03 /* GenWQE5 A7 Stratix-V-A7 */
+
+/* MMIO Unit offsets: Each UnitID occupies a defined address range */
+#define UID_OFFS(uid)			((uid) << 24)
+
+#define SLU_OFFS			UID_OFFS(0)
+#define HSU_OFFS			UID_OFFS(1)
+#define APP_OFFS			UID_OFFS(2)
+#define MEMC0_OFFS			UID_OFFS(3)
+#define MEMC1_OFFS			UID_OFFS(4)
+#define ETH0_OFFS			UID_OFFS(5)
+#define ETH1_OFFS			UID_OFFS(6)
+#define GENWQE_MAX_UNITS		3
+
+/* Common offsets per UnitID */
+#define IO_EXTENDED_ERROR_POINTER	0x00000048
+#define IO_ERROR_INJECT_SELECTOR	0x00000060
+#define IO_EXTENDED_DIAG_SELECTOR	0x00000070
+#define IO_EXTENDED_DIAG_READ_MBX	0x00000078
+#define IO_EXTENDED_DIAG_MAP(ring)	(0x00000500 | ((ring) << 3))
+
+#define EXTENDED_DIAG_SELECTOR(ring, trace) (((ring) << 8) | (trace))
+
+/* UnitID 0: Service Layer Unit (SLU) */
+
+/* SLU: Unit Configuration Register */
+#define IO_SLU_UNITCFG			0x00000000
+#define   SLU_UNITCFG_TYPE_MASK		0x000000000ff00000 /* 27:20 */
+
+/* SLU: Fault Isolation Register (FIR) (ac_slu_fir) */
+#define IO_SLU_FIR			0x00000008 /* read only, wr direct */
+#define IO_SLU_FIR_CLR			0x00000010 /* read and clear */
+
+/* SLU: First Error Capture Register (FEC/WOF) */
+#define IO_SLU_FEC			0x00000018
+
+#define IO_SLU_ERR_ACT_MASK		0x00000020
+#define IO_SLU_ERR_ATTN_MASK		0x00000028
+#define IO_SLU_FIRX1_ACT_MASK		0x00000030
+#define IO_SLU_FIRX0_ACT_MASK		0x00000038
+#define IO_SLU_SEC_LEM_DEBUG_OVR	0x00000040
+#define IO_SLU_EXTENDED_ERR_PTR		0x00000048
+#define IO_SLU_COMMON_CONFIG		0x00000060
+
+/* SLU: Flash FIR */
+#define IO_SLU_FLASH_FIR		0x00000108
+
+/* SLU: SLC FIR (This section needs to be updated for A5) */
+#define IO_SLU_SLC_FIR			0x00000110
+
+/* SLU: RIU Secondary Trap Register */
+#define IO_SLU_RIU_TRAP			0x00000280
+
+/* SLU: Flash FEC */
+#define IO_SLU_FLASH_FEC		0x00000308
+
+/* SLU: SLC secondary FEC */
+#define IO_SLU_SLC_FEC			0x00000310
+
+#define W1CLR_OFFS			0x00400000
+#define W1SET_OFFS			0x00800000
+
+/*
+ * The  Virtual Function's Access is from offset 0x00010000
+ * The Physical Function's Access is from offset 0x00050000
+ * Single Shared Registers exists only at offset 0x00060000
+ */
+
+/*
+ * SLC: Queue Virtual Window Window for accessing into a specific VF
+ * queue. When accessing the 0x10000 space using the 0x50000 address
+ * segment, the value indicated here is used to specify which VF
+ * register is decoded. This register, and the 0x50000 register space
+ * can only be accessed by the PF. Example, if this register is set to
+ * 0x2, then a read from 0x50000 is the same as a read from 0x10000
+ * from VF=2.
+ */
+
+/* SLC: Queue Segment */
+#define IO_SLC_QUEUE_SEGMENT		0x00010000
+#define IO_SLC_VF_QUEUE_SEGMENT		0x00050000
+
+/* SLC: Queue Offset */
+#define IO_SLC_QUEUE_OFFSET		0x00010008
+#define IO_SLC_VF_QUEUE_OFFSET		0x00050008
+
+/* SLC: Queue Configuration */
+#define IO_SLC_QUEUE_CONFIG		0x00010010
+#define IO_SLC_VF_QUEUE_CONFIG		0x00050010
+
+/* SLC: Job Timout/Only accessible for the PF */
+#define IO_SLC_APPJOB_TIMEOUT		0x00010018
+#define IO_SLC_VF_APPJOB_TIMEOUT	0x00050018
+#define TIMEOUT_250MS			0x0000000full
+#define HEARTBEAT_DISABLE		0x0000ff00ull
+
+/* SLC: Queue InitSequence Register */
+#define	IO_SLC_QUEUE_INITSQN		0x00010020
+#define	IO_SLC_VF_QUEUE_INITSQN		0x00050020
+
+/* SLC: Queue Wrap */
+#define IO_SLC_QUEUE_WRAP		0x00010028
+#define IO_SLC_VF_QUEUE_WRAP		0x00050028
+
+/* SLC: Queue Status */
+#define IO_SLC_QUEUE_STATUS		0x00010100
+#define IO_SLC_VF_QUEUE_STATUS		0x00050100
+
+/* SLC: Queue Working Time */
+#define IO_SLC_QUEUE_WTIME		0x00010030
+#define IO_SLC_VF_QUEUE_WTIME		0x00050030
+
+/* SLC: Queue Error Counts */
+#define IO_SLC_QUEUE_ERRCNTS		0x00010038
+#define IO_SLC_VF_QUEUE_ERRCNTS		0x00050038
+
+/* SLC: Queue Loast Response Word */
+#define IO_SLC_QUEUE_LRW		0x00010040
+#define IO_SLC_VF_QUEUE_LRW		0x00050040
+
+/* SLC: Freerunning Timer */
+#define IO_SLC_FREE_RUNNING_TIMER	0x00010108
+#define IO_SLC_VF_FREE_RUNNING_TIMER	0x00050108
+
+/* SLC: Queue Virtual Access Region */
+#define IO_PF_SLC_VIRTUAL_REGION	0x00050000
+
+/* SLC: Queue Virtual Window */
+#define IO_PF_SLC_VIRTUAL_WINDOW	0x00060000
+
+/* SLC: DDCB Application Job Pending [n] (n=0:63) */
+#define IO_PF_SLC_JOBPEND(n)		(0x00061000 + 8*(n))
+#define IO_SLC_JOBPEND(n)		IO_PF_SLC_JOBPEND(n)
+
+/* SLC: Parser Trap RAM [n] (n=0:31) */
+#define IO_SLU_SLC_PARSE_TRAP(n)	(0x00011000 + 8*(n))
+
+/* SLC: Dispatcher Trap RAM [n] (n=0:31) */
+#define IO_SLU_SLC_DISP_TRAP(n)	(0x00011200 + 8*(n))
+
+/* Global Fault Isolation Register (GFIR) */
+#define IO_SLC_CFGREG_GFIR		0x00020000
+#define GFIR_ERR_TRIGGER		0x000000000000ffffull
+
+/* SLU: Soft Reset Register */
+#define IO_SLC_CFGREG_SOFTRESET		0x00020018
+
+/* SLU: Misc Debug Register */
+#define IO_SLC_MISC_DEBUG		0x00020060
+#define IO_SLC_MISC_DEBUG_CLR		0x00020068
+#define IO_SLC_MISC_DEBUG_SET		0x00020070
+
+/* Temperature Sensor Reading */
+#define IO_SLU_TEMPERATURE_SENSOR	0x00030000
+#define IO_SLU_TEMPERATURE_CONFIG	0x00030008
+
+/* Voltage Margining Control */
+#define IO_SLU_VOLTAGE_CONTROL		0x00030080
+#define VOLTAGE_NOMINAL			0x00000000ull
+#define VOLTAGE_DOWN5			0x00000006ull
+#define VOLTAGE_UP5			0x00000007ull
+
+/* Direct LED Control Register */
+#define IO_SLU_LEDCONTROL		0x00030100
+
+/* SLU: Flashbus Direct Access -A5 */
+#define IO_SLU_FLASH_DIRECTACCESS	0x00040010
+
+/* SLU: Flashbus Direct Access2 -A5 */
+#define IO_SLU_FLASH_DIRECTACCESS2	0x00040020
+
+/* SLU: Flashbus Command Interface -A5 */
+#define IO_SLU_FLASH_CMDINTF		0x00040030
+
+/* SLU: BitStream Loaded */
+#define IO_SLU_BITSTREAM		0x00040040
+
+/* This Register has a switch which will change the CAs to UR */
+#define IO_HSU_ERR_BEHAVIOR		0x01001010
+
+#define IO_SLC2_SQB_TRAP		0x00062000
+#define IO_SLC2_QUEUE_MANAGER_TRAP	0x00062008
+#define IO_SLC2_FLS_MASTER_TRAP		0x00062010
+
+/* UnitID 1: HSU Registers */
+#define IO_HSU_UNITCFG			0x01000000
+#define IO_HSU_FIR			0x01000008
+#define IO_HSU_FIR_CLR			0x01000010
+#define IO_HSU_FEC			0x01000018
+#define IO_HSU_ERR_ACT_MASK		0x01000020
+#define IO_HSU_ERR_ATTN_MASK		0x01000028
+#define IO_HSU_FIRX1_ACT_MASK		0x01000030
+#define IO_HSU_FIRX0_ACT_MASK		0x01000038
+#define IO_HSU_SEC_LEM_DEBUG_OVR	0x01000040
+#define IO_HSU_EXTENDED_ERR_PTR		0x01000048
+#define IO_HSU_COMMON_CONFIG		0x01000060
+
+/* UnitID 2: Application Unit (APP) */
+#define IO_APP_UNITCFG			0x02000000
+#define IO_APP_FIR			0x02000008
+#define IO_APP_FIR_CLR			0x02000010
+#define IO_APP_FEC			0x02000018
+#define IO_APP_ERR_ACT_MASK		0x02000020
+#define IO_APP_ERR_ATTN_MASK		0x02000028
+#define IO_APP_FIRX1_ACT_MASK		0x02000030
+#define IO_APP_FIRX0_ACT_MASK		0x02000038
+#define IO_APP_SEC_LEM_DEBUG_OVR	0x02000040
+#define IO_APP_EXTENDED_ERR_PTR		0x02000048
+#define IO_APP_COMMON_CONFIG		0x02000060
+
+#define IO_APP_DEBUG_REG_01		0x02010000
+#define IO_APP_DEBUG_REG_02		0x02010008
+#define IO_APP_DEBUG_REG_03		0x02010010
+#define IO_APP_DEBUG_REG_04		0x02010018
+#define IO_APP_DEBUG_REG_05		0x02010020
+#define IO_APP_DEBUG_REG_06		0x02010028
+#define IO_APP_DEBUG_REG_07		0x02010030
+#define IO_APP_DEBUG_REG_08		0x02010038
+#define IO_APP_DEBUG_REG_09		0x02010040
+#define IO_APP_DEBUG_REG_10		0x02010048
+#define IO_APP_DEBUG_REG_11		0x02010050
+#define IO_APP_DEBUG_REG_12		0x02010058
+#define IO_APP_DEBUG_REG_13		0x02010060
+#define IO_APP_DEBUG_REG_14		0x02010068
+#define IO_APP_DEBUG_REG_15		0x02010070
+#define IO_APP_DEBUG_REG_16		0x02010078
+#define IO_APP_DEBUG_REG_17		0x02010080
+#define IO_APP_DEBUG_REG_18		0x02010088
+
+/* Read/write from/to registers */
+struct regs_io {
+	uint32_t num;		/* register offset/address */
+	union {
+		uint64_t val64;
+		uint32_t val32;
+		uint16_t define;
+	};
+};
+
+/*
+ * All registers of our card will return values not equal this values.
+ * If we see IO_ILLEGAL_VALUE on any of our MMIO register reads, the
+ * card can be considered as unusable. It will need recovery.
+ */
+#define IO_ILLEGAL_VALUE		0xffffffffffffffffull
+
+/*
+ * Generic DDCB execution interface.
+ *
+ * This interface is a first prototype resulting from discussions we
+ * had with other teams which wanted to use the Genwqe card. It allows
+ * to issue a DDCB request in a generic way. The request will block
+ * until it finishes or time out with error.
+ *
+ * Some DDCBs require DMA addresses to be specified in the ASIV
+ * block. The interface provies the capability to let the kernel
+ * driver know where those addresses are by specifying the ATS field,
+ * such that it can replace the user-space addresses with appropriate
+ * DMA addresses or DMA addresses of a scatter gather list which is
+ * dynamically created.
+ *
+ * Our hardware will refuse DDCB execution if the ATS field is not as
+ * expected. That means the DDCB execution engine in the chip knows
+ * where it expects DMA addresses within the ASIV part of the DDCB and
+ * will check that against the ATS field definition. Any invalid or
+ * unknown ATS content will lead to DDCB refusal.
+ */
+
+/* Genwqe chip Units */
+#define DDCB_ACFUNC_SLU			0x00  /* chip service layer unit */
+#define DDCB_ACFUNC_APP			0x01  /* chip application */
+
+/* DDCB return codes (RETC) */
+#define DDCB_RETC_IDLE			0x0000 /* Unexecuted/DDCB created */
+#define DDCB_RETC_PENDING		0x0101 /* Pending Execution */
+#define DDCB_RETC_COMPLETE		0x0102 /* Cmd complete. No error */
+#define DDCB_RETC_FAULT			0x0104 /* App Err, recoverable */
+#define DDCB_RETC_ERROR			0x0108 /* App Err, non-recoverable */
+#define DDCB_RETC_FORCED_ERROR		0x01ff /* overwritten by driver  */
+
+#define DDCB_RETC_UNEXEC		0x0110 /* Unexe/Removed from queue */
+#define DDCB_RETC_TERM			0x0120 /* Terminated */
+#define DDCB_RETC_RES0			0x0140 /* Reserved */
+#define DDCB_RETC_RES1			0x0180 /* Reserved */
+
+/* DDCB Command Options (CMDOPT) */
+#define DDCB_OPT_ECHO_FORCE_NO		0x0000 /* ECHO DDCB */
+#define DDCB_OPT_ECHO_FORCE_102		0x0001 /* force return code */
+#define DDCB_OPT_ECHO_FORCE_104		0x0002
+#define DDCB_OPT_ECHO_FORCE_108		0x0003
+
+#define DDCB_OPT_ECHO_FORCE_110		0x0004 /* only on PF ! */
+#define DDCB_OPT_ECHO_FORCE_120		0x0005
+#define DDCB_OPT_ECHO_FORCE_140		0x0006
+#define DDCB_OPT_ECHO_FORCE_180		0x0007
+
+#define DDCB_OPT_ECHO_COPY_NONE		(0 << 5)
+#define DDCB_OPT_ECHO_COPY_ALL		(1 << 5)
+
+/* Definitions of Service Layer Commands */
+#define SLCMD_ECHO_SYNC			0x00 /* PF/VF */
+#define SLCMD_MOVE_FLASH		0x06 /* PF only */
+
+#define   FLASH_FLAGS_MODE		0x03 /* bit 0 and 1 used for mode */
+#define   FLASH_FLAGS_DLOAD		0	/* mode: download  */
+#define   FLASH_FLAGS_EMUL		1	/* mode: emulation */
+#define   FLASH_FLAGS_UPLOAD		2	/* mode: upload	   */
+#define   FLASH_FLAGS_VERIFY		3	/* mode: verify	   */
+#define   FLASH_FLAG_NOTAP		(1 << 2)/* just dump DDCB and exit */
+#define   FLASH_FLAG_POLL		(1 << 3)/* wait for RETC >= 0102   */
+#define   FLASH_FLAG_PARTITION		(1 << 4)
+#define   FLASH_FLAG_ERASE		(1 << 5)
+
+enum genwqe_card_state {
+	GENWQE_CARD_UNUSED = 0,
+	GENWQE_CARD_USED = 1,
+	GENWQE_CARD_FATAL_ERROR = 2,
+	GENWQE_CARD_STATE_MAX,
+};
+
+/* common struct for chip image exchange */
+struct chip_bitstream {
+	uint8_t __user *pdata;		/* pointer to image data     */
+	int	 size;			/* size of image file	     */
+	uint32_t crc;			/* crc of this image */
+	uint8_t	 partition;		/* '0', '1', or 'v' */
+	uint64_t targetaddr;		/* starting address in Flash */
+	uint8_t	 uid;			/* 1=host / x=dram  */
+
+	uint64_t slu_id;		/* informational/sim: SluID	  */
+	uint64_t app_id;		/* informational/sim: AppID	  */
+
+	uint16_t retc;			/* returned from processing */
+	uint16_t attn;			/* attention code from processing */
+	uint32_t progress;		/* progress code from processing  */
+};
+
+/* issuing a specific DDCB command */
+#define DDCB_LENGTH			256 /* for debug data */
+#define DDCB_ASIV_LENGTH		104 /* len of the DDCB ASIV array */
+#define DDCB_ASIV_LENGTH_ATS		96  /* ASIV in ATS architecture */
+#define DDCB_ASV_LENGTH			64  /* len of the DDCB ASV array  */
+#define DDCB_FIXUPS			12  /* maximum number of fixups */
+
+/*
+ * We might have addresses within the ASIV data. Those need to be
+ * replaced by valid DMA addresses to the buffer, sg-list or
+ * child-block in the kernel driver handling the request.
+ */
+#define GENWQE_DMA_TYPE_MASK		0x18  /* mask off type */
+#define GENWQE_DMA_TYPE_RAW		0x00  /* no DMA addr  */
+#define GENWQE_DMA_TYPE_FLAT		0x08  /* contignous DMA block */
+#define GENWQE_DMA_TYPE_SGLIST		0x10  /* DMA sg-list */
+#define GENWQE_DMA_TYPE_CHILD		0x18  /* DMA child-block */
+#define GENWQE_DMA_WRITEABLE		0x04  /* memory writeable? */
+
+struct genwqe_debug_data {
+	char driver_version[64];
+	uint64_t slu_unitcfg;
+	uint64_t app_unitcfg;
+
+	uint8_t	 ddcb_before[DDCB_LENGTH];
+	uint8_t	 ddcb_prev[DDCB_LENGTH];
+	uint8_t	 ddcb_finished[DDCB_LENGTH];
+};
+
+/*
+ * Address Translation Specification (ATS) definitions
+ *
+ * Each 4 bit within the ATS 64-bit word specify the required address
+ * translation at the defined offset.
+ *
+ * 63 LSB
+ *         6666.5555.5555.5544.4444.4443.3333.3333 ... 11
+ *         3210.9876.5432.1098.7654.3210.9876.5432 ... 1098.7654.3210
+ *
+ * offset: 0x00 0x08 0x10 0x18 0x20 0x28 0x30 0x38 ... 0x68 0x70 0x78
+ *         res  res  res  res  ASIV ...
+ * The first 4 entries in the ATS word are reserved. The following nibbles
+ * each describe at an 8 byte offset the format of the required data.
+ */
+#define ATS_TYPE_DATA			0x0ull /* data  */
+#define ATS_TYPE_FLAT_RD		0x4ull /* flat buffer read only */
+#define ATS_TYPE_FLAT_RDWR		0x5ull /* flat buffer read/write */
+#define ATS_TYPE_SGL_RD			0x6ull /* sgl read only */
+#define ATS_TYPE_SGL_RDWR		0x7ull /* sgl read/write */
+
+#define ATS_SET_FLAGS(_struct, _field, _flags)				\
+	(((_flags) & 0xf) << (44 - (4 * (offsetof(_struct, _field) / 8))))
+
+#define ATS_GET_FLAGS(_ats, _byte_offs)					\
+	(((_ats)	  >> (44 - (4 * ((_byte_offs) / 8)))) & 0xf)
+
+/*
+ * User parameter for generic DDCB commands. On the way into the
+ * kernel the driver will read the whole data structure. On the way
+ * out the driver will not copy the ASIV data back to userland.
+ */
+struct genwqe_ddcb_cmd {
+	/* ------ START of data copied to/from driver ---------------------- */
+	struct	 genwqe_ddcb_cmd *next;	/* chaining genwqe_ddcb_cmd */
+
+	/* XDIR might be needed one day to allow to ignore errors. But
+	   that is an interface change and should be treated with some
+	   caution. */
+	uint8_t	 acfunc;		/* accelerators functional unit */
+	uint8_t	 cmd;			/* command to execute */
+	uint16_t cmdopts;		/* command options */
+
+	uint8_t	 asiv_length;		/* used parameter length */
+	uint8_t	 asv_length;		/* length of valid return values  */
+
+	uint16_t retc;			/* return code from processing    */
+	uint16_t attn;			/* attention code from processing */
+	uint32_t progress;		/* progress code from processing  */
+
+	uint16_t vcrc;			/* variant crc16 */
+	uint64_t deque_ts;		/* dequeue time stamp */
+	uint64_t cmplt_ts;		/* completion time stamp */
+	uint64_t disp_ts;		/* SW processing start */
+
+	/* move to end and avoid copy-back */
+	struct genwqe_debug_data __user *debug_data; /* collect debug data */
+
+	/* command specific values */
+	uint8_t	 asv[DDCB_ASV_LENGTH];
+
+	/* ------ END of data copied from driver --------------------------- */
+	union {
+		struct {
+			uint64_t ats;
+			uint8_t  asiv[DDCB_ASIV_LENGTH_ATS];
+		};
+		/* used for flash update to keep it backward compatible */
+		uint8_t __asiv[DDCB_ASIV_LENGTH];
+	};
+	/* ------ END of data copied to driver ----------------------------- */
+};
+
+static inline void genwqe_ddcb_cmd_init(struct genwqe_ddcb_cmd *cmd)
+{
+	uint64_t tstamp;
+
+	tstamp = cmd->disp_ts;
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->disp_ts = tstamp;
+}
+
+#define GENWQE_IOC_CODE	      0xa5
+
+/* Access functions */
+#define GENWQE_READ_REG64     _IOR(GENWQE_IOC_CODE, 30, struct regs_io *)
+#define GENWQE_WRITE_REG64    _IOW(GENWQE_IOC_CODE, 31, struct regs_io *)
+#define GENWQE_READ_REG32     _IOR(GENWQE_IOC_CODE, 32, struct regs_io *)
+#define GENWQE_WRITE_REG32    _IOW(GENWQE_IOC_CODE, 33, struct regs_io *)
+#define GENWQE_READ_REG16     _IOR(GENWQE_IOC_CODE, 34, struct regs_io *)
+#define GENWQE_WRITE_REG16    _IOW(GENWQE_IOC_CODE, 35, struct regs_io *)
+
+#define GENWQE_GET_CARD_STATE _IOR(GENWQE_IOC_CODE, 36,		\
+				   enum genwqe_card_state *)
+
+/*
+ * Avoid pinning and unpinning of memory pages dynamically. Instead
+ * the idea is to pin the whole buffer space required for DDCB
+ * opertionas in advance. The driver will reuse this pinning and the
+ * memory associated with it to setup the sglists for the DDCB
+ * requests without the need to allocate and free memory or map and
+ * unmap to get the DMA addresses.
+ *
+ * The inverse operation needs to be called after the pinning is not
+ * needed anymore. The pinnings else the pinnings will get removed
+ * after the device is closed. Note that pinnings will required
+ * memory.
+ */
+struct genwqe_mem {
+	unsigned long addr;	/* virtual user space address */
+	unsigned long size;	/* size of the area pin/dma-map/unmap */
+	int direction;		/* 0: read/1: read and write */
+};
+
+#define GENWQE_PIN_MEM	      _IOWR(GENWQE_IOC_CODE, 40, struct genwqe_mem *)
+#define GENWQE_UNPIN_MEM      _IOWR(GENWQE_IOC_CODE, 41, struct genwqe_mem *)
+
+/*
+ * @brief Generic synchronous DDCB execution interface.
+ * Synchronously execute a DDCB.
+ *
+ * @param [in] fd        open file descriptor to the genwqe_card device.
+ * @param [inout] cmd    DDCB execution request
+ * @return               0 on success or negative error code.
+ *              -EINVAL: Invalid parameters (ASIV_LEN, ASV_LEN, illegal fixups
+ *                       no mappings found/could not create mappings.
+ *              -EFAULT: illegal addresses in fixups.
+ *                       purging failed.
+ *             -EBADMSG: enqueing failed, retc != DDCB_RETC_COMPLETE.
+ */
+#define GENWQE_EXECUTE_DDCB					\
+	_IOWR(GENWQE_IOC_CODE, 50, struct genwqe_ddcb_cmd *)
+
+#define GENWQE_EXECUTE_RAW_DDCB					\
+	_IOWR(GENWQE_IOC_CODE, 51, struct genwqe_ddcb_cmd *)
+
+/* Service Layer functions (PF only) */
+#define GENWQE_SLU_UPDATE  _IOWR(GENWQE_IOC_CODE, 80, struct chip_bistream *)
+#define GENWQE_SLU_READ	   _IOWR(GENWQE_IOC_CODE, 81, struct chip_bistream *)
+
+#endif	/* __GENWQE_CARD_H__ */
-- 
1.7.1

