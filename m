Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab3KSVeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:34:37 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:63529 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202Ab3KSVed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:34:33 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkIACzYi1J5LGc//2dsb2JhbABZgweDLbdVhUmBIBd0giUBAQU6HCMQCAMYCSUPBSUDIROIAL9rFo9BB4QyA5gRkg6BaoFSKA
Date: Wed, 20 Nov 2013 08:34:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Regression x2, 3.13-git] virtio block mq hang, iostat busted on
 virtio devices
Message-ID: <20131119213429.GQ11434@dastard>
References: <20131119080218.GJ11434@dastard>
 <20131119201531.GA4094@kernel.dk>
 <20131119212042.GB4094@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119212042.GB4094@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 02:20:42PM -0700, Jens Axboe wrote:
> On Tue, Nov 19 2013, Jens Axboe wrote:
> > On Tue, Nov 19 2013, Dave Chinner wrote:
> > > Hi Jens,
> > > 
> > > I was just running xfstests on a 3.13 kernel that has had the block
> > > layer changed merged into it. generic/269 on XFS is hanging on a 2
> > > CPU VM using virtio,cache=none for the block devices under test,
> > > with many (130+) threads stuck below submit_bio() like this:
> > > 
> > >  Call Trace:
> > >   [<ffffffff81adb1c9>] schedule+0x29/0x70
> > >   [<ffffffff817833ee>] percpu_ida_alloc+0x16e/0x330
> > >   [<ffffffff81759bef>] blk_mq_wait_for_tags+0x1f/0x40
> > >   [<ffffffff81758bee>] blk_mq_alloc_request_pinned+0x4e/0xf0
> > >   [<ffffffff8175931b>] blk_mq_make_request+0x3bb/0x4a0
> > >   [<ffffffff8174d2b2>] generic_make_request+0xc2/0x110
> > >   [<ffffffff8174e40c>] submit_bio+0x6c/0x120
> > > 
> > > reads and writes are hung, both data (direct and buffered) and
> > > metadata.
> > > 
> > > Some IOs are sitting in io_schedule, waiting for IO completion (both
> > > buffered and direct IO, both reads and writes) so it looks like IO
> > > completion has stalled in some manner, too.
> > 
> > Can I get a recipe to reproduce this? I haven't had any luck so far.
> 
> OK, I reproduced it. Looks weird, basically all 64 commands are in
> flight, but haven't completed. So the next one that comes in just sits
> there forever. I can't find any sysfs debug entries for virtio, would be
> nice to inspect its queue as well...

Does it have anything to do with the fact that the request queue
depth is 128 entries and the tag pool only has 66 tags in it? i.e:

/sys/block/vdb/queue/nr_requests
128

/sys/block/vdb/mq/0/tags
nr_tags=66, reserved_tags=2, batch_move=16, max_cache=32
nr_free=0, nr_reserved=1
  cpu00: nr_free=0
  cpu01: nr_free=0

Seems to imply that if we queue up more than 66 IOs without
dispatching them, we'll run out of tags. And without another IO
coming through, the "none" scheduler that virtio uses will never
get a trigger to push out the currently queued IO?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
