Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3JKXRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 19:17:45 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45794 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3JKXRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 19:17:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v3 tip/core/rcu 02/14] notifiers: Apply ACCESS_ONCE() to avoid sparse false positive
Date: Fri, 11 Oct 2013 16:17:19 -0700
Message-Id: <1381533451-29018-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1381533451-29018-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131011231659.GA28062@linux.vnet.ibm.com>
 <1381533451-29018-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101123-0928-0000-0000-00000277C7E7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The sparse checking for rcu_assign_pointer() was recently upgraded
to reject non-__kernel address spaces.  This also rejects __rcu,
which is almost always the right thing to do.  However, the use in
notifier_chain_unregister() is legitimate: It is deleting an element
from an RCU-protected list, and all elements of this list are already
visible to caller.

This commit therefore silences this false positive by laundering the
pointer using ACCESS_ONCE() as suggested by Eric Dumazet and Josh
Triplett.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/notifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/notifier.c b/kernel/notifier.c
index 2d5cc4ccff7f..197eb70805a4 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -51,7 +51,8 @@ static int notifier_chain_unregister(struct notifier_block **nl,
 {
 	while ((*nl) != NULL) {
 		if ((*nl) == n) {
-			rcu_assign_pointer(*nl, n->next);
+			/* Both --rcu and visible, so ACCESS_ONCE() is OK. */
+			ACCESS_ONCE(*nl) = n->next;
 			return 0;
 		}
 		nl = &((*nl)->next);
-- 
1.8.1.5

