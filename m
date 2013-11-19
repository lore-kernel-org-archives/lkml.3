Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab3KSVa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:30:58 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:40354 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421Ab3KSVa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:30:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkIACzYi1J5LGc//2dsb2JhbABZgweDLbdVhUmBIBd0giUBAQU6HCMQCAMYCSUPBSUDIROIAL9UFxaPQQeEMgOYEZIOgWqBUig
Date: Wed, 20 Nov 2013 08:30:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [Regression x2, 3.13-git] virtio block mq hang, iostat busted on
 virtio devices
Message-ID: <20131119213051.GP11434@dastard>
References: <20131119080218.GJ11434@dastard>
 <20131119103635.GA9223@infradead.org>
 <20131119160509.GB21343@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119160509.GB21343@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 09:05:09AM -0700, Jens Axboe wrote:
> On Tue, Nov 19 2013, Christoph Hellwig wrote:
> > On Tue, Nov 19, 2013 at 07:02:18PM +1100, Dave Chinner wrote:
> > > I have no idea if it's related to the above hang, but either way
> > > breaking iostat is a major regression....
> > 
> > Both of them are most likely due to the conversion of virtio_blk
> > to the blk-mq code.
> > 
> > I've not seen the hang in my heavy xfstests testing, but that was a
> > slightly different codebase than what finally got in, so I'll try
> > to reproduce it once I get some spare QA cycles.
> 
> Thanks! Dave, if you still have it in that state, can you dump the
> contents of /sys/block/<devs>/mq/ for the device/devices that are hung?

# find /sys/block/vdb/mq -type f -print -exec cat {} \;
/sys/block/vdb/mq/0/run
1313835
/sys/block/vdb/mq/0/cpu0/completed
546857 207203
/sys/block/vdb/mq/0/cpu0/rq_list
CTX pending:
/sys/block/vdb/mq/0/cpu0/merged
0
/sys/block/vdb/mq/0/cpu0/dispatched
257733 496352
/sys/block/vdb/mq/0/cpu1/completed
547714 200741
/sys/block/vdb/mq/0/cpu1/rq_list
CTX pending:
/sys/block/vdb/mq/0/cpu1/merged
0
/sys/block/vdb/mq/0/cpu1/dispatched
262114 486381
/sys/block/vdb/mq/0/tags
nr_tags=66, reserved_tags=2, batch_move=16, max_cache=32
nr_free=0, nr_reserved=1
  cpu00: nr_free=0
  cpu01: nr_free=0
/sys/block/vdb/mq/0/ipi_redirect
0
/sys/block/vdb/mq/0/queued
1384795
/sys/block/vdb/mq/0/dispatched
       0        194596
       1        1022691
       2        68540
       4        10138
       8        7686
      16        10234
      32        0
      64        0
     128        0
     256        0
/sys/block/vdb/mq/0/pending
HCTX pending:
#

It looks like it's hung because of this:

/sys/block/vdb/mq/0/tags
nr_tags=66, reserved_tags=2, batch_move=16, max_cache=32
nr_free=0, nr_reserved=1
  cpu00: nr_free=0
  cpu01: nr_free=0

No free tags in teh pool, nor any free tags in the per-cpu
magazines. Perhaps there is a leak somewhere?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
