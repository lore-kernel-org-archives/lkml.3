Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934093Ab3JPLDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:03:38 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:58771 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933974Ab3JPLDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:03:35 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/8] zorro: Do not allocate zorro_autocon[] statically
Date: Wed, 16 Oct 2013 13:03:19 +0200
Message-Id: <1381921405-11206-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381921405-11206-1-git-send-email-geert@linux-m68k.org>
References: <1381921405-11206-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the array of Zorro devices is allocated statically, wasting
up to 4.5 KiB when running an Amiga or multi-platform kernel on a machine
with no or a handful of Zorro expansion cards. Convert it to conditional
dynamic memory allocation to fix this.

amiga_parse_bootinfo() still needs to store some information about the
detected Zorro devices, at a time even the bootmem allocator is not yet
available.  This is now handled using a much smaller array (typically less
than 0.5 KiB), which is __initdata and thus freed later.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/config.c   |    6 +++---
 arch/m68k/amiga/platform.c |    4 ++--
 drivers/zorro/zorro.c      |   19 ++++++++++++++++---
 include/linux/zorro.h      |   18 +++++++++++++++++-
 4 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index 93ab423758da..d956ddbfebe1 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -174,12 +174,12 @@ int __init amiga_parse_bootinfo(const struct bi_record *record)
 #ifdef CONFIG_ZORRO
 		if (zorro_num_autocon < ZORRO_NUM_AUTO) {
 			const struct ConfigDev *cd = (struct ConfigDev *)data;
-			struct zorro_dev *dev = &zorro_autocon[zorro_num_autocon++];
+			struct zorro_dev_init *dev = &zorro_autocon_init[zorro_num_autocon++];
 			dev->rom = cd->cd_Rom;
 			dev->slotaddr = cd->cd_SlotAddr;
 			dev->slotsize = cd->cd_SlotSize;
-			dev->resource.start = (unsigned long)cd->cd_BoardAddr;
-			dev->resource.end = dev->resource.start + cd->cd_BoardSize - 1;
+			dev->boardaddr = (u32)cd->cd_BoardAddr;
+			dev->boardsize = cd->cd_BoardSize;
 		} else
 			printk("amiga_parse_bootinfo: too many AutoConfig devices\n");
 #endif /* CONFIG_ZORRO */
diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index dacd9f911f71..7847b2b1b5b6 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -67,8 +67,8 @@ static int __init z_dev_present(zorro_id id)
 	unsigned int i;
 
 	for (i = 0; i < zorro_num_autocon; i++)
-		if (zorro_autocon[i].rom.er_Manufacturer == ZORRO_MANUF(id) &&
-		    zorro_autocon[i].rom.er_Product == ZORRO_PROD(id))
+		if (zorro_autocon_init[i].rom.er_Manufacturer == ZORRO_MANUF(id) &&
+		    zorro_autocon_init[i].rom.er_Product == ZORRO_PROD(id))
 			return 1;
 
 	return 0;
diff --git a/drivers/zorro/zorro.c b/drivers/zorro/zorro.c
index 858c9714b2f3..10c7f77aec08 100644
--- a/drivers/zorro/zorro.c
+++ b/drivers/zorro/zorro.c
@@ -29,7 +29,8 @@
      */
 
 unsigned int zorro_num_autocon;
-struct zorro_dev zorro_autocon[ZORRO_NUM_AUTO];
+struct zorro_dev_init zorro_autocon_init[ZORRO_NUM_AUTO] __initdata;
+struct zorro_dev *zorro_autocon;
 
 
     /*
@@ -38,6 +39,7 @@ struct zorro_dev zorro_autocon[ZORRO_NUM_AUTO];
 
 struct zorro_bus {
 	struct device dev;
+	struct zorro_dev devices[0];
 };
 
 
@@ -125,16 +127,20 @@ static struct resource __init *zorro_find_parent_resource(
 static int __init amiga_zorro_probe(struct platform_device *pdev)
 {
 	struct zorro_bus *bus;
+	struct zorro_dev_init *zi;
 	struct zorro_dev *z;
 	struct resource *r;
 	unsigned int i;
 	int error;
 
 	/* Initialize the Zorro bus */
-	bus = kzalloc(sizeof(*bus), GFP_KERNEL);
+	bus = kzalloc(sizeof(*bus) +
+		      zorro_num_autocon * sizeof(bus->devices[0]),
+		      GFP_KERNEL);
 	if (!bus)
 		return -ENOMEM;
 
+	zorro_autocon = bus->devices;
 	bus->dev.parent = &pdev->dev;
 	dev_set_name(&bus->dev, "zorro");
 	error = device_register(&bus->dev);
@@ -151,15 +157,22 @@ static int __init amiga_zorro_probe(struct platform_device *pdev)
 
 	/* First identify all devices ... */
 	for (i = 0; i < zorro_num_autocon; i++) {
+		zi = &zorro_autocon_init[i];
 		z = &zorro_autocon[i];
+
+		z->rom = zi->rom;
 		z->id = (z->rom.er_Manufacturer<<16) | (z->rom.er_Product<<8);
 		if (z->id == ZORRO_PROD_GVP_EPC_BASE) {
 			/* GVP quirk */
-			unsigned long magic = zorro_resource_start(z)+0x8000;
+			unsigned long magic = zi->boardaddr + 0x8000;
 			z->id |= *(u16 *)ZTWO_VADDR(magic) & GVP_PRODMASK;
 		}
+		z->slotaddr = zi->slotaddr;
+		z->slotsize = zi->slotsize;
 		sprintf(z->name, "Zorro device %08x", z->id);
 		zorro_name_device(z);
+		z->resource.start = zi->boardaddr;
+		z->resource.end = zi->boardaddr + zi->boardsize - 1;
 		z->resource.name = z->name;
 		r = zorro_find_parent_resource(pdev, z);
 		error = request_resource(r, &z->resource);
diff --git a/include/linux/zorro.h b/include/linux/zorro.h
index dff42025649b..661cbd2a86ee 100644
--- a/include/linux/zorro.h
+++ b/include/linux/zorro.h
@@ -175,7 +175,23 @@ static inline struct zorro_driver *zorro_dev_driver(const struct zorro_dev *z)
 
 
 extern unsigned int zorro_num_autocon;	/* # of autoconfig devices found */
-extern struct zorro_dev zorro_autocon[ZORRO_NUM_AUTO];
+extern struct zorro_dev *zorro_autocon;
+
+
+    /*
+     * Minimal information about a Zorro device, passed from bootinfo
+     * Only available temporarily, i.e. until initmem has been freed!
+     */
+
+struct zorro_dev_init {
+	struct ExpansionRom rom;
+	u16 slotaddr;
+	u16 slotsize;
+	u32 boardaddr;
+	u32 boardsize;
+};
+
+extern struct zorro_dev_init zorro_autocon_init[ZORRO_NUM_AUTO] __initdata;
 
 
     /*
-- 
1.7.9.5

