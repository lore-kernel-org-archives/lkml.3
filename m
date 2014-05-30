Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbaE3OGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:06:20 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:57878
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932873AbaE3OGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:06:19 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2014 10:06:19 EDT
Date: Fri, 30 May 2014 09:00:11 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmstat: on demand updates from differentials V7
In-Reply-To: <20140529235530.GA25555@localhost.localdomain>
Message-ID: <alpine.DEB.2.10.1405300859290.8240@gentwo.org>
References: <alpine.DEB.2.10.1405291453260.2899@gentwo.org> <20140529235530.GA25555@localhost.localdomain>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014, Frederic Weisbecker wrote:

> On Thu, May 29, 2014 at 02:56:15PM -0500, Christoph Lameter wrote:
> > -static void start_cpu_timer(int cpu)
> > +static void __init start_shepherd_timer(void)
> >  {
> > -	struct delayed_work *work = &per_cpu(vmstat_work, cpu);
> > +	int cpu;
> > +
> > +	for_each_possible_cpu(cpu)
> > +		INIT_DEFERRABLE_WORK(per_cpu_ptr(&vmstat_work, cpu),
> > +			vmstat_update);
> > +
> > +	cpu_stat_off = kmalloc(cpumask_size(), GFP_KERNEL);
>
> Now you're open coding alloc_cpumask_var() ?

Subject: on demand vmstat: Do not open code alloc_cpumask_var

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/vmstat.c
===================================================================
--- linux.orig/mm/vmstat.c	2014-05-29 14:43:26.439163942 -0500
+++ linux/mm/vmstat.c	2014-05-30 08:58:42.909697898 -0500
@@ -1238,7 +1238,7 @@
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
 int sysctl_stat_interval __read_mostly = HZ;
-struct cpumask *cpu_stat_off;
+cpumask_var_t cpu_stat_off;

 static void vmstat_update(struct work_struct *w)
 {
@@ -1332,7 +1332,8 @@
 		INIT_DEFERRABLE_WORK(per_cpu_ptr(&vmstat_work, cpu),
 			vmstat_update);

-	cpu_stat_off = kmalloc(cpumask_size(), GFP_KERNEL);
+	if (!alloc_cpumask_var(&cpu_stat_off, GFP_KERNEL))
+		BUG();
 	cpumask_copy(cpu_stat_off, cpu_online_mask);

 	schedule_delayed_work(&shepherd,
