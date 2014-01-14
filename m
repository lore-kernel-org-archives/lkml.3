Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaANWVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:21:31 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:38477 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaANWV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:21:28 -0500
Date: Tue, 14 Jan 2014 14:24:24 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hugh Dickins <hughd@google.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: next bio iters break discard?
Message-ID: <20140114222424.GA7333@moria.home.lan>
References: <alpine.LSU.2.11.1401121909160.1239@eggly.anvils>
 <20140114023346.GN9037@kmo>
 <yq161pnmcl2.fsf@sermon.lab.mkp.net>
 <20140114044841.GO9037@kmo>
 <yq1ob3el3mr.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1ob3el3mr.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 03:17:32PM -0500, Martin K. Petersen wrote:
> >>>>> "Kent" == Kent Overstreet <kmo@daterainc.com> writes:
> 
> >> IOW, DISCARD, WRITE SAME and the impending COPY requests do not have
> >> a 1:1 mapping between the block range worked on and the size of any
> >> bvecs attached. Your recent changes must have changed the way we
> >> handled that in the past.
> 
> Kent> Yeah - but with WRITE_SAME bios, wouldn't we at least have to
> Kent> check that they're writing the same data to merge them?
> 
> We do. Check blk_write_same_mergeable().

Aha, I missed that.

Side note, one of the things on my todo list/wishlist is make a separate
enum for bio type - bare flush, normal read/write, scsi command, discard
and write same. In particular with bi_size meaning different things
depending on the type of the command, I think having an enum we can
switch off of where appropriate instead of a bunch of random flags will
make things a hell of a lot saner.

Looking more at this code, I'm not sure it did what we wanted before for
REQ_DISCARD and REQ_WRITE_SAME bios/requests - I suspect for
REQ_WRITE_SAME requests that had been merged it overcounted.

There's also that horrible hack in the scsi (?) code Christoph added for
discards - where the driver adds a page to the bio - if the driver is
counting the number of segments _after_ that god only knows what is
supposed to happen.

Does the below patch look like what we want? I'm assuming that if
multiple WRITE_SAME bios are merged, since they're all writing the same
data we can consider the entire request to be a single segment.

commit 1755e7ffc5745591d37b8956ce2512f4052a104a
Author: Kent Overstreet <kmo@daterainc.com>
Date:   Tue Jan 14 14:22:01 2014 -0800

    block: Explicitly handle discard/write same when counting segments

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 8f8adaa..7d977f8 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -21,6 +21,12 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	if (!bio)
 		return 0;
 
+	if (bio->bi_rw & REQ_DISCARD)
+		return 0;
+
+	if (bio->bi_rw & REQ_WRITE_SAME)
+		return 1;
+
 	fbio = bio;
 	cluster = blk_queue_cluster(q);
 	seg_size = 0;
