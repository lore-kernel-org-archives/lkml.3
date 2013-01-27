Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3A0Aks (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:40:48 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:47506 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab3A0Akq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:40:46 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/12] rcu: Provide compile-time control for no-CBs CPUs
Date: Sat, 26 Jan 2013 16:29:53 -0800
Message-Id: <1359246603-6863-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1359246603-6863-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130127002943.GA6067@linux.vnet.ibm.com>
 <1359246603-6863-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012700-7606-0000-0000-000007C886F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Currently, the only way to specify no-CBs CPUs is via the rcu_nocbs
kernel command-line parameter.  This is inconvenient in some cases,
particularly for randconfig testing, so this commit adds a new
RCU_NOCB_CPU_DEFAULT kernel configuration parameter.  Setting this
new parameter to zero (the default) retains the old behavior, setting
it to one offloads callback processing from CPU 0 (along with any
other CPUs specified by the rcu_nocbs boot-time parameter), and setting
it to two offloads callback processing from all CPUs.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig            |   35 +++++++++++++++++++++++++++++++++++
 kernel/rcutree_plugin.h |   14 ++++++++++++++
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 97fc178..9a04156 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -686,6 +686,41 @@ config RCU_NOCB_CPU
 	  Say Y here if you want to help to debug reduced OS jitter.
 	  Say N here if you are unsure.
 
+choice
+	prompt "Build-forced no-CBs CPUs"
+	default RCU_NOCB_CPU_NONE
+
+config RCU_NOCB_CPU_NONE
+	bool "No build_forced no-CBs CPUs"
+	depends on RCU_NOCB_CPU
+	help
+	  This option does not force any of the CPUs to be no-CBs CPUs.
+	  Only CPUs designated by the rcu_nocbs= boot parameter will be
+	  no-CBs CPUs.
+
+config RCU_NOCB_CPU_ZERO
+	bool "CPU 0 is a build_forced no-CBs CPU"
+	depends on RCU_NOCB_CPU
+	help
+	  This option forces CPU 0 to be a no-CBs CPU.  Additional CPUs
+	  may be designated as no-CBs CPUs using the rcu_nocbs= boot
+	  parameter will be no-CBs CPUs.
+
+	  Select this if CPU 0 needs to be a no-CBs CPU for real-time
+	  or energy-efficiency reasons.
+
+config RCU_NOCB_CPU_ALL
+	bool "All CPUs are build_forced no-CBs CPUs"
+	depends on RCU_NOCB_CPU
+	help
+	  This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
+	  boot parameter will be ignored.
+
+	  Select this if all CPUs need to be no-CBs CPUs for real-time
+	  or energy-efficiency reasons.
+
+endchoice
+
 endmenu # "RCU Subsystem"
 
 config IKCONFIG
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 2db3160..e32236e 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -85,6 +85,20 @@ static void __init rcu_bootup_announce_oddness(void)
 	if (nr_cpu_ids != NR_CPUS)
 		printk(KERN_INFO "\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
 #ifdef CONFIG_RCU_NOCB_CPU
+#ifndef CONFIG_RCU_NOCB_CPU_NONE
+	if (!have_rcu_nocb_mask) {
+		alloc_bootmem_cpumask_var(&rcu_nocb_mask);
+		have_rcu_nocb_mask = true;
+	}
+#ifdef CONFIG_RCU_NOCB_CPU_ZERO
+	pr_info("\tExperimental no-CBs CPU 0\n");
+	cpumask_set_cpu(0, rcu_nocb_mask);
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
+#ifdef CONFIG_RCU_NOCB_CPU_ALL
+	pr_info("\tExperimental no-CBs for all CPUs\n");
+	cpumask_setall(rcu_nocb_mask);
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
 	if (have_rcu_nocb_mask) {
 		cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
 		pr_info("\tExperimental no-CBs CPUs: %s.\n", nocb_buf);
-- 
1.7.8

