Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113AbaJCX22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:28:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402AbaJCWD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 3.16 332/357] md/raid1: Dont use next_resync to determine how far resync has progressed
Date: Fri,  3 Oct 2014 14:31:58 -0700
Message-Id: <20141003212943.432448674@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -875,12 +875,10 @@ static bool need_to_wait_for_sync(struct
 	if (conf->array_frozen || !bio)
 		wait = true;
 	else if (conf->barrier && bio_data_dir(bio) == WRITE) {
-		if (conf->next_resync < RESYNC_WINDOW_SECTORS)
-			wait = true;
-		else if ((conf->next_resync - RESYNC_WINDOW_SECTORS
-				>= bio_end_sector(bio)) ||
-			 (conf->next_resync + NEXT_NORMALIO_DISTANCE
-				<= bio->bi_iter.bi_sector))
+		if ((conf->mddev->curr_resync_completed
+		     >= bio_end_sector(bio)) ||
+		    (conf->next_resync + NEXT_NORMALIO_DISTANCE
+		     <= bio->bi_iter.bi_sector))
 			wait = false;
 		else
 			wait = true;
@@ -918,7 +916,7 @@ static sector_t wait_barrier(struct r1co
 
 	if (bio && bio_data_dir(bio) == WRITE) {
 		if (bio->bi_iter.bi_sector >=
-		    conf->next_resync) {
+		    conf->mddev->curr_resync_completed) {
 			if (conf->start_next_window == MaxSector)
 				conf->start_next_window =
 					conf->next_resync +


