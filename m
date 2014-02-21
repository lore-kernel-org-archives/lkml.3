Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbaBUJQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 04:16:11 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48736 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754468AbaBUJQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 04:16:07 -0500
From: Lei Wen <leiwen@marvell.com>
To: Mike Galbraith <bitbucket@online.de>, Lei Wen <leiwen@marvell.com>,
        Peter Zijlstra <peterz@infradead.org>, <mingo@redhat.com>,
        <preeti.lkml@gmail.com>, <daniel.lezcano@linaro.org>,
        <viresh.kumar@linaro.org>, <xjian@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] sched: keep quiescent cpu out of idle balance loop
Date: Fri, 21 Feb 2014 17:15:08 +0800
Message-ID: <1392974108-28778-1-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392971691.5451.84.camel@marge.simpson.net>
References: <1392971691.5451.84.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-21_03:2014-02-21,2014-02-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402210013
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cpu which is put into quiescent mode, would set its sd
member as NULL, and want others not disturb its task running.
But current scheduler would not checking whether that cpu is
setting in such mode, and still insist the quiescent
cpu to response the nohz load balance.

Fix it by preventing such cpu set nohz.idle_cpus_mask in the
first place.

Signed-off-by: Lei Wen <leiwen@marvell.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <bitbucket@online.de>
---
Much thanks to Mike Pointing out the root span would be merged when the
last cpu becomes isolated from the crash result checking!

 kernel/sched/fair.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 235cfa7..af30b6a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6883,6 +6883,14 @@ void nohz_balance_enter_idle(int cpu)
 	if (!cpu_active(cpu))
 		return;
 
+	/*
+	 * If this cpu is isolated, its rq's sd member would becomes NULL.
+	 * Base on this observation, we could exclude this cpu from nohz
+	 * idle balance, so that it would not be disturbed.
+	 */
+	if (!this_rq()->sd)
+		return;
+
 	if (test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))
 		return;
 
-- 
1.8.3.2

