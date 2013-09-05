Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3IEWuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:50:40 -0400
Received: from relay2.sgi.com ([192.48.179.30]:52510 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752811Ab3IEWuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:50:35 -0400
Message-Id: <20130905225033.414718556@asylum.americas.sgi.com>
References: <20130905225032.879120272@asylum.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 05 Sep 2013 17:50:35 -0500
From: Mike Travis <travis@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] x86/UV: Add summary of cpu activity to UV NMI handler
Content-Disposition: inline; filename=uv-dump-ips-on-nmi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The standard NMI handler dumps the states of all the cpus.  This includes
a full register dump and stack trace.  This can be way more information
than what is needed.  This patch adds a "summary" dump that is basically
a form of the "ps" command.  It includes the symbolic IP address as well
as the command field and basic process information.

It is enabled when the nmi action is changed to "ips".

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Reviewed-by: Hedi Berriche <hberrich@sgi.com>
---
 arch/x86/platform/uv/uv_nmi.c |   48 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

--- linux.orig/arch/x86/platform/uv/uv_nmi.c
+++ linux/arch/x86/platform/uv/uv_nmi.c
@@ -139,6 +139,19 @@ module_param_named(wait_count, uv_nmi_wa
 static int uv_nmi_retry_count = 500;
 module_param_named(retry_count, uv_nmi_retry_count, int, 0644);
 
+/*
+ * Valid NMI Actions:
+ *  "dump"	- dump process stack for each cpu
+ *  "ips"	- dump IP info for each cpu
+ */
+static char uv_nmi_action[8] = "dump";
+module_param_string(action, uv_nmi_action, sizeof(uv_nmi_action), 0644);
+
+static inline bool uv_nmi_action_is(const char *action)
+{
+	return (strncmp(uv_nmi_action, action, strlen(action)) == 0);
+}
+
 /* Setup which NMI support is present in system */
 static void uv_nmi_setup_mmrs(void)
 {
@@ -367,13 +380,38 @@ static void uv_nmi_wait(int master)
 		atomic_read(&uv_nmi_cpus_in_nmi), num_online_cpus());
 }
 
+static void uv_nmi_dump_cpu_ip_hdr(void)
+{
+	printk(KERN_DEFAULT
+		"\nUV: %4s %6s %-32s %s   (Note: PID 0 not listed)\n",
+		"CPU", "PID", "COMMAND", "IP");
+}
+
+static void uv_nmi_dump_cpu_ip(int cpu, struct pt_regs *regs)
+{
+	printk(KERN_DEFAULT "UV: %4d %6d %-32.32s ",
+		cpu, current->pid, current->comm);
+
+	printk_address(regs->ip, 1);
+}
+
 /* Dump this cpu's state */
 static void uv_nmi_dump_state_cpu(int cpu, struct pt_regs *regs)
 {
 	const char *dots = " ................................. ";
 
-	printk(KERN_DEFAULT "UV:%sNMI process trace for CPU %d\n", dots, cpu);
-	show_regs(regs);
+	if (uv_nmi_action_is("ips")) {
+		if (cpu == 0)
+			uv_nmi_dump_cpu_ip_hdr();
+
+		if (current->pid != 0)
+			uv_nmi_dump_cpu_ip(cpu, regs);
+
+	} else if (uv_nmi_action_is("dump")) {
+		printk(KERN_DEFAULT
+			"UV:%sNMI process trace for CPU %d\n", dots, cpu);
+		show_regs(regs);
+	}
 	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_DUMP_DONE);
 }
 
@@ -420,7 +458,8 @@ static void uv_nmi_dump_state(int cpu, s
 		int ignored = 0;
 		int saved_console_loglevel = console_loglevel;
 
-		pr_alert("UV: tracing processes for %d CPUs from CPU %d\n",
+		pr_alert("UV: tracing %s for %d CPUs from CPU %d\n",
+			uv_nmi_action_is("ips") ? "IPs" : "processes",
 			atomic_read(&uv_nmi_cpus_in_nmi), cpu);
 
 		console_loglevel = uv_nmi_loglevel;
@@ -482,7 +521,8 @@ int uv_handle_nmi(unsigned int reason, s
 	uv_nmi_wait(master);
 
 	/* Dump state of each cpu */
-	uv_nmi_dump_state(cpu, regs, master);
+	if (uv_nmi_action_is("ips") || uv_nmi_action_is("dump"))
+		uv_nmi_dump_state(cpu, regs, master);
 
 	/* Clear per_cpu "in nmi" flag */
 	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_OUT);

-- 
