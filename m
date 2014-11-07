Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaKGV1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 16:27:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:39400 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbaKGV1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 16:27:47 -0500
Date: Fri, 7 Nov 2014 22:27:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        daniel@numascale.com, yuyang.du@intel.com,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH]: kthread: Fix memory ordering in __kthread_parkme
Message-ID: <20141107212739.GV10501@worktop.programming.kicks-ass.net>
References: <20141106150150.GT10501@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.11.1411071037440.3789@nanos>
 <20141107102855.GA29390@twins.programming.kicks-ass.net>
 <20141107184103.GA16043@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107184103.GA16043@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 07:41:03PM +0100, Oleg Nesterov wrote:
> On 11/07, Peter Zijlstra wrote:
> >
> >  static void __kthread_parkme(struct kthread *self)
> >  {
> > -	__set_current_state(TASK_PARKED);
> > +	set_current_state(TASK_PARKED);
> >  	while (test_bit(KTHREAD_SHOULD_PARK, &self->flags)) {
> >  		if (!test_and_set_bit(KTHREAD_IS_PARKED, &self->flags))
> >  			complete(&self->parked);
> >  		schedule();
> > -		__set_current_state(TASK_PARKED);
> > +		set_current_state(TASK_PARKED);
> >  	}
> 
> Perhaps it makses sense to do set_current_state(PARKED) once at the start
> of "for (;;)" loop, but this is cosmetic.

Yeah, we should probably clean that up, it looks a bit odd. But I didn't
want to do too many changes.

> What if kthread_unpark() is called right after test_bit(KTHREAD_SHOULD_PARK)
> and KTHREAD_IS_PARKED is not set? It seems that __kthread_unpark() should
> call wake_up_state() unconditionally ?

set_current_state(TASK_PARKED)
while (test_bit(KTHREAD_SHOULD_PARK, ..)) {
						clear_bit(KTHREAD_SHOULD_PARK, ..);
						if (test_and_clear_bit(KTHREAD_IS_PARKED, ..) {
							...
							wake_up_state(, TASK_PARKED);
						}
	if (!test_and_set_bit(KTHREAD_IS_PARKED, ..))
		complete(..);
	schedule();


Then yes we'll miss the wakeup, but we also miss the __kthread_bind().

Now I don't think this'll actually happen because kthread_park() waits
for the completion under the hotplug and smpboot_threads_lock lock, and
we do the unpark under the hotplug lock as well, so its fully serialized

But yes, we should probably clean this up as well.
