Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab3HTSmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:42:11 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:60508 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3HTSmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:42:09 -0400
Date: Tue, 20 Aug 2013 11:42:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Borislav Petkov <bp@alien8.de>,
        Borislav Petkov <bp@suse.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH tip/core/rcu 1/9] rcu: Expedite grace periods during
 suspend/resume
Message-ID: <20130820184203.GL29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130820024148.GA30283@linux.vnet.ibm.com>
 <1376966534-30775-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <52133DD0.8030804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52133DD0.8030804@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082018-5518-0000-0000-000011593859
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 05:58:40PM +0800, Lai Jiangshan wrote:
> On 08/20/2013 10:42 AM, Paul E. McKenney wrote:
> > From: Borislav Petkov <bp@alien8.de>
> > 
> > CONFIG_RCU_FAST_NO_HZ can increase grace-period durations by up to
> > a factor of four, which can result in long suspend and resume times.
> > Thus, this commit temporarily switches to expedited grace periods when
> > suspending the box and return to normal settings when resuming.  Similar
> > logic is applied to hibernation.
> > 
> > Because expedited grace periods are of dubious benefit on very large
> > systems, so this commit restricts their automated use during suspend
> > and resume to systems of 256 or fewer CPUs.  (Some day a number of
> > Linux-kernel facilities, including RCU's expedited grace periods,
> > will be more scalable, but I need to see bug reports first.)
> > 
> > [ paulmck: This also papers over an audio/irq bug, but hopefully that will
> >   be fixed soon. ]
> > 
> > Signed-off-by: Borislav Petkov <bp@suse.de>
> > Signed-off-by: Bjørn Mork <bjorn@mork.no>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > ---
> >  kernel/rcutree.c | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 338f1d1..a7bf517 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -54,6 +54,7 @@
> >  #include <linux/stop_machine.h>
> >  #include <linux/random.h>
> >  #include <linux/ftrace_event.h>
> > +#include <linux/suspend.h>
> >  
> >  #include "rcutree.h"
> >  #include <trace/events/rcu.h>
> > @@ -3032,6 +3033,25 @@ static int rcu_cpu_notify(struct notifier_block *self,
> >  	return NOTIFY_OK;
> >  }
> >  
> > +static int rcu_pm_notify(struct notifier_block *self,
> > +			 unsigned long action, void *hcpu)
> > +{
> > +	switch (action) {
> > +	case PM_HIBERNATION_PREPARE:
> > +	case PM_SUSPEND_PREPARE:
> > +		if (nr_cpu_ids <= 256) /* Expediting bad for large systems. */
> > +			rcu_expedited = 1;
> > +		break;
> > +	case PM_POST_HIBERNATION:
> > +	case PM_POST_SUSPEND:
> > +		rcu_expedited = 0;
> 
> Users can set it via sysfs, this notify will changes it.
> I think we can introduce an rcu_expedited_syfs_saved;
> thus we can change this line to:
> -		rcu_expedited = 0;
> +		rcu_expedited = rcu_expedited_syfs_saved;

We could do this, but there are still races where user tasks update sysfs
while the operation is in progress.  There are other races as well,
particularly if multiple user tasks are concurrently attempting to do
this sysfs update.  The final solution likely involves a bunch of stuff,
possibly including a driver to gain release-on-exit semantics.

Until someone actually tries using this, we won't really know what we
actually need.  And it is always possible that no one will actually
use it.  So we need to hold off until we see some real-world use cases.

							Thanx, Paul

> rcu_init() {
> 	...
> +	rcu_expedited_syfs_saved = rcu_expedited;
> }
> 
> static ssize_t rcu_expedited_store(struct kobject *kobj,
> 				   struct kobj_attribute *attr,
> 				   const char *buf, size_t count)
> {
> 	if (kstrtoint(buf, 0, &rcu_expedited))
> 		return -EINVAL;
> 
> +	rcu_expedited_syfs_saved = rcu_expedited;
> 	return count;
> }
> 
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +	return NOTIFY_OK;
> > +}
> > +
> >  /*
> >   * Spawn the kthread that handles this RCU flavor's grace periods.
> >   */
> > @@ -3273,6 +3293,7 @@ void __init rcu_init(void)
> >  	 * or the scheduler are operational.
> >  	 */
> >  	cpu_notifier(rcu_cpu_notify, 0);
> > +	pm_notifier(rcu_pm_notify, 0);
> >  	for_each_online_cpu(cpu)
> >  		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
> >  }
> 
> 

