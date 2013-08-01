Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab3HAFsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 01:48:13 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:55165 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271Ab3HAFsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 01:48:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjgFAKf1+VF5LPxHgWdsb2JhbABbvQ2FLoEgFw4BARYmKIIkAQEEATocIwULCAMOBwMJJQ8FJQMhE4gKBblLFo4/gTIHhAsDl16UdCqBLQ
Date: Thu, 1 Aug 2013 15:48:05 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davej@redhat.com, viro@zeniv.linux.org.uk,
        glommer@parallels.com
Subject: Re: [PATCH 01/11] writeback: plug writeback at a high level
Message-ID: <20130801054805.GO7118@dastard>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
 <1375244150-27296-2-git-send-email-david@fromorbit.com>
 <20130731144019.GC22930@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731144019.GC22930@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 04:40:19PM +0200, Jan Kara wrote:
> On Wed 31-07-13 14:15:40, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Doing writeback on lots of little files causes terrible IOPS storms
> > because of the per-mapping writeback plugging we do. This
> > essentially causes imeediate dispatch of IO for each mapping,
> > regardless of the context in which writeback is occurring.
> > 
> > IOWs, running a concurrent write-lots-of-small 4k files using fsmark
> > on XFS results in a huge number of IOPS being issued for data
> > writes.  Metadata writes are sorted and plugged at a high level by
> > XFS, so aggregate nicely into large IOs. However, data writeback IOs
> > are dispatched in individual 4k IOs, even when the blocks of two
> > consecutively written files are adjacent.
> > 
> > Test VM: 8p, 8GB RAM, 4xSSD in RAID0, 100TB sparse XFS filesystem,
> > metadata CRCs enabled.
> > 
> > Kernel: 3.10-rc5 + xfsdev + my 3.11 xfs queue (~70 patches)
> > 
> > Test:
> > 
> > $ ./fs_mark  -D  10000  -S0  -n  10000  -s  4096  -L  120  -d
> > /mnt/scratch/0  -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d
> > /mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d
> > /mnt/scratch/6  -d  /mnt/scratch/7
> > 
> > Result:
> > 
> > 		wall	sys	create rate	Physical write IO
> > 		time	CPU	(avg files/s)	 IOPS	Bandwidth
> > 		-----	-----	------------	------	---------
> > unpatched	6m56s	15m47s	24,000+/-500	26,000	130MB/s
> > patched		5m06s	13m28s	32,800+/-600	 1,500	180MB/s
> > improvement	-26.44%	-14.68%	  +36.67%	-94.23%	+38.46%
> > 
> > If I use zero length files, this workload at about 500 IOPS, so
> > plugging drops the data IOs from roughly 25,500/s to 1000/s.
> > 3 lines of code, 35% better throughput for 15% less CPU.
> > 
> > The benefits of plugging at this layer are likely to be higher for
> > spinning media as the IO patterns for this workload are going make a
> > much bigger difference on high IO latency devices.....
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
>   Just one question: Won't this cause a regression when files are say 2 MB
> large? Then we generate maximum sized requests for these files with
> per-inode plugging anyway and they will unnecessarily sit in the plug list
> until the plug list gets full (that is after 16 requests). Granted it
> shouldn't be too long but with fast storage it may be measurable...

Latency of IO dispatch only matters for the initial IOs being
queued. This, however, is not a latency sensitive IO path -
writeback is our bulk throughput IO engine, and in those cases low
latency dispatch is precisely what we don't want. We want to
optimise IO patterns for maximum *bandwidth*, not minimal latency.

The problem is that fast storage with immediate dispatch and dep
queues can keep ahead of IO dispatch, preventing throughput
optimisations like IO aggregation from being made because there is
never any IO queued to aggregate. That's why I'm seeing a couple of
orders of magnitude higher IOPS than I should. Sure, the hardware
can do that, but it's not the *most efficient* method of dispatching
background IO.

Allowing IOs a chance to aggregate in the scheduler for a short
while because dispatch allows existing bulk throughput optimisations
to be made to the IO stream, and as we can see, where a delayed
allocation filesystem is optimised for adjacent allocation
across sequentially written inodes such oppportunites for IO
aggregation make a big difference to performance.

So, to test your 2MB IO case, I ran a fsmark test using 40,000
2MB files instead of 10 million 4k files.

		wall time	IOPS	BW
mmotm		170s		1000	350MB/s
patched		167s		1000	350MB/s

The IO profiles are near enough to be identical, and the wall time
is basically the same.


I just don't see any particular concern about larger IOs and initial
dispatch latency here from either a theoretical or an observed POV.
Indeed, I haven't seen a performance degradation as a result of this
patch in any of the testing I've done since I first posted it...

> Now if we have maximum sized request in the plug list, maybe we could just
> dispatch it right away but that's another story.

That, in itself is potentially an issue, too, as it prevents seek
minimisation optimisations from being made when we batch up multiple
IOs on the plug list...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
