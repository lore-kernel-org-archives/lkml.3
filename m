Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab3IRC4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 22:56:10 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:39465 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3IRC4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 22:56:07 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH 2/2] x86: Useless inode var and Coding style fixes
Date: Tue, 17 Sep 2013 23:54:17 -0300
Message-Id: <1379472857-6473-2-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379472857-6473-1-git-send-email-geyslan@gmail.com>
References: <1379472857-6473-1-git-send-email-geyslan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

file size read only one time: useless prior value allocation.
It's not necessary to verify f_op in the load_aout_library, since the
prior kernel_read/vfs_read function already does.
Coding style and printk strings fixes.

Tested using qemu, a handcrafted a.out binary and a a.out linked with a
cross-compiled ld.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/binfmt_aout.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index 89dec7f..a4af504 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -142,7 +142,8 @@ static int set_brk(unsigned long start, unsigned long end)
  * memory and creates the pointer tables from them, and puts their
  * addresses on the "stack", returning the new stack pointer value.
  */
-static unsigned long __user *create_aout_tables(char __user *p, struct linux_binprm * bprm)
+static unsigned long __user *create_aout_tables(char __user *p,
+						struct linux_binprm *bprm)
 {
 	char __user * __user *argv;
 	char __user * __user *envp;
@@ -213,7 +214,8 @@ static int load_aout_binary(struct linux_binprm * bprm)
 	if ((N_MAGIC(ex) != ZMAGIC && N_MAGIC(ex) != OMAGIC &&
 	     N_MAGIC(ex) != QMAGIC && N_MAGIC(ex) != NMAGIC) ||
 	    N_TRSIZE(ex) || N_DRSIZE(ex) ||
-	    i_size_read(file_inode(bprm->file)) < ex.a_text+ex.a_data+N_SYMSIZE(ex)+N_TXTOFF(ex)) {
+	    i_size_read(file_inode(bprm->file)) <
+	    ex.a_text + ex.a_data + N_SYMSIZE(ex) + N_TXTOFF(ex)) {
 		return -ENOEXEC;
 	}
 
@@ -299,12 +301,12 @@ static int load_aout_binary(struct linux_binprm * bprm)
 
 		if ((fd_offset & ~PAGE_MASK) != 0 && printk_ratelimit())
 		{
-			printk(KERN_WARNING 
+			printk(KERN_WARNING
 			       "fd_offset is not page aligned. Please convert program: %s\n",
 			       bprm->file->f_path.dentry->d_name.name);
 		}
 
-		if (!bprm->file->f_op->mmap||((fd_offset & ~PAGE_MASK) != 0)) {
+		if ((fd_offset & ~PAGE_MASK) != 0) {
 			vm_brk(N_TXTADDR(ex), ex.a_text+ex.a_data);
 			read_code(bprm->file, N_TXTADDR(ex), fd_offset,
 				  ex.a_text + ex.a_data);
@@ -350,14 +352,11 @@ beyond_if:
 
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
@@ -366,7 +365,8 @@ static int load_aout_library(struct file *file)
 	/* We come in here for the regular a.out style of shared libraries */
 	if ((N_MAGIC(ex) != ZMAGIC && N_MAGIC(ex) != QMAGIC) || N_TRSIZE(ex) ||
 	    N_DRSIZE(ex) || ((ex.a_entry & 0xfff) && N_MAGIC(ex) == ZMAGIC) ||
-	    i_size_read(inode) < ex.a_text+ex.a_data+N_SYMSIZE(ex)+N_TXTOFF(ex)) {
+	    i_size_read(file_inode(file)) <
+	    ex.a_text + ex.a_data + N_SYMSIZE(ex) + N_TXTOFF(ex)) {
 		goto out;
 	}
 
@@ -374,7 +374,7 @@ static int load_aout_library(struct file *file)
 	 * Requires a mmap handler. This prevents people from using a.out
 	 * as part of an exploit attack against /proc-related vulnerabilities.
 	 */
-	if (!file->f_op || !file->f_op->mmap)
+	if (!file->f_op->mmap)
 		goto out;
 
 	if (N_FLAGS(ex))
@@ -388,12 +388,12 @@ static int load_aout_library(struct file *file)
 	if ((N_TXTOFF(ex) & ~PAGE_MASK) != 0) {
 		if (printk_ratelimit())
 		{
-			printk(KERN_WARNING 
+			printk(KERN_WARNING
 			       "N_TXTOFF is not page aligned. Please convert library: %s\n",
 			       file->f_path.dentry->d_name.name);
 		}
 		vm_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
-		
+
 		read_code(file, start_addr, N_TXTOFF(ex),
 			  ex.a_text + ex.a_data);
 		retval = 0;
-- 
1.8.4

