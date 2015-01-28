Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbbA2DNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:13:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46971 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762257AbbA2Cgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 073/139] md/raid5: avoid livelock caused by non-aligned writes.
Date: Wed, 28 Jan 2015 14:20:16 -0800
Message-Id: <1422483682-15393-74-git-send-email-kamal@canonical.com>
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

commit a40687ff73a5b14909d6aa522f7d778b158911c5 upstream.

If a stripe in a raid6 array received a write to each data block while
the array is degraded, and if any of these writes to a missing device
are not page-aligned, then a live-lock happens.

In this case the P and Q blocks need to be read so that the part of
the missing block which is *not* being updated by the write can be
constructed.  Due to a logic error, these blocks are not loaded, so
the update cannot proceed and the stripe is 'handled' repeatedly in an
infinite loop.

This bug is unlikely as most writes are page aligned.  However as it
can lead to a livelock it is suitable for -stable.  It was introduced
in 3.16.

Fixed: 67f455486d2ea20b2d94d6adf5b9b783d079e321
Signed-off-by: NeilBrown <neilb@suse.de>
[ kamal: 3.13-stable preqreq for
  108cef3 "md/raid5: fetch_block must fetch all the blocks ..." ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0b3fe80..2c2a3e4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2901,7 +2901,7 @@ static int fetch_block(struct stripe_head *sh, struct stripe_head_state *s,
 	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) &&
 	      !test_bit(R5_OVERWRITE, &fdev[0]->flags)) ||
 	     (sh->raid_conf->level == 6 && s->failed && s->to_write &&
-	      s->to_write < sh->raid_conf->raid_disks - 2 &&
+	      s->to_write - s->non_overwrite < sh->raid_conf->raid_disks - 2 &&
 	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))))) {
 		/* we would like to get this block, possibly by computing it,
 		 * otherwise read it if the backing disk is insync
-- 
1.9.1

