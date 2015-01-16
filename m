Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbbAPQ4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:56:32 -0500
Received: from smtprelay0134.hostedemail.com ([216.40.44.134]:49203 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752640AbbAPQ4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:56:30 -0500
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2015 11:56:30 EST
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3871:3873:3874:5007:6261:7875:7903:10004:10400:10848:10967:11026:11232:11658:11914:12296:12438:12517:12519:12740:13069:13311:13357:14096:14097:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: leg34_387a188da9b0f
X-Filterd-Recvd-Size: 2307
Date: Fri, 16 Jan 2015 11:56:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Rik van Riel <riel@redhat.com>, Steven Rostedt <srostedt@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch -rt 1/2] KVM: use simple waitqueue for vcpu->wq
Message-ID: <20150116115627.425daf95@gandalf.local.home>
In-Reply-To: <20150116114846.4e7b718d@gandalf.local.home>
References: <20150114171251.882318257@redhat.com>
	<20150114171459.593877145@redhat.com>
	<20150116114846.4e7b718d@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015 11:48:46 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> >  static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
> >  {
> > -	DEFINE_WAIT(wait);
> > +	DEFINE_SWAITER(wait);
> >  
> > -	prepare_to_wait(&vc->wq, &wait, TASK_INTERRUPTIBLE);
> > +	swait_prepare(&vc->wq, &wait, TASK_INTERRUPTIBLE);
> >  	vc->vcore_state = VCORE_SLEEPING;
> >  	spin_unlock(&vc->lock);
> >  	schedule();
> > -	finish_wait(&vc->wq, &wait);
> > +	swait_finish(&vc->wq, &wait);
> >  	spin_lock(&vc->lock);
> >  	vc->vcore_state = VCORE_INACTIVE;
> >  }
> > @@ -1613,7 +1613,7 @@
> >  			kvmppc_create_dtl_entry(vcpu, vc);
> >  			kvmppc_start_thread(vcpu);
> >  		} else if (vc->vcore_state == VCORE_SLEEPING) {
> > -			wake_up(&vc->wq);
> > +			swait_wake(&vc->wq);
> 
> I notice everywhere you have a swait_wake_interruptible() but here. Is
> there a reason why?
> 

Of course I could have misread this patch, and this specific work queue
will only be woken up by swait_wake() and not
swait_wake_interruptible(). If that's the case, then its fine as is
(except for that typo I pointed out before).

-- Steve
