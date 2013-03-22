Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422893Ab3CVUMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 16:12:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35386 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422691Ab3CVUMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 16:12:02 -0400
Date: Fri, 22 Mar 2013 13:11:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Paul Taysom <taysom@chromium.org>,
        Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org
Subject: [PATCH] dm: dm-cache fails to write the cache device in writethrough
 mode
Message-ID: <20130322201151.GB5357@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new writethrough strategy for dm-cache issues a bio to the origin device,
remaps the bio to the cache device, and issues the bio to the cache device.
However, the block layer modifies bi_sector and bi_size, so we need to preserve
these or else nothing gets written to the cache (bi_size == 0).  This fixes the
problem where someone writes a block through the cache, but a subsequent reread
(from the cache) returns old contents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 drivers/md/dm-cache-target.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 66120bd..0db0ad2 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -205,6 +205,8 @@ struct per_bio_data {
 	struct cache *cache;
 	dm_cblock_t cblock;
 	bio_end_io_t *saved_bi_end_io;
+	unsigned int bi_size;
+	sector_t bi_sector;
 };
 
 struct dm_cache_migration {
@@ -643,6 +645,8 @@ static void writethrough_endio(struct bio *bio, int err)
 		return;
 	}
 
+	bio->bi_sector = pb->bi_sector;
+	bio->bi_size = pb->bi_size;
 	remap_to_cache(pb->cache, bio, pb->cblock);
 
 	/*
@@ -667,6 +671,12 @@ static void remap_to_origin_then_cache(struct cache *cache, struct bio *bio,
 	pb->cache = cache;
 	pb->cblock = cblock;
 	pb->saved_bi_end_io = bio->bi_end_io;
+	/*
+	 * The block layer modifies bi_size and bi_sector, so we must save
+	 * them for when we re-issue the bio against the cache device.
+	 */
+	pb->bi_size = bio->bi_size;
+	pb->bi_sector = bio->bi_sector;
 	bio->bi_end_io = writethrough_endio;
 
 	remap_to_origin_clear_discard(pb->cache, bio, oblock);
