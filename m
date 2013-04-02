Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024Ab3DBXJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:09:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933200Ab3DBWM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [ 058/124] Btrfs: dont drop path when printing out tree errors in scrub
Date: Tue,  2 Apr 2013 15:10:40 -0700
Message-Id: <20130402221110.927238911@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/scrub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -541,7 +541,6 @@ static void scrub_print_warning(const ch
 	eb = path->nodes[0];
 	ei = btrfs_item_ptr(eb, path->slots[0], struct btrfs_extent_item);
 	item_size = btrfs_item_size_nr(eb, path->slots[0]);
-	btrfs_release_path(path);
 
 	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 		do {
@@ -557,7 +556,9 @@ static void scrub_print_warning(const ch
 				ret < 0 ? -1 : ref_level,
 				ret < 0 ? -1 : ref_root);
 		} while (ret != 1);
+		btrfs_release_path(path);
 	} else {
+		btrfs_release_path(path);
 		swarn.path = path;
 		swarn.dev = dev;
 		iterate_extent_inodes(fs_info, found_key.objectid,


