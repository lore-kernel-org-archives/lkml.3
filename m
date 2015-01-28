Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965029AbbA2Cgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:36:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46970 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762240AbbA2Cgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:36 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 060/139] dm cache: dirty flag was mistakenly being cleared when promoting via overwrite
Date: Wed, 28 Jan 2015 14:20:03 -0800
Message-Id: <1422483682-15393-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 1e32134a5a404e80bfb47fad8a94e9bbfcbdacc5 upstream.

If the incoming bio is a WRITE and completely covers a block then we
don't bother to do any copying for a promotion operation.  Once this is
done the cache block and origin block will be different, so we need to
set it to 'dirty'.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-cache-target.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index b943ef1..4a1a491 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -937,10 +937,14 @@ static void migration_success_post_commit(struct dm_cache_migration *mg)
 		}
 
 	} else {
-		clear_dirty(cache, mg->new_oblock, mg->cblock);
-		if (mg->requeue_holder)
+		if (mg->requeue_holder) {
+			clear_dirty(cache, mg->new_oblock, mg->cblock);
 			cell_defer(cache, mg->new_ocell, true);
-		else {
+		} else {
+			/*
+			 * The block was promoted via an overwrite, so it's dirty.
+			 */
+			set_dirty(cache, mg->new_oblock, mg->cblock);
 			bio_endio(mg->new_ocell->holder, 0);
 			cell_defer(cache, mg->new_ocell, false);
 		}
-- 
1.9.1

