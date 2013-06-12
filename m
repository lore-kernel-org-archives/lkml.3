Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab3FLHOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:14:30 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:48473 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab3FLHO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:14:27 -0400
Date: Wed, 12 Jun 2013 09:13:36 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        gregkh@linuxfoundation.org, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Subject: [PATCH 2/8] FMC: add needed headers
Message-ID: <1d3aedf8636f4bed4ffda25e13acd853bf8e08fb.1371018406.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1371018406.git.rubini@gnudd.com>
In-Reply-To: <cover.1371018406.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of headers comes from commit ab23167f (current master of the
project on ohwr.org). They define the basic data structures for FMC
and its SDB support.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
Acked-by: Emilio G. Cota <cota@braap.org>
Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 include/linux/fmc-sdb.h  |   36 +++++++
 include/linux/fmc.h      |  237 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/ipmi-fru.h |  135 ++++++++++++++++++++++++++
 include/linux/sdb.h      |  159 +++++++++++++++++++++++++++++++
 4 files changed, 567 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/fmc-sdb.h
 create mode 100644 include/linux/fmc.h
 create mode 100644 include/linux/ipmi-fru.h
 create mode 100644 include/linux/sdb.h

diff --git a/include/linux/fmc-sdb.h b/include/linux/fmc-sdb.h
new file mode 100644
index 0000000..1974317
--- /dev/null
+++ b/include/linux/fmc-sdb.h
@@ -0,0 +1,36 @@
+/*
+ * This file is separate from sdb.h, because I want that one to remain
+ * unchanged (as far as possible) from the official sdb distribution
+ *
+ * This file and associated functionality are a playground for me to
+ * understand stuff which will later be implemented in more generic places.
+ */
+#include <linux/sdb.h>
+
+/* This is the union of all currently defined types */
+union sdb_record {
+	struct sdb_interconnect ic;
+	struct sdb_device dev;
+	struct sdb_bridge bridge;
+	struct sdb_integration integr;
+	struct sdb_empty empty;
+};
+
+struct fmc_device;
+
+/* Every sdb table is turned into this structure */
+struct sdb_array {
+	int len;
+	int level;
+	unsigned long baseaddr;
+	struct fmc_device *fmc;		/* the device that hosts it */
+	struct sdb_array *parent;	/* NULL at root */
+	union sdb_record *record;	/* copies of the struct */
+	struct sdb_array **subtree;	/* only valid for bridge items */
+};
+
+extern int fmc_scan_sdb_tree(struct fmc_device *fmc, unsigned long address);
+extern void fmc_show_sdb_tree(const struct fmc_device *fmc);
+extern signed long fmc_find_sdb_device(struct sdb_array *tree, uint64_t vendor,
+				       uint32_t device, unsigned long *sz);
+extern int fmc_free_sdb_tree(struct fmc_device *fmc);
diff --git a/include/linux/fmc.h b/include/linux/fmc.h
new file mode 100644
index 0000000..a3c4985
--- /dev/null
+++ b/include/linux/fmc.h
@@ -0,0 +1,237 @@
+/*
+ * Copyright (C) 2012 CERN (www.cern.ch)
+ * Author: Alessandro Rubini <rubini@gnudd.com>
+ *
+ * Released according to the GNU GPL, version 2 or any later version.
+ *
+ * This work is part of the White Rabbit project, a research effort led
+ * by CERN, the European Institute for Nuclear Research.
+ */
+#ifndef __LINUX_FMC_H__
+#define __LINUX_FMC_H__
+#include <linux/types.h>
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+
+struct fmc_device;
+struct fmc_driver;
+
+/*
+ * This bus abstraction is developed separately from drivers, so we need
+ * to check the version of the data structures we receive.
+ */
+
+#define FMC_MAJOR	3
+#define FMC_MINOR	0
+#define FMC_VERSION	((FMC_MAJOR << 16) | FMC_MINOR)
+#define __FMC_MAJOR(x)	((x) >> 16)
+#define __FMC_MINOR(x)	((x) & 0xffff)
+
+/*
+ * The device identification, as defined by the IPMI FRU (Field Replaceable
+ * Unit) includes four different strings to describe the device. Here we
+ * only match the "Board Manufacturer" and the "Board Product Name",
+ * ignoring the "Board Serial Number" and "Board Part Number". All 4 are
+ * expected to be strings, so they are treated as zero-terminated C strings.
+ * Unspecified string (NULL) means "any", so if both are unspecified this
+ * is a catch-all driver. So null entries are allowed and we use array
+ * and length. This is unlike pci and usb that use null-terminated arrays
+ */
+struct fmc_fru_id {
+	char *manufacturer;
+	char *product_name;
+};
+
+/*
+ * If the FPGA is already programmed (think Etherbone or the second
+ * SVEC slot), we can match on SDB devices in the memory image. This
+ * match uses an array of devices that must all be present, and the
+ * match is based on vendor and device only. Further checks are expected
+ * to happen in the probe function. Zero means "any" and catch-all is allowed.
+ */
+struct fmc_sdb_one_id {
+	uint64_t vendor;
+	uint32_t device;
+};
+struct fmc_sdb_id {
+	struct fmc_sdb_one_id *cores;
+	int cores_nr;
+};
+
+struct fmc_device_id {
+	struct fmc_fru_id *fru_id;
+	int fru_id_nr;
+	struct fmc_sdb_id *sdb_id;
+	int sdb_id_nr;
+};
+
+/* This sizes the module_param_array used by generic module parameters */
+#define FMC_MAX_CARDS 32
+
+/* The driver is a pretty simple thing */
+struct fmc_driver {
+	unsigned long version;
+	struct device_driver driver;
+	int (*probe)(struct fmc_device *);
+	int (*remove)(struct fmc_device *);
+	const struct fmc_device_id id_table;
+	/* What follows is for generic module parameters */
+	int busid_n;
+	int busid_val[FMC_MAX_CARDS];
+	int gw_n;
+	char *gw_val[FMC_MAX_CARDS];
+};
+#define to_fmc_driver(x) container_of((x), struct fmc_driver, driver)
+
+/* These are the generic parameters, that drivers may instantiate */
+#define FMC_PARAM_BUSID(_d) \
+    module_param_array_named(busid, _d.busid_val, int, &_d.busid_n, 0444)
+#define FMC_PARAM_GATEWARE(_d) \
+    module_param_array_named(gateware, _d.gw_val, charp, &_d.gw_n, 0444)
+
+/*
+ * Drivers may need to configure gpio pins in the carrier. To read input
+ * (a very uncommon operation, and definitely not in the hot paths), just
+ * configure one gpio only and get 0 or 1 as retval of the config method
+ */
+struct fmc_gpio {
+	char *carrier_name; /* name or NULL for virtual pins */
+	int gpio;
+	int _gpio;	/* internal use by the carrier */
+	int mode;	/* GPIOF_DIR_OUT etc, from <linux/gpio.h> */
+	int irqmode;	/* IRQF_TRIGGER_LOW and so on */
+};
+
+/* The numbering of gpio pins allows access to raw pins or virtual roles */
+#define FMC_GPIO_RAW(x)		(x)		/* 4096 of them */
+#define __FMC_GPIO_IS_RAW(x)	((x) < 0x1000)
+#define FMC_GPIO_IRQ(x)		((x) + 0x1000)	/*  256 of them */
+#define FMC_GPIO_LED(x)		((x) + 0x1100)	/*  256 of them */
+#define FMC_GPIO_KEY(x)		((x) + 0x1200)	/*  256 of them */
+#define FMC_GPIO_TP(x)		((x) + 0x1300)	/*  256 of them */
+#define FMC_GPIO_USER(x)	((x) + 0x1400)	/*  256 of them */
+/* We may add SCL and SDA, or other roles if the need arises */
+
+/* GPIOF_DIR_IN etc are missing before 3.0. copy from <linux/gpio.h> */
+#ifndef GPIOF_DIR_IN
+#  define GPIOF_DIR_OUT   (0 << 0)
+#  define GPIOF_DIR_IN    (1 << 0)
+#  define GPIOF_INIT_LOW  (0 << 1)
+#  define GPIOF_INIT_HIGH (1 << 1)
+#endif
+
+/*
+ * The operations are offered by each carrier and should make driver
+ * design completely independent of the carrier. Named GPIO pins may be
+ * the exception.
+ */
+struct fmc_operations {
+	uint32_t (*readl)(struct fmc_device *fmc, int offset);
+	void (*writel)(struct fmc_device *fmc, uint32_t value, int offset);
+	int (*validate)(struct fmc_device *fmc, struct fmc_driver *drv);
+	int (*reprogram)(struct fmc_device *f, struct fmc_driver *d, char *gw);
+	int (*irq_request)(struct fmc_device *fmc, irq_handler_t h,
+			   char *name, int flags);
+	void (*irq_ack)(struct fmc_device *fmc);
+	int (*irq_free)(struct fmc_device *fmc);
+	int (*gpio_config)(struct fmc_device *fmc, struct fmc_gpio *gpio,
+			   int ngpio);
+	int (*read_ee)(struct fmc_device *fmc, int pos, void *d, int l);
+	int (*write_ee)(struct fmc_device *fmc, int pos, const void *d, int l);
+};
+
+/* Prefer this helper rather than calling of fmc->reprogram directly */
+extern int fmc_reprogram(struct fmc_device *f, struct fmc_driver *d, char *gw,
+		     int sdb_entry);
+
+/*
+ * The device reports all information needed to access hw.
+ *
+ * If we have eeprom_len and not contents, the core reads it.
+ * Then, parsing of identifiers is done by the core which fills fmc_fru_id..
+ * Similarly a device that must be matched based on SDB cores must
+ * fill the entry point and the core will scan the bus (FIXME: sdb match)
+ */
+struct fmc_device {
+	unsigned long version;
+	unsigned long flags;
+	struct module *owner;		/* char device must pin it */
+	struct fmc_fru_id id;		/* for EEPROM-based match */
+	struct fmc_operations *op;	/* carrier-provided */
+	int irq;			/* according to host bus. 0 == none */
+	int eeprom_len;			/* Usually 8kB, may be less */
+	int eeprom_addr;		/* 0x50, 0x52 etc */
+	uint8_t *eeprom;		/* Full contents or leading part */
+	char *carrier_name;		/* "SPEC" or similar, for special use */
+	void *carrier_data;		/* "struct spec *" or equivalent */
+	__iomem void *fpga_base;	/* May be NULL (Etherbone) */
+	__iomem void *slot_base;	/* Set by the driver */
+	struct fmc_device **devarray;	/* Allocated by the bus */
+	int slot_id;			/* Index in the slot array */
+	int nr_slots;			/* Number of slots in this carrier */
+	unsigned long memlen;		/* Used for the char device */
+	struct device dev;		/* For Linux use */
+	struct device *hwdev;		/* The underlying hardware device */
+	unsigned long sdbfs_entry;
+	struct sdb_array *sdb;
+	uint32_t device_id;		/* Filled by the device */
+	char *mezzanine_name;		/* Defaults to ``fmc'' */
+	void *mezzanine_data;
+};
+#define to_fmc_device(x) container_of((x), struct fmc_device, dev)
+
+#define FMC_DEVICE_HAS_GOLDEN		1
+#define FMC_DEVICE_HAS_CUSTOM		2
+#define FMC_DEVICE_NO_MEZZANINE		4
+#define FMC_DEVICE_MATCH_SDB		8 /* fmc-core must scan sdb in fpga */
+
+/*
+ * If fpga_base can be used, the carrier offers no readl/writel methods, and
+ * this expands to a single, fast, I/O access.
+ */
+static inline uint32_t fmc_readl(struct fmc_device *fmc, int offset)
+{
+	if (unlikely(fmc->op->readl))
+		return fmc->op->readl(fmc, offset);
+	return readl(fmc->fpga_base + offset);
+}
+static inline void fmc_writel(struct fmc_device *fmc, uint32_t val, int off)
+{
+	if (unlikely(fmc->op->writel))
+		fmc->op->writel(fmc, val, off);
+	else
+		writel(val, fmc->fpga_base + off);
+}
+
+/* pci-like naming */
+static inline void *fmc_get_drvdata(const struct fmc_device *fmc)
+{
+	return dev_get_drvdata(&fmc->dev);
+}
+
+static inline void fmc_set_drvdata(struct fmc_device *fmc, void *data)
+{
+	dev_set_drvdata(&fmc->dev, data);
+}
+
+/* The 4 access points */
+extern int fmc_driver_register(struct fmc_driver *drv);
+extern void fmc_driver_unregister(struct fmc_driver *drv);
+extern int fmc_device_register(struct fmc_device *tdev);
+extern void fmc_device_unregister(struct fmc_device *tdev);
+
+/* Two more for device sets, all driven by the same FPGA */
+extern int fmc_device_register_n(struct fmc_device **devs, int n);
+extern void fmc_device_unregister_n(struct fmc_device **devs, int n);
+
+/* Internal cross-calls between files; not exported to other modules */
+extern int fmc_match(struct device *dev, struct device_driver *drv);
+extern int fmc_fill_id_info(struct fmc_device *fmc);
+extern void fmc_free_id_info(struct fmc_device *fmc);
+extern void fmc_dump_eeprom(const struct fmc_device *fmc);
+extern void fmc_dump_sdb(const struct fmc_device *fmc);
+
+#endif /* __LINUX_FMC_H__ */
diff --git a/include/linux/ipmi-fru.h b/include/linux/ipmi-fru.h
new file mode 100644
index 0000000..4d3a763
--- /dev/null
+++ b/include/linux/ipmi-fru.h
@@ -0,0 +1,135 @@
+/*
+ * Copyright (C) 2012 CERN (www.cern.ch)
+ * Author: Alessandro Rubini <rubini@gnudd.com>
+ *
+ * Released according to the GNU GPL, version 2 or any later version.
+ *
+ * This work is part of the White Rabbit project, a research effort led
+ * by CERN, the European Institute for Nuclear Research.
+ */
+#ifndef __LINUX_IPMI_FRU_H__
+#define __LINUX_IPMI_FRU_H__
+#ifdef __KERNEL__
+#  include <linux/types.h>
+#  include <linux/string.h>
+#else
+#  include <stdint.h>
+#  include <string.h>
+#endif
+
+/*
+ * These structures match the unaligned crap we have in FRU1011.pdf
+ * (http://download.intel.com/design/servers/ipmi/FRU1011.pdf)
+ */
+
+/* chapter 8, page 5 */
+struct fru_common_header {
+	uint8_t format;			/* 0x01 */
+	uint8_t internal_use_off;	/* multiple of 8 bytes */
+	uint8_t chassis_info_off;	/* multiple of 8 bytes */
+	uint8_t board_area_off;		/* multiple of 8 bytes */
+	uint8_t product_area_off;	/* multiple of 8 bytes */
+	uint8_t multirecord_off;	/* multiple of 8 bytes */
+	uint8_t pad;			/* must be 0 */
+	uint8_t checksum;		/* sum modulo 256 must be 0 */
+};
+
+/* chapter 9, page 5 -- internal_use: not used by us */
+
+/* chapter 10, page 6 -- chassis info: not used by us */
+
+/* chapter 13, page 9 -- used by board_info_area below */
+struct fru_type_length {
+	uint8_t type_length;
+	uint8_t data[0];
+};
+
+/* chapter 11, page 7 */
+struct fru_board_info_area {
+	uint8_t format;			/* 0x01 */
+	uint8_t area_len;		/* multiple of 8 bytes */
+	uint8_t language;		/* I hope it's 0 */
+	uint8_t mfg_date[3];		/* LSB, minutes since 1996-01-01 */
+	struct fru_type_length tl[0];	/* type-length stuff follows */
+
+	/*
+	 * the TL there are in order:
+	 * Board Manufacturer
+	 * Board Product Name
+	 * Board Serial Number
+	 * Board Part Number
+	 * FRU File ID (may be null)
+	 * more manufacturer-specific stuff
+	 * 0xc1 as a terminator
+	 * 0x00 pad to a multiple of 8 bytes - 1
+	 * checksum (sum of all stuff module 256 must be zero)
+	 */
+};
+
+enum fru_type {
+	FRU_TYPE_BINARY		= 0x00,
+	FRU_TYPE_BCDPLUS	= 0x40,
+	FRU_TYPE_ASCII6		= 0x80,
+	FRU_TYPE_ASCII		= 0xc0, /* not ascii: depends on language */
+};
+
+/*
+ * some helpers
+ */
+static inline struct fru_board_info_area *fru_get_board_area(
+	const struct fru_common_header *header)
+{
+	/* we know for sure that the header is 8 bytes in size */
+	return (struct fru_board_info_area *)(header + header->board_area_off);
+}
+
+static inline int fru_type(struct fru_type_length *tl)
+{
+	return tl->type_length & 0xc0;
+}
+
+static inline int fru_length(struct fru_type_length *tl)
+{
+	return (tl->type_length & 0x3f) + 1; /* len of whole record */
+}
+
+/* assume ascii-latin1 encoding */
+static inline int fru_strlen(struct fru_type_length *tl)
+{
+	return fru_length(tl) - 1;
+}
+
+static inline char *fru_strcpy(char *dest, struct fru_type_length *tl)
+{
+	int len = fru_strlen(tl);
+	memcpy(dest, tl->data, len);
+	dest[len] = '\0';
+	return dest;
+}
+
+static inline struct fru_type_length *fru_next_tl(struct fru_type_length *tl)
+{
+	return tl + fru_length(tl);
+}
+
+static inline int fru_is_eof(struct fru_type_length *tl)
+{
+	return tl->type_length == 0xc1;
+}
+
+/*
+ * External functions defined in fru-parse.c.
+ */
+extern int fru_header_cksum_ok(struct fru_common_header *header);
+extern int fru_bia_cksum_ok(struct fru_board_info_area *bia);
+
+/* All these 4 return allocated strings by calling fru_alloc() */
+extern char *fru_get_board_manufacturer(struct fru_common_header *header);
+extern char *fru_get_product_name(struct fru_common_header *header);
+extern char *fru_get_serial_number(struct fru_common_header *header);
+extern char *fru_get_part_number(struct fru_common_header *header);
+
+/* This must be defined by the caller of the above functions */
+extern void *fru_alloc(size_t size);
+
+#endif /* __LINUX_IMPI_FRU_H__ */
diff --git a/include/linux/sdb.h b/include/linux/sdb.h
new file mode 100644
index 0000000..fbb76a4
--- /dev/null
+++ b/include/linux/sdb.h
@@ -0,0 +1,159 @@
+/*
+ * This is the official version 1.1 of sdb.h
+ */
+#ifndef __SDB_H__
+#define __SDB_H__
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
+
+/*
+ * All structures are 64 bytes long and are expected
+ * to live in an array, one for each interconnect.
+ * Most fields of the structures are shared among the
+ * various types, and most-specific fields are at the
+ * beginning (for alignment reasons, and to keep the
+ * magic number at the head of the interconnect record
+ */
+
+/* Product, 40 bytes at offset 24, 8-byte aligned
+ *
+ * device_id is vendor-assigned; version is device-specific,
+ * date is hex (e.g 0x20120501), name is UTF-8, blank-filled
+ * and not terminated with a 0 byte.
+ */
+struct sdb_product {
+	uint64_t		vendor_id;	/* 0x18..0x1f */
+	uint32_t		device_id;	/* 0x20..0x23 */
+	uint32_t		version;	/* 0x24..0x27 */
+	uint32_t		date;		/* 0x28..0x2b */
+	uint8_t			name[19];	/* 0x2c..0x3e */
+	uint8_t			record_type;	/* 0x3f */
+};
+
+/*
+ * Component, 56 bytes at offset 8, 8-byte aligned
+ *
+ * The address range is first to last, inclusive
+ * (for example 0x100000 - 0x10ffff)
+ */
+struct sdb_component {
+	uint64_t		addr_first;	/* 0x08..0x0f */
+	uint64_t		addr_last;	/* 0x10..0x17 */
+	struct sdb_product	product;	/* 0x18..0x3f */
+};
+
+/* Type of the SDB record */
+enum sdb_record_type {
+	sdb_type_interconnect	= 0x00,
+	sdb_type_device		= 0x01,
+	sdb_type_bridge		= 0x02,
+	sdb_type_integration	= 0x80,
+	sdb_type_repo_url	= 0x81,
+	sdb_type_synthesis	= 0x82,
+	sdb_type_empty		= 0xFF,
+};
+
+/* Type 0: interconnect (first of the array)
+ *
+ * sdb_records is the length of the table including this first
+ * record, version is 1. The bus type is enumerated later.
+ */
+#define				SDB_MAGIC	0x5344422d /* "SDB-" */
+struct sdb_interconnect {
+	uint32_t		sdb_magic;	/* 0x00-0x03 */
+	uint16_t		sdb_records;	/* 0x04-0x05 */
+	uint8_t			sdb_version;	/* 0x06 */
+	uint8_t			sdb_bus_type;	/* 0x07 */
+	struct sdb_component	sdb_component;	/* 0x08-0x3f */
+};
+
+/* Type 1: device
+ *
+ * class is 0 for "custom device", other values are
+ * to be standardized; ABI version is for the driver,
+ * bus-specific bits are defined by each bus (see below)
+ */
+struct sdb_device {
+	uint16_t		abi_class;	/* 0x00-0x01 */
+	uint8_t			abi_ver_major;	/* 0x02 */
+	uint8_t			abi_ver_minor;	/* 0x03 */
+	uint32_t		bus_specific;	/* 0x04-0x07 */
+	struct sdb_component	sdb_component;	/* 0x08-0x3f */
+};
+
+/* Type 2: bridge
+ *
+ * child is the address of the nested SDB table
+ */
+struct sdb_bridge {
+	uint64_t		sdb_child;	/* 0x00-0x07 */
+	struct sdb_component	sdb_component;	/* 0x08-0x3f */
+};
+
+/* Type 0x80: integration
+ *
+ * all types with bit 7 set are meta-information, so
+ * software can ignore the types it doesn't know. Here we
+ * just provide product information for an aggregate device
+ */
+struct sdb_integration {
+	uint8_t			reserved[24];	/* 0x00-0x17 */
+	struct sdb_product	product;	/* 0x08-0x3f */
+};
+
+/* Type 0x81: Top module repository url
+ *
+ * again, an informative field that software can ignore
+ */
+struct sdb_repo_url {
+	uint8_t			repo_url[63];	/* 0x00-0x3e */
+	uint8_t			record_type;	/* 0x3f */
+};
+
+/* Type 0x82: Synthesis tool information
+ *
+ * this informative record
+ */
+struct sdb_synthesis {
+	uint8_t			syn_name[16];	/* 0x00-0x0f */
+	uint8_t			commit_id[16];	/* 0x10-0x1f */
+	uint8_t			tool_name[8];	/* 0x20-0x27 */
+	uint32_t		tool_version;	/* 0x28-0x2b */
+	uint32_t		date;		/* 0x2c-0x2f */
+	uint8_t			user_name[15];	/* 0x30-0x3e */
+	uint8_t			record_type;	/* 0x3f */
+};
+
+/* Type 0xff: empty
+ *
+ * this allows keeping empty slots during development,
+ * so they can be filled later with minimal efforts and
+ * no misleading description is ever shipped -- hopefully.
+ * It can also be used to pad a table to a desired length.
+ */
+struct sdb_empty {
+	uint8_t			reserved[63];	/* 0x00-0x3e */
+	uint8_t			record_type;	/* 0x3f */
+};
+
+/* The type of bus, for bus-specific flags */
+enum sdb_bus_type {
+	sdb_wishbone = 0x00,
+	sdb_data     = 0x01,
+};
+
+#define SDB_WB_WIDTH_MASK	0x0f
+#define SDB_WB_ACCESS8			0x01
+#define SDB_WB_ACCESS16			0x02
+#define SDB_WB_ACCESS32			0x04
+#define SDB_WB_ACCESS64			0x08
+#define SDB_WB_LITTLE_ENDIAN	0x80
+
+#define SDB_DATA_READ		0x04
+#define SDB_DATA_WRITE		0x02
+#define SDB_DATA_EXEC		0x01
+
+#endif /* __SDB_H__ */
-- 
1.7.7.2
