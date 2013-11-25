Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab3KYU6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:58:15 -0500
Received: from www.linutronix.de ([62.245.132.108]:57359 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3KYU6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:58:13 -0500
Message-Id: <20131125203358.156292370@linutronix.de>
User-Agent: quilt/0.60-1
Date: Mon, 25 Nov 2013 20:58:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Jason Low <jason.low2@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket plist
 in futex_wake()
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch set from Davidlohr [1] tried to attempt the same via an
atomic counter of waiters in a hash bucket. The atomic counter access
provided enough serialization for x86 so that a failure is not
observable in testing, but does not provide any guarantees.

The same can be achieved with a smp_mb() pair including proper
guarantees for all architectures.

The following series provides an incremental approach to this and adds
documentation of the ordering guarantees of futexes.

Note, this is RFC and needs a lot of review, testing and proper
performance numbers for the following scenarios:

1) Test case where a single waiter is about to queue itself, i.e. the
   test case Davidlohr used to gather his numbers.

2) Test case where the hash bucket is always not empty. This allows us
   to determine the smp_mb() overhead for cases which are not
   optimized by the singler waiter per bucket.

These tests need to be done on x86 AND on other architectures where
the smp_mb() might be more expensive than on x86.

Thanks,

	tglx

---
[1] http://lkml.kernel.org/r/1385168197-8612-5-git-send-email-davidlohr@hp.com


