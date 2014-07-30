Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaG3Opb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:45:31 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:47967
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752772AbaG3Opa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:45:30 -0400
Date: Wed, 30 Jul 2014 09:45:26 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: akpm@linux-foundation.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: vmstat: On demand vmstat workers V8
In-Reply-To: <53D85F20.7020206@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.11.1407300934410.4608@gentwo.org>
References: <alpine.DEB.2.11.1407100903130.12483@gentwo.org> <53D85F20.7020206@cn.fujitsu.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2014, Lai Jiangshan wrote:

> I think the bug is here, it re-queues the per_cpu(vmstat_work, cpu) which is offline
> (after vmstat_cpuup_callback(CPU_DOWN_PREPARE).  And cpu_stat_off is accessed without
> proper lock.

Ok. I guess we need to make the preemption check output more information
so that it tells us that an operation was performed on a processor that is
down?

> I suggest to use get_cpu_online() or a new cpu_stat_off_mutex to protect it.

If a processor is downed then cpu_stat_off bit should be cleared but also
the worker thread should not run.

> >  	case CPU_DOWN_PREPARE:
> >  	case CPU_DOWN_PREPARE_FROZEN:
> > -		cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
> > -		per_cpu(vmstat_work, cpu).work.func = NULL;
> > +		if (!cpumask_test_and_set_cpu(cpu, cpu_stat_off))
> > +			cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
>
> It is suggest that cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu)) should
> be called unconditionally.  And the cpu should be cleared from cpu_stat_off.
> (you set it, it is BUG according to vmstat_shepherd() and the semantics of the
> cpu_stat_off).

True.

Subject: vmstat ondemand: Fix online/offline races

Do not allow onlining/offlining while the shepherd task is checking
for vmstat threads.

On offlining a processor do the right thing cancelling the vmstat
worker thread if it exista and also exclude it from the shepherd
process checks.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/vmstat.c
===================================================================
--- linux.orig/mm/vmstat.c	2014-07-30 09:35:54.602662306 -0500
+++ linux/mm/vmstat.c	2014-07-30 09:43:07.109037043 -0500
@@ -1317,6 +1317,7 @@ static void vmstat_shepherd(struct work_
 {
 	int cpu;

+	get_online_cpus();
 	/* Check processors whose vmstat worker threads have been disabled */
 	for_each_cpu(cpu, cpu_stat_off)
 		if (need_update(cpu) &&
@@ -1325,6 +1326,7 @@ static void vmstat_shepherd(struct work_
 			schedule_delayed_work_on(cpu, &per_cpu(vmstat_work, cpu),
 				__round_jiffies_relative(sysctl_stat_interval, cpu));

+	put_online_cpus();

 	schedule_delayed_work(&shepherd,
 		round_jiffies_relative(sysctl_stat_interval));
@@ -1380,8 +1382,8 @@ static int vmstat_cpuup_callback(struct
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
-		if (!cpumask_test_and_set_cpu(cpu, cpu_stat_off))
-			cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
+		cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
+		cpumask_clear_cpu(cpu, cpu_stat_off);
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
