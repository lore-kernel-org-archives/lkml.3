Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaCLXtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 19:49:12 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:36144 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbaCLXtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 19:49:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At9oAAnxIFN5LJYePGdsb2JhbABZgwY7iBehHgSYeYEdFwMBAQEBHxkNKIIhBAEBAQQ6HCMQCAMYCSUPBSUDBxoThUmCDyDTMhaORgeEOASYRJVvKQ
Date: Thu, 13 Mar 2014 10:48:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <waiman.long@hp.com>, arnd@arndb.de,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, walken@google.com, andi@firstfloor.org,
        riel@redhat.com, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, oleg@redhat.com
Subject: Re: [RFC][PATCH 0/7] locking: qspinlock
Message-ID: <20140312234857.GG13647@dastard>
References: <20140310154236.038181843@infradead.org>
 <20140312023153.GW13647@dastard>
 <20140312061503.GH30956@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312061503.GH30956@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 07:15:03AM +0100, Peter Zijlstra wrote:
> On Wed, Mar 12, 2014 at 01:31:53PM +1100, Dave Chinner wrote:
> > With the queuing spinlock, I expected to see somewhat better
> > results, but I didn't at first. Turns out if you have any sort of
> > lock debugging turned on, then the code doesn't ever go into the
> > lock slow path and hence does not ever enter the "lock failed" slow
> > path where all the contention fixes are supposed to be.
> 
> Yeah; its a 'feature' of the spinlock debugging to turn all spinlocks
> into test-and-set thingies.
> 
> > Anyway, with all lock debugging turned off, the system hangs
> > the instant I start the multithreaded bulkstat workload. Even the
> > console is unrepsonsive. 
> 
> Oops, I only briefly tested this series in userspace and that seemed to
> work. I'll go prod at it. Thanks for having a look though.
> 
> Is that bstat test any easier/faster to setup/run than the aim7 crap?

Depends. I've got a VM setup with a sparse 100TB block device hosted
on SSDs where I can create 50M inodes using fsmark in about 3
and half minutes. I also have a hacked xfstests::src/bstat.c that is
multithreaded that I then run and it triggers it staight away.

Quite frankly, you don't need bulkstat to produce this lock
contention - you'll see it running this on a wide directory
structure on XFS and an SSD:

$ cat ~/tests/walk-scratch.sh 
#!/bin/bash

echo Walking via find -ctime
echo 3 > /proc/sys/vm/drop_caches
time (
        for d in /mnt/scratch/[0-9]* ; do

                for i in $d/*; do
                        (
                                echo $i
                                find $i -ctime 1 > /dev/null
                        ) > /dev/null 2>&1
                done &
        done
        wait
)

echo Walking via ls -R
echo 3 > /proc/sys/vm/drop_caches
time (
        for d in /mnt/scratch/[0-9]* ; do

                for i in $d/*; do
                        (
                                echo $i
                                ls -R $i
                        ) > /dev/null 2>&1
                done &
        done
        wait
)
$

The directory structure I create has 16 top level directories (0-15)
each with 30-40 subdirectories containing 100,000 files each.
There's a thread per top level directory, and running it on a 16p VM
and an SSD that can do 30,000 IOPS will generate sufficient inode
cache pressure to trigger severe lock contention.

My usual test script for this workload runs mkfs, fsmark,
xfs_repair, bstat, walk-scratch, and finally a multi-threaded rm to
clean up. Usual inode numbers are in the 50-100million for zero
length file workloads, 10-20 million for single block (small) files,
and 100,000-1million for larger files. it's great for stressing VFs,
FS and IO level scalability...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
