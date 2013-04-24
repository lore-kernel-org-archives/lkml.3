Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab3DXLrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:47:17 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:47082 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758456Ab3DXLrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:47:11 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tj@kernel.org
Cc: davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-fbdev@vger.kernel.org
Subject: [PATCH V5 5/5] fbcon: queue work on power efficient wq
Date: Wed, 24 Apr 2013 17:12:57 +0530
Message-Id: <89924f001e3ddd66ab41a16500569a976ea846fd.1366803121.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1366803121.git.viresh.kumar@linaro.org>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1366803121.git.viresh.kumar@linaro.org>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fbcon uses workqueues and it has no real dependency of scheduling these on the
cpu which scheduled them.

On a idle system, it is observed that and idle cpu wakes up many times just to
service this work. It would be better if we can schedule it on a cpu which the
scheduler believes to be the most appropriate one.

This patch replaces system_wq with system_power_efficient_wq.

Cc: Dave Airlie <airlied@redhat.com>
Cc: linux-fbdev@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/video/console/fbcon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 3cd6759..0cae83d 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -404,7 +404,7 @@ static void cursor_timer_handler(unsigned long dev_addr)
 	struct fb_info *info = (struct fb_info *) dev_addr;
 	struct fbcon_ops *ops = info->fbcon_par;
 
-	schedule_work(&info->queue);
+	queue_work(system_power_efficient_wq, &info->queue);
 	mod_timer(&ops->cursor_timer, jiffies + HZ/5);
 }
 
-- 
1.7.12.rc2.18.g61b472e

