Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab3ENQiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:38:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757629Ab3ENQiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:38:10 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        hughd@google.com, lczerner@redhat.com
Subject: [PATCH v4 12/20] ext4: Call ext4_jbd2_file_inode() after zeroing block
Date: Tue, 14 May 2013 18:37:26 +0200
Message-Id: <1368549454-8930-13-git-send-email-lczerner@redhat.com>
In-Reply-To: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In data=ordered mode we should call ext4_jbd2_file_inode() so that crash
after the truncate transaction has committed does not expose stall data
in the tail of the block.

Thanks Jan Kara for pointing that out.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/inode.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 11c07e1..8187c3e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3680,8 +3680,11 @@ int ext4_block_zero_page_range(handle_t *handle,
 	err = 0;
 	if (ext4_should_journal_data(inode)) {
 		err = ext4_handle_dirty_metadata(handle, inode, bh);
-	} else
+	} else {
 		mark_buffer_dirty(bh);
+		if (ext4_test_inode_state(inode, EXT4_STATE_ORDERED_MODE))
+			err = ext4_jbd2_file_inode(handle, inode);
+	}
 
 unlock:
 	unlock_page(page);
-- 
1.7.7.6

