Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab3GAGsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 02:48:12 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:30210 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3GAGsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 02:48:10 -0400
Message-ID: <51D12570.9070100@huawei.com>
Date: Mon, 1 Jul 2013 14:45:04 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Li Zefan <lizefan@huawei.com>,
        Zhang Hang <bob.zhanghang@huawei.com>,
        Li Bin <huawei.libin@huawei.com>
Subject: [PATCH] sched: fix cpu utilization account error
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We setting clock_skip_update = 1 based on the assumption that the
next call to update_rq_clock() will come nearly immediately
after being set. However, it is not always true especially on
non-preempt mode. In this case we may miss some clock update, which
would cause an error curr->sum_exec_runtime account.

The test result show that test_kthread's exec_runtime has been
added to watchdog.

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+   P COMMAND
   28 root      RT   0     0    0    0 S  100  0.0   0:05.39  5 watchdog/5
    7 root      RT   0     0    0    0 S   95  0.0   0:05.83  0 watchdog/0
   12 root      RT   0     0    0    0 S   94  0.0   0:05.79  1 watchdog/1
   16 root      RT   0     0    0    0 S   92  0.0   0:05.74  2 watchdog/2
   20 root      RT   0     0    0    0 S   91  0.0   0:05.71  3 watchdog/3
   24 root      RT   0     0    0    0 S   82  0.0   0:05.42  4 watchdog/4
   32 root      RT   0     0    0    0 S   79  0.0   0:05.35  6 watchdog/6
 5200 root      20   0     0    0    0 R   21  0.0   0:08.88  6 test_kthread/6
 5194 root      20   0     0    0    0 R   20  0.0   0:08.41  0 test_kthread/0
 5195 root      20   0     0    0    0 R   20  0.0   0:08.44  1 test_kthread/1
 5196 root      20   0     0    0    0 R   20  0.0   0:08.49  2 test_kthread/2
 5197 root      20   0     0    0    0 R   20  0.0   0:08.53  3 test_kthread/3
 5198 root      20   0     0    0    0 R   19  0.0   0:08.81  4 test_kthread/4
 5199 root      20   0     0    0    0 R    2  0.0   0:08.66  5 test_kthread/5

"test_kthread/i" is a kernel thread which has a infinity loop and it calls
schedule() every 1s. It's main process as below:

static int main_loop (void *unused)
{
	unsigned long flags;
	unsigned long last = jiffies;
	int i;

	while (!kthread_should_stop()) {
		/* call schedule every 1 sec */
		if (HZ <= jiffies - last) {
			last = jiffies;
			schedule();
		}

		/* do some thing */
		for (i = 0; i < 1000; i++)
		;

		if (kthread_should_stop())
			break;
	}
}

In this patch, we do not skip clock update when current task is kernel
thread in non-preempt mode.

Reported-by: Zhang Hang <bob.zhanghang@huawei.com>
Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 kernel/sched/core.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e8b3350..018dc43 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -970,8 +970,19 @@ void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 	 * A queue event has occurred, and we're going to schedule.  In
 	 * this case, we can save a useless back to back clock update.
 	 */
+#ifdef CONFIG_PREEMPT
 	if (rq->curr->on_rq && test_tsk_need_resched(rq->curr))
 		rq->skip_clock_update = 1;
+#else
+	/*
+	 * In non-preempt mode, a kernel thread may run for a long time
+	 * until been scheduled out by itself. In this cace, we need update
+	 * rq clock when calling schedule function, otherwise, we might
+	 * miss rq clock update for a long time.
+	 */
+	if (rq->curr->on_rq && test_tsk_need_resched(rq->curr) && rq->curr->mm)
+		rq->skip_clock_update = 1;
+#endif
 }

 static ATOMIC_NOTIFIER_HEAD(task_migration_notifier);
-- 
1.7.6.1

