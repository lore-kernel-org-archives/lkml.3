Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3EMOko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:40:44 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:61396 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752732Ab3EMOkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:40:42 -0400
Message-ID: <1368456039.1350.53.camel@x61.thuisdomein>
Subject: [PATCH] mtd: remove obsolete JEDEC mapping drivers
From: Paul Bolle <pebolle@tiscali.nl>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Date: Mon, 13 May 2013 16:40:39 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 May 2013 14:40:39.0804 (UTC) FILETIME=[D6AD3BC0:01CE4FE7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JEDEC device support was removed in v2.6.22. (It had been marked as
BROKEN (indirectly) since at least v2.6.12.)

When it was removed the two JEDEC mapping drivers that depended on it
should have been removed too. Do so now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) These two seems to have been missed in Artem's recent cleaning up
effort. Or is a comparable patch queued somewhere?

 drivers/mtd/maps/Kconfig        |  18 ---
 drivers/mtd/maps/Makefile       |   2 -
 drivers/mtd/maps/octagon-5066.c | 246 ----------------------------------------
 drivers/mtd/maps/vmax301.c      | 196 --------------------------------
 4 files changed, 462 deletions(-)
 delete mode 100644 drivers/mtd/maps/octagon-5066.c
 delete mode 100644 drivers/mtd/maps/vmax301.c

diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index bed9d58..7978caa 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -157,24 +157,6 @@ config MTD_PXA2XX
 	help
 	  This provides a driver for the NOR flash attached to a PXA2xx chip.
 
-config MTD_OCTAGON
-	tristate "JEDEC Flash device mapped on Octagon 5066 SBC"
-	depends on X86 && MTD_JEDEC && MTD_COMPLEX_MAPPINGS
-	help
-	  This provides a 'mapping' driver which supports the way in which
-	  the flash chips are connected in the Octagon-5066 Single Board
-	  Computer. More information on the board is available at
-	  <http://www.octagonsystems.com/products/5066.aspx>.
-
-config MTD_VMAX
-	tristate "JEDEC Flash device mapped on Tempustech VMAX SBC301"
-	depends on X86 && MTD_JEDEC && MTD_COMPLEX_MAPPINGS
-	help
-	  This provides a 'mapping' driver which supports the way in which
-	  the flash chips are connected in the Tempustech VMAX SBC301 Single
-	  Board Computer. More information on the board is available at
-	  <http://www.tempustech.com/>.
-
 config MTD_SCx200_DOCFLASH
 	tristate "Flash device mapped with DOCCS on NatSemi SCx200"
 	depends on SCx200 && MTD_CFI
diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index 395a124..a5bb4a91 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -16,7 +16,6 @@ obj-$(CONFIG_MTD_ICHXROM)	+= ichxrom.o
 obj-$(CONFIG_MTD_CK804XROM)	+= ck804xrom.o
 obj-$(CONFIG_MTD_TSUNAMI)	+= tsunami_flash.o
 obj-$(CONFIG_MTD_PXA2XX)	+= pxa2xx-flash.o
-obj-$(CONFIG_MTD_OCTAGON)	+= octagon-5066.o
 obj-$(CONFIG_MTD_PHYSMAP)	+= physmap.o
 obj-$(CONFIG_MTD_PHYSMAP_OF)	+= physmap_of.o
 obj-$(CONFIG_MTD_PISMO)		+= pismo.o
@@ -28,7 +27,6 @@ obj-$(CONFIG_MTD_SC520CDP)	+= sc520cdp.o
 obj-$(CONFIG_MTD_NETSC520)	+= netsc520.o
 obj-$(CONFIG_MTD_TS5500)	+= ts5500_flash.o
 obj-$(CONFIG_MTD_SUN_UFLASH)	+= sun_uflash.o
-obj-$(CONFIG_MTD_VMAX)		+= vmax301.o
 obj-$(CONFIG_MTD_SCx200_DOCFLASH)+= scx200_docflash.o
 obj-$(CONFIG_MTD_SOLUTIONENGINE)+= solutionengine.o
 obj-$(CONFIG_MTD_PCI)		+= pci.o
diff --git a/drivers/mtd/maps/octagon-5066.c b/drivers/mtd/maps/octagon-5066.c
deleted file mode 100644
index 807ac2a..0000000
--- a/drivers/mtd/maps/octagon-5066.c
+++ /dev/null
@@ -1,246 +0,0 @@
-/* ######################################################################
-
-   Octagon 5066 MTD Driver.
-
-   The Octagon 5066 is a SBC based on AMD's 586-WB running at 133 MHZ. It
-   comes with a builtin AMD 29F016 flash chip and a socketed EEPROM that
-   is replacable by flash. Both units are mapped through a multiplexer
-   into a 32k memory window at 0xe8000. The control register for the
-   multiplexing unit is located at IO 0x208 with a bit map of
-     0-5 Page Selection in 32k increments
-     6-7 Device selection:
-        00 SSD off
-        01 SSD 0 (Socket)
-        10 SSD 1 (Flash chip)
-        11 undefined
-
-   On each SSD, the first 128k is reserved for use by the bios
-   (actually it IS the bios..) This only matters if you are booting off the
-   flash, you must not put a file system starting there.
-
-   The driver tries to do a detection algorithm to guess what sort of devices
-   are plugged into the sockets.
-
-   ##################################################################### */
-
-#include <linux/module.h>
-#include <linux/ioport.h>
-#include <linux/init.h>
-#include <asm/io.h>
-
-#include <linux/mtd/map.h>
-#include <linux/mtd/mtd.h>
-
-#define WINDOW_START 0xe8000
-#define WINDOW_LENGTH 0x8000
-#define WINDOW_SHIFT 27
-#define WINDOW_MASK 0x7FFF
-#define PAGE_IO 0x208
-
-static volatile char page_n_dev = 0;
-static unsigned long iomapadr;
-static DEFINE_SPINLOCK(oct5066_spin);
-
-/*
- * We use map_priv_1 to identify which device we are.
- */
-
-static void __oct5066_page(struct map_info *map, __u8 byte)
-{
-	outb(byte,PAGE_IO);
-	page_n_dev = byte;
-}
-
-static inline void oct5066_page(struct map_info *map, unsigned long ofs)
-{
-	__u8 byte = map->map_priv_1 | (ofs >> WINDOW_SHIFT);
-
-	if (page_n_dev != byte)
-		__oct5066_page(map, byte);
-}
-
-
-static map_word oct5066_read8(struct map_info *map, unsigned long ofs)
-{
-	map_word ret;
-	spin_lock(&oct5066_spin);
-	oct5066_page(map, ofs);
-	ret.x[0] = readb(iomapadr + (ofs & WINDOW_MASK));
-	spin_unlock(&oct5066_spin);
-	return ret;
-}
-
-static void oct5066_copy_from(struct map_info *map, void *to, unsigned long from, ssize_t len)
-{
-	while(len) {
-		unsigned long thislen = len;
-		if (len > (WINDOW_LENGTH - (from & WINDOW_MASK)))
-			thislen = WINDOW_LENGTH-(from & WINDOW_MASK);
-
-		spin_lock(&oct5066_spin);
-		oct5066_page(map, from);
-		memcpy_fromio(to, iomapadr + from, thislen);
-		spin_unlock(&oct5066_spin);
-		to += thislen;
-		from += thislen;
-		len -= thislen;
-	}
-}
-
-static void oct5066_write8(struct map_info *map, map_word d, unsigned long adr)
-{
-	spin_lock(&oct5066_spin);
-	oct5066_page(map, adr);
-	writeb(d.x[0], iomapadr + (adr & WINDOW_MASK));
-	spin_unlock(&oct5066_spin);
-}
-
-static void oct5066_copy_to(struct map_info *map, unsigned long to, const void *from, ssize_t len)
-{
-	while(len) {
-		unsigned long thislen = len;
-		if (len > (WINDOW_LENGTH - (to & WINDOW_MASK)))
-			thislen = WINDOW_LENGTH-(to & WINDOW_MASK);
-
-		spin_lock(&oct5066_spin);
-		oct5066_page(map, to);
-		memcpy_toio(iomapadr + to, from, thislen);
-		spin_unlock(&oct5066_spin);
-		to += thislen;
-		from += thislen;
-		len -= thislen;
-	}
-}
-
-static struct map_info oct5066_map[2] = {
-	{
-		.name = "Octagon 5066 Socket",
-		.phys = NO_XIP,
-		.size = 512 * 1024,
-		.bankwidth = 1,
-		.read = oct5066_read8,
-		.copy_from = oct5066_copy_from,
-		.write = oct5066_write8,
-		.copy_to = oct5066_copy_to,
-		.map_priv_1 = 1<<6
-	},
-	{
-		.name = "Octagon 5066 Internal Flash",
-		.phys = NO_XIP,
-		.size = 2 * 1024 * 1024,
-		.bankwidth = 1,
-		.read = oct5066_read8,
-		.copy_from = oct5066_copy_from,
-		.write = oct5066_write8,
-		.copy_to = oct5066_copy_to,
-		.map_priv_1 = 2<<6
-	}
-};
-
-static struct mtd_info *oct5066_mtd[2] = {NULL, NULL};
-
-// OctProbe - Sense if this is an octagon card
-// ---------------------------------------------------------------------
-/* Perform a simple validity test, we map the window select SSD0 and
-   change pages while monitoring the window. A change in the window,
-   controlled by the PAGE_IO port is a functioning 5066 board. This will
-   fail if the thing in the socket is set to a uniform value. */
-static int __init OctProbe(void)
-{
-   unsigned int Base = (1 << 6);
-   unsigned long I;
-   unsigned long Values[10];
-   for (I = 0; I != 20; I++)
-   {
-      outb(Base + (I%10),PAGE_IO);
-      if (I < 10)
-      {
-	 // Record the value and check for uniqueness
-	 Values[I%10] = readl(iomapadr);
-	 if (I > 0 && Values[I%10] == Values[0])
-	    return -EAGAIN;
-      }
-      else
-      {
-	 // Make sure we get the same values on the second pass
-	 if (Values[I%10] != readl(iomapadr))
-	    return -EAGAIN;
-      }
-   }
-   return 0;
-}
-
-void cleanup_oct5066(void)
-{
-	int i;
-	for (i=0; i<2; i++) {
-		if (oct5066_mtd[i]) {
-			mtd_device_unregister(oct5066_mtd[i]);
-			map_destroy(oct5066_mtd[i]);
-		}
-	}
-	iounmap((void *)iomapadr);
-	release_region(PAGE_IO, 1);
-}
-
-static int __init init_oct5066(void)
-{
-	int i;
-	int ret = 0;
-
-	// Do an autoprobe sequence
-	if (!request_region(PAGE_IO,1,"Octagon SSD")) {
-		printk(KERN_NOTICE "5066: Page Register in Use\n");
-		return -EAGAIN;
-	}
-	iomapadr = (unsigned long)ioremap(WINDOW_START, WINDOW_LENGTH);
-	if (!iomapadr) {
-		printk(KERN_NOTICE "Failed to ioremap memory region\n");
-		ret = -EIO;
-		goto out_rel;
-	}
-	if (OctProbe() != 0) {
-		printk(KERN_NOTICE "5066: Octagon Probe Failed, is this an Octagon 5066 SBC?\n");
-		iounmap((void *)iomapadr);
-		ret = -EAGAIN;
-		goto out_unmap;
-	}
-
-	// Print out our little header..
-	printk("Octagon 5066 SSD IO:0x%x MEM:0x%x-0x%x\n",PAGE_IO,WINDOW_START,
-	       WINDOW_START+WINDOW_LENGTH);
-
-	for (i=0; i<2; i++) {
-		oct5066_mtd[i] = do_map_probe("cfi_probe", &oct5066_map[i]);
-		if (!oct5066_mtd[i])
-			oct5066_mtd[i] = do_map_probe("jedec", &oct5066_map[i]);
-		if (!oct5066_mtd[i])
-			oct5066_mtd[i] = do_map_probe("map_ram", &oct5066_map[i]);
-		if (!oct5066_mtd[i])
-			oct5066_mtd[i] = do_map_probe("map_rom", &oct5066_map[i]);
-		if (oct5066_mtd[i]) {
-			oct5066_mtd[i]->owner = THIS_MODULE;
-			mtd_device_register(oct5066_mtd[i], NULL, 0);
-		}
-	}
-
-	if (!oct5066_mtd[0] && !oct5066_mtd[1]) {
-		cleanup_oct5066();
-		return -ENXIO;
-	}
-
-	return 0;
-
- out_unmap:
-	iounmap((void *)iomapadr);
- out_rel:
-	release_region(PAGE_IO, 1);
-	return ret;
-}
-
-module_init(init_oct5066);
-module_exit(cleanup_oct5066);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jason Gunthorpe <jgg@deltatee.com>, David Woodhouse <dwmw2@infradead.org>");
-MODULE_DESCRIPTION("MTD map driver for Octagon 5066 Single Board Computer");
diff --git a/drivers/mtd/maps/vmax301.c b/drivers/mtd/maps/vmax301.c
deleted file mode 100644
index 5e68de7..0000000
--- a/drivers/mtd/maps/vmax301.c
+++ /dev/null
@@ -1,196 +0,0 @@
-/* ######################################################################
-
-   Tempustech VMAX SBC301 MTD Driver.
-
-   The VMAx 301 is a SBC based on . It
-   comes with three builtin AMD 29F016B flash chips and a socket for SRAM or
-   more flash. Each unit has it's own 8k mapping into a settable region
-   (0xD8000). There are two 8k mappings for each MTD, the first is always set
-   to the lower 8k of the device the second is paged. Writing a 16 bit page
-   value to anywhere in the first 8k will cause the second 8k to page around.
-
-   To boot the device a bios extension must be installed into the first 8k
-   of flash that is smart enough to copy itself down, page in the rest of
-   itself and begin executing.
-
-   ##################################################################### */
-
-#include <linux/module.h>
-#include <linux/ioport.h>
-#include <linux/init.h>
-#include <linux/spinlock.h>
-#include <asm/io.h>
-
-#include <linux/mtd/map.h>
-#include <linux/mtd/mtd.h>
-
-
-#define WINDOW_START 0xd8000
-#define WINDOW_LENGTH 0x2000
-#define WINDOW_SHIFT 25
-#define WINDOW_MASK 0x1FFF
-
-/* Actually we could use two spinlocks, but we'd have to have
-   more private space in the struct map_info. We lose a little
-   performance like this, but we'd probably lose more by having
-   the extra indirection from having one of the map->map_priv
-   fields pointing to yet another private struct.
-*/
-static DEFINE_SPINLOCK(vmax301_spin);
-
-static void __vmax301_page(struct map_info *map, unsigned long page)
-{
-	writew(page, map->map_priv_2 - WINDOW_LENGTH);
-	map->map_priv_1 = page;
-}
-
-static inline void vmax301_page(struct map_info *map,
-				  unsigned long ofs)
-{
-	unsigned long page = (ofs >> WINDOW_SHIFT);
-	if (map->map_priv_1 != page)
-		__vmax301_page(map, page);
-}
-
-static map_word vmax301_read8(struct map_info *map, unsigned long ofs)
-{
-	map_word ret;
-	spin_lock(&vmax301_spin);
-	vmax301_page(map, ofs);
-	ret.x[0] = readb(map->map_priv_2 + (ofs & WINDOW_MASK));
-	spin_unlock(&vmax301_spin);
-	return ret;
-}
-
-static void vmax301_copy_from(struct map_info *map, void *to, unsigned long from, ssize_t len)
-{
-	while(len) {
-		unsigned long thislen = len;
-		if (len > (WINDOW_LENGTH - (from & WINDOW_MASK)))
-			thislen = WINDOW_LENGTH-(from & WINDOW_MASK);
-		spin_lock(&vmax301_spin);
-		vmax301_page(map, from);
-		memcpy_fromio(to, map->map_priv_2 + from, thislen);
-		spin_unlock(&vmax301_spin);
-		to += thislen;
-		from += thislen;
-		len -= thislen;
-	}
-}
-
-static void vmax301_write8(struct map_info *map, map_word d, unsigned long adr)
-{
-	spin_lock(&vmax301_spin);
-	vmax301_page(map, adr);
-	writeb(d.x[0], map->map_priv_2 + (adr & WINDOW_MASK));
-	spin_unlock(&vmax301_spin);
-}
-
-static void vmax301_copy_to(struct map_info *map, unsigned long to, const void *from, ssize_t len)
-{
-	while(len) {
-		unsigned long thislen = len;
-		if (len > (WINDOW_LENGTH - (to & WINDOW_MASK)))
-			thislen = WINDOW_LENGTH-(to & WINDOW_MASK);
-
-		spin_lock(&vmax301_spin);
-		vmax301_page(map, to);
-		memcpy_toio(map->map_priv_2 + to, from, thislen);
-		spin_unlock(&vmax301_spin);
-		to += thislen;
-		from += thislen;
-		len -= thislen;
-	}
-}
-
-static struct map_info vmax_map[2] = {
-	{
-		.name = "VMAX301 Internal Flash",
-		.phys = NO_XIP,
-		.size = 3*2*1024*1024,
-		.bankwidth = 1,
-		.read = vmax301_read8,
-		.copy_from = vmax301_copy_from,
-		.write = vmax301_write8,
-		.copy_to = vmax301_copy_to,
-		.map_priv_1 = WINDOW_START + WINDOW_LENGTH,
-		.map_priv_2 = 0xFFFFFFFF
-	},
-	{
-		.name = "VMAX301 Socket",
-		.phys = NO_XIP,
-		.size = 0,
-		.bankwidth = 1,
-		.read = vmax301_read8,
-		.copy_from = vmax301_copy_from,
-		.write = vmax301_write8,
-		.copy_to = vmax301_copy_to,
-		.map_priv_1 = WINDOW_START + (3*WINDOW_LENGTH),
-		.map_priv_2 = 0xFFFFFFFF
-	}
-};
-
-static struct mtd_info *vmax_mtd[2] = {NULL, NULL};
-
-static void __exit cleanup_vmax301(void)
-{
-	int i;
-
-	for (i=0; i<2; i++) {
-		if (vmax_mtd[i]) {
-			mtd_device_unregister(vmax_mtd[i]);
-			map_destroy(vmax_mtd[i]);
-		}
-	}
-	iounmap((void *)vmax_map[0].map_priv_1 - WINDOW_START);
-}
-
-static int __init init_vmax301(void)
-{
-	int i;
-	unsigned long iomapadr;
-	// Print out our little header..
-	printk("Tempustech VMAX 301 MEM:0x%x-0x%x\n",WINDOW_START,
-	       WINDOW_START+4*WINDOW_LENGTH);
-
-	iomapadr = (unsigned long)ioremap(WINDOW_START, WINDOW_LENGTH*4);
-	if (!iomapadr) {
-		printk("Failed to ioremap memory region\n");
-		return -EIO;
-	}
-	/* Put the address in the map's private data area.
-	   We store the actual MTD IO address rather than the
-	   address of the first half, because it's used more
-	   often.
-	*/
-	vmax_map[0].map_priv_2 = iomapadr + WINDOW_START;
-	vmax_map[1].map_priv_2 = iomapadr + (3*WINDOW_START);
-
-	for (i=0; i<2; i++) {
-		vmax_mtd[i] = do_map_probe("cfi_probe", &vmax_map[i]);
-		if (!vmax_mtd[i])
-			vmax_mtd[i] = do_map_probe("jedec", &vmax_map[i]);
-		if (!vmax_mtd[i])
-			vmax_mtd[i] = do_map_probe("map_ram", &vmax_map[i]);
-		if (!vmax_mtd[i])
-			vmax_mtd[i] = do_map_probe("map_rom", &vmax_map[i]);
-		if (vmax_mtd[i]) {
-			vmax_mtd[i]->owner = THIS_MODULE;
-			mtd_device_register(vmax_mtd[i], NULL, 0);
-		}
-	}
-
-	if (!vmax_mtd[0] && !vmax_mtd[1]) {
-		iounmap((void *)iomapadr);
-		return -ENXIO;
-	}
-
-	return 0;
-}
-
-module_init(init_vmax301);
-module_exit(cleanup_vmax301);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
-MODULE_DESCRIPTION("MTD map driver for Tempustech VMAX SBC301 board");
-- 
1.7.11.7

