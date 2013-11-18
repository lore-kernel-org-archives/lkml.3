Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab3KRJFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:05:15 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:32877 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3KRJFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:05:05 -0500
Date: Mon, 18 Nov 2013 10:04:56 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for  the 3.13 merge window #2
Message-ID: <20131118100456.40acbcee@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111809-0342-0000-0000-000006E3F61F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
The second set of s390 patches for the 3.13 merge window.

The handling of the PCI hotplug notifications has been improved,
the zfcp dumper can now detect the HSA size dynamically and the
default install kernel has been changed to the compressed bzImage.
And two bug-fixes for scm and 3720.

Hendrik Brueckner (2):
      s390/boot: Install bzImage as default kernel image
      s390/3270: fix missing device_destroy() call

Michael Holzheu (4):
      s390/sclp: Move declarations for sclp_sdias into separate header file
      s390/sclp: Determine HSA size dynamically for zfcpdump
      s390/sclp: Move early code from sclp_cmd.c to sclp_early.c
      s390/sclp: Consolidate early sclp init calls to sclp_early_detect()

Sebastian Ott (4):
      s390/pci: improve handling of bus resources
      s390/pci: implement pcibios_remove_bus
      s390/scm_block: do not hide eadm subchannel dependency
      s390/pci: implement hotplug notifications

 arch/s390/boot/Makefile              |    4 +-
 arch/s390/include/asm/ctl_reg.h      |    2 +
 arch/s390/include/asm/eadm.h         |   13 +-
 arch/s390/include/asm/pci.h          |    6 +-
 arch/s390/include/asm/sclp.h         |    3 +-
 arch/s390/include/asm/setup.h        |    3 -
 arch/s390/kernel/crash_dump.c        |   22 +--
 arch/s390/kernel/early.c             |    2 +-
 arch/s390/kernel/setup.c             |    7 +-
 arch/s390/pci/pci.c                  |  202 ++++++++++++++------------
 arch/s390/pci/pci_clp.c              |    8 +-
 arch/s390/pci/pci_event.c            |   79 ++++++----
 drivers/s390/block/scm_blk.c         |   24 +---
 drivers/s390/block/scm_blk_cluster.c |    2 +-
 drivers/s390/char/Makefile           |    3 +-
 drivers/s390/char/fs3270.c           |    1 +
 drivers/s390/char/sclp.h             |    5 +
 drivers/s390/char/sclp_cmd.c         |  180 ++---------------------
 drivers/s390/char/sclp_early.c       |  264 ++++++++++++++++++++++++++++++++++
 drivers/s390/char/sclp_sdias.c       |   78 +++-------
 drivers/s390/char/sclp_sdias.h       |   46 ++++++
 drivers/s390/char/zcore.c            |   22 +--
 drivers/s390/cio/eadm_sch.c          |   10 +-
 drivers/s390/cio/scm.c               |   45 ------
 24 files changed, 562 insertions(+), 469 deletions(-)
 create mode 100644 drivers/s390/char/sclp_early.c
 create mode 100644 drivers/s390/char/sclp_sdias.h

diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
index f2737a0..9a42ece 100644
--- a/arch/s390/boot/Makefile
+++ b/arch/s390/boot/Makefile
@@ -21,6 +21,6 @@ $(obj)/bzImage: $(obj)/compressed/vmlinux FORCE
 $(obj)/compressed/vmlinux: FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/compressed $@
 
-install: $(CONFIGURE) $(obj)/image
-	sh -x  $(srctree)/$(obj)/install.sh $(KERNELRELEASE) $(obj)/image \
+install: $(CONFIGURE) $(obj)/bzImage
+	sh -x  $(srctree)/$(obj)/install.sh $(KERNELRELEASE) $(obj)/bzImage \
 	      System.map "$(INSTALL_PATH)"
diff --git a/arch/s390/include/asm/ctl_reg.h b/arch/s390/include/asm/ctl_reg.h
index 9b69c0b..4e63f1a 100644
--- a/arch/s390/include/asm/ctl_reg.h
+++ b/arch/s390/include/asm/ctl_reg.h
@@ -7,6 +7,8 @@
 #ifndef __ASM_CTL_REG_H
 #define __ASM_CTL_REG_H
 
+#include <linux/bug.h>
+
 #ifdef CONFIG_64BIT
 # define __CTL_LOAD	"lctlg"
 # define __CTL_STORE	"stctg"
diff --git a/arch/s390/include/asm/eadm.h b/arch/s390/include/asm/eadm.h
index dc9200c..6702630 100644
--- a/arch/s390/include/asm/eadm.h
+++ b/arch/s390/include/asm/eadm.h
@@ -111,18 +111,7 @@ struct scm_driver {
 int scm_driver_register(struct scm_driver *scmdrv);
 void scm_driver_unregister(struct scm_driver *scmdrv);
 
-int scm_start_aob(struct aob *aob);
+int eadm_start_aob(struct aob *aob);
 void scm_irq_handler(struct aob *aob, int error);
 
-struct eadm_ops {
-	int (*eadm_start) (struct aob *aob);
-	struct module *owner;
-};
-
-int scm_get_ref(void);
-void scm_put_ref(void);
-
-void register_eadm_ops(struct eadm_ops *ops);
-void unregister_eadm_ops(struct eadm_ops *ops);
-
 #endif /* _ASM_S390_EADM_H */
diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 1cc185d..c129ab2 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -63,9 +63,10 @@ enum zpci_state {
 };
 
 struct zpci_bar_struct {
+	struct resource *res;		/* bus resource */
 	u32		val;		/* bar start & 3 flag bits */
-	u8		size;		/* order 2 exponent */
 	u16		map_idx;	/* index into bar mapping array */
+	u8		size;		/* order 2 exponent */
 };
 
 /* Private data per function */
@@ -97,6 +98,7 @@ struct zpci_dev {
 	unsigned long	iommu_pages;
 	unsigned int	next_bit;
 
+	char res_name[16];
 	struct zpci_bar_struct bars[PCI_BAR_COUNT];
 
 	u64		start_dma;	/* Start of available DMA addresses */
@@ -122,12 +124,10 @@ static inline bool zdev_enabled(struct zpci_dev *zdev)
   Prototypes
 ----------------------------------------------------------------------------- */
 /* Base stuff */
-struct zpci_dev *zpci_alloc_device(void);
 int zpci_create_device(struct zpci_dev *);
 int zpci_enable_device(struct zpci_dev *);
 int zpci_disable_device(struct zpci_dev *);
 void zpci_stop_device(struct zpci_dev *);
-void zpci_free_device(struct zpci_dev *);
 int zpci_register_ioat(struct zpci_dev *, u8, u64, u64, u64);
 int zpci_unregister_ioat(struct zpci_dev *, u8);
 
diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
index 7dc7f9c..30ef748 100644
--- a/arch/s390/include/asm/sclp.h
+++ b/arch/s390/include/asm/sclp.h
@@ -43,7 +43,6 @@ struct sclp_cpu_info {
 int sclp_get_cpu_info(struct sclp_cpu_info *info);
 int sclp_cpu_configure(u8 cpu);
 int sclp_cpu_deconfigure(u8 cpu);
-void sclp_facilities_detect(void);
 unsigned long long sclp_get_rnmax(void);
 unsigned long long sclp_get_rzm(void);
 int sclp_sdias_blk_count(void);
@@ -57,5 +56,7 @@ bool sclp_has_vt220(void);
 int sclp_pci_configure(u32 fid);
 int sclp_pci_deconfigure(u32 fid);
 int memcpy_hsa(void *dest, unsigned long src, size_t count, int mode);
+unsigned long sclp_get_hsa_size(void);
+void sclp_early_detect(void);
 
 #endif /* _ASM_S390_SCLP_H */
diff --git a/arch/s390/include/asm/setup.h b/arch/s390/include/asm/setup.h
index df802ee..94cfbe4 100644
--- a/arch/s390/include/asm/setup.h
+++ b/arch/s390/include/asm/setup.h
@@ -107,9 +107,6 @@ void create_mem_hole(struct mem_chunk mem_chunk[], unsigned long addr,
 #define MACHINE_HAS_RRBM	(S390_lowcore.machine_flags & MACHINE_FLAG_RRBM)
 #endif /* CONFIG_64BIT */
 
-#define ZFCPDUMP_HSA_SIZE	(32UL<<20)
-#define ZFCPDUMP_HSA_SIZE_MAX	(64UL<<20)
-
 /*
  * Console mode. Override with conmode=
  */
diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index f45b2ab..d7658c4 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -95,7 +95,7 @@ static void *elfcorehdr_newmem;
 /*
  * Copy one page from zfcpdump "oldmem"
  *
- * For pages below ZFCPDUMP_HSA_SIZE memory from the HSA is copied. Otherwise
+ * For pages below HSA size memory from the HSA is copied. Otherwise
  * real memory copy is used.
  */
 static ssize_t copy_oldmem_page_zfcpdump(char *buf, size_t csize,
@@ -103,7 +103,7 @@ static ssize_t copy_oldmem_page_zfcpdump(char *buf, size_t csize,
 {
 	int rc;
 
-	if (src < ZFCPDUMP_HSA_SIZE) {
+	if (src < sclp_get_hsa_size()) {
 		rc = memcpy_hsa(buf, src, csize, userbuf);
 	} else {
 		if (userbuf)
@@ -188,18 +188,19 @@ static int remap_oldmem_pfn_range_kdump(struct vm_area_struct *vma,
 /*
  * Remap "oldmem" for zfcpdump
  *
- * We only map available memory above ZFCPDUMP_HSA_SIZE. Memory below
- * ZFCPDUMP_HSA_SIZE is read on demand using the copy_oldmem_page() function.
+ * We only map available memory above HSA size. Memory below HSA size
+ * is read on demand using the copy_oldmem_page() function.
  */
 static int remap_oldmem_pfn_range_zfcpdump(struct vm_area_struct *vma,
 					   unsigned long from,
 					   unsigned long pfn,
 					   unsigned long size, pgprot_t prot)
 {
+	unsigned long hsa_end = sclp_get_hsa_size();
 	unsigned long size_hsa;
 
-	if (pfn < ZFCPDUMP_HSA_SIZE >> PAGE_SHIFT) {
-		size_hsa = min(size, ZFCPDUMP_HSA_SIZE - (pfn << PAGE_SHIFT));
+	if (pfn < hsa_end >> PAGE_SHIFT) {
+		size_hsa = min(size, hsa_end - (pfn << PAGE_SHIFT));
 		if (size == size_hsa)
 			return 0;
 		size -= size_hsa;
@@ -238,9 +239,9 @@ int copy_from_oldmem(void *dest, void *src, size_t count)
 				return rc;
 		}
 	} else {
-		if ((unsigned long) src < ZFCPDUMP_HSA_SIZE) {
-			copied = min(count,
-				     ZFCPDUMP_HSA_SIZE - (unsigned long) src);
+		unsigned long hsa_end = sclp_get_hsa_size();
+		if ((unsigned long) src < hsa_end) {
+			copied = min(count, hsa_end - (unsigned long) src);
 			rc = memcpy_hsa(dest, (unsigned long) src, copied, 0);
 			if (rc)
 				return rc;
@@ -580,6 +581,9 @@ int elfcorehdr_alloc(unsigned long long *addr, unsigned long long *size)
 	/* If elfcorehdr= has been passed via cmdline, we use that one */
 	if (elfcorehdr_addr != ELFCORE_ADDR_MAX)
 		return 0;
+	/* If we cannot get HSA size for zfcpdump return error */
+	if (ipl_info.type == IPL_TYPE_FCP_DUMP && !sclp_get_hsa_size())
+		return -ENODEV;
 	mem_chunk_cnt = get_mem_chunk_cnt();
 
 	alloc_size = 0x1000 + get_cpu_cnt() * 0x300 +
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 96543ac..fca20b5 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -483,7 +483,7 @@ void __init startup_init(void)
 	detect_diag44();
 	detect_machine_facilities();
 	setup_topology();
-	sclp_facilities_detect();
+	sclp_early_detect();
 #ifdef CONFIG_DYNAMIC_FTRACE
 	S390_lowcore.ftrace_func = (unsigned long)ftrace_caller;
 #endif
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index ffe1c53..4444875 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -471,8 +471,9 @@ static void __init setup_memory_end(void)
 
 
 #ifdef CONFIG_ZFCPDUMP
-	if (ipl_info.type == IPL_TYPE_FCP_DUMP && !OLDMEM_BASE) {
-		memory_end = ZFCPDUMP_HSA_SIZE;
+	if (ipl_info.type == IPL_TYPE_FCP_DUMP &&
+	    !OLDMEM_BASE && sclp_get_hsa_size()) {
+		memory_end = sclp_get_hsa_size();
 		memory_end_set = 1;
 	}
 #endif
@@ -586,7 +587,7 @@ static unsigned long __init find_crash_base(unsigned long crash_size,
 		crash_base = (chunk->addr + chunk->size) - crash_size;
 		if (crash_base < crash_size)
 			continue;
-		if (crash_base < ZFCPDUMP_HSA_SIZE_MAX)
+		if (crash_base < sclp_get_hsa_size())
 			continue;
 		if (crash_base < (unsigned long) INITRD_START + INITRD_SIZE)
 			continue;
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 0c9a177..bf7c73d 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -530,20 +530,6 @@ static void zpci_unmap_resources(struct zpci_dev *zdev)
 	}
 }
 
-struct zpci_dev *zpci_alloc_device(void)
-{
-	struct zpci_dev *zdev;
-
-	/* Alloc memory for our private pci device data */
-	zdev = kzalloc(sizeof(*zdev), GFP_KERNEL);
-	return zdev ? : ERR_PTR(-ENOMEM);
-}
-
-void zpci_free_device(struct zpci_dev *zdev)
-{
-	kfree(zdev);
-}
-
 int pcibios_add_platform_entries(struct pci_dev *pdev)
 {
 	return zpci_sysfs_add_device(&pdev->dev);
@@ -579,37 +565,6 @@ static void zpci_irq_exit(void)
 	unregister_adapter_interrupt(&zpci_airq);
 }
 
-static struct resource *zpci_alloc_bus_resource(unsigned long start, unsigned long size,
-						unsigned long flags, int domain)
-{
-	struct resource *r;
-	char *name;
-	int rc;
-
-	r = kzalloc(sizeof(*r), GFP_KERNEL);
-	if (!r)
-		return ERR_PTR(-ENOMEM);
-	r->start = start;
-	r->end = r->start + size - 1;
-	r->flags = flags;
-	r->parent = &iomem_resource;
-	name = kmalloc(18, GFP_KERNEL);
-	if (!name) {
-		kfree(r);
-		return ERR_PTR(-ENOMEM);
-	}
-	sprintf(name, "PCI Bus: %04x:%02x", domain, ZPCI_BUS_NR);
-	r->name = name;
-
-	rc = request_resource(&iomem_resource, r);
-	if (rc) {
-		kfree(r->name);
-		kfree(r);
-		return ERR_PTR(-ENOMEM);
-	}
-	return r;
-}
-
 static int zpci_alloc_iomap(struct zpci_dev *zdev)
 {
 	int entry;
@@ -633,6 +588,82 @@ static void zpci_free_iomap(struct zpci_dev *zdev, int entry)
 	spin_unlock(&zpci_iomap_lock);
 }
 
+static struct resource *__alloc_res(struct zpci_dev *zdev, unsigned long start,
+				    unsigned long size, unsigned long flags)
+{
+	struct resource *r;
+
+	r = kzalloc(sizeof(*r), GFP_KERNEL);
+	if (!r)
+		return NULL;
+
+	r->start = start;
+	r->end = r->start + size - 1;
+	r->flags = flags;
+	r->name = zdev->res_name;
+
+	if (request_resource(&iomem_resource, r)) {
+		kfree(r);
+		return NULL;
+	}
+	return r;
+}
+
+static int zpci_setup_bus_resources(struct zpci_dev *zdev,
+				    struct list_head *resources)
+{
+	unsigned long addr, size, flags;
+	struct resource *res;
+	int i, entry;
+
+	snprintf(zdev->res_name, sizeof(zdev->res_name),
+		 "PCI Bus %04x:%02x", zdev->domain, ZPCI_BUS_NR);
+
+	for (i = 0; i < PCI_BAR_COUNT; i++) {
+		if (!zdev->bars[i].size)
+			continue;
+		entry = zpci_alloc_iomap(zdev);
+		if (entry < 0)
+			return entry;
+		zdev->bars[i].map_idx = entry;
+
+		/* only MMIO is supported */
+		flags = IORESOURCE_MEM;
+		if (zdev->bars[i].val & 8)
+			flags |= IORESOURCE_PREFETCH;
+		if (zdev->bars[i].val & 4)
+			flags |= IORESOURCE_MEM_64;
+
+		addr = ZPCI_IOMAP_ADDR_BASE + ((u64) entry << 48);
+
+		size = 1UL << zdev->bars[i].size;
+
+		res = __alloc_res(zdev, addr, size, flags);
+		if (!res) {
+			zpci_free_iomap(zdev, entry);
+			return -ENOMEM;
+		}
+		zdev->bars[i].res = res;
+		pci_add_resource(resources, res);
+	}
+
+	return 0;
+}
+
+static void zpci_cleanup_bus_resources(struct zpci_dev *zdev)
+{
+	int i;
+
+	for (i = 0; i < PCI_BAR_COUNT; i++) {
+		if (!zdev->bars[i].size)
+			continue;
+
+		zpci_free_iomap(zdev, zdev->bars[i].map_idx);
+		release_resource(zdev->bars[i].res);
+		kfree(zdev->bars[i].res);
+	}
+}
+
 int pcibios_add_device(struct pci_dev *pdev)
 {
 	struct zpci_dev *zdev = get_zdev(pdev);
@@ -729,52 +760,6 @@ struct dev_pm_ops pcibios_pm_ops = {
 };
 #endif /* CONFIG_HIBERNATE_CALLBACKS */
 
-static int zpci_scan_bus(struct zpci_dev *zdev)
-{
-	struct resource *res;
-	LIST_HEAD(resources);
-	int i;
-
-	/* allocate mapping entry for each used bar */
-	for (i = 0; i < PCI_BAR_COUNT; i++) {
-		unsigned long addr, size, flags;
-		int entry;
-
-		if (!zdev->bars[i].size)
-			continue;
-		entry = zpci_alloc_iomap(zdev);
-		if (entry < 0)
-			return entry;
-		zdev->bars[i].map_idx = entry;
-
-		/* only MMIO is supported */
-		flags = IORESOURCE_MEM;
-		if (zdev->bars[i].val & 8)
-			flags |= IORESOURCE_PREFETCH;
-		if (zdev->bars[i].val & 4)
-			flags |= IORESOURCE_MEM_64;
-
-		addr = ZPCI_IOMAP_ADDR_BASE + ((u64) entry << 48);
-
-		size = 1UL << zdev->bars[i].size;
-
-		res = zpci_alloc_bus_resource(addr, size, flags, zdev->domain);
-		if (IS_ERR(res)) {
-			zpci_free_iomap(zdev, entry);
-			return PTR_ERR(res);
-		}
-		pci_add_resource(&resources, res);
-	}
-
-	zdev->bus = pci_scan_root_bus(NULL, ZPCI_BUS_NR, &pci_root_ops,
-				      zdev, &resources);
-	if (!zdev->bus)
-		return -EIO;
-
-	zdev->bus->max_bus_speed = zdev->max_bus_speed;
-	return 0;
-}
-
 static int zpci_alloc_domain(struct zpci_dev *zdev)
 {
 	spin_lock(&zpci_domain_lock);
@@ -795,6 +780,41 @@ static void zpci_free_domain(struct zpci_dev *zdev)
 	spin_unlock(&zpci_domain_lock);
 }
 
+void pcibios_remove_bus(struct pci_bus *bus)
+{
+	struct zpci_dev *zdev = get_zdev_by_bus(bus);
+
+	zpci_exit_slot(zdev);
+	zpci_cleanup_bus_resources(zdev);
+	zpci_free_domain(zdev);
+
+	spin_lock(&zpci_list_lock);
+	list_del(&zdev->entry);
+	spin_unlock(&zpci_list_lock);
+
+	kfree(zdev);
+}
+
+static int zpci_scan_bus(struct zpci_dev *zdev)
+{
+	LIST_HEAD(resources);
+	int ret;
+
+	ret = zpci_setup_bus_resources(zdev, &resources);
+	if (ret)
+		return ret;
+
+	zdev->bus = pci_scan_root_bus(NULL, ZPCI_BUS_NR, &pci_root_ops,
+				      zdev, &resources);
+	if (!zdev->bus) {
+		zpci_cleanup_bus_resources(zdev);
+		return -EIO;
+	}
+
+	zdev->bus->max_bus_speed = zdev->max_bus_speed;
+	return 0;
+}
+
 int zpci_enable_device(struct zpci_dev *zdev)
 {
 	int rc;
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index 8414798..c747394 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -155,9 +155,9 @@ int clp_add_pci_device(u32 fid, u32 fh, int configured)
 	int rc;
 
 	zpci_dbg(3, "add fid:%x, fh:%x, c:%d\n", fid, fh, configured);
-	zdev = zpci_alloc_device();
-	if (IS_ERR(zdev))
-		return PTR_ERR(zdev);
+	zdev = kzalloc(sizeof(*zdev), GFP_KERNEL);
+	if (!zdev)
+		return -ENOMEM;
 
 	zdev->fh = fh;
 	zdev->fid = fid;
@@ -178,7 +178,7 @@ int clp_add_pci_device(u32 fid, u32 fh, int configured)
 	return 0;
 
 error:
-	zpci_free_device(zdev);
+	kfree(zdev);
 	return rc;
 }
 
diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
index 278e671..800f064 100644
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <asm/pci_debug.h>
+#include <asm/sclp.h>
 
 /* Content Code Description for PCI Function Error */
 struct zpci_ccdf_err {
@@ -42,10 +43,27 @@ struct zpci_ccdf_avail {
 	u16 pec;			/* PCI event code */
 } __packed;
 
-static void zpci_event_log_avail(struct zpci_ccdf_avail *ccdf)
+void zpci_event_error(void *data)
 {
+	struct zpci_ccdf_err *ccdf = data;
+	struct zpci_dev *zdev = get_zdev_by_fid(ccdf->fid);
+
+	zpci_err("error CCDF:\n");
+	zpci_err_hex(ccdf, sizeof(*ccdf));
+
+	if (!zdev)
+		return;
+
+	pr_err("%s: Event 0x%x reports an error for PCI function 0x%x\n",
+	       pci_name(zdev->pdev), ccdf->pec, ccdf->fid);
+}
+
+void zpci_event_availability(void *data)
+{
+	struct zpci_ccdf_avail *ccdf = data;
 	struct zpci_dev *zdev = get_zdev_by_fid(ccdf->fid);
 	struct pci_dev *pdev = zdev ? zdev->pdev : NULL;
+	int ret;
 
 	pr_info("%s: Event 0x%x reconfigured PCI function 0x%x\n",
 		pdev ? pci_name(pdev) : "n/a", ccdf->pec, ccdf->fid);
@@ -53,36 +71,47 @@ static void zpci_event_log_avail(struct zpci_ccdf_avail *ccdf)
 	zpci_err_hex(ccdf, sizeof(*ccdf));
 
 	switch (ccdf->pec) {
-	case 0x0301:
-		zpci_enable_device(zdev);
+	case 0x0301: /* Standby -> Configured */
+		if (!zdev || zdev->state == ZPCI_FN_STATE_CONFIGURED)
+			break;
+		zdev->state = ZPCI_FN_STATE_CONFIGURED;
+		ret = zpci_enable_device(zdev);
+		if (ret)
+			break;
+		pci_rescan_bus(zdev->bus);
 		break;
-	case 0x0302:
+	case 0x0302: /* Reserved -> Standby */
 		clp_add_pci_device(ccdf->fid, ccdf->fh, 0);
 		break;
-	case 0x0306:
+	case 0x0303: /* Deconfiguration requested */
+		if (pdev)
+			pci_stop_and_remove_bus_device(pdev);
+
+		ret = zpci_disable_device(zdev);
+		if (ret)
+			break;
+
+		ret = sclp_pci_deconfigure(zdev->fid);
+		zpci_dbg(3, "deconf fid:%x, rc:%d\n", zdev->fid, ret);
+		if (!ret)
+			zdev->state = ZPCI_FN_STATE_STANDBY;
+
+		break;
+	case 0x0304: /* Configured -> Standby */
+		if (pdev)
+			pci_stop_and_remove_bus_device(pdev);
+
+		zpci_disable_device(zdev);
+		zdev->state = ZPCI_FN_STATE_STANDBY;
+		break;
+	case 0x0306: /* 0x308 or 0x302 for multiple devices */
 		clp_rescan_pci_devices();
 		break;
+	case 0x0308: /* Standby -> Reserved */
+		pci_stop_root_bus(zdev->bus);
+		pci_remove_root_bus(zdev->bus);
+		break;
 	default:
 		break;
 	}
 }
-
-void zpci_event_error(void *data)
-{
-	struct zpci_ccdf_err *ccdf = data;
-	struct zpci_dev *zdev = get_zdev_by_fid(ccdf->fid);
-
-	zpci_err("error CCDF:\n");
-	zpci_err_hex(ccdf, sizeof(*ccdf));
-
-	if (!zdev)
-		return;
-
-	pr_err("%s: Event 0x%x reports an error for PCI function 0x%x\n",
-	       pci_name(zdev->pdev), ccdf->pec, ccdf->fid);
-}
-
-void zpci_event_availability(void *data)
-{
-	zpci_event_log_avail(data);
-}
diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index 548209a..d0ab501 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -118,22 +118,6 @@ static void scm_request_done(struct scm_request *scmrq)
 	spin_unlock_irqrestore(&list_lock, flags);
 }
 
-static int scm_open(struct block_device *blkdev, fmode_t mode)
-{
-	return scm_get_ref();
-}
-
-static void scm_release(struct gendisk *gendisk, fmode_t mode)
-{
-	scm_put_ref();
-}
-
-static const struct block_device_operations scm_blk_devops = {
-	.owner = THIS_MODULE,
-	.open = scm_open,
-	.release = scm_release,
-};
-
 static bool scm_permit_request(struct scm_blk_dev *bdev, struct request *req)
 {
 	return rq_data_dir(req) != WRITE || bdev->state != SCM_WR_PROHIBIT;
@@ -256,7 +240,7 @@ static void scm_blk_request(struct request_queue *rq)
 		atomic_inc(&bdev->queued_reqs);
 		blk_start_request(req);
 
-		ret = scm_start_aob(scmrq->aob);
+		ret = eadm_start_aob(scmrq->aob);
 		if (ret) {
 			SCM_LOG(5, "no subchannel");
 			scm_request_requeue(scmrq);
@@ -320,7 +304,7 @@ static void scm_blk_handle_error(struct scm_request *scmrq)
 	}
 
 restart:
-	if (!scm_start_aob(scmrq->aob))
+	if (!eadm_start_aob(scmrq->aob))
 		return;
 
 requeue:
@@ -363,6 +347,10 @@ static void scm_blk_tasklet(struct scm_blk_dev *bdev)
 	blk_run_queue(bdev->rq);
 }
 
+static const struct block_device_operations scm_blk_devops = {
+	.owner = THIS_MODULE,
+};
+
 int scm_blk_dev_setup(struct scm_blk_dev *bdev, struct scm_device *scmdev)
 {
 	struct request_queue *rq;
diff --git a/drivers/s390/block/scm_blk_cluster.c b/drivers/s390/block/scm_blk_cluster.c
index c0d102e..27f930c 100644
--- a/drivers/s390/block/scm_blk_cluster.c
+++ b/drivers/s390/block/scm_blk_cluster.c
@@ -187,7 +187,7 @@ bool scm_need_cluster_request(struct scm_request *scmrq)
 void scm_initiate_cluster_request(struct scm_request *scmrq)
 {
 	scm_prepare_cluster_request(scmrq);
-	if (scm_start_aob(scmrq->aob))
+	if (eadm_start_aob(scmrq->aob))
 		scm_request_requeue(scmrq);
 }
 
diff --git a/drivers/s390/char/Makefile b/drivers/s390/char/Makefile
index 17821a0..b69ab17 100644
--- a/drivers/s390/char/Makefile
+++ b/drivers/s390/char/Makefile
@@ -3,7 +3,8 @@
 #
 
 obj-y += ctrlchar.o keyboard.o defkeymap.o sclp.o sclp_rw.o sclp_quiesce.o \
-	 sclp_cmd.o sclp_config.o sclp_cpi_sys.o sclp_ocf.o sclp_ctl.o
+	 sclp_cmd.o sclp_config.o sclp_cpi_sys.o sclp_ocf.o sclp_ctl.o \
+	 sclp_early.o
 
 obj-$(CONFIG_TN3270) += raw3270.o
 obj-$(CONFIG_TN3270_CONSOLE) += con3270.o
diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
index f93cc32..71e9747 100644
--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -564,6 +564,7 @@ static void __exit
 fs3270_exit(void)
 {
 	raw3270_unregister_notifier(&fs3270_notifier);
+	device_destroy(class3270, MKDEV(IBM_FS3270_MAJOR, 0));
 	__unregister_chrdev(IBM_FS3270_MAJOR, 0, 1, "fs3270");
 }
 
diff --git a/drivers/s390/char/sclp.h b/drivers/s390/char/sclp.h
index 40d1406..6fbe096 100644
--- a/drivers/s390/char/sclp.h
+++ b/drivers/s390/char/sclp.h
@@ -99,6 +99,7 @@ struct init_sccb {
 } __attribute__((packed));
 
 extern u64 sclp_facilities;
+
 #define SCLP_HAS_CHP_INFO	(sclp_facilities & 0x8000000000000000ULL)
 #define SCLP_HAS_CHP_RECONFIG	(sclp_facilities & 0x2000000000000000ULL)
 #define SCLP_HAS_CPU_INFO	(sclp_facilities & 0x0800000000000000ULL)
@@ -179,6 +180,10 @@ void sclp_sdias_exit(void);
 extern int sclp_console_pages;
 extern int sclp_console_drop;
 extern unsigned long sclp_console_full;
+extern u8 sclp_fac84;
+extern unsigned long long sclp_rzm;
+extern unsigned long long sclp_rnmax;
+extern __initdata int sclp_early_read_info_sccb_valid;
 
 /* useful inlines */
 
diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index 77df9cb..eaa21d5 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -28,168 +28,6 @@
 
 #include "sclp.h"
 
-#define SCLP_CMDW_READ_SCP_INFO		0x00020001
-#define SCLP_CMDW_READ_SCP_INFO_FORCED	0x00120001
-
-struct read_info_sccb {
-	struct	sccb_header header;	/* 0-7 */
-	u16	rnmax;			/* 8-9 */
-	u8	rnsize;			/* 10 */
-	u8	_reserved0[24 - 11];	/* 11-15 */
-	u8	loadparm[8];		/* 24-31 */
-	u8	_reserved1[48 - 32];	/* 32-47 */
-	u64	facilities;		/* 48-55 */
-	u8	_reserved2[84 - 56];	/* 56-83 */
-	u8	fac84;			/* 84 */
-	u8	fac85;			/* 85 */
-	u8	_reserved3[91 - 86];	/* 86-90 */
-	u8	flags;			/* 91 */
-	u8	_reserved4[100 - 92];	/* 92-99 */
-	u32	rnsize2;		/* 100-103 */
-	u64	rnmax2;			/* 104-111 */
-	u8	_reserved5[4096 - 112];	/* 112-4095 */
-} __attribute__((packed, aligned(PAGE_SIZE)));
-
-static struct init_sccb __initdata early_event_mask_sccb __aligned(PAGE_SIZE);
-static struct read_info_sccb __initdata early_read_info_sccb;
-static int __initdata early_read_info_sccb_valid;
-
-u64 sclp_facilities;
-static u8 sclp_fac84;
-static unsigned long long rzm;
-static unsigned long long rnmax;
-
-static int __init sclp_cmd_sync_early(sclp_cmdw_t cmd, void *sccb)
-{
-	int rc;
-
-	__ctl_set_bit(0, 9);
-	rc = sclp_service_call(cmd, sccb);
-	if (rc)
-		goto out;
-	__load_psw_mask(PSW_DEFAULT_KEY | PSW_MASK_BASE | PSW_MASK_EA |
-			PSW_MASK_BA | PSW_MASK_EXT | PSW_MASK_WAIT);
-	local_irq_disable();
-out:
-	/* Contents of the sccb might have changed. */
-	barrier();
-	__ctl_clear_bit(0, 9);
-	return rc;
-}
-
-static void __init sclp_read_info_early(void)
-{
-	int rc;
-	int i;
-	struct read_info_sccb *sccb;
-	sclp_cmdw_t commands[] = {SCLP_CMDW_READ_SCP_INFO_FORCED,
-				  SCLP_CMDW_READ_SCP_INFO};
-
-	sccb = &early_read_info_sccb;
-	for (i = 0; i < ARRAY_SIZE(commands); i++) {
-		do {
-			memset(sccb, 0, sizeof(*sccb));
-			sccb->header.length = sizeof(*sccb);
-			sccb->header.function_code = 0x80;
-			sccb->header.control_mask[2] = 0x80;
-			rc = sclp_cmd_sync_early(commands[i], sccb);
-		} while (rc == -EBUSY);
-
-		if (rc)
-			break;
-		if (sccb->header.response_code == 0x10) {
-			early_read_info_sccb_valid = 1;
-			break;
-		}
-		if (sccb->header.response_code != 0x1f0)
-			break;
-	}
-}
-
-static void __init sclp_event_mask_early(void)
-{
-	struct init_sccb *sccb = &early_event_mask_sccb;
-	int rc;
-
-	do {
-		memset(sccb, 0, sizeof(*sccb));
-		sccb->header.length = sizeof(*sccb);
-		sccb->mask_length = sizeof(sccb_mask_t);
-		rc = sclp_cmd_sync_early(SCLP_CMDW_WRITE_EVENT_MASK, sccb);
-	} while (rc == -EBUSY);
-}
-
-void __init sclp_facilities_detect(void)
-{
-	struct read_info_sccb *sccb;
-
-	sclp_read_info_early();
-	if (!early_read_info_sccb_valid)
-		return;
-
-	sccb = &early_read_info_sccb;
-	sclp_facilities = sccb->facilities;
-	sclp_fac84 = sccb->fac84;
-	if (sccb->fac85 & 0x02)
-		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;
-	rnmax = sccb->rnmax ? sccb->rnmax : sccb->rnmax2;
-	rzm = sccb->rnsize ? sccb->rnsize : sccb->rnsize2;
-	rzm <<= 20;
-
-	sclp_event_mask_early();
-}
-
-bool __init sclp_has_linemode(void)
-{
-	struct init_sccb *sccb = &early_event_mask_sccb;
-
-	if (sccb->header.response_code != 0x20)
-		return 0;
-	if (!(sccb->sclp_send_mask & (EVTYP_OPCMD_MASK | EVTYP_PMSGCMD_MASK)))
-		return 0;
-	if (!(sccb->sclp_receive_mask & (EVTYP_MSG_MASK | EVTYP_PMSGCMD_MASK)))
-		return 0;
-	return 1;
-}
-
-bool __init sclp_has_vt220(void)
-{
-	struct init_sccb *sccb = &early_event_mask_sccb;
-
-	if (sccb->header.response_code != 0x20)
-		return 0;
-	if (sccb->sclp_send_mask & EVTYP_VT220MSG_MASK)
-		return 1;
-	return 0;
-}
-
-unsigned long long sclp_get_rnmax(void)
-{
-	return rnmax;
-}
-
-unsigned long long sclp_get_rzm(void)
-{
-	return rzm;
-}
-
-/*
- * This function will be called after sclp_facilities_detect(), which gets
- * called from early.c code. Therefore the sccb should have valid contents.
- */
-void __init sclp_get_ipl_info(struct sclp_ipl_info *info)
-{
-	struct read_info_sccb *sccb;
-
-	if (!early_read_info_sccb_valid)
-		return;
-	sccb = &early_read_info_sccb;
-	info->is_valid = 1;
-	if (sccb->flags & 0x2)
-		info->has_dump = 1;
-	memcpy(&info->loadparm, &sccb->loadparm, LOADPARM_LEN);
-}
-
 static void sclp_sync_callback(struct sclp_req *req, void *data)
 {
 	struct completion *completion = data;
@@ -356,14 +194,14 @@ struct assign_storage_sccb {
 
 int arch_get_memory_phys_device(unsigned long start_pfn)
 {
-	if (!rzm)
+	if (!sclp_rzm)
 		return 0;
-	return PFN_PHYS(start_pfn) >> ilog2(rzm);
+	return PFN_PHYS(start_pfn) >> ilog2(sclp_rzm);
 }
 
 static unsigned long long rn2addr(u16 rn)
 {
-	return (unsigned long long) (rn - 1) * rzm;
+	return (unsigned long long) (rn - 1) * sclp_rzm;
 }
 
 static int do_assign_storage(sclp_cmdw_t cmd, u16 rn)
@@ -404,7 +242,7 @@ static int sclp_assign_storage(u16 rn)
 	if (rc)
 		return rc;
 	start = rn2addr(rn);
-	storage_key_init_range(start, start + rzm);
+	storage_key_init_range(start, start + sclp_rzm);
 	return 0;
 }
 
@@ -462,7 +300,7 @@ static int sclp_mem_change_state(unsigned long start, unsigned long size,
 		istart = rn2addr(incr->rn);
 		if (start + size - 1 < istart)
 			break;
-		if (start > istart + rzm - 1)
+		if (start > istart + sclp_rzm - 1)
 			continue;
 		if (online)
 			rc |= sclp_assign_storage(incr->rn);
@@ -526,7 +364,7 @@ static void __init add_memory_merged(u16 rn)
 	if (!first_rn)
 		goto skip_add;
 	start = rn2addr(first_rn);
-	size = (unsigned long long ) num * rzm;
+	size = (unsigned long long) num * sclp_rzm;
 	if (start >= VMEM_MAX_PHYS)
 		goto skip_add;
 	if (start + size > VMEM_MAX_PHYS)
@@ -574,7 +412,7 @@ static void __init insert_increment(u16 rn, int standby, int assigned)
 	}
 	if (!assigned)
 		new_incr->rn = last_rn + 1;
-	if (new_incr->rn > rnmax) {
+	if (new_incr->rn > sclp_rnmax) {
 		kfree(new_incr);
 		return;
 	}
@@ -617,7 +455,7 @@ static int __init sclp_detect_standby_memory(void)
 
 	if (OLDMEM_BASE) /* No standby memory in kdump mode */
 		return 0;
-	if (!early_read_info_sccb_valid)
+	if (!sclp_early_read_info_sccb_valid)
 		return 0;
 	if ((sclp_facilities & 0xe00000000000ULL) != 0xe00000000000ULL)
 		return 0;
@@ -661,7 +499,7 @@ static int __init sclp_detect_standby_memory(void)
 	}
 	if (rc || list_empty(&sclp_mem_list))
 		goto out;
-	for (i = 1; i <= rnmax - assigned; i++)
+	for (i = 1; i <= sclp_rnmax - assigned; i++)
 		insert_increment(0, 1, 0);
 	rc = register_memory_notifier(&sclp_mem_nb);
 	if (rc)
diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
new file mode 100644
index 0000000..f7aa080
--- /dev/null
+++ b/drivers/s390/char/sclp_early.c
@@ -0,0 +1,264 @@
+/*
+ * SCLP early driver
+ *
+ * Copyright IBM Corp. 2013
+ */
+
+#define KMSG_COMPONENT "sclp_early"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
+#include <asm/ctl_reg.h>
+#include <asm/sclp.h>
+#include <asm/ipl.h>
+#include "sclp_sdias.h"
+#include "sclp.h"
+
+#define SCLP_CMDW_READ_SCP_INFO		0x00020001
+#define SCLP_CMDW_READ_SCP_INFO_FORCED	0x00120001
+
+struct read_info_sccb {
+	struct	sccb_header header;	/* 0-7 */
+	u16	rnmax;			/* 8-9 */
+	u8	rnsize;			/* 10 */
+	u8	_reserved0[24 - 11];	/* 11-15 */
+	u8	loadparm[8];		/* 24-31 */
+	u8	_reserved1[48 - 32];	/* 32-47 */
+	u64	facilities;		/* 48-55 */
+	u8	_reserved2[84 - 56];	/* 56-83 */
+	u8	fac84;			/* 84 */
+	u8	fac85;			/* 85 */
+	u8	_reserved3[91 - 86];	/* 86-90 */
+	u8	flags;			/* 91 */
+	u8	_reserved4[100 - 92];	/* 92-99 */
+	u32	rnsize2;		/* 100-103 */
+	u64	rnmax2;			/* 104-111 */
+	u8	_reserved5[4096 - 112];	/* 112-4095 */
+} __packed __aligned(PAGE_SIZE);
+
+static __initdata struct init_sccb early_event_mask_sccb __aligned(PAGE_SIZE);
+static __initdata struct read_info_sccb early_read_info_sccb;
+static __initdata char sccb_early[PAGE_SIZE] __aligned(PAGE_SIZE);
+static unsigned long sclp_hsa_size;
+
+__initdata int sclp_early_read_info_sccb_valid;
+u64 sclp_facilities;
+u8 sclp_fac84;
+unsigned long long sclp_rzm;
+unsigned long long sclp_rnmax;
+
+static int __init sclp_cmd_sync_early(sclp_cmdw_t cmd, void *sccb)
+{
+	int rc;
+
+	__ctl_set_bit(0, 9);
+	rc = sclp_service_call(cmd, sccb);
+	if (rc)
+		goto out;
+	__load_psw_mask(PSW_DEFAULT_KEY | PSW_MASK_BASE | PSW_MASK_EA |
+			PSW_MASK_BA | PSW_MASK_EXT | PSW_MASK_WAIT);
+	local_irq_disable();
+out:
+	/* Contents of the sccb might have changed. */
+	barrier();
+	__ctl_clear_bit(0, 9);
+	return rc;
+}
+
+static void __init sclp_read_info_early(void)
+{
+	int rc;
+	int i;
+	struct read_info_sccb *sccb;
+	sclp_cmdw_t commands[] = {SCLP_CMDW_READ_SCP_INFO_FORCED,
+				  SCLP_CMDW_READ_SCP_INFO};
+
+	sccb = &early_read_info_sccb;
+	for (i = 0; i < ARRAY_SIZE(commands); i++) {
+		do {
+			memset(sccb, 0, sizeof(*sccb));
+			sccb->header.length = sizeof(*sccb);
+			sccb->header.function_code = 0x80;
+			sccb->header.control_mask[2] = 0x80;
+			rc = sclp_cmd_sync_early(commands[i], sccb);
+		} while (rc == -EBUSY);
+
+		if (rc)
+			break;
+		if (sccb->header.response_code == 0x10) {
+			sclp_early_read_info_sccb_valid = 1;
+			break;
+		}
+		if (sccb->header.response_code != 0x1f0)
+			break;
+	}
+}
+
+static void __init sclp_facilities_detect(void)
+{
+	struct read_info_sccb *sccb;
+
+	sclp_read_info_early();
+	if (!sclp_early_read_info_sccb_valid)
+		return;
+
+	sccb = &early_read_info_sccb;
+	sclp_facilities = sccb->facilities;
+	sclp_fac84 = sccb->fac84;
+	if (sccb->fac85 & 0x02)
+		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;
+	sclp_rnmax = sccb->rnmax ? sccb->rnmax : sccb->rnmax2;
+	sclp_rzm = sccb->rnsize ? sccb->rnsize : sccb->rnsize2;
+	sclp_rzm <<= 20;
+}
+
+bool __init sclp_has_linemode(void)
+{
+	struct init_sccb *sccb = &early_event_mask_sccb;
+
+	if (sccb->header.response_code != 0x20)
+		return 0;
+	if (!(sccb->sclp_send_mask & (EVTYP_OPCMD_MASK | EVTYP_PMSGCMD_MASK)))
+		return 0;
+	if (!(sccb->sclp_receive_mask & (EVTYP_MSG_MASK | EVTYP_PMSGCMD_MASK)))
+		return 0;
+	return 1;
+}
+
+bool __init sclp_has_vt220(void)
+{
+	struct init_sccb *sccb = &early_event_mask_sccb;
+
+	if (sccb->header.response_code != 0x20)
+		return 0;
+	if (sccb->sclp_send_mask & EVTYP_VT220MSG_MASK)
+		return 1;
+	return 0;
+}
+
+unsigned long long sclp_get_rnmax(void)
+{
+	return sclp_rnmax;
+}
+
+unsigned long long sclp_get_rzm(void)
+{
+	return sclp_rzm;
+}
+
+/*
+ * This function will be called after sclp_facilities_detect(), which gets
+ * called from early.c code. Therefore the sccb should have valid contents.
+ */
+void __init sclp_get_ipl_info(struct sclp_ipl_info *info)
+{
+	struct read_info_sccb *sccb;
+
+	if (!sclp_early_read_info_sccb_valid)
+		return;
+	sccb = &early_read_info_sccb;
+	info->is_valid = 1;
+	if (sccb->flags & 0x2)
+		info->has_dump = 1;
+	memcpy(&info->loadparm, &sccb->loadparm, LOADPARM_LEN);
+}
+
+static int __init sclp_cmd_early(sclp_cmdw_t cmd, void *sccb)
+{
+	int rc;
+
+	do {
+		rc = sclp_cmd_sync_early(cmd, sccb);
+	} while (rc == -EBUSY);
+
+	if (rc)
+		return -EIO;
+	if (((struct sccb_header *) sccb)->response_code != 0x0020)
+		return -EIO;
+	return 0;
+}
+
+static void __init sccb_init_eq_size(struct sdias_sccb *sccb)
+{
+	memset(sccb, 0, sizeof(*sccb));
+
+	sccb->hdr.length = sizeof(*sccb);
+	sccb->evbuf.hdr.length = sizeof(struct sdias_evbuf);
+	sccb->evbuf.hdr.type = EVTYP_SDIAS;
+	sccb->evbuf.event_qual = SDIAS_EQ_SIZE;
+	sccb->evbuf.data_id = SDIAS_DI_FCP_DUMP;
+	sccb->evbuf.event_id = 4712;
+	sccb->evbuf.dbs = 1;
+}
+
+static int __init sclp_set_event_mask(unsigned long receive_mask,
+				      unsigned long send_mask)
+{
+	struct init_sccb *sccb = (void *) &sccb_early;
+
+	memset(sccb, 0, sizeof(*sccb));
+	sccb->header.length = sizeof(*sccb);
+	sccb->mask_length = sizeof(sccb_mask_t);
+	sccb->receive_mask = receive_mask;
+	sccb->send_mask = send_mask;
+	return sclp_cmd_early(SCLP_CMDW_WRITE_EVENT_MASK, sccb);
+}
+
+static long __init sclp_hsa_size_init(void)
+{
+	struct sdias_sccb *sccb = (void *) &sccb_early;
+
+	sccb_init_eq_size(sccb);
+	if (sclp_cmd_early(SCLP_CMDW_WRITE_EVENT_DATA, sccb))
+		return -EIO;
+	if (sccb->evbuf.blk_cnt != 0)
+		return (sccb->evbuf.blk_cnt - 1) * PAGE_SIZE;
+	return 0;
+}
+
+static long __init sclp_hsa_copy_wait(void)
+{
+	struct sccb_header *sccb = (void *) &sccb_early;
+
+	memset(sccb, 0, PAGE_SIZE);
+	sccb->length = PAGE_SIZE;
+	if (sclp_cmd_early(SCLP_CMDW_READ_EVENT_DATA, sccb))
+		return -EIO;
+	return (((struct sdias_sccb *) sccb)->evbuf.blk_cnt - 1) * PAGE_SIZE;
+}
+
+unsigned long sclp_get_hsa_size(void)
+{
+	return sclp_hsa_size;
+}
+
+static void __init sclp_hsa_size_detect(void)
+{
+	long size;
+
+	/* First try synchronous interface (LPAR) */
+	if (sclp_set_event_mask(0, 0x40000010))
+		return;
+	size = sclp_hsa_size_init();
+	if (size < 0)
+		return;
+	if (size != 0)
+		goto out;
+	/* Then try asynchronous interface (z/VM) */
+	if (sclp_set_event_mask(0x00000010, 0x40000010))
+		return;
+	size = sclp_hsa_size_init();
+	if (size < 0)
+		return;
+	size = sclp_hsa_copy_wait();
+	if (size < 0)
+		return;
+out:
+	sclp_hsa_size = size;
+}
+
+void __init sclp_early_detect(void)
+{
+	sclp_facilities_detect();
+	sclp_hsa_size_detect();
+	sclp_set_event_mask(0, 0);
+}
diff --git a/drivers/s390/char/sclp_sdias.c b/drivers/s390/char/sclp_sdias.c
index b103293..561a041 100644
--- a/drivers/s390/char/sclp_sdias.c
+++ b/drivers/s390/char/sclp_sdias.c
@@ -1,7 +1,7 @@
 /*
- * Sclp "store data in absolut storage"
+ * SCLP "store data in absolute storage"
  *
- * Copyright IBM Corp. 2003, 2007
+ * Copyright IBM Corp. 2003, 2013
  * Author(s): Michael Holzheu
  */
 
@@ -14,6 +14,7 @@
 #include <asm/debug.h>
 #include <asm/ipl.h>
 
+#include "sclp_sdias.h"
 #include "sclp.h"
 #include "sclp_rw.h"
 
@@ -22,46 +23,12 @@
 #define SDIAS_RETRIES 300
 #define SDIAS_SLEEP_TICKS 50
 
-#define EQ_STORE_DATA	0x0
-#define EQ_SIZE		0x1
-#define DI_FCP_DUMP	0x0
-#define ASA_SIZE_32	0x0
-#define ASA_SIZE_64	0x1
-#define EVSTATE_ALL_STORED	0x0
-#define EVSTATE_NO_DATA		0x3
-#define EVSTATE_PART_STORED	0x10
-
 static struct debug_info *sdias_dbf;
 
 static struct sclp_register sclp_sdias_register = {
 	.send_mask = EVTYP_SDIAS_MASK,
 };
 
-struct sdias_evbuf {
-	struct	evbuf_header hdr;
-	u8	event_qual;
-	u8	data_id;
-	u64	reserved2;
-	u32	event_id;
-	u16	reserved3;
-	u8	asa_size;
-	u8	event_status;
-	u32	reserved4;
-	u32	blk_cnt;
-	u64	asa;
-	u32	reserved5;
-	u32	fbn;
-	u32	reserved6;
-	u32	lbn;
-	u16	reserved7;
-	u16	dbs;
-} __attribute__((packed));
-
-struct sdias_sccb {
-	struct sccb_header  hdr;
-	struct sdias_evbuf  evbuf;
-} __attribute__((packed));
-
 static struct sdias_sccb sccb __attribute__((aligned(4096)));
 static struct sdias_evbuf sdias_evbuf;
 
@@ -148,8 +115,8 @@ int sclp_sdias_blk_count(void)
 	sccb.hdr.length = sizeof(sccb);
 	sccb.evbuf.hdr.length = sizeof(struct sdias_evbuf);
 	sccb.evbuf.hdr.type = EVTYP_SDIAS;
-	sccb.evbuf.event_qual = EQ_SIZE;
-	sccb.evbuf.data_id = DI_FCP_DUMP;
+	sccb.evbuf.event_qual = SDIAS_EQ_SIZE;
+	sccb.evbuf.data_id = SDIAS_DI_FCP_DUMP;
 	sccb.evbuf.event_id = 4712;
 	sccb.evbuf.dbs = 1;
 
@@ -208,13 +175,13 @@ int sclp_sdias_copy(void *dest, int start_blk, int nr_blks)
 	sccb.evbuf.hdr.length = sizeof(struct sdias_evbuf);
 	sccb.evbuf.hdr.type = EVTYP_SDIAS;
 	sccb.evbuf.hdr.flags = 0;
-	sccb.evbuf.event_qual = EQ_STORE_DATA;
-	sccb.evbuf.data_id = DI_FCP_DUMP;
+	sccb.evbuf.event_qual = SDIAS_EQ_STORE_DATA;
+	sccb.evbuf.data_id = SDIAS_DI_FCP_DUMP;
 	sccb.evbuf.event_id = 4712;
 #ifdef CONFIG_64BIT
-	sccb.evbuf.asa_size = ASA_SIZE_64;
+	sccb.evbuf.asa_size = SDIAS_ASA_SIZE_64;
 #else
-	sccb.evbuf.asa_size = ASA_SIZE_32;
+	sccb.evbuf.asa_size = SDIAS_ASA_SIZE_32;
 #endif
 	sccb.evbuf.event_status = 0;
 	sccb.evbuf.blk_cnt = nr_blks;
@@ -240,20 +207,19 @@ int sclp_sdias_copy(void *dest, int start_blk, int nr_blks)
 	}
 
 	switch (sdias_evbuf.event_status) {
-		case EVSTATE_ALL_STORED:
-			TRACE("all stored\n");
-			break;
-		case EVSTATE_PART_STORED:
-			TRACE("part stored: %i\n", sdias_evbuf.blk_cnt);
-			break;
-		case EVSTATE_NO_DATA:
-			TRACE("no data\n");
-			/* fall through */
-		default:
-			pr_err("Error from SCLP while copying hsa. "
-			       "Event status = %x\n",
-			       sdias_evbuf.event_status);
-			rc = -EIO;
+	case SDIAS_EVSTATE_ALL_STORED:
+		TRACE("all stored\n");
+		break;
+	case SDIAS_EVSTATE_PART_STORED:
+		TRACE("part stored: %i\n", sdias_evbuf.blk_cnt);
+		break;
+	case SDIAS_EVSTATE_NO_DATA:
+		TRACE("no data\n");
+		/* fall through */
+	default:
+		pr_err("Error from SCLP while copying hsa. Event status = %x\n",
+		       sdias_evbuf.event_status);
+		rc = -EIO;
 	}
 out:
 	mutex_unlock(&sdias_mutex);
diff --git a/drivers/s390/char/sclp_sdias.h b/drivers/s390/char/sclp_sdias.h
new file mode 100644
index 0000000..f2431c4
--- /dev/null
+++ b/drivers/s390/char/sclp_sdias.h
@@ -0,0 +1,46 @@
+/*
+ * SCLP "store data in absolute storage"
+ *
+ * Copyright IBM Corp. 2003, 2013
+ */
+
+#ifndef SCLP_SDIAS_H
+#define SCLP_SDIAS_H
+
+#include "sclp.h"
+
+#define SDIAS_EQ_STORE_DATA		0x0
+#define SDIAS_EQ_SIZE			0x1
+#define SDIAS_DI_FCP_DUMP		0x0
+#define SDIAS_ASA_SIZE_32		0x0
+#define SDIAS_ASA_SIZE_64		0x1
+#define SDIAS_EVSTATE_ALL_STORED	0x0
+#define SDIAS_EVSTATE_NO_DATA		0x3
+#define SDIAS_EVSTATE_PART_STORED	0x10
+
+struct sdias_evbuf {
+	struct	evbuf_header hdr;
+	u8	event_qual;
+	u8	data_id;
+	u64	reserved2;
+	u32	event_id;
+	u16	reserved3;
+	u8	asa_size;
+	u8	event_status;
+	u32	reserved4;
+	u32	blk_cnt;
+	u64	asa;
+	u32	reserved5;
+	u32	fbn;
+	u32	reserved6;
+	u32	lbn;
+	u16	reserved7;
+	u16	dbs;
+} __packed;
+
+struct sdias_sccb {
+	struct sccb_header	hdr;
+	struct sdias_evbuf	evbuf;
+} __packed;
+
+#endif /* SCLP_SDIAS_H */
diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index ffb1fcf..3d8e4d6 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -328,9 +328,9 @@ static ssize_t zcore_read(struct file *file, char __user *buf, size_t count,
 	mem_offs = 0;
 
 	/* Copy from HSA data */
-	if (*ppos < (ZFCPDUMP_HSA_SIZE + HEADER_SIZE)) {
-		size = min((count - hdr_count), (size_t) (ZFCPDUMP_HSA_SIZE
-			   - mem_start));
+	if (*ppos < sclp_get_hsa_size() + HEADER_SIZE) {
+		size = min((count - hdr_count),
+			   (size_t) (sclp_get_hsa_size() - mem_start));
 		rc = memcpy_hsa_user(buf + hdr_count, mem_start, size);
 		if (rc)
 			goto fail;
@@ -490,7 +490,7 @@ static ssize_t zcore_hsa_read(struct file *filp, char __user *buf,
 	static char str[18];
 
 	if (hsa_available)
-		snprintf(str, sizeof(str), "%lx\n", ZFCPDUMP_HSA_SIZE);
+		snprintf(str, sizeof(str), "%lx\n", sclp_get_hsa_size());
 	else
 		snprintf(str, sizeof(str), "0\n");
 	return simple_read_from_buffer(buf, count, ppos, str, strlen(str));
@@ -584,17 +584,9 @@ static int __init sys_info_init(enum arch_id arch, unsigned long mem_end)
 
 static int __init check_sdias(void)
 {
-	int rc, act_hsa_size;
-
-	rc = sclp_sdias_blk_count();
-	if (rc < 0) {
+	if (!sclp_get_hsa_size()) {
 		TRACE("Could not determine HSA size\n");
-		return rc;
-	}
-	act_hsa_size = (rc - 1) * PAGE_SIZE;
-	if (act_hsa_size < ZFCPDUMP_HSA_SIZE) {
-		TRACE("HSA size too small: %i\n", act_hsa_size);
-		return -EINVAL;
+		return -ENODEV;
 	}
 	return 0;
 }
@@ -662,7 +654,7 @@ static int __init zcore_reipl_init(void)
 	ipl_block = (void *) __get_free_page(GFP_KERNEL);
 	if (!ipl_block)
 		return -ENOMEM;
-	if (ipib_info.ipib < ZFCPDUMP_HSA_SIZE)
+	if (ipib_info.ipib < sclp_get_hsa_size())
 		rc = memcpy_hsa_kernel(ipl_block, ipib_info.ipib, PAGE_SIZE);
 	else
 		rc = memcpy_real(ipl_block, (void *) ipib_info.ipib, PAGE_SIZE);
diff --git a/drivers/s390/cio/eadm_sch.c b/drivers/s390/cio/eadm_sch.c
index aca7bfc..3a2ee4a 100644
--- a/drivers/s390/cio/eadm_sch.c
+++ b/drivers/s390/cio/eadm_sch.c
@@ -190,7 +190,7 @@ static struct subchannel *eadm_get_idle_sch(void)
 	return NULL;
 }
 
-static int eadm_start_aob(struct aob *aob)
+int eadm_start_aob(struct aob *aob)
 {
 	struct eadm_private *private;
 	struct subchannel *sch;
@@ -218,6 +218,7 @@ out_unlock:
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(eadm_start_aob);
 
 static int eadm_subchannel_probe(struct subchannel *sch)
 {
@@ -380,11 +381,6 @@ static struct css_driver eadm_subchannel_driver = {
 	.restore = eadm_subchannel_restore,
 };
 
-static struct eadm_ops eadm_ops = {
-	.eadm_start = eadm_start_aob,
-	.owner = THIS_MODULE,
-};
-
 static int __init eadm_sch_init(void)
 {
 	int ret;
@@ -404,7 +400,6 @@ static int __init eadm_sch_init(void)
 	if (ret)
 		goto cleanup;
 
-	register_eadm_ops(&eadm_ops);
 	return ret;
 
 cleanup:
@@ -415,7 +410,6 @@ cleanup:
 
 static void __exit eadm_sch_exit(void)
 {
-	unregister_eadm_ops(&eadm_ops);
 	css_driver_unregister(&eadm_subchannel_driver);
 	isc_unregister(EADM_SCH_ISC);
 	debug_unregister(eadm_debug);
diff --git a/drivers/s390/cio/scm.c b/drivers/s390/cio/scm.c
index 46ec256..15268ed 100644
--- a/drivers/s390/cio/scm.c
+++ b/drivers/s390/cio/scm.c
@@ -15,8 +15,6 @@
 #include "chsc.h"
 
 static struct device *scm_root;
-static struct eadm_ops *eadm_ops;
-static DEFINE_MUTEX(eadm_ops_mutex);
 
 #define to_scm_dev(n) container_of(n, struct scm_device, dev)
 #define	to_scm_drv(d) container_of(d, struct scm_driver, drv)
@@ -73,49 +71,6 @@ void scm_driver_unregister(struct scm_driver *scmdrv)
 }
 EXPORT_SYMBOL_GPL(scm_driver_unregister);
 
-int scm_get_ref(void)
-{
-	int ret = 0;
-
-	mutex_lock(&eadm_ops_mutex);
-	if (!eadm_ops || !try_module_get(eadm_ops->owner))
-		ret = -ENOENT;
-	mutex_unlock(&eadm_ops_mutex);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(scm_get_ref);
-
-void scm_put_ref(void)
-{
-	mutex_lock(&eadm_ops_mutex);
-	module_put(eadm_ops->owner);
-	mutex_unlock(&eadm_ops_mutex);
-}
-EXPORT_SYMBOL_GPL(scm_put_ref);
-
-void register_eadm_ops(struct eadm_ops *ops)
-{
-	mutex_lock(&eadm_ops_mutex);
-	eadm_ops = ops;
-	mutex_unlock(&eadm_ops_mutex);
-}
-EXPORT_SYMBOL_GPL(register_eadm_ops);
-
-void unregister_eadm_ops(struct eadm_ops *ops)
-{
-	mutex_lock(&eadm_ops_mutex);
-	eadm_ops = NULL;
-	mutex_unlock(&eadm_ops_mutex);
-}
-EXPORT_SYMBOL_GPL(unregister_eadm_ops);
-
-int scm_start_aob(struct aob *aob)
-{
-	return eadm_ops->eadm_start(aob);
-}
-EXPORT_SYMBOL_GPL(scm_start_aob);
-
 void scm_irq_handler(struct aob *aob, int error)
 {
 	struct aob_rq_header *aobrq = (void *) aob->request.data;

