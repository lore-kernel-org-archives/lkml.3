Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab3JIAPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 20:15:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60571 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab3JIAPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 20:15:08 -0400
Date: Wed, 09 Oct 2013 01:15:07 +0100
To: torvalds@linux-foundation.org
Subject: [RFC][PATCH 06/13] convert the rest of binfmt_elf_fdpic to
 dump_emit()
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VThQh-0002xS-N5@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/binfmt_elf_fdpic.c |  109 ++++++++++++++-----------------------------------
 1 files changed, 31 insertions(+), 78 deletions(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 77bf7e3..1806e25 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1267,35 +1267,23 @@ static int notesize(struct memelfnote *en)
 
 /* #define DEBUG */
 
-#define DUMP_WRITE(addr, nr, foffset)	\
-	do { if (!dump_write(file, (addr), (nr))) return 0; *foffset += (nr); } while(0)
-
-static int alignfile(struct file *file, loff_t *foffset)
+static int alignfile(struct coredump_params *cprm)
 {
 	static const char buf[4] = { 0, };
-	DUMP_WRITE(buf, roundup(*foffset, 4) - *foffset, foffset);
-	return 1;
+	return dump_emit(cprm, buf, roundup(cprm->written, 4) - cprm->written);
 }
 
-static int writenote(struct memelfnote *men, struct file *file,
-			loff_t *foffset)
+static int writenote(struct memelfnote *men, struct coredump_params *cprm)
 {
 	struct elf_note en;
 	en.n_namesz = strlen(men->name) + 1;
 	en.n_descsz = men->datasz;
 	en.n_type = men->type;
 
-	DUMP_WRITE(&en, sizeof(en), foffset);
-	DUMP_WRITE(men->name, en.n_namesz, foffset);
-	if (!alignfile(file, foffset))
-		return 0;
-	DUMP_WRITE(men->data, men->datasz, foffset);
-	if (!alignfile(file, foffset))
-		return 0;
-
-	return 1;
+	return dump_emit(cprm, &en, sizeof(en)) &&
+		dump_emit(cprm, men->name, en.n_namesz) && alignfile(cprm) &&
+		dump_emit(cprm, men->data, men->datasz) && alignfile(cprm);
 }
-#undef DUMP_WRITE
 
 static inline void fill_elf_fdpic_header(struct elfhdr *elf, int segs)
 {
@@ -1500,12 +1488,10 @@ static void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
 /*
  * dump the segments for an MMU process
  */
-#ifdef CONFIG_MMU
-static int elf_fdpic_dump_segments(struct file *file, size_t *size,
-			   unsigned long *limit, unsigned long mm_flags)
+static bool elf_fdpic_dump_segments(struct coredump_params *cprm,
+			   unsigned long mm_flags)
 {
 	struct vm_area_struct *vma;
-	int err = 0;
 
 	for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
 		unsigned long addr;
@@ -1513,53 +1499,30 @@ static int elf_fdpic_dump_segments(struct file *file, size_t *size,
 		if (!maydump(vma, mm_flags))
 			continue;
 
+#ifdef CONFIG_MMU
 		for (addr = vma->vm_start; addr < vma->vm_end;
 							addr += PAGE_SIZE) {
+			bool res;
 			struct page *page = get_dump_page(addr);
 			if (page) {
 				void *kaddr = kmap(page);
-				*size += PAGE_SIZE;
-				if (*size > *limit)
-					err = -EFBIG;
-				else if (!dump_write(file, kaddr, PAGE_SIZE))
-					err = -EIO;
+				res = dump_emit(cprm, kaddr, PAGE_SIZE);
 				kunmap(page);
 				page_cache_release(page);
-			} else if (!dump_seek(file, PAGE_SIZE))
-				err = -EFBIG;
-			if (err)
-				goto out;
+			} else {
+				res = dump_seek(file, PAGE_SIZE);
+			}
+			if (!res)
+				return false;
 		}
-	}
-out:
-	return err;
-}
-#endif
-
-/*
- * dump the segments for a NOMMU process
- */
-#ifndef CONFIG_MMU
-static int elf_fdpic_dump_segments(struct file *file, size_t *size,
-			   unsigned long *limit, unsigned long mm_flags)
-{
-	struct vm_area_struct *vma;
-
-	for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
-		if (!maydump(vma, mm_flags))
-			continue;
-
-		if ((*size += PAGE_SIZE) > *limit)
-			return -EFBIG;
-
-		if (!dump_write(file, (void *) vma->vm_start,
+#else
+		if (!dump_emit(cprm, (void *) vma->vm_start,
 				vma->vm_end - vma->vm_start))
-			return -EIO;
+			return false;
+#endif
 	}
-
-	return 0;
+	return true;
 }
-#endif
 
 static size_t elf_core_vma_data_size(unsigned long mm_flags)
 {
@@ -1755,13 +1718,10 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 
 	offset = dataoff;
 
-	size += sizeof(*elf);
-	if (size > cprm->limit || !dump_write(cprm->file, elf, sizeof(*elf)))
+	if (!dump_emit(cprm, elf, sizeof(*elf)))
 		goto end_coredump;
 
-	size += sizeof(*phdr4note);
-	if (size > cprm->limit
-	    || !dump_write(cprm->file, phdr4note, sizeof(*phdr4note)))
+	if (!dump_emit(cprm, phdr4note, sizeof(*phdr4note)))
 		goto end_coredump;
 
 	/* write program headers for segments dump */
@@ -1785,20 +1745,18 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 			phdr.p_flags |= PF_X;
 		phdr.p_align = ELF_EXEC_PAGESIZE;
 
-		size += sizeof(phdr);
-		if (size > cprm->limit
-		    || !dump_write(cprm->file, &phdr, sizeof(phdr)))
+		if (!dump_emit(cprm, &phdr, sizeof(phdr)))
 			goto end_coredump;
 	}
 
-	cprm->written = size;
 	if (!elf_core_write_extra_phdrs(cprm, offset))
 		goto end_coredump;
 
 	size = cprm->written;
+	cprm->written = foffset;
  	/* write out the notes section */
 	for (i = 0; i < numnote; i++)
-		if (!writenote(notes + i, cprm->file, &foffset))
+		if (!writenote(notes + i, cprm))
 			goto end_coredump;
 
 	/* write out the thread status notes section */
@@ -1807,27 +1765,22 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 				list_entry(t, struct elf_thread_status, list);
 
 		for (i = 0; i < tmp->num_notes; i++)
-			if (!writenote(&tmp->notes[i], cprm->file, &foffset))
+			if (!writenote(&tmp->notes[i], cprm))
 				goto end_coredump;
 	}
 
-	if (!dump_seek(cprm->file, dataoff - foffset))
+	if (!dump_seek(cprm->file, dataoff - cprm->written))
 		goto end_coredump;
 
-	if (elf_fdpic_dump_segments(cprm->file, &size, &cprm->limit,
-				    cprm->mm_flags) < 0)
+	cprm->written = size;
+	if (!elf_fdpic_dump_segments(cprm))
 		goto end_coredump;
 
-	cprm->written = size;
 	if (!elf_core_write_extra_data(cprm))
 		goto end_coredump;
-	size = cprm->written;
 
 	if (e_phnum == PN_XNUM) {
-		size += sizeof(*shdr4extnum);
-		if (size > cprm->limit
-		    || !dump_write(cprm->file, shdr4extnum,
-				   sizeof(*shdr4extnum)))
+		if (!dump_emit(cprm, shdr4extnum, sizeof(*shdr4extnum)))
 			goto end_coredump;
 	}
 
-- 
1.7.2.5


