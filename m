Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3LRCPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 21:15:50 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:39893 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3LRCPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 21:15:48 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: <hui.geng@huawei.com>, Wang Guoli <andy.wangguoli@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] jffs2: unlock f->sem on error in jffs2_new_inode()
Date: Wed, 18 Dec 2013 10:14:54 +0800
Message-ID: <1387332894-33977-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Guoli <andy.wangguoli@huawei.com>

If jffs2_new_inode() succeeds, it returns with f->sem held, and
the caller is responsible for releasing the lock. If it fails,
it still returns with the lock held, but the caller won't release
the lock, which will lead to deadlock.

Fix it by releasing the lock in jffs2_new_inode() on error.

Cc: <stable@vger.kernel.org> # 2.6.34+
Signed-off-by: Wang Guoli <andy.wangguoli@huawei.com>
---
 fs/jffs2/fs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 09b3ed4..2b91675 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -456,12 +456,14 @@ struct inode *jffs2_new_inode (struct inode *dir_i, umode_t mode, struct jffs2_r
 	   The umask is only applied if there's no default ACL */
 	ret = jffs2_init_acl_pre(dir_i, inode, &mode);
 	if (ret) {
-	    make_bad_inode(inode);
-	    iput(inode);
-	    return ERR_PTR(ret);
+		mutex_unlock(&f->sem);
+		make_bad_inode(inode);
+		iput(inode);
+		return ERR_PTR(ret);
 	}
 	ret = jffs2_do_new_inode (c, f, mode, ri);
 	if (ret) {
+		mutex_unlock(&f->sem);
 		make_bad_inode(inode);
 		iput(inode);
 		return ERR_PTR(ret);
@@ -478,6 +480,7 @@ struct inode *jffs2_new_inode (struct inode *dir_i, umode_t mode, struct jffs2_r
 	inode->i_size = 0;
 
 	if (insert_inode_locked(inode) < 0) {
+		mutex_unlock(&f->sem);
 		make_bad_inode(inode);
 		iput(inode);
 		return ERR_PTR(-EINVAL);
-- 
1.8.4

