Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967397Ab3DRJew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:34:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36909 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967371Ab3DRJeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:34:46 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v4 1/8] vmcore: allocate buffer for ELF headers on page-size
 alignment
To: vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org
Cc: cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com
Date: Sat, 13 Apr 2013 09:21:11 +0900
Message-ID: <20130413002110.18245.50046.stgit@localhost6.localdomain6>
In-Reply-To: <20130413002000.18245.21513.stgit@localhost6.localdomain6>
References: <20130413002000.18245.21513.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate ELF headers on page-size boundary using __get_free_pages()
instead of kmalloc().

Later patch will merge PT_NOTE entries into a single unique one and
decrease the buffer size actually used. Keep original buffer size in
variable elfcorebuf_sz_orig to kfree the buffer later and actually
used buffer size with rounded up to page-size boundary in variable
elfcorebuf_sz seperately.

The size of part of the ELF buffer exported from /proc/vmcore is
elfcorebuf_sz.

The merged, removed PT_NOTE entries, i.e. the range [elfcorebuf_sz,
elfcorebuf_sz_orig], is filled with 0.

Use size of the ELF headers as an inital offset value in
set_vmcore_list_offsets_elf{64,32} and
process_ptload_program_headers_elf{64,32} in order to indicate that
the offset includes the holes towards the page boudary.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |   80 ++++++++++++++++++++++++++++++------------------------
 1 files changed, 45 insertions(+), 35 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index b870f74..cfbd1f7 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -31,6 +31,7 @@ static LIST_HEAD(vmcore_list);
 /* Stores the pointer to the buffer containing kernel elf core headers. */
 static char *elfcorebuf;
 static size_t elfcorebuf_sz;
+static size_t elfcorebuf_sz_orig;
 
 /* Total size of vmcore file. */
 static u64 vmcore_size;
@@ -213,7 +214,7 @@ static struct vmcore* __init get_new_element(void)
 	return kzalloc(sizeof(struct vmcore), GFP_KERNEL);
 }
 
-static u64 __init get_vmcore_size_elf64(char *elfptr)
+static u64 __init get_vmcore_size_elf64(char *elfptr, size_t elfsz)
 {
 	int i;
 	u64 size;
@@ -222,7 +223,7 @@ static u64 __init get_vmcore_size_elf64(char *elfptr)
 
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr));
-	size = sizeof(Elf64_Ehdr) + ((ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr));
+	size = elfsz;
 	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
 		size += phdr_ptr->p_memsz;
 		phdr_ptr++;
@@ -230,7 +231,7 @@ static u64 __init get_vmcore_size_elf64(char *elfptr)
 	return size;
 }
 
-static u64 __init get_vmcore_size_elf32(char *elfptr)
+static u64 __init get_vmcore_size_elf32(char *elfptr, size_t elfsz)
 {
 	int i;
 	u64 size;
@@ -239,7 +240,7 @@ static u64 __init get_vmcore_size_elf32(char *elfptr)
 
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr));
-	size = sizeof(Elf32_Ehdr) + ((ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr));
+	size = elfsz;
 	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
 		size += phdr_ptr->p_memsz;
 		phdr_ptr++;
@@ -307,7 +308,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 	phdr.p_flags   = 0;
 	note_off = sizeof(Elf64_Ehdr) +
 			(ehdr_ptr->e_phnum - nr_ptnote +1) * sizeof(Elf64_Phdr);
-	phdr.p_offset  = note_off;
+	phdr.p_offset  = roundup(note_off, PAGE_SIZE);
 	phdr.p_vaddr   = phdr.p_paddr = 0;
 	phdr.p_filesz  = phdr.p_memsz = phdr_sz;
 	phdr.p_align   = 0;
@@ -321,6 +322,8 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 	i = (nr_ptnote - 1) * sizeof(Elf64_Phdr);
 	*elfsz = *elfsz - i;
 	memmove(tmp, tmp+i, ((*elfsz)-sizeof(Elf64_Ehdr)-sizeof(Elf64_Phdr)));
+	memset(elfptr + *elfsz, 0, i);
+	*elfsz = roundup(*elfsz, PAGE_SIZE);
 
 	/* Modify e_phnum to reflect merged headers. */
 	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
@@ -388,7 +391,7 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 	phdr.p_flags   = 0;
 	note_off = sizeof(Elf32_Ehdr) +
 			(ehdr_ptr->e_phnum - nr_ptnote +1) * sizeof(Elf32_Phdr);
-	phdr.p_offset  = note_off;
+	phdr.p_offset  = roundup(note_off, PAGE_SIZE);
 	phdr.p_vaddr   = phdr.p_paddr = 0;
 	phdr.p_filesz  = phdr.p_memsz = phdr_sz;
 	phdr.p_align   = 0;
@@ -402,6 +405,8 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 	i = (nr_ptnote - 1) * sizeof(Elf32_Phdr);
 	*elfsz = *elfsz - i;
 	memmove(tmp, tmp+i, ((*elfsz)-sizeof(Elf32_Ehdr)-sizeof(Elf32_Phdr)));
+	memset(elfptr + *elfsz, 0, i);
+	*elfsz = roundup(*elfsz, PAGE_SIZE);
 
 	/* Modify e_phnum to reflect merged headers. */
 	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
@@ -425,9 +430,7 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
 	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr)); /* PT_NOTE hdr */
 
 	/* First program header is PT_NOTE header. */
-	vmcore_off = sizeof(Elf64_Ehdr) +
-			(ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr) +
-			phdr_ptr->p_memsz; /* Note sections */
+	vmcore_off = elfsz + roundup(phdr_ptr->p_memsz, PAGE_SIZE);
 
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
 		if (phdr_ptr->p_type != PT_LOAD)
@@ -462,9 +465,7 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
 	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr)); /* PT_NOTE hdr */
 
 	/* First program header is PT_NOTE header. */
-	vmcore_off = sizeof(Elf32_Ehdr) +
-			(ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr) +
-			phdr_ptr->p_memsz; /* Note sections */
+	vmcore_off = elfsz + roundup(phdr_ptr->p_memsz, PAGE_SIZE);
 
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
 		if (phdr_ptr->p_type != PT_LOAD)
@@ -486,7 +487,7 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
 }
 
 /* Sets offset fields of vmcore elements. */
-static void __init set_vmcore_list_offsets_elf64(char *elfptr,
+static void __init set_vmcore_list_offsets_elf64(char *elfptr, size_t elfsz,
 						struct list_head *vc_list)
 {
 	loff_t vmcore_off;
@@ -496,8 +497,7 @@ static void __init set_vmcore_list_offsets_elf64(char *elfptr,
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 
 	/* Skip Elf header and program headers. */
-	vmcore_off = sizeof(Elf64_Ehdr) +
-			(ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr);
+	vmcore_off = elfsz;
 
 	list_for_each_entry(m, vc_list, list) {
 		m->offset = vmcore_off;
@@ -506,7 +506,7 @@ static void __init set_vmcore_list_offsets_elf64(char *elfptr,
 }
 
 /* Sets offset fields of vmcore elements. */
-static void __init set_vmcore_list_offsets_elf32(char *elfptr,
+static void __init set_vmcore_list_offsets_elf32(char *elfptr, size_t elfsz,
 						struct list_head *vc_list)
 {
 	loff_t vmcore_off;
@@ -516,8 +516,7 @@ static void __init set_vmcore_list_offsets_elf32(char *elfptr,
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 
 	/* Skip Elf header and program headers. */
-	vmcore_off = sizeof(Elf32_Ehdr) +
-			(ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr);
+	vmcore_off = elfsz;
 
 	list_for_each_entry(m, vc_list, list) {
 		m->offset = vmcore_off;
@@ -553,30 +552,35 @@ static int __init parse_crash_elf64_headers(void)
 	}
 
 	/* Read in all elf headers. */
-	elfcorebuf_sz = sizeof(Elf64_Ehdr) + ehdr.e_phnum * sizeof(Elf64_Phdr);
-	elfcorebuf = kmalloc(elfcorebuf_sz, GFP_KERNEL);
+	elfcorebuf_sz_orig = sizeof(Elf64_Ehdr) + ehdr.e_phnum * sizeof(Elf64_Phdr);
+	elfcorebuf_sz = elfcorebuf_sz_orig;
+	elfcorebuf = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
+					       get_order(elfcorebuf_sz_orig));
 	if (!elfcorebuf)
 		return -ENOMEM;
 	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz, &addr, 0);
+	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
 	if (rc < 0) {
-		kfree(elfcorebuf);
+		free_pages((unsigned long)elfcorebuf,
+			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
 
 	/* Merge all PT_NOTE headers into one. */
 	rc = merge_note_headers_elf64(elfcorebuf, &elfcorebuf_sz, &vmcore_list);
 	if (rc) {
-		kfree(elfcorebuf);
+		free_pages((unsigned long)elfcorebuf,
+			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
 	rc = process_ptload_program_headers_elf64(elfcorebuf, elfcorebuf_sz,
 							&vmcore_list);
 	if (rc) {
-		kfree(elfcorebuf);
+		free_pages((unsigned long)elfcorebuf,
+			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
-	set_vmcore_list_offsets_elf64(elfcorebuf, &vmcore_list);
+	set_vmcore_list_offsets_elf64(elfcorebuf, elfcorebuf_sz, &vmcore_list);
 	return 0;
 }
 
@@ -608,30 +612,35 @@ static int __init parse_crash_elf32_headers(void)
 	}
 
 	/* Read in all elf headers. */
-	elfcorebuf_sz = sizeof(Elf32_Ehdr) + ehdr.e_phnum * sizeof(Elf32_Phdr);
-	elfcorebuf = kmalloc(elfcorebuf_sz, GFP_KERNEL);
+	elfcorebuf_sz_orig = sizeof(Elf32_Ehdr) + ehdr.e_phnum * sizeof(Elf32_Phdr);
+	elfcorebuf_sz = elfcorebuf_sz_orig;
+	elfcorebuf = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
+					       get_order(elfcorebuf_sz_orig));
 	if (!elfcorebuf)
 		return -ENOMEM;
 	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz, &addr, 0);
+	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
 	if (rc < 0) {
-		kfree(elfcorebuf);
+		free_pages((unsigned long)elfcorebuf,
+			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
 
 	/* Merge all PT_NOTE headers into one. */
 	rc = merge_note_headers_elf32(elfcorebuf, &elfcorebuf_sz, &vmcore_list);
 	if (rc) {
-		kfree(elfcorebuf);
+		free_pages((unsigned long)elfcorebuf,
+			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
 	rc = process_ptload_program_headers_elf32(elfcorebuf, elfcorebuf_sz,
 								&vmcore_list);
 	if (rc) {
-		kfree(elfcorebuf);
+		free_pages((unsigned long)elfcorebuf,
+			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
-	set_vmcore_list_offsets_elf32(elfcorebuf, &vmcore_list);
+	set_vmcore_list_offsets_elf32(elfcorebuf, elfcorebuf_sz, &vmcore_list);
 	return 0;
 }
 
@@ -656,14 +665,14 @@ static int __init parse_crash_elf_headers(void)
 			return rc;
 
 		/* Determine vmcore size. */
-		vmcore_size = get_vmcore_size_elf64(elfcorebuf);
+		vmcore_size = get_vmcore_size_elf64(elfcorebuf, elfcorebuf_sz);
 	} else if (e_ident[EI_CLASS] == ELFCLASS32) {
 		rc = parse_crash_elf32_headers();
 		if (rc)
 			return rc;
 
 		/* Determine vmcore size. */
-		vmcore_size = get_vmcore_size_elf32(elfcorebuf);
+		vmcore_size = get_vmcore_size_elf32(elfcorebuf, elfcorebuf_sz);
 	} else {
 		pr_warn("Warning: Core image elf header is not sane\n");
 		return -EINVAL;
@@ -710,7 +719,8 @@ void vmcore_cleanup(void)
 		list_del(&m->list);
 		kfree(m);
 	}
-	kfree(elfcorebuf);
+	free_pages((unsigned long)elfcorebuf,
+		   get_order(elfcorebuf_sz_orig));
 	elfcorebuf = NULL;
 }
 EXPORT_SYMBOL_GPL(vmcore_cleanup);

