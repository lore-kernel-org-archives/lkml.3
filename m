Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab3KLQlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:41:44 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:38169 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3KLQlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:41:37 -0500
Date: Tue, 12 Nov 2013 22:11:26 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mikey@neuling.org,
        linux-tip-commits@vger.kernel.org
Subject: [PATCH v2] sched: Check sched_domain before computing group power.
Message-ID: <20131112164126.GF2559@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <tip-db2pe0vxwunv37plc7onnugj@git.kernel.org>
 <20131112105547.GA27310@linux.vnet.ibm.com>
 <20131112115736.GO5056@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131112115736.GO5056@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111216-7164-0000-0000-0000033849A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After Commit-id 863bffc80898 (sched/fair: Fix group power_orig
computation), we might end up computing group power before the
sched_domain for a cpu is updated.

Update with cpu_power, if rq->sd is not yet updated.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
Changelog since v1: Fix divide by zero errors that can result because
power/power_orig was set to 0.

 kernel/sched/fair.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df77c60..8d92853 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5354,8 +5354,16 @@ void update_group_power(struct sched_domain *sd, int cpu)
 		 */
 
 		for_each_cpu(cpu, sched_group_cpus(sdg)) {
-			struct sched_group *sg = cpu_rq(cpu)->sd->groups;
+			struct rq *rq = cpu_rq(cpu);
+			struct sched_group *sg;
 
+			if (!rq->sd) {
+				power_orig += power_of(cpu);
+				power += power_of(cpu);
+				continue;
+			}
+
+			sg = rq->sd->groups;
 			power_orig += sg->sgp->power_orig;
 			power += sg->sgp->power;
 		}
-- 
1.7.1

