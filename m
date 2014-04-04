Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaDDGqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:46:14 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:59497 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbaDDGmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:42:20 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 26/36] hrtimer: take lock only once for a cpu_base in hrtimer_run_queues()
Date: Fri,  4 Apr 2014 12:06:09 +0530
Message-Id: <d424e8aedf25d7b0ac71470942890199752a5ea6.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are taking cpu_base->lock for every clock-base in hrtimer_run_queues() and
there is nothing in there which prevents us to take this lock only once. Modify
code to take lock only once for a cpu_base.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 2d9a7e2..c712960 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1466,8 +1466,8 @@ void hrtimer_run_queues(void)
 	if (cpu_base->active_bases)
 		hrtimer_get_softirq_time(cpu_base);
 
+	raw_spin_lock(&cpu_base->lock);
 	for_each_active_base(index, base, cpu_base, active_bases) {
-		raw_spin_lock(&cpu_base->lock);
 		while ((node = timerqueue_getnext(&base->active))) {
 			struct hrtimer *timer;
 
@@ -1478,8 +1478,8 @@ void hrtimer_run_queues(void)
 
 			__run_hrtimer(timer, &base->softirq_time);
 		}
-		raw_spin_unlock(&cpu_base->lock);
 	}
+	raw_spin_unlock(&cpu_base->lock);
 }
 
 /*
-- 
1.7.12.rc2.18.g61b472e

