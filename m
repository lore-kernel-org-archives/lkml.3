Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaDNQbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:31:50 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:60388 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236AbaDNQ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:27:46 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 32/38] tick-sched: add comment about 'idle_active' in tick_nohz_idle_exit()
Date: Mon, 14 Apr 2014 21:53:54 +0530
Message-Id: <d08702a052159ef78eb78ca7292f258f3a6aec59.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sequence of calls for dynticks CPUs was a bit confusing and so adding a
comment in tick_nohz_idle_exit() routine to mention it clearly. All information
required is in commit and this conversation with Frederic.

https://lkml.org/lkml/2014/4/10/355

Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-sched.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f1bc258..85a4e90 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -925,6 +925,22 @@ void tick_nohz_idle_exit(void)
 
 	ts->inidle = 0;
 
+	/*
+	 * Can idle_active be false here?
+	 * Ideally this would be the sequence of calls:
+	 * - tick_nohz_idle_enter(), i.e. idle_active = true;
+	 * - local_irq_disable()
+	 * - IDLE
+	 * - wake up due to IPI or other interrupt
+	 * - local_irq_enable()
+	 * - tick_nohz_irq_enter(), i.e. idle_active = false;
+	 * - tick_nohz_irq_exit(), i.e. idle_active = true; This is not called
+	 *   in case of IPI's as need_resched() will prevent that in
+	 *   tick_irq_exit(), as we don't need to account any more for idle time
+	 *   or try to enter dyntics mode (We are going to exit idle state).
+	 *
+	 * - tick_nohz_idle_exit()
+	 */
 	if (ts->idle_active || ts->tick_stopped)
 		now = ktime_get();
 
-- 
1.7.12.rc2.18.g61b472e

