Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbaEGPfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:35:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbaEGPfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:35:16 -0400
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, ak@linux.intel.com,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 5/5] x86, nmi: Add better NMI stats to /proc/interrupts and show handlers
Date: Wed,  7 May 2014 11:34:43 -0400
Message-Id: <1399476883-98970-6-git-send-email-dzickus@redhat.com>
In-Reply-To: <1399476883-98970-1-git-send-email-dzickus@redhat.com>
References: <1399476883-98970-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main reason for this patch is because I have a hard time knowing
what NMI handlers are registered on the system when debugging NMI issues.

This info is provided in /proc/interrupts for interrupt handlers, so I
added support for NMI stuff too.  As a bonus it provides stat breakdowns
much like the interrupts.

The only ugly issue is how to label NMI subtypes using only 3 letters
and still make it obvious it is part of the NMI.  Adding a /proc/nmi
seemed overkill, so I choose to indent things by one space.  Sample
output is below:

[root@dhcp71-248 ~]# cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
  0:         29          0          0          0  IR-IO-APIC-edge      timer
<snip>
NMI:         20        774      10986       4227   Non-maskable interrupts
 LOC:         21        775      10987       4228  Local     PMI, arch_bt
 EXT:          0          0          0          0  External  plat
 UNK:          0          0          0          0  Unknown
 SWA:          0          0          0          0  Swallowed
LOC:      30374      24749      20795      15095   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:         20        774      10986       4227   Performance monitoring interrupts
<snip>

The extra 'local' NMI count represents the number of NMIs 'handled'
whereas the general NMI count represents how many actual NMIs were
processed.  IOW, two NMIs came in at once during one call.

I am open to better suggestions.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/nmi.h |    1 +
 arch/x86/kernel/irq.c      |    3 ++
 arch/x86/kernel/nmi.c      |   57 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 47e8cff..47706af 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -60,6 +60,7 @@ void unregister_nmi_handler(unsigned int, const char *);
 void stop_nmi(void);
 void restart_nmi(void);
 void local_touch_nmi(void);
+void nmi_show_interrupts(struct seq_file *, int);
 
 int register_nmi_default_external_handler(void);
 void unregister_nmi_default_external_handler(void);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index d99f31d..520359c 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -17,6 +17,7 @@
 #include <asm/idle.h>
 #include <asm/mce.h>
 #include <asm/hw_irq.h>
+#include <asm/nmi.h>
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/irq_vectors.h>
@@ -59,6 +60,8 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->__nmi_count);
 	seq_printf(p, "  Non-maskable interrupts\n");
+	nmi_show_interrupts(p, prec);
+
 #ifdef CONFIG_X86_LOCAL_APIC
 	seq_printf(p, "%*s: ", prec, "LOC");
 	for_each_online_cpu(j)
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 7359e53..8741933 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -388,6 +388,63 @@ static __kprobes void default_do_nmi(struct pt_regs *regs)
 		unknown_nmi_error(regs);
 }
 
+static void print_nmi_action_name(struct seq_file *p, int type)
+{
+	struct nmi_desc *desc;
+	struct nmiaction *a;
+
+	rcu_read_lock();
+
+	desc = nmi_to_desc(type);
+
+	if (!(list_empty(&desc->head))) {
+
+		a = list_entry_rcu(desc->head.next, struct nmiaction, list);
+		seq_printf(p, "  %s", a->name);
+
+		list_for_each_entry_continue_rcu(a, &desc->head, list)
+			seq_printf(p, ", %s", a->name);
+
+	}
+	seq_puts(p, "\n");
+
+	rcu_read_unlock();
+}
+
+void nmi_show_interrupts(struct seq_file *p, int prec)
+{
+	int j;
+	int indent = prec + 1;
+
+#define get_nmi_stats(j)	(&per_cpu(nmi_stats, j))
+
+	seq_printf(p, "%*s: ", indent, "LOC");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", get_nmi_stats(j)->normal);
+	seq_printf(p, " %-8s", "Local");
+
+	print_nmi_action_name(p, NMI_LOCAL);
+
+	seq_printf(p, "%*s: ", indent, "EXT");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", get_nmi_stats(j)->external);
+	seq_printf(p, " %-8s", "External");
+
+	print_nmi_action_name(p, NMI_EXT);
+
+	seq_printf(p, "%*s: ", indent, "UNK");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", get_nmi_stats(j)->unknown);
+	seq_printf(p, " %-8s", "Unknown");
+
+	print_nmi_action_name(p, NMI_UNKNOWN);
+
+	seq_printf(p, "%*s: ", indent, "SWA");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", get_nmi_stats(j)->swallow);
+	seq_printf(p, " %-8s", "Swallowed\n");
+}
+
 /*
  * Prevent NMI reason port (0x61) being accessed simultaneously, can
  * only be used in NMI handler.
-- 
1.7.1

