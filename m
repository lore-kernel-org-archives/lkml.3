Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaBJN34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:29:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33119 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaBJN3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:29:52 -0500
Date: Mon, 10 Feb 2014 05:29:17 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-rdw0au56a5ymis1u8p48c12d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, dave.hansen@linux.intel.com, tglx@linutronix.de,
        dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, dave.hansen@linux.intel.com,
        dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/nmi: Push duration printk() to irq context
Git-Commit-ID: e90c78535283dd0ded3bf2e484890d14dba2d527
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:29:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e90c78535283dd0ded3bf2e484890d14dba2d527
Gitweb:     http://git.kernel.org/tip/e90c78535283dd0ded3bf2e484890d14dba2d527
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 3 Feb 2014 18:02:09 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 13:17:22 +0100

x86/nmi: Push duration printk() to irq context

Calling printk() from NMI context is bad (TM), so move it to IRQ
context.

In doing so we slightly change (probably wreck) the debugfs
nmi_longest_ns thingy, in that it doesn't update to reflect the
longest, nor does writing to it reset the count.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-rdw0au56a5ymis1u8p48c12d@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/nmi.h |  3 +++
 arch/x86/kernel/nmi.c      | 37 ++++++++++++++++++++++++-------------
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 86f9301..5f2fc44 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_NMI_H
 #define _ASM_X86_NMI_H
 
+#include <linux/irq_work.h>
 #include <linux/pm.h>
 #include <asm/irq.h>
 #include <asm/io.h>
@@ -38,6 +39,8 @@ typedef int (*nmi_handler_t)(unsigned int, struct pt_regs *);
 struct nmiaction {
 	struct list_head	list;
 	nmi_handler_t		handler;
+	u64			max_duration;
+	struct irq_work		irq_work;
 	unsigned long		flags;
 	const char		*name;
 };
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 6fcb49c..b4872b9 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -87,6 +87,7 @@ __setup("unknown_nmi_panic", setup_unknown_nmi_panic);
 #define nmi_to_desc(type) (&nmi_desc[type])
 
 static u64 nmi_longest_ns = 1 * NSEC_PER_MSEC;
+
 static int __init nmi_warning_debugfs(void)
 {
 	debugfs_create_u64("nmi_longest_ns", 0644,
@@ -95,6 +96,20 @@ static int __init nmi_warning_debugfs(void)
 }
 fs_initcall(nmi_warning_debugfs);
 
+static void nmi_max_handler(struct irq_work *w)
+{
+	struct nmiaction *a = container_of(w, struct nmiaction, irq_work);
+	int remainder_ns, decimal_msecs;
+	u64 whole_msecs = ACCESS_ONCE(a->max_duration);
+
+	remainder_ns = do_div(whole_msecs, (1000 * 1000));
+	decimal_msecs = remainder_ns / 1000;
+
+	printk_ratelimited(KERN_INFO
+		"INFO: NMI handler (%ps) took too long to run: %lld.%03d msecs\n",
+		a->handler, whole_msecs, decimal_msecs);
+}
+
 static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
@@ -110,26 +125,20 @@ static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2
 	 * to handle those situations.
 	 */
 	list_for_each_entry_rcu(a, &desc->head, list) {
-		u64 before, delta, whole_msecs;
-		int remainder_ns, decimal_msecs, thishandled;
+		int thishandled;
+		u64 delta;
 
-		before = sched_clock();
+		delta = sched_clock();
 		thishandled = a->handler(type, regs);
 		handled += thishandled;
-		delta = sched_clock() - before;
+		delta = sched_clock() - delta;
 		trace_nmi_handler(a->handler, (int)delta, thishandled);
 
-		if (delta < nmi_longest_ns)
+		if (delta < nmi_longest_ns || delta < a->max_duration)
 			continue;
 
-		nmi_longest_ns = delta;
-		whole_msecs = delta;
-		remainder_ns = do_div(whole_msecs, (1000 * 1000));
-		decimal_msecs = remainder_ns / 1000;
-		printk_ratelimited(KERN_INFO
-			"INFO: NMI handler (%ps) took too long to run: "
-			"%lld.%03d msecs\n", a->handler, whole_msecs,
-			decimal_msecs);
+		a->max_duration = delta;
+		irq_work_queue(&a->irq_work);
 	}
 
 	rcu_read_unlock();
@@ -146,6 +155,8 @@ int __register_nmi_handler(unsigned int type, struct nmiaction *action)
 	if (!action->handler)
 		return -EINVAL;
 
+	init_irq_work(&action->irq_work, nmi_max_handler);
+
 	spin_lock_irqsave(&desc->lock, flags);
 
 	/*
