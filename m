Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab3GATdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:33:18 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:60748 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3GATcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:32:46 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH v6 1/5] vmcore: Introduce ELF header in new memory feature
Date: Mon,  1 Jul 2013 21:32:35 +0200
Message-Id: <1372707159-10425-2-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070119-3548-0000-0000-000005D1F23C
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

 * elfcorehdr_alloc: Allocate ELF header
 * elfcorehdr_free: Free the memory of the ELF header
 * elfcorehdr_read: Read from ELF header
 * elfcorehdr_read_notes: Read from ELF notes

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 fs/proc/vmcore.c           | 61 ++++++++++++++++++++++++++++++++++++++--------
 include/linux/crash_dump.h |  6 +++++
 2 files changed, 57 insertions(+), 10 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 0f6db52..c28189c 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -123,6 +123,36 @@ static ssize_t read_from_oldmem(char *buf, size_t count,
 	return read;
 }
 
+/*
+ * Architectures may override this function to allocate ELF header in 2nd kernel
+ */
+int __weak elfcorehdr_alloc(unsigned long long *addr, unsigned long long *size)
+{
+	return 0;
+}
+
+/*
+ * Architectures may override this function to free header
+ */
+void __weak elfcorehdr_free(unsigned long long addr)
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
@@ -935,7 +967,14 @@ static int __init vmcore_init(void)
 {
 	int rc = 0;
 
-	/* If elfcorehdr= has been passed in cmdline, then capture the dump.*/
+	/* Allow architectures to allocate ELF header in 2nd kernel */
+	rc = elfcorehdr_alloc(&elfcorehdr_addr, &elfcorehdr_size);
+	if (rc)
+		return rc;
+	/*
+	 * If elfcorehdr= has been passed in cmdline or created in 2nd kernel,
+	 * then capture the dump.
+	 */
 	if (!(is_vmcore_usable()))
 		return rc;
 	rc = parse_crash_elf_headers();
@@ -943,6 +982,8 @@ static int __init vmcore_init(void)
 		pr_warn("Kdump: vmcore not initialized\n");
 		return rc;
 	}
+	elfcorehdr_free(elfcorehdr_addr);
+	elfcorehdr_addr = ELFCORE_ADDR_ERR;
 
 	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
 	if (proc_vmcore)
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 37e4f8d..6571f82 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -12,6 +12,12 @@
 extern unsigned long long elfcorehdr_addr;
 extern unsigned long long elfcorehdr_size;
 
+extern int __weak elfcorehdr_alloc(unsigned long long *addr,
+				   unsigned long long *size);
+extern void __weak elfcorehdr_free(unsigned long long addr);
+extern ssize_t __weak elfcorehdr_read(char *buf, size_t count, u64 *ppos);
+extern ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos);
+
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
 
-- 
1.8.2.2

