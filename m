Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaDUJ4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:56:55 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:41805 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaDUJ4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:56:46 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 14/19] tick-sched: add comment about 'idle_active' in tick_nohz_idle_exit()
Date: Mon, 21 Apr 2014 15:25:10 +0530
Message-Id: <387f4713d52595f055620f39dc7a0edad7d4d8bf.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sequence of calls for dynticks CPUs is a bit confusing. Add a comment in
tick_nohz_idle_exit() to mention it clearly. All information required is in
commit and this conversation with Frederic.

https://lkml.org/lkml/2014/4/10/355

Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-sched.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 71f64ee..c3aed50 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -922,6 +922,22 @@ void tick_nohz_idle_exit(void)
 
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

