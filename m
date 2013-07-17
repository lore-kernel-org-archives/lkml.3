Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934312Ab3GQWyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:54:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56447 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934229Ab3GQWyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:54:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 144/145] ext4: don't allow ext4_free_blocks() to fail due to ENOMEM
Date: Wed, 17 Jul 2013 15:47:56 -0700
Message-Id: <1374101277-7915-145-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit e7676a704ee0a1ef71a6b23760b5a8f6896cb1a1 upstream.

The filesystem should not be marked inconsistent if ext4_free_blocks()
is not able to allocate memory.  Unfortunately some callers (most
notably ext4_truncate) don't have a way to reflect an error back up to
the VFS.  And even if we did, most userspace applications won't deal
with most system calls returning ENOMEM anyway.

Reported-by: Nagachandra P <nagachandra@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/mballoc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 1206682..c8003a1 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4652,11 +4652,16 @@ do_more:
 		 * blocks being freed are metadata. these blocks shouldn't
 		 * be used until this transaction is committed
 		 */
+	retry:
 		new_entry = kmem_cache_alloc(ext4_free_data_cachep, GFP_NOFS);
 		if (!new_entry) {
-			ext4_mb_unload_buddy(&e4b);
-			err = -ENOMEM;
-			goto error_return;
+			/*
+			 * We use a retry loop because
+			 * ext4_free_blocks() is not allowed to fail.
+			 */
+			cond_resched();
+			congestion_wait(BLK_RW_ASYNC, HZ/50);
+			goto retry;
 		}
 		new_entry->efd_start_cluster = bit;
 		new_entry->efd_group = block_group;
-- 
1.8.1.2

