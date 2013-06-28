Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab3F1BNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 21:13:09 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:25141 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773Ab3F1BNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 21:13:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvcOAP/hzFF5LB/8/2dsb2JhbABbgwmDGLdIhSEEAYEBF3SCIwEBBAEnExwoCwgDGAklDwUlAyEBEogIBbtPFo4igSSDAmMDk3ODUZFGgyMq
Date: Fri, 28 Jun 2013 11:13:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130628011301.GC32195@dastard>
References: <20130623160452.GA11740@redhat.com>
 <20130624155758.GA5993@redhat.com>
 <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627100612.GA29338@dastard>
 <20130627125218.GB32195@dastard>
 <20130627152151.GA11551@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627152151.GA11551@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 11:21:51AM -0400, Dave Jones wrote:
> On Thu, Jun 27, 2013 at 10:52:18PM +1000, Dave Chinner wrote:
>  
>  
>  > > Yup, that's about three of orders of magnitude faster on this
>  > > workload....
>  > > 
>  > > Lightly smoke tested patch below - it passed the first round of
>  > > XFS data integrity tests in xfstests, so it's not completely
>  > > busted...
>  > 
>  > And now with even less smoke out that the first version. This one
>  > gets though a full xfstests run...
> 
> :sadface:
> 
> [  567.680836] ======================================================
> [  567.681582] [ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
> [  567.682389] 3.10.0-rc7+ #9 Not tainted
> [  567.682862] ------------------------------------------------------
> [  567.683607] trinity-child2/8665 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> [  567.684464]  (&sb->s_type->i_lock_key#3){+.+...}, at: [<ffffffff811d74e5>] sync_inodes_sb+0x225/0x3b0
> [  567.685632] 
> and this task is already holding:
> [  567.686334]  (&(&wb->wb_list_lock)->rlock){..-...}, at: [<ffffffff811d7451>] sync_inodes_sb+0x191/0x3b0
> [  567.687506] which would create a new lock dependency:
> [  567.688115]  (&(&wb->wb_list_lock)->rlock){..-...} -> (&sb->s_type->i_lock_key#3){+.+...}

.....

> other info that might help us debug this:
> 
> [  567.750396]  Possible interrupt unsafe locking scenario:
> 
> [  567.752062]        CPU0                    CPU1
> [  567.753025]        ----                    ----
> [  567.753981]   lock(&sb->s_type->i_lock_key#3);
> [  567.754969]                                local_irq_disable();
> [  567.756085]                                lock(&(&wb->wb_list_lock)->rlock);
> [  567.757368]                                lock(&sb->s_type->i_lock_key#3);
> [  567.758642]   <Interrupt>
> [  567.759370]     lock(&(&wb->wb_list_lock)->rlock);

Oh, that's easy enough to fix. It's just changing the wait_sb_inodes
loop to use a spin_trylock(&inode->i_lock), moving the inode to
the end of the sync list, dropping all locks and starting again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
