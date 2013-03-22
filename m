Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423461Ab3CVW1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 18:27:55 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:40326 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422648Ab3CVW1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 18:27:53 -0400
Date: Fri, 22 Mar 2013 23:27:50 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Takahisa Tanaka <mc74hc00@gmail.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>
Subject: [GIT PULL REQUEST] watchdog - v3.9-rc4 Fixes
Message-ID: <20130322222750.GF7867@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

It will fix a boot issues and correct the AcpiMmioSel bitmask in the
sp5100_tco watchdog device driver.

This will update the following files:

 sp5100_tco.c |  126 ++---------------------------------------------------------
 sp5100_tco.h |    2 
 2 files changed, 7 insertions(+), 121 deletions(-)

with these Changes:

commit 81fc933f176cd95f757bfc8a98109ef422598b79
Author: Takahisa Tanaka <mc74hc00@gmail.com>
Date:   Sun Mar 3 14:48:00 2013 +0900

    watchdog: sp5100_tco: Set the AcpiMmioSel bitmask value to 1 instead of 2
    
    The AcpiMmioSel bit is bit 1 in the AcpiMmioEn register, but the current
    sp5100_tco driver is using bit 2.
    
    See 2.3.3 Power Management (PM) Registers page 150 of the
    AMD SB800-Series Southbridges Register Reference Guide [1].
    
            AcpiMmioEn - RW – 8/16/32 bits - [PM_Reg: 24h]
            Field Name        Bits  Default  Description
            AcpiMMioDecodeEn  0     0b       Set to 1 to enable AcpiMMio space.
            AcpiMMIoSel       1     0b       Set AcpiMMio registers to be memory-mapped or IO-mapped space.
                                             0: Memory-mapped space
                                             1: I/O-mapped space
    
    The sp5100_tco driver expects zero as a value of AcpiMmioSel (bit 1).
    
    Fortunately, no problems were caused by this typo, because the default
    value of the undocumented misused bit 2 seems to be zero.
    
    However, the sp5100_tco driver should use the correct bitmask value.
    
    [1] http://support.amd.com/us/Embedded_TechDocs/45482.pdf
    
    Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
    Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: stable <stable@vger.kernel.org>

commit 18e4321276fcf083b85b788fee7cf15be29ed72a
Author: Takahisa Tanaka <mc74hc00@gmail.com>
Date:   Sun Mar 3 14:52:07 2013 +0900

    watchdog: sp5100_tco: Remove code that may cause a boot failure
    
    A problem was found on PC's with the SB700 chipset: The PC fails to
    load BIOS after running the 3.8.x kernel until the power is completely
    cut off. It occurs in all 3.8.x versions and the mainline version as of
    2/4. The issue does not occur with the 3.7.x builds.
    
    There are two methods for accessing the watchdog registers.
    
     1. Re-programming a resource address obtained by allocate_resource()
    to chipset.
     2. Use the direct memory-mapped IO access.
    
    The method 1 can be used by all the chipsets (SP5100, SB7x0, SB8x0 or
    later). However, experience shows that only PC with the SB8x0 (or
    later) chipsets can use the method 2.
    
    This patch removes the method 1, because the critical problem was found.
    That's why the watchdog timer was able to be used on SP5100 and SB7x0
    chipsets until now.
    
    Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1116835
    Link: https://lkml.org/lkml/2013/2/14/271
    
    Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: stable <stable@vger.kernel.org>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index e3b8f75..0e9d8c4 100644
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
@@ -459,63 +415,8 @@ static unsigned char sp5100_tco_setupdevice(void)
 	} else
 		pr_debug("SBResource_MMIO is disabled(0x%04x)\n", val);
 
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
+	pr_notice("failed to find MMIO address, giving up.\n");
+	goto  unreg_region;
 
 setup_wdt:
 	tcobase_phys = val;
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
