Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab3EUD6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:58:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32269 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3EUD6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:58:18 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-07-519af0d9e7b3
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/3] f2fs: avoid RECLAIM_FS-ON-W: deadlock
Date: Tue, 21 May 2013 12:56:31 +0900
Message-id: <1369108593-880-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zA92bH2YFGqx9w2dxfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8azqRdYCq6KVhzb
	+o61gfG6UBcjJ4eEgIlEz9EWJghbTOLCvfVsXYxcHEICyxglutb9Z4Ep+tTXywKRmM4osf/V
	aXYIp41JYtrVtUAOBwebgLbE5v0GIA0iAswSC6aeZwSpYRaYwCjxf9F7sEnCAlYSc1ZfBbNZ
	BFQlNn1sZwexeQVcJfb/boLapiux+v9zsAUSArfZJB7OPcEM0SAg8W3yIRaQZRICshKbDjBD
	1EtKHFxxg2UCo+ACRoZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGCFBOGEH470D1ocYk4HG
	TWSWEk3OBwZxXkm8obGZkYWpiamxkbmlGWnCSuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcY
	mTg4pRoYvY8JcgmX8Z2xlcq3566WC9/VrqC45XbRrd3Lf0kfvOSw/YtyncuWllvRoSUrlRnW
	v25lLkjKlbu6x9fJjHXKgza5g38E/bwNFU+3ftNvuMR15u3PpGyzbU8m3Wxdm1idKHq+8/+h
	iW6JLl9Ob5189cLtfq1dDjJXS6utXndoGenwLNzYGGKtxFKckWioxVxUnAgAEDak91gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd2bH2YFGnw+wGVxfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtA2JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+
	IUFwPUYGaCBhHWPGs6kXWAquilYc2/qOtYHxulAXIyeHhICJxKe+XhYIW0ziwr31bF2MXBxC
	AtMZJfa/Os0O4bQxSUy7uhbI4eBgE9CW2LzfAKRBRIBZYsHU84wgNcwCExgl/i96DzZJWMBK
	Ys7qq2A2i4CqxKaP7ewgNq+Aq8T+301Q23QlVv9/zj6BkXsBI8MqRtHUguSC4qT0XCO94sTc
	4tK8dL3k/NxNjOAQfya9g3FVg8UhRgEORiUeXgHDWYFCrIllxZW5hxglOJiVRHi/NwOFeFMS
	K6tSi/Lji0pzUosPMSYDbZ/ILCWanA+Mv7ySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQn
	lqRmp6YWpBbBbGHi4JRqYFxu+skj5tSZM03SrKV+9ZHrdevtrx9aF1FYqWN929e8h0ng9fbd
	5kzynbV3flZ/dX8asznaVoipLjF/NrOeVZ84z6wtWmqL9E5VF1y8m7FffebfHR8auiX58wKk
	nD1Tni+fcGTCqnPCHXbf72zafDd+oddztj/L5Ti9eZhllqY7hlk9c9t8UYmlOCPRUIu5qDgR
	AL3WeWy1AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to avoid the following deadlock condition of which the reclaim
path can trigger f2fs_balance_fs again.

=================================
[ INFO: inconsistent lock state ]
---------------------------------
inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
kswapd0/41 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&sbi->gc_mutex){+.+.?.}, at: f2fs_balance_fs+0xe6/0x100 [f2fs]
{RECLAIM_FS-ON-W} state was registered at:
  [<ffffffff810aa5a9>] mark_held_locks+0xb9/0x140
  [<ffffffff810aae85>] lockdep_trace_alloc+0x85/0xf0
  [<ffffffff8113ab2c>] __alloc_pages_nodemask+0x7c/0x9b0
  [<ffffffff81175aa8>] alloc_pages_current+0xb8/0x180
  [<ffffffff811319cf>] __page_cache_alloc+0xaf/0xd0
  [<ffffffff8113225c>] find_or_create_page+0x4c/0xb0
  [<ffffffffa021359e>] find_data_page+0x14e/0x210 [f2fs]
  [<ffffffffa021161b>] f2fs_gc+0x9eb/0xd90 [f2fs]
  [<ffffffffa0218fae>] f2fs_balance_fs+0xee/0x100 [f2fs]
  [<ffffffffa020848c>] f2fs_setattr+0x6c/0x200 [f2fs]
  [<ffffffff811ae51b>] notify_change+0x1db/0x3a0
  [<ffffffff8118fbd0>] do_truncate+0x60/0xa0
  [<ffffffff8118fd95>] vfs_truncate+0x185/0x1b0
  [<ffffffff8118fe1c>] do_sys_truncate+0x5c/0xa0
  [<ffffffff8118ffee>] SyS_truncate+0xe/0x10
  [<ffffffff816e2b42>] system_call_fastpath+0x16/0x1b

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c  | 4 ++--
 fs/f2fs/inode.c | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index c320f7f..1644fff 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -199,7 +199,7 @@ struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
 	if (dn.data_blkaddr == NEW_ADDR)
 		return ERR_PTR(-EINVAL);
 
-	page = grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index, AOP_FLAG_NOFS);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
@@ -234,7 +234,7 @@ struct page *get_lock_data_page(struct inode *inode, pgoff_t index)
 	int err;
 
 repeat:
-	page = grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index, AOP_FLAG_NOFS);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 91ac7f9..a18946e 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -130,8 +130,7 @@ make_now:
 		inode->i_op = &f2fs_dir_inode_operations;
 		inode->i_fop = &f2fs_dir_operations;
 		inode->i_mapping->a_ops = &f2fs_dblock_aops;
-		mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER_MOVABLE |
-				__GFP_ZERO);
+		mapping_set_gfp_mask(inode->i_mapping, GFP_F2FS_ZERO);
 	} else if (S_ISLNK(inode->i_mode)) {
 		inode->i_op = &f2fs_symlink_inode_operations;
 		inode->i_mapping->a_ops = &f2fs_dblock_aops;
-- 
1.8.1.3.566.gaa39828

