Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab3ITDKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 23:10:17 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:34499 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab3ITDKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 23:10:14 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, joe@perches.com
Cc: linux-kernel@vger.kernel.org, "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH v2 2/2] ia32_aout: x86_64: Add safe check in a.out loaders, printks, conding style fixes
Date: Fri, 20 Sep 2013 00:08:20 -0300
Message-Id: <1379646500-11858-2-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379646500-11858-1-git-send-email-geyslan@gmail.com>
References: <1379646500-11858-1-git-send-email-geyslan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia32_aout had no safe checks concerning the mmap and f_op in this module.
It's not necessary to verify f_op in the load_aout_library, since the
prior kernel_read/vfs_read function already does.
Made coding style fixes and printks replacements.

Tested using qemu, a handcrafted a.out binary and a a.out linked with a
cross-compiled ld.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 arch/x86/ia32/ia32_aout.c | 63 +++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index bae3aba..87d5114 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -24,9 +24,9 @@
 #include <linux/binfmts.h>
 #include <linux/personality.h>
 #include <linux/init.h>
-#include <linux/jiffies.h>
+#include <linux/ratelimit.h>
+#include <linux/uaccess.h>
 
-#include <asm/uaccess.h>
 #include <asm/pgalloc.h>
 #include <asm/cacheflush.h>
 #include <asm/user32.h>
@@ -224,9 +224,9 @@ static u32 __user *create_aout_tables(char __user *p, struct linux_binprm *bprm)
 	int argc = bprm->argc, envc = bprm->envc;
 
 	sp = (u32 __user *) ((-(unsigned long)sizeof(u32)) & (unsigned long) p);
-	sp -= envc+1;
+	sp -= envc + 1;
 	envp = sp;
-	sp -= argc+1;
+	sp -= argc + 1;
 	argv = sp;
 	put_user((unsigned long) envp, --sp);
 	put_user((unsigned long) argv, --sp);
@@ -271,10 +271,17 @@ static int load_aout_binary(struct linux_binprm *bprm)
 	     N_MAGIC(ex) != QMAGIC && N_MAGIC(ex) != NMAGIC) ||
 	    N_TRSIZE(ex) || N_DRSIZE(ex) ||
 	    i_size_read(file_inode(bprm->file)) <
-	    ex.a_text+ex.a_data+N_SYMSIZE(ex)+N_TXTOFF(ex)) {
+	    ex.a_text + ex.a_data + N_SYMSIZE(ex) + N_TXTOFF(ex)) {
 		return -ENOEXEC;
 	}
 
+	/*
+	 * Requires a mmap handler. This prevents people from using a.out
+	 * as part of an exploit attack against /proc-related vulnerabilities.
+	 */
+	if (!bprm->file->f_op || !bprm->file->f_op->mmap)
+		return -ENOEXEC;
+
 	fd_offset = N_TXTOFF(ex);
 
 	/* Check initial limits. This avoids letting people circumvent
@@ -322,7 +329,7 @@ static int load_aout_binary(struct linux_binprm *bprm)
 		unsigned long text_addr, map_size;
 
 		text_addr = N_TXTADDR(ex);
-		map_size = ex.a_text+ex.a_data;
+		map_size = ex.a_text + ex.a_data;
 
 		error = vm_brk(text_addr & PAGE_MASK, map_size);
 
@@ -339,28 +346,19 @@ static int load_aout_binary(struct linux_binprm *bprm)
 		}
 	} else {
 #ifdef WARN_OLD
-		static unsigned long error_time, error_time2;
 		if ((ex.a_text & 0xfff || ex.a_data & 0xfff) &&
-		    (N_MAGIC(ex) != NMAGIC) &&
-				time_after(jiffies, error_time2 + 5*HZ)) {
-			printk(KERN_NOTICE "executable not page aligned\n");
-			error_time2 = jiffies;
-		}
+		    (N_MAGIC(ex) != NMAGIC))
+			pr_notice_ratelimited("executable not page aligned\n");
 
-		if ((fd_offset & ~PAGE_MASK) != 0 &&
-			    time_after(jiffies, error_time + 5*HZ)) {
-			printk(KERN_WARNING
-			       "fd_offset is not page aligned. Please convert "
-			       "program: %s\n",
-			       bprm->file->f_path.dentry->d_name.name);
-			error_time = jiffies;
-		}
+		if ((fd_offset & ~PAGE_MASK) != 0)
+			pr_warn_ratelimited("fd_offset is not page aligned. Please convert program: %s\n",
+					    bprm->file->f_path.dentry->d_name.name);
 #endif
 
-		if (!bprm->file->f_op->mmap || (fd_offset & ~PAGE_MASK) != 0) {
-			vm_brk(N_TXTADDR(ex), ex.a_text+ex.a_data);
+		if ((fd_offset & ~PAGE_MASK) != 0) {
+			vm_brk(N_TXTADDR(ex), ex.a_text + ex.a_data);
 			read_code(bprm->file, N_TXTADDR(ex), fd_offset,
-					ex.a_text+ex.a_data);
+					ex.a_text + ex.a_data);
 			goto beyond_if;
 		}
 
@@ -424,10 +422,17 @@ static int load_aout_library(struct file *file)
 	if ((N_MAGIC(ex) != ZMAGIC && N_MAGIC(ex) != QMAGIC) || N_TRSIZE(ex) ||
 	    N_DRSIZE(ex) || ((ex.a_entry & 0xfff) && N_MAGIC(ex) == ZMAGIC) ||
 	    i_size_read(file_inode(file)) <
-	    ex.a_text+ex.a_data+N_SYMSIZE(ex)+N_TXTOFF(ex)) {
+	    ex.a_text + ex.a_data + N_SYMSIZE(ex) + N_TXTOFF(ex)) {
 		goto out;
 	}
 
+	/*
+	 * Requires a mmap handler. This prevents people from using a.out
+	 * as part of an exploit attack against /proc-related vulnerabilities.
+	 */
+	if (!file->f_op->mmap)
+		goto out;
+
 	if (N_FLAGS(ex))
 		goto out;
 
@@ -438,14 +443,8 @@ static int load_aout_library(struct file *file)
 
 	if ((N_TXTOFF(ex) & ~PAGE_MASK) != 0) {
 #ifdef WARN_OLD
-		static unsigned long error_time;
-		if (time_after(jiffies, error_time + 5*HZ)) {
-			printk(KERN_WARNING
-			       "N_TXTOFF is not page aligned. Please convert "
-			       "library: %s\n",
-			       file->f_path.dentry->d_name.name);
-			error_time = jiffies;
-		}
+		pr_warn_ratelimited("N_TXTOFF is not page aligned. Please convert library: %s\n",
+				    file->f_path.dentry->d_name.name);
 #endif
 		vm_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
 
-- 
1.8.4

