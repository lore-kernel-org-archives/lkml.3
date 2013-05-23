Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987Ab3EWS5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 14:57:13 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:45290 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab3EWS5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 14:57:06 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: [PATCH v3 3/3] s390/kdump: Use vmcore for zfcpdump
Date: Thu, 23 May 2013 20:57:01 +0200
Message-Id: <1369335421-43058-4-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.6
In-Reply-To: <1369335421-43058-1-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1369335421-43058-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052318-0342-0000-0000-0000051E6CD0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Willeke <willeke@de.ibm.com>

This patch modifies the s390 copy_oldmem_page() function for zfcpdump
to read from the HSA memory if memory below HSA_SIZE bytes is requested.
Otherwise from real memory is read.

Signed-off-by: Jan Willeke <willeke@de.ibm.com>
Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/Kconfig             |  3 +-
 arch/s390/include/asm/sclp.h  |  1 +
 arch/s390/kernel/crash_dump.c | 74 ++++++++++++++++++++++++++++++++++---------
 drivers/s390/char/zcore.c     |  6 ++--
 4 files changed, 65 insertions(+), 19 deletions(-)

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
index aeb1207..fd0dc60 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -16,6 +16,7 @@
 #include <asm/os_info.h>
 #include <asm/elf.h>
 #include <asm/ipl.h>
+#include <asm/sclp.h>
 
 #define PTR_ADD(x, y) (((char *) (x)) + ((unsigned long) (y)))
 #define PTR_SUB(x, y) (((char *) (x)) - ((unsigned long) (y)))
@@ -24,6 +25,25 @@
 static size_t elfcorebuf_sz;
 static char *elfcorebuf;
 
+/* For pages below ZFCPDUMP_HSA_SIZE memory from the HSA is copied. Otherwise
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
 /*
  * Copy one page from "oldmem"
  *
@@ -31,15 +51,10 @@ static char *elfcorebuf;
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
@@ -54,6 +69,23 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 }
 
 /*
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
  * Copy memory from old kernel
  */
 int copy_from_oldmem(void *dest, void *src, size_t count)
@@ -61,11 +93,21 @@ int copy_from_oldmem(void *dest, void *src, size_t count)
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
@@ -458,7 +500,9 @@ ssize_t arch_read_from_crash_header(char *buf, size_t count, u64 *ppos)
  */
 static int setup_kdump_elfcorehdr(void)
 {
-	if (!OLDMEM_BASE || is_kdump_kernel())
+	if (!OLDMEM_BASE && (ipl_info.type != IPL_TYPE_FCP_DUMP))
+		return -EINVAL;
+	if (is_kdump_kernel())
 		return -EINVAL;
 	s390_elf_corehdr_create(&elfcorebuf, &elfcorebuf_sz);
 	elfcorehdr_addr = __pa(elfcorebuf);
@@ -466,4 +510,4 @@ static int setup_kdump_elfcorehdr(void)
 	return 0;
 }
 
-subsys_initcall(setup_kdump_elfcorehdr);
+subsys_initcall_sync(setup_kdump_elfcorehdr);
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

