Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaFDT0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:26:19 -0400
Received: from skprod3.natinst.com ([130.164.80.24]:55845 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750777AbaFDT0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:26:17 -0400
From: "Brad Mouring" <bmouring@ni.com>
Date: Wed, 4 Jun 2014 14:25:41 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Brad Mouring <bmouring@ni.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 1/1] rtmutex: Handle when top lock owner changes
Message-ID: <20140604192541.GA9496@linuxgetsreal>
References: <1400855410-14773-1-git-send-email-brad.mouring@ni.com>
 <1400855410-14773-2-git-send-email-brad.mouring@ni.com>
 <20140603210609.62de6451@gandalf.local.home>
 <alpine.DEB.2.10.1406041623170.3319@nanos>
 <20140604114411.0fe51c1d@gandalf.local.home>
 <alpine.DEB.2.10.1406041951210.3319@nanos>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1406041951210.3319@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP5|July 31, 2013) at
 06/04/2014 02:25:42 PM,
	Serialize by Router on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP5|July 31, 2013) at
 06/04/2014 02:25:42 PM,
	Serialize complete at 06/04/2014 02:25:42 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-04_04:2014-06-04,2014-06-04,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 08:02:16PM +0200, Thomas Gleixner wrote:
> On Wed, 4 Jun 2014, Steven Rostedt wrote:
> 
> > On Wed, 4 Jun 2014 17:32:37 +0200 (CEST)
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > T3 releases L3
> > > T2 gets L3
> > > T2 drops L3 and L2
> > > T2 blocks on L4 held by T4
> > > T4 blocked on L5 held by T5
> > > 
> > > So we happily boost T4 and T5. Not what we really want to do.
> > > 
> > > Nasty, isn't it ?
> > > 
> > 
> > Actually, we may go up a chain, but we never do any unnecessary
> > boosting. That's because the boost is done with rt_mutex_adjust_prio()
> > which gets the prio from rt_mutex_getprio() which reads the
> > task->normal_prio and compares it to the task_top_pi_waiter(task)->prio,
> > which will always be correct as we have the necessary locks.
> 
> Indeed.

I had thought through how to try to determine, from what we knew at
this point, whether or not we were walking a different chain for just
this concern, but I had convinced myself that it would be cumbersome,
error-prone, and, as pointed out here, not vital.

>  
> > And we don't even need to worry about the chain we miss. That is, if
> > task A is blocked on a lock owned by D at the time, but as we go up the
> > chain, D releases the lock and B grabs it, B will still up its priority
> > based on the waiters of the lock (that is A), and if B blocks, it will
> > boost the tasks that own the lock it blocks on, where B is still
> > influenced by A.
> > 
> > The fact that we only update the prio based on the actual waiters and
> > don't carry a prio up the chain (which you designed, and I thought was
> > quite ingenious by the way), we may waste time going up a chain, but
> > the priority inheritance is still accurate.
> 
> Duh. I actually had to lookup my notes from back then. There is even a
> lenghty IRC discussion about not propagating the least waiters prio,
> but lookup the actual lock waiters. Good, so we just walk for nothing
> and waste some cpu cycles.
> 
I put the check within the deadlock detection block to try to minimize
this case. As evidenced by the spinning on this, it's a rare case where
your userspace code has to be doing some wacky (but valid) stuff.

> My brain still suffers from 3 days staring into futex.c
> 
> I'll fixup the check so it wont break the real deadlock case and queue
> it.

How would the change break the real deadlock case?

> 
> Thanks,
> 
> 	tglx
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
