Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab3IJEDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 00:03:04 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:40889 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553Ab3IJEDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 00:03:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArIGAFaZLlJ5Lapl/2dsb2JhbABbgweDSro0hTeBKRd0gjosHA8NBxgXDTQFJQM0iAHCfRaDBYxQHYMHgQADl3SKMIc3gWOBTyo
Date: Tue, 10 Sep 2013 14:02:54 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Paul Turner <pjt@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [performance regression, bisected] scheduler: should_we_balance()
 kills filesystem performance
Message-ID: <20130910040254.GB12779@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I just updated my performance test VM to the current 3.12-git
tree after the XFS dev branch was merged. The first test I ran
which was a 16-way concurrent fsmark test to create lots of files
gave me a number about 30% lower than I expected - ~180k files/s
when I was expecting somewhere around 250k files/s.

I did a bisect, and the bisect landed on this commit:

commit 23f0d2093c789e612185180c468fa09063834e87
Author: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date:   Tue Aug 6 17:36:42 2013 +0900

    sched: Factor out code to should_we_balance()
    
    Now checking whether this cpu is appropriate to balance or not
    is embedded into update_sg_lb_stats() and this checking has no direct
    relationship to this function. There is not enough reason to place
    this checking at update_sg_lb_stats(), except saving one iteration
    for sched_group_cpus.
....

Now, i couldn't revert that patch by itself, but I reverted the
series of about 10 scheduler patches in that series total from a
current TOT and the regression went away. Hence I'm pretty confident
that the this is the patch causing the issue as i've verified it in
more than one way and the difference between "good" and "bad" was
signficantlt greater than the variance of the test (1.5-2 stddev
difference).

In more detail:

			v4 filesystem		v5 filesystem
3.11+xfsdev:		220k files/s		225k files/s
3.12-git		180k files/s		185k files/s
3.12-git-revert		245k files/s		247k files/s

The test vm is a 16p/16GB RAM VM, with a sparse 100TB filesystem
image sitting on a 4-way RAID0 SSD array formatted with XFS and the
image file is accessed by virtio+direct IO. The fsmark command line
is:

time ./fs_mark  -D  10000  -S0  -n  100000  -s  0  -L  32 \
        -d  /mnt/scratch/0  -d  /mnt/scratch/1 \
        -d  /mnt/scratch/2  -d  /mnt/scratch/3 \
        -d  /mnt/scratch/4  -d  /mnt/scratch/5 \
        -d  /mnt/scratch/6  -d  /mnt/scratch/7 \
        -d  /mnt/scratch/8  -d  /mnt/scratch/9 \
        -d  /mnt/scratch/10  -d  /mnt/scratch/11 \
        -d  /mnt/scratch/12  -d  /mnt/scratch/13 \
        -d  /mnt/scratch/14  -d  /mnt/scratch/15 \
        | tee >(stats --trim-outliers | tail -1 1>&2)

The workload on XFS runs to almost being CPU bound - the effect of
the above patch was that there was a lot of idle time left in the
system. The workload consumed the same amount of user and system
CPU, just instantaneous CPU usage was reduced by 20-30% and the
elaspsed time was increased by 20-30%.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
