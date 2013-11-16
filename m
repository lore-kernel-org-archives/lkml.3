Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab3KPAnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:43:23 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:53670 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3KPAke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:40:34 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH tip/core/rcu 10/14] bridge/br_mdb: Apply ACCESS_ONCE() to avoid sparse false positive
Date: Fri, 15 Nov 2013 16:40:13 -0800
Message-Id: <1384562417-817-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562417-817-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003946.GA316@linux.vnet.ibm.com>
 <1384562417-817-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-8236-0000-0000-000003D81BD5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The sparse checking for rcu_assign_pointer() was recently upgraded
to reject non-__kernel address spaces.  This also rejects __rcu,
which is almost always the right thing to do.  However, the use in
__br_mdb_del() is legitimate: They are assigning a pointer to an element
from an RCU-protected list, and all elements of this list are already
visible to caller.

This commit therefore silences these false positives by laundering
the pointers using ACCESS_ONCE() as suggested by Eric Dumazet and Josh
Triplett.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: bridge@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
---
 net/bridge/br_mdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 85a09bb5ca51..de7197ba8695 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -447,7 +447,7 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry)
 		if (p->port->state == BR_STATE_DISABLED)
 			goto unlock;
 
-		rcu_assign_pointer(*pp, p->next);
+		ACCESS_ONCE(*pp) = p->next; /* OK: Both --rcu and visible. */
 		hlist_del_init(&p->mglist);
 		del_timer(&p->timer);
 		call_rcu_bh(&p->rcu, br_multicast_free_pg);
-- 
1.8.1.5

