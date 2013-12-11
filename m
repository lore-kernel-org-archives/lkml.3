Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab3LKXIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 18:08:31 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:41589 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab3LKXI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 18:08:28 -0500
Date: Wed, 11 Dec 2013 15:08:23 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: [PATCH v2 tip/core/rcu 0/4] Documentation changes for 3.14
Message-ID: <20131211230823.GA12448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121123-1542-0000-0000-00000424C740
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series once again attempts to improve rcu_assign_pointer()'s
relationship with sparse.

1.	Add a comment indicating that despite appearances,
	rcu_assign_pointer() really only evaluates its arguments once,
	as a cpp macro should.

2.	Replace rcu_assign_pointer() of NULL with RCU_INIT_POINTER() to
	silence a sparse warning.

3.	Apply ACCESS_ONCE() to rcu_assign_pointer()'s target to prevent
	comiler mischief.  Also require that the source pointer be from
	the kernel address space.  Sometimes it can be from the RCU address
	space, which necessitates the remaining patches in this series.
	Which, it must be admitted, apply to a very small fraction of
	the rcu_assign_pointer() invocations in the kernel.  This commit
	courtesy of Josh Triplett.

4.	Add an RCU_INITIALIZER() for compile-time initialization of
	global RCU-protected pointers.

Changes from v1 (candidate for v3.14):

o	Remove the requirement that values passed to rcu_assign_pointer()
	needed to be in sparse's __kernel address space.  This found
	no bugs and produced a number of ugly false positives.	(Hey,
	it seemed like a good idea at the time...)

o	Remove lots of rcu_assign_pointer()-to-ACCESS_ONCE() changes
	that are no longer needed given the above change.

Changes from v3 (candidate for 3.13):

o	Remove the replacements of rcu_assign_pointer() with ACCESS_ONCE()
	where new data really was being exposed to readers.

Changes from v2:

o	Switch from rcu_assign_pointer() to ACCESS_ONCE() given that
	the pointers are all --rcu and already visible to readers,
	as suggested by Eric Dumazet and Josh Triplett.

o	Place the commit adding the rcu_assign_pointer()'s ACCESS_ONCE()
	at the end to allow better bisectability, as suggested by Josh
	Triplett.

o	Add a comment to rcu_assign_pointer() noting that it only evaluates
	its arguments once, as suggested by Josh Triplett.

Changes from v1:

o	Fix grammar nit in commit logs.

							Thanx, Paul

------------------------------------------------------------------------

 b/drivers/net/bonding/bond_main.c |    2 
 b/include/linux/rcupdate.h        |   90 +++++++++++++++++++++-----------------
 2 files changed, 52 insertions(+), 40 deletions(-)

