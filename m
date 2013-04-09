Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936937Ab3DIHbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:31:04 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:63440 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936923Ab3DIHbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:31:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130331181931.GA7533@htj.dyndns.org>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
	<91239cde99aaba2715f63db1f88241d9f4a36e13.1364740180.git.viresh.kumar@linaro.org>
	<20130331181931.GA7533@htj.dyndns.org>
Date: Tue, 9 Apr 2013 13:00:59 +0530
Message-ID: <CAKohpomGSkz6_YqDzaTYEsJfVmcg2=TvdgquWqTvd-nmtOmoaQ@mail.gmail.com>
Subject: Re: [PATCH V4 3/4] block: queue work on unbound wq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 March 2013 23:49, Tejun Heo <tj@kernel.org> wrote:
> So, let's please introduce a new flag to mark these workqueues, say,
> WQ_UNBOUND_FOR_POWER_SAVE or whatever (please come up with a better
> name) and provide a compile time switch with boot time override.

Hi Tejun,

I have written a patch to get this done and want to get that a some review
before touching other drivers and spamming LKML with other patches :)

Here it is:

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Mon, 8 Apr 2013 16:45:40 +0530
Subject: [PATCH] workqueues: Introduce new flag WQ_POWER_EFFICIENT for power
 oriented workqueues

Workqueues can be performance or power oriented. For performance we may want to
keep them running on a single cpu, so that it remains cache hot. For power we
can give scheduler the liberty to choose target cpu for running work handler.

Later one (Power oriented WQ) can be achieved if the workqueue is allocated with
WQ_UNBOUND flag. To make this compile time configurable with boot time override
this patch adds in another flag WQ_POWER_EFFICIENT. This will be converted to
WQ_UNBOUND (on wq allocation) if CONFIG_WQ_POWER_EFFICIENT is enabled and
bootargs contain workqueue.power_efficient=1. It is unused otherwise and normal
behavior of WQ without this flag is expected.

CONFIG option is currently added under kernel/power/Kconfig and is looking for
relevant Kconfig file.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 Documentation/kernel-parameters.txt | 15 +++++++++++++++
 include/linux/workqueue.h           |  3 +++
 kernel/power/Kconfig                | 18 ++++++++++++++++++
 kernel/workqueue.c                  | 14 ++++++++++++++
 4 files changed, 50 insertions(+)

diff --git a/Documentation/kernel-parameters.txt
b/Documentation/kernel-parameters.txt
index 12c42a5..210e5fc 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3249,6 +3249,21 @@ bytes respectively. Such letter suffixes can
also be entirely omitted.
 			that this also can be controlled per-workqueue for
 			workqueues visible under /sys/bus/workqueue/.

+	workqueue.power_efficient
+			Workqueues can be performance or power oriented. For
+			performance we may want to keep them running on a single
+			cpu, so that it remains cache hot. For power we can give
+			scheduler the liberty to choose target cpu for running
+			work handler.
+
+			Later one (Power oriented WQ) can be achieved if the
+			workqueue is allocated with WQ_UNBOUND flag. Enabling
+			power_efficient boot param will convert
+			WQ_POWER_EFFICIENT flag to WQ_UNBOUND on wq allocation.
+			This requires CONFIG_WQ_POWER_EFFICIENT to be enabled.
+			WQ_POWER_EFFICIENT is unused if power_efficient is not
+			set in boot params.
+
 	x2apic_phys	[X86-64,APIC] Use x2apic physical mode instead of
 			default x2apic cluster mode on platforms
 			supporting x2apic.
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 1a53816..168b5be 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -299,6 +299,9 @@ enum {
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
 	WQ_SYSFS		= 1 << 6, /* visible in sysfs, see wq_sysfs_register() */
+	WQ_POWER_EFFICIENT	= 1 << 7, /* WQ_UNBOUND, for power
+					   * saving, if wq_power_efficient is
+					   * enabled. Unused otherwise. */

 	__WQ_DRAINING		= 1 << 16, /* internal: workqueue is draining */
 	__WQ_ORDERED		= 1 << 17, /* internal: workqueue is ordered */
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 5dfdc9e..8d62400 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -263,6 +263,24 @@ config PM_GENERIC_DOMAINS
 	bool
 	depends on PM

+config WQ_POWER_EFFICIENT
+	bool "Workqueue allocated as UNBOUND for power efficiency"
+	depends on PM
+	help
+	  Workqueues can be performance or power oriented. For performance we
+	  may want to keep them running on a single cpu, so that it remains
+	  cache hot. For power we can give scheduler the liberty to choose
+	  target cpu for running work handler.
+
+	  Later one (Power oriented WQ) can be achieved if the workqueue is
+	  allocated with WQ_UNBOUND flag. Enabling power_efficient boot param
+	  will convert WQ_POWER_EFFICIENT flag to WQ_UNBOUND on wq allocation.
+	  This requires CONFIG_WQ_POWER_EFFICIENT to be enabled.
+	  WQ_POWER_EFFICIENT is unused if power_efficient is not set in boot
+	  params.
+
+	  If in doubt, say N.
+
 config PM_GENERIC_DOMAINS_SLEEP
 	def_bool y
 	depends on PM_SLEEP && PM_GENERIC_DOMAINS
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1228fd7..590e333 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -271,6 +271,11 @@ static cpumask_var_t *wq_numa_possible_cpumask;
 static bool wq_disable_numa;
 module_param_named(disable_numa, wq_disable_numa, bool, 0444);

+#ifdef CONFIG_WQ_POWER_EFFICIENT
+static bool wq_power_efficient = 0;
+module_param_named(power_efficient, wq_power_efficient, bool, 0444);
+#endif
+
 static bool wq_numa_enabled;		/* unbound NUMA affinity enabled */

 /* buf for wq_update_unbound_numa_attrs(), protected by CPU hotplug
exclusion */
@@ -4085,6 +4090,15 @@ struct workqueue_struct
*__alloc_workqueue_key(const char *fmt,
 	struct workqueue_struct *wq;
 	struct pool_workqueue *pwq;

+	if (flags & WQ_POWER_EFFICIENT) {
+		flags &= ~WQ_POWER_EFFICIENT;
+
+#ifdef CONFIG_WQ_POWER_EFFICIENT
+		if (wq_power_efficient)
+			flags |= WQ_UNBOUND;
+#endif
+	}
+
 	/* allocate wq and format name */
 	if (flags & WQ_UNBOUND)
 		tbl_size = wq_numa_tbl_len * sizeof(wq->numa_pwq_tbl[0]);
