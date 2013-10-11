Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab3JKXRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 19:17:10 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46699 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab3JKXRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 19:17:08 -0400
Date: Fri, 11 Oct 2013 16:16:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, fengguang.wu@intel.com, stephen@networkplumber.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, tgraf@suug.ch, gaofeng@cn.fujitsu.com,
        linux-decnet-user@lists.sourceforge.net, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH v3 tip/core/rcu 0/14] Sparse-related updates for 3.13
Message-ID: <20131011231659.GA28062@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101123-6688-0000-0000-000002770388
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series features updates to allow sparse to do a better job of
statically analyzing RCU usage:

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


 b/drivers/net/bonding/bond_alb.c  |    3 ++-
 b/drivers/net/bonding/bond_main.c |    8 +++++---
 b/include/linux/rcupdate.h        |   20 +++++++++++++++++++-
 b/kernel/notifier.c               |    3 ++-
 b/net/bridge/br_mdb.c             |    2 +-
 b/net/bridge/br_multicast.c       |    4 ++--
 b/net/decnet/dn_route.c           |    8 +++++---
 b/net/ipv4/ip_sockglue.c          |    3 ++-
 b/net/ipv6/ip6_gre.c              |    3 ++-
 b/net/ipv6/ip6_tunnel.c           |    3 ++-
 b/net/ipv6/sit.c                  |    3 ++-
 b/net/mac80211/sta_info.c         |    7 ++++---
 b/net/wireless/scan.c             |   32 ++++++++++++++++++--------------
 13 files changed, 66 insertions(+), 33 deletions(-)

