Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaJEDC4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 23:02:56 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:49205 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaJEDCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 23:02:54 -0400
Date: Sat, 4 Oct 2014 23:00:42 -0400
From: John de la Garza <john@jjdev.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: use kfree_rcu instead of i_callback
Message-ID: <20141005030040.GA830@vega.jjdev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the callback is doing nothing more than calling kfree() we can
use kfree_rcu() instead of having to use a callback.

Signed-off-by: John de la Garza <john@jjdev.com>
---
 fs/inode.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 26753ba..51deccd 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -250,12 +250,6 @@ void __destroy_inode(struct inode *inode)
 }
 EXPORT_SYMBOL(__destroy_inode);
 
-static void i_callback(struct rcu_head *head)
-{
-	struct inode *inode = container_of(head, struct inode, i_rcu);
-	kmem_cache_free(inode_cachep, inode);
-}
-
 static void destroy_inode(struct inode *inode)
 {
 	BUG_ON(!list_empty(&inode->i_lru));
@@ -263,7 +257,7 @@ static void destroy_inode(struct inode *inode)
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
 	else
-		call_rcu(&inode->i_rcu, i_callback);
+		kfree(inode, i_rcu);
 }
 
 /**
-- 
2.1.0

