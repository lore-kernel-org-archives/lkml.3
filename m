Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab3KSVUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:20:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49414 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab3KSVUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:20:44 -0500
Date: Tue, 19 Nov 2013 14:20:42 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Regression x2, 3.13-git] virtio block mq hang, iostat busted on
 virtio devices
Message-ID: <20131119212042.GB4094@kernel.dk>
References: <20131119080218.GJ11434@dastard>
 <20131119201531.GA4094@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119201531.GA4094@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19 2013, Jens Axboe wrote:
> On Tue, Nov 19 2013, Dave Chinner wrote:
> > Hi Jens,
> > 
> > I was just running xfstests on a 3.13 kernel that has had the block
> > layer changed merged into it. generic/269 on XFS is hanging on a 2
> > CPU VM using virtio,cache=none for the block devices under test,
> > with many (130+) threads stuck below submit_bio() like this:
> > 
> >  Call Trace:
> >   [<ffffffff81adb1c9>] schedule+0x29/0x70
> >   [<ffffffff817833ee>] percpu_ida_alloc+0x16e/0x330
> >   [<ffffffff81759bef>] blk_mq_wait_for_tags+0x1f/0x40
> >   [<ffffffff81758bee>] blk_mq_alloc_request_pinned+0x4e/0xf0
> >   [<ffffffff8175931b>] blk_mq_make_request+0x3bb/0x4a0
> >   [<ffffffff8174d2b2>] generic_make_request+0xc2/0x110
> >   [<ffffffff8174e40c>] submit_bio+0x6c/0x120
> > 
> > reads and writes are hung, both data (direct and buffered) and
> > metadata.
> > 
> > Some IOs are sitting in io_schedule, waiting for IO completion (both
> > buffered and direct IO, both reads and writes) so it looks like IO
> > completion has stalled in some manner, too.
> 
> Can I get a recipe to reproduce this? I haven't had any luck so far.

OK, I reproduced it. Looks weird, basically all 64 commands are in
flight, but haven't completed. So the next one that comes in just sits
there forever. I can't find any sysfs debug entries for virtio, would be
nice to inspect its queue as well...

-- 
Jens Axboe

