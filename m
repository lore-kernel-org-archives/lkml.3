Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaHTKiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 06:38:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14931 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHTKiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 06:38:19 -0400
X-AuditID: cbfee61b-f79f86d00000144c-df-53f47a9a8e82
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 2/3] f2fs: introduce need_do_checkpoint for
 readability
Date: Wed, 20 Aug 2014 18:37:35 +0800
Message-id: <008101cfbc62$d9d92fa0$8d8b8ee0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+6x/s59doT4S/VSP6wIw9H+pzc0A==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jQd1ZVV+CDV58ErJ4sn4Ws8WlRe4W
	l3fNYXNg9ti0qpPNY/eCz0wenzfJBTBHcdmkpOZklqUW6dslcGW83bqItWA3f8W6SeeZGhiv
	83QxcnJICJhIfPi8hgXCFpO4cG89WxcjF4eQwHRGifkTulggnB+MEn1LXoFVsQmoSCzv+M8E
	YosA2YcWXWYHsZkFPCQaO76zgtjCAsESa272gtWzCKhKnJ/7HczmFbCU2DD/FZQtKPFj8j0W
	iF4tic3bmlghbHmJzWveMkNcpCCx4+xrRohdehInFvZB7RKX2HjkFssERoFZSEbNQjJqFpJR
	s5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHMDPpHcwrmqwOMQowMGoxMPr0P45
	WIg1say4MvcQowQHs5IIr0/ul2Ah3pTEyqrUovz4otKc1OJDjNIcLErivAdbrQOFBNITS1Kz
	U1MLUotgskwcnFINjF4b1rk93CF7WLdiUeJyLuPdvR4y3q96nA847jZfzP9fkvvLnGtiLgvc
	P3zbkKXmHHThnu4dY+G5FdszdmwuX/w+N82By9RlrqXdVIvPz5vcV+wJ7+/S/m+dVlvnb+E5
	/cNH9hIN289NZSf5PN2Xl0mesV2uO8eXUV7RuiT9gc+cXZO2WZwrVmIpzkg01GIuKk4EAM+W
	UCpcAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduce need_do_checkpoint() to include numerous judgment condition
for readability.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/file.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 208f1a9..9c09a0f 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -110,6 +110,25 @@ static int get_parent_ino(struct inode *inode, nid_t *pino)
 	return 1;
 }
 
+static inline bool need_do_checkpoint(struct inode *inode)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	bool need_cp = false;
+
+	if (!S_ISREG(inode->i_mode) || inode->i_nlink != 1)
+		need_cp = true;
+	else if (file_wrong_pino(inode))
+		need_cp = true;
+	else if (!space_for_roll_forward(sbi))
+		need_cp = true;
+	else if (!is_checkpointed_node(sbi, F2FS_I(inode)->i_pino))
+		need_cp = true;
+	else if (F2FS_I(inode)->xattr_ver == cur_cp_version(F2FS_CKPT(sbi)))
+		need_cp = true;
+
+	return need_cp;
+}
+
 int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
@@ -154,23 +173,12 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	/* guarantee free sections for fsync */
 	f2fs_balance_fs(sbi);
 
-	down_read(&fi->i_sem);
-
 	/*
 	 * Both of fdatasync() and fsync() are able to be recovered from
 	 * sudden-power-off.
 	 */
-	if (!S_ISREG(inode->i_mode) || inode->i_nlink != 1)
-		need_cp = true;
-	else if (file_wrong_pino(inode))
-		need_cp = true;
-	else if (!space_for_roll_forward(sbi))
-		need_cp = true;
-	else if (!is_checkpointed_node(sbi, F2FS_I(inode)->i_pino))
-		need_cp = true;
-	else if (F2FS_I(inode)->xattr_ver == cur_cp_version(F2FS_CKPT(sbi)))
-		need_cp = true;
-
+	down_read(&fi->i_sem);
+	need_cp = need_do_checkpoint(inode);
 	up_read(&fi->i_sem);
 
 	if (need_cp) {
-- 
2.0.1.474.g72c7794


