Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936289Ab3DKVJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:09:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26790 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935663Ab3DKUtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:10 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=G2QXo0J4P7IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=mGMshMEowx4A:10 a=vpVRfoo1AAAA:8 a=VwQbUJbxAAAA:8 a=zxVruq8Ywy3q7gflxNoA:9 a=0yVQzcu7H6MA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202605.140434271@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Josef Bacik <jbacik@fusionio.com>, Chris Mason <chris.mason@fusionio.com>
Subject: [ 115/171 ] Btrfs: dont drop path when printing out tree errors in scrub
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0115-Btrfs-don-t-drop-path-when-printing-out-tree-errors-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

[ Upstream commit d8fe29e9dea8d7d61fd140d8779326856478fc62 ]

A user reported a panic where we were panicing somewhere in
tree_backref_for_extent from scrub_print_warning.  He only captured the trace
but looking at scrub_print_warning we drop the path right before we mess with
the extent buffer to print out a bunch of stuff, which isn't right.  So fix this
by dropping the path after we use the eb if we need to.  Thanks,

Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/btrfs/scrub.c |    3 ++-
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
1.7.10.4


