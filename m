Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab3KDPGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 10:06:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab3KDPGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 10:06:07 -0500
Date: Mon, 4 Nov 2013 10:06:00 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Jens Axboe <axboe@kernel.dk>
cc: Mike Snitzer <snitzer@redhat.com>, Kent Overstreet <kmo@daterainc.com>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH for-next] dm: fix missing bi_remaining accounting
In-Reply-To: <5273C2B8.5030608@kernel.dk>
Message-ID: <alpine.LRH.2.02.1311041003400.4548@file01.intranet.prod.int.rdu2.redhat.com>
References: <20131101135931.GA22903@redhat.com> <5273C2B8.5030608@kernel.dk>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Nov 2013, Jens Axboe wrote:

> On 11/01/2013 07:59 AM, Mike Snitzer wrote:
> > Add the missing bi_remaining increment, required by the block layer's
> > new bio-chaining code, to both the verity and old snapshot DM targets.
> > 
> > Otherwise users will hit the bi_remaining <= 0 BUG_ON in bio_endio().
> 
> Thanks Mike, added to the mix.
> 
> -- 
> Jens Axboe

Hi

This improves a little bit on the previous patch, by replacing costly 
atomic_inc with cheap atomic_set.


From: Mikulas Patocka <mpatocka@redhat.com>

dm: change atomic_inc to atomic_set(1)

There are places in dm where we save bi_endio and bi_private, set them to
target's routine, submit the bio, from the target's bi_endio routine we
restore bi_endio and bi_private and end the bio with bi_endio.

This causes underflow of bi_remaining, so we must restore bi_remaining
before ending the bio from the target bi_endio routine.

The code uses atomic_inc for restoration of bi_remaining. This patch
changes it to atomic_set(1) to avoid an interlocked instruction. In the
target's bi_endio routine we are sure that bi_remaining is zero
(otherwise, the bi_endio routine wouldn't be called) and there are no
concurrent users of the bio, so we can replace atomic_inc with
atomic_set(1).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-cache-target.c |    2 +-
 drivers/md/dm-snap.c         |    2 +-
 drivers/md/dm-thin.c         |    4 ++--
 drivers/md/dm-verity.c       |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-block/drivers/md/dm-cache-target.c
===================================================================
--- linux-block.orig/drivers/md/dm-cache-target.c	2013-11-01 17:21:11.000000000 +0100
+++ linux-block/drivers/md/dm-cache-target.c	2013-11-04 13:59:13.000000000 +0100
@@ -670,7 +670,7 @@ static void writethrough_endio(struct bi
 	 * Must bump bi_remaining to allow bio to complete with
 	 * restored bi_end_io.
 	 */
-	atomic_inc(&bio->bi_remaining);
+	atomic_set(&bio->bi_remaining, 1);
 
 	if (err) {
 		bio_endio(bio, err);
Index: linux-block/drivers/md/dm-snap.c
===================================================================
--- linux-block.orig/drivers/md/dm-snap.c	2013-11-01 17:21:11.000000000 +0100
+++ linux-block/drivers/md/dm-snap.c	2013-11-04 13:59:56.000000000 +0100
@@ -1415,7 +1415,7 @@ out:
 	if (full_bio) {
 		full_bio->bi_end_io = pe->full_bio_end_io;
 		full_bio->bi_private = pe->full_bio_private;
-		atomic_inc(&full_bio->bi_remaining);
+		atomic_set(&full_bio->bi_remaining, 1);
 	}
 	free_pending_exception(pe);
 
Index: linux-block/drivers/md/dm-thin.c
===================================================================
--- linux-block.orig/drivers/md/dm-thin.c	2013-11-01 17:21:11.000000000 +0100
+++ linux-block/drivers/md/dm-thin.c	2013-11-04 14:00:19.000000000 +0100
@@ -613,7 +613,7 @@ static void process_prepared_mapping_fai
 {
 	if (m->bio) {
 		m->bio->bi_end_io = m->saved_bi_end_io;
-		atomic_inc(&m->bio->bi_remaining);
+		atomic_set(&m->bio->bi_remaining, 1);
 	}
 	cell_error(m->tc->pool, m->cell);
 	list_del(&m->list);
@@ -630,7 +630,7 @@ static void process_prepared_mapping(str
 	bio = m->bio;
 	if (bio) {
 		bio->bi_end_io = m->saved_bi_end_io;
-		atomic_inc(&bio->bi_remaining);
+		atomic_set(&bio->bi_remaining, 1);
 	}
 
 	if (m->err) {
Index: linux-block/drivers/md/dm-verity.c
===================================================================
--- linux-block.orig/drivers/md/dm-verity.c	2013-11-01 17:21:11.000000000 +0100
+++ linux-block/drivers/md/dm-verity.c	2013-11-04 13:59:28.000000000 +0100
@@ -384,7 +384,7 @@ static void verity_finish_io(struct dm_v
 
 	bio->bi_end_io = io->orig_bi_end_io;
 	bio->bi_private = io->orig_bi_private;
-	atomic_inc(&bio->bi_remaining);
+	atomic_set(&bio->bi_remaining, 1);
 
 	bio_endio(bio, error);
 }
