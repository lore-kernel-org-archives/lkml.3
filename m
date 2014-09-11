Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaIKIho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:37:44 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:49114 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbaIKIhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:37:34 -0400
From: Paul Burton <paul.burton@imgtec.com>
To: <linux-mips@linux-mips.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Paul Burton <paul.burton@imgtec.com>
Subject: [PATCH 01/10] binfmt_elf: hoist ELF program header loading to a function
Date: Thu, 11 Sep 2014 08:30:14 +0100
Message-ID: <1410420623-11691-2-git-send-email-paul.burton@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
References: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.159.78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

load_elf_binary & load_elf_interp both load program headers from an ELF
executable in the same way, duplicating the code. This patch introduces
a helper function (load_elf_phdrs) which performs this common task &
calls it from both load_elf_binary & load_elf_interp. In addition to
reducing code duplication, this is part of preparing to load the ELF
interpreter headers earlier such that they can be examined before it's
too late to return an error from an exec syscall.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
---
 fs/binfmt_elf.c | 99 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 56 insertions(+), 43 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 3892c1a..64ca110 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -386,6 +386,59 @@ static unsigned long total_mapping_size(struct elf_phdr *cmds, int nr)
 				ELF_PAGESTART(cmds[first_idx].p_vaddr);
 }
 
+/**
+ * load_elf_phdrs() - load ELF program headers
+ * @elf_ex:   ELF header of the binary whose program headers should be loaded
+ * @elf_file: the opened ELF binary file
+ *
+ * Loads ELF program headers from the binary file elf_file, which has the ELF
+ * header pointed to by elf_ex, into a newly allocated array. The caller is
+ * responsible for freeing the allocated data. Returns an ERR_PTR upon failure.
+ */
+static struct elf_phdr *load_elf_phdrs(struct elfhdr *elf_ex,
+				       struct file *elf_file)
+{
+	struct elf_phdr *elf_phdata = NULL;
+	int retval, size, err = -1;
+
+	/*
+	 * If the size of this structure has changed, then punt, since
+	 * we will be doing the wrong thing.
+	 */
+	if (elf_ex->e_phentsize != sizeof(struct elf_phdr))
+		goto out;
+
+	/* Sanity check the number of program headers... */
+	if (elf_ex->e_phnum < 1 ||
+		elf_ex->e_phnum > 65536U / sizeof(struct elf_phdr))
+		goto out;
+
+	/* ...and their total size. */
+	size = sizeof(struct elf_phdr) * elf_ex->e_phnum;
+	if (size > ELF_MIN_ALIGN)
+		goto out;
+
+	elf_phdata = kmalloc(size, GFP_KERNEL);
+	if (!elf_phdata)
+		goto out;
+
+	/* Read in the program headers */
+	retval = kernel_read(elf_file, elf_ex->e_phoff,
+			     (char *)elf_phdata, size);
+	if (retval != size) {
+		err = (retval < 0) ? retval : -EIO;
+		goto out;
+	}
+
+	/* Success! */
+	err = 0;
+out:
+	if (err) {
+		kfree(elf_phdata);
+		elf_phdata = NULL;
+	}
+	return elf_phdata;
+}
 
 /* This is much more generalized than the library routine read function,
    so we keep this separate.  Technically the library read function
@@ -403,7 +456,7 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 	unsigned long last_bss = 0, elf_bss = 0;
 	unsigned long error = ~0UL;
 	unsigned long total_size;
-	int retval, i, size;
+	int i;
 
 	/* First of all, some simple consistency checks */
 	if (interp_elf_ex->e_type != ET_EXEC &&
@@ -414,33 +467,10 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 	if (!interpreter->f_op->mmap)
 		goto out;
 
-	/*
-	 * If the size of this structure has changed, then punt, since
-	 * we will be doing the wrong thing.
-	 */
-	if (interp_elf_ex->e_phentsize != sizeof(struct elf_phdr))
-		goto out;
-	if (interp_elf_ex->e_phnum < 1 ||
-		interp_elf_ex->e_phnum > 65536U / sizeof(struct elf_phdr))
-		goto out;
-
-	/* Now read in all of the header information */
-	size = sizeof(struct elf_phdr) * interp_elf_ex->e_phnum;
-	if (size > ELF_MIN_ALIGN)
-		goto out;
-	elf_phdata = kmalloc(size, GFP_KERNEL);
+	elf_phdata = load_elf_phdrs(interp_elf_ex, interpreter);
 	if (!elf_phdata)
 		goto out;
 
-	retval = kernel_read(interpreter, interp_elf_ex->e_phoff,
-			     (char *)elf_phdata, size);
-	error = -EIO;
-	if (retval != size) {
-		if (retval < 0)
-			error = retval;	
-		goto out_close;
-	}
-
 	total_size = total_mapping_size(elf_phdata, interp_elf_ex->e_phnum);
 	if (!total_size) {
 		error = -EINVAL;
@@ -578,7 +608,6 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	struct elf_phdr *elf_ppnt, *elf_phdata;
 	unsigned long elf_bss, elf_brk;
 	int retval, i;
-	unsigned int size;
 	unsigned long elf_entry;
 	unsigned long interp_load_addr = 0;
 	unsigned long start_code, end_code, start_data, end_data;
@@ -611,26 +640,10 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	if (!bprm->file->f_op->mmap)
 		goto out;
 
-	/* Now read in all of the header information */
-	if (loc->elf_ex.e_phentsize != sizeof(struct elf_phdr))
-		goto out;
-	if (loc->elf_ex.e_phnum < 1 ||
-	 	loc->elf_ex.e_phnum > 65536U / sizeof(struct elf_phdr))
-		goto out;
-	size = loc->elf_ex.e_phnum * sizeof(struct elf_phdr);
-	retval = -ENOMEM;
-	elf_phdata = kmalloc(size, GFP_KERNEL);
+	elf_phdata = load_elf_phdrs(&loc->elf_ex, bprm->file);
 	if (!elf_phdata)
 		goto out;
 
-	retval = kernel_read(bprm->file, loc->elf_ex.e_phoff,
-			     (char *)elf_phdata, size);
-	if (retval != size) {
-		if (retval >= 0)
-			retval = -EIO;
-		goto out_free_ph;
-	}
-
 	elf_ppnt = elf_phdata;
 	elf_bss = 0;
 	elf_brk = 0;
-- 
2.0.4

