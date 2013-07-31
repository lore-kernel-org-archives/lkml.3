Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109Ab3GaNil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:38:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47052 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759811Ab3GaNZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nagachandra P" <nagachandra@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.729223333@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [37/84] ext4: don't allow ext4_free_blocks() to fail due to ENOMEM
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/mballoc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4696,11 +4696,16 @@ do_more:
 		 * blocks being freed are metadata. these blocks shouldn't
 		 * be used until this transaction is committed
 		 */
+	retry:
 		new_entry = kmem_cache_alloc(ext4_free_ext_cachep, GFP_NOFS);
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
 		new_entry->start_cluster = bit;
 		new_entry->group  = block_group;

