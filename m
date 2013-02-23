Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab3BWLch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 06:32:37 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:62166 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab3BWLce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 06:32:34 -0500
From: Takahisa Tanaka <mc74hc00@gmail.com>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Arkadiusz Miskiewicz <arekm@maven.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        Florian Mickler <florian@mickler.org>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Joseph Salisbury <josephtsalisbury@gmail.com>, stable@vger.kernel.org,
        Takahisa Tanaka <mc74hc00@gmail.com>
Subject: [PATCH] sp5100_tco: Remove code that may cause a boot failure
Date: Sat, 23 Feb 2013 20:31:52 +0900
Message-Id: <1361619112-7481-1-git-send-email-mc74hc00@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The critical problem which can't boot OS until the power is completely
cut off found on PC with SB700 chipset. This patch fix the problem, but,
this patch prevents the sp5100_tco driver from using watchdog timer
function of chipset on PC with SP5100 or SB7x0 chipset.

Re-programming the MMIO address registers for the watchdog timer must
have generated the problem. However, I don't know root cause so far.
So, I decided to remove the concerned codes.

Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1116835
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176

Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
---
 drivers/watchdog/sp5100_tco.c | 140 ++++--------------------------------------
 drivers/watchdog/sp5100_tco.h |   2 +-
 2 files changed, 14 insertions(+), 128 deletions(-)

diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index e3b8f75..eaf396b 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -40,13 +40,12 @@
 #include "sp5100_tco.h"
 
 /* Module and version information */
-#define TCO_VERSION "0.03"
+#define TCO_VERSION "0.05"
 #define TCO_MODULE_NAME "SP5100 TCO timer"
 #define TCO_DRIVER_NAME   TCO_MODULE_NAME ", v" TCO_VERSION
 
 /* internal variables */
 static u32 tcobase_phys;
-static u32 resbase_phys;
 static u32 tco_wdt_fired;
 static void __iomem *tcobase;
 static unsigned int pm_iobase;
@@ -54,10 +53,6 @@ static DEFINE_SPINLOCK(tco_lock);	/* Guards the hardware */
 static unsigned long timer_alive;
 static char tco_expect_close;
 static struct pci_dev *sp5100_tco_pci;
-static struct resource wdt_res = {
-	.name = "Watchdog Timer",
-	.flags = IORESOURCE_MEM,
-};
 
 /* the watchdog platform device */
 static struct platform_device *sp5100_tco_platform_device;
@@ -75,12 +70,6 @@ module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started."
 		" (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-static unsigned int force_addr;
-module_param(force_addr, uint, 0);
-MODULE_PARM_DESC(force_addr, "Force the use of specified MMIO address."
-		" ONLY USE THIS PARAMETER IF YOU REALLY KNOW"
-		" WHAT YOU ARE DOING (default=none)");
-
 /*
  * Some TCO specific functions
  */
@@ -176,39 +165,6 @@ static void tco_timer_enable(void)
 	}
 }
 
-static void tco_timer_disable(void)
-{
-	int val;
-
-	if (sp5100_tco_pci->revision >= 0x40) {
-		/* For SB800 or later */
-		/* Enable watchdog decode bit and Disable watchdog timer */
-		outb(SB800_PM_WATCHDOG_CONTROL, SB800_IO_PM_INDEX_REG);
-		val = inb(SB800_IO_PM_DATA_REG);
-		val |= SB800_PCI_WATCHDOG_DECODE_EN;
-		val |= SB800_PM_WATCHDOG_DISABLE;
-		outb(val, SB800_IO_PM_DATA_REG);
-	} else {
-		/* For SP5100 or SB7x0 */
-		/* Enable watchdog decode bit */
-		pci_read_config_dword(sp5100_tco_pci,
-				      SP5100_PCI_WATCHDOG_MISC_REG,
-				      &val);
-
-		val |= SP5100_PCI_WATCHDOG_DECODE_EN;
-
-		pci_write_config_dword(sp5100_tco_pci,
-				       SP5100_PCI_WATCHDOG_MISC_REG,
-				       val);
-
-		/* Disable Watchdog timer */
-		outb(SP5100_PM_WATCHDOG_CONTROL, SP5100_IO_PM_INDEX_REG);
-		val = inb(SP5100_IO_PM_DATA_REG);
-		val |= SP5100_PM_WATCHDOG_DISABLE;
-		outb(val, SP5100_IO_PM_DATA_REG);
-	}
-}
-
 /*
  *	/dev/watchdog handling
  */
@@ -361,7 +317,7 @@ static unsigned char sp5100_tco_setupdevice(void)
 {
 	struct pci_dev *dev = NULL;
 	const char *dev_name = NULL;
-	u32 val, tmp_val;
+	u32 val;
 	u32 index_reg, data_reg, base_addr;
 
 	/* Match the PCI device */
@@ -395,7 +351,7 @@ static unsigned char sp5100_tco_setupdevice(void)
 	/* Request the IO ports used by this driver */
 	pm_iobase = SP5100_IO_PM_INDEX_REG;
 	if (!request_region(pm_iobase, SP5100_PM_IOPORTS_SIZE, dev_name)) {
-		pr_err("I/O address 0x%04x already in use\n", pm_iobase);
+		pr_info("I/O address 0x%04x already in use\n", pm_iobase);
 		goto exit;
 	}
 
@@ -412,14 +368,14 @@ static unsigned char sp5100_tco_setupdevice(void)
 	/* Low three bits of BASE are reserved */
 	val = val << 8 | (inb(data_reg) & 0xf8);
 
-	pr_debug("Got 0x%04x from indirect I/O\n", val);
+	pr_debug("Got 0x%08x from indirect I/O\n", val);
 
 	/* Check MMIO address conflict */
 	if (request_mem_region_exclusive(val, SP5100_WDT_MEM_MAP_SIZE,
 								dev_name))
 		goto setup_wdt;
 	else
-		pr_debug("MMIO address 0x%04x already in use\n", val);
+		pr_info("MMIO address 0x%08x already in use\n", val);
 
 	/*
 	 * Secondly, Find the watchdog timer MMIO address
@@ -451,71 +407,16 @@ static unsigned char sp5100_tco_setupdevice(void)
 		/* Check MMIO address conflict */
 		if (request_mem_region_exclusive(val, SP5100_WDT_MEM_MAP_SIZE,
 								   dev_name)) {
-			pr_debug("Got 0x%04x from SBResource_MMIO register\n",
+			pr_debug("Got 0x%08x from SBResource_MMIO register\n",
 				val);
 			goto setup_wdt;
 		} else
-			pr_debug("MMIO address 0x%04x already in use\n", val);
+			pr_info("MMIO address 0x%08x already in use\n", val);
 	} else
-		pr_debug("SBResource_MMIO is disabled(0x%04x)\n", val);
+		pr_info("SBResource_MMIO is disabled (0x%08x)\n", val);
 
-	/*
-	 * Lastly re-programming the watchdog timer MMIO address,
-	 * This method is a last resort...
-	 *
-	 * Before re-programming, to ensure that the watchdog timer
-	 * is disabled, disable the watchdog timer.
-	 */
-	tco_timer_disable();
-
-	if (force_addr) {
-		/*
-		 * Force the use of watchdog timer MMIO address, and aligned to
-		 * 8byte boundary.
-		 */
-		force_addr &= ~0x7;
-		val = force_addr;
-
-		pr_info("Force the use of 0x%04x as MMIO address\n", val);
-	} else {
-		/*
-		 * Get empty slot into the resource tree for watchdog timer.
-		 */
-		if (allocate_resource(&iomem_resource,
-				      &wdt_res,
-				      SP5100_WDT_MEM_MAP_SIZE,
-				      0xf0000000,
-				      0xfffffff8,
-				      0x8,
-				      NULL,
-				      NULL)) {
-			pr_err("MMIO allocation failed\n");
-			goto unreg_region;
-		}
-
-		val = resbase_phys = wdt_res.start;
-		pr_debug("Got 0x%04x from resource tree\n", val);
-	}
-
-	/* Restore to the low three bits */
-	outb(base_addr+0, index_reg);
-	tmp_val = val | (inb(data_reg) & 0x7);
-
-	/* Re-programming the watchdog timer base address */
-	outb(base_addr+0, index_reg);
-	outb((tmp_val >>  0) & 0xff, data_reg);
-	outb(base_addr+1, index_reg);
-	outb((tmp_val >>  8) & 0xff, data_reg);
-	outb(base_addr+2, index_reg);
-	outb((tmp_val >> 16) & 0xff, data_reg);
-	outb(base_addr+3, index_reg);
-	outb((tmp_val >> 24) & 0xff, data_reg);
-
-	if (!request_mem_region_exclusive(val, SP5100_WDT_MEM_MAP_SIZE,
-								   dev_name)) {
-		pr_err("MMIO address 0x%04x already in use\n", val);
-		goto unreg_resource;
-	}
+	pr_notice("Can't find MMIO address, giving up.\n");
+	goto  unreg_region;
 
 setup_wdt:
 	tcobase_phys = val;
@@ -526,7 +427,7 @@ setup_wdt:
 		goto unreg_mem_region;
 	}
 
-	pr_info("Using 0x%04x for watchdog MMIO address\n", val);
+	pr_info("Using 0x%08x for watchdog MMIO address\n", val);
 
 	/* Setup the watchdog timer */
 	tco_timer_enable();
@@ -555,9 +456,6 @@ setup_wdt:
 
 unreg_mem_region:
 	release_mem_region(tcobase_phys, SP5100_WDT_MEM_MAP_SIZE);
-unreg_resource:
-	if (resbase_phys)
-		release_resource(&wdt_res);
 unreg_region:
 	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
 exit:
@@ -567,7 +465,6 @@ exit:
 static int sp5100_tco_init(struct platform_device *dev)
 {
 	int ret;
-	char addr_str[16];
 
 	/*
 	 * Check whether or not the hardware watchdog is there. If found, then
@@ -599,23 +496,14 @@ static int sp5100_tco_init(struct platform_device *dev)
 	clear_bit(0, &timer_alive);
 
 	/* Show module parameters */
-	if (force_addr == tcobase_phys)
-		/* The force_addr is vaild */
-		sprintf(addr_str, "0x%04x", force_addr);
-	else
-		strcpy(addr_str, "none");
-
-	pr_info("initialized (0x%p). heartbeat=%d sec (nowayout=%d, "
-		"force_addr=%s)\n",
-		tcobase, heartbeat, nowayout, addr_str);
+	pr_info("initialized (0x%p). heartbeat=%d sec (nowayout=%d)\n",
+		tcobase, heartbeat, nowayout);
 
 	return 0;
 
 exit:
 	iounmap(tcobase);
 	release_mem_region(tcobase_phys, SP5100_WDT_MEM_MAP_SIZE);
-	if (resbase_phys)
-		release_resource(&wdt_res);
 	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
 	return ret;
 }
@@ -630,8 +518,6 @@ static void sp5100_tco_cleanup(void)
 	misc_deregister(&sp5100_tco_miscdev);
 	iounmap(tcobase);
 	release_mem_region(tcobase_phys, SP5100_WDT_MEM_MAP_SIZE);
-	if (resbase_phys)
-		release_resource(&wdt_res);
 	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
 }
 
diff --git a/drivers/watchdog/sp5100_tco.h b/drivers/watchdog/sp5100_tco.h
index 71594a0..2b28c00 100644
--- a/drivers/watchdog/sp5100_tco.h
+++ b/drivers/watchdog/sp5100_tco.h
@@ -57,7 +57,7 @@
 #define SB800_PM_WATCHDOG_DISABLE	(1 << 2)
 #define SB800_PM_WATCHDOG_SECOND_RES	(3 << 0)
 #define SB800_ACPI_MMIO_DECODE_EN	(1 << 0)
-#define SB800_ACPI_MMIO_SEL		(1 << 2)
+#define SB800_ACPI_MMIO_SEL		(1 << 1)
 
 
 #define SB800_PM_WDT_MMIO_OFFSET	0xB00
-- 
1.8.1.2

