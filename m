Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbbATSQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:16:20 -0500
Received: from smtprelay0085.hostedemail.com ([216.40.44.85]:33433 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751933AbbATSQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:16:17 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4362:5007:6261:7875:10004:10400:10450:10455:10848:10967:11026:11232:11658:11914:12296:12438:12517:12519:12663:12740:13069:13311:13357:14096:14097:19904:19999:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: earth47_70b1f11e2b102
X-Filterd-Recvd-Size: 3261
Date: Tue, 20 Jan 2015 13:16:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Rik van Riel <riel@redhat.com>, Steven Rostedt <srostedt@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch -rt 1/2] KVM: use simple waitqueue for vcpu->wq
Message-ID: <20150120131613.009903a0@gandalf.local.home>
In-Reply-To: <20150120054653.GA6473@iris.ozlabs.ibm.com>
References: <20150114171251.882318257@redhat.com>
	<20150114171459.593877145@redhat.com>
	<20150116114846.4e7b718d@gandalf.local.home>
	<20150119144100.GA10794@amt.cnet>
	<20150120054653.GA6473@iris.ozlabs.ibm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015 16:46:53 +1100
Paul Mackerras <paulus@samba.org> wrote:

> On Mon, Jan 19, 2015 at 12:41:00PM -0200, Marcelo Tosatti wrote:
> > On Fri, Jan 16, 2015 at 11:48:46AM -0500, Steven Rostedt wrote:
> > > >  static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
> > > >  {
> > > > -	DEFINE_WAIT(wait);
> > > > +	DEFINE_SWAITER(wait);
> > > >  
> > > > -	prepare_to_wait(&vc->wq, &wait, TASK_INTERRUPTIBLE);
> > > > +	swait_prepare(&vc->wq, &wait, TASK_INTERRUPTIBLE);
> > > >  	vc->vcore_state = VCORE_SLEEPING;
> > > >  	spin_unlock(&vc->lock);
> > > >  	schedule();
> > > > -	finish_wait(&vc->wq, &wait);
> > > > +	swait_finish(&vc->wq, &wait);
> > > >  	spin_lock(&vc->lock);
> > > >  	vc->vcore_state = VCORE_INACTIVE;
> > > >  }
> > > > @@ -1613,7 +1613,7 @@
> > > >  			kvmppc_create_dtl_entry(vcpu, vc);
> > > >  			kvmppc_start_thread(vcpu);
> > > >  		} else if (vc->vcore_state == VCORE_SLEEPING) {
> > > > -			wake_up(&vc->wq);
> > > > +			swait_wake(&vc->wq);
> > > 
> > > I notice everywhere you have a swait_wake_interruptible() but here. Is
> > > there a reason why?
> > > 
> > > IIRC, Peter wants to make swait wakeup usage homogenous. That is, you
> > > either sleep in an interruptible state, or you don't. You can't mix and
> > > match it.
> > 
> > IIUC there is only one waiter on this waitqueue at any given time.
> > 
> > Paul is that correct?
> 
> Yes, that's right.  It's only the task that has taken the
> responsibility for running the virtual core that would be waiting on
> that wait queue.

Thanks Paul, but it still makes me nervious.

I'm actually wondering if we should just nuke the _interruptible()
version of swait. As it should only be all interruptible or all not
interruptible, that the swait_wake() should just do the wake up
regardless. In which case, swait_wake() is good enough. No need to have
different versions where people may think do something special.

Peter?

-- Steve
