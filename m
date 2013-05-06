Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab3EFNKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 09:10:38 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:34010 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab3EFNKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 09:10:35 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Jan Willeke <willeke@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: [PATCH 2/4] s390/kdump: Use ELFCORE_ADDR_NEWMEM for kdump
Date: Mon,  6 May 2013 15:09:57 +0200
Message-Id: <1367845799-29125-3-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.6
In-Reply-To: <1367845799-29125-1-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1367845799-29125-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050613-2966-0000-0000-000007859EBF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently for s390 we create the ELF core header in the 2nd kernel
with a small trick. We relocate the addresses in the ELF header in
a way that for the /proc/vmcore code it seems to be in the 1st kernel
(old) memory and the read_from_oldmem() returns the correct data.
This allows the /proc/vmcore code to use the ELF header in the
2nd kernel.

This patch now exchanges the old mechanism with the new and much
cleaner ELFCORE_ADDR_NEWMEM feature that now offcially allows to
create the ELF core header in the 2nd kernel.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/kernel/crash_dump.c | 26 +++++++-------------------
 arch/s390/kernel/setup.c      |  2 +-
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index fb8d878..f1feaaa 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -325,14 +325,6 @@ static int get_mem_chunk_cnt(void)
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
@@ -383,7 +375,7 @@ static void *notes_init(Elf64_Phdr *phdr, void *ptr, u64 notes_offset)
 	ptr = nt_vmcoreinfo(ptr);
 	memset(phdr, 0, sizeof(*phdr));
 	phdr->p_type = PT_NOTE;
-	phdr->p_offset = relocate(notes_offset);
+	phdr->p_offset = notes_offset;
 	phdr->p_filesz = (unsigned long) PTR_SUB(ptr, ptr_start);
 	phdr->p_memsz = phdr->p_filesz;
 	return ptr;
@@ -392,7 +384,7 @@ static void *notes_init(Elf64_Phdr *phdr, void *ptr, u64 notes_offset)
 /*
  * Create ELF core header (new kernel)
  */
-static void s390_elf_corehdr_create(char **elfcorebuf, size_t *elfcorebuf_sz)
+int arch_vmcore_get_elf_hdr(char **elfcorebuf, size_t *elfcorebuf_sz)
 {
 	Elf64_Phdr *phdr_notes, *phdr_loads;
 	int mem_chunk_cnt;
@@ -414,13 +406,14 @@ static void s390_elf_corehdr_create(char **elfcorebuf, size_t *elfcorebuf_sz)
 	ptr = PTR_ADD(ptr, sizeof(Elf64_Phdr) * mem_chunk_cnt);
 	/* Init notes */
 	hdr_off = PTR_DIFF(ptr, hdr);
-	ptr = notes_init(phdr_notes, ptr, ((unsigned long) hdr) + hdr_off);
+	ptr = notes_init(phdr_notes, ptr, hdr_off);
 	/* Init loads */
 	hdr_off = PTR_DIFF(ptr, hdr);
-	loads_init(phdr_loads, ((unsigned long) hdr) + hdr_off);
+	loads_init(phdr_loads, hdr_off);
 	*elfcorebuf_sz = hdr_off;
-	*elfcorebuf = (void *) relocate((unsigned long) hdr);
+	*elfcorebuf = hdr;
 	BUG_ON(*elfcorebuf_sz > alloc_size);
+	return 0;
 }
 
 /*
@@ -429,14 +422,9 @@ static void s390_elf_corehdr_create(char **elfcorebuf, size_t *elfcorebuf_sz)
  */
 static int setup_kdump_elfcorehdr(void)
 {
-	size_t elfcorebuf_sz;
-	char *elfcorebuf;
-
 	if (!OLDMEM_BASE || is_kdump_kernel())
 		return -EINVAL;
-	s390_elf_corehdr_create(&elfcorebuf, &elfcorebuf_sz);
-	elfcorehdr_addr = (unsigned long long) elfcorebuf;
-	elfcorehdr_size = elfcorebuf_sz;
+	elfcorehdr_addr = ELFCORE_ADDR_NEWMEM;
 	return 0;
 }
 
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 0f419c5..86f2ca1 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -889,7 +889,7 @@ static void __init setup_memory(void)
 		reserve_bootmem(crashk_res.start,
 				crashk_res.end - crashk_res.start + 1,
 				BOOTMEM_DEFAULT);
-	if (is_kdump_kernel())
+	if (is_kdump_kernel() && (elfcorehdr_addr != ELFCORE_ADDR_NEWMEM))
 		reserve_bootmem(elfcorehdr_addr - OLDMEM_BASE,
 				PAGE_ALIGN(elfcorehdr_size), BOOTMEM_DEFAULT);
 #endif
-- 
1.8.1.6

