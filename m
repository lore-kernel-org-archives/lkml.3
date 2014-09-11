Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbaIKImO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:42:14 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:40520 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaIKIhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:37:34 -0400
From: Paul Burton <paul.burton@imgtec.com>
To: <linux-mips@linux-mips.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Paul Burton <paul.burton@imgtec.com>
Subject: [PATCH 02/10] binfmt_elf: load interpreter program headers earlier
Date: Thu, 11 Sep 2014 08:30:15 +0100
Message-ID: <1410420623-11691-3-git-send-email-paul.burton@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
References: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.159.78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Load the program headers of an ELF interpreter early enough in
load_elf_binary that they can be examined before it's too late to return
an error from an exec syscall. This patch does not perform any such
checking, it merely lays the groundwork for a further patch to do so.

No functional change is intended.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
---
 fs/binfmt_elf.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 64ca110..61dabe0 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -447,9 +447,8 @@ out:
 
 static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 		struct file *interpreter, unsigned long *interp_map_addr,
-		unsigned long no_base)
+		unsigned long no_base, struct elf_phdr *interp_elf_phdata)
 {
-	struct elf_phdr *elf_phdata;
 	struct elf_phdr *eppnt;
 	unsigned long load_addr = 0;
 	int load_addr_set = 0;
@@ -467,17 +466,14 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 	if (!interpreter->f_op->mmap)
 		goto out;
 
-	elf_phdata = load_elf_phdrs(interp_elf_ex, interpreter);
-	if (!elf_phdata)
-		goto out;
-
-	total_size = total_mapping_size(elf_phdata, interp_elf_ex->e_phnum);
+	total_size = total_mapping_size(interp_elf_phdata,
+					interp_elf_ex->e_phnum);
 	if (!total_size) {
 		error = -EINVAL;
-		goto out_close;
+		goto out;
 	}
 
-	eppnt = elf_phdata;
+	eppnt = interp_elf_phdata;
 	for (i = 0; i < interp_elf_ex->e_phnum; i++, eppnt++) {
 		if (eppnt->p_type == PT_LOAD) {
 			int elf_type = MAP_PRIVATE | MAP_DENYWRITE;
@@ -504,7 +500,7 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 				*interp_map_addr = map_addr;
 			error = map_addr;
 			if (BAD_ADDR(map_addr))
-				goto out_close;
+				goto out;
 
 			if (!load_addr_set &&
 			    interp_elf_ex->e_type == ET_DYN) {
@@ -523,7 +519,7 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 			    eppnt->p_memsz > TASK_SIZE ||
 			    TASK_SIZE - eppnt->p_memsz < k) {
 				error = -ENOMEM;
-				goto out_close;
+				goto out;
 			}
 
 			/*
@@ -553,7 +549,7 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 		 */
 		if (padzero(elf_bss)) {
 			error = -EFAULT;
-			goto out_close;
+			goto out;
 		}
 
 		/* What we have mapped so far */
@@ -562,13 +558,10 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 		/* Map the last of the bss segment */
 		error = vm_brk(elf_bss, last_bss - elf_bss);
 		if (BAD_ADDR(error))
-			goto out_close;
+			goto out;
 	}
 
 	error = load_addr;
-
-out_close:
-	kfree(elf_phdata);
 out:
 	return error;
 }
@@ -605,7 +598,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	int load_addr_set = 0;
 	char * elf_interpreter = NULL;
 	unsigned long error;
-	struct elf_phdr *elf_ppnt, *elf_phdata;
+	struct elf_phdr *elf_ppnt, *elf_phdata, *interp_elf_phdata = NULL;
 	unsigned long elf_bss, elf_brk;
 	int retval, i;
 	unsigned long elf_entry;
@@ -729,6 +722,12 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		/* Verify the interpreter has a valid arch */
 		if (!elf_check_arch(&loc->interp_elf_ex))
 			goto out_free_dentry;
+
+		/* Load the interpreter program headers */
+		interp_elf_phdata = load_elf_phdrs(&loc->interp_elf_ex,
+						   interpreter);
+		if (!interp_elf_phdata)
+			goto out_free_dentry;
 	}
 
 	/* Flush all traces of the currently running executable */
@@ -912,7 +911,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		elf_entry = load_elf_interp(&loc->interp_elf_ex,
 					    interpreter,
 					    &interp_map_addr,
-					    load_bias);
+					    load_bias, interp_elf_phdata);
 		if (!IS_ERR((void *)elf_entry)) {
 			/*
 			 * load_elf_interp() returns relocation
@@ -1009,6 +1008,7 @@ out_ret:
 
 	/* error cleanup */
 out_free_dentry:
+	kfree(interp_elf_phdata);
 	allow_write_access(interpreter);
 	if (interpreter)
 		fput(interpreter);
-- 
2.0.4

