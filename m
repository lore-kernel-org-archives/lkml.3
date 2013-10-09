Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab3JIAPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 20:15:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60572 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948Ab3JIAPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 20:15:18 -0400
Date: Wed, 09 Oct 2013 01:15:17 +0100
To: torvalds@linux-foundation.org
Subject: [RFC][PATCH 07/13] switch elf_coredump_extra_notes_write() to
 dump_emit()
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VThQr-0002xf-Ni@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/include/asm/spu.h               |    3 +-
 arch/powerpc/platforms/cell/spu_syscalls.c   |    5 ++-
 arch/powerpc/platforms/cell/spufs/coredump.c |   44 ++++++++++----------------
 arch/powerpc/platforms/cell/spufs/spufs.h    |    3 +-
 fs/binfmt_elf.c                              |    7 ++--
 include/linux/elf.h                          |    6 ++--
 6 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/arch/powerpc/include/asm/spu.h b/arch/powerpc/include/asm/spu.h
index 93f280e..37b7ca3 100644
--- a/arch/powerpc/include/asm/spu.h
+++ b/arch/powerpc/include/asm/spu.h
@@ -235,6 +235,7 @@ extern long spu_sys_callback(struct spu_syscall_block *s);
 
 /* syscalls implemented in spufs */
 struct file;
+struct coredump_params;
 struct spufs_calls {
 	long (*create_thread)(const char __user *name,
 					unsigned int flags, umode_t mode,
@@ -242,7 +243,7 @@ struct spufs_calls {
 	long (*spu_run)(struct file *filp, __u32 __user *unpc,
 						__u32 __user *ustatus);
 	int (*coredump_extra_notes_size)(void);
-	int (*coredump_extra_notes_write)(struct file *file, loff_t *foffset);
+	int (*coredump_extra_notes_write)(struct coredump_params *cprm);
 	void (*notify_spus_active)(void);
 	struct module *owner;
 };
diff --git a/arch/powerpc/platforms/cell/spu_syscalls.c b/arch/powerpc/platforms/cell/spu_syscalls.c
index db4e638..3844f13 100644
--- a/arch/powerpc/platforms/cell/spu_syscalls.c
+++ b/arch/powerpc/platforms/cell/spu_syscalls.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/rcupdate.h>
+#include <linux/binfmts.h>
 
 #include <asm/spu.h>
 
@@ -126,7 +127,7 @@ int elf_coredump_extra_notes_size(void)
 	return ret;
 }
 
-int elf_coredump_extra_notes_write(struct file *file, loff_t *foffset)
+int elf_coredump_extra_notes_write(struct coredump_params *cprm)
 {
 	struct spufs_calls *calls;
 	int ret;
@@ -135,7 +136,7 @@ int elf_coredump_extra_notes_write(struct file *file, loff_t *foffset)
 	if (!calls)
 		return 0;
 
-	ret = calls->coredump_extra_notes_write(file, foffset);
+	ret = calls->coredump_extra_notes_write(cprm);
 
 	spufs_calls_put(calls);
 
diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
index c9500ea..5d9b0a2 100644
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ b/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -27,6 +27,8 @@
 #include <linux/gfp.h>
 #include <linux/list.h>
 #include <linux/syscalls.h>
+#include <linux/coredump.h>
+#include <linux/binfmts.h>
 
 #include <asm/uaccess.h>
 
@@ -52,35 +54,24 @@ static ssize_t do_coredump_read(int num, struct spu_context *ctx, void *buffer,
  * These are the only things you should do on a core-file: use only these
  * functions to write out all the necessary info.
  */
-static int spufs_dump_write(struct file *file, const void *addr, int nr, loff_t *foffset)
+static int spufs_dump_write(struct coredump_params *cprm, const void *addr, int nr)
 {
-	unsigned long limit = rlimit(RLIMIT_CORE);
-	ssize_t written;
-
-	if (*foffset + nr > limit)
+	if (!dump_emit(cprm, addr, nr))
 		return -EIO;
-
-	written = file->f_op->write(file, addr, nr, &file->f_pos);
-	*foffset += written;
-
-	if (written != nr)
-		return -EIO;
-
 	return 0;
 }
 
-static int spufs_dump_align(struct file *file, char *buf, loff_t new_off,
-			    loff_t *foffset)
+static int spufs_dump_align(struct coredump_params *cprm, char *buf, loff_t new_off)
 {
 	int rc, size;
 
-	size = min((loff_t)PAGE_SIZE, new_off - *foffset);
+	size = min((loff_t)PAGE_SIZE, new_off - cprm->written);
 	memset(buf, 0, size);
 
 	rc = 0;
-	while (rc == 0 && new_off > *foffset) {
-		size = min((loff_t)PAGE_SIZE, new_off - *foffset);
-		rc = spufs_dump_write(file, buf, size, foffset);
+	while (rc == 0 && new_off > cprm->written) {
+		size = min((loff_t)PAGE_SIZE, new_off - cprm->written);
+		rc = spufs_dump_write(cprm, buf, size);
 	}
 
 	return rc;
@@ -165,7 +156,7 @@ int spufs_coredump_extra_notes_size(void)
 }
 
 static int spufs_arch_write_note(struct spu_context *ctx, int i,
-				  struct file *file, int dfd, loff_t *foffset)
+				  struct coredump_params *cprm, int dfd)
 {
 	loff_t pos = 0;
 	int sz, rc, nread, total = 0;
@@ -186,22 +177,22 @@ static int spufs_arch_write_note(struct spu_context *ctx, int i,
 	en.n_descsz = sz;
 	en.n_type = NT_SPU;
 
-	rc = spufs_dump_write(file, &en, sizeof(en), foffset);
+	rc = spufs_dump_write(cprm, &en, sizeof(en));
 	if (rc)
 		goto out;
 
-	rc = spufs_dump_write(file, fullname, en.n_namesz, foffset);
+	rc = spufs_dump_write(cprm, fullname, en.n_namesz);
 	if (rc)
 		goto out;
 
-	rc = spufs_dump_align(file, buf, roundup(*foffset, 4), foffset);
+	rc = spufs_dump_align(cprm, buf, roundup(cprm->written, 4));
 	if (rc)
 		goto out;
 
 	do {
 		nread = do_coredump_read(i, ctx, buf, bufsz, &pos);
 		if (nread > 0) {
-			rc = spufs_dump_write(file, buf, nread, foffset);
+			rc = spufs_dump_write(cprm, buf, nread);
 			if (rc)
 				goto out;
 			total += nread;
@@ -213,15 +204,14 @@ static int spufs_arch_write_note(struct spu_context *ctx, int i,
 		goto out;
 	}
 
-	rc = spufs_dump_align(file, buf, roundup(*foffset - total + sz, 4),
-			      foffset);
+	rc = spufs_dump_align(cprm, buf, roundup(cprm->written - total + sz, 4));
 
 out:
 	free_page((unsigned long)buf);
 	return rc;
 }
 
-int spufs_coredump_extra_notes_write(struct file *file, loff_t *foffset)
+int spufs_coredump_extra_notes_write(struct coredump_params *cprm)
 {
 	struct spu_context *ctx;
 	int fd, j, rc;
@@ -233,7 +223,7 @@ int spufs_coredump_extra_notes_write(struct file *file, loff_t *foffset)
 			return rc;
 
 		for (j = 0; spufs_coredump_read[j].name != NULL; j++) {
-			rc = spufs_arch_write_note(ctx, j, file, fd, foffset);
+			rc = spufs_arch_write_note(ctx, j, cprm, fd);
 			if (rc) {
 				spu_release_saved(ctx);
 				return rc;
diff --git a/arch/powerpc/platforms/cell/spufs/spufs.h b/arch/powerpc/platforms/cell/spufs/spufs.h
index 67852ad..0ba3c95 100644
--- a/arch/powerpc/platforms/cell/spufs/spufs.h
+++ b/arch/powerpc/platforms/cell/spufs/spufs.h
@@ -247,12 +247,13 @@ extern const struct spufs_tree_descr spufs_dir_debug_contents[];
 
 /* system call implementation */
 extern struct spufs_calls spufs_calls;
+struct coredump_params;
 long spufs_run_spu(struct spu_context *ctx, u32 *npc, u32 *status);
 long spufs_create(struct path *nd, struct dentry *dentry, unsigned int flags,
 			umode_t mode, struct file *filp);
 /* ELF coredump callbacks for writing SPU ELF notes */
 extern int spufs_coredump_extra_notes_size(void);
-extern int spufs_coredump_extra_notes_write(struct file *file, loff_t *foffset);
+extern int spufs_coredump_extra_notes_write(struct coredump_params *cprm);
 
 extern const struct file_operations spufs_context_fops;
 
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index bc01aaf..bb59220 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -2037,7 +2037,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 	size_t size = 0;
 	struct vm_area_struct *vma, *gate_vma;
 	struct elfhdr *elf = NULL;
-	loff_t offset = 0, dataoff, foffset;
+	loff_t offset = 0, dataoff;
 	struct elf_note_info info = { };
 	struct elf_phdr *phdr4note = NULL;
 	struct elf_shdr *shdr4extnum = NULL;
@@ -2160,12 +2160,11 @@ static int elf_core_dump(struct coredump_params *cprm)
 	if (!write_note_info(&info, cprm))
 		goto end_coredump;
 
-	foffset = cprm->written;
-	if (elf_coredump_extra_notes_write(cprm->file, &foffset))
+	if (elf_coredump_extra_notes_write(cprm))
 		goto end_coredump;
 
 	/* Align to page */
-	if (!dump_seek(cprm->file, dataoff - foffset))
+	if (!dump_seek(cprm->file, dataoff - cprm->written))
 		goto end_coredump;
 
 	cprm->written = size;
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 40a3c0e..67a5fa7 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -39,13 +39,13 @@ extern Elf64_Dyn _DYNAMIC [];
 
 /* Optional callbacks to write extra ELF notes. */
 struct file;
+struct coredump_params;
 
 #ifndef ARCH_HAVE_EXTRA_ELF_NOTES
 static inline int elf_coredump_extra_notes_size(void) { return 0; }
-static inline int elf_coredump_extra_notes_write(struct file *file,
-			loff_t *foffset) { return 0; }
+static inline int elf_coredump_extra_notes_write(struct coredump_params *cprm) { return 0; }
 #else
 extern int elf_coredump_extra_notes_size(void);
-extern int elf_coredump_extra_notes_write(struct file *file, loff_t *foffset);
+extern int elf_coredump_extra_notes_write(struct coredump_params *cprm);
 #endif
 #endif /* _LINUX_ELF_H */
-- 
1.7.2.5


