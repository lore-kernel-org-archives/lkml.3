Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959AbaD2SGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:06:51 -0400
Received: from shelob.surriel.com ([74.92.59.67]:48123 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624AbaD2SGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:06:48 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        rdunlap@infradead.org, richard@nod.at, umgwanakikbuti@gmail.com
Subject: [PATCH 2/2] sysrq,rcu: suppress RCU stall warnings while sysrq runs
Date: Tue, 29 Apr 2014 14:06:36 -0400
Message-Id: <1398794796-17464-3-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398794796-17464-1-git-send-email-riel@redhat.com>
References: <1398794796-17464-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Some sysrq handlers can run for a long time, because they dump a lot
of data onto a serial console. Having RCU stall warnings pop up in
the middle of them only makes the problem worse.

This patch temporarily disables RCU stall warnings while a sysrq
request is handled.

Signed-off-by: Rik van Riel <riel@redhat.com>
Suggested-by: Paul McKenney <paulmck@linux.vnet.ibm.com>
[ paulmck: Fix TINY_RCU build error. ]
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 drivers/tty/sysrq.c      |  3 +++
 include/linux/rcupdate.h | 12 ++++++++++++
 kernel/rcu/update.c      | 12 ++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index fc67a89..38d5f9a 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -46,6 +46,7 @@
 #include <linux/jiffies.h>
 #include <linux/syscalls.h>
 #include <linux/of.h>
+#include <linux/rcupdate.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
@@ -511,6 +512,7 @@ void __handle_sysrq(int key, bool check_mask)
 	int orig_log_level;
 	int i;
 
+	rcu_sysrq_start();
 	rcu_read_lock();
 	/*
 	 * Raise the apparent loglevel to maximum so that the sysrq header
@@ -554,6 +556,7 @@ void __handle_sysrq(int key, bool check_mask)
 		console_loglevel = orig_log_level;
 	}
 	rcu_read_unlock();
+	rcu_sysrq_end();
 }
 
 void handle_sysrq(int key)
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 00a7fd6..ec3959b 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -228,6 +228,18 @@ void rcu_idle_exit(void);
 void rcu_irq_enter(void);
 void rcu_irq_exit(void);
 
+#ifdef CONFIG_RCU_STALL_COMMON
+void rcu_sysrq_start(void);
+void rcu_sysrq_end(void);
+#else /* #ifdef CONFIG_RCU_STALL_COMMON */
+static inline void rcu_sysrq_start(void)
+{
+}
+static inline void rcu_sysrq_end(void)
+{
+}
+#endif /* #else #ifdef CONFIG_RCU_STALL_COMMON */
+
 #ifdef CONFIG_RCU_USER_QS
 void rcu_user_enter(void);
 void rcu_user_exit(void);
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 4c0a9b0..d22309c 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -320,6 +320,18 @@ int rcu_jiffies_till_stall_check(void)
 	return till_stall_check * HZ + RCU_STALL_DELAY_DELTA;
 }
 
+void rcu_sysrq_start(void)
+{
+	if (!rcu_cpu_stall_suppress)
+		rcu_cpu_stall_suppress = 2;
+}
+
+void rcu_sysrq_end(void)
+{
+	if (rcu_cpu_stall_suppress == 2)
+		rcu_cpu_stall_suppress = 0;
+}
+
 static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
 {
 	rcu_cpu_stall_suppress = 1;
-- 
1.8.5.3

