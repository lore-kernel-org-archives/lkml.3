Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaGHWzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:55:36 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:64863 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaGHWzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:55:35 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [RFC PATCH 1/1] rcu: use atomic_read(v) instead of atomic_add_return(0, v)
Date: Tue,  8 Jul 2014 18:55:45 -0400
Message-Id: <1404860145-16450-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic_add_return() invalidates the cache line in other processors where-as
atomic_read does not. I don't see why we would need invalidation in this case.
If indeed it was need a comment would be helpful for readers. Otherwise doesn't
using atomic_read() make more sense here? RFC!

replace atomic_add_return(0, v) with atomic_read(v) as the latter is better.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index dac6d20..a4a8f5f 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -891,7 +891,7 @@ static int rcu_is_cpu_rrupt_from_idle(void)
 static int dyntick_save_progress_counter(struct rcu_data *rdp,
 					 bool *isidle, unsigned long *maxj)
 {
-	rdp->dynticks_snap = atomic_add_return(0, &rdp->dynticks->dynticks);
+	rdp->dynticks_snap = atomic_read(&rdp->dynticks->dynticks);
 	rcu_sysidle_check_cpu(rdp, isidle, maxj);
 	if ((rdp->dynticks_snap & 0x1) == 0) {
 		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, TPS("dti"));
@@ -920,7 +920,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 	int *rcrmp;
 	unsigned int snap;
 
-	curr = (unsigned int)atomic_add_return(0, &rdp->dynticks->dynticks);
+	curr = (unsigned int)atomic_read(&rdp->dynticks->dynticks);
 	snap = (unsigned int)rdp->dynticks_snap;
 
 	/*
-- 
1.9.1

