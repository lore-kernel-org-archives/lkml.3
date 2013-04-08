Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935613Ab3DHJvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:51:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42743 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935594Ab3DHJvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fusionio.com>, Chris Mason <chris.mason@fusionio.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 034/102] Btrfs: don't drop path when printing out tree errors in scrub
Date: Mon,  8 Apr 2013 10:49:49 +0100
Message-Id: <1365414657-29191-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit d8fe29e9dea8d7d61fd140d8779326856478fc62 upstream.

A user reported a panic where we were panicing somewhere in
tree_backref_for_extent from scrub_print_warning.  He only captured the trace
but looking at scrub_print_warning we drop the path right before we mess with
the extent buffer to print out a bunch of stuff, which isn't right.  So fix this
by dropping the path after we use the eb if we need to.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/scrub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b223620..5aeffbe 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -385,7 +385,6 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 	eb = path->nodes[0];
 	ei = btrfs_item_ptr(eb, path->slots[0], struct btrfs_extent_item);
 	item_size = btrfs_item_size_nr(eb, path->slots[0]);
-	btrfs_release_path(path);
 
 	if (ret & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 		do {
@@ -401,7 +400,9 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 				ret < 0 ? -1 : ref_level,
 				ret < 0 ? -1 : ref_root);
 		} while (ret != 1);
+		btrfs_release_path(path);
 	} else {
+		btrfs_release_path(path);
 		swarn.path = path;
 		iterate_extent_inodes(fs_info, found_key.objectid,
 					extent_item_pos, 1,
-- 
1.8.1.2

