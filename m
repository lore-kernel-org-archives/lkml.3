Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaJ1XEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 19:04:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaJ1XEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 19:04:45 -0400
Date: Wed, 29 Oct 2014 01:00:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, mingo@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, rafael.j.wysocki@intel.com
Subject: Re: [PATCH 00/11] nested sleeps, fixes and debug infrastructure
Message-ID: <20141029000055.GA12107@redhat.com>
References: <20140924081845.572814794@infradead.org> <1411633803.15810.12.camel@marge.simpson.net> <20140925090619.GA5430@worktop> <20140925091556.GB5430@worktop> <20141002102251.GA6324@worktop.programming.kicks-ass.net> <20141002121553.GB6324@worktop.programming.kicks-ass.net> <20141027134103.GA10476@twins.programming.kicks-ass.net> <20141028000703.GA22964@redhat.com> <20141028082335.GM3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028082335.GM3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28, Peter Zijlstra wrote:
>
> On Tue, Oct 28, 2014 at 01:07:03AM +0100, Oleg Nesterov wrote:
>
> > I was going to say that wait_event_freezable() in kauditd_thread()
> > is not friendly wrt kthread_should_stop() and thus we we need
> > kthread_freezable_should_stop().
>
> I'm not sure those two would interact, yes, both would first set either
> the freezable or stop bit and then wake. If both were to race, all we
> need to ensure is to check both before calling schedule again.
>
> A loop like:
>
> 	while (!kthread_should_stop()) {
> 		wait_event_freezable(wq, cond);
> 	}
>
> Would satisfy that, because even if kthread_should_stop() gets set first
> and then freezing happens and we get into try_to_freeze() first, we'd
> still to the kthread_should_stop() check right after we thaw.

Right after, yes.

But what if it calls try_to_freeze() and another thread (which should
be frozen too) sleeps in kthread_stop() ?

> > Perhaps it also makes sense to redefine wait_event_freezable.*()
> > via ___wait_event(cmd => freezable_schedule), but I think this needs
> > another patch.
>
> So I talked to Rafael yesterday and I'm going to replace all the
> wait_event*() stuff, and I suppose also freezable_schedule() because
> they're racy.
>
> The moment we call freezer_do_not_count() the freezer will ignore us,
> this means the thread could still be running (albeit not for long) when
> the freezer reports success.

Yes, sure. IIRC the theory was that a PF_FREEZER_SKIP will do nothing
"wrong" wrt freezing/suspend before it actually sleeps, but I guess
today we can't assume this.

> Ideally I'll be able to kill the entire freezer_do_not_count() stuff.

Agreed... but it is not clear to me what exactly we can/should do.


Anyway, I only meant that I believe your patch is correct (just it should
not define wait_freezable which we already have), and you could also remove
that kthread_should_stop() which only adds the confusion.

Oleg.

