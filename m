Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaBQVgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:36:20 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:43207 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbaBQVgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:36:09 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH tip/core/rcu 11/12] notifier: Substitute rcu_access_pointer() for rcu_dereference_raw()
Date: Mon, 17 Feb 2014 13:35:58 -0800
Message-Id: <1392672959-6386-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217213533.GA5387@linux.vnet.ibm.com>
 <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-3532-0000-0000-000005BEA0DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

(Trivial patch.)

If the code is looking at the RCU-protected pointer itself, but not
dereferencing it, the rcu_dereference() functions can be downgraded
to rcu_access_pointer().  This commit makes this downgrade in
__blocking_notifier_call_chain() which simply compares the RCU-protected
pointer against NULL with no dereferencing.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/notifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/notifier.c b/kernel/notifier.c
index 2d5cc4ccff7f..db4c8b08a50c 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -309,7 +309,7 @@ int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 	 * racy then it does not matter what the result of the test
 	 * is, we re-check the list after having taken the lock anyway:
 	 */
-	if (rcu_dereference_raw(nh->head)) {
+	if (rcu_access_pointer(nh->head)) {
 		down_read(&nh->rwsem);
 		ret = notifier_call_chain(&nh->head, val, v, nr_to_call,
 					nr_calls);
-- 
1.8.1.5

