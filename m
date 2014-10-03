Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbaJCWXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:23:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757963AbaJCWOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:14:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        majianpeng <majianpeng@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3.14 216/238] md/raid1: make sure resync waits for conflicting writes to complete.
Date: Fri,  3 Oct 2014 14:32:11 -0700
Message-Id: <20141003212920.572605417@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -845,10 +845,12 @@ static void raise_barrier(struct r1conf
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
@@ -915,8 +917,8 @@ static sector_t wait_barrier(struct r1co
 	}
 
 	if (bio && bio_data_dir(bio) == WRITE) {
-		if (conf->next_resync + NEXT_NORMALIO_DISTANCE
-		    <= bio->bi_iter.bi_sector) {
+		if (bio->bi_iter.bi_sector >=
+		    conf->next_resync) {
 			if (conf->start_next_window == MaxSector)
 				conf->start_next_window =
 					conf->next_resync +


