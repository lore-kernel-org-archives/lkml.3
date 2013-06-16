Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3FPCgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 22:36:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62616 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab3FPCgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 22:36:16 -0400
Date: Sat, 15 Jun 2013 19:36:11 -0700
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: A question on RCU vs. preempt-RCU
Message-ID: <20130616023611.GA19863@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

Kent recently implemented a generic percpu reference counter.  It's
scheduled to be merged in the coming merge window and some part of
cgroup refcnting is already converted to it.

 https://git.kernel.org/cgit/linux/kernel/git/tj/percpu.git/tree/include/linux/percpu-refcount.h?h=for-3.11

 https://git.kernel.org/cgit/linux/kernel/git/tj/percpu.git/tree/lib/percpu-refcount.c?h=for-3.11

It's essentially a generalized form of module refcnting but uses
regular RCU instead of toggling preemption for local atomicity.

I've been running some performance tests with different preemption
levels and, with CONFIG_PREEMPT, the percpu ref could be slower by
around 10% or at the worst contrived case maybe even close to 20% when
compared to simple atomic_t on a single CPU (when hit by multiple CPUs
concurrently, it of course destroys atomic_t).  Most of the slow down
seems to come from the preempt tree RCU calls and there no longer
seems to be a way to opt out of that RCU implementation when
CONFIG_PREEMPT.

For most use cases, the trade-off should be fine.  With any kind of
cross-cpu traffic, which there usually will be, it should be an easy
win for the percpu-refcount even when CONFIG_PREEMPT; however, I've
been looking to replace the module ref with the generic one and the
performance degradation there has low but existing possibility of
being noticeable in some edge use cases.

We can convert the percpu-refcount to use preempt_disable/enable()
paired with call_rcu_sched() but IIUC that would have latency
implications from the callback processing side, right?  Given that
module ref killing would be very low-frequency, it shouldn't
contribute significant amount of callbacks but I'd like to avoid
providing two separate implementations if at all possible.

So, what would be the right thing to do here?  How bad would
converting percpu-refcount to sched-RCU by default be?  Would the
extra overhead on module ref be acceptable when CONFIG_PREEMPT?
What do you guys think?

Thanks!

-- 
tejun
