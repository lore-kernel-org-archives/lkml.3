Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaDXNF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:05:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbaDXNF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:05:26 -0400
Date: Thu, 24 Apr 2014 09:04:52 -0400
From: Rik van Riel <riel@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        joern@logfs.org, peterz@infradead.org,
        Andrew Morton <akpm@linux-foundation.org>, cxie@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH RFC] sysrq,rcu: suppress RCU stall warnings while sysrq runs
Message-ID: <20140424090452.3482f95c@annuminas.surriel.com>
In-Reply-To: <20140424014648.GK4496@linux.vnet.ibm.com>
References: <20140423125352.704f9fb2@annuminas.surriel.com>
	<alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz>
	<535833AE.6010505@redhat.com>
	<alpine.LRH.2.00.1404232349350.1491@twin.jikos.cz>
	<20140424014648.GK4496@linux.vnet.ibm.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Paul McKenney...

This seems small and simple enough that it should not introduce any
extra maintenance work in the future.

---8<---

Some sysrq handlers can run for a long time, because they dump a lot
of data onto a serial console. Having RCU stall warnings pop up in
the middle of them only makes the problem worse.

This patch temporarily disables RCU stall warnings while a sysrq
request is handled.

Signed-off-by: Rik van Riel <riel@redhat.com>
Suggested-by: Paul McKenney <paulmck@linux.vnet.ibm.com>
---
 drivers/tty/sysrq.c      |  2 ++
 include/linux/rcupdate.h |  2 ++
 kernel/rcu/update.c      | 11 +++++++++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 3c61e9b..dd53af9 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -511,6 +511,7 @@ void __handle_sysrq(int key, bool check_mask)
 	int orig_log_level;
 	int i;
 
+	rcu_sysrq_start();
 	rcu_read_lock();
 	/*
 	 * Raise the apparent loglevel to maximum so that the sysrq header
@@ -554,6 +555,7 @@ void __handle_sysrq(int key, bool check_mask)
 		console_loglevel = orig_log_level;
 	}
 	rcu_read_unlock();
+	rcu_sysrq_end();
 }
 
 void handle_sysrq(int key)
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 00a7fd6..b9a95f8 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -227,6 +227,8 @@ void rcu_idle_enter(void);
 void rcu_idle_exit(void);
 void rcu_irq_enter(void);
 void rcu_irq_exit(void);
+void rcu_sysrq_start(void);
+void rcu_sysrq_end(void);
 
 #ifdef CONFIG_RCU_USER_QS
 void rcu_user_enter(void);
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 4c0a9b0..2ac3289 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -320,6 +320,17 @@ int rcu_jiffies_till_stall_check(void)
 	return till_stall_check * HZ + RCU_STALL_DELAY_DELTA;
 }
 
+void rcu_sysrq_start(void)
+{
+	rcu_cpu_stall_suppress = 2;
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
