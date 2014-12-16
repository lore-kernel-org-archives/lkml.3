Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaLPD7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 22:59:40 -0500
Received: from pegasus3.altlinux.org ([194.107.17.103]:39989 "EHLO
	pegasus3.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaLPD7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 22:59:39 -0500
Date: Tue, 16 Dec 2014 06:59:37 +0300
From: "Dmitry V. Levin" <ldv@altlinux.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND v4 PATCH 2/2] vfs: make mounts and mountstats honor root dir
 like mountinfo does
Message-ID: <20141216035936.GC2461@altlinux.org>
Mail-Followup-To: Al Viro <viro@ZenIV.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20140929180523.GC15829@altlinux.org>
 <20140929183222.GJ7996@ZenIV.linux.org.uk>
 <20140929184333.GD15829@altlinux.org>
 <20140929193329.GL7996@ZenIV.linux.org.uk>
 <20140929202659.GA16292@altlinux.org>
 <20140929212057.GN7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929212057.GN7996@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we already show mountpoints relative to the root directory, thanks
to the change made back in 2000, change show_vfsmnt() and show_vfsstat()
to skip out-of-root mountpoints the same way as show_mountinfo() does.

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
