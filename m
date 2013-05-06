Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab3EFNKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 09:10:08 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:56268 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3EFNKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 09:10:04 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Jan Willeke <willeke@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: [PATCH 4/4] kdump: Merge set_vmcore_list_offsets_elf64/elf32/newmem
Date: Mon,  6 May 2013 15:09:59 +0200
Message-Id: <1367845799-29125-5-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.6
In-Reply-To: <1367845799-29125-1-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1367845799-29125-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050613-4966-0000-0000-000005A879B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The three functions set_vmcore_list_offsets_elf64(),
set_vmcore_list_offsets_elf32(), and set_vmcore_list_offsets_newmem()
can be merged to a single fuction set_vmcore_list_offsets()

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 fs/proc/vmcore.c | 50 +++++---------------------------------------------
 1 file changed, 5 insertions(+), 45 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 71db4e6..3ddfc73 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -487,7 +487,7 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
 }
 
 /* Sets offset fields of vmcore elements. */
-static void __init set_vmcore_list_offsets_newmem(struct list_head *vc_list)
+static void __init set_vmcore_list_offsets(struct list_head *vc_list)
 {
 	loff_t vmcore_off = elfcorebuf_sz;
 	struct vmcore *m;
@@ -498,46 +498,6 @@ static void __init set_vmcore_list_offsets_newmem(struct list_head *vc_list)
 	}
 }
 
-/* Sets offset fields of vmcore elements. */
-static void __init set_vmcore_list_offsets_elf64(char *elfptr,
-						struct list_head *vc_list)
-{
-	loff_t vmcore_off;
-	Elf64_Ehdr *ehdr_ptr;
-	struct vmcore *m;
-
-	ehdr_ptr = (Elf64_Ehdr *)elfptr;
-
-	/* Skip Elf header and program headers. */
-	vmcore_off = sizeof(Elf64_Ehdr) +
-			(ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr);
-
-	list_for_each_entry(m, vc_list, list) {
-		m->offset = vmcore_off;
-		vmcore_off += m->size;
-	}
-}
-
-/* Sets offset fields of vmcore elements. */
-static void __init set_vmcore_list_offsets_elf32(char *elfptr,
-						struct list_head *vc_list)
-{
-	loff_t vmcore_off;
-	Elf32_Ehdr *ehdr_ptr;
-	struct vmcore *m;
-
-	ehdr_ptr = (Elf32_Ehdr *)elfptr;
-
-	/* Skip Elf header and program headers. */
-	vmcore_off = sizeof(Elf32_Ehdr) +
-			(ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr);
-
-	list_for_each_entry(m, vc_list, list) {
-		m->offset = vmcore_off;
-		vmcore_off += m->size;
-	}
-}
-
 static int __init parse_crash_elf64_headers(void)
 {
 	int rc=0;
@@ -589,7 +549,7 @@ static int __init parse_crash_elf64_headers(void)
 		kfree(elfcorebuf);
 		return rc;
 	}
-	set_vmcore_list_offsets_elf64(elfcorebuf, &vmcore_list);
+	set_vmcore_list_offsets(&vmcore_list);
 	return 0;
 }
 
@@ -644,7 +604,7 @@ static int __init parse_crash_elf32_headers(void)
 		kfree(elfcorebuf);
 		return rc;
 	}
-	set_vmcore_list_offsets_elf32(elfcorebuf, &vmcore_list);
+	set_vmcore_list_offsets(&vmcore_list);
 	return 0;
 }
 
@@ -713,7 +673,7 @@ static int parse_crash_elf_headers_newmem(void)
 							  &vmcore_list);
 		if (rc)
 			goto fail;
-		set_vmcore_list_offsets_newmem(&vmcore_list);
+		set_vmcore_list_offsets(&vmcore_list);
 		vmcore_size = get_vmcore_size_elf64(elfcorebuf);
 	} else if (e_ident[EI_CLASS] == ELFCLASS32) {
 		rc = process_ptload_program_headers_elf32(elfcorebuf,
@@ -721,7 +681,7 @@ static int parse_crash_elf_headers_newmem(void)
 							  &vmcore_list);
 		if (rc)
 			goto fail;
-		set_vmcore_list_offsets_newmem(&vmcore_list);
+		set_vmcore_list_offsets(&vmcore_list);
 		vmcore_size = get_vmcore_size_elf32(elfcorebuf);
 	}
 	return 0;
-- 
1.8.1.6

