Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbaJIVFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:05:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59004 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbaJIVFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:05:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: majianpeng <majianpeng@gmail.com>, NeilBrown <neilb@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 132/163] md/raid1: make sure resync waits for conflicting writes to complete.
Date: Thu,  9 Oct 2014 14:02:37 -0700
Message-Id: <1412888588-26755-133-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 2f73d3c55d09ce60647b96ad2a9b539c95a530ee upstream.

The resync/recovery process for raid1 was recently changed
so that writes could happen in parallel with resync providing
they were in different regions of the device.

There is a problem though:  While a write request will always
wait for conflicting resync to complete, a resync request
will *not* always wait for conflicting writes to complete.

Two changes are needed to fix this:

1/ raise_barrier (which waits until it is safe to do resync)
   must wait until current_window_requests is zero
2/ wait_battier (which waits at the start of a new write request)
   must update current_window_requests if the request could
   possible conflict with a concurrent resync.

As concurrent writes and resync can lead to data loss,
this patch is suitable for -stable.

Fixes: 79ef3a8aa1cb1523cc231c9a90a278333c21f761
Cc: majianpeng <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
[ kamal: backport to 3.13-stable: no bi_iter struct ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid1.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 2414a79..c85ac43 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -847,10 +847,12 @@ static void raise_barrier(struct r1conf *conf)
 	 * C: next_resync + RESYNC_SECTORS > start_next_window, meaning
 	 *    next resync will reach to the window which normal bios are
 	 *    handling.
+	 * D: while there are any active requests in the current window.
 	 */
 	wait_event_lock_irq(conf->wait_barrier,
 			    !conf->array_frozen &&
 			    conf->barrier < RESYNC_DEPTH &&
+			    conf->current_window_requests == 0 &&
 			    (conf->start_next_window >=
 			     conf->next_resync + RESYNC_SECTORS),
 			    conf->resync_lock);
@@ -917,8 +919,8 @@ static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
 	}
 
 	if (bio && bio_data_dir(bio) == WRITE) {
-		if (conf->next_resync + NEXT_NORMALIO_DISTANCE
-		    <= bio->bi_sector) {
+		if (bio->bi_sector >=
+		    conf->next_resync) {
 			if (conf->start_next_window == MaxSector)
 				conf->start_next_window =
 					conf->next_resync +
-- 
1.9.1

