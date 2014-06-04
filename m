Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934431AbaFDAaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 20:30:16 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52283 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbaFDAaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 20:30:02 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>, umgwanakikbuti@gmail.com
Cc: mingo@kernel.org, tglx@linutronix.de, nicolas.pitre@linaro.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3/6] sched,idle: Clarify where TIF_NRFLAG_POLLING is set
Date: Tue,  3 Jun 2014 17:29:49 -0700
Message-Id: <1f7b2a25440561e49fb6d0bace3532b5df832ffd.1401841482.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1401841482.git.luto@amacapital.net>
References: <cover.1401841482.git.luto@amacapital.net>
In-Reply-To: <cover.1401841482.git.luto@amacapital.net>
References: <cover.1401841482.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't change functionality at all, but I've misread this code
so many times that I want to make it a bit more obvious.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 kernel/sched/idle.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 25b9423..2ec9f47 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -67,6 +67,10 @@ void __weak arch_cpu_idle(void)
  * cpuidle_idle_call - the main idle function
  *
  * NOTE: no locks or semaphores should be used here
+ *
+ * On archs that support TIF_POLLING_NRFLAG, is called with polling
+ * set, and it returns with polling set.  If it ever stops polling, it
+ * must clear the polling bit.
  */
 static void cpuidle_idle_call(void)
 {
@@ -178,7 +182,14 @@ exit_idle:
  */
 static void cpu_idle_loop(void)
 {
+	__current_set_polling();
+
 	while (1) {
+		/*
+		 * Invariant: polling is set here (assuming that the arch
+		 * has a polling bit.
+		 */
+
 		tick_nohz_idle_enter();
 
 		while (!need_resched()) {
@@ -239,7 +250,6 @@ void cpu_startup_entry(enum cpuhp_state state)
 	 */
 	boot_init_stack_canary();
 #endif
-	__current_set_polling();
 	arch_cpu_idle_prepare();
 	cpu_idle_loop();
 }
-- 
1.9.3

