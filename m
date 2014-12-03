Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaLCIVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 03:21:17 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:41045 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbaLCIVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 03:21:16 -0500
From: Rob Ward <robert.ward114@googlemail.com>
X-Google-Original-From: Rob Ward <rob@rob-thinkpad>
Date: Wed, 3 Dec 2014 08:21:04 +0000 (GMT)
To: arnd@arndb.de, gregkh@linuxfoundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: char: mem: Make /dev/mem an optional device
Message-ID: <alpine.DEB.2.10.1412030818030.7838@rob-thinkpad>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ecd3ac31f6be2372d2beac0cc4831e74aeae75d2 Mon Sep 17 00:00:00 2001
From: Rob Ward <robert.ward114@googlemail.com>
Date: Wed, 5 Nov 2014 19:13:53 +0000
Subject: [PATCH] drivers: char: mem: Make /dev/mem an optional device

Adds Kconfig option CONFIG_DEVMEM that allows the
/dev/mem device to be disabled.

Option defaults to /dev/mem enabled.

Signed-off-by: Rob Ward <robert.ward114@googlemail.com>
---
 drivers/char/Kconfig |  9 +++++++++
 drivers/char/mem.c   | 19 ++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index efefd12..a4af822 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -6,6 +6,15 @@ menu "Character devices"
 
 source "drivers/tty/Kconfig"
 
+config DEVMEM
+	bool "/dev/mem virtual device support"
+	default y
+	help
+	  Say Y here if you want to support the /dev/mem device.
+	  The /dev/mem device is used to access areas of physical
+	  memory.
+	  When in doubt, say "Y".
+
 config DEVKMEM
 	bool "/dev/kmem virtual device support"
 	default y
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 524b707..feadc87 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -92,6 +92,7 @@ void __weak unxlate_dev_mem_ptr(unsigned long phys, void *addr)
  * This funcion reads the *physical* memory. The f_pos points directly to the
  * memory location.
  */
+#ifdef CONFIG_DEVMEM
 static ssize_t read_mem(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos)
 {
@@ -216,6 +217,7 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 	*ppos += written;
 	return written;
 }
+#endif
 
 int __weak phys_mem_access_prot_allowed(struct file *file,
 	unsigned long pfn, unsigned long size, pgprot_t *vma_prot)
@@ -273,6 +275,7 @@ static pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 #endif
 
 #ifndef CONFIG_MMU
+#if defined CONFIG_DEVMEM || defined CONFIG_DEVKMEM
 static unsigned long get_unmapped_area_mem(struct file *file,
 					   unsigned long addr,
 					   unsigned long len,
@@ -283,14 +286,16 @@ static unsigned long get_unmapped_area_mem(struct file *file,
 		return (unsigned long) -EINVAL;
 	return pgoff << PAGE_SHIFT;
 }
-
+#endif
 /* can't do an in-place private mapping if there's no MMU */
 static inline int private_mapping_ok(struct vm_area_struct *vma)
 {
 	return vma->vm_flags & VM_MAYSHARE;
 }
 #else
+#if defined CONFIG_DEVMEM || defined CONFIG_DEVKMEM
 #define get_unmapped_area_mem	NULL
+#endif
 
 static inline int private_mapping_ok(struct vm_area_struct *vma)
 {
@@ -298,6 +303,7 @@ static inline int private_mapping_ok(struct vm_area_struct *vma)
 }
 #endif
 
+#if defined CONFIG_DEVMEM || defined CONFIG_DEVKMEM
 static const struct vm_operations_struct mmap_mem_ops = {
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 	.access = generic_access_phys
@@ -337,6 +343,7 @@ static int mmap_mem(struct file *file, struct vm_area_struct *vma)
 	}
 	return 0;
 }
+#endif
 
 #ifdef CONFIG_DEVKMEM
 static int mmap_kmem(struct file *file, struct vm_area_struct *vma)
@@ -675,6 +682,7 @@ static loff_t null_lseek(struct file *file, loff_t offset, int orig)
  * also note that seeking relative to the "end of file" isn't supported:
  * it has no meaning, so it returns -EINVAL.
  */
+#if defined CONFIG_DEVMEM  || defined CONFIG_DEVKMEM || defined CONFIG_DEVPORT
 static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
 {
 	loff_t ret;
@@ -704,14 +712,20 @@ static int open_port(struct inode *inode, struct file *filp)
 {
 	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
 }
+#endif
 
 #define zero_lseek	null_lseek
 #define full_lseek      null_lseek
 #define write_zero	write_null
 #define aio_write_zero	aio_write_null
+#if defined CONFIG_DEVMEM || defined CONFIG_DEVKMEM
 #define open_mem	open_port
+#endif
+#ifdef CONFIG_DEVKMEM
 #define open_kmem	open_mem
+#endif
 
+#ifdef CONFIG_DEVMEM
 static const struct file_operations mem_fops = {
 	.llseek		= memory_lseek,
 	.read		= read_mem,
@@ -720,6 +734,7 @@ static const struct file_operations mem_fops = {
 	.open		= open_mem,
 	.get_unmapped_area = get_unmapped_area_mem,
 };
+#endif
 
 #ifdef CONFIG_DEVKMEM
 static const struct file_operations kmem_fops = {
@@ -782,7 +797,9 @@ static const struct memdev {
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
2.0.2

