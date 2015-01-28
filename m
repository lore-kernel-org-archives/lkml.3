Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965610AbbA1Eny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:43:54 -0500
Received: from mail.kernel.org ([198.145.29.136]:40423 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964965AbbA1EXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:23:42 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 116/177] ext4: fix oops when loading block bitmap failed
Date: Wed, 28 Jan 2015 12:09:34 +0800
Message-Id: <1422418236-12852-207-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 599a9b77ab289d85c2d5c8607624efbe1f552b0f upstream.

When we fail to load block bitmap in __ext4_new_inode() we will
dereference NULL pointer in ext4_journal_get_write_access(). So check
for error from ext4_read_block_bitmap().

Coverity-id: 989065
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/ext4/ialloc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 75c4f36..97ca4b6 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -725,6 +725,10 @@ got:
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

