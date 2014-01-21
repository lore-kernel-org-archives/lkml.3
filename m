Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaAUFfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 00:35:20 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64116 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaAUFfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 00:35:15 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org, efault@gmx.de
Cc: wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Alex Shi <alex.shi@linaro.org>
Subject: [RFC PATCH 1/2] sched/update_avg: avoid negative time
Date: Tue, 21 Jan 2014 13:33:18 +0800
Message-Id: <1390282399-17091-1-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rq->avg_idle try to reflect the average idle time between the cpu idle
and first wakeup. But in the function, it maybe get a negative value
if old avg_idle is too small. Then this negative value will be double
counted in next time calculation. Guess that is not the original purpose,
so recalibrate it to zero.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 30eb011..af9121c6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1358,6 +1358,9 @@ static void update_avg(u64 *avg, u64 sample)
 {
 	s64 diff = sample - *avg;
 	*avg += diff >> 3;
+
+	if (*avg < 0)
+		*avg = 0;
 }
 #endif
 
-- 
1.8.1.2

