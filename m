Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbbAFV21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:28:27 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:54826 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935AbbAFV1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:27:50 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com,
        lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com,
        david@fromorbit.com, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 44/45] mpage: make __mpage_writepage() honor cgroup writeback
Date: Tue,  6 Jan 2015 16:26:21 -0500
Message-Id: <1420579582-8516-45-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__mpage_writepage() is used to implement mpage_writepages() which in
turn is used for ->writepages() of various filesystems.  All writeback
logic is now updated to handle cgroup writeback and the block cgroup
to issue IOs for is encoded in writeback_control and can be retrieved
using wbc_blkcg_css(); however, __mpage_writepage() currently ignores
the blkcg indicated by wbc and issues all bio's without explicit blkcg
association.

This patch updates __mpage_writepage() so that the issued bio's are
associated with wbc_blkcg_css().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 fs/mpage.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/mpage.c b/fs/mpage.c
index 587c7ed..84921b2 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -595,6 +595,8 @@ page_is_mapped:
 
 alloc_new:
 	if (bio == NULL) {
+		struct cgroup_subsys_state *blkcg_css;
+
 		if (first_unmapped == blocks_per_page) {
 			if (!bdev_write_page(bdev, blocks[0] << (blkbits - 9),
 								page, wbc)) {
@@ -606,6 +608,10 @@ alloc_new:
 				bio_get_nr_vecs(bdev), GFP_NOFS|__GFP_HIGH);
 		if (bio == NULL)
 			goto confused;
+
+		blkcg_css = wbc_blkcg_css(wbc);
+		if (blkcg_css)
+			bio_associate_blkcg(bio, blkcg_css);
 	}
 
 	/*
-- 
2.1.0

