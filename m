Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab3CRPZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:25:15 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:54707 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab3CRPZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:25:09 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org
Cc: linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dave Airlie <airlied@redhat.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH V3 7/7] fbcon: queue work on any cpu
Date: Mon, 18 Mar 2013 20:53:29 +0530
Message-Id: <e82c429f56d058cb6e2bbcad40232c11a4be511a.1363617402.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1363617402.git.viresh.kumar@linaro.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1363617402.git.viresh.kumar@linaro.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fbcon uses workqueues and it has no real dependency of scheduling these on the
cpu which scheduled them.

On a idle system, it is observed that and idle cpu wakes up few times just to
service this work. It would be better if we can schedule it on a cpu which isn't
idle to save on power.

By idle cpu (from scheduler's perspective) we mean:
- Current task is idle task
- nr_running == 0
- wake_list is empty

This patch replaces schedule_work() routine with queue_work_on_any_cpu()
sibling with system_wq as workqueue.

This routine would look for the closest (via scheduling domains) non-idle cpu
(non-idle from schedulers perspective). If the current cpu is not idle or all
cpus are idle, work will be scheduled on local cpu.

Cc: Dave Airlie <airlied@redhat.com>
Cc: linux-fbdev@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/video/console/fbcon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 3cd6759..a900997 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -404,7 +404,7 @@ static void cursor_timer_handler(unsigned long dev_addr)
 	struct fb_info *info = (struct fb_info *) dev_addr;
 	struct fbcon_ops *ops = info->fbcon_par;
 
-	schedule_work(&info->queue);
+	queue_work_on_any_cpu(system_wq, &info->queue);
 	mod_timer(&ops->cursor_timer, jiffies + HZ/5);
 }
 
-- 
1.7.12.rc2.18.g61b472e

