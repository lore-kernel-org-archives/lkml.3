Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3IWPia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:38:30 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62410 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab3IWPiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:38:25 -0400
From: Richard Weinberger <richard@nod.at>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/4] um: Get rid of thread_struct->saved_task
Date: Mon, 23 Sep 2013 17:38:03 +0200
Message-Id: <1379950684-18710-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379950684-18710-1-git-send-email-richard@nod.at>
References: <1379950684-18710-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we have a sane show_stack() now, we can drop
the ->saved_task hack.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/mconsole_kern.c         |  6 ++----
 arch/um/include/asm/processor-generic.h |  1 -
 arch/um/kernel/process.c                | 15 ++-------------
 3 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 3df3bd5..29880c9 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -645,11 +645,9 @@ void mconsole_sysrq(struct mc_request *req)
 
 static void stack_proc(void *arg)
 {
-	struct task_struct *from = current, *to = arg;
+	struct task_struct *task = arg;
 
-	to->thread.saved_task = from;
-	rcu_user_hooks_switch(from, to);
-	switch_to(from, to, from);
+	show_stack(task, NULL);
 }
 
 /*
diff --git a/arch/um/include/asm/processor-generic.h b/arch/um/include/asm/processor-generic.h
index 9046903..d89b02b 100644
--- a/arch/um/include/asm/processor-generic.h
+++ b/arch/um/include/asm/processor-generic.h
@@ -19,7 +19,6 @@ struct task_struct;
 struct mm_struct;
 
 struct thread_struct {
-	struct task_struct *saved_task;
 	struct pt_regs regs;
 	struct pt_regs *segv_regs;
 	int singlestep_syscall;
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index bbcef52..eecc414 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -82,19 +82,8 @@ void *__switch_to(struct task_struct *from, struct task_struct *to)
 	to->thread.prev_sched = from;
 	set_current(to);
 
-	do {
-		current->thread.saved_task = NULL;
-
-		switch_threads(&from->thread.switch_buf,
-			       &to->thread.switch_buf);
-
-		arch_switch_to(current);
-
-		if (current->thread.saved_task)
-			show_regs(&(current->thread.regs));
-		to = current->thread.saved_task;
-		from = current;
-	} while (current->thread.saved_task);
+	switch_threads(&from->thread.switch_buf, &to->thread.switch_buf);
+	arch_switch_to(current);
 
 	return current->thread.prev_sched;
 }
-- 
1.8.3.1

