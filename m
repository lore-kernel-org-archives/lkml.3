Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3FGQ4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:56:13 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:40334 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab3FGQ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:56:08 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH v5 5/5] s390/vmcore: Use vmcore for zfcpdump
Date: Fri,  7 Jun 2013 18:56:01 +0200
Message-Id: <1370624161-2298-6-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.6
In-Reply-To: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060716-0342-0000-0000-00000541CD1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the s390 copy_oldmem_page() and remap_oldmem_pfn_range()
function for zfcpdump to read from the HSA memory if memory below HSA_SIZE
bytes is requested. Otherwise real memory is used.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/Kconfig             |   3 +-
 arch/s390/include/asm/sclp.h  |   1 +
 arch/s390/kernel/crash_dump.c | 113 ++++++++++++++++++++++++++++++++++++------
 drivers/s390/char/zcore.c     |   6 +--
 4 files changed, 103 insertions(+), 20 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 2c9789d..a0d78f1 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -516,6 +516,7 @@ config CRASH_DUMP
 	bool "kernel crash dumps"
 	depends on 64BIT && SMP
 	select KEXEC
+	select ZFCPDUMP
 	help
 	  Generate crash dump after being started by kexec.
 	  Crash dump kernels are loaded in the main kernel with kexec-tools
@@ -526,7 +527,7 @@ config CRASH_DUMP
 config ZFCPDUMP
 	def_bool n
 	prompt "zfcpdump support"
-	select SMP
+	depends on SMP
 	help
 	  Select this option if you want to build an zfcpdump enabled kernel.
 	  Refer to <file:Documentation/s390/zfcpdump.txt> for more details on this.
diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
index 06a1361..7dc7f9c 100644
--- a/arch/s390/include/asm/sclp.h
+++ b/arch/s390/include/asm/sclp.h
@@ -56,5 +56,6 @@ bool sclp_has_linemode(void);
 bool sclp_has_vt220(void);
 int sclp_pci_configure(u32 fid);
 int sclp_pci_deconfigure(u32 fid);
+int memcpy_hsa(void *dest, unsigned long src, size_t count, int mode);
 
 #endif /* _ASM_S390_SCLP_H */
diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index 12ccc3c..ee0770d 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -16,6 +16,7 @@
 #include <asm/os_info.h>
 #include <asm/elf.h>
 #include <asm/ipl.h>
+#include <asm/sclp.h>
 
 #define PTR_ADD(x, y) (((char *) (x)) + ((unsigned long) (y)))
 #define PTR_SUB(x, y) (((char *) (x)) - ((unsigned long) (y)))
@@ -27,21 +28,36 @@
 static void *elfcorehdr_newmem;
 
 /*
+ * For pages below ZFCPDUMP_HSA_SIZE memory from the HSA is copied. Otherwise
+ * real memory copy is used.
+ */
+static ssize_t copy_oldmem_page_zfcpdump(char *buf, size_t csize,
+					 unsigned long src, int userbuf)
+{
+	if (src < ZFCPDUMP_HSA_SIZE) {
+		if (memcpy_hsa(buf, src, csize, userbuf) < 0)
+			return -EINVAL;
+	} else {
+		if (userbuf)
+			copy_to_user_real((void __force __user *) buf,
+					  (void *) src, csize);
+		else
+			memcpy_real(buf, (void *) src, csize);
+	}
+	return csize;
+}
+
+/*
  * Copy one page from "oldmem"
  *
  * For the kdump reserved memory this functions performs a swap operation:
  *  - [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE] is mapped to [0 - OLDMEM_SIZE].
  *  - [0 - OLDMEM_SIZE] is mapped to [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE]
  */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
-			 size_t csize, unsigned long offset, int userbuf)
-{
-	unsigned long src;
+static ssize_t copy_oldmem_page_kdump(char *buf, size_t csize,
+				      unsigned long src, int userbuf)
 
-	if (!csize)
-		return 0;
-
-	src = (pfn << PAGE_SHIFT) + offset;
+{
 	if (src < OLDMEM_SIZE)
 		src += OLDMEM_BASE;
 	else if (src > OLDMEM_BASE &&
@@ -56,13 +72,31 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 }
 
 /*
- * Remap "oldmem"
+ * Copy one page from "oldmem"
+ */
+ssize_t copy_oldmem_page(unsigned long pfn, char *buf, size_t csize,
+			 unsigned long offset, int userbuf)
+{
+	unsigned long src;
+	if (!csize)
+		return 0;
+	src = (pfn << PAGE_SHIFT) + offset;
+
+	if (OLDMEM_BASE)
+		return copy_oldmem_page_kdump(buf, csize, src, userbuf);
+	else
+		return copy_oldmem_page_zfcpdump(buf, csize, src, userbuf);
+}
+
+/*
+ * Remap "oldmem" for kdump
  *
  * For the kdump reserved memory this functions performs a swap operation:
  * [0 - OLDMEM_SIZE] is mapped to [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE]
  */
-int remap_oldmem_pfn_range(struct vm_area_struct *vma, unsigned long from,
-			   unsigned long pfn, unsigned long size, pgprot_t prot)
+static int remap_oldmem_pfn_range_kdump(struct vm_area_struct *vma,
+					unsigned long from, unsigned long pfn,
+					unsigned long size, pgprot_t prot)
 {
 	unsigned long size_old;
 	int rc;
@@ -82,6 +116,43 @@ int remap_oldmem_pfn_range(struct vm_area_struct *vma, unsigned long from,
 }
 
 /*
+ * Remap "oldmem" for zfcpdump
+ *
+ * We only map available memory above ZFCPDUMP_HSA_SIZE. Memory below
+ * ZFCPDUMP_HSA_SIZE is read on demand using the copy_oldmem_page() function.
+ */
+static int remap_oldmem_pfn_range_zfcpdump(struct vm_area_struct *vma,
+					   unsigned long from,
+					   unsigned long pfn,
+					   unsigned long size, pgprot_t prot)
+{
+	unsigned long size_hsa;
+
+	if (pfn < ZFCPDUMP_HSA_SIZE >> PAGE_SHIFT) {
+		size_hsa = min(size, OLDMEM_SIZE - (pfn << PAGE_SHIFT));
+		if (size == size_hsa)
+			return 0;
+		size -= size_hsa;
+		from += size_hsa;
+		pfn += size_hsa >> PAGE_SHIFT;
+	}
+	return remap_pfn_range(vma, from, pfn, size, prot);
+}
+
+/*
+ * Remap "oldmem" for kdump or zfcpdump
+ */
+int remap_oldmem_pfn_range(struct vm_area_struct *vma, unsigned long from,
+			   unsigned long pfn, unsigned long size, pgprot_t prot)
+{
+	if (OLDMEM_BASE)
+		return remap_oldmem_pfn_range_kdump(vma, from, pfn, size, prot);
+	else
+		return remap_oldmem_pfn_range_zfcpdump(vma, from, pfn, size,
+						       prot);
+}
+
+/*
  * Copy memory from old kernel
  */
 int copy_from_oldmem(void *dest, void *src, size_t count)
@@ -89,11 +160,21 @@ int copy_from_oldmem(void *dest, void *src, size_t count)
 	unsigned long copied = 0;
 	int rc;
 
-	if ((unsigned long) src < OLDMEM_SIZE) {
-		copied = min(count, OLDMEM_SIZE - (unsigned long) src);
-		rc = memcpy_real(dest, src + OLDMEM_BASE, copied);
-		if (rc)
-			return rc;
+	if (OLDMEM_BASE) {
+		if ((unsigned long) src < OLDMEM_SIZE) {
+			copied = min(count, OLDMEM_SIZE - (unsigned long) src);
+			rc = memcpy_real(dest, src + OLDMEM_BASE, copied);
+			if (rc)
+				return rc;
+		}
+	} else {
+		if ((unsigned long) src < ZFCPDUMP_HSA_SIZE) {
+			copied = min(count,
+				     ZFCPDUMP_HSA_SIZE - (unsigned long) src);
+			rc = memcpy_hsa(dest, (unsigned long) src, copied, 0);
+			if (rc)
+				return rc;
+		}
 	}
 	return memcpy_real(dest + copied, src + copied, count - copied);
 }
diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index 9e5e146..794820a 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -30,8 +30,8 @@
 
 #define TRACE(x...) debug_sprintf_event(zcore_dbf, 1, x)
 
-#define TO_USER		0
-#define TO_KERNEL	1
+#define TO_USER		1
+#define TO_KERNEL	0
 #define CHUNK_INFO_SIZE	34 /* 2 16-byte char, each followed by blank */
 
 enum arch_id {
@@ -73,7 +73,7 @@ static struct ipl_parameter_block *ipl_block;
  * @count: Size of buffer, which should be copied
  * @mode:  Either TO_KERNEL or TO_USER
  */
-static int memcpy_hsa(void *dest, unsigned long src, size_t count, int mode)
+int memcpy_hsa(void *dest, unsigned long src, size_t count, int mode)
 {
 	int offs, blk_num;
 	static char buf[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
-- 
1.8.1.6

