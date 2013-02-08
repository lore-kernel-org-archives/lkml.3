Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946920Ab3BHSGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 13:06:13 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:32981 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946902Ab3BHSGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 13:06:11 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, efault@gmx.de
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v3 2/2] sched: fix update NOHZ_IDLE flag
Date: Fri,  8 Feb 2013 19:05:18 +0100
Message-Id: <1360346718-3313-3-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360346718-3313-1-git-send-email-vincent.guittot@linaro.org>
References: <1360346718-3313-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function nohz_kick_needed modifies NOHZ_IDLE flag that is used to update
the nr_busy_cpus of the sched_group.
When the sched_domain are updated (during the boot or because of the unplug of
a CPUs as an example) a null_domain is attached to CPUs. We have to test
likely(!on_null_domain(cpu) first in order to detect such intialization step
and to not modify the NOHZ_IDLE flag

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5eea870..dac2edf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5695,7 +5695,7 @@ void trigger_load_balance(struct rq *rq, int cpu)
 	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
 #ifdef CONFIG_NO_HZ
-	if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
+	if (likely(!on_null_domain(cpu)) && nohz_kick_needed(rq, cpu))
 		nohz_balancer_kick(cpu);
 #endif
 }
-- 
1.7.9.5

