Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab3EPW5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:57:07 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:7144 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754288Ab3EPW5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:57:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnQQAK9ilVF5LDbs/2dsb2JhbABbDoJ6gwq5SoUtBAF7F3SCHwEBBAE6HA8UBQsIAw4KCSUPBSUDIROIBgW8UBaNUQELD4EdB4NVA5c3kUGCUVEqgSwBHw
Date: Fri, 17 May 2013 08:56:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: David Oostdyk <daveo@ll.mit.edu>
Cc: "stan@hardwarefreak.com" <stan@hardwarefreak.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Subject: Re: high-speed disk I/O is CPU-bound?
Message-ID: <20130516225656.GG24635@dastard>
References: <518CFE7C.9080708@ll.mit.edu>
 <20130516005913.GE24635@dastard>
 <5194C4BB.9080406@hardwarefreak.com>
 <5194FCAC.1010300@ll.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5194FCAC.1010300@ll.mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 11:35:08AM -0400, David Oostdyk wrote:
> On 05/16/13 07:36, Stan Hoeppner wrote:
> >On 5/15/2013 7:59 PM, Dave Chinner wrote:
> >>[cc xfs list, seeing as that's where all the people who use XFS in
> >>these sorts of configurations hang out. ]
> >>
> >>On Fri, May 10, 2013 at 10:04:44AM -0400, David Oostdyk wrote:
> >>>As a basic benchmark, I have an application
> >>>that simply writes the same buffer (say, 128MB) to disk repeatedly.
> >>>Alternatively you could use the "dd" utility.  (For these
> >>>benchmarks, I set /proc/sys/vm/dirty_bytes to 512M or lower, since
> >>>these systems have a lot of RAM.)
> >>>
> >>>The basic observations are:
> >>>
> >>>1.  "single-threaded" writes, either a file on the mounted
> >>>filesystem or with a "dd" to the raw RAID device, seem to be limited
> >>>to 1200-1400MB/sec.  These numbers vary slightly based on whether
> >>>TurboBoost is affecting the writing process or not.  "top" will show
> >>>this process running at 100% CPU.
> >>Expected. You are using buffered IO. Write speed is limited by the
> >>rate at which your user process can memcpy data into the page cache.
> >>
> >>>2.  With two benchmarks running on the same device, I see aggregate
> >>>write speeds of up to ~2.4GB/sec, which is closer to what I'd expect
> >>>the drives of being able to deliver.  This can either be with two
> >>>applications writing to separate files on the same mounted file
> >>>system, or two separate "dd" applications writing to distinct
> >>>locations on the raw device.
> >2.4GB/s is the interface limit of quad lane 6G SAS.  Coincidence?  If
> >you've daisy chained the SAS expander backplanes within a server chassis
> >(9266-8i/72405), or between external enclosures (9285-8e/71685), and
> >have a single 4 lane cable (SFF-8087/8088/8643/8644) connected to your
> >RAID card, this would fully explain the 2.4GB/s wall, regardless of how
> >many parallel processes are writing, or any other software factor.
> >
> >But surely you already know this, and you're using more than one 4 lane
> >cable.  Just covering all the bases here, due to seeing 2.4 GB/s as the
> >stated wall.  This number is just too coincidental to ignore.
> 
> We definitely have two 4-lane cables being used, but this is an
> interesting coincidence.  I'd be surprised if anyone could really
> achieve the theoretical throughput on one cable, though.  We have
> one JBOD that only takes a single 4-lane cable, and we seem to cap
> out at closer to 1450MB/sec on that unit.  (This is just a single
> point of reference, and I don't have many tests where only one
> 4-lane cable was in use.)

You can get pretty close to the theoretical limit on the back end
SAS cables - just like you can with FC.

What I'd suggest you do is look at the RAID card configuration -
often they default to active/passive failover configurations when
there are multiple channels to the same storage. Then hey only use
one of the cables for all traffic. Some RAID cards offer
ative/active or "load balanced" options where all back end paths are
used in redundant configurations rather than just one....

> You guys hit the nail on the head!  With O_DIRECT I can use a single
> writer thread and easily see the same throughput that I _ever_ saw
> in the multiple-writer case (~2.4GB/sec), and "top" shows the writer
> at 10% CPU usage.  I've modified my application to use O_DIRECT and
> it makes a world of difference.

Be aware that O_DIRECT is not a magic bullet. It can make your IO
go a lot slower on some worklaods and storage configs....

> [It's interesting that you see performance benefits for O_DIRECT
> even with a single SATA drive.  The reason it took me so long to
> test O_DIRECT in this case, is that I never saw any significant
> benefit from using it in the past.  But that is when I didn't have
> such fast storage, so I probably wasn't hitting the bottleneck with
> buffered I/O?]

Right - for applications not designed to use direct IO from the
ground up, this is typically the case - buffered IO is faster right
up to the point where you run out of CPU....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
