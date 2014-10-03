Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbaJCXOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:14:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787AbaJCWNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:13:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anssi Hannula <anssi.hannula@iki.fi>, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.14 159/238] dm cache: fix race causing dirty blocks to be marked as clean
Date: Fri,  3 Oct 2014 14:31:14 -0700
Message-Id: <20141003212918.761283012@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anssi Hannula <anssi.hannula@iki.fi>

commit 40aa978eccec61347cd47b97c598df49acde8be5 upstream.

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
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-target.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -890,8 +890,8 @@ static void migration_success_pre_commit
 	struct cache *cache = mg->cache;
 
 	if (mg->writeback) {
-		cell_defer(cache, mg->old_ocell, false);
 		clear_dirty(cache, mg->old_oblock, mg->cblock);
+		cell_defer(cache, mg->old_ocell, false);
 		cleanup_migration(mg);
 		return;
 
@@ -946,13 +946,13 @@ static void migration_success_post_commi
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


