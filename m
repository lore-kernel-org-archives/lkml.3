Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934985AbaBDVTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:19:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934558AbaBDVMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Mason <clm@fb.com>
Subject: [PATCH 3.13 137/140] Btrfs: setup inode location during btrfs_init_inode_locked
Date: Tue,  4 Feb 2014 13:12:04 -0800
Message-Id: <20140204211040.888042515@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -60,7 +60,7 @@
 #include "hash.h"
 
 struct btrfs_iget_args {
-	u64 ino;
+	struct btrfs_key *location;
 	struct btrfs_root *root;
 };
 
@@ -4818,7 +4818,9 @@ again:
 static int btrfs_init_locked_inode(struct inode *inode, void *p)
 {
 	struct btrfs_iget_args *args = p;
-	inode->i_ino = args->ino;
+	inode->i_ino = args->location->objectid;
+	memcpy(&BTRFS_I(inode)->location, args->location,
+	       sizeof(*args->location));
 	BTRFS_I(inode)->root = args->root;
 	return 0;
 }
@@ -4826,19 +4828,19 @@ static int btrfs_init_locked_inode(struc
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
-	unsigned long hashval = btrfs_inode_hash(objectid, root);
+	unsigned long hashval = btrfs_inode_hash(location->objectid, root);
 
-	args.ino = objectid;
+	args.location = location;
 	args.root = root;
 
 	inode = iget5_locked(s, hashval, btrfs_find_actor,
@@ -4855,13 +4857,11 @@ struct inode *btrfs_iget(struct super_bl
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


