Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbaAaTxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:53:32 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43425 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbaAaTxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:53:31 -0500
From: Zoran Markovic <zoran.markovic@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: [RFC PATCH] rcu: move SRCU grace period work to power efficient workqueue
Date: Fri, 31 Jan 2014 11:53:06 -0800
Message-Id: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaibal Dutta <shaibal.dutta@broadcom.com>

For better use of CPU idle time, allow the scheduler to select the CPU
on which the SRCU grace period work would be scheduled. This improves
idle residency time and conserves power.

This functionality is enabled when CONFIG_WQ_POWER_EFFICIENT is selected.

Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Shaibal Dutta <shaibal.dutta@broadcom.com>
[zoran.markovic@linaro.org: Rebased to latest kernel version. Added commit
message. Fixed code alignment.]
---
 kernel/rcu/srcu.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/srcu.c b/kernel/rcu/srcu.c
index 3318d82..a1ebe6d 100644
--- a/kernel/rcu/srcu.c
+++ b/kernel/rcu/srcu.c
@@ -398,7 +398,7 @@ void call_srcu(struct srcu_struct *sp, struct rcu_head *head,
 	rcu_batch_queue(&sp->batch_queue, head);
 	if (!sp->running) {
 		sp->running = true;
-		schedule_delayed_work(&sp->work, 0);
+		queue_delayed_work(system_power_efficient_wq, &sp->work, 0);
 	}
 	spin_unlock_irqrestore(&sp->queue_lock, flags);
 }
@@ -674,7 +674,8 @@ static void srcu_reschedule(struct srcu_struct *sp)
 	}
 
 	if (pending)
-		schedule_delayed_work(&sp->work, SRCU_INTERVAL);
+		queue_delayed_work(system_power_efficient_wq,
+				   &sp->work, SRCU_INTERVAL);
 }
 
 /*
-- 
1.7.9.5

