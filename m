Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaDDDTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:19:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64688 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724AbaDDDTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:19:04 -0400
From: Lei Wen <leiwen@marvell.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>,
        Petr Mladek <pmladek@suse.cz>, <linux-kernel@vger.kernel.org>,
        <leiwen@marvell.com>
Subject: [PATCH 2/3] timekeeping: move clocksource init to the early place
Date: Fri, 4 Apr 2014 11:18:41 +0800
Message-ID: <1396581522-3309-3-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396581522-3309-1-git-send-email-leiwen@marvell.com>
References: <1396581522-3309-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-04-04_01:2014-04-03,2014-04-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=2 spamscore=2 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404030304
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that in the very early booting place, we could call timekeeping
code, while it would not cause system panic, since clock is not
init yet.

And for system default clock is always jiffies, so that it shall be
safe to do so.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 include/linux/time.h      |  1 +
 init/main.c               |  1 +
 kernel/time/timekeeping.c | 22 +++++++++++++++-------
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index a2f5079..e2d4899 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -127,6 +127,7 @@ extern void read_boot_clock(struct timespec *ts);
 extern int persistent_clock_is_local;
 extern int update_persistent_clock(struct timespec now);
 void timekeeping_init(void);
+void timekeeping_init_early(void);
 extern int timekeeping_suspended;
 
 unsigned long get_seconds(void);
diff --git a/init/main.c b/init/main.c
index 9c7fd4c..5723933 100644
--- a/init/main.c
+++ b/init/main.c
@@ -494,6 +494,7 @@ asmlinkage void __init start_kernel(void)
 	 */
 	boot_init_stack_canary();
 
+	timekeeping_init_early();
 	cgroup_init_early();
 
 	local_irq_disable();
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index c196111..b8f850b 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -782,12 +782,25 @@ void __attribute__((weak)) read_boot_clock(struct timespec *ts)
 }
 
 /*
- * timekeeping_init - Initializes the clocksource and common timekeeping values
+ * timekeeping_init_early - setup clocksource early
  */
-void __init timekeeping_init(void)
+void __init timekeeping_init_early(void)
 {
 	struct timekeeper *tk = &timekeeper;
 	struct clocksource *clock;
+
+	clock = clocksource_default_clock();
+	if (clock->enable)
+		clock->enable(clock);
+	tk_setup_internals(tk, clock);
+}
+
+/*
+ * timekeeping_init - Initializes common timekeeping values
+ */
+void __init timekeeping_init(void)
+{
+	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
 	struct timespec now, boot, tmp;
 
@@ -813,11 +826,6 @@ void __init timekeeping_init(void)
 	write_seqcount_begin(&timekeeper_seq);
 	ntp_init();
 
-	clock = clocksource_default_clock();
-	if (clock->enable)
-		clock->enable(clock);
-	tk_setup_internals(tk, clock);
-
 	tk_set_xtime(tk, &now);
 	tk->raw_time.tv_sec = 0;
 	tk->raw_time.tv_nsec = 0;
-- 
1.8.3.2

