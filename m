Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab3GAPmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:42:24 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:32883 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab3GAPmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:42:23 -0400
Date: Mon, 1 Jul 2013 08:41:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, athorlton@sgi.com,
        CAI Qian <caiqian@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: BUG: tick device NULL pointer during system initialization and
 shutdown
Message-ID: <20130701154109.GK3773@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <51C0AB09.2090605@redhat.com>
 <alpine.DEB.2.02.1306241551020.4013@ionos.tec.linutronix.de>
 <51CA2CBF.70404@redhat.com>
 <alpine.DEB.2.02.1306261303260.4013@ionos.tec.linutronix.de>
 <51CC708B.7040605@redhat.com>
 <alpine.DEB.2.02.1306281250270.4013@ionos.tec.linutronix.de>
 <51D17F2B.7000300@redhat.com>
 <alpine.DEB.2.02.1307011518350.4013@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307011518350.4013@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070115-7182-0000-0000-00000797CF93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 03:30:47PM +0200, Thomas Gleixner wrote:
> On Mon, 1 Jul 2013, Prarit Bhargava wrote:
> > On 06/28/2013 06:52 AM, Thomas Gleixner wrote:
> > > Huch. Did the warning in the broadcast code trigger before that?
> > 
> > tglx,
> > 
> > AFAICT it does not.  Log below on the system I'm testing on.  The test on the
> > system is system boots, sleeps for 30 seconds and then reboots.
> 
> > [  270.563197] INFO: rcu_sched detected stalls on CPUs/tasks: { 51} (detected by
> > 63, t=217205 jiffies, g=3583, c=3582, q=578)
> 
> So the stall is on CPU51, but we do not get a backtrace for CPU51. 
> 
> The backtrace trigger is only sent to online cpus. So CPU51 is offline
> already. Which makes sense as we are in the process of bringing CPUs
> down and the CPUs with backtrace are 0 and 53-63.
> 
> I'm pretty sure, that the patch which clears the stale flag is
> unrelated to this and it cures the NULL pointer dereference (the
> reason why this can happen is clear).
> 
> So now you do not longer trip over the NULL pointer dereference, but
> you see a weird RCU stall on an already DEAD cpu. Note, it's dead
> because we already took CPU52 offline as well.
> 
> Paul???

Odd.  The force-quiescent-state machinery should notice that the
dead CPU gets a false return from cpu_is_offline(), at which point it
should not a quiescent state on behalf of that CPU and get on with the
grace period.

In the meantime, here are my guesses as to what might be causing this bug:

o	RCU's grace-period kthreads got stuck somehow.  One way that
	this could happen is if you don't have commit #971394f3 (Fix
	deadlock with CPU hotplug, RCU GP init, and timer migration)
	but do have CONFIG_PROVE_RCU_DELAY=y.

o	The handling of CPU-hotplug bitmaps has changed so that RCU
	needs to do something other than cpu_offline().  I have been
	expecting that RCU would be needing to keep its own mask of
	online CPUs at some point, but didn't think that time had
	arrived.

If neither of those help, then it is time for me to add more information
to CONFIG_RCU_CPU_STALL_INFO.  ;-)

							Thanx, Paul

> Thanks,
> 
> 	tglx
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

