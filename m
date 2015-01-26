Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbbAZHgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 02:36:42 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:52174 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbbAZHgl (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 26 Jan 2015 02:36:41 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Michel Lespinasse <walken@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH -tip 0/6] rwsem: Fine tuning
Date: Sun, 25 Jan 2015 23:36:03 -0800
Message-Id: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

First two patches are self descriptive obvious add-ons.

The rest are performance enhancements for write-mostly workloads.
While this is not our priority (use mutexes instead!!), there are
cases where heavy use of writers can severly hurt rwsem performance.
For instace, we got reports[1] of writer only issues when converting
the i_mmap_rwsem from mutex, on a workload that pathologically pounds
on this lock for vma operations:

-     81.20%           execl  [kernel.kallsyms]     [k] osq_lock
      - 100.00% mutex_optimistic_spin                                                                                                   
           __mutex_lock_slowpath                                                                                                        
         - mutex_lock                                                                                                                   
            + 47.71% unlink_file_vma                                                                                                    
            + 34.91% vma_adjust                                                                                                         
            + 17.38% vma_link

This is enough to make small differences painfully evident. These changes
(particularly patch 6/6) recover most (~75%) of the performance regression.
Patches 4 and 6 deal with optimistic spinning fine tunning, while patch
5 is an attempt to get tid of two barriers when blocking. While I believe
this is safe, it certainly needs more eyeballs, I could have easily overlooked
something. Most of these changes are straighforward, but have various implications.

Passes multiple x86-64 tests.

Thanks!

[1] https://lkml.org/lkml/2015/1/7/884

Davidlohr Bueso (6):
  locking/rwsem: Use task->state helpers
  locking/rwsem: Document barrier need when waking tasks
  locking/rwsem: Set lock ownership ASAP
  locking/rwsem: Avoid deceiving lock spinners
  locking/rwsem: Optimize slowpath/sleeping
  locking/rwsem: Check for active lock before bailing on spinning

 kernel/locking/mutex.c          |  2 +-
 kernel/locking/rwsem-spinlock.c |  7 +++-
 kernel/locking/rwsem-xadd.c     | 71 +++++++++++++++++++++++++++++------------
 kernel/locking/rwsem.c          | 22 +------------
 kernel/locking/rwsem.h          | 20 ++++++++++++
 5 files changed, 78 insertions(+), 44 deletions(-)
 create mode 100644 kernel/locking/rwsem.h

-- 
2.1.2

