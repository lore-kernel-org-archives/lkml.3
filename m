Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3LDESP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 23:18:15 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:25041 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753690Ab3LDESM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 23:18:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AloHAKqsnlJ5LHyk/2dsb2JhbABagweDMbB+hU+BHBd0giUBAQUnExwjEAgDGAklDwUlAyETiADBNxcWjmgHhDMDmBOKTIdIgz0o
Date: Wed, 4 Dec 2013 15:17:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [OOPS, 3.13-rc2] null ptr in dio_complete()
Message-ID: <20131204041749.GL10988@dastard>
References: <20131203215940.GX10988@dastard>
 <20131204015837.GJ10988@dastard>
 <20131204033815.GK10988@dastard>
 <20131204034712.GM5051@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204034712.GM5051@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 08:47:12PM -0700, Jens Axboe wrote:
> On Wed, Dec 04 2013, Dave Chinner wrote:
> > On Wed, Dec 04, 2013 at 12:58:38PM +1100, Dave Chinner wrote:
> > > On Wed, Dec 04, 2013 at 08:59:40AM +1100, Dave Chinner wrote:
> > > > Hi Jens,
> > > > 
> > > > Not sure who to direct this to or CC, so I figured you are the
> > > > person to do that. I just had xfstests generic/299 (an AIO/DIO test)
> > > > oops in dio_complete() like so:
> > > > 
....
> > > > [ 9650.590630]  <IRQ>
> > > > [ 9650.590630]  [<ffffffff811ddae3>] dio_complete+0xa3/0x140
> > > > [ 9650.590630]  [<ffffffff811ddc2a>] dio_bio_end_aio+0x7a/0x110
> > > > [ 9650.590630]  [<ffffffff811ddbb5>] ? dio_bio_end_aio+0x5/0x110
> > > > [ 9650.590630]  [<ffffffff811d8a9d>] bio_endio+0x1d/0x30
> > > > [ 9650.590630]  [<ffffffff8175d65f>] blk_mq_complete_request+0x5f/0x120
> > > > [ 9650.590630]  [<ffffffff8175d736>] __blk_mq_end_io+0x16/0x20
> > > > [ 9650.590630]  [<ffffffff8175d7a8>] blk_mq_end_io+0x68/0xd0
> > > > [ 9650.590630]  [<ffffffff818539a7>] virtblk_done+0x67/0x110
> > > > [ 9650.590630]  [<ffffffff817f74c5>] vring_interrupt+0x35/0x60
.....
> > > And I just hit this from running xfs_repair which is doing
> > > multithreaded direct IO directly on /dev/vdc:
> > > 
....
> > > [ 1776.510446] IP: [<ffffffff81755b6a>] blk_account_io_done+0x6a/0x180
....
> > > [ 1776.512577]  [<ffffffff8175e4b8>] blk_mq_complete_request+0xb8/0x120
> > > [ 1776.512577]  [<ffffffff8175e536>] __blk_mq_end_io+0x16/0x20
> > > [ 1776.512577]  [<ffffffff8175e5a8>] blk_mq_end_io+0x68/0xd0
> > > [ 1776.512577]  [<ffffffff81852e47>] virtblk_done+0x67/0x110
> > > [ 1776.512577]  [<ffffffff817f7925>] vring_interrupt+0x35/0x60
> > > [ 1776.512577]  [<ffffffff810e48a4>] handle_irq_event_percpu+0x54/0x1e0
.....
> > > So this is looking like another virtio+blk_mq problem....
> > 
> > This one is definitely reproducable. Just hit it again...
> 
> I'll take a look at this. You don't happen to have gdb dumps of the
> lines associated with those crashes? Just to save me some digging
> time...

Only this:

(gdb) l *(dio_complete+0xa3)
0xffffffff811ddae3 is in dio_complete (fs/direct-io.c:282).
277                     }
278
279                     aio_complete(dio->iocb, ret, 0);
280             }
281
282             kmem_cache_free(dio_cache, dio);
283             return ret;
284     }
285
286     static void dio_aio_complete_work(struct work_struct *work)

And this:

(gdb) l *(blk_account_io_done+0x6a)
0xffffffff81755b6a is in blk_account_io_done (block/blk-core.c:2049).
2044                    int cpu;
2045
2046                    cpu = part_stat_lock();
2047                    part = req->part;
2048
2049                    part_stat_inc(cpu, part, ios[rw]);
2050                    part_stat_add(cpu, part, ticks[rw], duration);
2051                    part_round_stats(cpu, part);
2052                    part_dec_in_flight(part, rw);
2053

as I've rebuild the kernel with different patches since the one
running on the machine that is triggering the problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
