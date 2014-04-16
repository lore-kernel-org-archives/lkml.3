Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaDPLek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 07:34:40 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:64291 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaDPLei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 07:34:38 -0400
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org, efault@gmx.de,
        chris.redpath@arm.com
Cc: wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] sched: let task migration destination cpu do active balance
Date: Wed, 16 Apr 2014 19:34:29 +0800
Message-Id: <1397648069-6462-1-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Redpath found an issue on active balance: 
We let the task source cpu, the busiest cpu, do the active balance,
while the destination cpu maybe idle. thus we take the busiest cpu
time, but left the idlest cpu wait. That is not good for performance.

This patch let the destination cpu do active balance. It will give tasks
more running time.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9b4c4f3..cccee76 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6308,7 +6308,7 @@ more_balance:
 			raw_spin_unlock_irqrestore(&busiest->lock, flags);
 
 			if (active_balance) {
-				stop_one_cpu_nowait(cpu_of(busiest),
+				stop_one_cpu_nowait(busiest->push_cpu,
 					active_load_balance_cpu_stop, busiest,
 					&busiest->active_balance_work);
 			}
-- 
1.8.1.2

