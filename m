Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaFWItH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:49:07 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55564 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Justin Maggard <jmaggard10@gmail.com>,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 008/111] btrfs: fix defrag 32-bit integer overflow
Date: Mon, 23 Jun 2014 10:30:43 +0200
Message-Id: <6e8451cbf0d2e90d8cabac10b47848e3aaf8aa4e.1403512280.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Justin Maggard <jmaggard10@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c41570c9d29764f797fa35490d72b7395a0105c3 upstream.

When defragging a very large file, the cluster variable can wrap its 32-bit
signed int type and become negative, which eventually gets passed to
btrfs_force_ra() as a very large unsigned long value.  On 32-bit platforms,
this eventually results in an Oops from the SLAB allocator.

Change the cluster and max_cluster signed int variables to unsigned long to
match the readahead functions.  This also allows the min() comparison in
btrfs_defrag_file() to work as intended.

Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 669eb53273c0..45301541349e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1014,7 +1014,7 @@ out:
 static int cluster_pages_for_defrag(struct inode *inode,
 				    struct page **pages,
 				    unsigned long start_index,
-				    int num_pages)
+				    unsigned long num_pages)
 {
 	unsigned long file_end;
 	u64 isize = i_size_read(inode);
@@ -1172,8 +1172,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 	int defrag_count = 0;
 	int compress_type = BTRFS_COMPRESS_ZLIB;
 	int extent_thresh = range->extent_thresh;
-	int max_cluster = (256 * 1024) >> PAGE_CACHE_SHIFT;
-	int cluster = max_cluster;
+	unsigned long max_cluster = (256 * 1024) >> PAGE_CACHE_SHIFT;
+	unsigned long cluster = max_cluster;
 	u64 new_align = ~((u64)128 * 1024 - 1);
 	struct page **pages = NULL;
 
-- 
2.0.0

