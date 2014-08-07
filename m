Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbaHGW1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 18:27:00 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:15426 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaHGW05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 18:26:57 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v2 0/7] locking/rwsem: enable reader opt-spinning & writer respin
Date: Thu,  7 Aug 2014 18:26:41 -0400
Message-Id: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2:
 - Remove patch 1 which changes preempt_enable() to
   preempt_enable_no_resched().
 - Remove the RWSEM_READ_OWNED macro and assume readers own the lock
   when owner is NULL.
 - Reduce the spin threshold to 64.
 - Enable writer respin only if spinners are present.

This patch set improves upon the rwsem optimistic spinning patch set
from Davidlohr to enable better performing rwsem and more aggressive
use of optimistic spinning.

By using a microbenchmark running 1 million lock-unlock operations per
thread on a 4-socket 40-core Westmere-EX x86-64 test machine running
3.16-rc7 based kernels, the following table shows the execution times
with 2/10 threads running on different CPUs on the same socket where
load is the number of pause instructions in the critical section:

  lock/r:w ratio # of threads	Load:Execution Time (ms)
  -------------- ------------	------------------------
  mutex		      2		1:530.7, 5:406.0, 10:472.7
  mutex		     10		1:1848 , 5:2046 , 10:4394

Before patch:
  rwsem/0:1	      2		1:339.4, 5:368.9, 10:394.0
  rwsem/1:1	      2		1:2915 , 5:2621 , 10:2764
  rwsem/10:1	      2		1:891.2, 5:779.2, 10:827.2
  rwsem/0:1	     10		1:5618 , 5:5722 , 10:5683
  rwsem/1:1	     10		1:14562, 5:14561, 10:14770
  rwsem/10:1	     10		1:5914 , 5:5971 , 10:5912

After patch:
  rwsem/0:1	     2		1:334.6, 5:334.5, 10:366.9
  rwsem/1:1	     2		1:311.0, 5:320.5, 10:300.0
  rwsem/10:1	     2		1:184.6, 5:180.6, 10:188.9
  rwsem/0:1	    10		1:1842 , 5:1925 , 10:2306
  rwsem/1:1	    10		1:1668 , 5:1706 , 10:1555
  rwsem/10:1	    10		1:1266 , 5:1294 , 10:1342

% Change:
  rwsem/0:1	     2		1: -1.4%, 5: -9.6%, 10: -6.7%
  rwsem/1:1	     2		1:-89.3%, 5:-87.7%, 10:-89.1%
  rwsem/10:1	     2		1:-79.3%, 5:-76.8%, 10:-77.2%
  rwsem/0:1	    10		1:-67.2%, 5:-66.4%, 10:-59.4%
  rwsem/1:1	    10		1:-88.5%, 5:-88.3%, 10:-89.5%
  rwsem/10:1	    10		1:-78.6%, 5:-78.3%, 10:-77.3%

It can be seen that there is dramatic reduction in the execution
times. The new rwsem is now even faster than mutex whether it is all
writers or a mixture of writers and readers.

Running the AIM7 benchmarks on a larger 8-socket 80-core system
(HT off), the performance improvements on some of the workloads were
as follows:

      Workload	       Before Patch	After Patch	% Change
      --------	       ------------	-----------	--------
  alltests (200-1000)	  337892	  345888	 + 2.4%
  alltests (1100-2000)	  402535	  474065	 +17.8%
  custom (200-1000)	  480651	  547522	 +13.9%
  custom (1100-2000)	  461037	  561588	 +21.8%
  shared (200-1000)	  420845	  458048	 + 8.8%
  shared (1100-2000)	  428045	  473121	 +10.5%

Waiman Long (7):
  locking/rwsem: check for active writer/spinner before wakeup
  locking/rwsem: threshold limited spinning for active readers
  locking/rwsem: rwsem_can_spin_on_owner can be called with preemption
    enabled
  locking/rwsem: more aggressive use of optimistic spinning
  locking/rwsem: move down rwsem_down_read_failed function
  locking/rwsem: enables optimistic spinning for readers
  locking/rwsem: allow waiting writers to go back to spinning

 include/linux/osq_lock.h    |    5 +
 kernel/locking/rwsem-xadd.c |  348 ++++++++++++++++++++++++++++++++++---------
 2 files changed, 283 insertions(+), 70 deletions(-)

