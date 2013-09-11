Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab3IKE7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab3IKE5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:05 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=2m5QCr9AYkkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=-SR9KHVdskEA:10 a=drOt6m5kAAAA:8 a=zIFEpUIBb9-fIA0fM3gA:9 a=jeBq3FmKZ4MA:10 a=qM7uQree8IL0P5V5:21 a=F9LN8SnIH2XLWJ4k:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042923.290785808@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [187/251] reiserfs: fix deadlock in umount
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0187-reiserfs-fix-deadlock-in-umount.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 672fe15d091ce76d6fb98e489962e9add7c1ba4c ]

Since remove_proc_entry() started to wait for IO in progress (i.e.
since 2007 or so), the locking in fs/reiserfs/proc.c became wrong;
if procfs read happens between the moment when umount() locks the
victim superblock and removal of /proc/fs/reiserfs/<device>/*,
we'll get a deadlock - read will wait for s_umount (in sget(),
called by r_start()), while umount will wait in remove_proc_entry()
for that read to finish, holding s_umount all along.

Fortunately, the same change allows a much simpler race avoidance -
all we need to do is remove the procfs entries in the very beginning
of reiserfs ->kill_sb(); that'll guarantee that pointer to superblock
will remain valid for the duration for procfs IO, so we don't need
sget() to keep the sucker alive.  As the matter of fact, we can
get rid of the home-grown iterator completely, and use single_open()
instead.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/reiserfs/procfs.c |   92 +++++++++++---------------------------------------
 fs/reiserfs/super.c  |    3 +-
 2 files changed, 20 insertions(+), 75 deletions(-)

diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index e60e870..d700e3f 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -19,12 +19,13 @@
 /*
  * LOCKING:
  *
- * We rely on new Alexander Viro's super-block locking.
+ * These guys are evicted from procfs as the very first step in ->kill_sb().
  *
  */
 
-static int show_version(struct seq_file *m, struct super_block *sb)
+static int show_version(struct seq_file *m, void *unused)
 {
+	struct super_block *sb = m->private;
 	char *format;
 
 	if (REISERFS_SB(sb)->s_properties & (1 << REISERFS_3_6)) {
@@ -66,8 +67,9 @@ static int show_version(struct seq_file *m, struct super_block *sb)
 #define DJP( x ) le32_to_cpu( jp -> x )
 #define JF( x ) ( r -> s_journal -> x )
 
-static int show_super(struct seq_file *m, struct super_block *sb)
+static int show_super(struct seq_file *m, void *unused)
 {
+	struct super_block *sb = m->private;
 	struct reiserfs_sb_info *r = REISERFS_SB(sb);
 
 	seq_printf(m, "state: \t%s\n"
@@ -128,8 +130,9 @@ static int show_super(struct seq_file *m, struct super_block *sb)
 	return 0;
 }
 
-static int show_per_level(struct seq_file *m, struct super_block *sb)
+static int show_per_level(struct seq_file *m, void *unused)
 {
+	struct super_block *sb = m->private;
 	struct reiserfs_sb_info *r = REISERFS_SB(sb);
 	int level;
 
@@ -186,8 +189,9 @@ static int show_per_level(struct seq_file *m, struct super_block *sb)
 	return 0;
 }
 
-static int show_bitmap(struct seq_file *m, struct super_block *sb)
+static int show_bitmap(struct seq_file *m, void *unused)
 {
+	struct super_block *sb = m->private;
 	struct reiserfs_sb_info *r = REISERFS_SB(sb);
 
 	seq_printf(m, "free_block: %lu\n"
@@ -218,8 +222,9 @@ static int show_bitmap(struct seq_file *m, struct super_block *sb)
 	return 0;
 }
 
-static int show_on_disk_super(struct seq_file *m, struct super_block *sb)
+static int show_on_disk_super(struct seq_file *m, void *unused)
 {
+	struct super_block *sb = m->private;
 	struct reiserfs_sb_info *sb_info = REISERFS_SB(sb);
 	struct reiserfs_super_block *rs = sb_info->s_rs;
 	int hash_code = DFL(s_hash_function_code);
@@ -261,8 +266,9 @@ static int show_on_disk_super(struct seq_file *m, struct super_block *sb)
 	return 0;
 }
 
-static int show_oidmap(struct seq_file *m, struct super_block *sb)
+static int show_oidmap(struct seq_file *m, void *unused)
 {
+	struct super_block *sb = m->private;
 	struct reiserfs_sb_info *sb_info = REISERFS_SB(sb);
 	struct reiserfs_super_block *rs = sb_info->s_rs;
 	unsigned int mapsize = le16_to_cpu(rs->s_v1.s_oid_cursize);
@@ -291,8 +297,9 @@ static int show_oidmap(struct seq_file *m, struct super_block *sb)
 	return 0;
 }
 
-static int show_journal(struct seq_file *m, struct super_block *sb)
+static int show_journal(struct seq_file *m, void *unused)
 {
+	struct super_block *sb = m->private;
 	struct reiserfs_sb_info *r = REISERFS_SB(sb);
 	struct reiserfs_super_block *rs = r->s_rs;
 	struct journal_params *jp = &rs->s_v1.s_journal;
@@ -383,85 +390,24 @@ static int show_journal(struct seq_file *m, struct super_block *sb)
 	return 0;
 }
 
-/* iterator */
-static int test_sb(struct super_block *sb, void *data)
-{
-	return data == sb;
-}
-
-static int set_sb(struct super_block *sb, void *data)
-{
-	return -ENOENT;
-}
-
-static void *r_start(struct seq_file *m, loff_t * pos)
-{
-	struct proc_dir_entry *de = m->private;
-	struct super_block *s = de->parent->data;
-	loff_t l = *pos;
-
-	if (l)
-		return NULL;
-
-	if (IS_ERR(sget(&reiserfs_fs_type, test_sb, set_sb, 0, s)))
-		return NULL;
-
-	up_write(&s->s_umount);
-	return s;
-}
-
-static void *r_next(struct seq_file *m, void *v, loff_t * pos)
-{
-	++*pos;
-	if (v)
-		deactivate_super(v);
-	return NULL;
-}
-
-static void r_stop(struct seq_file *m, void *v)
-{
-	if (v)
-		deactivate_super(v);
-}
-
-static int r_show(struct seq_file *m, void *v)
-{
-	struct proc_dir_entry *de = m->private;
-	int (*show) (struct seq_file *, struct super_block *) = de->data;
-	return show(m, v);
-}
-
-static const struct seq_operations r_ops = {
-	.start = r_start,
-	.next = r_next,
-	.stop = r_stop,
-	.show = r_show,
-};
-
 static int r_open(struct inode *inode, struct file *file)
 {
-	int ret = seq_open(file, &r_ops);
-
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		m->private = PDE(inode);
-	}
-	return ret;
+	return single_open(file, PDE(inode)->data,
+                           PDE(inode)->parent->data);
 }
 
 static const struct file_operations r_file_operations = {
 	.open = r_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = seq_release,
-	.owner = THIS_MODULE,
+	.release = single_release,
 };
 
 static struct proc_dir_entry *proc_info_root = NULL;
 static const char proc_info_root_name[] = "fs/reiserfs";
 
 static void add_file(struct super_block *sb, char *name,
-		     int (*func) (struct seq_file *, struct super_block *))
+		     int (*func) (struct seq_file *, void *))
 {
 	proc_create_data(name, 0, REISERFS_SB(sb)->procdir,
 			 &r_file_operations, func);
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 4300030..cd4b149 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -499,6 +499,7 @@ int remove_save_link(struct inode *inode, int truncate)
 static void reiserfs_kill_sb(struct super_block *s)
 {
 	if (REISERFS_SB(s)) {
+		reiserfs_proc_info_done(s);
 		/*
 		 * Force any pending inode evictions to occur now. Any
 		 * inodes to be removed that have extended attributes
@@ -554,8 +555,6 @@ static void reiserfs_put_super(struct super_block *s)
 				 REISERFS_SB(s)->reserved_blocks);
 	}
 
-	reiserfs_proc_info_done(s);
-
 	reiserfs_write_unlock(s);
 	mutex_destroy(&REISERFS_SB(s)->lock);
 	kfree(s->s_fs_info);
-- 
1.7.10.4


