Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704Ab3FRVsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:48:07 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:38205 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933376Ab3FRVsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:48:01 -0400
Date: Tue, 18 Jun 2013 23:47:13 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
        Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH V3 1/6] FMC: add core bus driver
Message-ID: <dcef7ff52b7e93efee153b81da99fab119e51d06.1371591538.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1371591538.git.rubini@gnudd.com>
In-Reply-To: <cover.1371591538.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This module offers registration services for both carriers
(i.e. devices) and mezzanines (i.e. drivers). The matching for devices
and drivers is performed according to the IPMI standard for FRU
devices (Field Replaceable Units).

The code includes support for parsing an SDB tree if present in the FPGA,
and dumping it for diagnostics. SDB is not mandatory.

Files in this commit correspond to commit ab23167f in the master branch
of the project hosted on ohwr.org.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
Acked-by: Emilio G. Cota <cota@braap.org>
Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/fmc/Makefile    |    4 +
 drivers/fmc/fmc-core.c  |  274 ++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/fmc/fmc-dump.c  |  100 +++++++++++++++++
 drivers/fmc/fmc-match.c |  114 ++++++++++++++++++++
 drivers/fmc/fmc-sdb.c   |  265 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/fmc/fru-parse.c |   82 ++++++++++++++
 6 files changed, 838 insertions(+), 1 deletions(-)
 create mode 100644 drivers/fmc/fmc-dump.c
 create mode 100644 drivers/fmc/fmc-match.c
 create mode 100644 drivers/fmc/fmc-sdb.c
 create mode 100644 drivers/fmc/fru-parse.c

diff --git a/drivers/fmc/Makefile b/drivers/fmc/Makefile
index a2784d8..df98939 100644
--- a/drivers/fmc/Makefile
+++ b/drivers/fmc/Makefile
@@ -2,3 +2,7 @@
 obj-$(CONFIG_FMC) += fmc.o
 
 fmc-y = fmc-core.o
+fmc-y += fmc-match.o
+fmc-y += fmc-sdb.o
+fmc-y += fru-parse.o
+fmc-y += fmc-dump.o
diff --git a/drivers/fmc/fmc-core.c b/drivers/fmc/fmc-core.c
index fc3547f..f4c8801 100644
--- a/drivers/fmc/fmc-core.c
+++ b/drivers/fmc/fmc-core.c
@@ -1,13 +1,285 @@
-/* Temporary placeholder so the empty code can build */
+/*
+ * Copyright (C) 2012 CERN (www.cern.ch)
+ * Author: Alessandro Rubini <rubini@gnudd.com>
+ *
+ * Released according to the GNU GPL, version 2 or any later version.
+ *
+ * This work is part of the White Rabbit project, a research effort led
+ * by CERN, the European Institute for Nuclear Research.
+ */
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/device.h>
+#include <linux/fmc.h>
+
+static int fmc_check_version(unsigned long version, const char *name)
+{
+	if (__FMC_MAJOR(version) != FMC_MAJOR) {
+		pr_err("%s: \"%s\" has wrong major (has %li, expected %i)\n",
+		       __func__, name, __FMC_MAJOR(version), FMC_MAJOR);
+		return -EINVAL;
+	}
+
+	if (__FMC_MINOR(version) != FMC_MINOR)
+		pr_info("%s: \"%s\" has wrong minor (has %li, expected %i)\n",
+		       __func__, name, __FMC_MINOR(version), FMC_MINOR);
+	return 0;
+}
+
+static int fmc_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	/* struct fmc_device *fdev = to_fmc_device(dev); */
+
+	/* FIXME: The MODALIAS */
+	add_uevent_var(env, "MODALIAS=%s", "fmc");
+	return 0;
+}
+
+static int fmc_probe(struct device *dev)
+{
+	struct fmc_driver *fdrv = to_fmc_driver(dev->driver);
+	struct fmc_device *fdev = to_fmc_device(dev);
+
+	return fdrv->probe(fdev);
+}
+
+static int fmc_remove(struct device *dev)
+{
+	struct fmc_driver *fdrv = to_fmc_driver(dev->driver);
+	struct fmc_device *fdev = to_fmc_device(dev);
+
+	return fdrv->remove(fdev);
+}
+
+static void fmc_shutdown(struct device *dev)
+{
+	/* not implemented but mandatory */
+}
 
 static struct bus_type fmc_bus_type = {
 	.name = "fmc",
+	.match = fmc_match,
+	.uevent = fmc_uevent,
+	.probe = fmc_probe,
+	.remove = fmc_remove,
+	.shutdown = fmc_shutdown,
 };
 
+static void fmc_release(struct device *dev)
+{
+	struct fmc_device *fmc = container_of(dev, struct fmc_device, dev);
+
+	kfree(fmc);
+}
+
+/*
+ * The eeprom is exported in sysfs, through a binary attribute
+ */
+
+static ssize_t fmc_read_eeprom(struct file *file, struct kobject *kobj,
+			   struct bin_attribute *bin_attr,
+			   char *buf, loff_t off, size_t count)
+{
+	struct device *dev;
+	struct fmc_device *fmc;
+	int eelen;
+
+	dev = container_of(kobj, struct device, kobj);
+	fmc = container_of(dev, struct fmc_device, dev);
+	eelen = fmc->eeprom_len;
+	if (off > eelen)
+		return -ESPIPE;
+	if (off == eelen)
+		return 0; /* EOF */
+	if (off + count > eelen)
+		count = eelen - off;
+	memcpy(buf, fmc->eeprom + off, count);
+	return count;
+}
+
+static struct bin_attribute fmc_eeprom_attr = {
+	.attr = { .name = "eeprom", .mode = S_IRUGO, },
+	.size = 8192, /* more or less standard */
+	.read = fmc_read_eeprom,
+};
+
+/*
+ * Functions for client modules follow
+ */
+
+int fmc_driver_register(struct fmc_driver *drv)
+{
+	if (fmc_check_version(drv->version, drv->driver.name))
+		return -EINVAL;
+	drv->driver.bus = &fmc_bus_type;
+	return driver_register(&drv->driver);
+}
+EXPORT_SYMBOL(fmc_driver_register);
+
+void fmc_driver_unregister(struct fmc_driver *drv)
+{
+	driver_unregister(&drv->driver);
+}
+EXPORT_SYMBOL(fmc_driver_unregister);
+
+/*
+ * When a device set is registered, all eeproms must be read
+ * and all FRUs must be parsed
+ */
+int fmc_device_register_n(struct fmc_device **devs, int n)
+{
+	struct fmc_device *fmc, **devarray;
+	uint32_t device_id;
+	int i, ret = 0;
+
+	if (n < 1)
+		return 0;
+
+	/* Check the version of the first data structure (function prints) */
+	if (fmc_check_version(devs[0]->version, devs[0]->carrier_name))
+		return -EINVAL;
+
+	devarray = kmemdup(devs, n * sizeof(*devs), GFP_KERNEL);
+	if (!devarray)
+		return -ENOMEM;
+
+	/* Make all other checks before continuing, for all devices */
+	for (i = 0; i < n; i++) {
+		fmc = devarray[i];
+		if (!fmc->hwdev) {
+			pr_err("%s: device nr. %i has no hwdev pointer\n",
+			       __func__, i);
+			ret = -EINVAL;
+			break;
+		}
+		if (fmc->flags == FMC_DEVICE_NO_MEZZANINE) {
+			dev_info(fmc->hwdev, "absent mezzanine in slot %d\n",
+				 fmc->slot_id);
+			continue;
+		}
+		if (!fmc->eeprom) {
+			dev_err(fmc->hwdev, "no eeprom provided for slot %i\n",
+				fmc->slot_id);
+			ret = -EINVAL;
+		}
+		if (!fmc->eeprom_addr) {
+			dev_err(fmc->hwdev, "no eeprom_addr for slot %i\n",
+				fmc->slot_id);
+			ret = -EINVAL;
+		}
+		if (!fmc->carrier_name || !fmc->carrier_data || \
+		    !fmc->device_id) {
+			dev_err(fmc->hwdev,
+				"deivce nr %i: carrier name, "
+				"data or dev_id not set\n", i);
+			ret = -EINVAL;
+		}
+		if (ret)
+			break;
+
+	}
+	if (ret) {
+		kfree(devarray);
+		return ret;
+	}
+
+	/* Validation is ok. Now init and register the devices */
+	for (i = 0; i < n; i++) {
+		fmc = devarray[i];
+
+		if (fmc->flags == FMC_DEVICE_NO_MEZZANINE)
+			continue; /* dev_info already done above */
+
+		fmc->nr_slots = n; /* each slot must know how many are there */
+		fmc->devarray = devarray;
+
+		device_initialize(&fmc->dev);
+		fmc->dev.release = fmc_release;
+		fmc->dev.parent = fmc->hwdev;
+
+		/* Fill the identification stuff (may fail) */
+		fmc_fill_id_info(fmc);
+
+		fmc->dev.bus = &fmc_bus_type;
+
+		/* Name from mezzanine info or carrier info. Or 0,1,2.. */
+		device_id = fmc->device_id;
+		if (!fmc->mezzanine_name)
+			dev_set_name(&fmc->dev, "fmc-%04x", device_id);
+		else
+			dev_set_name(&fmc->dev, "%s-%04x", fmc->mezzanine_name,
+				     device_id);
+		ret = device_add(&fmc->dev);
+		if (ret < 0) {
+			dev_err(fmc->hwdev, "Slot %i: Failed in registering "
+				"\"%s\"\n", fmc->slot_id, fmc->dev.kobj.name);
+			goto out;
+		}
+		ret = sysfs_create_bin_file(&fmc->dev.kobj, &fmc_eeprom_attr);
+		if (ret < 0) {
+			dev_err(&fmc->dev, "Failed in registering eeprom\n");
+			goto out1;
+		}
+		/* This device went well, give information to the user */
+		fmc_dump_eeprom(fmc);
+		fmc_dump_sdb(fmc);
+	}
+	return 0;
+
+out1:
+	device_del(&fmc->dev);
+out:
+	fmc_free_id_info(fmc);
+	put_device(&fmc->dev);
+
+	kfree(devarray);
+	for (i--; i >= 0; i--) {
+		sysfs_remove_bin_file(&devs[i]->dev.kobj, &fmc_eeprom_attr);
+		device_del(&devs[i]->dev);
+		fmc_free_id_info(devs[i]);
+		put_device(&devs[i]->dev);
+	}
+	return ret;
+
+}
+EXPORT_SYMBOL(fmc_device_register_n);
+
+int fmc_device_register(struct fmc_device *fmc)
+{
+	return fmc_device_register_n(&fmc, 1);
+}
+EXPORT_SYMBOL(fmc_device_register);
+
+void fmc_device_unregister_n(struct fmc_device **devs, int n)
+{
+	int i;
+
+	if (n < 1)
+		return;
+
+	/* Free devarray first, not used by the later loop */
+	kfree(devs[0]->devarray);
+
+	for (i = 0; i < n; i++) {
+		if (devs[i]->flags == FMC_DEVICE_NO_MEZZANINE)
+			continue;
+		sysfs_remove_bin_file(&devs[i]->dev.kobj, &fmc_eeprom_attr);
+		device_del(&devs[i]->dev);
+		fmc_free_id_info(devs[i]);
+		put_device(&devs[i]->dev);
+	}
+}
+EXPORT_SYMBOL(fmc_device_unregister_n);
+
+void fmc_device_unregister(struct fmc_device *fmc)
+{
+	fmc_device_unregister_n(&fmc, 1);
+}
+EXPORT_SYMBOL(fmc_device_unregister);
+
+/* Init and exit are trivial */
 static int fmc_init(void)
 {
 	return bus_register(&fmc_bus_type);
diff --git a/drivers/fmc/fmc-dump.c b/drivers/fmc/fmc-dump.c
new file mode 100644
index 0000000..c91afd6
--- /dev/null
+++ b/drivers/fmc/fmc-dump.c
@@ -0,0 +1,100 @@
+/*
+ * Copyright (C) 2013 CERN (www.cern.ch)
+ * Author: Alessandro Rubini <rubini@gnudd.com>
+ *
+ * Released according to the GNU GPL, version 2 or any later version.
+ *
+ * This work is part of the White Rabbit project, a research effort led
+ * by CERN, the European Institute for Nuclear Research.
+ */
+#include <linux/kernel.h>
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+#include <linux/fmc.h>
+#include <linux/fmc-sdb.h>
+
+static int fmc_must_dump_eeprom;
+module_param_named(dump_eeprom, fmc_must_dump_eeprom, int, 0644);
+static int fmc_must_dump_sdb;
+module_param_named(dump_sdb, fmc_must_dump_sdb, int, 0644);
+
+#define LINELEN 16
+
+/* Dumping 8k takes oh so much: avoid duplicate lines */
+static const uint8_t *dump_line(int addr, const uint8_t *line,
+				const uint8_t *prev)
+{
+	int i;
+
+	if (!prev || memcmp(line, prev, LINELEN)) {
+		pr_info("%04x: ", addr);
+		for (i = 0; i < LINELEN; ) {
+			printk(KERN_CONT "%02x", line[i]);
+			i++;
+			printk(i & 3 ? " " : i & (LINELEN - 1) ? "  " : "\n");
+		}
+		return line;
+	}
+	/* repeated line */
+	if (line == prev + LINELEN)
+		pr_info("[...]\n");
+	return prev;
+}
+
+void fmc_dump_eeprom(const struct fmc_device *fmc)
+{
+	const uint8_t *line, *prev;
+	int i;
+
+	if (!fmc_must_dump_eeprom)
+		return;
+
+	pr_info("FMC: %s (%s), slot %i, device %s\n", dev_name(fmc->hwdev),
+		fmc->carrier_name, fmc->slot_id, dev_name(&fmc->dev));
+	pr_info("FMC: dumping eeprom 0x%x (%i) bytes\n", fmc->eeprom_len,
+	       fmc->eeprom_len);
+
+	line = fmc->eeprom;
+	prev = NULL;
+	for (i = 0; i < fmc->eeprom_len; i += LINELEN, line += LINELEN)
+		prev = dump_line(i, line, prev);
+}
+
+void fmc_dump_sdb(const struct fmc_device *fmc)
+{
+	const uint8_t *line, *prev;
+	int i, len;
+
+	if (!fmc->sdb)
+		return;
+	if (!fmc_must_dump_sdb)
+		return;
+
+	/* If the argument is not-zero, do simple dump (== show) */
+	if (fmc_must_dump_sdb > 0)
+		fmc_show_sdb_tree(fmc);
+
+	if (fmc_must_dump_sdb == 1)
+		return;
+
+	/* If bigger than 1, dump it seriously, to help debugging */
+
+	/*
+	 * Here we should really use libsdbfs (which is designed to
+	 * work in kernel space as well) , but it doesn't support
+	 * directories yet, and it requires better intergration (it
+	 * should be used instead of fmc-specific code).
+	 *
+	 * So, lazily, just dump the top-level array
+	 */
+	pr_info("FMC: %s (%s), slot %i, device %s\n", dev_name(fmc->hwdev),
+		fmc->carrier_name, fmc->slot_id, dev_name(&fmc->dev));
+	pr_info("FMC: poor dump of sdb first level:\n");
+
+	len = fmc->sdb->len * sizeof(union sdb_record);
+	line = (void *)fmc->sdb->record;
+	prev = NULL;
+	for (i = 0; i < len; i += LINELEN, line += LINELEN)
+		prev = dump_line(i, line, prev);
+	return;
+}
diff --git a/drivers/fmc/fmc-match.c b/drivers/fmc/fmc-match.c
new file mode 100644
index 0000000..104a5ef
--- /dev/null
+++ b/drivers/fmc/fmc-match.c
@@ -0,0 +1,114 @@
+/*
+ * Copyright (C) 2012 CERN (www.cern.ch)
+ * Author: Alessandro Rubini <rubini@gnudd.com>
+ *
+ * Released according to the GNU GPL, version 2 or any later version.
+ *
+ * This work is part of the White Rabbit project, a research effort led
+ * by CERN, the European Institute for Nuclear Research.
+ */
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/fmc.h>
+#include <linux/ipmi-fru.h>
+
+/* The fru parser is both user and kernel capable: it needs alloc */
+void *fru_alloc(size_t size)
+{
+	return kzalloc(size, GFP_KERNEL);
+}
+
+/* The actual match function */
+int fmc_match(struct device *dev, struct device_driver *drv)
+{
+	struct fmc_driver *fdrv = to_fmc_driver(drv);
+	struct fmc_device *fdev = to_fmc_device(dev);
+	struct fmc_fru_id *fid;
+	int i, matched = 0;
+
+	/* This currently only matches the EEPROM (FRU id) */
+	fid = fdrv->id_table.fru_id;
+	if (!fid) {
+		dev_warn(&fdev->dev, "Driver has no ID: matches all\n");
+		matched = 1;
+	} else {
+		if (!fdev->id.manufacturer || !fdev->id.product_name)
+			return 0; /* the device has no FRU information */
+		for (i = 0; i < fdrv->id_table.fru_id_nr; i++, fid++) {
+			if (fid->manufacturer &&
+			    strcmp(fid->manufacturer, fdev->id.manufacturer))
+				continue;
+			if (fid->product_name &&
+			    strcmp(fid->product_name, fdev->id.product_name))
+				continue;
+			matched = 1;
+			break;
+		}
+	}
+
+	/* FIXME: match SDB contents */
+	return matched;
+}
+
+/* This function creates ID info for a newly registered device */
+int fmc_fill_id_info(struct fmc_device *fmc)
+{
+	struct fru_common_header *h;
+	struct fru_board_info_area *bia;
+	int ret, allocated = 0;
+
+	/* If we know the eeprom length, try to read it off the device */
+	if (fmc->eeprom_len && !fmc->eeprom) {
+		fmc->eeprom = kzalloc(fmc->eeprom_len, GFP_KERNEL);
+		if (!fmc->eeprom)
+			return -ENOMEM;
+		allocated = 1;
+		ret = fmc->op->read_ee(fmc, 0, fmc->eeprom, fmc->eeprom_len);
+		if (ret < 0)
+			goto out;
+	}
+
+	/* If no eeprom, continue with other matches */
+	if (!fmc->eeprom)
+		return 0;
+
+	dev_info(fmc->hwdev, "mezzanine %i\n", fmc->slot_id); /* header */
+
+	/* So we have the eeprom: parse the FRU part (if any) */
+	h = (void *)fmc->eeprom;
+	if (h->format != 1) {
+		pr_info("      EEPROM has no FRU information\n");
+		goto out;
+	}
+	if (!fru_header_cksum_ok(h)) {
+		pr_info("      FRU: wrong header checksum\n");
+		goto out;
+	}
+	bia = fru_get_board_area(h);
+	if (!fru_bia_cksum_ok(bia)) {
+		pr_info("      FRU: wrong board area checksum\n");
+		goto out;
+	}
+	fmc->id.manufacturer = fru_get_board_manufacturer(h);
+	fmc->id.product_name = fru_get_product_name(h);
+	pr_info("      Manufacturer: %s\n", fmc->id.manufacturer);
+	pr_info("      Product name: %s\n", fmc->id.product_name);
+
+	/* Create the short name (FIXME: look in sdb as well) */
+	fmc->mezzanine_name = kstrdup(fmc->id.product_name, GFP_KERNEL);
+
+out:
+	if (allocated) {
+		kfree(fmc->eeprom);
+		fmc->eeprom = NULL;
+	}
+	return 0; /* no error: let other identification work */
+}
+
+/* Some ID data is allocated using fru_alloc() above, so release it */
+void fmc_free_id_info(struct fmc_device *fmc)
+{
+	kfree(fmc->mezzanine_name);
+	kfree(fmc->id.manufacturer);
+	kfree(fmc->id.product_name);
+}
diff --git a/drivers/fmc/fmc-sdb.c b/drivers/fmc/fmc-sdb.c
new file mode 100644
index 0000000..74fb326
--- /dev/null
+++ b/drivers/fmc/fmc-sdb.c
@@ -0,0 +1,265 @@
+/*
+ * Copyright (C) 2012 CERN (www.cern.ch)
+ * Author: Alessandro Rubini <rubini@gnudd.com>
+ *
+ * Released according to the GNU GPL, version 2 or any later version.
+ *
+ * This work is part of the White Rabbit project, a research effort led
+ * by CERN, the European Institute for Nuclear Research.
+ */
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/fmc.h>
+#include <linux/sdb.h>
+#include <linux/err.h>
+#include <linux/fmc-sdb.h>
+#include <asm/byteorder.h>
+
+static uint32_t __sdb_rd(struct fmc_device *fmc, unsigned long address,
+			int convert)
+{
+	uint32_t res = fmc_readl(fmc, address);
+	if (convert)
+		return __be32_to_cpu(res);
+	return res;
+}
+
+static struct sdb_array *__fmc_scan_sdb_tree(struct fmc_device *fmc,
+					     unsigned long sdb_addr,
+					     unsigned long reg_base, int level)
+{
+	uint32_t onew;
+	int i, j, n, convert = 0;
+	struct sdb_array *arr, *sub;
+
+	onew = fmc_readl(fmc, sdb_addr);
+	if (onew == SDB_MAGIC) {
+		/* Uh! If we are little-endian, we must convert */
+		if (SDB_MAGIC != __be32_to_cpu(SDB_MAGIC))
+			convert = 1;
+	} else if (onew == __be32_to_cpu(SDB_MAGIC)) {
+		/* ok, don't convert */
+	} else {
+		return ERR_PTR(-ENOENT);
+	}
+	/* So, the magic was there: get the count from offset 4*/
+	onew = __sdb_rd(fmc, sdb_addr + 4, convert);
+	n = __be16_to_cpu(*(uint16_t *)&onew);
+	arr = kzalloc(sizeof(*arr), GFP_KERNEL);
+	if (arr) {
+		arr->record = kzalloc(sizeof(arr->record[0]) * n, GFP_KERNEL);
+		arr->subtree = kzalloc(sizeof(arr->subtree[0]) * n, GFP_KERNEL);
+	}
+	if (!arr || !arr->record || !arr->subtree) {
+		kfree(arr->record);
+		kfree(arr->subtree);
+		kfree(arr);
+		return ERR_PTR(-ENOMEM);
+	}
+	arr->len = n;
+	arr->level = level;
+	arr->fmc = fmc;
+	for (i = 0; i < n; i++) {
+		union  sdb_record *r;
+
+		for (j = 0; j < sizeof(arr->record[0]); j += 4) {
+			*(uint32_t *)((void *)(arr->record + i) + j) =
+				__sdb_rd(fmc, sdb_addr + (i * 64) + j, convert);
+		}
+		r = &arr->record[i];
+		arr->subtree[i] = ERR_PTR(-ENODEV);
+		if (r->empty.record_type == sdb_type_bridge) {
+			struct sdb_component *c = &r->bridge.sdb_component;
+			uint64_t subaddr = __be64_to_cpu(r->bridge.sdb_child);
+			uint64_t newbase = __be64_to_cpu(c->addr_first);
+
+			subaddr += reg_base;
+			newbase += reg_base;
+			sub = __fmc_scan_sdb_tree(fmc, subaddr, newbase,
+						  level + 1);
+			arr->subtree[i] = sub; /* may be error */
+			if (IS_ERR(sub))
+				continue;
+			sub->parent = arr;
+			sub->baseaddr = newbase;
+		}
+	}
+	return arr;
+}
+
+int fmc_scan_sdb_tree(struct fmc_device *fmc, unsigned long address)
+{
+	struct sdb_array *ret;
+	if (fmc->sdb)
+		return -EBUSY;
+	ret = __fmc_scan_sdb_tree(fmc, address, 0 /* regs */, 0);
+	if (IS_ERR(ret))
+		return PTR_ERR(ret);
+	fmc->sdb = ret;
+	return 0;
+}
+EXPORT_SYMBOL(fmc_scan_sdb_tree);
+
+static void __fmc_sdb_free(struct sdb_array *arr)
+{
+	int i, n;
+
+	if (!arr)
+		return;
+	n = arr->len;
+	for (i = 0; i < n; i++) {
+		if (IS_ERR(arr->subtree[i]))
+			continue;
+		__fmc_sdb_free(arr->subtree[i]);
+	}
+	kfree(arr->record);
+	kfree(arr->subtree);
+	kfree(arr);
+}
+
+int fmc_free_sdb_tree(struct fmc_device *fmc)
+{
+	__fmc_sdb_free(fmc->sdb);
+	fmc->sdb = NULL;
+	return 0;
+}
+EXPORT_SYMBOL(fmc_free_sdb_tree);
+
+/* This helper calls reprogram and inizialized sdb as well */
+int fmc_reprogram(struct fmc_device *fmc, struct fmc_driver *d, char *gw,
+			 int sdb_entry)
+{
+	int ret;
+
+	ret = fmc->op->reprogram(fmc, d, gw);
+	if (ret < 0)
+		return ret;
+	if (sdb_entry < 0)
+		return ret;
+
+	/* We are required to find SDB at a given offset */
+	ret = fmc_scan_sdb_tree(fmc, sdb_entry);
+	if (ret < 0) {
+		dev_err(&fmc->dev, "Can't find SDB at address 0x%x\n",
+			sdb_entry);
+		return -ENODEV;
+	}
+	fmc_dump_sdb(fmc);
+	return 0;
+}
+EXPORT_SYMBOL(fmc_reprogram);
+
+static void __fmc_show_sdb_tree(const struct fmc_device *fmc,
+				const struct sdb_array *arr)
+{
+	int i, j, n = arr->len, level = arr->level;
+	const struct sdb_array *ap;
+
+	for (i = 0; i < n; i++) {
+		unsigned long base;
+		union  sdb_record *r;
+		struct sdb_product *p;
+		struct sdb_component *c;
+		r = &arr->record[i];
+		c = &r->dev.sdb_component;
+		p = &c->product;
+		base = 0;
+		for (ap = arr; ap; ap = ap->parent)
+			base += ap->baseaddr;
+		dev_info(&fmc->dev, "SDB: ");
+
+		for (j = 0; j < level; j++)
+			printk(KERN_CONT "   ");
+		switch (r->empty.record_type) {
+		case sdb_type_interconnect:
+			printk(KERN_CONT "%08llx:%08x %.19s\n",
+			       __be64_to_cpu(p->vendor_id),
+			       __be32_to_cpu(p->device_id),
+			       p->name);
+			break;
+		case sdb_type_device:
+			printk(KERN_CONT "%08llx:%08x %.19s (%08llx-%08llx)\n",
+			       __be64_to_cpu(p->vendor_id),
+			       __be32_to_cpu(p->device_id),
+			       p->name,
+			       __be64_to_cpu(c->addr_first) + base,
+			       __be64_to_cpu(c->addr_last) + base);
+			break;
+		case sdb_type_bridge:
+			printk(KERN_CONT "%08llx:%08x %.19s (bridge: %08llx)\n",
+			       __be64_to_cpu(p->vendor_id),
+			       __be32_to_cpu(p->device_id),
+			       p->name,
+			       __be64_to_cpu(c->addr_first) + base);
+			if (IS_ERR(arr->subtree[i])) {
+				printk(KERN_CONT "(bridge error %li)\n",
+				       PTR_ERR(arr->subtree[i]));
+				break;
+			}
+			__fmc_show_sdb_tree(fmc, arr->subtree[i]);
+			break;
+		case sdb_type_integration:
+			printk(KERN_CONT "integration\n");
+			break;
+		case sdb_type_repo_url:
+			printk(KERN_CONT "repo-url\n");
+			break;
+		case sdb_type_synthesis:
+			printk(KERN_CONT "synthesis-info\n");
+			break;
+		case sdb_type_empty:
+			printk(KERN_CONT "empty\n");
+			break;
+		default:
+			printk(KERN_CONT "UNKNOWN TYPE 0x%02x\n",
+			       r->empty.record_type);
+			break;
+		}
+	}
+}
+
+void fmc_show_sdb_tree(const struct fmc_device *fmc)
+{
+	if (!fmc->sdb)
+		return;
+	__fmc_show_sdb_tree(fmc, fmc->sdb);
+}
+EXPORT_SYMBOL(fmc_show_sdb_tree);
+
+signed long fmc_find_sdb_device(struct sdb_array *tree,
+				uint64_t vid, uint32_t did, unsigned long *sz)
+{
+	signed long res = -ENODEV;
+	union  sdb_record *r;
+	struct sdb_product *p;
+	struct sdb_component *c;
+	int i, n = tree->len;
+	uint64_t last, first;
+
+	/* FIXME: what if the first interconnect is not at zero? */
+	for (i = 0; i < n; i++) {
+		r = &tree->record[i];
+		c = &r->dev.sdb_component;
+		p = &c->product;
+
+		if (!IS_ERR(tree->subtree[i]))
+			res = fmc_find_sdb_device(tree->subtree[i],
+						  vid, did, sz);
+		if (res >= 0)
+			return res + tree->baseaddr;
+		if (r->empty.record_type != sdb_type_device)
+			continue;
+		if (__be64_to_cpu(p->vendor_id) != vid)
+			continue;
+		if (__be32_to_cpu(p->device_id) != did)
+			continue;
+		/* found */
+		last = __be64_to_cpu(c->addr_last);
+		first = __be64_to_cpu(c->addr_first);
+		if (sz)
+			*sz = (typeof(*sz))(last + 1 - first);
+		return first + tree->baseaddr;
+	}
+	return res;
+}
+EXPORT_SYMBOL(fmc_find_sdb_device);
diff --git a/drivers/fmc/fru-parse.c b/drivers/fmc/fru-parse.c
new file mode 100644
index 0000000..cb46263
--- /dev/null
+++ b/drivers/fmc/fru-parse.c
@@ -0,0 +1,82 @@
+/*
+ * Copyright (C) 2012 CERN (www.cern.ch)
+ * Author: Alessandro Rubini <rubini@gnudd.com>
+ *
+ * Released according to the GNU GPL, version 2 or any later version.
+ *
+ * This work is part of the White Rabbit project, a research effort led
+ * by CERN, the European Institute for Nuclear Research.
+ */
+#include <linux/ipmi-fru.h>
+
+/* Some internal helpers */
+static struct fru_type_length *
+__fru_get_board_tl(struct fru_common_header *header, int nr)
+{
+	struct fru_board_info_area *bia;
+	struct fru_type_length *tl;
+
+	bia = fru_get_board_area(header);
+	tl = bia->tl;
+	while (nr > 0 && !fru_is_eof(tl)) {
+		tl = fru_next_tl(tl);
+		nr--;
+	}
+	if (fru_is_eof(tl))
+		return NULL;
+	return tl;
+}
+
+static char *__fru_alloc_get_tl(struct fru_common_header *header, int nr)
+{
+	struct fru_type_length *tl;
+	char *res;
+	int len;
+
+	tl = __fru_get_board_tl(header, nr);
+	if (!tl)
+		return NULL;
+	len = fru_strlen(tl);
+	res = fru_alloc(fru_strlen(tl) + 1);
+	if (!res)
+		return NULL;
+	return fru_strcpy(res, tl);
+}
+
+/* Public checksum verifiers */
+int fru_header_cksum_ok(struct fru_common_header *header)
+{
+	uint8_t *ptr = (void *)header;
+	int i, sum;
+
+	for (i = sum = 0; i < sizeof(*header); i++)
+		sum += ptr[i];
+	return (sum & 0xff) == 0;
+}
+int fru_bia_cksum_ok(struct fru_board_info_area *bia)
+{
+	uint8_t *ptr = (void *)bia;
+	int i, sum;
+
+	for (i = sum = 0; i < 8 * bia->area_len; i++)
+		sum += ptr[i];
+	return (sum & 0xff) == 0;
+}
+
+/* Get various stuff, trivial */
+char *fru_get_board_manufacturer(struct fru_common_header *header)
+{
+	return __fru_alloc_get_tl(header, 0);
+}
+char *fru_get_product_name(struct fru_common_header *header)
+{
+	return __fru_alloc_get_tl(header, 1);
+}
+char *fru_get_serial_number(struct fru_common_header *header)
+{
+	return __fru_alloc_get_tl(header, 2);
+}
+char *fru_get_part_number(struct fru_common_header *header)
+{
+	return __fru_alloc_get_tl(header, 3);
+}
-- 
1.7.7.2
