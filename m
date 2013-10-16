Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934173Ab3JPLEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:04:38 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:58832 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934027Ab3JPLDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:03:37 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 8/8] zorro/UAPI: Use proper types (endianness/size) in <linux/zorro.h>
Date: Wed, 16 Oct 2013 13:03:25 +0200
Message-Id: <1381921405-11206-9-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381921405-11206-1-git-send-email-geert@linux-m68k.org>
References: <1381921405-11206-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix member definitions for non-native userspace handling:
  - All multi-byte values are big-endian, hence use __be*,
  - All pointers are 32-bit pointers under AmigaOS, but unused (except for
    cd_BoardAddr) under Linux, hence use __be32.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
---
 arch/m68k/amiga/config.c           |    9 +++----
 arch/m68k/amiga/platform.c         |    9 ++++---
 drivers/net/ethernet/amd/a2065.c   |    9 ++++---
 drivers/net/ethernet/amd/ariadne.c |    9 ++++---
 drivers/zorro/proc.c               |   10 ++++----
 drivers/zorro/zorro-sysfs.c        |   22 +++++++++++++----
 drivers/zorro/zorro.c              |    4 +++-
 include/uapi/linux/zorro.h         |   46 ++++++++++++++++++------------------
 8 files changed, 72 insertions(+), 46 deletions(-)

diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index acd9c1640cfc..65b5e937ebba 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -28,6 +28,7 @@
 #include <linux/keyboard.h>
 
 #include <asm/bootinfo.h>
+#include <asm/byteorder.h>
 #include <asm/setup.h>
 #include <asm/pgtable.h>
 #include <asm/amigahw.h>
@@ -176,10 +177,10 @@ int __init amiga_parse_bootinfo(const struct bi_record *record)
 			const struct ConfigDev *cd = (struct ConfigDev *)data;
 			struct zorro_dev_init *dev = &zorro_autocon_init[zorro_num_autocon++];
 			dev->rom = cd->cd_Rom;
-			dev->slotaddr = cd->cd_SlotAddr;
-			dev->slotsize = cd->cd_SlotSize;
-			dev->boardaddr = (u32)cd->cd_BoardAddr;
-			dev->boardsize = cd->cd_BoardSize;
+			dev->slotaddr = be16_to_cpu(cd->cd_SlotAddr);
+			dev->slotsize = be16_to_cpu(cd->cd_SlotSize);
+			dev->boardaddr = be32_to_cpu(cd->cd_BoardAddr);
+			dev->boardsize = be32_to_cpu(cd->cd_BoardSize);
 		} else
 			printk("amiga_parse_bootinfo: too many AutoConfig devices\n");
 #endif /* CONFIG_ZORRO */
diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index 7847b2b1b5b6..d34029d7b058 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -13,6 +13,7 @@
 
 #include <asm/amigahw.h>
 #include <asm/amigayle.h>
+#include <asm/byteorder.h>
 
 
 #ifdef CONFIG_ZORRO
@@ -66,10 +67,12 @@ static int __init z_dev_present(zorro_id id)
 {
 	unsigned int i;
 
-	for (i = 0; i < zorro_num_autocon; i++)
-		if (zorro_autocon_init[i].rom.er_Manufacturer == ZORRO_MANUF(id) &&
-		    zorro_autocon_init[i].rom.er_Product == ZORRO_PROD(id))
+	for (i = 0; i < zorro_num_autocon; i++) {
+		const struct ExpansionRom *rom = &zorro_autocon_init[i].rom;
+		if (be16_to_cpu(rom->er_Manufacturer) == ZORRO_MANUF(id) &&
+		    rom->er_Product == ZORRO_PROD(id))
 			return 1;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/amd/a2065.c b/drivers/net/ethernet/amd/a2065.c
index f492a19328e5..56139184b801 100644
--- a/drivers/net/ethernet/amd/a2065.c
+++ b/drivers/net/ethernet/amd/a2065.c
@@ -57,6 +57,7 @@
 #include <linux/zorro.h>
 #include <linux/bitops.h>
 
+#include <asm/byteorder.h>
 #include <asm/irq.h>
 #include <asm/amigaints.h>
 #include <asm/amigahw.h>
@@ -678,6 +679,7 @@ static int a2065_init_one(struct zorro_dev *z,
 	unsigned long base_addr = board + A2065_LANCE;
 	unsigned long mem_start = board + A2065_RAM;
 	struct resource *r1, *r2;
+	u32 serial;
 	int err;
 
 	r1 = request_mem_region(base_addr, sizeof(struct lance_regs),
@@ -702,6 +704,7 @@ static int a2065_init_one(struct zorro_dev *z,
 	r1->name = dev->name;
 	r2->name = dev->name;
 
+	serial = be32_to_cpu(z->rom.er_SerialNumber);
 	dev->dev_addr[0] = 0x00;
 	if (z->id != ZORRO_PROD_AMERISTAR_A2065) {	/* Commodore */
 		dev->dev_addr[1] = 0x80;
@@ -710,9 +713,9 @@ static int a2065_init_one(struct zorro_dev *z,
 		dev->dev_addr[1] = 0x00;
 		dev->dev_addr[2] = 0x9f;
 	}
-	dev->dev_addr[3] = (z->rom.er_SerialNumber >> 16) & 0xff;
-	dev->dev_addr[4] = (z->rom.er_SerialNumber >> 8) & 0xff;
-	dev->dev_addr[5] = z->rom.er_SerialNumber & 0xff;
+	dev->dev_addr[3] = (serial >> 16) & 0xff;
+	dev->dev_addr[4] = (serial >> 8) & 0xff;
+	dev->dev_addr[5] = serial & 0xff;
 	dev->base_addr = (unsigned long)ZTWO_VADDR(base_addr);
 	dev->mem_start = (unsigned long)ZTWO_VADDR(mem_start);
 	dev->mem_end = dev->mem_start + A2065_RAM_SIZE;
diff --git a/drivers/net/ethernet/amd/ariadne.c b/drivers/net/ethernet/amd/ariadne.c
index 33822cb69366..b08101b31b8b 100644
--- a/drivers/net/ethernet/amd/ariadne.c
+++ b/drivers/net/ethernet/amd/ariadne.c
@@ -51,6 +51,7 @@
 #include <linux/zorro.h>
 #include <linux/bitops.h>
 
+#include <asm/byteorder.h>
 #include <asm/amigaints.h>
 #include <asm/amigahw.h>
 #include <asm/irq.h>
@@ -718,6 +719,7 @@ static int ariadne_init_one(struct zorro_dev *z,
 	struct resource *r1, *r2;
 	struct net_device *dev;
 	struct ariadne_private *priv;
+	u32 serial;
 	int err;
 
 	r1 = request_mem_region(base_addr, sizeof(struct Am79C960), "Am79C960");
@@ -741,12 +743,13 @@ static int ariadne_init_one(struct zorro_dev *z,
 	r1->name = dev->name;
 	r2->name = dev->name;
 
+	serial = be32_to_cpu(z->rom.er_SerialNumber);
 	dev->dev_addr[0] = 0x00;
 	dev->dev_addr[1] = 0x60;
 	dev->dev_addr[2] = 0x30;
-	dev->dev_addr[3] = (z->rom.er_SerialNumber >> 16) & 0xff;
-	dev->dev_addr[4] = (z->rom.er_SerialNumber >> 8) & 0xff;
-	dev->dev_addr[5] = z->rom.er_SerialNumber & 0xff;
+	dev->dev_addr[3] = (serial >> 16) & 0xff;
+	dev->dev_addr[4] = (serial >> 8) & 0xff;
+	dev->dev_addr[5] = serial & 0xff;
 	dev->base_addr = (unsigned long)ZTWO_VADDR(base_addr);
 	dev->mem_start = (unsigned long)ZTWO_VADDR(mem_start);
 	dev->mem_end = dev->mem_start + ARIADNE_RAM_SIZE;
diff --git a/drivers/zorro/proc.c b/drivers/zorro/proc.c
index ea1ce822a8e0..6ac2579da0eb 100644
--- a/drivers/zorro/proc.c
+++ b/drivers/zorro/proc.c
@@ -14,6 +14,8 @@
 #include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/export.h>
+
+#include <asm/byteorder.h>
 #include <asm/uaccess.h>
 #include <asm/amigahw.h>
 #include <asm/setup.h>
@@ -41,10 +43,10 @@ proc_bus_zorro_read(struct file *file, char __user *buf, size_t nbytes, loff_t *
 	/* Construct a ConfigDev */
 	memset(&cd, 0, sizeof(cd));
 	cd.cd_Rom = z->rom;
-	cd.cd_SlotAddr = z->slotaddr;
-	cd.cd_SlotSize = z->slotsize;
-	cd.cd_BoardAddr = (void *)zorro_resource_start(z);
-	cd.cd_BoardSize = zorro_resource_len(z);
+	cd.cd_SlotAddr = cpu_to_be16(z->slotaddr);
+	cd.cd_SlotSize = cpu_to_be16(z->slotsize);
+	cd.cd_BoardAddr = cpu_to_be32(zorro_resource_start(z));
+	cd.cd_BoardSize = cpu_to_be32(zorro_resource_len(z));
 
 	if (copy_to_user(buf, (void *)&cd + pos, nbytes))
 		return -EFAULT;
diff --git a/drivers/zorro/zorro-sysfs.c b/drivers/zorro/zorro-sysfs.c
index 26f7184ef9e1..36b210f9b6b2 100644
--- a/drivers/zorro/zorro-sysfs.c
+++ b/drivers/zorro/zorro-sysfs.c
@@ -16,6 +16,8 @@
 #include <linux/stat.h>
 #include <linux/string.h>
 
+#include <asm/byteorder.h>
+
 #include "zorro.h"
 
 
@@ -33,10 +35,20 @@ static DEVICE_ATTR(name, S_IRUGO, show_##name, NULL);
 
 zorro_config_attr(id, id, "0x%08x\n");
 zorro_config_attr(type, rom.er_Type, "0x%02x\n");
-zorro_config_attr(serial, rom.er_SerialNumber, "0x%08x\n");
 zorro_config_attr(slotaddr, slotaddr, "0x%04x\n");
 zorro_config_attr(slotsize, slotsize, "0x%04x\n");
 
+static ssize_t
+show_serial(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct zorro_dev *z;
+
+	z = to_zorro_dev(dev);
+	return sprintf(buf, "0x%08x\n", be32_to_cpu(z->rom.er_SerialNumber));
+}
+
+static DEVICE_ATTR(serial, S_IRUGO, show_serial, NULL);
+
 static ssize_t zorro_show_resource(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct zorro_dev *z = to_zorro_dev(dev);
@@ -60,10 +72,10 @@ static ssize_t zorro_read_config(struct file *filp, struct kobject *kobj,
 	/* Construct a ConfigDev */
 	memset(&cd, 0, sizeof(cd));
 	cd.cd_Rom = z->rom;
-	cd.cd_SlotAddr = z->slotaddr;
-	cd.cd_SlotSize = z->slotsize;
-	cd.cd_BoardAddr = (void *)zorro_resource_start(z);
-	cd.cd_BoardSize = zorro_resource_len(z);
+	cd.cd_SlotAddr = cpu_to_be16(z->slotaddr);
+	cd.cd_SlotSize = cpu_to_be16(z->slotsize);
+	cd.cd_BoardAddr = cpu_to_be32(zorro_resource_start(z));
+	cd.cd_BoardSize = cpu_to_be32(zorro_resource_len(z));
 
 	return memory_read_from_buffer(buf, count, &off, &cd, sizeof(cd));
 }
diff --git a/drivers/zorro/zorro.c b/drivers/zorro/zorro.c
index 450abf100f06..707c1a5a0317 100644
--- a/drivers/zorro/zorro.c
+++ b/drivers/zorro/zorro.c
@@ -18,6 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
+#include <asm/byteorder.h>
 #include <asm/setup.h>
 #include <asm/amigahw.h>
 
@@ -161,7 +162,8 @@ static int __init amiga_zorro_probe(struct platform_device *pdev)
 		z = &zorro_autocon[i];
 
 		z->rom = zi->rom;
-		z->id = (z->rom.er_Manufacturer<<16) | (z->rom.er_Product<<8);
+		z->id = (be16_to_cpu(z->rom.er_Manufacturer) << 16) |
+			(z->rom.er_Product << 8);
 		if (z->id == ZORRO_PROD_GVP_EPC_BASE) {
 			/* GVP quirk */
 			unsigned long magic = zi->boardaddr + 0x8000;
diff --git a/include/uapi/linux/zorro.h b/include/uapi/linux/zorro.h
index 36a033e23d31..59d021b242ed 100644
--- a/include/uapi/linux/zorro.h
+++ b/include/uapi/linux/zorro.h
@@ -63,26 +63,26 @@ enum GVP_flags {
 
 
 struct Node {
-	struct  Node *ln_Succ;	/* Pointer to next (successor) */
-	struct  Node *ln_Pred;	/* Pointer to previous (predecessor) */
-	__u8    ln_Type;
-	__s8    ln_Pri;		/* Priority, for sorting */
-	__s8    *ln_Name;	/* ID string, null terminated */
+	__be32 ln_Succ;		/* Pointer to next (successor) */
+	__be32 ln_Pred;		/* Pointer to previous (predecessor) */
+	__u8   ln_Type;
+	__s8   ln_Pri;		/* Priority, for sorting */
+	__be32 ln_Name;		/* ID string, null terminated */
 } __packed;
 
 struct ExpansionRom {
 	/* -First 16 bytes of the expansion ROM */
-	__u8  er_Type;		/* Board type, size and flags */
-	__u8  er_Product;	/* Product number, assigned by manufacturer */
-	__u8  er_Flags;		/* Flags */
-	__u8  er_Reserved03;	/* Must be zero ($ff inverted) */
-	__u16 er_Manufacturer;	/* Unique ID, ASSIGNED BY COMMODORE-AMIGA! */
-	__u32 er_SerialNumber;	/* Available for use by manufacturer */
-	__u16 er_InitDiagVec;	/* Offset to optional "DiagArea" structure */
-	__u8  er_Reserved0c;
-	__u8  er_Reserved0d;
-	__u8  er_Reserved0e;
-	__u8  er_Reserved0f;
+	__u8   er_Type;		/* Board type, size and flags */
+	__u8   er_Product;	/* Product number, assigned by manufacturer */
+	__u8   er_Flags;		/* Flags */
+	__u8   er_Reserved03;	/* Must be zero ($ff inverted) */
+	__be16 er_Manufacturer;	/* Unique ID, ASSIGNED BY COMMODORE-AMIGA! */
+	__be32 er_SerialNumber;	/* Available for use by manufacturer */
+	__be16 er_InitDiagVec;	/* Offset to optional "DiagArea" structure */
+	__u8   er_Reserved0c;
+	__u8   er_Reserved0d;
+	__u8   er_Reserved0e;
+	__u8   er_Reserved0f;
 } __packed;
 
 /* er_Type board type bits */
@@ -99,13 +99,13 @@ struct ConfigDev {
 	__u8		cd_Flags;	/* (read/write) */
 	__u8		cd_Pad;		/* reserved */
 	struct ExpansionRom cd_Rom;	/* copy of board's expansion ROM */
-	void		*cd_BoardAddr;	/* where in memory the board was placed */
-	__u32		cd_BoardSize;	/* size of board in bytes */
-	__u16		cd_SlotAddr;	/* which slot number (PRIVATE) */
-	__u16		cd_SlotSize;	/* number of slots (PRIVATE) */
-	void		*cd_Driver;	/* pointer to node of driver */
-	struct ConfigDev *cd_NextCD;	/* linked list of drivers to config */
-	__u32		cd_Unused[4];	/* for whatever the driver wants */
+	__be32		cd_BoardAddr;	/* where in memory the board was placed */
+	__be32		cd_BoardSize;	/* size of board in bytes */
+	__be16		cd_SlotAddr;	/* which slot number (PRIVATE) */
+	__be16		cd_SlotSize;	/* number of slots (PRIVATE) */
+	__be32		cd_Driver;	/* pointer to node of driver */
+	__be32		cd_NextCD;	/* linked list of drivers to config */
+	__be32		cd_Unused[4];	/* for whatever the driver wants */
 } __packed;
 
 #define ZORRO_NUM_AUTO		16
-- 
1.7.9.5

