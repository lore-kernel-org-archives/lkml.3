Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab3KSKKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:10:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50033 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab3KSKKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:10:08 -0500
X-IronPort-AV: E=Sophos;i="4.93,728,1378828800"; 
   d="scan'208";a="9074464"
Message-ID: <528B3783.2040905@cn.fujitsu.com>
Date: Tue, 19 Nov 2013 18:03:47 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] f2fs: move the list_head initialization into the lock
 protection region
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/19 18:08:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/19 18:08:12,
	Serialize complete at 2013/11/19 18:08:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/checkpoint.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index f884589..1de70cc 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -511,8 +511,8 @@ void add_dirty_dir_inode(struct inode *inode)
 void remove_dirty_dir_inode(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-	struct list_head *head = &sbi->dir_inode_list;
-	struct list_head *this;
+
+	struct list_head *this, *head;
 
 	if (!S_ISDIR(inode->i_mode))
 		return;
@@ -523,6 +523,7 @@ void remove_dirty_dir_inode(struct inode *inode)
 		return;
 	}
 
+	head = &sbi->dir_inode_list;
 	list_for_each(this, head) {
 		struct dir_inode_entry *entry;
 		entry = list_entry(this, struct dir_inode_entry, list);
@@ -544,11 +545,13 @@ void remove_dirty_dir_inode(struct inode *inode)
 
 struct inode *check_dirty_dir_inode(struct f2fs_sb_info *sbi, nid_t ino)
 {
-	struct list_head *head = &sbi->dir_inode_list;
-	struct list_head *this;
+
+	struct list_head *this, *head;
 	struct inode *inode = NULL;
 
 	spin_lock(&sbi->dir_inode_lock);
+
+	head = &sbi->dir_inode_list;
 	list_for_each(this, head) {
 		struct dir_inode_entry *entry;
 		entry = list_entry(this, struct dir_inode_entry, list);
@@ -563,11 +566,13 @@ struct inode *check_dirty_dir_inode(struct f2fs_sb_info *sbi, nid_t ino)
 
 void sync_dirty_dir_inodes(struct f2fs_sb_info *sbi)
 {
-	struct list_head *head = &sbi->dir_inode_list;
+	struct list_head *head;
 	struct dir_inode_entry *entry;
 	struct inode *inode;
 retry:
 	spin_lock(&sbi->dir_inode_lock);
+
+	head = &sbi->dir_inode_list;
 	if (list_empty(head)) {
 		spin_unlock(&sbi->dir_inode_lock);
 		return;
-- 
1.7.7

