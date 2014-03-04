Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbaCDLdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:33:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38520 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721AbaCDLdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:33:51 -0500
Date: Tue, 4 Mar 2014 03:33:30 -0800
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-c24a4a369419c360c323865b91198878275c1481@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <c439f5b6bbc2047e1662f4d523350531425bcf9d.1393576981.git.viresh.kumar@linaro.org>
References: <c439f5b6bbc2047e1662f4d523350531425bcf9d.1393576981.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timer: Check failure of timer_cpu_notify()
  before calling init_timer_stats()
Git-Commit-ID: c24a4a369419c360c323865b91198878275c1481
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c24a4a369419c360c323865b91198878275c1481
Gitweb:     http://git.kernel.org/tip/c24a4a369419c360c323865b91198878275c1481
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Fri, 28 Feb 2014 14:15:21 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 12:30:29 +0100

timer: Check failure of timer_cpu_notify() before calling init_timer_stats()

timer_cpu_notify() should return NOTIFY_OK and nothing else. Anything else would
trigger a BUG_ON(). Return value of this routine is already checked correctly
but is done after issuing a call to init_timer_stats(). The right order would be
to check the error case first and then call init_timer_stats(). Lets do it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org
Cc: fweisbec@gmail.com
Cc: tj@kernel.org
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/c439f5b6bbc2047e1662f4d523350531425bcf9d.1393576981.git.viresh.kumar@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index a71bdfd..31824ef 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1681,9 +1681,9 @@ void __init init_timers(void)
 
 	err = timer_cpu_notify(&timers_nb, (unsigned long)CPU_UP_PREPARE,
 			       (void *)(long)smp_processor_id());
-	init_timer_stats();
-
 	BUG_ON(err != NOTIFY_OK);
+
+	init_timer_stats();
 	register_cpu_notifier(&timers_nb);
 	open_softirq(TIMER_SOFTIRQ, run_timer_softirq);
 }
