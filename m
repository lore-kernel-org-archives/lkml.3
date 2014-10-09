Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbaJIVFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:05:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58981 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbaJIVFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:05:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 133/163] md/raid1: Don't use next_resync to determine how far resync has progressed
Date: Thu,  9 Oct 2014 14:02:38 -0700
Message-Id: <1412888588-26755-134-git-send-email-kamal@canonical.com>
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

commit 235549605eb7f1c5a37cef8b09d12e6d412c5cd6 upstream.

next_resync is (approximately) the location for the next resync request.
However it does *not* reliably determine the earliest location
at which resync might be happening.
This is because resync requests can complete out of order, and
we only limit the number of current requests, not the distance
from the earliest pending request to the latest.

mddev->curr_resync_completed is a reliable indicator of the earliest
position at which resync could be happening.   It is updated less
frequently, but is actually reliable which is more important.

So use it to determine if a write request is before the region
being resynced and so safe from conflict.

This error can allow resync IO to interfere with normal IO which
could lead to data corruption. Hence: stable.

Fixes: 79ef3a8aa1cb1523cc231c9a90a278333c21f761
Signed-off-by: NeilBrown <neilb@suse.de>
[ kamal: backport to 3.13-stable: no bi_iter struct ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid1.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c85ac43..11d0bd8 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -877,12 +877,10 @@ static bool need_to_wait_for_sync(struct r1conf *conf, struct bio *bio)
 	if (conf->array_frozen || !bio)
 		wait = true;
 	else if (conf->barrier && bio_data_dir(bio) == WRITE) {
-		if (conf->next_resync < RESYNC_WINDOW_SECTORS)
-			wait = true;
-		else if ((conf->next_resync - RESYNC_WINDOW_SECTORS
-				>= bio_end_sector(bio)) ||
-			 (conf->next_resync + NEXT_NORMALIO_DISTANCE
-				<= bio->bi_sector))
+		if ((conf->mddev->curr_resync_completed
+		     >= bio_end_sector(bio)) ||
+		    (conf->next_resync + NEXT_NORMALIO_DISTANCE
+		     <= bio->bi_sector))
 			wait = false;
 		else
 			wait = true;
@@ -920,7 +918,7 @@ static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
 
 	if (bio && bio_data_dir(bio) == WRITE) {
 		if (bio->bi_sector >=
-		    conf->next_resync) {
+		    conf->mddev->curr_resync_completed) {
 			if (conf->start_next_window == MaxSector)
 				conf->start_next_window =
 					conf->next_resync +
-- 
1.9.1

