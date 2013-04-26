Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587Ab3DZI7C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:59:02 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:63625 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759515Ab3DZI67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:58:59 -0400
Message-ID: <517A4023.1090709@gmail.com>
Date: Fri, 26 Apr 2013 10:51:47 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] fsfreeze: use sb_start_write_killable instead of sb_start_write
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace sb_start_write with sb_start_write_killable where
possible.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/open.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 8c74100..d621d76 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -182,7 +182,9 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 	if (IS_APPEND(inode))
 		goto out_putf;
 
-	sb_start_write(inode->i_sb);
+	error = sb_start_write_killable(inode->i_sb);
+	if (error < 0)
+		return error;
 	error = locks_verify_truncate(inode, f.file, length);
 	if (!error)
 		error = security_path_truncate(&f.file->f_path);
@@ -273,7 +275,9 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (!file->f_op->fallocate)
 		return -EOPNOTSUPP;
 
-	sb_start_write(inode->i_sb);
+	ret = sb_start_write_killable(inode->i_sb);
+	if (ret < 0)
+		return ret;
 	ret = file->f_op->fallocate(file, mode, offset, len);
 	sb_end_write(inode->i_sb);
 	return ret;
-- 
1.7.3.4
