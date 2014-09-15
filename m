Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbaIOWRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:17:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50993 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbaIOWRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:17:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 076/187] ext4: Fix block zeroing when punching holes in indirect block files
Date: Mon, 15 Sep 2014 15:08:06 -0700
Message-Id: <1410818997-9432-77-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 77ea2a4ba657a1ad4fb7c64bc5cdce84b8a132b6 upstream.

free_holes_block() passed local variable as a block pointer
to ext4_clear_blocks(). Thus ext4_clear_blocks() zeroed out this local
variable instead of proper place in inode / indirect block. We later
zero out proper place in inode / indirect block but don't dirty the
inode / buffer again which can lead to subtle issues (some changes e.g.
to inode can be lost).

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/indirect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index e6574d7..c30cbe2 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1345,8 +1345,8 @@ static int free_hole_blocks(handle_t *handle, struct inode *inode,
 		if (level == 0 ||
 		    (bh && all_zeroes((__le32 *)bh->b_data,
 				      (__le32 *)bh->b_data + addr_per_block))) {
-			ext4_free_data(handle, inode, parent_bh, &blk, &blk+1);
-			*i_data = 0;
+			ext4_free_data(handle, inode, parent_bh,
+				       i_data, i_data + 1);
 		}
 		brelse(bh);
 		bh = NULL;
-- 
1.9.1

