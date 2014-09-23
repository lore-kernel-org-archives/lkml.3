Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbaIWDDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 23:03:50 -0400
Received: from mx1.mxmail.xiaomi.com ([58.68.235.87]:59928 "EHLO
	mx1.mxmail.xiaomi.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753650AbaIWDDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 23:03:48 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2014 23:03:47 EDT
From: Hui Zhu <zhuhui@xiaomi.com>
To: <gregkh@linuxfoundation.org>, <rientjes@google.com>,
        <vinayakm.list@gmail.com>, <weijie.yang@samsung.com>
CC: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        <teawater@gmail.com>, Hui Zhu <zhuhui@xiaomi.com>
Subject: [PATCH] Fix the issue that lowmemkiller fell into a cycle that try to kill a task
Date: Tue, 23 Sep 2014 10:57:09 +0800
Message-ID: <1411441029-8428-1-git-send-email-zhuhui@xiaomi.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.27.14.101]
X-EsetResult: clean, is OK
X-EsetId: B888893E9A6C9E31E8C9D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cause of this issue is when free memroy size is low and a lot of task is
trying to shrink the memory, the task that is killed by lowmemkiller cannot get
CPU to exit itself.

Fix this issue with change the scheduling policy to SCHED_FIFO if a task's flag
is TIF_MEMDIE in lowmemkiller.

Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
---
 drivers/staging/android/lowmemorykiller.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index b545d3d..ca1ffac 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -129,6 +129,10 @@ static unsigned long lowmem_scan(struct shrinker *s, struct shrink_control *sc)
 
 		if (test_tsk_thread_flag(p, TIF_MEMDIE) &&
 		    time_before_eq(jiffies, lowmem_deathpending_timeout)) {
+			struct sched_param param = { .sched_priority = 1 };
+
+			if (p->policy == SCHED_NORMAL)
+				sched_setscheduler(p, SCHED_FIFO, &param);
 			task_unlock(p);
 			rcu_read_unlock();
 			return 0;
-- 
1.9.1

