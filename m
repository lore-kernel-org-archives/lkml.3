Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbaBJTrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:47:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35048 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbaBJTqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:46:54 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 038/124] ext4: avoid clearing beyond i_blocks when truncating an inline data file
Date: Mon, 10 Feb 2014 11:39:38 -0800
Message-Id: <1392061264-28124-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 09c455aaa8f47a94d5bafaa23d58365768210507 upstream.

A missing cast means that when we are truncating a file which is less
than 60 bytes, we don't clear the correct area of memory, and in fact
we can end up truncating the next inode in the inode table, or worse
yet, some other kernel data structure.

Addresses-Coverity-Id: #751987

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/inline.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index f33fcb6..10816d2 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1817,9 +1817,11 @@ void ext4_inline_data_truncate(struct inode *inode, int *has_inline)
 		}
 
 		/* Clear the content within i_blocks. */
-		if (i_size < EXT4_MIN_INLINE_DATA_SIZE)
-			memset(ext4_raw_inode(&is.iloc)->i_block + i_size, 0,
-					EXT4_MIN_INLINE_DATA_SIZE - i_size);
+		if (i_size < EXT4_MIN_INLINE_DATA_SIZE) {
+			void *p = (void *) ext4_raw_inode(&is.iloc)->i_block;
+			memset(p + i_size, 0,
+			       EXT4_MIN_INLINE_DATA_SIZE - i_size);
+		}
 
 		EXT4_I(inode)->i_inline_size = i_size <
 					EXT4_MIN_INLINE_DATA_SIZE ?
-- 
1.8.3.2

