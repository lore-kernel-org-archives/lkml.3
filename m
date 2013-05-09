Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab3EIW04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:26:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab3EIW0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roman Mamedov <rm@romanrm.ru>, Josef Bacik <jbacik@fusionio.com>
Subject: [ 67/73] Btrfs: compare relevant parts of delayed tree refs
Date: Thu,  9 May 2013 15:25:57 -0700
Message-Id: <20130509222533.224063331@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit 41b0fc42800569f63e029549b75c4c9cb63f2dfd upstream.

A user reported a panic while running a balance.  What was happening was he was
relocating a block, which added the reference to the relocation tree.  Then
relocation would walk through the relocation tree and drop that reference and
free that block, and then it would walk down a snapshot which referenced the
same block and add another ref to the block.  The problem is this was all
happening in the same transaction, so the parent block was free'ed up when we
drop our reference which was immediately available for allocation, and then it
was used _again_ to add a reference for the same block from a different
snapshot.  This resulted in something like this in the delayed ref tree

add ref to 90234880, parent=2067398656, ref_root 1766, level 1
del ref to 90234880, parent=2067398656, ref_root 18446744073709551608, level 1
add ref to 90234880, parent=2067398656, ref_root 1767, level 1

as you can see the ref_root's don't match, because when we inc the ref we use
the header owner, which is the original tree the block belonged to, instead of
the data reloc tree.  Then when we remove the extent we use the reloc tree
objectid.  But none of this matters, since it is a shared reference which means
only the parent matters.  When the delayed ref stuff runs it adds all the
increments first, and then does all the drops, to make sure that we don't delete
the ref if we net a positive ref count.  But tree blocks aren't allowed to have
multiple refs from the same block, so this panics when it tries to add the
second ref.  We need the add and the drop to cancel each other out in memory so
we only do the final add.

So to fix this we need to adjust how the delayed refs are added to the tree.
Only the ref_root matters when it is a normal backref, and only the parent
matters when it is a shared backref.  So make our decision based on what ref
type we have.  This allows us to keep the ref_root in memory in case anybody
wants to use it for something else, and it allows the delayed refs to be merged
properly so we don't end up with this panic.

With this patch the users image no longer panics on mount, and it has a clean
fsck after a normal mount/umount cycle.  Thanks,

Reported-by: Roman Mamedov <rm@romanrm.ru>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/delayed-ref.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -40,16 +40,19 @@ struct kmem_cache *btrfs_delayed_extent_
  * compare two delayed tree backrefs with same bytenr and type
  */
 static int comp_tree_refs(struct btrfs_delayed_tree_ref *ref2,
-			  struct btrfs_delayed_tree_ref *ref1)
+			  struct btrfs_delayed_tree_ref *ref1, int type)
 {
-	if (ref1->root < ref2->root)
-		return -1;
-	if (ref1->root > ref2->root)
-		return 1;
-	if (ref1->parent < ref2->parent)
-		return -1;
-	if (ref1->parent > ref2->parent)
-		return 1;
+	if (type == BTRFS_TREE_BLOCK_REF_KEY) {
+		if (ref1->root < ref2->root)
+			return -1;
+		if (ref1->root > ref2->root)
+			return 1;
+	} else {
+		if (ref1->parent < ref2->parent)
+			return -1;
+		if (ref1->parent > ref2->parent)
+			return 1;
+	}
 	return 0;
 }
 
@@ -113,7 +116,8 @@ static int comp_entry(struct btrfs_delay
 	if (ref1->type == BTRFS_TREE_BLOCK_REF_KEY ||
 	    ref1->type == BTRFS_SHARED_BLOCK_REF_KEY) {
 		return comp_tree_refs(btrfs_delayed_node_to_tree_ref(ref2),
-				      btrfs_delayed_node_to_tree_ref(ref1));
+				      btrfs_delayed_node_to_tree_ref(ref1),
+				      ref1->type);
 	} else if (ref1->type == BTRFS_EXTENT_DATA_REF_KEY ||
 		   ref1->type == BTRFS_SHARED_DATA_REF_KEY) {
 		return comp_data_refs(btrfs_delayed_node_to_data_ref(ref2),


