Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491AbaGWFM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:12:59 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:64822 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306AbaGWFK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:10:57 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 09/16] rcu: Remove redundant check for online cpu
Date: Wed, 23 Jul 2014 01:09:46 -0400
Message-Id: <1406092194-13004-10-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two checks for an online CPU if two if() conditions. This commit
simplies this by replacing it with only one check for the online CPU.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 5dcbf36..8d598a2 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2602,15 +2602,18 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 {
 	bool needwake;
 
+	if (!cpu_online(smp_processor_id()))
+		return;
+
 	/*
 	 * If called from an extended quiescent state, invoke the RCU
 	 * core in order to force a re-evaluation of RCU's idleness.
 	 */
-	if (!rcu_is_watching() && cpu_online(smp_processor_id()))
+	if (!rcu_is_watching())
 		invoke_rcu_core();
 
-	/* If interrupts were disabled or CPU offline, don't invoke RCU core. */
-	if (irqs_disabled_flags(flags) || cpu_is_offline(smp_processor_id()))
+	/* If interrupts were disabled, don't invoke RCU core. */
+	if (irqs_disabled_flags(flags))
 		return;
 
 	/*
-- 
2.0.0.rc2

