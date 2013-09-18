Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3IRV3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 17:29:31 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:38516 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab3IRV33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 17:29:29 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH 01/02] x86: Useless inode var, printks and coding style fixes
Date: Wed, 18 Sep 2013 18:27:20 -0300
Message-Id: <1379539641-1726-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

file size read only one time: useless prior value allocation.
It's not necessary to verify f_op in the load_aout_library, since the
prior kernel_read/vfs_read function already does.
Coding style fixes and printk replacements.

Tested using qemu, a handcrafted a.out binary and a a.out linked with a
cross-compiled ld.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/binfmt_aout.c | 41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index 89dec7f..2307467 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/coredump.h>
 #include <linux/slab.h>
+#include <linux/ratelimit.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -142,7 +143,8 @@ static int set_brk(unsigned long start, unsigned long end)
  * memory and creates the pointer tables from them, and puts their
  * addresses on the "stack", returning the new stack pointer value.
  */
-static unsigned long __user *create_aout_tables(char __user *p, struct linux_binprm * bprm)
+static unsigned long __user *create_aout_tables(char __user *p,
+						struct linux_binprm *bprm)
 {
 	char __user * __user *argv;
 	char __user * __user *envp;
@@ -213,7 +215,8 @@ static int load_aout_binary(struct linux_binprm * bprm)
 	if ((N_MAGIC(ex) != ZMAGIC && N_MAGIC(ex) != OMAGIC &&
 	     N_MAGIC(ex) != QMAGIC && N_MAGIC(ex) != NMAGIC) ||
 	    N_TRSIZE(ex) || N_DRSIZE(ex) ||
-	    i_size_read(file_inode(bprm->file)) < ex.a_text+ex.a_data+N_SYMSIZE(ex)+N_TXTOFF(ex)) {
+	    i_size_read(file_inode(bprm->file)) <
+	    ex.a_text + ex.a_data + N_SYMSIZE(ex) + N_TXTOFF(ex)) {
 		return -ENOEXEC;
 	}
 
@@ -292,19 +295,16 @@ static int load_aout_binary(struct linux_binprm * bprm)
 		}
 	} else {
 		if ((ex.a_text & 0xfff || ex.a_data & 0xfff) &&
-		    (N_MAGIC(ex) != NMAGIC) && printk_ratelimit())
+		    (N_MAGIC(ex) != NMAGIC))
 		{
-			printk(KERN_NOTICE "executable not page aligned\n");
+			pr_notice_ratelimited("executable not page aligned\n");
 		}
 
-		if ((fd_offset & ~PAGE_MASK) != 0 && printk_ratelimit())
-		{
-			printk(KERN_WARNING 
-			       "fd_offset is not page aligned. Please convert program: %s\n",
-			       bprm->file->f_path.dentry->d_name.name);
-		}
+		if ((fd_offset & ~PAGE_MASK) != 0)
+			pr_warn_ratelimited("fd_offset is not page aligned. Please convert program: %s\n",
+					    bprm->file->f_path.dentry->d_name.name);
 
-		if (!bprm->file->f_op->mmap||((fd_offset & ~PAGE_MASK) != 0)) {
+		if ((fd_offset & ~PAGE_MASK) != 0) {
 			vm_brk(N_TXTADDR(ex), ex.a_text+ex.a_data);
 			read_code(bprm->file, N_TXTADDR(ex), fd_offset,
 				  ex.a_text + ex.a_data);
@@ -350,14 +350,11 @@ beyond_if:
 
 static int load_aout_library(struct file *file)
 {
-	struct inode * inode;
 	unsigned long bss, start_addr, len;
 	unsigned long error;
 	int retval;
 	struct exec ex;
 
-	inode = file_inode(file);
-
 	retval = -ENOEXEC;
 	error = kernel_read(file, 0, (char *) &ex, sizeof(ex));
 	if (error != sizeof(ex))
@@ -366,7 +363,8 @@ static int load_aout_library(struct file *file)
 	/* We come in here for the regular a.out style of shared libraries */
 	if ((N_MAGIC(ex) != ZMAGIC && N_MAGIC(ex) != QMAGIC) || N_TRSIZE(ex) ||
 	    N_DRSIZE(ex) || ((ex.a_entry & 0xfff) && N_MAGIC(ex) == ZMAGIC) ||
-	    i_size_read(inode) < ex.a_text+ex.a_data+N_SYMSIZE(ex)+N_TXTOFF(ex)) {
+	    i_size_read(file_inode(file)) <
+	    ex.a_text + ex.a_data + N_SYMSIZE(ex) + N_TXTOFF(ex)) {
 		goto out;
 	}
 
@@ -374,7 +372,7 @@ static int load_aout_library(struct file *file)
 	 * Requires a mmap handler. This prevents people from using a.out
 	 * as part of an exploit attack against /proc-related vulnerabilities.
 	 */
-	if (!file->f_op || !file->f_op->mmap)
+	if (!file->f_op->mmap)
 		goto out;
 
 	if (N_FLAGS(ex))
@@ -386,14 +384,11 @@ static int load_aout_library(struct file *file)
 	start_addr =  ex.a_entry & 0xfffff000;
 
 	if ((N_TXTOFF(ex) & ~PAGE_MASK) != 0) {
-		if (printk_ratelimit())
-		{
-			printk(KERN_WARNING 
-			       "N_TXTOFF is not page aligned. Please convert library: %s\n",
-			       file->f_path.dentry->d_name.name);
-		}
+		pr_warn_ratelimited("N_TXTOFF is not page aligned. Please convert library: %s\n",
+				    file->f_path.dentry->d_name.name);
+
 		vm_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
-		
+
 		read_code(file, start_addr, N_TXTOFF(ex),
 			  ex.a_text + ex.a_data);
 		retval = 0;
-- 
1.8.4

