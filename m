Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaLAGJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 01:09:08 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44422 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaLAGJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 01:09:07 -0500
From: Jungseung Lee <js07.lee@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Jungseung Lee <js07.lee@gmail.com>
Subject: [RFC PATCHv2] fs/binfmt_elf.c: fix internal inconsistency relating to vma dump size
Date: Mon,  1 Dec 2014 15:08:58 +0900
Message-Id: <1417414138-5927-1-git-send-email-js07.lee@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vma_dump_size() has been used several times on actual dumper and it is
supposed to return the same value for the same vma. But vma_dump_size()
could return different values for same vma.

The known problem case is concurrent shared memory removal. If a vma is
used for a shared memory and that shared memory is removed between writing
program header and dumping vma memory, this will result in a dump file which
is internally consistent.

To fix the problem, we set baseline to get dump size and store the size
into vma_filesz and always use the same vma dump size which is stored
in vma_filsz. The consistnecy with reality is not actually guranteed, but
it's tolerable since that is fully consistent with base line.

Signed-off-by: Jungseung Lee <js07.lee@gmail.com>
---
 fs/binfmt_elf.c | 40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index d8fc060..3a6175f 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1994,18 +1994,6 @@ static void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
 	shdr4extnum->sh_info = segs;
 }
 
-static size_t elf_core_vma_data_size(struct vm_area_struct *gate_vma,
-				     unsigned long mm_flags)
-{
-	struct vm_area_struct *vma;
-	size_t size = 0;
-
-	for (vma = first_vma(current, gate_vma); vma != NULL;
-	     vma = next_vma(vma, gate_vma))
-		size += vma_dump_size(vma, mm_flags);
-	return size;
-}
-
 /*
  * Actual dumper
  *
@@ -2017,7 +2005,8 @@ static int elf_core_dump(struct coredump_params *cprm)
 {
 	int has_dumped = 0;
 	mm_segment_t fs;
-	int segs;
+	int segs, i;
+	size_t vma_data_size = 0;
 	struct vm_area_struct *vma, *gate_vma;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff;
@@ -2026,6 +2015,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 	struct elf_shdr *shdr4extnum = NULL;
 	Elf_Half e_phnum;
 	elf_addr_t e_shoff;
+	elf_addr_t *vma_filesz = NULL;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -2093,7 +2083,20 @@ static int elf_core_dump(struct coredump_params *cprm)
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
-	offset += elf_core_vma_data_size(gate_vma, cprm->mm_flags);
+	vma_filesz = kmalloc_array(segs - 1, sizeof(*vma_filesz), GFP_KERNEL);
+	if (!vma_filesz)
+		goto end_coredump;
+
+	for (i = 0, vma = first_vma(current, gate_vma); vma != NULL;
+			vma = next_vma(vma, gate_vma)) {
+		unsigned long dump_size;
+
+		dump_size = vma_dump_size(vma, cprm->mm_flags);
+		vma_filesz[i++] = dump_size;
+		vma_data_size += dump_size;
+	}
+
+	offset += vma_data_size;
 	offset += elf_core_extra_data_size();
 	e_shoff = offset;
 
@@ -2113,7 +2116,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 		goto end_coredump;
 
 	/* Write program headers for segments dump */
-	for (vma = first_vma(current, gate_vma); vma != NULL;
+	for (i = 0, vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
 		struct elf_phdr phdr;
 
@@ -2121,7 +2124,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = vma_dump_size(vma, cprm->mm_flags);
+		phdr.p_filesz = vma_filesz[i++];
 		phdr.p_memsz = vma->vm_end - vma->vm_start;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
@@ -2149,12 +2152,12 @@ static int elf_core_dump(struct coredump_params *cprm)
 	if (!dump_skip(cprm, dataoff - cprm->written))
 		goto end_coredump;
 
-	for (vma = first_vma(current, gate_vma); vma != NULL;
+	for (i = 0, vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
 		unsigned long addr;
 		unsigned long end;
 
-		end = vma->vm_start + vma_dump_size(vma, cprm->mm_flags);
+		end = vma->vm_start + vma_filesz[i++];
 
 		for (addr = vma->vm_start; addr < end; addr += PAGE_SIZE) {
 			struct page *page;
@@ -2187,6 +2190,7 @@ end_coredump:
 cleanup:
 	free_note_info(&info);
 	kfree(shdr4extnum);
+	kfree(vma_filesz);
 	kfree(phdr4note);
 	kfree(elf);
 out:
-- 
1.9.1

