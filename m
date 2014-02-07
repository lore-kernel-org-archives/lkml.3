Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaBGM5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:57:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41835 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbaBGLtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:49:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 093/233] ext4: avoid clearing beyond i_blocks when truncating an inline data file
Date: Fri,  7 Feb 2014 11:45:12 +0000
Message-Id: <1391773652-25214-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 09c455aaa8f47a94d5bafaa23d58365768210507 upstream.

A missing cast means that when we are truncating a file which is less
than 60 bytes, we don't clear the correct area of memory, and in fact
we can end up truncating the next inode in the inode table, or worse
yet, some other kernel data structure.

Addresses-Coverity-Id: #751987

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/inline.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index d9ecbf1..46b3668 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1925,9 +1925,11 @@ void ext4_inline_data_truncate(struct inode *inode, int *has_inline)
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

