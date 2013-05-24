Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab3EXL3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:29:49 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:41602 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3EXL3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:29:47 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: [PATCH v4 1/3] kdump: Introduce ELF header in new memory feature
Date: Fri, 24 May 2013 13:29:41 +0200
Message-Id: <1369394983-65360-2-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.6
In-Reply-To: <1369394983-65360-1-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1369394983-65360-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052411-3548-0000-0000-0000057C53A5
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
cleaner function call override feature that now offcially allows to
create the ELF core header in the 2nd kernel.

To use the new feature the following has to be done by the architecture
backend code:

 * Override arch_get_crash_header() to return the address of the ELF
   header in new memory.
 * Override arch_free_crash_header() to free the memory of the ELF
   header in new memory.
 * Override arch_read_from_crash_header() to read from the ELF header
   in new memory
 * Set elfcorehdr_addr to the address of ELF header in new memory

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 fs/proc/vmcore.c           | 58 ++++++++++++++++++++++++++++++++++------------
 include/linux/crash_dump.h |  4 ++++
 2 files changed, 47 insertions(+), 15 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 80221d7..eb47346 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -123,6 +123,28 @@ static ssize_t read_from_oldmem(char *buf, size_t count,
 	return read;
 }
 
+/*
+ * Architetures may override this function to read header data
+ */
+ssize_t __weak arch_read_from_crash_header(char *buf, size_t count, u64 *ppos)
+{
+	return read_from_oldmem(buf, count, ppos, 0);
+}
+
+/*
+ * Architetures may override this function to get header address
+ */
+unsigned long long __weak arch_get_crash_header(void)
+{
+	return elfcorehdr_addr;
+}
+
+/*
+ * Architetures may override this function to free header
+ */
+void __weak arch_free_crash_header(void)
+{}
+
 /* Read from the ELF header and then the crash dump. On error, negative value is
  * returned otherwise number of bytes read are returned.
  */
@@ -335,7 +357,8 @@ static int __init update_note_header_size_elf64(const Elf64_Ehdr *ehdr_ptr)
 		notes_section = kmalloc(max_sz, GFP_KERNEL);
 		if (!notes_section)
 			return -ENOMEM;
-		rc = read_from_oldmem(notes_section, max_sz, &offset, 0);
+		rc = arch_read_from_crash_header(notes_section, max_sz,
+						 &offset);
 		if (rc < 0) {
 			kfree(notes_section);
 			return rc;
@@ -422,7 +445,8 @@ static int __init copy_notes_elf64(const Elf64_Ehdr *ehdr_ptr, char *notes_buf)
 		if (phdr_ptr->p_type != PT_NOTE)
 			continue;
 		offset = phdr_ptr->p_offset;
-		rc = read_from_oldmem(notes_buf, phdr_ptr->p_memsz, &offset, 0);
+		rc =  arch_read_from_crash_header(notes_buf, phdr_ptr->p_memsz,
+						  &offset, 0);
 		if (rc < 0)
 			return rc;
 		notes_buf += phdr_ptr->p_memsz;
@@ -521,7 +545,8 @@ static int __init update_note_header_size_elf32(const Elf32_Ehdr *ehdr_ptr)
 		notes_section = kmalloc(max_sz, GFP_KERNEL);
 		if (!notes_section)
 			return -ENOMEM;
-		rc = read_from_oldmem(notes_section, max_sz, &offset, 0);
+		rc = arch_read_from_crash_header(notes_section, max_sz,
+						 &offset);
 		if (rc < 0) {
 			kfree(notes_section);
 			return rc;
@@ -608,7 +633,8 @@ static int __init copy_notes_elf32(const Elf32_Ehdr *ehdr_ptr, char *notes_buf)
 		if (phdr_ptr->p_type != PT_NOTE)
 			continue;
 		offset = phdr_ptr->p_offset;
-		rc = read_from_oldmem(notes_buf, phdr_ptr->p_memsz, &offset, 0);
+		rc =  arch_read_from_crash_header(notes_buf, phdr_ptr->p_memsz,
+						  &offset, 0);
 		if (rc < 0)
 			return rc;
 		notes_buf += phdr_ptr->p_memsz;
@@ -791,10 +817,11 @@ static int __init parse_crash_elf64_headers(void)
 	Elf64_Ehdr ehdr;
 	u64 addr;
 
-	addr = elfcorehdr_addr;
+	addr = arch_get_crash_header();
 
 	/* Read Elf header */
-	rc = read_from_oldmem((char*)&ehdr, sizeof(Elf64_Ehdr), &addr, 0);
+	rc = arch_read_from_crash_header((char *)&ehdr, sizeof(Elf64_Ehdr),
+					 &addr);
 	if (rc < 0)
 		return rc;
 
@@ -819,8 +846,8 @@ static int __init parse_crash_elf64_headers(void)
 					       get_order(elfcorebuf_sz_orig));
 	if (!elfcorebuf)
 		return -ENOMEM;
-	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
+	addr = arch_get_crash_header();
+	rc = arch_read_from_crash_header(elfcorebuf, elfcorebuf_sz_orig, &addr);
 	if (rc < 0) {
 		free_pages((unsigned long)elfcorebuf,
 			   get_order(elfcorebuf_sz_orig));
@@ -853,10 +880,11 @@ static int __init parse_crash_elf32_headers(void)
 	Elf32_Ehdr ehdr;
 	u64 addr;
 
-	addr = elfcorehdr_addr;
+	addr = arch_get_crash_header();
 
 	/* Read Elf header */
-	rc = read_from_oldmem((char*)&ehdr, sizeof(Elf32_Ehdr), &addr, 0);
+	rc = arch_read_from_crash_header((char *)&ehdr, sizeof(Elf32_Ehdr),
+					 &addr);
 	if (rc < 0)
 		return rc;
 
@@ -881,8 +909,8 @@ static int __init parse_crash_elf32_headers(void)
 					       get_order(elfcorebuf_sz_orig));
 	if (!elfcorebuf)
 		return -ENOMEM;
-	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
+	addr = arch_get_crash_header();
+	rc = arch_read_from_crash_header(elfcorebuf, elfcorebuf_sz_orig, &addr);
 	if (rc < 0) {
 		free_pages((unsigned long)elfcorebuf,
 			   get_order(elfcorebuf_sz_orig));
@@ -915,8 +943,8 @@ static int __init parse_crash_elf_headers(void)
 	u64 addr;
 	int rc=0;
 
-	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(e_ident, EI_NIDENT, &addr, 0);
+	addr = arch_get_crash_header();
+	rc = arch_read_from_crash_header(e_ident, EI_NIDENT, &addr);
 	if (rc < 0)
 		return rc;
 	if (memcmp(e_ident, ELFMAG, SELFMAG) != 0) {
@@ -940,7 +968,7 @@ static int __init parse_crash_elf_headers(void)
 	/* Determine vmcore size. */
 	vmcore_size = get_vmcore_size(elfcorebuf_sz, elfnotes_sz,
 				      &vmcore_list);
-
+	arch_free_crash_header();
 	return 0;
 }
 
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 37e4f8d..c66da41 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -14,6 +14,10 @@ extern unsigned long long elfcorehdr_size;
 
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
+extern unsigned long long __weak arch_get_crash_header(void);
+extern void __weak arch_free_crash_header(void);
+extern ssize_t __weak arch_read_from_crash_header(char *buf, size_t count,
+						  u64 *ppos);
 
 /* Architecture code defines this if there are other possible ELF
  * machine types, e.g. on bi-arch capable hardware. */
-- 
1.8.1.6

