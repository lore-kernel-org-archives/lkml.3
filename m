Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbbASM3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:29:32 -0500
Received: from mx2.parallels.com ([199.115.105.18]:53554 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbbASM3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:29:31 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs: super: do not cacheline align s_{inode,dentry}_lru
Date: Mon, 19 Jan 2015 15:29:23 +0300
Message-ID: <1421670563-28228-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

super_block->s_{inode,dentry}_lru were made cacheline aligned, because
the list_lru struct had a spinlock and a list embedded to it and
therefore could be actively modified.

Today, struct list_lru is, in fact, read-only: the lists and locks live
in list_lru_node's, which list_lru points to. The list_lru_node struct
is already cacheline aligned by definition.

So let us drop the cacheline aligned annotation in order not to waste
space in struct super_block.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 include/linux/fs.h |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0bd9669ce91d..790e534adbc7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1309,12 +1309,9 @@ struct super_block {
 	struct workqueue_struct *s_dio_done_wq;
 	struct hlist_head s_pins;
 
-	/*
-	 * Keep the lru lists last in the structure so they always sit on their
-	 * own individual cachelines.
-	 */
-	struct list_lru		s_dentry_lru ____cacheline_aligned_in_smp;
-	struct list_lru		s_inode_lru ____cacheline_aligned_in_smp;
+	struct list_lru		s_dentry_lru;
+	struct list_lru		s_inode_lru;
+
 	struct rcu_head		rcu;
 
 	/*
-- 
1.7.10.4

