Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab3JHKkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:40:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33581 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab3JHKkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:40:51 -0400
Message-Id: <20131008102505.404025673@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 08 Oct 2013 12:25:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current cpu hotplug lock is a single global lock; therefore excluding
hotplug is a very expensive proposition even though it is rare occurrence under
normal operation.

There is a desire for a more light weight implementation of
{get,put}_online_cpus() from both the NUMA scheduling as well as the -RT side.

The current hotplug lock is a full reader preference lock -- and thus supports
reader recursion. However since we're making the read side lock much cheaper it
is the expectation that it will also be used far more. Which in turn would lead
to writer starvation.

Therefore the new lock proposed is completely fair; albeit somewhat expensive
on the write side. This in turn means that we need a per-task nesting count to
support reader recursion.

This patch-set is in 3 parts;

 1) The new hotplug lock implementation, very fast on the read side,
    very expensive on the write side; patch 1

 2) Some new rcu_sync primitive by Oleg; patches 2,4-6

 3) Employment of the rcy_sync thingy to optimize the write-side of the
    new hotplug lock; patch 3


Barring further comments/objections I'll stuff this lot into -tip and go look
at getting the numa bits into there too.

Changes since -v1:
 - Addressed all comments from Paul
 - Actually made sure to send the version that builds
 - Added a few patches from Oleg extending the rcu_sync primitive
 - Added Reviewed-by for Oleg to patches 1,3 -- please holler if you disagree!


---
 include/linux/rcusync.h   |   57 +++++++++++
 kernel/rcusync.c          |  152 +++++++++++++++++++++++++++++++
 include/linux/cpu.h       |   68 +++++++++++++-
 include/linux/sched.h     |    3 
 kernel/Makefile           |    3 
 kernel/cpu.c              |  223 +++++++++++++++++++++++++++++++++-------------
 kernel/sched/core.c       |    2 
 7 files changed, 444 insertions(+), 64 deletions(-)

