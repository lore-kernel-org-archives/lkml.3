Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762228AbbA2Cgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:36:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46964 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762210AbbA2Cg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:27 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 074/139] md/raid5: fetch_block must fetch all the blocks handle_stripe_dirtying wants.
Date: Wed, 28 Jan 2015 14:20:17 -0800
Message-Id: <1422483682-15393-75-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 108cef3aa41669610e1836fe638812dd067d72de upstream.

It is critical that fetch_block() and handle_stripe_dirtying()
are consistent in their analysis of what needs to be loaded.
Otherwise raid5 can wait forever for a block that won't be loaded.

Currently when writing to a RAID5 that is resyncing, to a location
beyond the resync offset, handle_stripe_dirtying chooses a
reconstruct-write cycle, but fetch_block() assumes a
read-modify-write, and a lockup can happen.

So treat that case just like RAID6, just as we do in
handle_stripe_dirtying.  RAID6 always does reconstruct-write.

This bug was introduced when the behaviour of handle_stripe_dirtying
was changed in 3.7, so the patch is suitable for any kernel since,
though it will need careful merging for some versions.

Fixes: a7854487cd7128a30a7f4f5259de9f67d5efb95f
Reported-by: Henry Cai <henryplusplus@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid5.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2c2a3e4..3782c2f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2900,8 +2900,11 @@ static int fetch_block(struct stripe_head *sh, struct stripe_head_state *s,
 	     (sh->raid_conf->level <= 5 && s->failed && fdev[0]->towrite &&
 	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) &&
 	      !test_bit(R5_OVERWRITE, &fdev[0]->flags)) ||
-	     (sh->raid_conf->level == 6 && s->failed && s->to_write &&
-	      s->to_write - s->non_overwrite < sh->raid_conf->raid_disks - 2 &&
+	     ((sh->raid_conf->level == 6 ||
+	       sh->sector >= sh->raid_conf->mddev->recovery_cp)
+	      && s->failed && s->to_write &&
+	      (s->to_write - s->non_overwrite <
+	       sh->raid_conf->raid_disks - sh->raid_conf->max_degraded) &&
 	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))))) {
 		/* we would like to get this block, possibly by computing it,
 		 * otherwise read it if the backing disk is insync
-- 
1.9.1

