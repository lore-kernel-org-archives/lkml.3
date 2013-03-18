Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab3CRPYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:24:51 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:58697 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3CRPYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:24:49 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org
Cc: linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
Subject: [PATCH V3 5/7] mmc: queue work on any cpu
Date: Mon, 18 Mar 2013 20:53:27 +0530
Message-Id: <08070dbf56439c84b8c25837c2049ff8e8eafd6e.1363617402.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1363617402.git.viresh.kumar@linaro.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1363617402.git.viresh.kumar@linaro.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmc uses workqueues for running mmc_rescan(). There is no real dependency of
scheduling these on the cpu which scheduled them.

On a idle system, it is observed that and idle cpu wakes up many times just to
service this work. It would be better if we can schedule it on a cpu which isn't
idle to save on power.

By idle cpu (from scheduler's perspective) we mean:
- Current task is idle task
- nr_running == 0
- wake_list is empty

This patch replaces the queue_delayed_work() with
queue_delayed_work_on_any_cpu() siblings.

This routine would look for the closest (via scheduling domains) non-idle cpu
(non-idle from schedulers perspective). If the current cpu is not idle or all
cpus are idle, work will be scheduled on local cpu.

Cc: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/mmc/core/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 9290bb5..adf331a 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -85,7 +85,7 @@ MODULE_PARM_DESC(
 static int mmc_schedule_delayed_work(struct delayed_work *work,
 				     unsigned long delay)
 {
-	return queue_delayed_work(workqueue, work, delay);
+	return queue_delayed_work_on_any_cpu(workqueue, work, delay);
 }
 
 /*
-- 
1.7.12.rc2.18.g61b472e

