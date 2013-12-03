Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab3LCXzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:55:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629Ab3LCXzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:55:06 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Cc: kmo@daterainc.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] dm cache: increment bi_remaining when bi_end_io is restored
Date: Tue,  3 Dec 2013 18:54:59 -0500
Message-Id: <1386114899-7766-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the bio->bi_remaining increment into dm_unhook_bio() so the
overwrite_endio() handler works as expected.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-target.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

[Jens: this one would've been needed as a post-merge fix for v3.13 but
 immutable biovecs fell out.. please apply to your for-3.14/core]

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index bf3a206..7c8dd1f 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -85,6 +85,12 @@ static void dm_unhook_bio(struct dm_hook_info *h, struct bio *bio)
 {
 	bio->bi_end_io = h->bi_end_io;
 	bio->bi_private = h->bi_private;
+
+	/*
+	 * Must bump bi_remaining to allow bio to complete with
+	 * restored bi_end_io.
+	 */
+	atomic_inc(&bio->bi_remaining);
 }
 
 /*----------------------------------------------------------------*/
@@ -765,12 +771,6 @@ static void writethrough_endio(struct bio *bio, int err)
 
 	dm_unhook_bio(&pb->hook_info, bio);
 
-	/*
-	 * Must bump bi_remaining to allow bio to complete with
-	 * restored bi_end_io.
-	 */
-	atomic_inc(&bio->bi_remaining);
-
 	if (err) {
 		bio_endio(bio, err);
 		return;
-- 
1.7.1

