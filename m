Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab3FGQ4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:56:15 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:58704 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479Ab3FGQ4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:56:07 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH v5 2/5] s390/vmcore: Use ELF header in new memory feature
Date: Fri,  7 Jun 2013 18:55:58 +0200
Message-Id: <1370624161-2298-3-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.6
In-Reply-To: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060716-0542-0000-0000-0000057AC7ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch now exchanges the old relocate mechanism with the new
arch function call override mechanism that allows to create the ELF
core header in the 2nd kernel.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/kernel/crash_dump.c | 70 ++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 27 deletions(-)

diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index f703d91..a17f8d4 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -22,6 +22,11 @@
 #define PTR_DIFF(x, y) ((unsigned long)(((char *) (x)) - ((unsigned long) (y))))
 
 /*
+ * Pointer to ELF header in new kernel
+ */
+static void *elfcorehdr_newmem;
+
+/*
  * Copy one page from "oldmem"
  *
  * For the kdump reserved memory this functions performs a swap operation:
@@ -325,14 +330,6 @@ static int get_mem_chunk_cnt(void)
 }
 
 /*
- * Relocate pointer in order to allow vmcore code access the data
- */
-static inline unsigned long relocate(unsigned long addr)
-{
-	return OLDMEM_BASE + addr;
-}
-
-/*
  * Initialize ELF loads (new kernel)
  */
 static int loads_init(Elf64_Phdr *phdr, u64 loads_offset)
@@ -383,7 +380,7 @@ static void *notes_init(Elf64_Phdr *phdr, void *ptr, u64 notes_offset)
 	ptr = nt_vmcoreinfo(ptr);
 	memset(phdr, 0, sizeof(*phdr));
 	phdr->p_type = PT_NOTE;
-	phdr->p_offset = relocate(notes_offset);
+	phdr->p_offset = notes_offset;
 	phdr->p_filesz = (unsigned long) PTR_SUB(ptr, ptr_start);
 	phdr->p_memsz = phdr->p_filesz;
 	return ptr;
@@ -392,7 +389,7 @@ static void *notes_init(Elf64_Phdr *phdr, void *ptr, u64 notes_offset)
 /*
  * Create ELF core header (new kernel)
  */
-static void s390_elf_corehdr_create(char **elfcorebuf, size_t *elfcorebuf_sz)
+int elfcorehdr_alloc(void)
 {
 	Elf64_Phdr *phdr_notes, *phdr_loads;
 	int mem_chunk_cnt;
@@ -400,6 +397,8 @@ static void s390_elf_corehdr_create(char **elfcorebuf, size_t *elfcorebuf_sz)
 	u32 alloc_size;
 	u64 hdr_off;
 
+	if (!OLDMEM_BASE)
+		return -ENOENT;
 	mem_chunk_cnt = get_mem_chunk_cnt();
 
 	alloc_size = 0x1000 + get_cpu_cnt() * 0x300 +
@@ -417,27 +416,44 @@ static void s390_elf_corehdr_create(char **elfcorebuf, size_t *elfcorebuf_sz)
 	ptr = notes_init(phdr_notes, ptr, ((unsigned long) hdr) + hdr_off);
 	/* Init loads */
 	hdr_off = PTR_DIFF(ptr, hdr);
-	loads_init(phdr_loads, ((unsigned long) hdr) + hdr_off);
-	*elfcorebuf_sz = hdr_off;
-	*elfcorebuf = (void *) relocate((unsigned long) hdr);
-	BUG_ON(*elfcorebuf_sz > alloc_size);
+	loads_init(phdr_loads, hdr_off);
+	elfcorehdr_addr = (unsigned long long) hdr;
+	elfcorehdr_size = (unsigned long long) hdr_off;
+	elfcorehdr_newmem = hdr;
+	BUG_ON(elfcorehdr_size > alloc_size);
+	return 0;
 }
 
 /*
- * Create kdump ELF core header in new kernel, if it has not been passed via
- * the "elfcorehdr" kernel parameter
+ * Free ELF core header (new kernel)
  */
-static int setup_kdump_elfcorehdr(void)
+void elfcorehdr_free(void)
 {
-	size_t elfcorebuf_sz;
-	char *elfcorebuf;
-
-	if (!OLDMEM_BASE || is_kdump_kernel())
-		return -EINVAL;
-	s390_elf_corehdr_create(&elfcorebuf, &elfcorebuf_sz);
-	elfcorehdr_addr = (unsigned long long) elfcorebuf;
-	elfcorehdr_size = elfcorebuf_sz;
-	return 0;
+	if (!elfcorehdr_newmem)
+		return;
+	vfree(elfcorehdr_newmem);
+	elfcorehdr_newmem = NULL;
 }
 
-subsys_initcall(setup_kdump_elfcorehdr);
+/*
+ * Read from ELF header
+ */
+ssize_t elfcorehdr_read(char *buf, size_t count, u64 *ppos)
+{
+	void *src = (void *)(unsigned long)*ppos;
+
+	if (elfcorehdr_newmem)
+		memcpy(buf, src, count);
+	else
+		copy_from_oldmem(buf, src, count);
+	*ppos += count;
+	return count;
+}
+
+/*
+ * Read from ELF notes data
+ */
+ssize_t elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos)
+{
+	return elfcorehdr_read(buf, count, ppos);
+}
-- 
1.8.1.6

