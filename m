Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab3EPA7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 20:59:23 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:63937 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751414Ab3EPA7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 20:59:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnYPAOkulFF5LKxY/2dsb2JhbABbDoJ5gwq4ZYUgBAGBABd0gh8BAQQBOhwjBQsIAw4KCSUPBSUDIROIBgW9GBaNUAwPgR0HgnRhA5czkT6CUVEqgS0BHw
Date: Thu, 16 May 2013 10:59:13 +1000
From: Dave Chinner <david@fromorbit.com>
To: David Oostdyk <daveo@ll.mit.edu>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: high-speed disk I/O is CPU-bound?
Message-ID: <20130516005913.GE24635@dastard>
References: <518CFE7C.9080708@ll.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518CFE7C.9080708@ll.mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc xfs list, seeing as that's where all the people who use XFS in
these sorts of configurations hang out. ]

On Fri, May 10, 2013 at 10:04:44AM -0400, David Oostdyk wrote:
> Hello,
> 
> I have a few relatively high-end systems with hardware RAIDs which
> are being used for recording systems, and I'm trying to get a better
> understanding of contiguous write performance.
> 
> The hardware that I've tested with includes two high-end Intel
> E5-2600 and E5-4600 (~3GHz) series systems, as well as a slightly
> older Xeon 5600 system.  The JBODs include a 45x3.5" JBOD, a 28x3.5"
> JBOD (with either 7200RPM or 10kRPM SAS drives), and a 24x2.5" JBOD
> with 10kRPM drives.  I've tried LSI controllers (9285-8e, 9266-8i,
> as well as the integrated Intel LSI controllers) as well as Adaptec
> Series 7 RAID controllers (72405 and 71685).
> 
> Normally I'll setup the RAIDs as RAID60 and format them as XFS, but
> the exact RAID level, filesystem type, and even RAID hardware don't
> seem to matter very much from my observations (but I'm willing to
> try any suggestions).

Document them. There's many ways to screw them up and get bad
performance.

> As a basic benchmark, I have an application
> that simply writes the same buffer (say, 128MB) to disk repeatedly.
> Alternatively you could use the "dd" utility.  (For these
> benchmarks, I set /proc/sys/vm/dirty_bytes to 512M or lower, since
> these systems have a lot of RAM.)
> 
> The basic observations are:
> 
> 1.  "single-threaded" writes, either a file on the mounted
> filesystem or with a "dd" to the raw RAID device, seem to be limited
> to 1200-1400MB/sec.  These numbers vary slightly based on whether
> TurboBoost is affecting the writing process or not.  "top" will show
> this process running at 100% CPU.

Expected. You are using buffered IO. Write speed is limited by the
rate at which your user process can memcpy data into the page cache.

> 2.  With two benchmarks running on the same device, I see aggregate
> write speeds of up to ~2.4GB/sec, which is closer to what I'd expect
> the drives of being able to deliver.  This can either be with two
> applications writing to separate files on the same mounted file
> system, or two separate "dd" applications writing to distinct
> locations on the raw device.  (Increasing the number of writers
> beyond two does not seem to increase aggregate performance; "top"
> will show both processes running at perhaps 80% CPU).

Still using buffered IO, which means you are typically limited by
the rate at which the flusher thread can do writeback.

> 3.  I haven't been able to find any tricks (lio_listio, multiple
> threads writing to distinct file offsets, etc) that seem to deliver
> higher write speeds when writing to a single file.  (This might be
> xfs-specific, though)

How about using direct IO? Single threaded direct IO will beslower
than buffered IO, but throughput should scale linearly with the
number of threads if the IO size is large enough (e.g. 32MB).

> 4.  Cheap tricks like making a software RAID0 of two hardware RAID
> devices does not deliver any improved performance for
> single-threaded writes.  (Have not thoroughly tested this
> configuration fully with multiple writers, though.)

Of course not - you are CPU bound and nothing you do to the storage
will change that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
