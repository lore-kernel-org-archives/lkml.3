Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab3ENR4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:56:08 -0400
Received: from mail-ye0-f181.google.com ([209.85.213.181]:56917 "EHLO
	mail-ye0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475Ab3ENR4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:56:06 -0400
Date: Tue, 14 May 2013 10:55:59 -0700
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>, davem@davemloft.net,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robin Randhawa <robin.randhawa@arm.com>,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>,
        Steve Bannister <Steve.Bannister@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Patch Tracking <patches@linaro.org>, airlied@redhat.com,
        mingo@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH V5 1/5] workqueues: Introduce new flag WQ_POWER_EFFICIENT
 for power oriented workqueues
Message-ID: <20130514175559.GH6795@mtj.dyndns.org>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
 <480f5d6da920e2f2b868f311228c81635727799e.1366803121.git.viresh.kumar@linaro.org>
 <CAP245DWtwguSp8ubid_KJnLSOqvCbmTXN+0Bg_MtDrUhBqve-Q@mail.gmail.com>
 <CAKohpokN_o-RUX6MDwqqfzu4NKRysG-hSzmB=MHV7Y0aDbztuA@mail.gmail.com>
 <20130424161208.GA16991@mtj.dyndns.org>
 <CAP245DUGuaSQbP4026N8kgn6-NqXFJWR3zKoYud=HQ_b+v5+Xw@mail.gmail.com>
 <CAKohpo=U5OqN7SM7XyOWv-WoUHOoJvGc6wcGH61+uikPK3novg@mail.gmail.com>
 <20130426191118.GD1433@mtj.dyndns.org>
 <CAKohpo=5eTz2Kfded_D988wTeiQbKv35C36cPC9N1NXwnW4mzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=5eTz2Kfded_D988wTeiQbKv35C36cPC9N1NXwnW4mzQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From cee22a15052faa817e3ec8985a28154d3fabc7aa Mon Sep 17 00:00:00 2001
From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Mon, 8 Apr 2013 16:45:40 +0530
Subject: workqueues: Introduce new flag WQ_POWER_EFFICIENT for power oriented workqueues

Workqueues can be performance or power-oriented. Currently, most workqueues are
bound to the CPU they were created on. This gives good performance (due to cache
effects) at the cost of potentially waking up otherwise idle cores (Idle from
scheduler's perspective. Which may or may not be physically idle) just to
process some work. To save power, we can allow the work to be rescheduled on a
core that is already awake.

Workqueues created with the WQ_UNBOUND flag will allow some power savings.
However, we don't change the default behaviour of the system.  To enable
power-saving behaviour, a new config option CONFIG_WQ_POWER_EFFICIENT needs to
be turned on. This option can also be overridden by the
workqueue.power_efficient boot parameter.

tj: Updated config description and comments.  Renamed
    CONFIG_WQ_POWER_EFFICIENT to CONFIG_WQ_POWER_EFFICIENT_DEFAULT.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 Documentation/kernel-parameters.txt | 15 +++++++++++++++
 include/linux/workqueue.h           | 27 +++++++++++++++++++++++++++
 kernel/power/Kconfig                | 20 ++++++++++++++++++++
 kernel/workqueue.c                  | 13 +++++++++++++
 4 files changed, 75 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c3bfacb..37dfd72 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3320,6 +3320,21 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			that this also can be controlled per-workqueue for
 			workqueues visible under /sys/bus/workqueue/.
 
+	workqueue.power_efficient
+			Per-cpu workqueues are generally preferred because
+			they show better performance thanks to cache
+			locality; unfortunately, per-cpu workqueues tend to
+			be more power hungry than unbound workqueues.
+
+			Enabling this makes the per-cpu workqueues which
+			were observed to contribute significantly to power
+			consumption unbound, leading to measurably lower
+			power usage at the cost of small performance
+			overhead.
+
+			The default value of this parameter is determined by
+			the config option CONFIG_WQ_POWER_EFFICIENT_DEFAULT.
+
 	x2apic_phys	[X86-64,APIC] Use x2apic physical mode instead of
 			default x2apic cluster mode on platforms
 			supporting x2apic.
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 623488f..fc0136b 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -303,6 +303,33 @@ enum {
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
 	WQ_SYSFS		= 1 << 6, /* visible in sysfs, see wq_sysfs_register() */
 
+	/*
+	 * Per-cpu workqueues are generally preferred because they tend to
+	 * show better performance thanks to cache locality.  Per-cpu
+	 * workqueues exclude the scheduler from choosing the CPU to
+	 * execute the worker threads, which has an unfortunate side effect
+	 * of increasing power consumption.
+	 *
+	 * The scheduler considers a CPU idle if it doesn't have any task
+	 * to execute and tries to keep idle cores idle to conserve power;
+	 * however, for example, a per-cpu work item scheduled from an
+	 * interrupt handler on an idle CPU will force the scheduler to
+	 * excute the work item on that CPU breaking the idleness, which in
+	 * turn may lead to more scheduling choices which are sub-optimal
+	 * in terms of power consumption.
+	 *
+	 * Workqueues marked with WQ_POWER_EFFICIENT are per-cpu by default
+	 * but become unbound if workqueue.power_efficient kernel param is
+	 * specified.  Per-cpu workqueues which are identified to
+	 * contribute significantly to power-consumption are identified and
+	 * marked with this flag and enabling the power_efficient mode
+	 * leads to noticeable power saving at the cost of small
+	 * performance disadvantage.
+	 *
+	 * http://thread.gmane.org/gmane.linux.kernel/1480396
+	 */
+	WQ_POWER_EFFICIENT	= 1 << 7,
+
 	__WQ_DRAINING		= 1 << 16, /* internal: workqueue is draining */
 	__WQ_ORDERED		= 1 << 17, /* internal: workqueue is ordered */
 
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 5dfdc9e..4645596 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -263,6 +263,26 @@ config PM_GENERIC_DOMAINS
 	bool
 	depends on PM
 
+config WQ_POWER_EFFICIENT_DEFAULT
+	bool "Enable workqueue power-efficient mode by default"
+	depends on PM
+	default n
+	help
+	  Per-cpu workqueues are generally preferred because they show
+	  better performance thanks to cache locality; unfortunately,
+	  per-cpu workqueues tend to be more power hungry than unbound
+	  workqueues.
+
+	  Enabling workqueue.power_efficient kernel parameter makes the
+	  per-cpu workqueues which were observed to contribute
+	  significantly to power consumption unbound, leading to measurably
+	  lower power usage at the cost of small performance overhead.
+
+	  This config option determines whether workqueue.power_efficient
+	  is enabled by default.
+
+	  If in doubt, say N.
+
 config PM_GENERIC_DOMAINS_SLEEP
 	def_bool y
 	depends on PM_SLEEP && PM_GENERIC_DOMAINS
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4aa9f5b..8068d97 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -272,6 +272,15 @@ static cpumask_var_t *wq_numa_possible_cpumask;
 static bool wq_disable_numa;
 module_param_named(disable_numa, wq_disable_numa, bool, 0444);
 
+/* see the comment above the definition of WQ_POWER_EFFICIENT */
+#ifdef CONFIG_WQ_POWER_EFFICIENT_DEFAULT
+static bool wq_power_efficient = true;
+#else
+static bool wq_power_efficient;
+#endif
+
+module_param_named(power_efficient, wq_power_efficient, bool, 0444);
+
 static bool wq_numa_enabled;		/* unbound NUMA affinity enabled */
 
 /* buf for wq_update_unbound_numa_attrs(), protected by CPU hotplug exclusion */
@@ -4085,6 +4094,10 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	struct workqueue_struct *wq;
 	struct pool_workqueue *pwq;
 
+	/* see the comment above the definition of WQ_POWER_EFFICIENT */
+	if ((flags & WQ_POWER_EFFICIENT) && wq_power_efficient)
+		flags |= WQ_UNBOUND;
+
 	/* allocate wq and format name */
 	if (flags & WQ_UNBOUND)
 		tbl_size = wq_numa_tbl_len * sizeof(wq->numa_pwq_tbl[0]);
-- 
1.8.1.4

