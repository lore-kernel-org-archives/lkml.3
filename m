Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbaJ2JfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:35:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:41183 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbaJ2JfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:35:11 -0400
Date: Wed, 29 Oct 2014 10:35:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, mingo@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, rafael.j.wysocki@intel.com
Subject: Re: [PATCH 00/11] nested sleeps, fixes and debug infrastructure
Message-ID: <20141029093503.GX3337@twins.programming.kicks-ass.net>
References: <20140924081845.572814794@infradead.org>
 <1411633803.15810.12.camel@marge.simpson.net>
 <20140925090619.GA5430@worktop>
 <20140925091556.GB5430@worktop>
 <20141002102251.GA6324@worktop.programming.kicks-ass.net>
 <20141002121553.GB6324@worktop.programming.kicks-ass.net>
 <20141027134103.GA10476@twins.programming.kicks-ass.net>
 <20141028000703.GA22964@redhat.com>
 <20141028082335.GM3337@twins.programming.kicks-ass.net>
 <20141029000055.GA12107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029000055.GA12107@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 01:00:56AM +0100, Oleg Nesterov wrote:
> On 10/28, Peter Zijlstra wrote:
> >
> > On Tue, Oct 28, 2014 at 01:07:03AM +0100, Oleg Nesterov wrote:
> >
> > > I was going to say that wait_event_freezable() in kauditd_thread()
> > > is not friendly wrt kthread_should_stop() and thus we we need
> > > kthread_freezable_should_stop().
> >
> > I'm not sure those two would interact, yes, both would first set either
> > the freezable or stop bit and then wake. If both were to race, all we
> > need to ensure is to check both before calling schedule again.
> >
> > A loop like:
> >
> > 	while (!kthread_should_stop()) {
> > 		wait_event_freezable(wq, cond);
> > 	}
> >
> > Would satisfy that, because even if kthread_should_stop() gets set first
> > and then freezing happens and we get into try_to_freeze() first, we'd
> > still to the kthread_should_stop() check right after we thaw.
> 
> Right after, yes.
> 
> But what if it calls try_to_freeze() and another thread (which should
> be frozen too) sleeps in kthread_stop() ?

Fair point indeed. Now I had a look at __refrigerator() and is there any
reason we should not remove that .check_kthr_stop argument and replace
it with an unconditional (current->flags & PF_KTHREAD) ?
