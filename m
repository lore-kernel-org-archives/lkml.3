Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab3LJB1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:27:46 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:33790 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3LJB1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:27:45 -0500
Date: Mon, 9 Dec 2013 17:27:38 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH v5 tip/core/locking] Memory-barrier documentation updates +
 smp_mb__after_unlock_lock()
Message-ID: <20131210012738.GA24317@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121001-1542-0000-0000-00000412FFD3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series applies some long-needed updates to memory-barriers.txt and
adds an smp_mb__after_unlock_lock():

1.	Add ACCESS_ONCE() calls where needed to ensure their inclusion
	in code copy-and-pasted from this file.

2.	Add long atomic examples alongside the existing atomics.

3.	Prohibit architectures supporting the Linux kernel from
	speculating stores.

4.	Document what ACCESS_ONCE() does along with a number of situations
	requiring its use.

5.	Downgrade UNLOCK+LOCK to no longer imply a full barrier, at least
	in the absence of smp_mb__after_unlock_lock().  See the LKML thread
	that includes http://www.spinics.net/lists/linux-mm/msg65653.html
	for more information.

6.	Added smp_mb__after_unlock_lock() for all architectures.  Because
	all architectures are presumably providing full-barrier semantics
	for UNLOCK+LOCK, these are all no-ops.  Some will change if
	low-latency-handoff queued locks are accepted.

7.	Applied smp_mb__after_unlock_lock() as needed in RCU.

Changes from v4:

o	Added Josh Triplett's Reviewed-by for 1-4.

o	Applied feedback from Ingo Molnar and Jonathan Corbet.

o	Trimmed Cc lists as suggested by David Miller.

o	Added smp_mb__after_unlock_lock() changes.

Changes from v3:

o	Fix typos noted by Peter Zijlstra.

o	Added the documentation about ACCESS_ONCE(), which expands on
	http://thread.gmane.org/gmane.linux.kernel.mm/82891/focus=14696,
	ably summarized by Jon Corbet at http://lwn.net/Articles/508991/.

Changes from v2:

o	Update examples so that that load against which the subsequent
	store is to be ordered is part of the "if" condition.

o	Add an example showing how the compiler can remove "if"
	conditions and how to prevent it from doing so.

o	Add ACCESS_ONCE() to the compiler-barrier section.

o	Add a sentence noting that transitivity requires smp_mb().

Changes from v1:

o	Combined with Peter Zijlstra's speculative-store-prohibition patch.

o	Added more pitfalls to avoid when prohibiting speculative
	stores, along with how to avoid them.

o	Applied Josh Triplett's review comments.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/memory-barriers.txt   |  760 +++++++++++++++++++++++++++-------
 b/arch/arm/include/asm/barrier.h      |    2 
 b/arch/arm64/include/asm/barrier.h    |    2 
 b/arch/ia64/include/asm/barrier.h     |    2 
 b/arch/metag/include/asm/barrier.h    |    2 
 b/arch/mips/include/asm/barrier.h     |    2 
 b/arch/powerpc/include/asm/barrier.h  |    2 
 b/arch/s390/include/asm/barrier.h     |    2 
 b/arch/sparc/include/asm/barrier_64.h |    2 
 b/arch/x86/include/asm/barrier.h      |    2 
 b/include/asm-generic/barrier.h       |    2 
 b/kernel/rcu/tree.c                   |   18 
 b/kernel/rcu/tree_plugin.h            |   13 
 13 files changed, 670 insertions(+), 141 deletions(-)

