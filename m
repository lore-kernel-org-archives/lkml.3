Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaEOT2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:28:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100AbaEOT0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:26:46 -0400
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Elliott@hp.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 6/6 V2] x86, nmi: Add better NMI stats to /proc/interrupts and show handlers
Date: Thu, 15 May 2014 15:25:49 -0400
Message-Id: <1400181949-157170-7-git-send-email-dzickus@redhat.com>
In-Reply-To: <1400181949-157170-1-git-send-email-dzickus@redhat.com>
References: <1400181949-157170-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main reason for this patch is because I have a hard time knowing
what NMI handlers are registered on the system when debugging NMI issues.

This info is provided in /proc/interrupts for interrupt handlers, so I
added support for NMI stuff too.  As a bonus it provides stat breakdowns
much like the interrupts.

[root@dhcp71-248 ~]# cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
  0:         32          0          0          0  IR-IO-APIC-edge      timer
<snip>
NMI:         13         15          7          6   Non-maskable interrupts
NLC:         12         13          8          7   NMI: Local  (PMI, arch_bt)
NXT:          0          0          0          0   NMI: External  (plat)
NUN:          0          0          0          0   NMI: Unknown
NSW:          0          0          0          0   NMI: Swallowed
LOC:      23768      18248      14187      15891   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:         11         12          7          6   Performance monitoring interrupts
IWI:       2131       1196        862       1113   IRQ work interrupts

The extra 'local' NMI count represents the number of NMIs 'handled'
whereas the general NMI count represents how many actual NMIs were
processed.  IOW, two NMIs came in at once during one call.

I am open to better suggestions.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
V2: modified output based on feedback (Ingo Molnar, Rob Elliott)
---
 arch/x86/include/asm/nmi.h |    1 +
 arch/x86/kernel/irq.c      |    3 ++
 arch/x86/kernel/nmi.c      |   57 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index c8ffab3..cbb49a2 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -63,6 +63,7 @@ void unregister_nmi_handler(unsigned int, const char *);
 void stop_nmi(void);
 void restart_nmi(void);
 void local_touch_nmi(void);
+void nmi_show_interrupts(struct seq_file *, int);
 
 int register_nmi_default_external_handler(void);
 void unregister_nmi_default_external_handler(void);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 42805fa..a969f87 100644
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
index 458be2a..f54fea3 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -506,6 +506,63 @@ static __kprobes void default_do_nmi(struct pt_regs *regs)
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
+		seq_printf(p, "  (%s", a->name);
+
+		list_for_each_entry_continue_rcu(a, &desc->head, list)
+			seq_printf(p, ", %s", a->name);
+
+		seq_printf(p, ")");
+	}
+	seq_puts(p, "\n");
+
+	rcu_read_unlock();
+}
+
+void nmi_show_interrupts(struct seq_file *p, int prec)
+{
+	int j;
+
+#define get_nmi_stats(j)	(&per_cpu(nmi_stats, j))
+
+	seq_printf(p, "%*s: ", prec, "NLC");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", get_nmi_stats(j)->normal);
+	seq_printf(p, " %-8s", " NMI: Local");
+
+	print_nmi_action_name(p, NMI_LOCAL);
+
+	seq_printf(p, "%*s: ", prec, "NXT");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", get_nmi_stats(j)->external);
+	seq_printf(p, " %-8s", " NMI: External");
+
+	print_nmi_action_name(p, NMI_EXT);
+
+	seq_printf(p, "%*s: ", prec, "NUN");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", get_nmi_stats(j)->unknown);
+	seq_printf(p, " %-8s", " NMI: Unknown");
+
+	print_nmi_action_name(p, NMI_UNKNOWN);
+
+	seq_printf(p, "%*s: ", prec, "NSW");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", get_nmi_stats(j)->swallow);
+	seq_printf(p, " %-8s", " NMI: Swallowed\n");
+}
+
 /*
  * Prevent NMI reason port (0x61) being accessed simultaneously, can
  * only be used in NMI handler.
-- 
1.7.1

