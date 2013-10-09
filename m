Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab3JIVch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 17:32:37 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45746 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373Ab3JIVaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 17:30:00 -0400
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
Subject: [PATCH v2 tip/core/rcu 12/13] bonding/bond_main: Apply rcu_access_pointer() to avoid sparse false positive
Date: Wed,  9 Oct 2013 14:29:45 -0700
Message-Id: <1381354186-16285-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1381354186-16285-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131009212920.GA15413@linux.vnet.ibm.com>
 <1381354186-16285-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100921-0928-0000-0000-000002691FD9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The sparse checking for rcu_assign_pointer() was recently upgraded
to reject non-__kernel address spaces.  This also rejects __rcu,
which is almost always the right thing to do.  However, the uses in
bond_change_active_slave(), bond_enslave(), and __bond_release_one()
are legitimate: They are assigning a pointer to an element from an
RCU-protected list (or a NULL pointer), and all elements of this list
are already visible to caller.

This commit therefore silences these false positives either by laundering
the pointers using rcu_access_pointer() as suggested by Josh Triplett,
or by using RCU_INIT_POINTER() for NULL pointer assignments.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: bridge@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
---
 drivers/net/bonding/bond_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 72df399c4ab3..2f276b971bc4 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -890,7 +890,8 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 		if (new_active)
 			bond_set_slave_active_flags(new_active);
 	} else {
-		rcu_assign_pointer(bond->curr_active_slave, new_active);
+		rcu_assign_pointer(bond->curr_active_slave,
+				   rcu_access_pointer(new_active));
 	}
 
 	if (bond->params.mode == BOND_MODE_ACTIVEBACKUP) {
@@ -1601,7 +1602,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
 		 * so we can change it without calling change_active_interface()
 		 */
 		if (!bond->curr_active_slave && new_slave->link == BOND_LINK_UP)
-			rcu_assign_pointer(bond->curr_active_slave, new_slave);
+			rcu_assign_pointer(bond->curr_active_slave,
+					   rcu_access_pointer(new_slave));
 
 		break;
 	} /* switch(bond_mode) */
@@ -1801,7 +1803,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 	}
 
 	if (all) {
-		rcu_assign_pointer(bond->curr_active_slave, NULL);
+		RCU_INIT_POINTER(bond->curr_active_slave, NULL);
 	} else if (oldcurrent == slave) {
 		/*
 		 * Note that we hold RTNL over this sequence, so there
-- 
1.8.1.5

