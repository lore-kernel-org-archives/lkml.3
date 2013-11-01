Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab3KAN7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:59:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab3KAN7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:36 -0400
Date: Fri, 1 Nov 2013 09:59:31 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kmo@daterainc.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH for-next] dm: fix missing bi_remaining accounting
Message-ID: <20131101135931.GA22903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing bi_remaining increment, required by the block layer's
new bio-chaining code, to both the verity and old snapshot DM targets.

Otherwise users will hit the bi_remaining <= 0 BUG_ON in bio_endio().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c   |    1 +
 drivers/md/dm-verity.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index b7a5053..1b4d22d 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1415,6 +1415,7 @@ out:
 	if (full_bio) {
 		full_bio->bi_end_io = pe->full_bio_end_io;
 		full_bio->bi_private = pe->full_bio_private;
+		atomic_inc(&full_bio->bi_remaining);
 	}
 	free_pending_exception(pe);
 
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index ac35e95..dc15857 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -384,6 +384,7 @@ static void verity_finish_io(struct dm_verity_io *io, int error)
 
 	bio->bi_end_io = io->orig_bi_end_io;
 	bio->bi_private = io->orig_bi_private;
+	atomic_inc(&bio->bi_remaining);
 
 	bio_endio(bio, error);
 }
