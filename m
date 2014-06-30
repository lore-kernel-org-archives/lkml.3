Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbaF3Mdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:33:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755312AbaF3McC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:32:02 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        Chris Mason <clm@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 166/181] Btrfs: make sure there are not any read requests before stopping workers
Date: Mon, 30 Jun 2014 13:53:07 +0200
Message-Id: <d8fefeeedf1a69bbe83d27fab0e0e8ed0ea331df.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/disk-io.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9f1d680558bb..8964b59fee92 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3622,6 +3622,11 @@ int close_ctree(struct btrfs_root *root)
 
 	btrfs_free_block_groups(fs_info);
 
+	/*
+	 * we must make sure there is not any read request to
+	 * submit after we stopping all workers.
+	 */
+	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 	btrfs_stop_all_workers(fs_info);
 
 	del_fs_roots(fs_info);
-- 
2.0.0

