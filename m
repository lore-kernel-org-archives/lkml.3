Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbbALSXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:23:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57573 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbbALSGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 061/216] dm cache: dirty flag was mistakenly being cleared when promoting via overwrite
Date: Mon, 12 Jan 2015 18:02:58 +0000
Message-Id: <1421085933-32536-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 1e32134a5a404e80bfb47fad8a94e9bbfcbdacc5 upstream.

If the incoming bio is a WRITE and completely covers a block then we
don't bother to do any copying for a promotion operation.  Once this is
done the cache block and origin block will be different, so we need to
set it to 'dirty'.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-cache-target.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index e5bb12810ccc..e5308b8b4043 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -929,10 +929,14 @@ static void migration_success_post_commit(struct dm_cache_migration *mg)
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
2.1.4

