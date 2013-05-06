Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3EFNKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 09:10:09 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:48090 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab3EFNKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 09:10:04 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Jan Willeke <willeke@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: [PATCH 1/4] kdump: Introduce ELFCORE_ADDR_NEWMEM
Date: Mon,  6 May 2013 15:09:56 +0200
Message-Id: <1367845799-29125-2-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.6
In-Reply-To: <1367845799-29125-1-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1367845799-29125-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050613-8372-0000-0000-000005EF8EE8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently vmcore gets the ELF header from oldmem using the global variable
"elfcorehdr_addr". This patch introduces a new possible value
ELFCORE_ADDR_NEWMEM. This indicates that the ELF header is allocated
in the new (2nd) kernel. In this case a new architecture function
arch_vmcore_get_elf_hdr() is called to obtain address and length of the
ELF header. The ELF header that is created in the 2nd kernel already
contains the correct relative offsets in the ELF notes and loads sections.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 fs/proc/vmcore.c           | 65 ++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/crash_dump.h |  4 ++-
 2 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 17f7e08..71db4e6 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -487,6 +487,18 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
 }
 
 /* Sets offset fields of vmcore elements. */
+static void __init set_vmcore_list_offsets_newmem(struct list_head *vc_list)
+{
+	loff_t vmcore_off = elfcorebuf_sz;
+	struct vmcore *m;
+
+	list_for_each_entry(m, vc_list, list) {
+		m->offset = vmcore_off;
+		vmcore_off += m->size;
+	}
+}
+
+/* Sets offset fields of vmcore elements. */
 static void __init set_vmcore_list_offsets_elf64(char *elfptr,
 						struct list_head *vc_list)
 {
@@ -636,7 +648,7 @@ static int __init parse_crash_elf32_headers(void)
 	return 0;
 }
 
-static int __init parse_crash_elf_headers(void)
+static int __init parse_crash_elf_headers_oldmem(void)
 {
 	unsigned char e_ident[EI_NIDENT];
 	u64 addr;
@@ -672,6 +684,52 @@ static int __init parse_crash_elf_headers(void)
 	return 0;
 }
 
+/*
+ * provide an empty default implementation here -- architecture
+ * code may override this
+ */
+int __weak arch_vmcore_get_elf_hdr(char **elfcorebuf, size_t *elfcorebuf_sz)
+{
+	return -EOPNOTSUPP;
+}
+
+static int parse_crash_elf_headers_newmem(void)
+{
+	unsigned char e_ident[EI_NIDENT];
+	int rc;
+
+	rc = arch_vmcore_get_elf_hdr(&elfcorebuf, &elfcorebuf_sz);
+	if (rc)
+		return rc;
+	memcpy(e_ident, elfcorebuf, EI_NIDENT);
+	if (memcmp(e_ident, ELFMAG, SELFMAG) != 0) {
+		pr_warn("Warning: Core image elf header not found\n");
+		rc = -EINVAL;
+		goto fail;
+	}
+	if (e_ident[EI_CLASS] == ELFCLASS64) {
+		rc = process_ptload_program_headers_elf64(elfcorebuf,
+							  elfcorebuf_sz,
+							  &vmcore_list);
+		if (rc)
+			goto fail;
+		set_vmcore_list_offsets_newmem(&vmcore_list);
+		vmcore_size = get_vmcore_size_elf64(elfcorebuf);
+	} else if (e_ident[EI_CLASS] == ELFCLASS32) {
+		rc = process_ptload_program_headers_elf32(elfcorebuf,
+							  elfcorebuf_sz,
+							  &vmcore_list);
+		if (rc)
+			goto fail;
+		set_vmcore_list_offsets_newmem(&vmcore_list);
+		vmcore_size = get_vmcore_size_elf32(elfcorebuf);
+	}
+	return 0;
+fail:
+	kfree(elfcorebuf);
+	return rc;
+}
+
 /* Init function for vmcore module. */
 static int __init vmcore_init(void)
 {
@@ -680,7 +738,10 @@ static int __init vmcore_init(void)
 	/* If elfcorehdr= has been passed in cmdline, then capture the dump.*/
 	if (!(is_vmcore_usable()))
 		return rc;
-	rc = parse_crash_elf_headers();
+	if (elfcorehdr_addr == ELFCORE_ADDR_NEWMEM)
+		rc = parse_crash_elf_headers_newmem();
+	else
+		rc = parse_crash_elf_headers_oldmem();
 	if (rc) {
 		pr_warn("Kdump: vmcore not initialized\n");
 		return rc;
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 37e4f8d..9424d4fc 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -8,10 +8,12 @@
 
 #define ELFCORE_ADDR_MAX	(-1ULL)
 #define ELFCORE_ADDR_ERR	(-2ULL)
+#define ELFCORE_ADDR_NEWMEM	(-3ULL)
 
 extern unsigned long long elfcorehdr_addr;
 extern unsigned long long elfcorehdr_size;
-
+extern int arch_vmcore_get_elf_hdr(char **elfcorebuf,
+				   size_t *elfcorebuf_sz);
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
 
-- 
1.8.1.6

