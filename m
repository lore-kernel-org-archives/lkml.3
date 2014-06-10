Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbaFJTtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:49:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35065 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbaFJTtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:49:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Snitzer <snitzer@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 123/160] dm cache: fix writethrough mode quiescing in cache_map
Date: Tue, 10 Jun 2014 12:46:03 -0700
Message-Id: <1402429600-20477-124-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 131cd131a9ff63d4b84f3fe15073a2984ac30066 upstream.

Commit 2ee57d58735 ("dm cache: add passthrough mode") inadvertently
removed the deferred set reference that was taken in cache_map()'s
writethrough mode support.  Restore taking this reference.

This issue was found with code inspection.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-cache-target.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 0826650..1d30f65 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2495,6 +2495,7 @@ static int cache_map(struct dm_target *ti, struct bio *bio)
 
 		} else {
 			inc_hit_counter(cache, bio);
+			pb->all_io_entry = dm_deferred_entry_inc(cache->all_io_ds);
 
 			if (bio_data_dir(bio) == WRITE && writethrough_mode(&cache->features) &&
 			    !is_dirty(cache, lookup_result.cblock))
-- 
1.9.1

