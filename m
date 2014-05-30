Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030482AbaE3UHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:07:24 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:53461 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934246AbaE3UHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:07:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org
Subject: [RFC 17/32] ubifs: convert to struct inode_time
Date: Fri, 30 May 2014 22:01:41 +0200
Message-Id: <1401480116-1973111-18-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ST9M1Va8oewAjecWDa3yBmv5iMA7iPdU8UFCmR6uJg0
 mK6EHd2B16C4BUQTp9m2g00wX+dJATNJDrNBlOmpnvb/6JJekx
 p/ZcmZ7W0k0qQkOsWlmUYF/D6peZGeuxM/t2IupIEtiXYUnq/Z
 cpexndw11TvY1hPYmmurRmOFJnnrtiYwqJuw2YLX8hgZhYkelA
 o8fQo6mWR0glVrFP8CJOEFYE4Y8iXNRwGOPZY3nemtlAFtjvsl
 T5aEOltChwFwnKr+6KUMPEDJLMYf8P11VrVq6fVRbhewcNTjey
 ZruR28/QiKNnSR954YIyfTqgu9MtRyWpniPQ6/DPv4UYP/iKnf
 Pyd0qU82hqfwM0eNNG++wi1VjROF7RhRpSBcqNK4a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ubifs uses 64-bit integers for inode timestamps, which will work
practicall forever, but the VFS uses struct timespec for timestamps,
which is only good until 2038 on 32-bit CPUs.

This gets us one small step closer to lifting the VFS limit by using
struct inode_time in ubifs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-mtd@lists.infradead.org
---
 fs/ubifs/dir.c  |  2 +-
 fs/ubifs/file.c | 16 ++++++++--------
 fs/ubifs/misc.h |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index ea41649..a551ecc 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -965,7 +965,7 @@ static int ubifs_rename(struct inode *old_dir, struct dentry *old_dentry,
 					.dirtied_ino = 3 };
 	struct ubifs_budget_req ino_req = { .dirtied_ino = 1,
 			.dirtied_ino_d = ALIGN(old_inode_ui->data_len, 8) };
-	struct timespec time;
+	struct inode_time time;
 	unsigned int uninitialized_var(saved_nlink);
 
 	/*
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index ebcf15f..55cd034 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1073,13 +1073,13 @@ static void do_attr_changes(struct inode *inode, const struct iattr *attr)
 	if (attr->ia_valid & ATTR_GID)
 		inode->i_gid = attr->ia_gid;
 	if (attr->ia_valid & ATTR_ATIME)
-		inode->i_atime = timespec_trunc(attr->ia_atime,
+		inode->i_atime = inode_time_trunc(attr->ia_atime,
 						inode->i_sb->s_time_gran);
 	if (attr->ia_valid & ATTR_MTIME)
-		inode->i_mtime = timespec_trunc(attr->ia_mtime,
+		inode->i_mtime = inode_time_trunc(attr->ia_mtime,
 						inode->i_sb->s_time_gran);
 	if (attr->ia_valid & ATTR_CTIME)
-		inode->i_ctime = timespec_trunc(attr->ia_ctime,
+		inode->i_ctime = inode_time_trunc(attr->ia_ctime,
 						inode->i_sb->s_time_gran);
 	if (attr->ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
@@ -1353,10 +1353,10 @@ out:
  * granularity, they are not updated. This is an optimization.
  */
 static inline int mctime_update_needed(const struct inode *inode,
-				       const struct timespec *now)
+				       const struct inode_time *now)
 {
-	if (!timespec_equal(&inode->i_mtime, now) ||
-	    !timespec_equal(&inode->i_ctime, now))
+	if (!inode_time_equal(&inode->i_mtime, now) ||
+	    !inode_time_equal(&inode->i_ctime, now))
 		return 1;
 	return 0;
 }
@@ -1371,7 +1371,7 @@ static inline int mctime_update_needed(const struct inode *inode,
  */
 static int update_mctime(struct inode *inode)
 {
-	struct timespec now = ubifs_current_time(inode);
+	struct inode_time now = ubifs_current_time(inode);
 	struct ubifs_inode *ui = ubifs_inode(inode);
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
 
@@ -1443,7 +1443,7 @@ static int ubifs_vm_page_mkwrite(struct vm_area_struct *vma,
 	struct page *page = vmf->page;
 	struct inode *inode = file_inode(vma->vm_file);
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
-	struct timespec now = ubifs_current_time(inode);
+	struct inode_time now = ubifs_current_time(inode);
 	struct ubifs_budget_req req = { .new_page = 1 };
 	int err, update_time;
 
diff --git a/fs/ubifs/misc.h b/fs/ubifs/misc.h
index ee7cb5e..ca0fcac 100644
--- a/fs/ubifs/misc.h
+++ b/fs/ubifs/misc.h
@@ -233,7 +233,7 @@ static inline void *ubifs_idx_key(const struct ubifs_info *c,
  * ubifs_current_time - round current time to time granularity.
  * @inode: inode
  */
-static inline struct timespec ubifs_current_time(struct inode *inode)
+static inline struct inode_time ubifs_current_time(struct inode *inode)
 {
 	return (inode->i_sb->s_time_gran < NSEC_PER_SEC) ?
 		current_fs_time(inode->i_sb) : CURRENT_TIME_SEC;
-- 
1.8.3.2

