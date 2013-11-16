Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab3KPAlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:41:31 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:35078 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab3KPAjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:39:54 -0500
Date: Fri, 15 Nov 2013 16:39:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/14] sparse improvements of
 rcu_assign_pointer() for 3.14
Message-ID: <20131116003946.GA316@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-9332-0000-0000-0000022BC350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series once again attempts to improve rcu_assign_pointer()'s
relationship with sparse.

1.	Add a comment indicating that despite appearances,
	rcu_assign_pointer() really only evaluates its arguments once,
	as a cpp macro should.

2-13.	Apply ACCESS_ONCE() to avoid a number of rcu_assign_pointer()
	calls that would otherwise suffer sparse false positives given
	patch #13 below.

14.	Apply ACCESS_ONCE() to rcu_assign_pointer()'s target to prevent
	comiler mischief.  Also require that the source pointer be from
	the kernel address space.  Sometimes it can be from the RCU address
	space, which necessitates the remaining patches in this series.
	Which, it must be admitted, apply to a very small fraction of
	the rcu_assign_pointer() invocations in the kernel.  This commit
	courtesy of Josh Triplett.

Changes from v3:

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

 b/drivers/net/bonding/bond_alb.c  |    3 -
 b/drivers/net/bonding/bond_main.c |    5 +-
 b/include/linux/rcupdate.h        |    8 +++
 b/kernel/notifier.c               |    3 -
 b/net/bridge/br_mdb.c             |    2 
 b/net/bridge/br_multicast.c       |    4 -
 b/net/decnet/dn_route.c           |    8 ++-
 b/net/ipv4/ip_sockglue.c          |    3 -
 b/net/ipv6/ip6_gre.c              |    3 -
 b/net/ipv6/ip6_tunnel.c           |    3 -
 b/net/ipv6/sit.c                  |    3 -
 b/net/mac80211/sta_info.c         |    7 +-
 include/linux/rcupdate.h          |   92 +++++++++++++++++++++-----------------
 13 files changed, 88 insertions(+), 56 deletions(-)

