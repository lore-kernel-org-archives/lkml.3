Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018Ab3DCPZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:25:52 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:53252 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760662Ab3DCPZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:25:50 -0400
Date: Wed, 3 Apr 2013 17:25:34 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.9-rc6
Message-ID: <20130403172534.528d04c5@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040315-3548-0000-0000-000004FA4FAC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates: Just a bunch of bugfixes.

Heiko Carstens (4):
      drivers/Kconfig: add several missing GENERIC_HARDIRQS dependencies
      s390/uaccess: fix clear_user_pt()
      s390/uaccess: fix page table walk
      s390/mm: provide emtpy check_pgt_cache() function

Martin Schwidefsky (1):
      s390/3270: fix minor_start issue

Sebastian Ott (1):
      s390/scm_block: fix printk format string

Wei Yongjun (1):
      s390/scm_blk: fix error return code in scm_blk_init()

 arch/s390/include/asm/pgtable.h |    4 +-
 arch/s390/lib/uaccess_pt.c      |   83 ++++++++++++++++++++++++++-------------
 drivers/dma/Kconfig             |    1 +
 drivers/media/platform/Kconfig  |    2 +-
 drivers/s390/block/scm_blk.c    |   11 ++++--
 drivers/s390/block/scm_drv.c    |    2 +-
 drivers/s390/char/tty3270.c     |   16 ++++----
 drivers/spi/Kconfig             |    3 +-
 8 files changed, 79 insertions(+), 43 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 4a29308..4a54431 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -344,6 +344,7 @@ extern unsigned long MODULES_END;
 #define _REGION3_ENTRY_CO	0x100	/* change-recording override	    */
 
 /* Bits in the segment table entry */
+#define _SEGMENT_ENTRY_ORIGIN_LARGE ~0xfffffUL /* large page address	    */
 #define _SEGMENT_ENTRY_ORIGIN	~0x7ffUL/* segment table origin		    */
 #define _SEGMENT_ENTRY_RO	0x200	/* page protection bit		    */
 #define _SEGMENT_ENTRY_INV	0x20	/* invalid segment table entry	    */
@@ -1531,7 +1532,8 @@ extern int s390_enable_sie(void);
 /*
  * No page table caches to initialise
  */
-#define pgtable_cache_init()	do { } while (0)
+static inline void pgtable_cache_init(void) { }
+static inline void check_pgt_cache(void) { }
 
 #include <asm-generic/pgtable.h>
 
diff --git a/arch/s390/lib/uaccess_pt.c b/arch/s390/lib/uaccess_pt.c
index dff631d..466fb33 100644
--- a/arch/s390/lib/uaccess_pt.c
+++ b/arch/s390/lib/uaccess_pt.c
@@ -77,42 +77,69 @@ static size_t copy_in_kernel(size_t count, void __user *to,
  * >= -4095 (IS_ERR_VALUE(x) returns true), a fault has occured and the address
  * contains the (negative) exception code.
  */
-static __always_inline unsigned long follow_table(struct mm_struct *mm,
-						  unsigned long addr, int write)
+#ifdef CONFIG_64BIT
+static unsigned long follow_table(struct mm_struct *mm,
+				  unsigned long address, int write)
 {
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *ptep;
+	unsigned long *table = (unsigned long *)__pa(mm->pgd);
+
+	switch (mm->context.asce_bits & _ASCE_TYPE_MASK) {
+	case _ASCE_TYPE_REGION1:
+		table = table + ((address >> 53) & 0x7ff);
+		if (unlikely(*table & _REGION_ENTRY_INV))
+			return -0x39UL;
+		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
+	case _ASCE_TYPE_REGION2:
+		table = table + ((address >> 42) & 0x7ff);
+		if (unlikely(*table & _REGION_ENTRY_INV))
+			return -0x3aUL;
+		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
+	case _ASCE_TYPE_REGION3:
+		table = table + ((address >> 31) & 0x7ff);
+		if (unlikely(*table & _REGION_ENTRY_INV))
+			return -0x3bUL;
+		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
+	case _ASCE_TYPE_SEGMENT:
+		table = table + ((address >> 20) & 0x7ff);
+		if (unlikely(*table & _SEGMENT_ENTRY_INV))
+			return -0x10UL;
+		if (unlikely(*table & _SEGMENT_ENTRY_LARGE)) {
+			if (write && (*table & _SEGMENT_ENTRY_RO))
+				return -0x04UL;
+			return (*table & _SEGMENT_ENTRY_ORIGIN_LARGE) +
+				(address & ~_SEGMENT_ENTRY_ORIGIN_LARGE);
+		}
+		table = (unsigned long *)(*table & _SEGMENT_ENTRY_ORIGIN);
+	}
+	table = table + ((address >> 12) & 0xff);
+	if (unlikely(*table & _PAGE_INVALID))
+		return -0x11UL;
+	if (write && (*table & _PAGE_RO))
+		return -0x04UL;
+	return (*table & PAGE_MASK) + (address & ~PAGE_MASK);
+}
 
-	pgd = pgd_offset(mm, addr);
-	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
-		return -0x3aUL;
+#else /* CONFIG_64BIT */
 
-	pud = pud_offset(pgd, addr);
-	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
-		return -0x3bUL;
+static unsigned long follow_table(struct mm_struct *mm,
+				  unsigned long address, int write)
+{
+	unsigned long *table = (unsigned long *)__pa(mm->pgd);
 
-	pmd = pmd_offset(pud, addr);
-	if (pmd_none(*pmd))
+	table = table + ((address >> 20) & 0x7ff);
+	if (unlikely(*table & _SEGMENT_ENTRY_INV))
 		return -0x10UL;
-	if (pmd_large(*pmd)) {
-		if (write && (pmd_val(*pmd) & _SEGMENT_ENTRY_RO))
-			return -0x04UL;
-		return (pmd_val(*pmd) & HPAGE_MASK) + (addr & ~HPAGE_MASK);
-	}
-	if (unlikely(pmd_bad(*pmd)))
-		return -0x10UL;
-
-	ptep = pte_offset_map(pmd, addr);
-	if (!pte_present(*ptep))
+	table = (unsigned long *)(*table & _SEGMENT_ENTRY_ORIGIN);
+	table = table + ((address >> 12) & 0xff);
+	if (unlikely(*table & _PAGE_INVALID))
 		return -0x11UL;
-	if (write && (!pte_write(*ptep) || !pte_dirty(*ptep)))
+	if (write && (*table & _PAGE_RO))
 		return -0x04UL;
-
-	return (pte_val(*ptep) & PAGE_MASK) + (addr & ~PAGE_MASK);
+	return (*table & PAGE_MASK) + (address & ~PAGE_MASK);
 }
 
+#endif /* CONFIG_64BIT */
+
 static __always_inline size_t __user_copy_pt(unsigned long uaddr, void *kptr,
 					     size_t n, int write_user)
 {
@@ -197,7 +224,7 @@ size_t copy_to_user_pt(size_t n, void __user *to, const void *from)
 
 static size_t clear_user_pt(size_t n, void __user *to)
 {
-	void *zpage = &empty_zero_page;
+	void *zpage = (void *) empty_zero_page;
 	long done, size, ret;
 
 	done = 0;
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 80b6997..aeaea32 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -83,6 +83,7 @@ config INTEL_IOP_ADMA
 
 config DW_DMAC
 	tristate "Synopsys DesignWare AHB DMA support"
+	depends on GENERIC_HARDIRQS
 	select DMA_ENGINE
 	default y if CPU_AT32AP7000
 	help
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 05d7b63..a0639e7 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -204,7 +204,7 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 
 config VIDEO_SH_VEU
 	tristate "SuperH VEU mem2mem video processing driver"
-	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on VIDEO_DEV && VIDEO_V4L2 && GENERIC_HARDIRQS
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index 5ac9c93..e9b9c83 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -307,7 +307,7 @@ static void scm_blk_handle_error(struct scm_request *scmrq)
 	case EQC_WR_PROHIBIT:
 		spin_lock_irqsave(&bdev->lock, flags);
 		if (bdev->state != SCM_WR_PROHIBIT)
-			pr_info("%lu: Write access to the SCM increment is suspended\n",
+			pr_info("%lx: Write access to the SCM increment is suspended\n",
 				(unsigned long) bdev->scmdev->address);
 		bdev->state = SCM_WR_PROHIBIT;
 		spin_unlock_irqrestore(&bdev->lock, flags);
@@ -445,7 +445,7 @@ void scm_blk_set_available(struct scm_blk_dev *bdev)
 
 	spin_lock_irqsave(&bdev->lock, flags);
 	if (bdev->state == SCM_WR_PROHIBIT)
-		pr_info("%lu: Write access to the SCM increment is restored\n",
+		pr_info("%lx: Write access to the SCM increment is restored\n",
 			(unsigned long) bdev->scmdev->address);
 	bdev->state = SCM_OPER;
 	spin_unlock_irqrestore(&bdev->lock, flags);
@@ -463,12 +463,15 @@ static int __init scm_blk_init(void)
 		goto out;
 
 	scm_major = ret;
-	if (scm_alloc_rqs(nr_requests))
+	ret = scm_alloc_rqs(nr_requests);
+	if (ret)
 		goto out_unreg;
 
 	scm_debug = debug_register("scm_log", 16, 1, 16);
-	if (!scm_debug)
+	if (!scm_debug) {
+		ret = -ENOMEM;
 		goto out_free;
+	}
 
 	debug_register_view(scm_debug, &debug_hex_ascii_view);
 	debug_set_level(scm_debug, 2);
diff --git a/drivers/s390/block/scm_drv.c b/drivers/s390/block/scm_drv.c
index 5f6180d..c98cf52 100644
--- a/drivers/s390/block/scm_drv.c
+++ b/drivers/s390/block/scm_drv.c
@@ -19,7 +19,7 @@ static void scm_notify(struct scm_device *scmdev, enum scm_event event)
 
 	switch (event) {
 	case SCM_CHANGE:
-		pr_info("%lu: The capabilities of the SCM increment changed\n",
+		pr_info("%lx: The capabilities of the SCM increment changed\n",
 			(unsigned long) scmdev->address);
 		SCM_LOG(2, "State changed");
 		SCM_LOG_STATE(2, scmdev);
diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index b907dba..cee69da 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -915,7 +915,7 @@ static int tty3270_install(struct tty_driver *driver, struct tty_struct *tty)
 	int i, rc;
 
 	/* Check if the tty3270 is already there. */
-	view = raw3270_find_view(&tty3270_fn, tty->index);
+	view = raw3270_find_view(&tty3270_fn, tty->index + RAW3270_FIRSTMINOR);
 	if (!IS_ERR(view)) {
 		tp = container_of(view, struct tty3270, view);
 		tty->driver_data = tp;
@@ -927,15 +927,16 @@ static int tty3270_install(struct tty_driver *driver, struct tty_struct *tty)
 		tp->inattr = TF_INPUT;
 		return tty_port_install(&tp->port, driver, tty);
 	}
-	if (tty3270_max_index < tty->index)
-		tty3270_max_index = tty->index;
+	if (tty3270_max_index < tty->index + 1)
+		tty3270_max_index = tty->index + 1;
 
 	/* Allocate tty3270 structure on first open. */
 	tp = tty3270_alloc_view();
 	if (IS_ERR(tp))
 		return PTR_ERR(tp);
 
-	rc = raw3270_add_view(&tp->view, &tty3270_fn, tty->index);
+	rc = raw3270_add_view(&tp->view, &tty3270_fn,
+			      tty->index + RAW3270_FIRSTMINOR);
 	if (rc) {
 		tty3270_free_view(tp);
 		return rc;
@@ -1846,12 +1847,12 @@ static const struct tty_operations tty3270_ops = {
 
 void tty3270_create_cb(int minor)
 {
-	tty_register_device(tty3270_driver, minor, NULL);
+	tty_register_device(tty3270_driver, minor - RAW3270_FIRSTMINOR, NULL);
 }
 
 void tty3270_destroy_cb(int minor)
 {
-	tty_unregister_device(tty3270_driver, minor);
+	tty_unregister_device(tty3270_driver, minor - RAW3270_FIRSTMINOR);
 }
 
 struct raw3270_notifier tty3270_notifier =
@@ -1884,7 +1885,8 @@ static int __init tty3270_init(void)
 	driver->driver_name = "tty3270";
 	driver->name = "3270/tty";
 	driver->major = IBM_TTY3270_MAJOR;
-	driver->minor_start = 0;
+	driver->minor_start = RAW3270_FIRSTMINOR;
+	driver->name_base = RAW3270_FIRSTMINOR;
 	driver->type = TTY_DRIVER_TYPE_SYSTEM;
 	driver->subtype = SYSTEM_TYPE_TTY;
 	driver->init_termios = tty_std_termios;
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index f80eee7..2be0de9 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -55,6 +55,7 @@ comment "SPI Master Controller Drivers"
 
 config SPI_ALTERA
 	tristate "Altera SPI Controller"
+	depends on GENERIC_HARDIRQS
 	select SPI_BITBANG
 	help
 	  This is the driver for the Altera SPI Controller.
@@ -310,7 +311,7 @@ config SPI_PXA2XX_DMA
 
 config SPI_PXA2XX
 	tristate "PXA2xx SSP SPI master"
-	depends on ARCH_PXA || PCI || ACPI
+	depends on (ARCH_PXA || PCI || ACPI) && GENERIC_HARDIRQS
 	select PXA_SSP if ARCH_PXA
 	help
 	  This enables using a PXA2xx or Sodaville SSP port as a SPI master

