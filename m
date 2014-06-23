Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaFWJe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:34:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59225 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaFWJe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:34:26 -0400
Date: Mon, 23 Jun 2014 02:34:13 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-cddd02489f52ccf635ed65931214729a23b93cd6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <1403393357-2070-4-git-send-email-fweisbec@gmail.com>
References: <1403393357-2070-4-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] hrtimer:
  Store cpu-number in struct hrtimer_cpu_base
Git-Commit-ID: cddd02489f52ccf635ed65931214729a23b93cd6
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

Commit-ID:  cddd02489f52ccf635ed65931214729a23b93cd6
Gitweb:     http://git.kernel.org/tip/cddd02489f52ccf635ed65931214729a23b93cd6
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Sun, 22 Jun 2014 01:29:15 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 23 Jun 2014 11:23:47 +0200

hrtimer: Store cpu-number in struct hrtimer_cpu_base

In lowres mode, hrtimers are serviced by the tick instead of a clock
event. Now it works well as long as the tick stays periodic but we
must also make sure that the hrtimers are serviced in dynticks mode.

Part of that job consist in kicking a dynticks hrtimer target in order
to make it reconsider the next tick to schedule to correctly handle the
hrtimer's expiring time. And that part isn't handled by the hrtimers
subsystem.

To prepare for fixing this, we need __hrtimer_start_range_ns() to be
able to resolve the CPU target associated to a hrtimer's object
'cpu_base' so that the kick can be centralized there.

So lets store it in the 'struct hrtimer_cpu_base' to resolve the CPU
without overhead. It is set once at CPU's online notification.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1403393357-2070-4-git-send-email-fweisbec@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hrtimer.h | 2 ++
 kernel/time/hrtimer.c   | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index e7a8d3f..bb4ffff 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -165,6 +165,7 @@ enum  hrtimer_base_type {
  * struct hrtimer_cpu_base - the per cpu clock bases
  * @lock:		lock protecting the base and associated clock bases
  *			and timers
+ * @cpu:		cpu number
  * @active_bases:	Bitfield to mark bases with active timers
  * @clock_was_set:	Indicates that clock was set from irq context.
  * @expires_next:	absolute time of the next event which was scheduled
@@ -179,6 +180,7 @@ enum  hrtimer_base_type {
  */
 struct hrtimer_cpu_base {
 	raw_spinlock_t			lock;
+	unsigned int			cpu;
 	unsigned int			active_bases;
 	unsigned int			clock_was_set;
 #ifdef CONFIG_HIGH_RES_TIMERS
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 3ab2899..0e32d4e 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1680,6 +1680,7 @@ static void init_hrtimers_cpu(int cpu)
 		timerqueue_init_head(&cpu_base->clock_base[i].active);
 	}
 
+	cpu_base->cpu = cpu;
 	hrtimer_init_hres(cpu_base);
 }
 
