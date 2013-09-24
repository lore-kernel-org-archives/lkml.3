Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab3IXIiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:38:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53250 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3IXIiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:38:05 -0400
Date: Tue, 24 Sep 2013 01:37:46 -0700
From: tip-bot for Mike Travis <tipbot@zytor.com>
Message-ID: <tip-3c121d9a21dc16ef030ad6ca3ebb159b5726fab9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jason.wessel@windriver.com, a.p.zijlstra@chello.nl,
        travis@sgi.com, acme@ghostprotocols.net, hedi@sgi.com,
        sivanich@sgi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, travis@sgi.com, a.p.zijlstra@chello.nl,
        jason.wessel@windriver.com, acme@ghostprotocols.net, hedi@sgi.com,
        sivanich@sgi.com, tglx@linutronix.de
In-Reply-To: <20130923212500.507922930@asylum.americas.sgi.com>
References: <20130923212500.507922930@asylum.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86/UV:
  Add summary of cpu activity to UV NMI handler
Git-Commit-ID: 3c121d9a21dc16ef030ad6ca3ebb159b5726fab9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 24 Sep 2013 01:37:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c121d9a21dc16ef030ad6ca3ebb159b5726fab9
Gitweb:     http://git.kernel.org/tip/3c121d9a21dc16ef030ad6ca3ebb159b5726fab9
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Mon, 23 Sep 2013 16:25:02 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 24 Sep 2013 09:02:03 +0200

x86/UV: Add summary of cpu activity to UV NMI handler

The standard NMI handler dumps the states of all the cpus.  This
includes a full register dump and stack trace.  This can be way
more information than what is needed.  This patch adds a
"summary" dump that is basically a form of the "ps" command.  It
includes the symbolic IP address as well as the command field
and basic process information.

It is enabled when the nmi action is changed to "ips".

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Reviewed-by: Hedi Berriche <hedi@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jason Wessel <jason.wessel@windriver.com>
Link: http://lkml.kernel.org/r/20130923212500.507922930@asylum.americas.sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/uv/uv_nmi.c | 48 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
index fb02ea7..4efcde1 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -139,6 +139,19 @@ module_param_named(wait_count, uv_nmi_wait_count, int, 0644);
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
 
@@ -420,7 +458,8 @@ static void uv_nmi_dump_state(int cpu, struct pt_regs *regs, int master)
 		int ignored = 0;
 		int saved_console_loglevel = console_loglevel;
 
-		pr_alert("UV: tracing processes for %d CPUs from CPU %d\n",
+		pr_alert("UV: tracing %s for %d CPUs from CPU %d\n",
+			uv_nmi_action_is("ips") ? "IPs" : "processes",
 			atomic_read(&uv_nmi_cpus_in_nmi), cpu);
 
 		console_loglevel = uv_nmi_loglevel;
@@ -482,7 +521,8 @@ int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
 	uv_nmi_wait(master);
 
 	/* Dump state of each cpu */
-	uv_nmi_dump_state(cpu, regs, master);
+	if (uv_nmi_action_is("ips") || uv_nmi_action_is("dump"))
+		uv_nmi_dump_state(cpu, regs, master);
 
 	/* Clear per_cpu "in nmi" flag */
 	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_OUT);
