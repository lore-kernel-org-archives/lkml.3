Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaHKLh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:37:58 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51716 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaHKLh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:37:56 -0400
Subject: [RFC PATCH V2 10/19] sched: detect wakeup burst with rq->avg_idle
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: alex.shi@intel.com, vincent.guittot@linaro.org, peterz@infradead.org,
        pjt@google.com, efault@gmx.de, rjw@rjwysocki.net,
        morten.rasmussen@arm.com, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org
Cc: nicolas.pitre@linaro.org, len.brown@intel.com, yuyang.du@intel.com,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        corbet@lwn.net, catalin.marinas@arm.com, markgross@thegnar.org,
        sundar.iyer@intel.com, linux-kernel@vger.kernel.org,
        dietmar.eggemann@arm.com, Lorenzo.Pieralisi@arm.com,
        mike.turquette@linaro.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Date: Mon, 11 Aug 2014 17:07:31 +0530
Message-ID: <20140811113719.31956.86159.stgit@preeti.in.ibm.com>
In-Reply-To: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-9332-0000-0000-000001A6A2DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@intel.com>

rq->avg_idle is 'to used to accommodate bursty loads in a dirt simple
dirt cheap manner' -- Mike Galbraith.

With this cheap and smart bursty indicator, we can find the wake up
burst, and just use nr_running as instant utilization only.

The 'sysctl_sched_burst_threshold' used for wakeup burst, set it as
double of sysctl_sched_migration_cost.

Signed-off-by: Alex Shi <alex.shi@intel.com>
[Added CONFIG_SCHED_POWER switch to enable this patch]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 include/linux/sched/sysctl.h |    3 +++
 kernel/sched/fair.c          |    4 ++++
 kernel/sysctl.c              |    9 +++++++++
 3 files changed, 16 insertions(+)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 596a0e0..0a3307b 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -55,6 +55,9 @@ extern unsigned int sysctl_numa_balancing_scan_size;
 
 #ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_migration_cost;
+#ifdef CONFIG_SCHED_POWER
+extern unsigned int sysctl_sched_burst_threshold;
+#endif /* CONFIG_SCHED_POWER */
 extern unsigned int sysctl_sched_nr_migrate;
 extern unsigned int sysctl_sched_time_avg;
 extern unsigned int sysctl_timer_migration;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 60abaf4..20e2414 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -92,6 +92,10 @@ unsigned int normalized_sysctl_sched_wakeup_granularity = 1000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
+#ifdef CONFIG_SCHED_POWER
+const_debug unsigned int sysctl_sched_burst_threshold = 1000000UL;
+#endif
+
 /*
  * The exponential sliding  window over which load is averaged for shares
  * distribution.
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 75875a7..8175d93 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -329,6 +329,15 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#ifdef CONFIG_SCHED_POWER
+	{
+		.procname	= "sched_burst_threshold_ns",
+		.data		= &sysctl_sched_burst_threshold,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif /* CONFIG_SCHED_POWER */
 	{
 		.procname	= "sched_nr_migrate",
 		.data		= &sysctl_sched_nr_migrate,

