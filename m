Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab3CWW47 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 18:56:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab3CWW45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 18:56:57 -0400
Date: Sat, 23 Mar 2013 18:56:48 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Paul Taysom <taysom@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Thornber <ejt@redhat.com>
Subject: Re: dm: dm-cache fails to write the cache device in writethrough mode
Message-ID: <20130323225648.GA13583@redhat.com>
References: <20130322201151.GB5357@blackbox.djwong.org>
 <20130322223425.GA5638@redhat.com>
 <20130322231600.GD5357@blackbox.djwong.org>
 <20130323032715.GA7692@redhat.com>
 <20130323051549.GE5357@blackbox.djwong.org>
 <20130323210853.GA12164@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130323210853.GA12164@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23 2013 at  5:08pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> But even after having changed my test to use /dev/sdb for the origin
> device I cannot reproduce the problem you've reported.  Do you have any
> further details on how/why the bios are being altered?  Are you
> reliably hitting partial completions within the origin's driver?  If so
> how?

I can easily see bio->bi_size being 0 in writethrough_endio, here is the
stack trace from a WARN_ON_ONCE(!bio->bi_size); that I added to
writethrough_endio:

Call Trace:
 <IRQ>  [<ffffffff81042d7f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81042dda>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa072f56f>] writethrough_endio+0x13f/0x150 [dm_cache]
 [<ffffffff811a30dd>] bio_endio+0x3d/0x90
 [<ffffffff81233853>] req_bio_endio+0xa3/0xe0
 [<ffffffff81234f6f>] blk_update_request+0x10f/0x480
 [<ffffffff81235307>] blk_update_bidi_request+0x27/0xb0
 [<ffffffff8123651f>] blk_end_bidi_request+0x2f/0x80
 [<ffffffff812365c0>] blk_end_request+0x10/0x20
 [<ffffffff81363680>] scsi_end_request+0x40/0xb0
 [<ffffffff81081737>] ? entity_tick+0x97/0x420
 [<ffffffff813639ff>] scsi_io_completion+0x9f/0x660
 [<ffffffff8104baa9>] ? raise_softirq_irqoff+0x9/0x50
 [<ffffffff8135ad89>] scsi_finish_command+0xc9/0x130
 [<ffffffff81364127>] scsi_softirq_done+0x147/0x170
 [<ffffffff8123ca42>] blk_done_softirq+0x82/0xa0
 [<ffffffff8104b697>] __do_softirq+0xe7/0x260
 [<ffffffff811a21a5>] ? bio_alloc_bioset+0x65/0x120
 [<ffffffff8150fc9c>] call_softirq+0x1c/0x30
 [<ffffffff81004415>] do_softirq+0x65/0xa0
 [<ffffffff8104b46d>] irq_exit+0xbd/0xe0
 [<ffffffff81510396>] do_IRQ+0x66/0xe0
 [<ffffffff815061ed>] common_interrupt+0x6d/0x6d

No idea why I was so oblivious to a bio->bi_size of 0 reflecting
completion.  So nothing to do with partial completion at all.

Here is a version of the patch you posted that uses
dm_bio_{record,restore} like Alasdair suggested:

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 66120bd..90b1dd2 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -5,6 +5,7 @@
  */
 
 #include "dm.h"
+#include "dm-bio-record.h"
 #include "dm-bio-prison.h"
 #include "dm-cache-metadata.h"
 
@@ -205,6 +206,7 @@ struct per_bio_data {
 	struct cache *cache;
 	dm_cblock_t cblock;
 	bio_end_io_t *saved_bi_end_io;
+	struct dm_bio_details bio_details;
 };
 
 struct dm_cache_migration {
@@ -643,6 +645,7 @@ static void writethrough_endio(struct bio *bio, int err)
 		return;
 	}
 
+	dm_bio_restore(&pb->bio_details, bio);
 	remap_to_cache(pb->cache, bio, pb->cblock);
 
 	/*
@@ -668,6 +671,7 @@ static void remap_to_origin_then_cache(struct cache *cache, struct bio *bio,
 	pb->cblock = cblock;
 	pb->saved_bi_end_io = bio->bi_end_io;
 	bio->bi_end_io = writethrough_endio;
+	dm_bio_record(&pb->bio_details, bio);
 
 	remap_to_origin_clear_discard(pb->cache, bio, oblock);
 }
