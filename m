Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab3JIAQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 20:16:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60580 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab3JIAP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 20:15:58 -0400
Date: Wed, 09 Oct 2013 01:15:57 +0100
To: torvalds@linux-foundation.org
Subject: [RFC][PATCH 11/13] dump_skip(): dump_seek() replacement taking
 coredump_params
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VThRV-0002z6-Or@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/ia32/ia32_aout.c |    2 +-
 fs/binfmt_aout.c          |    2 +-
 fs/binfmt_elf.c           |    4 ++--
 fs/binfmt_elf_fdpic.c     |   11 +++--------
 fs/coredump.c             |   43 ++++++++++++++-----------------------------
 include/linux/coredump.h  |    3 +--
 6 files changed, 22 insertions(+), 43 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 9e26e9e..d21ff89 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -187,7 +187,7 @@ static int aout_core_dump(struct coredump_params *cprm)
 	if (!dump_emit(cprm, &dump, sizeof(dump)))
 		goto end_coredump;
 	/* Now dump all of the user data.  Include malloced stuff as well */
-	if (!dump_seek(cprm->file, PAGE_SIZE - sizeof(dump)))
+	if (!dump_skip(cprm, PAGE_SIZE - sizeof(dump)))
 		goto end_coredump;
 	/* now we start writing out the user space info */
 	set_fs(USER_DS);
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index a4f847f..ca0ba15 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -87,7 +87,7 @@ static int aout_core_dump(struct coredump_params *cprm)
 	if (!dump_emit(cprm, &dump, sizeof(dump)))
 		goto end_coredump;
 /* Now dump all of the user data.  Include malloced stuff as well */
-	if (!dump_seek(cprm->file, PAGE_SIZE - sizeof(dump)))
+	if (!dump_skip(cprm, PAGE_SIZE - sizeof(dump)))
 		goto end_coredump;
 /* now we start writing out the user space info */
 	set_fs(USER_DS);
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 42ef312..da33c1d 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -2162,7 +2162,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 		goto end_coredump;
 
 	/* Align to page */
-	if (!dump_seek(cprm->file, dataoff - cprm->written))
+	if (!dump_skip(cprm, dataoff - cprm->written))
 		goto end_coredump;
 
 	for (vma = first_vma(current, gate_vma); vma != NULL;
@@ -2183,7 +2183,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 				kunmap(page);
 				page_cache_release(page);
 			} else
-				stop = !dump_seek(cprm->file, PAGE_SIZE);
+				stop = !dump_skip(cprm, PAGE_SIZE);
 			if (stop)
 				goto end_coredump;
 		}
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 1806e25..723fa02 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1510,7 +1510,7 @@ static bool elf_fdpic_dump_segments(struct coredump_params *cprm,
 				kunmap(page);
 				page_cache_release(page);
 			} else {
-				res = dump_seek(file, PAGE_SIZE);
+				res = dump_skip(cprm, PAGE_SIZE);
 			}
 			if (!res)
 				return false;
@@ -1548,11 +1548,10 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 	int has_dumped = 0;
 	mm_segment_t fs;
 	int segs;
-	size_t size = 0;
 	int i;
 	struct vm_area_struct *vma;
 	struct elfhdr *elf = NULL;
-	loff_t offset = 0, dataoff, foffset;
+	loff_t offset = 0, dataoff;
 	int numnote;
 	struct memelfnote *notes = NULL;
 	struct elf_prstatus *prstatus = NULL;	/* NT_PRSTATUS */
@@ -1683,7 +1682,6 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 
 	offset += sizeof(*elf);				/* Elf header */
 	offset += segs * sizeof(struct elf_phdr);	/* Program headers */
-	foffset = offset;
 
 	/* Write notes phdr entry */
 	{
@@ -1752,8 +1750,6 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 	if (!elf_core_write_extra_phdrs(cprm, offset))
 		goto end_coredump;
 
-	size = cprm->written;
-	cprm->written = foffset;
  	/* write out the notes section */
 	for (i = 0; i < numnote; i++)
 		if (!writenote(notes + i, cprm))
@@ -1769,10 +1765,9 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 				goto end_coredump;
 	}
 
-	if (!dump_seek(cprm->file, dataoff - cprm->written))
+	if (!dump_skip(cprm->file, dataoff - cprm->written))
 		goto end_coredump;
 
-	cprm->written = size;
 	if (!elf_fdpic_dump_segments(cprm))
 		goto end_coredump;
 
diff --git a/fs/coredump.c b/fs/coredump.c
index 478ebad..489372e 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -685,14 +685,6 @@ fail:
  * do on a core-file: use only these functions to write out all the
  * necessary info.
  */
-int dump_write(struct file *file, const void *addr, int nr)
-{
-	return !dump_interrupted() &&
-		access_ok(VERIFY_READ, addr, nr) &&
-		file->f_op->write(file, addr, nr, &file->f_pos) == nr;
-}
-EXPORT_SYMBOL(dump_write);
-
 int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
 {
 	struct file *file = cprm->file;
@@ -714,32 +706,25 @@ int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
 }
 EXPORT_SYMBOL(dump_emit);
 
-int dump_seek(struct file *file, loff_t off)
+int dump_skip(struct coredump_params *cprm, size_t nr)
 {
-	int ret = 1;
-
+	static char zeroes[PAGE_SIZE];
+	struct file *file = cprm->file;
 	if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
+		if (cprm->written + nr > cprm->limit)
+			return 0;
 		if (dump_interrupted() ||
-		    file->f_op->llseek(file, off, SEEK_CUR) < 0)
+		    file->f_op->llseek(file, nr, SEEK_CUR) < 0)
 			return 0;
+		cprm->written += nr;
+		return 1;
 	} else {
-		char *buf = (char *)get_zeroed_page(GFP_KERNEL);
-
-		if (!buf)
-			return 0;
-		while (off > 0) {
-			unsigned long n = off;
-
-			if (n > PAGE_SIZE)
-				n = PAGE_SIZE;
-			if (!dump_write(file, buf, n)) {
-				ret = 0;
-				break;
-			}
-			off -= n;
+		while (nr > PAGE_SIZE) {
+			if (!dump_emit(cprm, zeroes, PAGE_SIZE))
+				return 0;
+			nr -= PAGE_SIZE;
 		}
-		free_page((unsigned long)buf);
+		return dump_emit(cprm, zeroes, nr);
 	}
-	return ret;
 }
-EXPORT_SYMBOL(dump_seek);
+EXPORT_SYMBOL(dump_skip);
diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index 2959376..07a0af9 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -11,8 +11,7 @@
  * functions to write out all the necessary info.
  */
 struct coredump_params;
-extern int dump_write(struct file *file, const void *addr, int nr);
-extern int dump_seek(struct file *file, loff_t off);
+extern int dump_skip(struct coredump_params *cprm, size_t nr);
 extern int dump_emit(struct coredump_params *cprm, const void *addr, int nr);
 #ifdef CONFIG_COREDUMP
 extern void do_coredump(siginfo_t *siginfo);
-- 
1.7.2.5


