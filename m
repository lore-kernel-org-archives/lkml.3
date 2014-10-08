Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaJHWyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:54:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59411 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaJHWyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:54:15 -0400
Message-ID: <5435C093.5070405@suse.com>
Date: Wed, 08 Oct 2014 18:54:11 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: copy bi_vcnt in __bio_clone_fast
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 05f1dd53152173 (block: add queue flag for disabling SG merging) uses
bi_vcnt to assign bio->bi_phys_segments if sg merging is disabled. When
using device mapper on top of a blk-mq device (virtio_blk in my test),
we'd end up overflowing the scatterlist in __blk_bios_map_sg.

__bio_clone_fast copies bi_iter and bi_io_vec but not bi_vcnt, so
blk_recount_segments would report bi_phys_segments as 0. Since
rq->nr_phys_segments is 0 as well, the checks to ensure that we don't
exceed the queue's segment limit end up allowing more bios (and segments) to
attach the a request until we finally map it. That also means we
pass the BUG_ON at the beginning of virtio_queue_rq, ultimately causing
memory corruption and a crash.

If we copy bi_vcnt in __bio_clone_fast, the bios and requests properly
report the number of segments and everything works as expected.

Originally reported at http://bugzilla.opensuse.org/show_bug.cgi?id=888259

Reported-by: Stephen Kulow <coolo@suse.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 block/bio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/bio.c
+++ b/block/bio.c
@@ -564,6 +564,7 @@ void __bio_clone_fast(struct bio *bio, s
 	bio->bi_rw = bio_src->bi_rw;
 	bio->bi_iter = bio_src->bi_iter;
 	bio->bi_io_vec = bio_src->bi_io_vec;
+	bio->bi_vcnt = bio_src->bi_vcnt;
 }
 EXPORT_SYMBOL(__bio_clone_fast);
 

-- 
Jeff Mahoney
SUSE Labs

