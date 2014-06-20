Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966510AbaFTTcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:32:17 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:51977 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966329AbaFTTcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:32:07 -0400
Message-Id: <20140620193126.861853673@linux.com>
Date: Fri, 20 Jun 2014 14:31:32 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>
Subject: [PATCH 17/31] uv: Replace __get_cpu_var
References: <20140620193115.547427118@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_uv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __this_cpu_read instead.

Cc: Hedi Berriche <hedi@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2014-06-16 09:45:44.948069805 -0500
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2014-06-16 09:47:15.326306504 -0500
@@ -601,16 +601,16 @@
 
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
--- linux.orig/arch/x86/platform/uv/uv_nmi.c	2014-06-16 09:45:44.948069805 -0500
+++ linux/arch/x86/platform/uv/uv_nmi.c	2014-06-16 09:45:44.944069883 -0500
@@ -215,7 +215,7 @@
 	int nmi = 0;
 
 	local64_inc(&uv_nmi_count);
-	uv_cpu_nmi.queries++;
+	this_cpu_inc(uv_cpu_nmi.queries);
 
 	do {
 		nmi = atomic_read(&hub_nmi->in_nmi);
@@ -293,7 +293,7 @@
 	int cpu;
 
 	for_each_cpu(cpu, uv_nmi_cpu_mask)
-		atomic_set(&uv_cpu_nmi_per(cpu).pinging, 1);
+		uv_cpu_nmi_per(cpu).pinging = 1;
 
 	apic->send_IPI_mask(uv_nmi_cpu_mask, APIC_DM_NMI);
 }
@@ -304,8 +304,8 @@
 	int cpu;
 
 	for_each_cpu(cpu, uv_nmi_cpu_mask) {
-		atomic_set(&uv_cpu_nmi_per(cpu).pinging, 0);
-		atomic_set(&uv_cpu_nmi_per(cpu).state, UV_NMI_STATE_OUT);
+		uv_cpu_nmi_per(cpu).pinging =  0;
+		uv_cpu_nmi_per(cpu).state = UV_NMI_STATE_OUT;
 		cpumask_clear_cpu(cpu, uv_nmi_cpu_mask);
 	}
 }
@@ -328,7 +328,7 @@
 		int loop_delay = uv_nmi_loop_delay;
 
 		for_each_cpu(j, uv_nmi_cpu_mask) {
-			if (atomic_read(&uv_cpu_nmi_per(j).state)) {
+			if (uv_cpu_nmi_per(j).state) {
 				cpumask_clear_cpu(j, uv_nmi_cpu_mask);
 				if (++k >= n)
 					break;
@@ -359,7 +359,7 @@
 static void uv_nmi_wait(int master)
 {
 	/* indicate this cpu is in */
-	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_IN);
+	this_cpu_write(uv_cpu_nmi.state, UV_NMI_STATE_IN);
 
 	/* if not the first cpu in (the master), then we are a slave cpu */
 	if (!master)
@@ -419,7 +419,7 @@
 			"UV:%sNMI process trace for CPU %d\n", dots, cpu);
 		show_regs(regs);
 	}
-	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_DUMP_DONE);
+	this_cpu_write(uv_cpu_nmi.state, UV_NMI_STATE_DUMP_DONE);
 }
 
 /* Trigger a slave cpu to dump it's state */
@@ -427,20 +427,20 @@
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
@@ -488,7 +488,7 @@
 	} else {
 		while (!atomic_read(&uv_nmi_slave_continue))
 			cpu_relax();
-		while (atomic_read(&uv_cpu_nmi.state) != UV_NMI_STATE_DUMP)
+		while (this_cpu_read(uv_cpu_nmi.state) != UV_NMI_STATE_DUMP)
 			cpu_relax();
 		uv_nmi_dump_state_cpu(cpu, regs);
 	}
@@ -615,7 +615,7 @@
 	local_irq_save(flags);
 
 	/* If not a UV System NMI, ignore */
-	if (!atomic_read(&uv_cpu_nmi.pinging) && !uv_check_nmi(hub_nmi)) {
+	if (!this_cpu_read(uv_cpu_nmi.pinging) && !uv_check_nmi(hub_nmi)) {
 		local_irq_restore(flags);
 		return NMI_DONE;
 	}
@@ -639,7 +639,7 @@
 		uv_call_kgdb_kdb(cpu, regs, master);
 
 	/* Clear per_cpu "in nmi" flag */
-	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_OUT);
+	this_cpu_write(uv_cpu_nmi.state, UV_NMI_STATE_OUT);
 
 	/* Clear MMR NMI flag on each hub */
 	uv_clear_nmi(cpu);
@@ -666,16 +666,16 @@
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
 

