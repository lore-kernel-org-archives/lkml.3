Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbaIEATo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 20:19:44 -0400
Received: from webmail.tpnet.fi ([62.106.63.33]:35566 "EHLO webmail.tpnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755692AbaIEATn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 20:19:43 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2014 20:19:43 EDT
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] dm cache: fix race causing dirty blocks to be marked as clean
Date: Fri,  5 Sep 2014 03:11:28 +0300
Message-Id: <1409875888-1255-1-git-send-email-anssi.hannula@iki.fi>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <53F10F80.6080204@iki.fi>
References: <53F10F80.6080204@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a writeback or a promotion of a block is completed, the cell of
that block is removed from the prison, the block is marked as clean, and
the clear_dirty() callback of the cache policy is called.

Unfortunately, performing those actions in this order allows an incoming
new write bio for that block to come in before clearing the dirty status
is completed and therefore possibly causing one of these two scenarios:

Scenario A:

Thread 1                      Thread 2
cell_defer()                  .
- cell removed from prison    .
- detained bios queued        .
.                             incoming write bio
.                             remapped to cache
.                             set_dirty() called,
.                               but block already dirty
.                               => it does nothing
clear_dirty()                 .
- block marked clean          .
- policy clear_dirty() called .

Result: Block is marked clean even though it is actually dirty. No
writeback will occur.

Scenario B:

Thread 1                      Thread 2
cell_defer()                  .
- cell removed from prison    .
- detained bios queued        .
clear_dirty()                 .
- block marked clean          .
.                             incoming write bio
.                             remapped to cache
.                             set_dirty() called
.                             - block marked dirty
.                             - policy set_dirty() called
- policy clear_dirty() called .

Result: Block is properly marked as dirty, but policy thinks it is clean
and therefore never asks us to writeback it.
This case is visible in "dmsetup status" dirty block count (which
normally decreases to 0 on a quiet device).

Fix these issues by calling clear_dirty() before calling cell_defer().
Incoming bios for that block will then be detained in the cell and
released only after clear_dirty() has completed, so the race will not
occur.

Found by inspecting the code after noticing spurious dirty counts
(scenario B).

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Cc: Joe Thornber <ejt@redhat.com>
Cc: stable@vger.kernel.org
---

> Unfortunately it seems there is some other potentially more serious bug
> still in there...

After looking through the code that indeed seems to be the case, as
explained above.

Unless I'm missing something?

I can't say with 100% certainty if this fixes the spurious counts I saw
since those took quite a long time (1-2 weeks?) to appear and the load
of that system is somewhat irregular.


 drivers/md/dm-cache-target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 1af40ee209e2..7130505c2425 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -895,8 +895,8 @@ static void migration_success_pre_commit(struct dm_cache_migration *mg)
 	struct cache *cache = mg->cache;
 
 	if (mg->writeback) {
-		cell_defer(cache, mg->old_ocell, false);
 		clear_dirty(cache, mg->old_oblock, mg->cblock);
+		cell_defer(cache, mg->old_ocell, false);
 		cleanup_migration(mg);
 		return;
 
@@ -951,13 +951,13 @@ static void migration_success_post_commit(struct dm_cache_migration *mg)
 		}
 
 	} else {
+		clear_dirty(cache, mg->new_oblock, mg->cblock);
 		if (mg->requeue_holder)
 			cell_defer(cache, mg->new_ocell, true);
 		else {
 			bio_endio(mg->new_ocell->holder, 0);
 			cell_defer(cache, mg->new_ocell, false);
 		}
-		clear_dirty(cache, mg->new_oblock, mg->cblock);
 		cleanup_migration(mg);
 	}
 }
-- 
1.8.4.5

