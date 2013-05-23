Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab3EWIfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:35:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19363 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3EWIfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:35:41 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-3f-519dd4db8425
From: Lukasz Majewski <l.majewski@samsung.com>
To: Alex Shi <alex.shi@intel.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/2] sched: Use do_div() for 64 bit division at power
 utilization calculation (putil)
Date: Thu, 23 May 2013 10:34:23 +0200
Message-id: <1369298064-14998-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsVy+t9jAd3bV+YGGkxfrmvRv+0ni0Xn2SfM
	Fmeb3rBbvHm4mdHi8q45bBafe48wWtxuXMFm0XHkG7MDh8fiPS+ZPO5c28Pm0bdlFaPH501y
	ASxRXDYpqTmZZalF+nYJXBlbF/1hK/jFUfHxXwNLA+NR9i5GTg4JAROJs+umMkPYYhIX7q1n
	62Lk4hASWMQoseHZVyini0ni6sUJYB1sAnoSn+8+ZQKxRQQUJd5Mf8ECUsQssJNJYv7RTkaQ
	hLBAusSWxSfAilgEVCUO9F0Ga+YVcJPYeecfI8Q6eYmn9/vYJjByL2BkWMUomlqQXFCclJ5r
	pFecmFtcmpeul5yfu4kRHCjPpHcwrmqwOMQowMGoxMMrcXtOoBBrYllxZe4hRgkOZiUR3s09
	cwOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0tSC2CyTJxcEo1MIYnxupX
	phu/YDpbl69W9lToxvWWA388LimFpqxr71y17yxbR+Kf30KXBJb29myKjZbuPPGkaNHtjatF
	PyxPMjlb+FZ26Qfd7xPKumsc18jtvlgiXWbqNa3dw8PryY6Qn2knX75XFdoub/OZoVtf7dyq
	xoQE3Y1uH19mxtQ3FAv90Ojj0JU9o8RSnJFoqMVcVJwIAHrEmGEQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now explicit casting is done when power usage variable (putil) is calculated

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
This patch was developed on top of the following Alex's repository:
https://github.com/alexshi/power-scheduling/commits/power-scheduling
---
 kernel/sched/fair.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f0ead38..14d29b3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3471,8 +3471,10 @@ find_leader_cpu(struct sched_group *group, struct task_struct *p, int this_cpu,
 	int leader_cpu = -1;
 	int i;
 	/* percentage of the task's util */
-	unsigned putil = (u64)(p->se.avg.runnable_avg_sum << SCHED_POWER_SHIFT)
-				/ (p->se.avg.runnable_avg_period + 1);
+	unsigned putil;
+	u64 tmp = (u64) p->se.avg.runnable_avg_sum << SCHED_POWER_SHIFT;
+	do_div(tmp, (p->se.avg.runnable_avg_period + 1));
+	putil = (unsigned) tmp;
 
 	/* bias toward local cpu */
 	if (cpumask_test_cpu(this_cpu, tsk_cpus_allowed(p)) &&
-- 
1.7.10.4

