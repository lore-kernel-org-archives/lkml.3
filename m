Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaBTV7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:59:17 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:33357 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288AbaBTV7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:59:16 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AscVAPx5BlNXQx0h/2dsb2JhbABZKIJewRsCAoEQF3SCUxMcIxiBAjeICQHNOheOZB2EIgSJRo5pAYpPh1WDOi8
Date: Thu, 20 Feb 2014 22:00:39 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: akpm <akpm@linux-foundation.org>, dhowells <dhowells@redhat.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH v2] afs: afs_alloc_inode: use kmem_cache_zalloc
Message-Id: <20140220220039.0a727f1bc423339d69ffca0a@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch calls zalloc for explicit zero fill and removes all memset 0.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/afs/super.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/afs/super.c b/fs/afs/super.c
index c486155..aff91ee 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -460,7 +460,6 @@ static void afs_i_init_once(void *_vnode)
 {
 	struct afs_vnode *vnode = _vnode;
 
-	memset(vnode, 0, sizeof(*vnode));
 	inode_init_once(&vnode->vfs_inode);
 	init_waitqueue_head(&vnode->update_waitq);
 	mutex_init(&vnode->permits_lock);
@@ -481,17 +480,12 @@ static struct inode *afs_alloc_inode(struct super_block *sb)
 {
 	struct afs_vnode *vnode;
 
-	vnode = kmem_cache_alloc(afs_inode_cachep, GFP_KERNEL);
+	vnode = kmem_cache_zalloc(afs_inode_cachep, GFP_KERNEL);
 	if (!vnode)
 		return NULL;
 
 	atomic_inc(&afs_count_active_inodes);
 
-	memset(&vnode->fid, 0, sizeof(vnode->fid));
-	memset(&vnode->status, 0, sizeof(vnode->status));
-
-	vnode->volume		= NULL;
-	vnode->update_cnt	= 0;
 	vnode->flags		= 1 << AFS_VNODE_UNSET;
 	vnode->cb_promised	= false;
 
-- 
1.8.1.4

