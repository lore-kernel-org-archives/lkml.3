Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3F1BS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 21:18:56 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:27544 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773Ab3F1BSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 21:18:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvcOAGjjzFF5LB/8/2dsb2JhbABbgwmDGLdIhSEEAYEBF3SCIwEBBAEnExwoCwgDGAklDwUlAyEBEogIBbtQFo4XC4EkgwJjA5dEkUaDIyo
Date: Fri, 28 Jun 2013 11:18:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130628011843.GD32195@dastard>
References: <20130623143634.GA2000@redhat.com>
 <20130623150603.GA32313@redhat.com>
 <20130623160452.GA11740@redhat.com>
 <20130624155758.GA5993@redhat.com>
 <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627143055.GA1000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627143055.GA1000@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 10:30:55AM -0400, Dave Jones wrote:
> On Thu, Jun 27, 2013 at 05:55:43PM +1000, Dave Chinner wrote:
>  
>  > Is this just a soft lockup warning? Or is the system hung?
>  
> I've only seen it completely lock up the box 2-3 times out of dozens
> of times I've seen this, and tbh that could have been a different bug.
> 
>  > I mean, what you see here is probably sync_inodes_sb() having called
>  > wait_sb_inodes() and is spinning on the inode_sb_list_lock.
>  > 
>  > There's nothing stopping multiple sys_sync() calls from executing on
>  > the same superblock simulatenously, and if there's lots of cached
>  > inodes on a single filesystem and nothing much to write back then
>  > concurrent sync() calls will enter wait_sb_inodes() concurrently and
>  > contend on the inode_sb_list_lock.
>  > 
>  > Get enough sync() calls running at the same time, and you'll see
>  > this. e.g. I just ran a parallel find/stat workload over a
>  > filesystem with 50 million inodes in it, and once that had reached a
>  > steady state of about 2 million cached inodes in RAM:
>  
> It's not even just sync calls it seems. Here's the latest victim from
> last nights overnight run, failing in hugetlb mmap.
> Same lock, but we got there by different way. (I suppose it could be
> that the other CPUs were running sync() at the time of this mmap call)

Right, that will be what is happening - the entire system will go
unresponsive when a sync call happens, so it's entirely possible
to see the soft lockups on inode_sb_list_add()/inode_sb_list_del()
trying to get the lock because of the way ticket spinlocks work...

>  > I didn't realise that just calling sync caused this lock contention
>  > problem until I read this thread, so fixing this just went up
>  > several levels of priority given the affect an unprivileged user can
>  > have on the system just by running lots of concurrent sync calls.
>  > 
>  > > I'll work on trying to narrow down what trinity is doing. That might at least
>  > > make it easier to reproduce it in a shorter timeframe.
>  > 
>  > This is only occurring on your new machines, right? They have more
>  > memory than your old machines, and faster drives? So the caches are
>  > larger and the IO completion faster? Those combinations will put
>  > more pressure on wait_sb_inodes() from concurrent sync operations...
> 
> Sounds feasible.  Maybe I should add something to trinity to create more
> dirty pages, perhaps that would have triggered this faster.

Creating more cached -clean, empty- inodes will make it happen
faster. The trigger for long lock holds is clean inodes that have no
cached pages (i.e. hit the mapping->nr_pages == 0 shortcut) on them...

> 8gb ram, 80MB/s SSD's, nothing exciting there (compared to my other machines)
> so I think it's purely down to the CPUs being faster, or some other architectural
> improvement with Haswell that increases parallelism.

Possibly - I'm reproducing it here with 8GB RAM, and the disk speed
doesn't realy matter as I'm seeing it with workload that doesn't
dirty any data or inodes at all...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
