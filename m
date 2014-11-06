Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbaKFXRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:17:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58580 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaKFWji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:39:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 153/162] ext4: fix oops when loading block bitmap failed
Date: Thu,  6 Nov 2014 14:36:57 -0800
Message-Id: <1415313426-9622-154-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 599a9b77ab289d85c2d5c8607624efbe1f552b0f upstream.

When we fail to load block bitmap in __ext4_new_inode() we will
dereference NULL pointer in ext4_journal_get_write_access(). So check
for error from ext4_read_block_bitmap().

Coverity-id: 989065
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/ialloc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 158ddf6..a8d1a64 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -864,6 +864,10 @@ got:
 		struct buffer_head *block_bitmap_bh;
 
 		block_bitmap_bh = ext4_read_block_bitmap(sb, group);
+		if (!block_bitmap_bh) {
+			err = -EIO;
+			goto out;
+		}
 		BUFFER_TRACE(block_bitmap_bh, "get block bitmap access");
 		err = ext4_journal_get_write_access(handle, block_bitmap_bh);
 		if (err) {
-- 
1.9.1

