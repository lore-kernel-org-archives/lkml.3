Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab3LPENp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 23:13:45 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:40121 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab3LPEI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 23:08:57 -0500
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 01/16] uprobes: allow ignoring of probe hits
Date: Sun, 15 Dec 2013 23:08:35 -0500
Message-Id: <1387166930-13182-2-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387166930-13182-1-git-send-email-dave.long@linaro.org>
References: <1387166930-13182-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Allow arches to decided to ignore a probe hit.  ARM will use this to
only call handlers if the conditions to execute a conditionally executed
instruction are satisfied.

Signed-off-by: David A. Long <dave.long@linaro.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/uprobes.h | 1 +
 kernel/events/uprobes.c | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 319eae7..197a36e 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -134,6 +134,7 @@ extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
 extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
 extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
+extern bool __weak arch_uprobe_ignore(struct arch_uprobe *aup, struct pt_regs *regs);
 #else /* !CONFIG_UPROBES */
 struct uprobes_state {
 };
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 24b7d6c..4eec7ce 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1778,6 +1778,11 @@ static bool handle_trampoline(struct pt_regs *regs)
 	return true;
 }
 
+bool __weak arch_uprobe_ignore(struct arch_uprobe *aup, struct pt_regs *regs)
+{
+	return false;
+}
+
 /*
  * Run handler and ask thread to singlestep.
  * Ensure all non-fatal signals cannot interrupt thread while it singlesteps.
@@ -1828,7 +1833,11 @@ static void handle_swbp(struct pt_regs *regs)
 	if (unlikely(!test_bit(UPROBE_COPY_INSN, &uprobe->flags)))
 		goto out;
 
+	if (arch_uprobe_ignore(&uprobe->arch, regs))
+		goto out;
+
 	handler_chain(uprobe, regs);
+
 	if (can_skip_sstep(uprobe, regs))
 		goto out;
 
-- 
1.8.1.2

