Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaHTLxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:53:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58997 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752600AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 066/104] ext4: Fix block zeroing when punching holes in indirect block files
Date: Wed, 20 Aug 2014 13:43:29 +0200
Message-Id: <c05e7dcf669e800e589e288cdadf331b649bdf1e.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 77ea2a4ba657a1ad4fb7c64bc5cdce84b8a132b6 upstream.

free_holes_block() passed local variable as a block pointer
to ext4_clear_blocks(). Thus ext4_clear_blocks() zeroed out this local
variable instead of proper place in inode / indirect block. We later
zero out proper place in inode / indirect block but don't dirty the
inode / buffer again which can lead to subtle issues (some changes e.g.
to inode can be lost).

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/indirect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index e6574d7b6642..c30cbe291e30 100644
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
2.0.4

