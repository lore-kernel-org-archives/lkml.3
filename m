Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaBTJRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:17:42 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57827 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753832AbaBTJRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 04:17:39 -0500
From: Lei Wen <leiwen@marvell.com>
To: Peter Zijlstra <peterz@infradead.org>, Lei Wen <leiwen@marvell.com>,
        <mingo@redhat.com>, <preeti.lkml@gmail.com>,
        <daniel.lezcano@linaro.org>, <viresh.kumar@linaro.org>,
        <xjian@marvell.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: keep quiescent cpu out of idle balance loop
Date: Thu, 20 Feb 2014 17:17:04 +0800
Message-ID: <1392887824-20138-1-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140220085017.GL6835@laptop.programming.kicks-ass.net>
References: <20140220085017.GL6835@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-20_02:2014-02-18,2014-02-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402200010
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cpu which is put into quiescent mode, would remove itself
from kernel's sched_domain, and want others not disturb its
task running. But current scheduler would not checking whether
that cpu is setting in such mode, and still insist the quiescent
cpu to response the nohz load balance.

Fix it by preventing such cpu set nohz.idle_cpus_mask in the
first place.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/fair.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 235cfa7..bc85022 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6883,6 +6883,13 @@ void nohz_balance_enter_idle(int cpu)
 	if (!cpu_active(cpu))
 		return;
 
+	/*
+	 * If this cpu is kept outside of root domain, we don't bother
+	 * to ask it for nohz balance.
+	 */
+	if (!cpumask_test_cpu(cpu, this_rq()->rd.span))
+		return;
+
 	if (test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))
 		return;
 
-- 
1.8.3.2

