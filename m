Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab3LCFwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 00:52:45 -0500
Received: from mout.gmx.net ([74.208.4.200]:49859 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab3LCFwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 00:52:42 -0500
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Date: Tue, 03 Dec 2013 00:52:40 -0500
From: "Fabian Frederick" <fabian.frederick@humanoid.net>
Message-ID: <20131203055241.3160@gmx.com>
MIME-Version: 1.0
Subject: [PATCH] befs : Add small_data support through xattr handlers
To: linux-kernel@vger.kernel.org
X-Flags: 0001
X-Mailer: GMX.com Web Mailer
x-registered: 0
X-GMX-UID: /hTvclhg3zOlO8VHFX8h5Kt+IGRvb4C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beos Filesystem stores small attributes in first inode block automagically read during lookup.
Current driver implementation does nothing about it.
 
Those attributes feature both window manager and user metadata.
 
-This patch wakes up the small_data dump functionality when mounting in debug mode (iget)
-The same is done "for real" by creating a list_head merged in befs_inode_info.
-getfattr -n "attributename" is handled as well to retrieve small attributes
 through xattr_handlers.
 
I hope someone (Andrew, Al ?) can help me improve that feature despite that driver is declared "Orphan" in maintainer list.
 
Signed off by Fabian Frederick
diff --git a/fs/befs/befs.h b/fs/befs/befs.h
index b266428..02eb7ae 100644
--- a/fs/befs/befs.h
+++ b/fs/befs/befs.h
@@ -57,6 +57,14 @@ typedef struct befs_sb_info {
 
 } befs_sb_info;
 
+typedef struct befs_small_datamem {
+ u32 type;
+ char name[BEFS_ATTRIBUTE_LEN];
+ char value[BEFS_ATTRIBUTE_VALUE_LEN];
+ struct list_head list;
+
+} befs_small_datamem;
+
 typedef struct befs_inode_info {
  u32 i_flags;
  u32 i_type;
@@ -71,6 +79,7 @@ typedef struct befs_inode_info {
  } i_data;
 
  struct inode vfs_inode;
+ struct befs_small_datamem datamem;
 
 } befs_inode_info;
 
@@ -96,6 +105,8 @@ void befs_dump_super_block(const struct super_block *sb, befs_super_block *);
 void befs_dump_inode(const struct super_block *sb, befs_inode *);
 void befs_dump_index_entry(const struct super_block *sb, befs_disk_btree_super *);
 void befs_dump_index_node(const struct super_block *sb, befs_btree_nodehead *);
+void befs_dump_small_data(const struct super_block *sb, befs_small_data * sd);
+
 /****************************/
 
 
diff --git a/fs/befs/befs_fs_types.h b/fs/befs/befs_fs_types.h
index eb557d9..47e2ac0 100644
--- a/fs/befs/befs_fs_types.h
+++ b/fs/befs/befs_fs_types.h
@@ -26,6 +26,8 @@
 
 #define BEFS_NAME_LEN 255
 
+#define BEFS_ATTRIBUTE_LEN 255
+#define BEFS_ATTRIBUTE_VALUE_LEN 1024
 #define BEFS_SYMLINK_LEN 144
 #define BEFS_NUM_DIRECT_BLOCKS 12
 #define B_OS_NAME_LENGTH 32
diff --git a/fs/befs/debug.c b/fs/befs/debug.c
index 622e737..d23dda2 100644
--- a/fs/befs/debug.c
+++ b/fs/befs/debug.c
@@ -222,13 +222,38 @@ befs_dump_super_block(const struct super_block *sb, befs_super_block * sup)
 #endif //CONFIG_BEFS_DEBUG
 }
 
-#if 0
-/* unused */
 void
 befs_dump_small_data(const struct super_block *sb, befs_small_data * sd)
 {
+#ifdef CONFIG_BEFS_DEBUG
+
+ char *oft, *ioft;
+ ioft=(char*)sd;
+
+ while(1){
+ befs_debug(sb, "befs_small_data information");
+ befs_debug(sb, "   type : %x", sd->type);
+ befs_debug(sb, "   name size : %d", sd->name_size);
+ befs_debug(sb, "   name size : %d", sd->data_size);
+ if(sd->name[0]==0x13)
+ befs_debug(sb, "   name : %d", sd->data_size);
+     else befs_debug(sb, "   name : %s", sd->name);
+ oft=sd->name;
+ while(oft[0])oft++; //eos
+ oft+=3; //padding
+ befs_debug(sb, "   value :%s", oft);
+ oft=oft+(sd->data_size);
+ while(!oft[0])oft++; 
+ sd=(befs_small_data*)oft;
+ befs_debug(sb, "   ioft : %x oft : %x delta : %x", ioft, oft, oft-ioft);
+ if(oft-ioft > sb->s_blocksize-sizeof(befs_inode))
+ break;
+ }
+
+#endif //CONFIG_BEFS_DEBUG
 }
 
+#if 0
 /* unused */
 void
 befs_dump_run(const struct super_block *sb, befs_disk_block_run run)
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index daa15d6..ba7d3e8 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -3,6 +3,8 @@
  *
  * Copyright (C) 2001 Will Dyson <will_dyson@pobox.com
  *
+ * 12/2013 : Fabian Frederick : Adding xattr support.
+ *
  */
 
 #include <linux/module.h>
@@ -16,6 +18,7 @@
 #include <linux/parser.h>
 #include <linux/namei.h>
 #include <linux/sched.h>
+#include <linux/xattr.h>
 
 #include "befs.h"
 #include "btree.h"
@@ -36,6 +39,7 @@ static int befs_get_block(struct inode *, sector_t, struct buffer_head *, int);
 static int befs_readpage(struct file *file, struct page *page);
 static sector_t befs_bmap(struct address_space *mapping, sector_t block);
 static struct dentry *befs_lookup(struct inode *, struct dentry *, unsigned int);
+static void befs_getsmalldata(struct super_block *, befs_small_data *, struct befs_small_datamem *);
 static struct inode *befs_iget(struct super_block *, unsigned long);
 static struct inode *befs_alloc_inode(struct super_block *sb);
 static void befs_destroy_inode(struct inode *inode);
@@ -43,6 +47,7 @@ static int befs_init_inodecache(void);
 static void befs_destroy_inodecache(void);
 static void *befs_follow_link(struct dentry *, struct nameidata *);
 static void *befs_fast_follow_link(struct dentry *, struct nameidata *);
+static int befs_xattr_get(struct dentry *, const char *, void *, size_t, int);
 static int befs_utf2nls(struct super_block *sb, const char *in, int in_len,
  char **out, int *out_len);
 static int befs_nls2utf(struct super_block *sb, const char *in, int in_len,
@@ -74,6 +79,10 @@ static const struct inode_operations befs_dir_inode_operations = {
  .lookup = befs_lookup,
 };
 
+static const struct inode_operations befs_file_inode_operations = {
+ .getxattr = generic_getxattr,
+};
+
 static const struct address_space_operations befs_aops = {
  .readpage = befs_readpage,
  .bmap = befs_bmap,
@@ -90,6 +99,16 @@ static const struct inode_operations befs_symlink_inode_operations = {
  .put_link = kfree_put_link,
 };
 
+static const struct xattr_handler befs_xattr_handler = {
+ .prefix = "",
+ .get = befs_xattr_get,
+};
+
+static const struct xattr_handler *befs_xattr_handlers[] = {
+ &befs_xattr_handler,
+ NULL
+};
+
 /* 
  * Called by generic_file_read() to read a page of data
  * 
@@ -311,6 +330,35 @@ static void init_once(void *foo)
  inode_init_once(&bi->vfs_inode);
 }
 
+static void befs_getsmalldata(struct super_block *sb, befs_small_data *sd, struct befs_small_datamem *datamem)
+{
+ char *oft, *ioft;
+ struct befs_small_datamem *newdatamem;
+ struct befs_small_datamem *testdatamem;
+
+ ioft = (char*) sd;
+
+ INIT_LIST_HEAD(&datamem->list);
+
+ while(1){
+ newdatamem = kmalloc(sizeof(*newdatamem), GFP_KERNEL);
+ newdatamem->type=sd->type;
+ strcpy(newdatamem->name, sd->name);
+ oft = sd->name;
+ while(oft[0])oft++;
+ oft+=3; //padding
+ strcpy(newdatamem->value, oft);
+ INIT_LIST_HEAD(&newdatamem->list);
+ oft = oft+(sd->data_size);
+ while(!oft[0])oft++;
+ sd = oft;
+ list_add_tail(&(newdatamem->list), &(datamem->list));
+ if(oft-ioft > sb->s_blocksize-sizeof(befs_inode))
+ break;
+ }
+
+}
+
 static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 {
  struct buffer_head *bh = NULL;
@@ -411,7 +459,10 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
  inode->i_mapping->a_ops = &befs_aops;
 
  if (S_ISREG(inode->i_mode)) {
+ inode->i_op = &befs_file_inode_operations;
  inode->i_fop = &generic_ro_fops;
+ befs_dump_small_data(sb, raw_inode->small_data);
+ befs_getsmalldata(sb,raw_inode->small_data, &(befs_ino->datamem));
  } else if (S_ISDIR(inode->i_mode)) {
  inode->i_op = &befs_dir_inode_operations;
  inode->i_fop = &befs_dir_operations;
@@ -521,6 +572,42 @@ befs_fast_follow_link(struct dentry *dentry, struct nameidata *nd)
  return NULL;
 }
 
+static int
+befs_xattr_get(struct dentry *dentry, const char *name, 
+ void *buffer, size_t buffer_size, int type)
+{
+
+
+ struct befs_small_datamem *currentdatamem;
+ struct befs_small_datamem *datamem;
+ befs_inode_info *befs_ino = NULL;
+ int name_len, error;
+
+ if (name == NULL)
+ return -EINVAL;
+
+ name_len = strlen(name);
+ if(name_len > BEFS_ATTRIBUTE_LEN)
+ return -ERANGE;
+ error = -ENODATA;
+
+ befs_ino = BEFS_I(dentry->d_inode);
+ datamem=&(befs_ino->datamem);
+
+ list_for_each_entry(currentdatamem, &(datamem->list), list){
+ if(!strcmp(currentdatamem->name, name)){
+ if(buffer){
+ if(strlen(currentdatamem->value)<=buffer_size){
+ strcpy(buffer, currentdatamem->value);
+ error=strlen(currentdatamem->value);
+  } else  error=-ERANGE; 
+ }else error=strlen(currentdatamem->value);
+
+ }
+ }
+ return(error);
+}
+
 /*
  * UTF-8 to NLS charset  convert routine
  * 
@@ -846,6 +933,7 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
  if (befs_load_sb(sb, disk_sb) != BEFS_OK)
  goto unacquire_bh;
 
+ sb->s_xattr = befs_xattr_handlers;
  befs_dump_super_block(sb, disk_sb);
 
  brelse(bh);
