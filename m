Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbaC3XnG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:43:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289AbaC3XnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:01 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chris Mason" <clm@fb.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.339552275@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 060/200] Btrfs: setup inode location during
 btrfs_init_inode_locked
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@fb.com>

commit 90d3e592e99b8e374ead2b45148abf506493a959 upstream.

We have a race during inode init because the BTRFS_I(inode)->location is setup
after the inode hash table lock is dropped.  btrfs_find_actor uses the location
field, so our search might not find an existing inode in the hash table if we
race with the inode init code.

This commit changes things to setup the location field sooner.  Also the find actor now
uses only the location objectid to match inodes.  For inode hashing, we just
need a unique and stable test, it doesn't have to reflect the inode numbers we
show to userland.

Signed-off-by: Chris Mason <clm@fb.com>
[bwh: Backported to 3.2:
 - No hashval in btrfs_iget_locked()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/inode.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -56,7 +56,7 @@
 #include "inode-map.h"
 
 struct btrfs_iget_args {
-	u64 ino;
+	struct btrfs_key *location;
 	struct btrfs_root *root;
 };
 
@@ -3847,7 +3847,9 @@ again:
 static int btrfs_init_locked_inode(struct inode *inode, void *p)
 {
 	struct btrfs_iget_args *args = p;
-	inode->i_ino = args->ino;
+	inode->i_ino = args->location->objectid;
+	memcpy(&BTRFS_I(inode)->location, args->location,
+	       sizeof(*args->location));
 	BTRFS_I(inode)->root = args->root;
 	btrfs_set_inode_space_info(args->root, inode);
 	return 0;
@@ -3856,20 +3858,20 @@ static int btrfs_init_locked_inode(struc
 static int btrfs_find_actor(struct inode *inode, void *opaque)
 {
 	struct btrfs_iget_args *args = opaque;
-	return args->ino == btrfs_ino(inode) &&
+	return args->location->objectid == BTRFS_I(inode)->location.objectid &&
 		args->root == BTRFS_I(inode)->root;
 }
 
 static struct inode *btrfs_iget_locked(struct super_block *s,
-				       u64 objectid,
+				       struct btrfs_key *location,
 				       struct btrfs_root *root)
 {
 	struct inode *inode;
 	struct btrfs_iget_args args;
-	args.ino = objectid;
+	args.location = location;
 	args.root = root;
 
-	inode = iget5_locked(s, objectid, btrfs_find_actor,
+	inode = iget5_locked(s, location->objectid, btrfs_find_actor,
 			     btrfs_init_locked_inode,
 			     (void *)&args);
 	return inode;
@@ -3883,13 +3885,11 @@ struct inode *btrfs_iget(struct super_bl
 {
 	struct inode *inode;
 
-	inode = btrfs_iget_locked(s, location->objectid, root);
+	inode = btrfs_iget_locked(s, location, root);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
 	if (inode->i_state & I_NEW) {
-		BTRFS_I(inode)->root = root;
-		memcpy(&BTRFS_I(inode)->location, location, sizeof(*location));
 		btrfs_read_locked_inode(inode);
 		if (!is_bad_inode(inode)) {
 			inode_tree_add(inode);

