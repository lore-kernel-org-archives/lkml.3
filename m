Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3CKLDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:03:10 -0400
Received: from mail1.windriver.com ([147.11.146.13]:54858 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab3CKLDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:03:07 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>, <galak@kernel.crashing.org>
CC: <jason.wessel@windriver.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [v4][PATCH 7/7] book3e/kgdb: Fix a single stgep case of lazy IRQ
Date: Mon, 11 Mar 2013 19:02:46 +0800
Message-ID: <1362999766-20897-8-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362999766-20897-1-git-send-email-tiejun.chen@windriver.com>
References: <1362999766-20897-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we're in kgdb_singlestep(), we have to work around to get
thread_info by copying from the kernel stack before calling
kgdb_handle_exception(), then copying it back afterwards.

But for PPC64, we have a lazy interrupt implementation. So after
copying thread info frome kernle stack, if we need to replay an
interrupt, we shouldn't restore that previous backup thread info
to make sure we can replay an interrupt lately with a proper
thread info.

This patch use __check_irq_replay() to guarantee this process.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/kernel/irq.c  |   10 ++++++++++
 arch/powerpc/kernel/kgdb.c |    3 ++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 4f97fe3..bb8d27a 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -339,7 +339,17 @@ bool prep_irq_for_idle(void)
 	return true;
 }
 
+notrace unsigned int check_irq_replay(void)
+{
+	return __check_irq_replay();
+}
+#else
+notrace unsigned int check_irq_replay(void)
+{
+	return 0;
+}
 #endif /* CONFIG_PPC64 */
+EXPORT_SYMBOL(check_irq_replay);
 
 int arch_show_interrupts(struct seq_file *p, int prec)
 {
diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index cde7818..5b30408 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -152,6 +152,7 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
 }
 
 static DEFINE_PER_CPU(struct thread_info, kgdb_thread_info);
+extern notrace unsigned int check_irq_replay(void);
 static int kgdb_singlestep(struct pt_regs *regs)
 {
 	struct thread_info *thread_info, *exception_thread_info;
@@ -181,7 +182,7 @@ static int kgdb_singlestep(struct pt_regs *regs)
 
 	kgdb_handle_exception(0, SIGTRAP, 0, regs);
 
-	if (thread_info != exception_thread_info)
+	if ((thread_info != exception_thread_info) && (!check_irq_replay()))
 		/* Restore current_thread_info lastly. */
 		memcpy(exception_thread_info, backup_current_thread_info, sizeof *thread_info);
 
-- 
1.7.9.5

