Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab3ATJY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 04:24:56 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:34768 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab3ATJYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 04:24:54 -0500
Date: Sun, 20 Jan 2013 10:24:49 +0100
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH]xfs: Fix xfs_swap_extents() after removal of
 xfs_flushinval_pages()
Message-ID: <20130120102449.397b3f8b@googlemail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Torsten Kaiser <just.for.lkml@googlemail.com>

Commit fb59581404ab7ec5075299065c22cb211a9262a9 removed
xfs_flushinval_pages() and changed its callers to use
filemap_write_and_wait() and  truncate_pagecache_range() directly.

But in xfs_swap_extents() this change accidental switched the argument
for 'tip' to 'ip'. This patch switches it back to 'tip'

Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>

--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -246,10 +246,10 @@ xfs_swap_extents(
 		goto out_unlock;
 	}
 
-	error = -filemap_write_and_wait(VFS_I(ip)->i_mapping);
+	error = -filemap_write_and_wait(VFS_I(tip)->i_mapping);
 	if (error)
 		goto out_unlock;
-	truncate_pagecache_range(VFS_I(ip), 0, -1);
+	truncate_pagecache_range(VFS_I(tip), 0, -1);
 
 	/* Verify O_DIRECT for ftmp */
 	if (VN_CACHED(VFS_I(tip)) != 0) {
