Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3JIAOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 20:14:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60562 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab3JIAO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 20:14:28 -0400
Date: Wed, 09 Oct 2013 01:14:27 +0100
To: torvalds@linux-foundation.org
Subject: [RFC][PATCH 02/13] new helper: dump_emit()
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VThQ3-0002vV-M2@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


dump_write() analog, takes core_dump_params instead of file,
keeps track of the amount written in cprm->written and checks for
cprm->limit.  Start using it in binfmt_elf.c...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/binfmt_elf.c          |   62 +++++++++++++++++----------------------------
 fs/coredump.c            |   14 ++++++++++
 include/linux/binfmts.h  |    1 +
 include/linux/coredump.h |    2 +
 4 files changed, 41 insertions(+), 38 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 501c8a4..4bdf6b6 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1225,35 +1225,23 @@ static int notesize(struct memelfnote *en)
 	return sz;
 }
 
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
+	    dump_emit(cprm, men->name, en.n_namesz) && alignfile(cprm) &&
+	    dump_emit(cprm, men->data, men->datasz) && alignfile(cprm);
 }
-#undef DUMP_WRITE
 
 static void fill_elf_header(struct elfhdr *elf, int segs,
 			    u16 machine, u32 flags)
@@ -1702,7 +1690,7 @@ static size_t get_note_info_size(struct elf_note_info *info)
  * process-wide notes are interleaved after the first thread-specific note.
  */
 static int write_note_info(struct elf_note_info *info,
-			   struct file *file, loff_t *foffset)
+			   struct coredump_params *cprm)
 {
 	bool first = 1;
 	struct elf_thread_core_info *t = info->thread;
@@ -1710,22 +1698,22 @@ static int write_note_info(struct elf_note_info *info,
 	do {
 		int i;
 
-		if (!writenote(&t->notes[0], file, foffset))
+		if (!writenote(&t->notes[0], cprm))
 			return 0;
 
-		if (first && !writenote(&info->psinfo, file, foffset))
+		if (first && !writenote(&info->psinfo, cprm))
 			return 0;
-		if (first && !writenote(&info->signote, file, foffset))
+		if (first && !writenote(&info->signote, cprm))
 			return 0;
-		if (first && !writenote(&info->auxv, file, foffset))
+		if (first && !writenote(&info->auxv, cprm))
 			return 0;
 		if (first && info->files.data &&
-				!writenote(&info->files, file, foffset))
+				!writenote(&info->files, cprm))
 			return 0;
 
 		for (i = 1; i < info->thread_notes; ++i)
 			if (t->notes[i].data &&
-			    !writenote(&t->notes[i], file, foffset))
+			    !writenote(&t->notes[i], cprm))
 				return 0;
 
 		first = 0;
@@ -1934,14 +1922,14 @@ static size_t get_note_info_size(struct elf_note_info *info)
 	return sz;
 }
 
-static int write_note_info(struct elf_note_info *info,
-			   struct file *file, loff_t *foffset)
+static int write_note_info(struct elf_note_info *info
+			   struct coredump_params *cprm)
 {
 	int i;
 	struct list_head *t;
 
 	for (i = 0; i < info->numnote; i++)
-		if (!writenote(info->notes + i, file, foffset))
+		if (!writenote(info->notes + i, cprm))
 			return 0;
 
 	/* write out the thread status notes section */
@@ -1950,7 +1938,7 @@ static int write_note_info(struct elf_note_info *info,
 				list_entry(t, struct elf_thread_status, list);
 
 		for (i = 0; i < tmp->num_notes; i++)
-			if (!writenote(&tmp->notes[i], file, foffset))
+			if (!writenote(&tmp->notes[i], cprm))
 				return 0;
 	}
 
@@ -2136,13 +2124,10 @@ static int elf_core_dump(struct coredump_params *cprm)
 
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
 
 	/* Write program headers for segments dump */
@@ -2164,19 +2149,20 @@ static int elf_core_dump(struct coredump_params *cprm)
 			phdr.p_flags |= PF_X;
 		phdr.p_align = ELF_EXEC_PAGESIZE;
 
-		size += sizeof(phdr);
-		if (size > cprm->limit
-		    || !dump_write(cprm->file, &phdr, sizeof(phdr)))
+		if (!dump_emit(cprm, &phdr, sizeof(phdr)))
 			goto end_coredump;
 	}
+	size = cprm->written;
 
 	if (!elf_core_write_extra_phdrs(cprm->file, offset, &size, cprm->limit))
 		goto end_coredump;
 
+	cprm->written = foffset;	/* will disappear */
  	/* write out the notes section */
-	if (!write_note_info(&info, cprm->file, &foffset))
+	if (!write_note_info(&info, cprm))
 		goto end_coredump;
 
+	foffset = cprm->written;
 	if (elf_coredump_extra_notes_write(cprm->file, &foffset))
 		goto end_coredump;
 
diff --git a/fs/coredump.c b/fs/coredump.c
index 42c3b84..319f973 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -693,6 +693,20 @@ int dump_write(struct file *file, const void *addr, int nr)
 }
 EXPORT_SYMBOL(dump_write);
 
+int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
+{
+	struct file *file = cprm->file;
+	if (dump_interrupted() || !access_ok(VERIFY_READ, addr, nr))
+		return 0;
+	if (cprm->written + nr > cprm->limit)
+		return 0;
+	if (file->f_op->write(file, addr, nr, &file->f_pos) != nr)
+		return 0;
+	cprm->written += nr;
+	return 1;
+}
+EXPORT_SYMBOL(dump_emit);
+
 int dump_seek(struct file *file, loff_t off)
 {
 	int ret = 1;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index e8112ae..8aa507e 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -61,6 +61,7 @@ struct coredump_params {
 	struct file *file;
 	unsigned long limit;
 	unsigned long mm_flags;
+	loff_t written;
 };
 
 /*
diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index a98f1ca..2959376 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -10,8 +10,10 @@
  * These are the only things you should do on a core-file: use only these
  * functions to write out all the necessary info.
  */
+struct coredump_params;
 extern int dump_write(struct file *file, const void *addr, int nr);
 extern int dump_seek(struct file *file, loff_t off);
+extern int dump_emit(struct coredump_params *cprm, const void *addr, int nr);
 #ifdef CONFIG_COREDUMP
 extern void do_coredump(siginfo_t *siginfo);
 #else
-- 
1.7.2.5


