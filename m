Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098Ab3CYX7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 19:59:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440Ab3CYX7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 19:59:22 -0400
Date: Mon, 25 Mar 2013 19:59:18 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        device-mapper development <dm-devel@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Joe Thornber <ejt@redhat.com>
Subject: [PATCH v2] dm cache: fix writes to cache device in writethrough mode
Message-ID: <20130325235918.GA28746@redhat.com>
References: <20130322201151.GB5357@blackbox.djwong.org>
 <20130322223425.GA5638@redhat.com>
 <20130322231600.GD5357@blackbox.djwong.org>
 <20130323032715.GA7692@redhat.com>
 <20130323051549.GE5357@blackbox.djwong.org>
 <20130323210853.GA12164@redhat.com>
 <20130323225648.GA13583@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130323225648.GA13583@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The dm-cache writethrough strategy introduced by commit e2e74d617eadc15
("dm cache: fix race in writethrough implementation") issues a bio to
the origin device, remaps and then issues the bio to the cache device.
This more conservative in-series approach was selected to favor
correctness over performance (of the previous parallel writethrough).
However, this in-series implementation that reuses the same bio to write
both the origin and cache device didn't take into account that the block
layer's req_bio_endio() modifies a completing bio's bi_sector and
bi_size.  So the new writethrough strategy needs to preserve these bio
fields, and restore them before submission to the cache device,
otherwise nothing gets written to the cache (because bi_size is 0).

This patch adds a struct dm_bio_details field to struct per_bio_data,
and uses dm_bio_record() and dm_bio_restore() to ensure the bio is
restored before reissuing to the cache device.  Adding such a large
structure to the per_bio_data is not ideal but we can improve this
later, for now correctness is the important thing.

This problem initially went unnoticed because the dm-cache test-suite
uses a linear DM device for the dm-cache device's origin device.
Writethrough worked as expected because DM submits a *clone* of the
original bio, so the original bio which was reused for the cache was
never touched.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-target.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

v2: revised patch header on Darrick and Joe's behalf

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index cf24a46..873f495 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -6,6 +6,7 @@
 
 #include "dm.h"
 #include "dm-bio-prison.h"
+#include "dm-bio-record.h"
 #include "dm-cache-metadata.h"
 
 #include <linux/dm-io.h>
@@ -205,6 +206,7 @@ struct per_bio_data {
        struct cache *cache;
        dm_cblock_t cblock;
        bio_end_io_t *saved_bi_end_io;
+       struct dm_bio_details bio_details;
 };
 
 struct dm_cache_migration {
@@ -642,6 +644,7 @@ static void writethrough_endio(struct bio *bio, int err)
                return;
        }
 
+       dm_bio_restore(&pb->bio_details, bio);
        remap_to_cache(pb->cache, bio, pb->cblock);
 
        /*
@@ -665,6 +668,7 @@ static void remap_to_origin_then_cache(struct cache *cache, struct bio *bio,
        pb->cache = cache;
        pb->cblock = cblock;
        pb->saved_bi_end_io = bio->bi_end_io;
+       dm_bio_record(&pb->bio_details, bio);
        bio->bi_end_io = writethrough_endio;
 
        remap_to_origin_clear_discard(pb->cache, bio, oblock);
