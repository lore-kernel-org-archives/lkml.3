Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaHQRgH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:36:07 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:39269 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368AbaHQRbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:31:19 -0400
Message-Id: <20140817173035.721736659@linux.com>
Date: Sun, 17 Aug 2014 12:30:41 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>
Subject: [PATCH 18/35] [PATCH 18/36] uv: Replace __get_cpu_var
References: <20140817173023.439660246@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0018-uv-Replace-__get_cpu_var.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __this_cpu_read instead.

Cc: Hedi Berriche <hedi@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux.com>
---
 arch/x86/include/asm/uv/uv_hub.h | 10 +++++-----
 arch/x86/platform/uv/uv_nmi.c    | 40 ++++++++++++++++++++--------------------
 2 files changed, 25 insertions(+), 25 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h
+++ linux/arch/x86/include/asm/uv/uv_hub.h
@@ -601,16 +601,16 @@ struct uv_hub_nmi_s {
 
 struct uv_cpu_nmi_s {
 	struct uv_hub_nmi_s	*hub;
-	atomic_t		state;
-	atomic_t		pinging;
+	int			state;
+	int			pinging;
 	int			queries;
 	int			pings;
 };
 
-DECLARE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
-#define uv_cpu_nmi			(__get_cpu_var(__uv_cpu_nmi))
+DECLARE_PER_CPU(struct uv_cpu_nmi_s, uv_cpu_nmi);
+
 #define uv_hub_nmi			(uv_cpu_nmi.hub)
-#define uv_cpu_nmi_per(cpu)		(per_cpu(__uv_cpu_nmi, cpu))
+#define uv_cpu_nmi_per(cpu)		(per_cpu(uv_cpu_nmi, cpu))
 #define uv_hub_nmi_per(cpu)		(uv_cpu_nmi_per(cpu).hub)
 
 /* uv_cpu_nmi_states */
Index: linux/arch/x86/platform/uv/uv_nmi.c
===================================================================
--- linux.orig/arch/x86/platform/uv/uv_nmi.c
+++ linux/arch/x86/platform/uv/uv_nmi.c
@@ -63,8 +63,8 @@
 
 static struct uv_hub_nmi_s **uv_hub_nmi_list;
 
-DEFINE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
-EXPORT_PER_CPU_SYMBOL_GPL(__uv_cpu_nmi);
+DEFINE_PER_CPU(struct uv_cpu_nmi_s, uv_cpu_nmi);
+EXPORT_PER_CPU_SYMBOL_GPL(uv_cpu_nmi);
 
 static unsigned long nmi_mmr;
 static unsigned long nmi_mmr_clear;
@@ -215,7 +215,7 @@ static int uv_check_nmi(struct uv_hub_nm
 	int nmi = 0;
 
 	local64_inc(&uv_nmi_count);
-	uv_cpu_nmi.queries++;
+	this_cpu_inc(uv_cpu_nmi.queries);
 
 	do {
 		nmi = atomic_read(&hub_nmi->in_nmi);
@@ -293,7 +293,7 @@ static void uv_nmi_nr_cpus_ping(void)
 	int cpu;
 
 	for_each_cpu(cpu, uv_nmi_cpu_mask)
-		atomic_set(&uv_cpu_nmi_per(cpu).pinging, 1);
+		uv_cpu_nmi_per(cpu).pinging = 1;
 
 	apic->send_IPI_mask(uv_nmi_cpu_mask, APIC_DM_NMI);
 }
@@ -304,8 +304,8 @@ static void uv_nmi_cleanup_mask(void)
 	int cpu;
 
 	for_each_cpu(cpu, uv_nmi_cpu_mask) {
-		atomic_set(&uv_cpu_nmi_per(cpu).pinging, 0);
-		atomic_set(&uv_cpu_nmi_per(cpu).state, UV_NMI_STATE_OUT);
+		uv_cpu_nmi_per(cpu).pinging =  0;
+		uv_cpu_nmi_per(cpu).state = UV_NMI_STATE_OUT;
 		cpumask_clear_cpu(cpu, uv_nmi_cpu_mask);
 	}
 }
@@ -328,7 +328,7 @@ static int uv_nmi_wait_cpus(int first)
 		int loop_delay = uv_nmi_loop_delay;
 
 		for_each_cpu(j, uv_nmi_cpu_mask) {
-			if (atomic_read(&uv_cpu_nmi_per(j).state)) {
+			if (uv_cpu_nmi_per(j).state) {
 				cpumask_clear_cpu(j, uv_nmi_cpu_mask);
 				if (++k >= n)
 					break;
@@ -359,7 +359,7 @@ static int uv_nmi_wait_cpus(int first)
 static void uv_nmi_wait(int master)
 {
 	/* indicate this cpu is in */
-	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_IN);
+	this_cpu_write(uv_cpu_nmi.state, UV_NMI_STATE_IN);
 
 	/* if not the first cpu in (the master), then we are a slave cpu */
 	if (!master)
@@ -419,7 +419,7 @@ static void uv_nmi_dump_state_cpu(int cp
 			"UV:%sNMI process trace for CPU %d\n", dots, cpu);
 		show_regs(regs);
 	}
-	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_DUMP_DONE);
+	this_cpu_write(uv_cpu_nmi.state, UV_NMI_STATE_DUMP_DONE);
 }
 
 /* Trigger a slave cpu to dump it's state */
@@ -427,20 +427,20 @@ static void uv_nmi_trigger_dump(int cpu)
 {
 	int retry = uv_nmi_trigger_delay;
 
-	if (atomic_read(&uv_cpu_nmi_per(cpu).state) != UV_NMI_STATE_IN)
+	if (uv_cpu_nmi_per(cpu).state != UV_NMI_STATE_IN)
 		return;
 
-	atomic_set(&uv_cpu_nmi_per(cpu).state, UV_NMI_STATE_DUMP);
+	uv_cpu_nmi_per(cpu).state = UV_NMI_STATE_DUMP;
 	do {
 		cpu_relax();
 		udelay(10);
-		if (atomic_read(&uv_cpu_nmi_per(cpu).state)
+		if (uv_cpu_nmi_per(cpu).state
 				!= UV_NMI_STATE_DUMP)
 			return;
 	} while (--retry > 0);
 
 	pr_crit("UV: CPU %d stuck in process dump function\n", cpu);
-	atomic_set(&uv_cpu_nmi_per(cpu).state, UV_NMI_STATE_DUMP_DONE);
+	uv_cpu_nmi_per(cpu).state = UV_NMI_STATE_DUMP_DONE;
 }
 
 /* Wait until all cpus ready to exit */
@@ -488,7 +488,7 @@ static void uv_nmi_dump_state(int cpu, s
 	} else {
 		while (!atomic_read(&uv_nmi_slave_continue))
 			cpu_relax();
-		while (atomic_read(&uv_cpu_nmi.state) != UV_NMI_STATE_DUMP)
+		while (this_cpu_read(uv_cpu_nmi.state) != UV_NMI_STATE_DUMP)
 			cpu_relax();
 		uv_nmi_dump_state_cpu(cpu, regs);
 	}
@@ -615,7 +615,7 @@ int uv_handle_nmi(unsigned int reason, s
 	local_irq_save(flags);
 
 	/* If not a UV System NMI, ignore */
-	if (!atomic_read(&uv_cpu_nmi.pinging) && !uv_check_nmi(hub_nmi)) {
+	if (!this_cpu_read(uv_cpu_nmi.pinging) && !uv_check_nmi(hub_nmi)) {
 		local_irq_restore(flags);
 		return NMI_DONE;
 	}
@@ -639,7 +639,7 @@ int uv_handle_nmi(unsigned int reason, s
 		uv_call_kgdb_kdb(cpu, regs, master);
 
 	/* Clear per_cpu "in nmi" flag */
-	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_OUT);
+	this_cpu_write(uv_cpu_nmi.state, UV_NMI_STATE_OUT);
 
 	/* Clear MMR NMI flag on each hub */
 	uv_clear_nmi(cpu);
@@ -666,16 +666,16 @@ static int uv_handle_nmi_ping(unsigned i
 {
 	int ret;
 
-	uv_cpu_nmi.queries++;
-	if (!atomic_read(&uv_cpu_nmi.pinging)) {
+	this_cpu_inc(uv_cpu_nmi.queries);
+	if (!this_cpu_read(uv_cpu_nmi.pinging)) {
 		local64_inc(&uv_nmi_ping_misses);
 		return NMI_DONE;
 	}
 
-	uv_cpu_nmi.pings++;
+	this_cpu_inc(uv_cpu_nmi.pings);
 	local64_inc(&uv_nmi_ping_count);
 	ret = uv_handle_nmi(reason, regs);
-	atomic_set(&uv_cpu_nmi.pinging, 0);
+	this_cpu_write(uv_cpu_nmi.pinging, 0);
 	return ret;
 }
 

