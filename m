Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbaGWFLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:11:04 -0400
Received: from mail-yk0-f171.google.com ([209.85.160.171]:49284 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458AbaGWFLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:11:00 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 10/16] rcu: Check for RCU_FLAG_GP_INIT bit in gp_flags for spurious wakeup
Date: Wed, 23 Jul 2014 01:09:47 -0400
Message-Id: <1406092194-13004-11-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_gp_init() is called once the gp_kthread wakes up on the condition that
the init bit is set in the gp_flags. For a spurious wakeup we need to check that
it is actually set. This commit ensures that the RCU_GP_FLAG_INIT bit is set in
gp_flags.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 8d598a2..f8847d9 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1600,7 +1600,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 	rcu_bind_gp_kthread();
 	raw_spin_lock_irq(&rnp->lock);
 	smp_mb__after_unlock_lock();
-	if (!ACCESS_ONCE(rsp->gp_flags)) {
+	if (!(ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_INIT)) {
 		/* Spurious wakeup, tell caller to go back to sleep.  */
 		raw_spin_unlock_irq(&rnp->lock);
 		return 0;
-- 
2.0.0.rc2

