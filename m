Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbaGXK3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:29:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54565 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066AbaGXJqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:46:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 006/128] Btrfs: make sure there are not any read requests before stopping workers
Date: Thu, 24 Jul 2014 10:44:15 +0100
Message-Id: <1406195177-8656-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

commit de348ee022175401e77d7662b7ca6e231a94e3fd upstream.

In close_ctree(), after we have stopped all workers,there maybe still
some read requests(for example readahead) to submit and this *maybe* trigger
an oops that user reported before:

kernel BUG at fs/btrfs/async-thread.c:619!

By hacking codes, i can reproduce this problem with one cpu available.
We fix this potential problem by invalidating all btree inode pages before
stopping all workers.

Thanks to Miao for pointing out this problem.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/disk-io.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3ce443662607..9001c263bc79 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3554,6 +3554,11 @@ int close_ctree(struct btrfs_root *root)
 
 	btrfs_free_block_groups(fs_info);
 
+	/*
+	 * we must make sure there is not any read request to
+	 * submit after we stopping all workers.
+	 */
+	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 	btrfs_stop_all_workers(fs_info);
 
 	del_fs_roots(fs_info);
-- 
1.9.1

