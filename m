Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3IJGye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 02:54:34 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54544 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab3IJGyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 02:54:32 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-6a-522ec2261ee7
Date: Tue, 10 Sep 2013 15:54:49 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [performance regression, bisected] scheduler:
 should_we_balance() kills filesystem performance
Message-ID: <20130910065448.GA20368@lge.com>
References: <20130910040254.GB12779@dastard>
 <20130910044759.GA24602@lge.com>
 <20130910061520.GC12779@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910061520.GC12779@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 04:15:20PM +1000, Dave Chinner wrote:
> On Tue, Sep 10, 2013 at 01:47:59PM +0900, Joonsoo Kim wrote:
> > On Tue, Sep 10, 2013 at 02:02:54PM +1000, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > I just updated my performance test VM to the current 3.12-git
> > > tree after the XFS dev branch was merged. The first test I ran
> > > which was a 16-way concurrent fsmark test to create lots of files
> > > gave me a number about 30% lower than I expected - ~180k files/s
> > > when I was expecting somewhere around 250k files/s.
> > > 
> > > I did a bisect, and the bisect landed on this commit:
> > > 
> > > commit 23f0d2093c789e612185180c468fa09063834e87
> > > Author: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > > Date:   Tue Aug 6 17:36:42 2013 +0900
> > > 
> > >     sched: Factor out code to should_we_balance()
> .....
> > > 
> > > 			v4 filesystem		v5 filesystem
> > > 3.11+xfsdev:		220k files/s		225k files/s
> > > 3.12-git		180k files/s		185k files/s
> > > 3.12-git-revert		245k files/s		247k files/s
> > > 
> > > The test vm is a 16p/16GB RAM VM, with a sparse 100TB filesystem
> > > image sitting on a 4-way RAID0 SSD array formatted with XFS and the
> > > image file is accessed by virtio+direct IO. The fsmark command line
> > > is:
> > > 
> > > time ./fs_mark  -D  10000  -S0  -n  100000  -s  0  -L  32 \
> > >         -d  /mnt/scratch/0  -d  /mnt/scratch/1 \
> > >         -d  /mnt/scratch/2  -d  /mnt/scratch/3 \
> > >         -d  /mnt/scratch/4  -d  /mnt/scratch/5 \
> > >         -d  /mnt/scratch/6  -d  /mnt/scratch/7 \
> > >         -d  /mnt/scratch/8  -d  /mnt/scratch/9 \
> > >         -d  /mnt/scratch/10  -d  /mnt/scratch/11 \
> > >         -d  /mnt/scratch/12  -d  /mnt/scratch/13 \
> > >         -d  /mnt/scratch/14  -d  /mnt/scratch/15 \
> > >         | tee >(stats --trim-outliers | tail -1 1>&2)
> > > 
> > > The workload on XFS runs to almost being CPU bound - the effect of
> > > the above patch was that there was a lot of idle time left in the
> > > system. The workload consumed the same amount of user and system
> > > CPU, just instantaneous CPU usage was reduced by 20-30% and the
> > > elaspsed time was increased by 20-30%.
> > 
> > Hello, Dave.
> > 
> > Now, I look again this patch and find one mistake.
> > If we find that we are appropriate cpu for balancing, should_we_balance()
> > should return 1. But current code doesn't do so. This correspond with
> > your observation that a lot of idle time left.
> > 
> > Could you re-test your benchmark with below?
> 
> Sure. It looks like your patch fixes the problem:
> 
> 			v4 filesystem		v5 filesystem
> 3.11+xfsdev:		220k files/s		225k files/s
> 3.12-git		180k files/s		185k files/s
> 3.12-git-revert		245k files/s		247k files/s
> 3.12-git-fix		249k files/s		248k files/s
> 
> Thanks for the quick turnaround :)
> 
> Tested-by: Dave Chinner <dchinner@redhat.com>
> 

Thanks for the quick turnaround, too. :)

Hello, Ingo.

I attach the formatted patch with proper SOBs and commit message.
Please merge this to fix above problem.

Thanks.

--------------------->8-------------------------
>From cf8ca492c2206e72d91ca0a1f6c59c5436132c61 Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Tue, 10 Sep 2013 15:28:10 +0900
Subject: [PATCH] sched: return 1 if this cpu is proper for balancing in
 should_we_balance()

Commit 23f0d20('sched: Factor out code to should_we_balance()') introduces
should_we_balance() function. This function should return 1 if this cpu is
appropriate for balancing. But current code doesn't do so. When this
happens, it returns 0, instead of 1.

This introduces performance regression which Dave Chinner reports.

                        v4 filesystem           v5 filesystem
3.11+xfsdev:            220k files/s            225k files/s
3.12-git                180k files/s            185k files/s
3.12-git-revert         245k files/s            247k files/s

You can find more detailed information in below link.
https://lkml.org/lkml/2013/9/10/1

This patch corrects the return value of should_we_balance() function
as orignally intended.

With this patch, Dave Chinner said that regression are gone.

                        v4 filesystem           v5 filesystem
3.11+xfsdev:            220k files/s            225k files/s
3.12-git                180k files/s            185k files/s
3.12-git-revert         245k files/s            247k files/s
3.12-git-fix            249k files/s            248k files/s

Reported-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7f0a5e6..9b3fe1c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5151,7 +5151,7 @@ static int should_we_balance(struct lb_env *env)
 	 * First idle cpu or the first cpu(busiest) in this sched group
 	 * is eligible for doing load balancing at this and above domains.
 	 */
-	return balance_cpu != env->dst_cpu;
+	return balance_cpu == env->dst_cpu;
 }
 
 /*
-- 
1.7.9.5

