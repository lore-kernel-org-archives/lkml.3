Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965199Ab3DPS04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:26:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965003Ab3DPS0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:26:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 15/28] reiserfs: Don't access the proc_dir_entry in r_open(),
 r_start() r_show() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        reiserfs-devel@vger.kernel.org
Date: Tue, 16 Apr 2013 19:26:51 +0100
Message-ID: <20130416182651.27773.77972.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't access the proc_dir_entry in ReiserFS's r_open(), r_start() r_show()
procfs interface functions.

ReiserFS stores the ->show() method pointer in PDE->data and the super_block
pointer in PDE->parent->data.  This isn't changing.

Currently, ReiserFS passes the PDE pointer into seq_file::private from
r_open() so that r_start() and r_show() can then access it.  Instead, use
seq_open_private() to allocate a two-pointer struct that's passed through
seq_file::private and put the ->show() method and the sb pointers in there.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: reiserfs-devel@vger.kernel.org
---

 fs/reiserfs/procfs.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index 274adea..33532f7 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -394,20 +394,24 @@ static int set_sb(struct super_block *sb, void *data)
 	return -ENOENT;
 }
 
+struct reiserfs_seq_private {
+	struct super_block *sb;
+	int (*show) (struct seq_file *, struct super_block *);
+};
+
 static void *r_start(struct seq_file *m, loff_t * pos)
 {
-	struct proc_dir_entry *de = m->private;
-	struct super_block *s = de->parent->data;
+	struct reiserfs_seq_private *priv = m->private;
 	loff_t l = *pos;
 
 	if (l)
 		return NULL;
 
-	if (IS_ERR(sget(&reiserfs_fs_type, test_sb, set_sb, 0, s)))
+	if (IS_ERR(sget(&reiserfs_fs_type, test_sb, set_sb, 0, priv->sb)))
 		return NULL;
 
-	up_write(&s->s_umount);
-	return s;
+	up_write(&priv->sb->s_umount);
+	return priv->sb;
 }
 
 static void *r_next(struct seq_file *m, void *v, loff_t * pos)
@@ -426,9 +430,8 @@ static void r_stop(struct seq_file *m, void *v)
 
 static int r_show(struct seq_file *m, void *v)
 {
-	struct proc_dir_entry *de = m->private;
-	int (*show) (struct seq_file *, struct super_block *) = de->data;
-	return show(m, v);
+	struct reiserfs_seq_private *priv = m->private;
+	return priv->show(m, v);
 }
 
 static const struct seq_operations r_ops = {
@@ -440,11 +443,15 @@ static const struct seq_operations r_ops = {
 
 static int r_open(struct inode *inode, struct file *file)
 {
-	int ret = seq_open(file, &r_ops);
+	struct reiserfs_seq_private *priv;
+	int ret = seq_open_private(file, &r_ops,
+				   sizeof(struct reiserfs_seq_private));
 
 	if (!ret) {
 		struct seq_file *m = file->private_data;
-		m->private = PDE(inode);
+		priv = m->private;
+		priv->sb = proc_get_parent_data(inode);
+		priv->show = PDE_DATA(inode);
 	}
 	return ret;
 }
@@ -453,7 +460,7 @@ static const struct file_operations r_file_operations = {
 	.open = r_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = seq_release,
+	.release = seq_release_private,
 	.owner = THIS_MODULE,
 };
 
@@ -479,9 +486,8 @@ int reiserfs_proc_info_init(struct super_block *sb)
 		*s = '!';
 
 	spin_lock_init(&__PINFO(sb).lock);
-	REISERFS_SB(sb)->procdir = proc_mkdir(b, proc_info_root);
+	REISERFS_SB(sb)->procdir = proc_mkdir_data(b, 0, proc_info_root, sb);
 	if (REISERFS_SB(sb)->procdir) {
-		REISERFS_SB(sb)->procdir->data = sb;
 		add_file(sb, "version", show_version);
 		add_file(sb, "super", show_super);
 		add_file(sb, "per-level", show_per_level);

