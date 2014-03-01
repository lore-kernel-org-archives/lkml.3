Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaCASFv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 13:05:51 -0500
Received: from mail.efficios.com ([78.47.125.74]:57952 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbaCASFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 13:05:49 -0500
Date: Sat, 1 Mar 2014 18:05:48 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        rp@svcs.cs.pdx.edu
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Alan Stern <stern@rowland.harvard.edu>
Message-ID: <118155517.32860.1393697148593.JavaMail.zimbra@efficios.com>
In-Reply-To: <529596190.32848.1393696790299.JavaMail.zimbra@efficios.com>
Subject: [RELEASE] Userspace RCU 0.7.11 and 0.8.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: Userspace RCU 0.7.11 and 0.8.3
Thread-Index: uWF7txO538ntRdFmv1ccRMrD/KLj7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

liburcu is a LGPLv2.1 userspace RCU (read-copy-update) library. This
data synchronization library provides read-side access which scales
linearly with the number of cores. It does so by allowing multiples
copies of a given data structure to live at the same time, and by
monitoring the data structure accesses to detect grace periods after
which memory reclamation is possible.

liburcu-cds provides efficient data structures based on RCU and
lock-free algorithms. Those structures include hash tables, queues,
stacks, and doubly-linked lists.

Sorry about the quick releases, but I though I should save our
packagers some time by releasing this fix, so they can skip over
yesterday's version. It fixes a higher-than-normal CPU usage in
presence of long RCU read-side critical sections. It does not affect
correctness of RCU, just the amount of CPU usage in very specific
scenarios. Since there is only one new commit, I'm putting the full
commit changelog (from the stable-0.8 branch) below.

Changelog:
commit e198fb6a2ebc22ceac8b10d953103b59452f24d4
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date:   Sat Mar 1 11:33:25 2014 -0500

    Fix: high cpu usage in synchronize_rcu with long RCU read-side C.S.
    
    We noticed that with this kind of scenario:
    - application using urcu-mb, urcu-membarrier, urcu-signal, or urcu-bp,
    - long RCU read-side critical sections, caused by e.g. long network I/O
      system calls,
    - other short lived RCU critical sections running in other threads,
    - very frequent invocation of call_rcu to enqueue callbacks,
    lead to abnormally high CPU usage within synchronize_rcu() in the
    call_rcu worker threads.
    
    Inspection of the code gives us the answer: in urcu.c, we expect that if
    we need to wait on a futex (wait_gp()), we expect to be able to end the
    grace period within the next loop, having been notified by a
    rcu_read_unlock(). However, this is not always the case: we can very
    well be awakened by a rcu_read_unlock() executed on a thread running
    short-lived RCU read-side critical sections, while the long-running RCU
    read-side C.S. is still active. We end up in a situation where we
    busy-wait for a very long time, because the counter is !=
    RCU_QS_ACTIVE_ATTEMPTS until a 32-bit overflow happens (or more likely,
    until we complete the grace period). We need to change the wait_loops ==
    RCU_QS_ACTIVE_ATTEMPTS check into an inequality to use wait_gp() for
    every attempts beyond RCU_QS_ACTIVE_ATTEMPTS loops.
    
    urcu-bp.c also has this issue. Moreover, it uses usleep() rather than
    poll() when dealing with long-running RCU read-side critical sections.
    Turn the usleep 1000us (1ms) into a poll of 10ms. One of the advantage
    of using poll() rather than usleep() is that it does not interact with
    SIGALRM.
    
    urcu-qsbr.c already checks for wait_loops >= RCU_QS_ACTIVE_ATTEMPTS, so
    it is not affected by this issue.
    
    Looking into these loops, however, shows that overflow of the loop
    counter, although unlikely, would bring us back to a situation of high
    cpu usage (a negative value well below RCU_QS_ACTIVE_ATTEMPTS).
    Therefore, change the counter behavior so it stops incrementing when it
    reaches RCU_QS_ACTIVE_ATTEMPTS, to eliminate overflow.
    
    Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Project website: http://urcu.so
Download link: http://urcu.so/files/
Git repository: git://git.urcu.so/urcu.git

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
