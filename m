Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab3GCQoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:44:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab3GCQoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:44:09 -0400
Date: Wed, 3 Jul 2013 12:44:01 -0400
From: Don Zickus <dzickus@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm-devel <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Karen Noel <knoel@redhat.com>, Rik van Riel <riel@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: watchdog: print stolen time increment at softlockup detection
Message-ID: <20130703164401.GS126784@redhat.com>
References: <20130628025723.GA12719@amt.cnet>
 <20130628141215.GF126784@redhat.com>
 <20130628203739.GA25847@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628203739.GA25847@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 05:37:39PM -0300, Marcelo Tosatti wrote:
> On Fri, Jun 28, 2013 at 10:12:15AM -0400, Don Zickus wrote:
> > On Thu, Jun 27, 2013 at 11:57:23PM -0300, Marcelo Tosatti wrote:
> > > 
> > > One possibility for a softlockup report in a Linux VM, is that the host
> > > system is overcommitted to the point where the watchdog task is unable
> > > to make progress (unable to touch the watchdog).
> > 
> > I think I am confused on the VM/host stuff.  How does an overcommitted
> > host prevent a high priority task like the watchdog from running?
> > 
> > Or is it the watchdog task on the VM that is being blocked from running
> > because the host is overcommitted and can't run the VM frequent enough?
> 
> Yes, thats the case.
> 
> > The latter would make sense, though I thought you solved that with the
> > other kvm splat in the watchdog code a while ago.  So I would be
> > interested in understanding why the previous solution isn't working.
> 
> That functionality is for a notification so the guest ignores the time
> jump induced by a vm pause. This problem is similar to the kgdb case.
> 
> > Second, I am still curious how this problem differs from say kgdb or
> > suspend-hibernate/resume.  Doesn't both of those scenarios deal with a
> > clock that suddenly jumps forward without the watchdog task running?
> 
> The difference is this:
> 
> The present functionality in watchdog.c allows the hypervisor to notify
> the guest that it should ignore the large delta seen via clock reads
> (at the watchdog timer interrupt).
> This notification is used for the case where the vm has been paused for
> a period of time.

But why do this at the watchdog timer interrupt?  I thought this would be
done at the lower layer like in sched_clock() or something.

> 
> Are you suggesting the host should silence the guest watchdog, also in
> the overcommitment case? Issues i see with that:
> 
> 1) The host is not aware of the variable softlockup threshold in
> the guest.
> 
> 2) Whatever the threshold of overcommitment for sending the ignore
> softlockup notification to the guest, genuine softlockup detections in
> the guest could be silenced, given proper conditioning.

No.  That would be difficult as you described.  What I am trying to get at
is, doesn't the guest /know/ time jumped when it schedules again?  And
can't it determine based on this jump that something unreasonable
happened like a long pause or and overcommit?

> 
> And why overcommitment is not a valid reason to generate a softlockup in
> the first place ?

For the guest I don't believe it is.  It isn't the guest's fault it
couldn't run processes.  A warning should be scheduled on the host that it
couldn't run a process in a very long time.

> 
> > For some reason I had the impression that when a VM starts running again,
> > one of the first things it does it sync up its clock again (which leads to
> > a softlockup shortly thereafter in the case of paused/overcommitted VMs)?
> 
> Sort of, the kvmclock counts while the VM is running (whether is
> overcommitted or not).

Does comparing the kvmclock with the current clock indicate that a long
pause or an overcommit occurred?

> 
> > At that time I would have thought that the code could detect a large jump
> > in time and touch_softlockup_watchdog_sync() or something to delay the
> > check until the next cycle.
> 
> But this would silence any softlockups that are due to delays
> in the host causing the watchdog task to make progress (eg:
> https://lkml.org/lkml/2013/6/20/633, in that case if 1 operation took
> longer than expected your suggestion would silence the report).

Ok.  I don't fully understand that problem, the changelog was a little
vague.

> 
> > That would make the watchdog code alot less messier than having custom
> > kvm/paravirt splat all over it.  Generic solutions are always nice. :-)
> 
> Can you give more detail on what the suggestion is and how can you deal
> with points 1 and 2 above?

I don't have a good suggestion, just a lot of questions really.  The thing
is there are lots of watchdogs in the system (ie clock watchdog,
filesystem watchdog, rcu stalls, etc).  Solving this problem just for the lockup
watchdog doesn't seem right because if the lockup timeout was longer, you
would probably hit the other watchdogs too.

So my suggestion (based on my ignorance of how the clock code works) is
that some sort of generic mechanism be applied to all the watchdogs.  Much
like how kgdb touches all of them at once when it handles an exception.

For example, unpausing a guest could be a good time to touch all the
watchdogs as you have no idea how long the pause was.  I can't think of
any hook for an overcommit though.

Cheers,
Don
