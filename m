Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbaI2SOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:14:00 -0400
Received: from pegasus3.altlinux.org ([194.107.17.103]:52964 "EHLO
	pegasus3.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbaI2SNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:13:16 -0400
Date: Mon, 29 Sep 2014 22:05:23 +0400
From: "Dmitry V. Levin" <ldv@altlinux.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND v3 PATCH 3/3] vfs: make mounts and mountstats honor root dir like mountinfo does
Message-ID: <20140929180523.GC15829@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Wed, 17 Oct 2012 20:29:55 +0400

Change show_vfsmnt() and show_vfsstat() to show mountpoints relative
to the root directory and skip mountpoints outside of chroot jail
the same way as show_mountinfo() does.

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 fs/proc_namespace.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 789e8d1..0f96f71 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -91,6 +91,7 @@ static void show_type(struct seq_file *m, struct super_block *sb)
 
 static int show_vfsmnt(struct seq_file *m, struct vfsmount *mnt)
 {
+	struct proc_mounts *p = proc_mounts(m);
 	struct mount *r = real_mount(mnt);
 	int err = 0;
 	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
@@ -104,7 +105,10 @@ static int show_vfsmnt(struct seq_file *m, struct vfsmount *mnt)
 		mangle(m, r->mnt_devname ? r->mnt_devname : "none");
 	}
 	seq_putc(m, ' ');
-	seq_path(m, &mnt_path, " \t\n\\");
+	/* mountpoints outside of chroot jail will give SEQ_SKIP on this */
+	err = seq_path_root(m, &mnt_path, &p->root, " \t\n\\");
+	if (err)
+		goto out;
 	seq_putc(m, ' ');
 	show_type(m, sb);
 	seq_puts(m, __mnt_is_readonly(mnt) ? " ro" : " rw");
@@ -181,6 +185,7 @@ out:
 
 static int show_vfsstat(struct seq_file *m, struct vfsmount *mnt)
 {
+	struct proc_mounts *p = proc_mounts(m);
 	struct mount *r = real_mount(mnt);
 	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
 	struct super_block *sb = mnt_path.dentry->d_sb;
@@ -200,7 +205,10 @@ static int show_vfsstat(struct seq_file *m, struct vfsmount *mnt)
 
 	/* mount point */
 	seq_puts(m, " mounted on ");
-	seq_path(m, &mnt_path, " \t\n\\");
+	/* mountpoints outside of chroot jail will give SEQ_SKIP on this */
+	err = seq_path_root(m, &mnt_path, &p->root, " \t\n\\");
+	if (err)
+		goto out;
 	seq_putc(m, ' ');
 
 	/* file system type */
@@ -215,6 +223,7 @@ static int show_vfsstat(struct seq_file *m, struct vfsmount *mnt)
 	}
 
 	seq_putc(m, '\n');
+out:
 	return err;
 }
 
-- 
ldv

