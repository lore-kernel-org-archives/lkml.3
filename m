Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaBTVOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:14:50 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:19570 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286AbaBTVOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:14:49 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AscVAPxuBlNXQx0h/2dsb2JhbABZKIJewRoCAoEQF3SCUxMcIxiBAjeICQHNUReOZB2EIgSJRo5pAYpPh1WDOi8
Date: Thu, 20 Feb 2014 21:16:12 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: dhowells <dhowells@redhat.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] afs: afs_alloc_inode: use kmem_cache_zalloc
Message-Id: <20140220211612.506074a7fd876e47130a8c5c@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

afs_vnode is currently cleared with 2 memsets after allocation and 
1 in constructor (afs_i_init_once).
	-This patch calls zalloc for explicit zero fill.
	-Fix some typos.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/afs/super.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/afs/super.c b/fs/afs/super.c
index c486155..e1fc569 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -76,7 +76,7 @@ static const match_table_t afs_options_list = {
 };
 
 /*
- * initialise the filesystem
+ * Initialize the filesystem
  */
 int __init afs_fs_init(void)
 {
@@ -448,19 +448,19 @@ error:
 static void afs_kill_super(struct super_block *sb)
 {
 	struct afs_super_info *as = sb->s_fs_info;
+
 	kill_anon_super(sb);
 	afs_put_volume(as->volume);
 	kfree(as);
 }
 
 /*
- * initialise an inode cache slab element prior to any use
+ * Initialize an inode cache slab element prior to any use
  */
 static void afs_i_init_once(void *_vnode)
 {
 	struct afs_vnode *vnode = _vnode;
 
-	memset(vnode, 0, sizeof(*vnode));
 	inode_init_once(&vnode->vfs_inode);
 	init_waitqueue_head(&vnode->update_waitq);
 	mutex_init(&vnode->permits_lock);
@@ -481,15 +481,12 @@ static struct inode *afs_alloc_inode(struct super_block *sb)
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
 	vnode->volume		= NULL;
 	vnode->update_cnt	= 0;
 	vnode->flags		= 1 << AFS_VNODE_UNSET;
@@ -503,6 +500,7 @@ static void afs_i_callback(struct rcu_head *head)
 {
 	struct inode *inode = container_of(head, struct inode, i_rcu);
 	struct afs_vnode *vnode = AFS_FS_I(inode);
+
 	kmem_cache_free(afs_inode_cachep, vnode);
 }
 
-- 
1.8.1.4

