Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab3ERDTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:19:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758584Ab3ERDAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:09 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Gxp69Bc55fYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=DJ1we4y0EbAA:10 a=vpVRfoo1AAAA:8 a=VwQbUJbxAAAA:8 a=HsRkr8XvAAAA:8 a=LVg6W_3aZdhOP0SbT2sA:9 a=0yVQzcu7H6MA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021702.909876367@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:18:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Roman Mamedov <rm@romanrm.ru>, Josef Bacik <jbacik@fusionio.com>
Subject: [ 133/136 ] Btrfs: compare relevant parts of delayed tree refs
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0133-Btrfs-compare-relevant-parts-of-delayed-tree-refs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

[ Upstream commit 41b0fc42800569f63e029549b75c4c9cb63f2dfd ]

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

Cc: stable@vger.kernel.org
Reported-by: Roman Mamedov <rm@romanrm.ru>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/btrfs/delayed-ref.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index ae94117..105b265 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -36,16 +36,19 @@
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
 
@@ -109,7 +112,8 @@ static int comp_entry(struct btrfs_delayed_ref_node *ref2,
 	if (ref1->type == BTRFS_TREE_BLOCK_REF_KEY ||
 	    ref1->type == BTRFS_SHARED_BLOCK_REF_KEY) {
 		return comp_tree_refs(btrfs_delayed_node_to_tree_ref(ref2),
-				      btrfs_delayed_node_to_tree_ref(ref1));
+				      btrfs_delayed_node_to_tree_ref(ref1),
+				      ref1->type);
 	} else if (ref1->type == BTRFS_EXTENT_DATA_REF_KEY ||
 		   ref1->type == BTRFS_SHARED_DATA_REF_KEY) {
 		return comp_data_refs(btrfs_delayed_node_to_data_ref(ref2),
-- 
1.7.10.4


