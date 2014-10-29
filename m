Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309AbaJ2O1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:27:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41739 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476AbaJ2O1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:27:05 -0400
Date: Wed, 29 Oct 2014 15:26:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, mingo@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, rafael.j.wysocki@intel.com
Subject: Re: [PATCH 00/11] nested sleeps, fixes and debug infrastructure
Message-ID: <20141029142654.GD3337@twins.programming.kicks-ass.net>
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

> > So I talked to Rafael yesterday and I'm going to replace all the
> > wait_event*() stuff, and I suppose also freezable_schedule() because
> > they're racy.
> >
> > The moment we call freezer_do_not_count() the freezer will ignore us,
> > this means the thread could still be running (albeit not for long) when
> > the freezer reports success.
> 
> Yes, sure. IIRC the theory was that a PF_FREEZER_SKIP will do nothing
> "wrong" wrt freezing/suspend before it actually sleeps, but I guess
> today we can't assume this.

Esp. the wait_event_freezable*() family seems suspicious in that the
cond stmt can actually result in quite a lot of code.

But see below, I don't think we have a guarantee it will _ever_ sleep.

Also, this calls schedule(); try_to_freeze() in a suitable loop that's
safe against spurious wakeups, OTOH..

> > Ideally I'll be able to kill the entire freezer_do_not_count() stuff.
> 
> Agreed... but it is not clear to me what exactly we can/should do.

.. I looked at freezable_schedule() and I'm not sure how to 'fix' that.
The problem being things like signal.c:ptrace_stop() that will actually
misbehave in the face of spurious wakeups as allowed by try_to_freeze().

Then again, freezable_schedule() isn't nearly as bad as the
wait_event_freezable() stuff because it does indeed guarantee the task
only calls schedule().

Then again, it is possible to miss these tasks and report freeze success
with a running task all the same, suppose its already woken but
preempted before freezer_count(). The for_each_process_thread() loop in
try_to_freeze_tasks() will skip over it.

And all I can come up with is horrible.. maybe for another day.
