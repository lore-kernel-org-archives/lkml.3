Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaBJTrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:47:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35136 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385AbaBJTr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:47:27 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 041/124] dm space map common: make sure new space is used during extend
Date: Mon, 10 Feb 2014 11:39:41 -0800
Message-Id: <1392061264-28124-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 12c91a5c2d2a8e8cc40a9552313e1e7b0a2d9ee3 upstream.

When extending a low level space map we should update nr_blocks at
the start so the new space is used for the index entries.

Otherwise extend can fail, e.g.: sm_metadata_extend call sequence
that fails:
 -> sm_ll_extend
    -> dm_tm_new_block -> dm_sm_new_block -> sm_bootstrap_new_block
    => returns -ENOSPC because smm->begin == smm->ll.nr_blocks

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/persistent-data/dm-space-map-common.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index 3e7a88d..0d24037 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -245,6 +245,10 @@ int sm_ll_extend(struct ll_disk *ll, dm_block_t extra_blocks)
 		return -EINVAL;
 	}
 
+	/*
+	 * We need to set this before the dm_tm_new_block() call below.
+	 */
+	ll->nr_blocks = nr_blocks;
 	for (i = old_blocks; i < blocks; i++) {
 		struct dm_block *b;
 		struct disk_index_entry idx;
@@ -252,6 +256,7 @@ int sm_ll_extend(struct ll_disk *ll, dm_block_t extra_blocks)
 		r = dm_tm_new_block(ll->tm, &dm_sm_bitmap_validator, &b);
 		if (r < 0)
 			return r;
+
 		idx.blocknr = cpu_to_le64(dm_block_location(b));
 
 		r = dm_tm_unlock(ll->tm, b);
@@ -266,7 +271,6 @@ int sm_ll_extend(struct ll_disk *ll, dm_block_t extra_blocks)
 			return r;
 	}
 
-	ll->nr_blocks = nr_blocks;
 	return 0;
 }
 
-- 
1.8.3.2

