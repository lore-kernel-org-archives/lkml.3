Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab3EVR6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 13:58:47 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:50921 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab3EVR6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 13:58:43 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: [PATCH v2 1/3] kdump: Introduce ELF header in new memory feature
Date: Wed, 22 May 2013 19:58:35 +0200
Message-Id: <1369245517-16204-2-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.6
In-Reply-To: <1369245517-16204-1-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1369245517-16204-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052217-1948-0000-0000-0000053992AB
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

 * Set elfcorehdr_addr to ELFCORE_ADDR_NEWMEM
   -> is_kdump_kernel() will return true
 * Override arch_get_crash_header() to return the address of the ELF
   header in new memory.
 * Override arch_free_crash_header() to free the memory of the ELF
   header in new memory.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 fs/proc/vmcore.c           | 80 +++++++++++++++++++++++++++++++++++-----------
 include/linux/crash_dump.h |  3 ++
 2 files changed, 65 insertions(+), 18 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 6ba32f8..d97ed31 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -123,6 +123,47 @@ static ssize_t read_from_oldmem(char *buf, size_t count,
 	return read;
 }
 
+/*
+ * Read from the current (new) kernel memory
+ */
+static ssize_t read_from_newmem(char *buf, size_t count, u64 *ppos, int userbuf)
+{
+	if (userbuf) {
+		if (copy_to_user(buf, (void *)*ppos, count))
+			return -EFAULT;
+	} else {
+		memcpy(buf, (void *)*ppos, count);
+	}
+	*ppos += count;
+	return count;
+}
+
+/*
+ * Provide access to the header
+ */
+static ssize_t read_from_crash_header(char *buf, size_t count, u64 *ppos,
+				      int userbuf)
+{
+	if (elfcorehdr_addr == ELFCORE_ADDR_NEWMEM)
+		return read_from_newmem(buf, count, ppos, userbuf);
+	else
+		return read_from_oldmem(buf, count, ppos, userbuf);
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
@@ -356,7 +397,7 @@ static int __init get_note_number_and_size_elf64(const Elf64_Ehdr *ehdr_ptr,
 		notes_section = kmalloc(max_sz, GFP_KERNEL);
 		if (!notes_section)
 			return -ENOMEM;
-		rc = read_from_oldmem(notes_section, max_sz, &offset, 0);
+		rc = read_from_crash_header(notes_section, max_sz, &offset, 0);
 		if (rc < 0) {
 			kfree(notes_section);
 			return rc;
@@ -412,7 +453,7 @@ static int __init copy_notes_elf64(const Elf64_Ehdr *ehdr_ptr, char *notes_buf)
 		notes_section = kmalloc(max_sz, GFP_KERNEL);
 		if (!notes_section)
 			return -ENOMEM;
-		rc = read_from_oldmem(notes_section, max_sz, &offset, 0);
+		rc = read_from_crash_header(notes_section, max_sz, &offset, 0);
 		if (rc < 0) {
 			kfree(notes_section);
 			return rc;
@@ -428,8 +469,8 @@ static int __init copy_notes_elf64(const Elf64_Ehdr *ehdr_ptr, char *notes_buf)
 			nhdr_ptr = (Elf64_Nhdr*)((char*)nhdr_ptr + sz);
 		}
 		offset = phdr_ptr->p_offset;
-		rc = read_from_oldmem(notes_buf + phdr_sz, real_sz,
-				      &offset, 0);
+		rc = read_from_crash_header(notes_buf + phdr_sz, real_sz,
+					    &offset, 0);
 		if (rc < 0) {
 			kfree(notes_section);
 			return rc;
@@ -533,7 +574,7 @@ static int __init get_note_number_and_size_elf32(const Elf32_Ehdr *ehdr_ptr,
 		notes_section = kmalloc(max_sz, GFP_KERNEL);
 		if (!notes_section)
 			return -ENOMEM;
-		rc = read_from_oldmem(notes_section, max_sz, &offset, 0);
+		rc = read_from_crash_header(notes_section, max_sz, &offset, 0);
 		if (rc < 0) {
 			kfree(notes_section);
 			return rc;
@@ -589,7 +630,7 @@ static int __init copy_notes_elf32(const Elf32_Ehdr *ehdr_ptr, char *notes_buf)
 		notes_section = kmalloc(max_sz, GFP_KERNEL);
 		if (!notes_section)
 			return -ENOMEM;
-		rc = read_from_oldmem(notes_section, max_sz, &offset, 0);
+		rc = read_from_crash_header(notes_section, max_sz, &offset, 0);
 		if (rc < 0) {
 			kfree(notes_section);
 			return rc;
@@ -605,8 +646,8 @@ static int __init copy_notes_elf32(const Elf32_Ehdr *ehdr_ptr, char *notes_buf)
 			nhdr_ptr = (Elf32_Nhdr*)((char*)nhdr_ptr + sz);
 		}
 		offset = phdr_ptr->p_offset;
-		rc = read_from_oldmem(notes_buf + phdr_sz, real_sz,
-				      &offset, 0);
+		rc = read_from_crash_header(notes_buf + phdr_sz, real_sz,
+					    &offset, 0);
 		if (rc < 0) {
 			kfree(notes_section);
 			return rc;
@@ -804,10 +845,11 @@ static int __init parse_crash_elf64_headers(void)
 	Elf64_Ehdr ehdr;
 	u64 addr;
 
-	addr = elfcorehdr_addr;
+	addr = arch_get_crash_header();
 
 	/* Read Elf header */
-	rc = read_from_oldmem((char*)&ehdr, sizeof(Elf64_Ehdr), &addr, 0);
+	rc = read_from_crash_header((char *)&ehdr, sizeof(Elf64_Ehdr),
+				    &addr, 0);
 	if (rc < 0)
 		return rc;
 
@@ -832,8 +874,8 @@ static int __init parse_crash_elf64_headers(void)
 					       get_order(elfcorebuf_sz_orig));
 	if (!elfcorebuf)
 		return -ENOMEM;
-	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
+	addr = arch_get_crash_header();
+	rc = read_from_crash_header(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
 	if (rc < 0) {
 		free_pages((unsigned long)elfcorebuf,
 			   get_order(elfcorebuf_sz_orig));
@@ -867,10 +909,11 @@ static int __init parse_crash_elf32_headers(void)
 	Elf32_Ehdr ehdr;
 	u64 addr;
 
-	addr = elfcorehdr_addr;
+	addr = arch_get_crash_header();
 
 	/* Read Elf header */
-	rc = read_from_oldmem((char*)&ehdr, sizeof(Elf32_Ehdr), &addr, 0);
+	rc = read_from_crash_header((char *)&ehdr, sizeof(Elf32_Ehdr),
+				    &addr, 0);
 	if (rc < 0)
 		return rc;
 
@@ -895,8 +938,8 @@ static int __init parse_crash_elf32_headers(void)
 					       get_order(elfcorebuf_sz_orig));
 	if (!elfcorebuf)
 		return -ENOMEM;
-	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
+	addr = arch_get_crash_header();
+	rc = read_from_crash_header(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
 	if (rc < 0) {
 		free_pages((unsigned long)elfcorebuf,
 			   get_order(elfcorebuf_sz_orig));
@@ -930,8 +973,8 @@ static int __init parse_crash_elf_headers(void)
 	u64 addr;
 	int rc=0;
 
-	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(e_ident, EI_NIDENT, &addr, 0);
+	addr = arch_get_crash_header();
+	rc = read_from_crash_header(e_ident, EI_NIDENT, &addr, 0);
 	if (rc < 0)
 		return rc;
 	if (memcmp(e_ident, ELFMAG, SELFMAG) != 0) {
@@ -961,6 +1004,7 @@ static int __init parse_crash_elf_headers(void)
 		pr_warn("Warning: Core image elf header is not sane\n");
 		return -EINVAL;
 	}
+	arch_free_crash_header();
 	return 0;
 }
 
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 37e4f8d..a1ef7b5 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -8,12 +8,15 @@
 
 #define ELFCORE_ADDR_MAX	(-1ULL)
 #define ELFCORE_ADDR_ERR	(-2ULL)
+#define ELFCORE_ADDR_NEWMEM	(-3ULL)
 
 extern unsigned long long elfcorehdr_addr;
 extern unsigned long long elfcorehdr_size;
 
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
+extern unsigned long long __weak arch_get_crash_header(void);
+extern void __weak arch_free_crash_header(void);
 
 /* Architecture code defines this if there are other possible ELF
  * machine types, e.g. on bi-arch capable hardware. */
-- 
1.8.1.6

