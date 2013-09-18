Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab3IRCXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 22:23:06 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:37421 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3IRCXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 22:23:05 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH 1/2] x86_64: Add safe check in a.out loaders and some coding style
Date: Tue, 17 Sep 2013 23:21:23 -0300
Message-Id: <1379470883-3972-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia32_aout had no safe checks concerning the mmap and f_op in this module.
It's not necessary to verify f_op in the load_aout_library, since the
prior kernel_read/vfs_read function already does.
Coding style and printk strings fixes.

Tested using qemu, a handcrafted a.out binary and a a.out linked with a
cross-compiled ld.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 arch/x86/ia32/ia32_aout.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index bae3aba..15a8319 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
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
@@ -350,14 +357,13 @@ static int load_aout_binary(struct linux_binprm *bprm)
 		if ((fd_offset & ~PAGE_MASK) != 0 &&
 			    time_after(jiffies, error_time + 5*HZ)) {
 			printk(KERN_WARNING
-			       "fd_offset is not page aligned. Please convert "
-			       "program: %s\n",
+			       "fd_offset is not page aligned. Please convert program: %s\n",
 			       bprm->file->f_path.dentry->d_name.name);
 			error_time = jiffies;
 		}
 #endif
 
-		if (!bprm->file->f_op->mmap || (fd_offset & ~PAGE_MASK) != 0) {
+		if ((fd_offset & ~PAGE_MASK) != 0) {
 			vm_brk(N_TXTADDR(ex), ex.a_text+ex.a_data);
 			read_code(bprm->file, N_TXTADDR(ex), fd_offset,
 					ex.a_text+ex.a_data);
@@ -424,10 +430,17 @@ static int load_aout_library(struct file *file)
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
 
@@ -441,8 +454,7 @@ static int load_aout_library(struct file *file)
 		static unsigned long error_time;
 		if (time_after(jiffies, error_time + 5*HZ)) {
 			printk(KERN_WARNING
-			       "N_TXTOFF is not page aligned. Please convert "
-			       "library: %s\n",
+			       "N_TXTOFF is not page aligned. Please convert library: %s\n",
 			       file->f_path.dentry->d_name.name);
 			error_time = jiffies;
 		}
-- 
1.8.4

