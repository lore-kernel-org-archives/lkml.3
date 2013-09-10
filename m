Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3IJGP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 02:15:28 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:12854 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353Ab3IJGP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 02:15:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj4IAMa3LlJ5Lapl/2dsb2JhbABbgweDSro4hTeBKRd0giUBAQU6HCMQCAMOBgQJJQ8FJQMhE4gBwlAWgwWMQAeDHYEAA5d1ijSHOIFjgU8q
Date: Tue, 10 Sep 2013 16:15:20 +1000
From: Dave Chinner <david@fromorbit.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [performance regression, bisected] scheduler:
 should_we_balance() kills filesystem performance
Message-ID: <20130910061520.GC12779@dastard>
References: <20130910040254.GB12779@dastard>
 <20130910044759.GA24602@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910044759.GA24602@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 01:47:59PM +0900, Joonsoo Kim wrote:
> On Tue, Sep 10, 2013 at 02:02:54PM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > I just updated my performance test VM to the current 3.12-git
> > tree after the XFS dev branch was merged. The first test I ran
> > which was a 16-way concurrent fsmark test to create lots of files
> > gave me a number about 30% lower than I expected - ~180k files/s
> > when I was expecting somewhere around 250k files/s.
> > 
> > I did a bisect, and the bisect landed on this commit:
> > 
> > commit 23f0d2093c789e612185180c468fa09063834e87
> > Author: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > Date:   Tue Aug 6 17:36:42 2013 +0900
> > 
> >     sched: Factor out code to should_we_balance()
.....
> > 
> > 			v4 filesystem		v5 filesystem
> > 3.11+xfsdev:		220k files/s		225k files/s
> > 3.12-git		180k files/s		185k files/s
> > 3.12-git-revert		245k files/s		247k files/s
> > 
> > The test vm is a 16p/16GB RAM VM, with a sparse 100TB filesystem
> > image sitting on a 4-way RAID0 SSD array formatted with XFS and the
> > image file is accessed by virtio+direct IO. The fsmark command line
> > is:
> > 
> > time ./fs_mark  -D  10000  -S0  -n  100000  -s  0  -L  32 \
> >         -d  /mnt/scratch/0  -d  /mnt/scratch/1 \
> >         -d  /mnt/scratch/2  -d  /mnt/scratch/3 \
> >         -d  /mnt/scratch/4  -d  /mnt/scratch/5 \
> >         -d  /mnt/scratch/6  -d  /mnt/scratch/7 \
> >         -d  /mnt/scratch/8  -d  /mnt/scratch/9 \
> >         -d  /mnt/scratch/10  -d  /mnt/scratch/11 \
> >         -d  /mnt/scratch/12  -d  /mnt/scratch/13 \
> >         -d  /mnt/scratch/14  -d  /mnt/scratch/15 \
> >         | tee >(stats --trim-outliers | tail -1 1>&2)
> > 
> > The workload on XFS runs to almost being CPU bound - the effect of
> > the above patch was that there was a lot of idle time left in the
> > system. The workload consumed the same amount of user and system
> > CPU, just instantaneous CPU usage was reduced by 20-30% and the
> > elaspsed time was increased by 20-30%.
> 
> Hello, Dave.
> 
> Now, I look again this patch and find one mistake.
> If we find that we are appropriate cpu for balancing, should_we_balance()
> should return 1. But current code doesn't do so. This correspond with
> your observation that a lot of idle time left.
> 
> Could you re-test your benchmark with below?

Sure. It looks like your patch fixes the problem:

			v4 filesystem		v5 filesystem
3.11+xfsdev:		220k files/s		225k files/s
3.12-git		180k files/s		185k files/s
3.12-git-revert		245k files/s		247k files/s
3.12-git-fix		249k files/s		248k files/s

Thanks for the quick turnaround :)

Tested-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
