Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab3KPAnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:43:49 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:35282 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab3KPAk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:40:28 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [PATCH tip/core/rcu 08/14] ipv6/sit: Apply ACCESS_ONCE() to avoid sparse false positive
Date: Fri, 15 Nov 2013 16:40:11 -0800
Message-Id: <1384562417-817-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562417-817-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003946.GA316@linux.vnet.ibm.com>
 <1384562417-817-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-9332-0000-0000-0000022BC3DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The sparse checking for rcu_assign_pointer() was recently upgraded
to reject non-__kernel address spaces.  This also rejects __rcu,
which is almost always the right thing to do.  However, the use in
ipip6_tunnel_unlink() is legitimate: It is assigning a pointer to an
element from an RCU-protected list, and all elements of this list are
already visible to caller.

This commit therefore silences this false positive by laundering the
pointer using ACCESS_ONCE() as suggested by Eric Dumazet and Josh
Triplett.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org
---
 net/ipv6/sit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 7ee5cb96db34..9b976a4b463d 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -157,7 +157,8 @@ static void ipip6_tunnel_unlink(struct sit_net *sitn, struct ip_tunnel *t)
 	     (iter = rtnl_dereference(*tp)) != NULL;
 	     tp = &iter->next) {
 		if (t == iter) {
-			rcu_assign_pointer(*tp, t->next);
+			/* Both --rcu and visible, so ACCESS_ONCE() is OK. */
+			ACCESS_ONCE(*tp) = t->next;
 			break;
 		}
 	}
-- 
1.8.1.5

