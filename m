Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbaJ2VBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:01:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671AbaJ2VBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:01:06 -0400
Date: Wed, 29 Oct 2014 21:09:16 +0000
From: Alexander Gordeev <agordeev@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: Remove redundant rcu_is_cpu_rrupt_from_idle()
 function
Message-ID: <20141029210916.GB13273@agordeev.usersys.redhat.com>
References: <1414580827-19545-1-git-send-email-agordeev@redhat.com>
 <20141029124728.GL5718@linux.vnet.ibm.com>
 <20141029134519.GC30198@agordeev.usersys.redhat.com>
 <20141029143439.GN5718@linux.vnet.ibm.com>
 <20141029151622.GD30198@agordeev.usersys.redhat.com>
 <20141029154615.GR5718@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029154615.GR5718@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 08:46:15AM -0700, Paul E. McKenney wrote:
> On Wed, Oct 29, 2014 at 03:16:23PM +0000, Alexander Gordeev wrote:
> > On Wed, Oct 29, 2014 at 07:34:39AM -0700, Paul E. McKenney wrote:
> > > On Wed, Oct 29, 2014 at 01:45:19PM +0000, Alexander Gordeev wrote:
> > > > On Wed, Oct 29, 2014 at 05:47:29AM -0700, Paul E. McKenney wrote:
> > > > > On Wed, Oct 29, 2014 at 12:07:07PM +0100, Alexander Gordeev wrote:
> > > > > > Function rcu_is_cpu_rrupt_from_idle() is called from scheduling-
> > > > > > clock interrupt handler to check if the current CPU was interrupted
> > > > > > from idle. If true, it results in invocation of RCU callbacks. But
> > > > > > the common hardware interrupt exit path also contains similar check
> > > > > > and therefore the call to rcu_is_cpu_rrupt_from_idle() is redundant.
> > > > > 
> > > > > By common hardware interrupt exit path, you are meaning the calls
> > > > > to rcu_irq_exit()?  If not, please let me know exactly what you
> > > > > mean here.
> > > > 
> > > > Yes, I mean rcu_irq_exit().
> > > 
> > > Unless you can get the indication of whether or not the original interrupt
> > > came from userspace execution into rcu_irq_exit(), this will not work.
> > > It will result in grace-period hangs on some configurations.
> > 
> > Okay, that was my concern wrt tree RCU. By contrast, tiny RCU does not seem
> > able to hang a grace-period, isn't it?
> 
> Although it is true that tiny RCU cannot hang a synchronize_rcu()
> grace period, it most certainly can hang a call_rcu() grace period
> in exactly the same way.

Sorry for being a pain in the neck - just want to make sure I am following.

I only see possibility to cause callbacks not being called for "too long"
in case a system has lots of nested interrupts and rcu_idle_enter_common()
is not being called from hardware interrupt context as result. How could
rcu_is_cpu_rrupt_from_idle() help here?

> > > Now, if you -can- get the userspace-execution indication into
> > > rcu_irq_exit(), this might be of interest.  However, it might be faster
> > > to simply let the scheduling-clock interrupt do the job as it currently
> > > does, especially for workloads with lots of interrupts.
> > > 
> > > Or did you have something else in mind?
> > 
> > Nope. I would even leave as is tiny RCU's rcu_is_cpu_rrupt_from_idle()
> > for clarity then ;)
> 
> Also to avoid userspace execution from preventing RCU callbacks from
> ever being invoked.  ;-)

Hmm.. Am I missing something else? I did not remove the userspace check
from the scheduling-clock interrupt:

@@ -250,7 +240,7 @@ void rcu_bh_qs(void)
 void rcu_check_callbacks(int cpu, int user)
 {
 	RCU_TRACE(check_cpu_stalls());
-	if (user || rcu_is_cpu_rrupt_from_idle())
+	if (user)
 		rcu_sched_qs();
 	else if (!in_softirq())
 		rcu_bh_qs();

Thanks!

> 							Thanx, Paul

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
