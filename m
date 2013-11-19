Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab3KSKJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:09:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:11272 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab3KSKJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:09:39 -0500
X-IronPort-AV: E=Sophos;i="4.93,728,1378828800"; 
   d="scan'208";a="9074457"
Message-ID: <528B3766.4070202@cn.fujitsu.com>
Date: Tue, 19 Nov 2013 18:03:18 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] f2fs: convert remove_inode_page to void
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/19 18:07:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/19 18:07:43,
	Serialize complete at 2013/11/19 18:07:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/f2fs.h |    2 +-
 fs/f2fs/node.c |   12 ++++--------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 89dc750..94fbec3 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1027,7 +1027,7 @@ int get_dnode_of_data(struct dnode_of_data *, pgoff_t, int);
 int truncate_inode_blocks(struct inode *, pgoff_t);
 int truncate_xattr_node(struct inode *, struct page *);
 int wait_on_node_pages_writeback(struct f2fs_sb_info *, nid_t);
-int remove_inode_page(struct inode *);
+void remove_inode_page(struct inode *);
 struct page *new_inode_page(struct inode *, const struct qstr *);
 struct page *new_node_page(struct dnode_of_data *, unsigned int, struct page *);
 void ra_node_page(struct f2fs_sb_info *, nid_t);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 4ac4150..e7b6826 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -803,29 +803,25 @@ int truncate_xattr_node(struct inode *inode, struct page *page)
  * Caller should grab and release a mutex by calling mutex_lock_op() and
  * mutex_unlock_op().
  */
-int remove_inode_page(struct inode *inode)
+void remove_inode_page(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct page *page;
 	nid_t ino = inode->i_ino;
 	struct dnode_of_data dn;
-	int err;
 
 	page = get_node_page(sbi, ino);
 	if (IS_ERR(page))
-		return PTR_ERR(page);
+		return;
 
-	err = truncate_xattr_node(inode, page);
-	if (err) {
+	if (truncate_xattr_node(inode, page)) {
 		f2fs_put_page(page, 1);
-		return err;
+		return;
 	}
-
 	/* 0 is possible, after f2fs_new_inode() is failed */
 	f2fs_bug_on(inode->i_blocks != 0 && inode->i_blocks != 1);
 	set_new_dnode(&dn, inode, page, page, ino);
 	truncate_node(&dn);
-	return 0;
 }
 
 struct page *new_inode_page(struct inode *inode, const struct qstr *name)
-- 
1.7.7

