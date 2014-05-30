Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030496AbaE3UH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:07:29 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:61316 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934246AbaE3UH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:07:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [RFC 19/32] fs/fat: convert to struct inode_time
Date: Fri, 30 May 2014 22:01:43 +0200
Message-Id: <1401480116-1973111-20-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:B/yvg6fjqeDp8r9GVcOUy2fcZGBY1Y9Jol+ztmF1u6/
 NCWXXRb9rA3qmENPM0R9E7Uz10DQ2JrZCjA0ZgDMd26eHI7aDJ
 yTrRwwmANR4eNMv454f4w3DtD4Fne0hkAFrG+8Ky+zVU24dVUf
 XI6EV0seECmsr7KrAremuOkS7lVtcDjMLIV3atkxXwhSDS16dV
 WgibTYT1jSlNgOxuq7Q4dZOYN4datsjLWoGwvP3QG6U/vcNJJ5
 oV/EALegFZKvfXDobb+wkAvgl+n6b3RVJcbiwS6ym7h9d5+plx
 KA/60vdyikuaU99Q7dng53Bsr/Bs9iMcN3cueDP2fQMITM/n/W
 lgn4t0foJSz0YmjgNQeWvwmjMBEGAX0iP9fxNtfRD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fat uses 7-bit year numbers for inode timestamps, which will work
for the next 93 years, but the VFS uses struct timespec for timestamps,
which is only good until 2038 on 32-bit CPUs.

This gets us one small step closer to lifting the VFS limit by using
struct inode_time in fat.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/dir.c         |  2 +-
 fs/fat/fat.h         |  6 +++---
 fs/fat/misc.c        |  4 ++--
 fs/fat/namei_msdos.c |  8 ++++----
 fs/fat/namei_vfat.c  | 10 +++++-----
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 3963ede..9a9a12d 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1127,7 +1127,7 @@ error:
 	return err;
 }
 
-int fat_alloc_new_dir(struct inode *dir, struct timespec *ts)
+int fat_alloc_new_dir(struct inode *dir, struct inode_time *ts)
 {
 	struct super_block *sb = dir->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 13b7202..70a32b4 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -307,7 +307,7 @@ extern int fat_scan_logstart(struct inode *dir, int i_logstart,
 			     struct fat_slot_info *sinfo);
 extern int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
 				struct msdos_dir_entry **de);
-extern int fat_alloc_new_dir(struct inode *dir, struct timespec *ts);
+extern int fat_alloc_new_dir(struct inode *dir, struct inode_time *ts);
 extern int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 			   struct fat_slot_info *sinfo);
 extern int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo);
@@ -407,9 +407,9 @@ void fat_msg(struct super_block *sb, const char *level, const char *fmt, ...);
 	 } while (0)
 extern int fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
-extern void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
+extern void fat_time_fat2unix(struct msdos_sb_info *sbi, struct inode_time *ts,
 			      __le16 __time, __le16 __date, u8 time_cs);
-extern void fat_time_unix2fat(struct msdos_sb_info *sbi, struct timespec *ts,
+extern void fat_time_unix2fat(struct msdos_sb_info *sbi, struct inode_time *ts,
 			      __le16 *time, __le16 *date, u8 *time_cs);
 extern int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs);
 
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 628e22a..8710e24 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -192,7 +192,7 @@ static time_t days_in_year[] = {
 };
 
 /* Convert a FAT time/date pair to a UNIX date (seconds since 1 1 70). */
-void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
+void fat_time_fat2unix(struct msdos_sb_info *sbi, struct inode_time *ts,
 		       __le16 __time, __le16 __date, u8 time_cs)
 {
 	u16 time = le16_to_cpu(__time), date = le16_to_cpu(__date);
@@ -230,7 +230,7 @@ void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
 }
 
 /* Convert linear UNIX date to a FAT time/date pair. */
-void fat_time_unix2fat(struct msdos_sb_info *sbi, struct timespec *ts,
+void fat_time_unix2fat(struct msdos_sb_info *sbi, struct inode_time *ts,
 		       __le16 *time, __le16 *date, u8 *time_cs)
 {
 	struct tm tm;
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index a783b0e..699aa3e 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -226,7 +226,7 @@ static struct dentry *msdos_lookup(struct inode *dir, struct dentry *dentry,
 /***** Creates a directory entry (name is already formatted). */
 static int msdos_add_entry(struct inode *dir, const unsigned char *name,
 			   int is_dir, int is_hid, int cluster,
-			   struct timespec *ts, struct fat_slot_info *sinfo)
+			   struct inode_time *ts, struct fat_slot_info *sinfo)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(dir->i_sb);
 	struct msdos_dir_entry de;
@@ -267,7 +267,7 @@ static int msdos_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	struct super_block *sb = dir->i_sb;
 	struct inode *inode = NULL;
 	struct fat_slot_info sinfo;
-	struct timespec ts;
+	struct inode_time ts;
 	unsigned char msdos_name[MSDOS_NAME];
 	int err, is_hid;
 
@@ -349,7 +349,7 @@ static int msdos_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct fat_slot_info sinfo;
 	struct inode *inode;
 	unsigned char msdos_name[MSDOS_NAME];
-	struct timespec ts;
+	struct inode_time ts;
 	int err, is_hid, cluster;
 
 	mutex_lock(&MSDOS_SB(sb)->s_lock);
@@ -437,7 +437,7 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 	struct msdos_dir_entry *dotdot_de;
 	struct inode *old_inode, *new_inode;
 	struct fat_slot_info old_sinfo, sinfo;
-	struct timespec ts;
+	struct inode_time ts;
 	loff_t new_i_pos;
 	int err, old_attrs, is_dir, update_dotdot, corrupt = 0;
 
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 6df8d3d..f31b0af 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -579,7 +579,7 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
 
 static int vfat_build_slots(struct inode *dir, const unsigned char *name,
 			    int len, int is_dir, int cluster,
-			    struct timespec *ts,
+			    struct inode_time *ts,
 			    struct msdos_dir_slot *slots, int *nr_slots)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(dir->i_sb);
@@ -655,7 +655,7 @@ out_free:
 }
 
 static int vfat_add_entry(struct inode *dir, struct qstr *qname, int is_dir,
-			  int cluster, struct timespec *ts,
+			  int cluster, struct inode_time *ts,
 			  struct fat_slot_info *sinfo)
 {
 	struct msdos_dir_slot *slots;
@@ -772,7 +772,7 @@ static int vfat_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	struct super_block *sb = dir->i_sb;
 	struct inode *inode;
 	struct fat_slot_info sinfo;
-	struct timespec ts;
+	struct inode_time ts;
 	int err;
 
 	mutex_lock(&MSDOS_SB(sb)->s_lock);
@@ -860,7 +860,7 @@ static int vfat_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct super_block *sb = dir->i_sb;
 	struct inode *inode;
 	struct fat_slot_info sinfo;
-	struct timespec ts;
+	struct inode_time ts;
 	int err, cluster;
 
 	mutex_lock(&MSDOS_SB(sb)->s_lock);
@@ -909,7 +909,7 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct msdos_dir_entry *dotdot_de;
 	struct inode *old_inode, *new_inode;
 	struct fat_slot_info old_sinfo, sinfo;
-	struct timespec ts;
+	struct inode_time ts;
 	loff_t new_i_pos;
 	int err, is_dir, update_dotdot, corrupt = 0;
 	struct super_block *sb = old_dir->i_sb;
-- 
1.8.3.2

