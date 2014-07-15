Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbaGOVbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:31:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53872 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959AbaGOVbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:31:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 001/198] btrfs: fix defrag 32-bit integer overflow
Date: Tue, 15 Jul 2014 14:27:51 -0700
Message-Id: <1405459868-15089-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Maggard <jmaggard10@gmail.com>

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
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/btrfs/ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9f831bb..043d6cd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1011,7 +1011,7 @@ out:
 static int cluster_pages_for_defrag(struct inode *inode,
 				    struct page **pages,
 				    unsigned long start_index,
-				    int num_pages)
+				    unsigned long num_pages)
 {
 	unsigned long file_end;
 	u64 isize = i_size_read(inode);
@@ -1169,8 +1169,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
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
1.9.1

