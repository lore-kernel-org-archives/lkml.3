Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaBGLmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:42:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41013 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbaBGLY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:24:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 43/88] dm space map common: make sure new space is used during extend
Date: Fri,  7 Feb 2014 11:22:40 +0000
Message-Id: <1391772205-22239-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/persistent-data/dm-space-map-common.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index ff3beed..79c02d9 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -244,6 +244,10 @@ int sm_ll_extend(struct ll_disk *ll, dm_block_t extra_blocks)
 		return -EINVAL;
 	}
 
+	/*
+	 * We need to set this before the dm_tm_new_block() call below.
+	 */
+	ll->nr_blocks = nr_blocks;
 	for (i = old_blocks; i < blocks; i++) {
 		struct dm_block *b;
 		struct disk_index_entry idx;
@@ -251,6 +255,7 @@ int sm_ll_extend(struct ll_disk *ll, dm_block_t extra_blocks)
 		r = dm_tm_new_block(ll->tm, &dm_sm_bitmap_validator, &b);
 		if (r < 0)
 			return r;
+
 		idx.blocknr = cpu_to_le64(dm_block_location(b));
 
 		r = dm_tm_unlock(ll->tm, b);
@@ -265,7 +270,6 @@ int sm_ll_extend(struct ll_disk *ll, dm_block_t extra_blocks)
 			return r;
 	}
 
-	ll->nr_blocks = nr_blocks;
 	return 0;
 }
 
-- 
1.8.3.2

