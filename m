Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbaGCCcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:32:10 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:29541 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547AbaGCCcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:32:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqBaAHy/tFN5LHZ8PGdsb2JhbABagw2DSoUIpBkBAgEBB5pVgQgXBAEBAQE4NYREHCMYJDQFJQMHLYhBx2kYhViGDQGCW0mESgWabJYMgVQrgTI
Date: Thu, 3 Jul 2014 12:32:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: Davidlohr Bueso <davidlohr@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: [regression, 3.16-rc] rwsem: optimistic spinning causing performance
 degradation
Message-ID: <20140703023204.GN4453@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I've got a workload that hammers the mmap_sem via multi-threads
memory allocation and page faults: it's called xfs_repair. I've been
debugging problems with the latest release, and in the process of
tracking down some recent regressions I noticed that turning off all
the cross-ag IO concurrency resulted in the repair running about
4-5x faster.

i.e.:

# time xfs_repair -f -vv fs.img
.....

        XFS_REPAIR Summary    Thu Jul  3 11:51:41 2014

Phase           Start           End             Duration
Phase 1:        07/03 11:47:15  07/03 11:47:15
Phase 2:        07/03 11:47:15  07/03 11:47:35  20 seconds
Phase 3:        07/03 11:47:35  07/03 11:51:26  3 minutes, 51 seconds
Phase 4:        07/03 11:51:26  07/03 11:51:31  5 seconds
Phase 5:        07/03 11:51:31  07/03 11:51:31
Phase 6:        07/03 11:51:31  07/03 11:51:39  8 seconds
Phase 7:        07/03 11:51:39  07/03 11:51:39

Total run time: 4 minutes, 24 seconds
done

real    4m26.399s
user    1m6.023s
sys     27m26.707s
$

And turning off AG striding:

# time xfs_repair -f -vv -o ag_stride=-1 fs.img
.....
        XFS_REPAIR Summary    Thu Jul  3 11:41:28 2014

Phase           Start           End             Duration
Phase 1:        07/03 11:40:27  07/03 11:40:27  
Phase 2:        07/03 11:40:27  07/03 11:40:36  9 seconds
Phase 3:        07/03 11:40:36  07/03 11:41:12  36 seconds
Phase 4:        07/03 11:41:12  07/03 11:41:17  5 seconds
Phase 5:        07/03 11:41:17  07/03 11:41:18  1 second
Phase 6:        07/03 11:41:18  07/03 11:41:25  7 seconds
Phase 7:        07/03 11:41:25  07/03 11:41:25  

Total run time: 58 seconds
done

real    0m59.893s
user    0m41.935s
sys     4m55.867s
$

The difference is in phase 2 and 3, which is where all the memory
allocation and IO that populates the userspace buffer cache takes
place. The remainder of the phases run from the cache. All IO is
direct IO, so there is no kernel caching at all. The filesystem
image has a lot of metadata in it - it has 336 AGs and the buffer
cache grows to about 6GB in size during phase 3.

The difference in performance is in the system CPU time, and it
results directly in lower IO dispatch rates - about 2,000 IOPS
instead of ~12,000.

This is what the kernel profile looks like on the strided run:

-  83.06%  [kernel]  [k] osq_lock
   - osq_lock
      - 100.00% rwsem_down_write_failed
         - call_rwsem_down_write_failed
            - 99.55% sys_mprotect
                 tracesys
                 __GI___mprotect
-  12.02%  [kernel]  [k] rwsem_down_write_failed
     rwsem_down_write_failed
     call_rwsem_down_write_failed
+   1.09%  [kernel]  [k] _raw_spin_unlock_irqrestore
+   0.92%  [kernel]  [k] _raw_spin_unlock_irq
+   0.68%  [kernel]  [k] __do_softirq
+   0.33%  [kernel]  [k] default_send_IPI_mask_sequence_phys
+   0.10%  [kernel]  [k] __do_page_fault

Basically, all the kernel time is spent processing lock contention
rather than doing real work.

I haven't tested back on 3.15 yet, but historically the strided AG
repair for such filesystems (which I test all the time on 100+500TB
filesystem images) is about 20-25% faster on this storage subsystem.
Yes, the old code also burnt a lot of CPU due to lock contention,
but it didn't go 5x slower than having no threading at all.

So this looks like a significant performance regression due to:

4fc828e locking/rwsem: Support optimistic spinning

which changed the rwsem behaviour in 3.16-rc1.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
