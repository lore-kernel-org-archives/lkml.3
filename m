Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbbAWShq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:37:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:49840 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380AbbAWShk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:37:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,455,1418112000"; 
   d="scan'208";a="674944791"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 02/10] drivers/char: Support compiling out /dev/mem
Date: Fri, 23 Jan 2015 12:37:08 -0600
Message-Id: <85621d47d40652f5f7c5ba16d6dedda9821f64ca.1422035184.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most embedded systems have no use for /dev/mem, and omitting it saves
space.  Add a new EMBEDDED config option to disable it.

mmap_mem() is shared between /dev/mem and /dev/kmem; making it
__maybe_unused prevents it from emitting warnings if both devices are
compiled out, while avoiding ugly compound ifdefs.

Also, STRICT_DEVMEM can now be refined to depend on DEVMEM rather than
the big hammer, DEVMEM_BASE.

bloat-o-meter (based on tinyconfig):

add/remove: 0/4 grow/shrink: 1/0 up/down: 96/-565 (-469)
function                                     old     new   delta
mmap_kmem                                     37     133     +96
mmap_mem                                     103       -    -103
mem_fops                                     116       -    -116
read_mem                                     162       -    -162
write_mem                                    184       -    -184

Here we see mmap_mem inlined in mmap_kmem and mmap_mem going away.

bloat-o-meter showing only CONFIG_DEVKMEM off:

add/remove: 0/4 grow/shrink: 0/0 up/down: 0/-792 (-792)
function                                     old     new   delta
mmap_kmem                                     37       -     -37
kmem_fops                                    116       -    -116
read_kmem                                    290       -    -290
write_kmem                                   349       -    -349

bloat-o-meter showing the difference between only CONFIG_DEVKMEM off
and both CONFIG_DEVKMEM and CONFIG_DEVMEM off:

add/remove: 0/5 grow/shrink: 0/0 up/down: 0/-597 (-597)
function                                     old     new   delta
mmap_mem_ops                                  32       -     -32
mmap_mem                                     103       -    -103
mem_fops                                     116       -    -116
read_mem                                     162       -    -162
write_mem                                    184       -    -184

Here we see mmap_mem going away as before, but also not being inlined
by mmap_kmem because that's gone, and mmap_mem_ops goes away as well,
because it's not being used by even an inlined mmap_mem.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 arch/x86/Kconfig.debug |  2 +-
 drivers/char/Kconfig   | 10 ++++++++++
 drivers/char/mem.c     |  9 ++++++++-
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 34a781a..39afd1c 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -7,7 +7,7 @@ source "lib/Kconfig.debug"
 
 config STRICT_DEVMEM
 	bool "Filter access to /dev/mem"
-	depends on DEVMEM_BASE
+	depends on DEVMEM
 	---help---
 	  If this option is disabled, you allow userspace (root) access to all
 	  of memory, including kernel and userspace memory. Accidental
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 7a8204a..73e2bb8 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -26,6 +26,16 @@ config DEVKMEM
 	  kind of kernel debugging operations.
 	  When in doubt, say "N".
 
+config DEVMEM
+	bool "/dev/mem virtual device support" if EMBEDDED
+	depends on DEVMEM_BASE
+	default y
+	help
+	  Say Y here if you want to support the /dev/mem device. The
+	  /dev/mem device is used mainly by X and dosemu, and can be
+	  disabled on systems that will never use either, such as many
+	  embedded systems.  When in doubt, say "Y".
+
 config SGI_SNSC
 	bool "SGI Altix system controller communication support"
 	depends on (IA64_SGI_SN2 || IA64_GENERIC)
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index c141c0f..9b7b04e 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -92,6 +92,7 @@ void __weak unxlate_dev_mem_ptr(phys_addr_t phys, void *addr)
 }
 #endif
 
+#ifdef CONFIG_DEVMEM
 /*
  * This funcion reads the *physical* memory. The f_pos points directly to the
  * memory location.
@@ -220,6 +221,7 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 	*ppos += written;
 	return written;
 }
+#endif
 
 int __weak phys_mem_access_prot_allowed(struct file *file,
 	unsigned long pfn, unsigned long size, pgprot_t *vma_prot)
@@ -308,7 +310,8 @@ static const struct vm_operations_struct mmap_mem_ops = {
 #endif
 };
 
-static int mmap_mem(struct file *file, struct vm_area_struct *vma)
+static int __maybe_unused mmap_mem(struct file *file,
+				   struct vm_area_struct *vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
 
@@ -716,6 +719,7 @@ static int open_port(struct inode *inode, struct file *filp)
 #define open_mem	open_port
 #define open_kmem	open_mem
 
+#ifdef CONFIG_DEVMEM
 static const struct file_operations mem_fops = {
 	.llseek		= memory_lseek,
 	.read		= read_mem,
@@ -724,6 +728,7 @@ static const struct file_operations mem_fops = {
 	.open		= open_mem,
 	.get_unmapped_area = get_unmapped_area_mem,
 };
+#endif
 
 #ifdef CONFIG_DEVKMEM
 static const struct file_operations kmem_fops = {
@@ -786,7 +791,9 @@ static const struct memdev {
 	const struct file_operations *fops;
 	struct backing_dev_info *dev_info;
 } devlist[] = {
+#ifdef CONFIG_DEVMEM
 	 [1] = { "mem", 0, &mem_fops, &directly_mappable_cdev_bdi },
+#endif
 #ifdef CONFIG_DEVKMEM
 	 [2] = { "kmem", 0, &kmem_fops, &directly_mappable_cdev_bdi },
 #endif
-- 
1.9.3

