Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaDAAsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 20:48:07 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:34741 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaDAAsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 20:48:04 -0400
Date: Mon, 31 Mar 2014 17:48:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu_prempt stalls / lockup
Message-ID: <20140401004801.GQ4284@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140331230241.GA30019@redhat.com>
 <20140331232220.GP4284@linux.vnet.ibm.com>
 <20140331233552.GB30019@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140331233552.GB30019@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040100-0928-0000-0000-000000CFDD67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 07:35:52PM -0400, Dave Jones wrote:
> On Mon, Mar 31, 2014 at 04:22:21PM -0700, Paul E. McKenney wrote:
>  > On Mon, Mar 31, 2014 at 07:02:41PM -0400, Dave Jones wrote:
>  > > You can tell the merge window is open, because I'm back to breaking RCU.
>  > > 
>  > > ... 
>  > > [ 3558.120739] INFO: Stall ended before state dump start
>  > > 
>  > > at that point, userspace stopped responding. cursor on console was blinking,
>  > > but I couldn't even switch tty's, or sysrq dump.

Hmmm...  I am having a very hard time imagining any of this merge
window's RCU changes preventing a sysrq dump.  On the other hand,
having a single grace period persist without anything blocking it
is pretty strange as well.

I would hope that the sysrq path does not allocate memory, but who knows?
After all, one possible reason for the eventual hang is memory exhaustion.
So one thing to try is to do sysrq earlier in the process.  (Yeah,
I know, tough to do if you have lots of scripted systems.)

>  > > rc8 was fine, so this is todays rcu changes.
>  > 
>  > New one on me!  Any chance of a .config file?
> 
> http://paste.fedoraproject.org/90449/30888213/raw/

Given that you have CONFIG_RCU_NOCB_CPU_ALL=y, all the grace-period
activity is being driven by the grace-period kthreads ("rcu_preempt"
in this case).  This leads me to wonder if your workload if preventing
RCU's grace-period kthreads from running.  These kthreads are SCHED_OTHER,
so could potentially be preempted for a long time.  But I would expect
a softlockup message in that case.

Alternatively, I suppose a wakeup could be getting lost.  The main change
related to that this merge window was ffa83fb565fb, which eliminated
idle wakeups from RCU in the CONFIG_RCU_NOCB_CPU_ALL=y case.

So, could you please try reverting ffa83fb565fb?

If that doesn't work, I will need to put together some diagnostic patches.
Starting with the one below.

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 0c47e300210a..c5a163378710 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -936,7 +936,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start),
 	       rsp->gpnum, rsp->completed, totqlen);
 	if (ndetected == 0)
-		pr_err("INFO: Stall ended before state dump start\n");
+		pr_err("INFO: Stall ended before state dump start, gp_kthread state: %#lx\n", rsp->gp_kthread->state);
 	else if (!trigger_all_cpu_backtrace())
 		rcu_dump_cpu_stacks(rsp);
 

