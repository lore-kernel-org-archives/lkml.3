Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab3ILNqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:46:46 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:50942 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab3ILNqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:46:45 -0400
Subject: [PATCH] shmem: fix double memory uncharge on error path
To: Hugh Dickins <hughd@google.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 12 Sep 2013 17:46:41 +0400
Message-ID: <20130912134641.2306.24297.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes erroneous call of shmem_unacct_size() from error path.
Shmem inode will release that memory reservation in shmem_evict_inode().
So, if following call of alloc_file fails we'll free reservation twice.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/shmem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 8297623..ff08920 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2946,16 +2946,16 @@ struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags
 	this.len = strlen(name);
 	this.hash = 0; /* will go */
 	sb = shm_mnt->mnt_sb;
+	path.mnt = mntget(shm_mnt);
 	path.dentry = d_alloc_pseudo(sb, &this);
 	if (!path.dentry)
 		goto put_memory;
 	d_set_d_op(path.dentry, &anon_ops);
-	path.mnt = mntget(shm_mnt);
 
 	res = ERR_PTR(-ENOSPC);
 	inode = shmem_get_inode(sb, NULL, S_IFREG | S_IRWXUGO, 0, flags);
 	if (!inode)
-		goto put_dentry;
+		goto put_memory;
 
 	d_instantiate(path.dentry, inode);
 	inode->i_size = size;
@@ -2971,10 +2971,10 @@ struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags
 
 	return res;
 
-put_dentry:
-	path_put(&path);
 put_memory:
 	shmem_unacct_size(flags, size);
+put_dentry:
+	path_put(&path);
 	return res;
 }
 EXPORT_SYMBOL_GPL(shmem_file_setup);

