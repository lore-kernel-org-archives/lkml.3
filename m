Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966214Ab3DQJCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:02:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53265 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965853Ab3DQJCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:02:06 -0400
Date: Wed, 17 Apr 2013 02:01:32 -0700
From: tip-bot for Richard Weinberger <tipbot@zytor.com>
Message-ID: <tip-8198c1696a2cd15d436ade172bfd8085f5f818d3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        richard@nod.at, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        richard@nod.at, tglx@linutronix.de
In-Reply-To: <1366149209-24787-1-git-send-email-richard@nod.at>
References: <1366149209-24787-1-git-send-email-richard@nod.at>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] um: Use generic idle loop
Git-Commit-ID: 8198c1696a2cd15d436ade172bfd8085f5f818d3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 17 Apr 2013 02:01:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8198c1696a2cd15d436ade172bfd8085f5f818d3
Gitweb:     http://git.kernel.org/tip/8198c1696a2cd15d436ade172bfd8085f5f818d3
Author:     Richard Weinberger <richard@nod.at>
AuthorDate: Tue, 16 Apr 2013 23:53:29 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 17 Apr 2013 10:39:38 +0200

um: Use generic idle loop

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net
Link: http://lkml.kernel.org/r/1366149209-24787-1-git-send-email-richard@nod.at
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/um/Kconfig.common   |  1 +
 arch/um/kernel/process.c | 27 ++++-----------------------
 2 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index bceee66..5783406 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -12,6 +12,7 @@ config UML
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IO
 	select GENERIC_CLOCKEVENTS
+	select GENERIC_IDLE_LOOP
 	select TTY # Needed for line.c
 
 config MMU
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index b462b13..bbcef52 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -210,33 +210,14 @@ void initial_thread_cb(void (*proc)(void *), void *arg)
 	kmalloc_ok = save_kmalloc_ok;
 }
 
-void default_idle(void)
+void arch_cpu_idle(void)
 {
 	unsigned long long nsecs;
 
-	while (1) {
-		/* endless idle loop with no priority at all */
-
-		/*
-		 * although we are an idle CPU, we do not want to
-		 * get into the scheduler unnecessarily.
-		 */
-		if (need_resched())
-			schedule();
-
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		nsecs = disable_timer();
-		idle_sleep(nsecs);
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-	}
-}
-
-void cpu_idle(void)
-{
 	cpu_tasks[current_thread_info()->cpu].pid = os_getpid();
-	default_idle();
+	nsecs = disable_timer();
+	idle_sleep(nsecs);
+	local_irq_enable();
 }
 
 int __cant_sleep(void) {
