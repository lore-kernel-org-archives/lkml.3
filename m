Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbaF1Sb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:31:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbaF1Ruu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:50:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.14 094/110] Btrfs: make sure there are not any read requests before stopping workers
Date: Sat, 28 Jun 2014 10:47:31 -0700
Message-Id: <20140628174551.052604206@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/disk-io.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3598,6 +3598,11 @@ int close_ctree(struct btrfs_root *root)
 
 	btrfs_free_block_groups(fs_info);
 
+	/*
+	 * we must make sure there is not any read request to
+	 * submit after we stopping all workers.
+	 */
+	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 	btrfs_stop_all_workers(fs_info);
 
 	free_root_pointers(fs_info, 1);


