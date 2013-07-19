Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965780Ab3GSFf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:35:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965720Ab3GSF04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Schmidt <list.btrfs@jan-o-sch.net>,
        Josef Bacik <jbacik@fusionio.com>
Subject: [ 51/72] Btrfs: only do the tree_mod_log_free_eb if this is our last ref
Date: Thu, 18 Jul 2013 22:26:08 -0700
Message-Id: <20130719052603.346629617@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit 7fb7d76f96bfcbea25007d190ba828b18e13d29d upstream.

There is another bug in the tree mod log stuff in that we're calling
tree_mod_log_free_eb every single time a block is cow'ed.  The problem with this
is that if this block is shared by multiple snapshots we will call this multiple
times per block, so if we go to rewind the mod log for this block we'll BUG_ON()
in __tree_mod_log_rewind because we try to rewind a free twice.  We only want to
call tree_mod_log_free_eb if we are actually freeing the block.  With this patch
I no longer hit the panic in __tree_mod_log_rewind.  Thanks,

Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ctree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1089,7 +1089,8 @@ static noinline int __btrfs_cow_block(st
 		btrfs_set_node_ptr_generation(parent, parent_slot,
 					      trans->transid);
 		btrfs_mark_buffer_dirty(parent);
-		tree_mod_log_free_eb(root->fs_info, buf);
+		if (last_ref)
+			tree_mod_log_free_eb(root->fs_info, buf);
 		btrfs_free_tree_block(trans, root, buf, parent_start,
 				      last_ref);
 	}


