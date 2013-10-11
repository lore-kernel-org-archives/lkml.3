Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab3JKThj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:37:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357Ab3JKThb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:37:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [ 47/48] Btrfs: change how we queue blocks for backref checking
Date: Fri, 11 Oct 2013 12:36:54 -0700
Message-Id: <20131011193642.335830800@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193637.253208688@linuxfoundation.org>
References: <20131011193637.253208688@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit b6c60c8018c4e9beb2f83fc82c09f9d033766571 upstream.

Previously we only added blocks to the list to have their backrefs checked if
the level of the block is right above the one we are searching for.  This is
because we want to make sure we don't add the entire path up to the root to the
lists to make sure we process things one at a time.  This assumes that if any
blocks in the path to the root are going to be not checked (shared in other
words) then they will be in the level right above the current block on up.  This
isn't quite right though since we can have blocks higher up the list that are
shared because they are attached to a reloc root.  But we won't add this block
to be checked and then later on we will BUG_ON(!upper->checked).  So instead
keep track of wether or not we've queued a block to be checked in this current
search, and if we haven't go ahead and queue it to be checked.  This patch fixed
the panic I was seeing where we BUG_ON(!upper->checked).  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -684,6 +684,7 @@ struct backref_node *build_backref_tree(
 	int cowonly;
 	int ret;
 	int err = 0;
+	bool need_check = true;
 
 	path1 = btrfs_alloc_path();
 	path2 = btrfs_alloc_path();
@@ -906,6 +907,7 @@ again:
 			cur->bytenr);
 
 		lower = cur;
+		need_check = true;
 		for (; level < BTRFS_MAX_LEVEL; level++) {
 			if (!path2->nodes[level]) {
 				BUG_ON(btrfs_root_bytenr(&root->root_item) !=
@@ -949,14 +951,12 @@ again:
 
 				/*
 				 * add the block to pending list if we
-				 * need check its backrefs. only block
-				 * at 'cur->level + 1' is added to the
-				 * tail of pending list. this guarantees
-				 * we check backrefs from lower level
-				 * blocks to upper level blocks.
+				 * need check its backrefs, we only do this once
+				 * while walking up a tree as we will catch
+				 * anything else later on.
 				 */
-				if (!upper->checked &&
-				    level == cur->level + 1) {
+				if (!upper->checked && need_check) {
+					need_check = false;
 					list_add_tail(&edge->list[UPPER],
 						      &list);
 				} else


