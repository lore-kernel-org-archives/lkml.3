Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab3CRVk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:40:57 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44964 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933141Ab3CRVhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:37:01 -0400
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
Subject: [PATCH tip/core/rcu 02/15] rcu: Provide compile-time control for no-CBs CPUs
Date: Mon, 18 Mar 2013 14:36:37 -0700
Message-Id: <1363642610-21390-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130318213608.GA20296@linux.vnet.ibm.com>
 <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031821-3620-0000-0000-000001AC9325
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Currently, the only way to specify no-CBs CPUs is via the rcu_nocbs
kernel command-line parameter.  This is inconvenient in some cases,
particularly for randconfig testing, so this commit adds a new set of
kernel configuration parameters.  CONFIG_RCU_NOCB_CPU_NONE (the default)
retains the old behavior, CONFIG_RCU_NOCB_CPU_ZERO offloads callback
processing from CPU 0 (along with any other CPUs specified by the
rcu_nocbs boot-time parameter), and CONFIG_RCU_NOCB_CPU_ALL offloads
callback processing from all CPUs.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig            | 37 +++++++++++++++++++++++++++++++++++++
 kernel/rcutree_plugin.h | 14 ++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index c8bd349..5e9e617 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -676,6 +676,43 @@ config RCU_NOCB_CPU
 	  Say Y here if you want to help to debug reduced OS jitter.
 	  Say N here if you are unsure.
 
+choice
+	prompt "Build-forced no-CBs CPUs"
+	default RCU_NOCB_CPU_NONE
+	help
+	  This option allows no-CBs CPUs to be specified at build time.
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
index 44f958a..3e33aef 100644
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
1.8.1.5

