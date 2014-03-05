Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbaCEAaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:30:39 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:44985 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756990AbaCEA3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:29:48 -0500
Message-Id: <20140305002944.129685346@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Mar 2014 19:29:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <stable-rt@vger.kernel.org>
Subject: [PATCH RT 3/6] rt: Make cpu_chill() use hrtimer instead of msleep()
References: <20140305002933.559081123@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-rt-Make-cpu_chill-use-hrtimer-instead-of-msleep.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4.82-rt101-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

Ulrich Obergfell pointed out that cpu_chill() calls msleep() which is woken
up by the ksoftirqd running the TIMER softirq. But as the cpu_chill() is
called from softirq context, it may block the ksoftirqd() from running, in
which case, it may never wake up the msleep() causing the deadlock.

I checked the vmcore, and irq/74-qla2xxx is stuck in the msleep() call,
running on CPU 8. The one ksoftirqd that is stuck, happens to be the one that
runs on CPU 8, and it is blocked on a lock held by irq/74-qla2xxx. As that
ksoftirqd is the one that will wake up irq/74-qla2xxx, and it happens to be
blocked on a lock that irq/74-qla2xxx holds, we have our deadlock.

The solution is not to convert the cpu_chill() back to a cpu_relax() as that
will re-create a possible live lock that the cpu_chill() fixed earlier, and may
also leave this bug open on other softirqs. The fix is to remove the
dependency on ksoftirqd from cpu_chill(). That is, instead of calling
msleep() that requires ksoftirqd to wake it up, use the
hrtimer_nanosleep() code that does the wakeup from hard irq context.

|Looks to be the lock of the block softirq. I don't have the core dump
|anymore, but from what I could tell the ksoftirqd was blocked on the
|block softirq lock, where the block softirq handler did a msleep
|(called by the qla2xxx interrupt handler).
|
|Looking at trigger_softirq() in block/blk-softirq.c, it can do a
|smp_callfunction() to another cpu to run the block softirq. If that
|happens to be the cpu where the qla2xx irq handler is doing the block
|softirq and is in a middle of a msleep(), I believe the ksoftirqd will
|try to run the softirq. If it does that, then BOOM, it's deadlocked
|because the ksoftirqd will never run the timer softirq either.

|I should have also stated that it was only one lock that was involved.
|But the lock owner was doing a msleep() that requires a wakeup by
|ksoftirqd to continue. If ksoftirqd happens to be blocked on a lock
|held by the msleep() caller, then you have your deadlock.
|
|It's best not to have any softirqs going to sleep requiring another
|softirq to wake it up. Note, if we ever require a timer softirq to do a
|cpu_chill() it will most definitely hit this deadlock.

Cc: stable-rt@vger.kernel.org
Found-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[bigeasy: add the 4 | chapters from email]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/delay.h |  2 +-
 kernel/hrtimer.c      | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/delay.h b/include/linux/delay.h
index e23a7c0..37caab3 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -53,7 +53,7 @@ static inline void ssleep(unsigned int seconds)
 }
 
 #ifdef CONFIG_PREEMPT_RT_FULL
-# define cpu_chill()	msleep(1)
+extern void cpu_chill(void);
 #else
 # define cpu_chill()	cpu_relax()
 #endif
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 1314c00..0b1d411 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1845,6 +1845,21 @@ SYSCALL_DEFINE2(nanosleep, struct timespec __user *, rqtp,
 	return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+/*
+ * Sleep for 1 ms in hope whoever holds what we want will let it go.
+ */
+void cpu_chill(void)
+{
+	struct timespec tu = {
+		.tv_nsec = NSEC_PER_MSEC,
+	};
+
+	hrtimer_nanosleep(&tu, NULL, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
+}
+EXPORT_SYMBOL(cpu_chill);
+#endif
+
 /*
  * Functions related to boot-time initialization:
  */
-- 
1.8.5.3


