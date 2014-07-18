Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681AbaGRAEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 20:04:25 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:50388 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbaGRAEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 20:04:24 -0400
Date: Thu, 17 Jul 2014 17:04:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: bobby.prani@gmail.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH RFC tip/core/rcu 1/2] rcu: Rationalize kthread spawning
Message-ID: <20140718000413.GF8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140714100604.GA9905@linux.vnet.ibm.com>
 <1405332404-10094-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53C73BA3.1070303@oracle.com>
 <20140717053334.GL8690@linux.vnet.ibm.com>
 <53C7F37D.1060100@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C7F37D.1060100@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071800-7164-0000-0000-000003367925
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 12:02:05PM -0400, Sasha Levin wrote:
> On 07/17/2014 01:33 AM, Paul E. McKenney wrote:
> > On Wed, Jul 16, 2014 at 10:57:39PM -0400, Sasha Levin wrote:
> >> On 07/14/2014 06:06 AM, Paul E. McKenney wrote:
> >>> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> >>>
> >>> Currently, RCU spawns kthreads from several different early_initcall()
> >>> functions.  Although this has served RCU well for quite some time,
> >>> as more kthreads are added a more deterministic approach is required.
> >>> This commit therefore causes all of RCU's early-boot kthreads to be
> >>> spawned from a single early_initcall() function.
> >>>
> >>> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >>
> >> Hey Paul,
> >>
> >> I've updated to today's -next and my VM started hanging on boot. Bisect
> >> pointed out this patch.
> >>
> >> I don't have any further info right now, but can provide whatever you'll
> >> find useful.
> > 
> > Could you please add initcall_debug to qemu's -append list?  If sysrq-T
> > works that early, its output would be helpful as well.
> > 
> > Your .config would also be helpful.
> 
> Hi Pranith, Paul,
> 
> I've attached my boot log with initcall_debug, as well as the .config.

Hello, Sasha,

Looks like you might have run into the same thing that Ingo ran into.
Could you please try the following patch?  (Or wait for it to show up
in the next -next, if you prefer.)

							Thanx, Paul

------------------------------------------------------------------------

rcu: Allow for NULL tick_nohz_full_mask when nohz_full= missing

If there isn't a nohz_full= kernel parameter specified, then
tick_nohz_full_mask can legitimately be NULL.  This can cause
problems when RCU's boot code tries to cpumask_or() this value into
rcu_nocb_mask.  In addition, if NO_HZ_FULL_ALL=y, there is no point
in doing the cpumask_or() in the first place because this will cause
RCU_NOCB_CPU_ALL=y, which in turn will have all bits already set in
rcu_nocb_mask.

This commit therefore avoids the cpumask_or() if NO_HZ_FULL_ALL=y
and checks for !tick_nohz_full_running otherwise, this latter check
catching cases when there was no nohz_full= kernel parameter specified.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index f62b7f2f6abd..00dc411e9676 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2479,9 +2479,10 @@ static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
 
 	if (rcu_nocb_mask == NULL)
 		return;
-#ifdef CONFIG_NO_HZ_FULL
-	cpumask_or(rcu_nocb_mask, rcu_nocb_mask, tick_nohz_full_mask);
-#endif /* #ifdef CONFIG_NO_HZ_FULL */
+#if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL)
+	if (tick_nohz_full_running)
+		cpumask_or(rcu_nocb_mask, rcu_nocb_mask, tick_nohz_full_mask);
+#endif /* #if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL) */
 	if (ls == -1) {
 		ls = int_sqrt(nr_cpu_ids);
 		rcu_nocb_leader_stride = ls;

