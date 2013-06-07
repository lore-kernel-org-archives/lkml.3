Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab3FGQ4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:56:22 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:59715 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab3FGQ4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:56:07 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH v5 1/5] vmcore: Introduce ELF header in new memory feature
Date: Fri,  7 Jun 2013 18:55:57 +0200
Message-Id: <1370624161-2298-2-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.6
In-Reply-To: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060716-5024-0000-0000-00000644D9E9
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

To use the new feature the following function have to be defined
by the architecture backend code to read from new memory:

 * elfcorehdr_alloc: Return the address and size of the ELF header
 * elfcorehdr_free: Free the memory of the ELF header
 * elfcorehdr_read: Read from ELF header
 * elfcorehdr_read_notes: Read from ELF notes

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 fs/proc/vmcore.c           | 63 +++++++++++++++++++++++++++++++++++++---------
 include/linux/crash_dump.h |  5 ++++
 2 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 0f6db52..221f84b 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -123,6 +123,36 @@ static ssize_t read_from_oldmem(char *buf, size_t count,
 	return read;
 }
 
+/*
+ * Architectures may override this function to allocate ELF header in 2nd kernel
+ */
+int __weak elfcorehdr_alloc(void)
+{
+	return -ENODEV;
+}
+
+/*
+ * Architectures may override this function to free header
+ */
+void __weak elfcorehdr_free(void)
+{}
+
+/*
+ * Architectures may override this function to read from ELF header
+ */
+ssize_t __weak elfcorehdr_read(char *buf, size_t count, u64 *ppos)
+{
+	return read_from_oldmem(buf, count, ppos, 0);
+}
+
+/*
+ * Architectures may override this function to read from notes sections
+ */
+ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos)
+{
+	return read_from_oldmem(buf, count, ppos, 0);
+}
+
 /* Read from the ELF header and then the crash dump. On error, negative value is
  * returned otherwise number of bytes read are returned.
  */
@@ -322,7 +352,7 @@ static int __init update_note_header_size_elf64(const Elf64_Ehdr *ehdr_ptr)
 		notes_section = kmalloc(max_sz, GFP_KERNEL);
 		if (!notes_section)
 			return -ENOMEM;
-		rc = read_from_oldmem(notes_section, max_sz, &offset, 0);
+		rc = elfcorehdr_read_notes(notes_section, max_sz, &offset);
 		if (rc < 0) {
 			kfree(notes_section);
 			return rc;
@@ -409,7 +439,8 @@ static int __init copy_notes_elf64(const Elf64_Ehdr *ehdr_ptr, char *notes_buf)
 		if (phdr_ptr->p_type != PT_NOTE)
 			continue;
 		offset = phdr_ptr->p_offset;
-		rc = read_from_oldmem(notes_buf, phdr_ptr->p_memsz, &offset, 0);
+		rc = elfcorehdr_read_notes(notes_buf, phdr_ptr->p_memsz,
+					   &offset);
 		if (rc < 0)
 			return rc;
 		notes_buf += phdr_ptr->p_memsz;
@@ -510,7 +541,7 @@ static int __init update_note_header_size_elf32(const Elf32_Ehdr *ehdr_ptr)
 		notes_section = kmalloc(max_sz, GFP_KERNEL);
 		if (!notes_section)
 			return -ENOMEM;
-		rc = read_from_oldmem(notes_section, max_sz, &offset, 0);
+		rc = elfcorehdr_read_notes(notes_section, max_sz, &offset);
 		if (rc < 0) {
 			kfree(notes_section);
 			return rc;
@@ -597,7 +628,8 @@ static int __init copy_notes_elf32(const Elf32_Ehdr *ehdr_ptr, char *notes_buf)
 		if (phdr_ptr->p_type != PT_NOTE)
 			continue;
 		offset = phdr_ptr->p_offset;
-		rc = read_from_oldmem(notes_buf, phdr_ptr->p_memsz, &offset, 0);
+		rc = elfcorehdr_read_notes(notes_buf, phdr_ptr->p_memsz,
+					   &offset);
 		if (rc < 0)
 			return rc;
 		notes_buf += phdr_ptr->p_memsz;
@@ -793,7 +825,7 @@ static int __init parse_crash_elf64_headers(void)
 	addr = elfcorehdr_addr;
 
 	/* Read Elf header */
-	rc = read_from_oldmem((char*)&ehdr, sizeof(Elf64_Ehdr), &addr, 0);
+	rc = elfcorehdr_read((char *)&ehdr, sizeof(Elf64_Ehdr), &addr);
 	if (rc < 0)
 		return rc;
 
@@ -820,7 +852,7 @@ static int __init parse_crash_elf64_headers(void)
 	if (!elfcorebuf)
 		return -ENOMEM;
 	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
+	rc = elfcorehdr_read(elfcorebuf, elfcorebuf_sz_orig, &addr);
 	if (rc < 0)
 		goto fail;
 
@@ -849,7 +881,7 @@ static int __init parse_crash_elf32_headers(void)
 	addr = elfcorehdr_addr;
 
 	/* Read Elf header */
-	rc = read_from_oldmem((char*)&ehdr, sizeof(Elf32_Ehdr), &addr, 0);
+	rc = elfcorehdr_read((char *)&ehdr, sizeof(Elf32_Ehdr), &addr);
 	if (rc < 0)
 		return rc;
 
@@ -875,7 +907,7 @@ static int __init parse_crash_elf32_headers(void)
 	if (!elfcorebuf)
 		return -ENOMEM;
 	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
+	rc = elfcorehdr_read(elfcorebuf, elfcorebuf_sz_orig, &addr);
 	if (rc < 0)
 		goto fail;
 
@@ -902,7 +934,7 @@ static int __init parse_crash_elf_headers(void)
 	int rc=0;
 
 	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(e_ident, EI_NIDENT, &addr, 0);
+	rc = elfcorehdr_read(e_ident, EI_NIDENT, &addr);
 	if (rc < 0)
 		return rc;
 	if (memcmp(e_ident, ELFMAG, SELFMAG) != 0) {
@@ -935,10 +967,17 @@ static int __init vmcore_init(void)
 {
 	int rc = 0;
 
-	/* If elfcorehdr= has been passed in cmdline, then capture the dump.*/
-	if (!(is_vmcore_usable()))
-		return rc;
+	/*
+	 * If elfcorehdr= has not been passed in cmdline, try to get the
+	 * header from 2nd kernel, then capture the dump.
+	 */
+	if (!(is_vmcore_usable())) {
+		rc = elfcorehdr_alloc();
+		if (rc)
+			return rc;
+	}
 	rc = parse_crash_elf_headers();
+	elfcorehdr_free();
 	if (rc) {
 		pr_warn("Kdump: vmcore not initialized\n");
 		return rc;
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 37e4f8d..dd0f434 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -12,6 +12,11 @@
 extern unsigned long long elfcorehdr_addr;
 extern unsigned long long elfcorehdr_size;
 
+extern int __weak elfcorehdr_alloc(void);
+extern void __weak elfcorehdr_free(void);
+extern ssize_t __weak elfcorehdr_read(char *buf, size_t count, u64 *ppos);
+extern ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos);
+
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
 
-- 
1.8.1.6

