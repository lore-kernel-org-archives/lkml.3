Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbbA2CgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:36:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46956 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762144AbbA2CgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 072/139] md/raid56: Don't perform reads to support writes until stripe is ready.
Date: Wed, 28 Jan 2015 14:20:15 -0800
Message-Id: <1422483682-15393-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 67f455486d2ea20b2d94d6adf5b9b783d079e321 upstream.

If it is found that we need to pre-read some blocks before a write
can succeed, we normally set STRIPE_DELAYED and don't actually perform
the read until STRIPE_PREREAD_ACTIVE subsequently gets set.

However for a degraded RAID6 we currently perform the reads as soon
as we see that a write is pending.  This significantly hurts
throughput.

So:
 - when handle_stripe_dirtying find a block that it wants on a device
   that is failed, set STRIPE_DELAY, instead of doing nothing, and
 - when fetch_block detects that a read might be required to satisfy a
   write, only perform the read if STRIPE_PREREAD_ACTIVE is set,
   and if we would actually need to read something to complete the write.

This also helps RAID5, though less often as RAID5 supports a
read-modify-write cycle.  For RAID5 the read is performed too early
only if the write is not a full 4K aligned write (i.e. no an
R5_OVERWRITE).

Also clean up a couple of horrible bits of formatting.

Reported-by: Patrik Horník <patrik@dsl.sk>
Signed-off-by: NeilBrown <neilb@suse.de>
[ kamal: 3.13-stable preqreq for
  108cef3 "md/raid5: fetch_block must fetch all the blocks ..." ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid5.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 498ccf3..0b3fe80 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -296,9 +296,12 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 	BUG_ON(atomic_read(&conf->active_stripes)==0);
 	if (test_bit(STRIPE_HANDLE, &sh->state)) {
 		if (test_bit(STRIPE_DELAYED, &sh->state) &&
-		    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+		    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 			list_add_tail(&sh->lru, &conf->delayed_list);
-		else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
+			if (atomic_read(&conf->preread_active_stripes)
+			    < IO_THRESHOLD)
+				md_wakeup_thread(conf->mddev->thread);
+		} else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
 			   sh->bm_seq - conf->seq_write > 0)
 			list_add_tail(&sh->lru, &conf->bitmap_list);
 		else {
@@ -2895,8 +2898,11 @@ static int fetch_block(struct stripe_head *sh, struct stripe_head_state *s,
 	     (s->failed >= 1 && fdev[0]->toread) ||
 	     (s->failed >= 2 && fdev[1]->toread) ||
 	     (sh->raid_conf->level <= 5 && s->failed && fdev[0]->towrite &&
+	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) &&
 	      !test_bit(R5_OVERWRITE, &fdev[0]->flags)) ||
-	     (sh->raid_conf->level == 6 && s->failed && s->to_write))) {
+	     (sh->raid_conf->level == 6 && s->failed && s->to_write &&
+	      s->to_write < sh->raid_conf->raid_disks - 2 &&
+	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))))) {
 		/* we would like to get this block, possibly by computing it,
 		 * otherwise read it if the backing disk is insync
 		 */
@@ -3095,7 +3101,8 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 		    !test_bit(R5_LOCKED, &dev->flags) &&
 		    !(test_bit(R5_UPTODATE, &dev->flags) ||
 		    test_bit(R5_Wantcompute, &dev->flags))) {
-			if (test_bit(R5_Insync, &dev->flags)) rcw++;
+			if (test_bit(R5_Insync, &dev->flags))
+				rcw++;
 			else
 				rcw += 2*disks;
 		}
@@ -3116,10 +3123,10 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 			    !(test_bit(R5_UPTODATE, &dev->flags) ||
 			    test_bit(R5_Wantcompute, &dev->flags)) &&
 			    test_bit(R5_Insync, &dev->flags)) {
-				if (
-				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-					pr_debug("Read_old block "
-						 "%d for r-m-w\n", i);
+				if (test_bit(STRIPE_PREREAD_ACTIVE,
+					     &sh->state)) {
+					pr_debug("Read_old block %d for r-m-w\n",
+						 i);
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
 					s->locked++;
@@ -3142,10 +3149,9 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 			    !(test_bit(R5_UPTODATE, &dev->flags) ||
 			      test_bit(R5_Wantcompute, &dev->flags))) {
 				rcw++;
-				if (!test_bit(R5_Insync, &dev->flags))
-					continue; /* it's a failed drive */
-				if (
-				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+				if (test_bit(R5_Insync, &dev->flags) &&
+				    test_bit(STRIPE_PREREAD_ACTIVE,
+					     &sh->state)) {
 					pr_debug("Read_old block "
 						"%d for Reconstruct\n", i);
 					set_bit(R5_LOCKED, &dev->flags);
-- 
1.9.1

