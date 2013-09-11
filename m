Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab3ILFk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:40:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22683 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab3ILFks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:40:48 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=nC4xcIb-7FUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=mGbztWbqtI8A:10 a=vpVRfoo1AAAA:8 a=VwQbUJbxAAAA:8 a=ASTB1Uf0AAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=0yVQzcu7H6MA:10 a=pDhNVk4yl4oA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042908.283625793@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Lyakas <alex.btrfs@zadarastorage.com>,
        Josef Bacik <jbacik@fusionio.com>
Subject: [096/251] Btrfs: fix lock leak when resuming snapshot deletion
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0096-Btrfs-fix-lock-leak-when-resuming-snapshot-deletion.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

[ Upstream commit fec386ac1428f9c0e672df952cbca5cebd4e4e2f ]

We aren't setting path->locks[level] when we resume a snapshot deletion which
means we won't unlock the buffer when we free the path.  This causes deadlocks
if we happen to re-allocate the block before we've evicted the extent buffer
from cache.  Thanks,

Cc: stable@vger.kernel.org
Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/btrfs/extent-tree.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6d7b589..dcfce2a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7007,6 +7007,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		while (1) {
 			btrfs_tree_lock(path->nodes[level]);
 			btrfs_set_lock_blocking(path->nodes[level]);
+			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 
 			ret = btrfs_lookup_extent_info(trans, root,
 						path->nodes[level]->start,
@@ -7023,6 +7024,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 				break;
 
 			btrfs_tree_unlock(path->nodes[level]);
+			path->locks[level] = 0;
 			WARN_ON(wc->refs[level] != 1);
 			level--;
 		}
-- 
1.7.10.4


