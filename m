Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab3H3HWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 03:22:50 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:55534 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab3H3HWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 03:22:48 -0400
From: Rui Xiang <rui.xiang@huawei.com>
To: Ian Kent <raven@themaw.net>
CC: <autofs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 1/2] autofs: fix the return value of autofs4_fill_super
Date: Fri, 30 Aug 2013 15:22:17 +0800
Message-ID: <1377847338-51032-1-git-send-email-rui.xiang@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While kzallocing sbi/ino fails, it should return -ENOMEM.

And it should return the err value from autofs_prepare_pipe.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
---
 fs/autofs4/inode.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index b104726..fe390ed 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -211,10 +211,11 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	int pipefd;
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
+	int ret = -EINVAL;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
-		goto fail_unlock;
+		return -ENOMEM;
 	DPRINTK("starting up, sbi = %p",sbi);
 
 	s->s_fs_info = sbi;
@@ -248,8 +249,10 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	 * Get the root inode and dentry, but defer checking for errors.
 	 */
 	ino = autofs4_new_ino(sbi);
-	if (!ino)
+	if (!ino) {
+		ret = -ENOMEM;
 		goto fail_free;
+	}
 	root_inode = autofs4_get_inode(s, S_IFDIR | 0755);
 	root = d_make_root(root_inode);
 	if (!root)
@@ -296,7 +299,8 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 		printk("autofs: could not open pipe file descriptor\n");
 		goto fail_dput;
 	}
-	if (autofs_prepare_pipe(pipe) < 0)
+	ret = autofs_prepare_pipe(pipe);
+	if (ret < 0)
 		goto fail_fput;
 	sbi->pipe = pipe;
 	sbi->pipefd = pipefd;
@@ -323,8 +327,7 @@ fail_ino:
 fail_free:
 	kfree(sbi);
 	s->s_fs_info = NULL;
-fail_unlock:
-	return -EINVAL;
+	return ret;
 }
 
 struct inode *autofs4_get_inode(struct super_block *sb, umode_t mode)
-- 
1.8.2.2


