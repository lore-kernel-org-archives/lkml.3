Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab3EEOOe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 10:14:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34624 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3EEOOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 10:14:33 -0400
Date: Sun, 5 May 2013 07:14:01 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-3fa479b9a7762e12bdad2db39f983ba1b5f51ba2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bitbucket@online.de, tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bitbucket@online.de, tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <alpine.LFD.2.02.1305031451561.2886@ionos>
References: <alpine.LFD.2.02.1305031451561.2886@ionos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] tick: Cleanup NOHZ per cpu data on cpu down
Git-Commit-ID: 3fa479b9a7762e12bdad2db39f983ba1b5f51ba2
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

Commit-ID:  3fa479b9a7762e12bdad2db39f983ba1b5f51ba2
Gitweb:     http://git.kernel.org/tip/3fa479b9a7762e12bdad2db39f983ba1b5f51ba2
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 3 May 2013 15:02:50 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 5 May 2013 16:06:27 +0200

tick: Cleanup NOHZ per cpu data on cpu down

Prarit reported a crash on CPU offline/online. The reason is that on
CPU down the NOHZ related per cpu data of the dead cpu is not cleaned
up. If at cpu online an interrupt happens before the per cpu tick
device is registered the irq_enter() check potentially sees stale data
and dereferences a NULL pointer.

Cleanup the data after the cpu is dead.

[ hrtimer fix from Mike Galbraith ]

Reported-by: Prarit Bhargava <prarit@redhat.com>
Cc: stable@vger.kernel.org
Cc: Mike Galbraith <bitbucket@online.de>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1305031451561.2886@ionos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/hrtimer.c            | 2 +-
 kernel/time/tick-common.c   | 1 +
 kernel/time/tick-internal.h | 6 ++++++
 kernel/time/tick-sched.c    | 7 +++++++
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 609d8ff..90f8642 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1759,8 +1759,8 @@ static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 	{
-		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &scpu);
 		migrate_hrtimers(scpu);
+		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &scpu);
 		break;
 	}
 #endif
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 6176a3e..29b765d 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -387,6 +387,7 @@ static int tick_notify(struct notifier_block *nb, unsigned long reason,
 		tick_shutdown_broadcast_oneshot(dev);
 		tick_shutdown_broadcast(dev);
 		tick_shutdown(dev);
+		tick_shutdown_nohz(dev);
 		break;
 
 	case CLOCK_EVT_NOTIFY_SUSPEND:
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index f0299ea..9644b29 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -144,3 +144,9 @@ static inline int tick_device_is_functional(struct clock_event_device *dev)
 #endif
 
 extern void do_timer(unsigned long ticks);
+
+#ifdef CONFIG_NO_HZ
+extern void tick_shutdown_nohz(unsigned int *cpup);
+#else
+static inline void tick_shutdown_nohz(unsigned int *cpup) { }
+#endif
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 225f8bf..b79f562 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -797,6 +797,13 @@ static inline void tick_check_nohz(int cpu)
 	}
 }
 
+void tick_shutdown_nohz(unsigned int *cpup)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, *cpup);
+
+	memset(ts, 0, sizeof(*ts));
+}
+
 #else
 
 static inline void tick_nohz_switch_to_nohz(void) { }
