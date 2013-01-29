Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3A2IYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 03:24:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:2525 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494Ab3A2IYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 03:24:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,557,1355126400"; 
   d="scan'208";a="249598312"
Date: Tue, 29 Jan 2013 16:25:37 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        lkp@linux.intel.com
Subject: aim7 performance regression by commit 5a50508 report from LKP
Message-ID: <20130129082537.GS12678@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here we, LKP(Linux Kernel Performance, a project to do performance
benchmark testing for Linux kernel, and try to find and fix the
performance regressions), found a 10%-20% performance regression
of aim7 benchmark introduced by commit 5a50508: "mm/rmap: Convert
the struct anon_vma::mutex to an rwsem".

It is quite easy to reproduce such regression with the workload of
workfile.shared in aim7 benchmark[0]. More, you will see more
obvious performance drop by setting fork_test as the only one
workload; the performance drops 2-4 times on our test boxes.

And here is the workfile you can see a obvious performance drop:

----------- workfile ----------
FILESIZE: 1M
POOLSIZE: 10M
10 fork_test
-------------------------------

Commit 5a50508 just convert all mutex lock to down_write, which, in
my opinion, is the same in semantics. While, the result is quite
different on the above workload.

I tried to figure out the root cause, and did some tests and took
some performance counters. Say, here is some /usr/bin/time output:

commit d28d433(good one, the commit before 5a50508):
-------------------------
  User time (seconds): 76.12
  System time (seconds): 4387.35
  Percent of CPU this job got: 599%
  Voluntary context switches: 191800723
  Involuntary context switches: 41312548

commit 5a50508(bad one):
------------------------
  User time (seconds): 98.20
  System time (seconds): 5623.07
  Percent of CPU this job got: 373%
  Voluntary context switches: 615474680
  Involuntary context switches: 20388913


Where you can see:
 1. CPU is much idler at commit 5a50508 than d28d433 (373% vs 599%)

 2. Involves more voluntary context switches at commit 5a50508 than
    d28d433(615474680 vs 191800723), which is about 3.2 times.


The performance drop and above data troubles me a lot, as I do think
rwsem write lock and mutex is the same.

I then tried to check the difference between mutex and rwsem
implementation, and found the key difference and I guess that is the
root cause:

It's about the condition how we quit the for(;;) loop, more accurate,
how to detect we got the lock.

mutex side
==========
In __mutex_lock_common:

        for (;;) {
                if (atomic_xchg(&lock->count, -1) == 1)
                        break;
        }
        ....

In __mutex_unlock_common_slowpath

        atomic_set(&lock->count, 1);
        wake_up_process(waiter->task);


rwsem side
==========
In rwsem_down_failed_common(lock part):

        waiter->task = current;
        ....

        for (;;) {
                if (!waiter.task)
                        break;
        }

In __rwsem_do_wake(unlock part):

        list_del(&waiter->list);
        tsk = waiter->task;
        smp_mb();
        waiter->task = NULL;
        wake_up_process(tsk);


Summary
=======
In a simple word: mutex use lock->count to detect if we can get a lock
or not, while rwsem checks waiter->task. And that is the key problem.

Say, assume processes A, B, tried to get the mutex lock in that order,

So, A got it first, then B is blocked(went to sleep by calling schedule
voluntarily). After a while, A put the lock by setting lock->count to 1
and calling wake_up_process() to wake up B. While before B is woke up,
another process C tries to get the mutex. And C will find the condition
of following is true:

        if (atomic_xchg(&lock->count, -1) == 1)
		break;

Then C will get the lock bypassing B. In such case, one schedule is saved.

While, you will see no bypass getting lock with rwsem, as all process
are put into that wait list in order and wake up in order.

And that's why you saw more voluntary context switch with rwsem write lock
than mutex.

"This can't explain '1. CPU is much idler at commit 5a50508 than
d28d433 (373% vs 599%)' well", added by Huang Ying. He suggests to look
this issue from another side: who owns the lock.

As stated above, anybody can have a chance to own the lock in mutex once
somebody release the lock. Well, there is only one to own the lock in
rwsem write lock, and the one is known already: the one in the head of
wait list. That would result to more contention in rwsem write lock case,
especially if the one _will_ own the lock is not running now.

He also suggested to get some scheduler data, here I sampled some data
from /proc/sched_debug. And the following  is a data list of .nr_running
filed for all CPUs:

commit d28d433(good one):
            (sampled per 2 seconds, just few of them are showed)
------------------------------------------------------------------------------------->
cpu 00:   0   0   ... 102 103  99 110 105 100 104 108 106  98 103 103 ....  98  40  38 
cpu 01:   0   0   ... 103 103  99 110 106 100 104 108 106  98 103 103 ....  98  40  38 
cpu 02:   0   0   ... 106 112 114 104 109 112 107 105 110 109 104 102 .... 109  41  42 
cpu 03:   0   0   ... 106 112 114 104 109 113 107 106 110 109 104 102 .... 109  41  42 
cpu 04:   0   0   ...  95 106 102  98 102 102 102 109 105  93  91 103 ....  98  39  38 
cpu 05:   0   0   ...  95 107 102  98 102 102 103 109 105  93  91 103 ....  99  39  38 
cpu 06:   0   0   ... 106 109 115 111 108 108 102 100 107  99 101 103 .... 110  42  44 
cpu 07:   0   0   ... 107 109 116 111 109 108 102 100 107  99 102 103 .... 110  42  44 
cpu 08:   0   0   ... 106 114 108 104 107 102 108  98 102  96  97  98 ....  99  39  40 
cpu 09:   0   0   ... 106 114 108 104 107 102 108  98 102  96  97  98 ....  99  39  40 
cpu 10:   0   0   ... 111 106 107 109 106 113 111 108 110 101 100 108 .... 104  40  39 
cpu 11:   0   0   ... 111 106 107 109 106 113 112 108 110 101 100 108 .... 104  40  39 
cpu 12:   0   1   ...  96 107 109 109 108 103 105  98 100  93  92  98 ....  98  41  42 
cpu 13:   0   1   ...  96 108 109 109 108 103 105  98 100  93  92  98 ....  98  41  42 
cpu 14:   0   0   ... 102 113 108 102 105 101 105 106 108 101 103 111 .... 113  42  43 
cpu 15:   0   0   ... 102 113 108 102 106 101 105 106 109 101 103 111 .... 114  42  43 

commit 5a50508(bad one):
            (sampled per 2 seconds, just few of them are showed)
------------------------------------------------------------------------------------->
cpu 00:   0   0   ...   0   1   0   1   0   1   0   0   0   0   2   0 ....   0   0   0 
cpu 01:   0   0   ...   0   2   0   0   0   1   0   0   1   0   2   0 ....   0   0   1 
cpu 02:   0   0   ...   0   0   0   0   0   0   0   1   1   0   0   0 ....   0   1   2 
cpu 03:   0   0   ...   0   0   0   0   0   0   1   1   1   0   0   0 ....   1   1   0 
cpu 04:   0   0   ...   0   0   0   0   0   0   1   0   1   0   0   1 ....   0   0   2 
cpu 05:   0   0   ...   0   0   0   0   0   0   0   1   1   0   0   1 ....   0   0   2 
cpu 06:   0   1   ...   0   1   1   0   0   1   3   0   2   1   0   0 ....   1   1   0 
cpu 07:   0   1   ...   0   1   0   0   0   0   3   0   2   1   0   0 ....   1   1   0 
cpu 08:   0   0   ...   0   0   2   1   0   1   0   0   0   0   0   1 ....   0   0   0 
cpu 09:   0   0   ...   0   1   0   1   0   1   0   1   0   0   0   1 ....   0   0   0 
cpu 10:   0   0   ...   0   0   2   1   0   0   1   1   0   1   0   1 ....   0   0   0 
cpu 11:   0   0   ...   0   0   2   1   0   0   1   0   0   1   0   1 ....   0   0   0 
cpu 12:   0   0   ...   2   2   0   1   2   0   1   0   0   0   0   2 ....   1   0   2 
cpu 13:   0   0   ...   2   2   1   1   2   0   1   0   0   0   0   1 ....   2   0   2 
cpu 14:   0   0   ...   0   0   2   1   0   1   0   0   0   0   0   1 ....   0   1   1 
cpu 15:   0   0   ...   0   0   1   1   0   0   2   1   0   0   0   1 ....   0   1   0 

As you can see, the difference is huge! And you can see that in commit
d28d433, all CPUs are always busy! While in commit 5a50508, about half of
CPUs are idle. That matches the result well.


NOTE: this is just a report to let you be aware that we caught a such
regression and wrote what we think may cause the regression. We don't
mean to revert such commit as we know it aimed to make rmap_walk_anon()
and try_to_unmap_anon() more scalable.


[0]: http://aimbench.cvs.sourceforge.net/viewvc/aimbench/caldera/suite7/workfile.shared?view=markup

--
Linux Kernel Performance (LKP) project        Open Source Technology Center
                                                          Intel Corporation
