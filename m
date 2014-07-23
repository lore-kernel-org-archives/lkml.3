Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbaGWFN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:13:28 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:44990 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346AbaGWFKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:10:51 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 06/16] rcu: Clear gp_flags only when actually starting new gp
Date: Wed, 23 Jul 2014 01:09:43 -0400
Message-Id: <1406092194-13004-7-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are clearing the gp_flags before we check if a grace period is in progress.
If a grace period is in progress, we return after incorrectly clearing the
gp_flags. The code comments say that this is highly unlikely, but just to be
safe this commit moves the clearing of gp_flags to after the check for grace
period in progress.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 044946e..b14cecd 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1605,7 +1605,6 @@ static int rcu_gp_init(struct rcu_state *rsp)
 		raw_spin_unlock_irq(&rnp->lock);
 		return 0;
 	}
-	ACCESS_ONCE(rsp->gp_flags) = 0; /* Clear all flags: New grace period. */
 
 	if (WARN_ON_ONCE(rcu_gp_in_progress(rsp))) {
 		/*
@@ -1616,6 +1615,8 @@ static int rcu_gp_init(struct rcu_state *rsp)
 		return 0;
 	}
 
+	ACCESS_ONCE(rsp->gp_flags) = 0; /* Clear all flags: New grace period. */
+
 	/* Advance to a new grace period and initialize state. */
 	record_gp_stall_check_time(rsp);
 	/* Record GP times before starting GP, hence smp_store_release(). */
-- 
2.0.0.rc2

