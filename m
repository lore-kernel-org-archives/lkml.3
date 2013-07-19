Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965852Ab3GSFbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:31:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965809Ab3GSF1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:27:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nagachandra P <nagachandra@gmail.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 58/72] ext4: dont allow ext4_free_blocks() to fail due to ENOMEM
Date: Thu, 18 Jul 2013 22:26:15 -0700
Message-Id: <20130719052603.830750716@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/mballoc.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4735,11 +4735,16 @@ do_more:
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


