Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751044AbaBSFVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 00:21:08 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5930 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbaBSFVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 00:21:05 -0500
From: Lei Wen <leiwen@marvell.com>
To: <peterz@infradead.org>, <mingo@redhat.com>, <preeti.lkml@gmail.com>,
        <daniel.lezcano@linaro.org>, <viresh.kumar@linaro.org>,
        <xjian@marvell.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: keep quiescent cpu out of idle balance loop
Date: Wed, 19 Feb 2014 13:20:30 +0800
Message-ID: <1392787230-17986-1-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-19_01:2014-02-18,2014-02-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402180231
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since cpu which is put into quiescent mode, would remove itself
from kernel's sched_domain. So we could use search sched_domain
method to check whether this cpu don't want to be disturbed as
idle load balance would send IPI to it.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/fair.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 235cfa7..14230ae 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6783,6 +6783,8 @@ out_unlock:
  * - When one of the busy CPUs notice that there may be an idle rebalancing
  *   needed, they will kick the idle load balancer, which then does idle
  *   load balancing for all the idle CPUs.
+ * - exclude those cpus not inside current call_cpu's sched_domain, so that
+ *   those isolated cpu could be kept in their quisecnt mode.
  */
 static struct {
 	cpumask_var_t idle_cpus_mask;
@@ -6792,10 +6794,16 @@ static struct {
 
 static inline int find_new_ilb(void)
 {
-	int ilb = cpumask_first(nohz.idle_cpus_mask);
+	int ilb;
+	int cpu = smp_processor_id();
+	struct sched_domain *tmp;
 
-	if (ilb < nr_cpu_ids && idle_cpu(ilb))
-		return ilb;
+	for_each_domain(cpu, tmp) {
+		ilb = cpumask_first_and(nohz.idle_cpus_mask,
+				sched_domain_span(tmp));
+		if (ilb < nr_cpu_ids && idle_cpu(ilb))
+			return ilb;
+	}
 
 	return nr_cpu_ids;
 }
-- 
1.8.3.2

