Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab3IYBf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:35:28 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44496 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab3IYBfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:35:25 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/13] notifiers: Apply rcu_access_pointer() to avoid sparse false positive
Date: Tue, 24 Sep 2013 18:35:05 -0700
Message-Id: <1380072916-31557-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380072916-31557-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925013451.GA31260@linux.vnet.ibm.com>
 <1380072916-31557-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-7182-0000-0000-000008839D2C
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
pointer using rcu_access_pointer() as suggested by Josh Triplett.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/notifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/notifier.c b/kernel/notifier.c
index 2d5cc4c..1857c71 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -51,7 +51,7 @@ static int notifier_chain_unregister(struct notifier_block **nl,
 {
 	while ((*nl) != NULL) {
 		if ((*nl) == n) {
-			rcu_assign_pointer(*nl, n->next);
+			rcu_assign_pointer(*nl, rcu_access_pointer(n->next));
 			return 0;
 		}
 		nl = &((*nl)->next);
-- 
1.8.1.5

