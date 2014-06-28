Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbaF1Sd4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:33:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551AbaF1Rum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:50:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.14 100/110] Btrfs: dont check nodes for extent items
Date: Sat, 28 Jun 2014 10:47:37 -0700
Message-Id: <20140628174551.351303918@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fb.com>

commit 8a56457f5f8fa7c2698ffae8545214c5b96a2cb5 upstream.

The backref code was looking at nodes as well as leaves when we tried to
populate extent item entries.  This is not good, and although we go away with it
for the most part because we'd skip where disk_bytenr != random_memory,
sometimes random_memory would match and suddenly boom.  This fixes that problem.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/backref.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -972,11 +972,12 @@ again:
 				goto out;
 		}
 		if (ref->count && ref->parent) {
-			if (extent_item_pos && !ref->inode_list) {
+			if (extent_item_pos && !ref->inode_list &&
+			    ref->level == 0) {
 				u32 bsz;
 				struct extent_buffer *eb;
 				bsz = btrfs_level_size(fs_info->extent_root,
-							info_level);
+							ref->level);
 				eb = read_tree_block(fs_info->extent_root,
 							   ref->parent, bsz, 0);
 				if (!eb || !extent_buffer_uptodate(eb)) {


