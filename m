Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaHDVCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 17:02:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33444 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaHDVCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:02:30 -0400
Date: Mon, 4 Aug 2014 23:02:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>
Subject: Re: [RFC][PATCH 4/7] inotify: Deal with nested sleeps
Message-ID: <20140804210222.GU3935@laptop>
References: <20140804103025.478913141@infradead.org>
 <20140804103537.564978189@infradead.org>
 <20140804192358.GA23283@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804192358.GA23283@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 09:23:58PM +0200, Oleg Nesterov wrote:
> On 08/04, Peter Zijlstra wrote:
> >
> >  	while (1) {
> > -		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
> > -
> >  		mutex_lock(&group->notification_mutex);
> 
> So yes, even these 2 lines look obviously buggy. Even if
> fsnotify_add_notify_event()->wake_up(&group->notification_waitq) uses
> TASK_NORMAL, so at least this can't miss an event.

There's another problem, mutex_lock() actively assumes ->state ==
TASK_RUNNING and if its not can go to sleep, possibly without ever being
woken again (because nobody knows its sleeping).

We should probably fix that too, but then its not too weird an
assumption for a blocking primitive.

> It is too later for me, but I am wondering if we can do another thing.
> Something like
> 
> 		int state;
> 
> 		prepare_to_wait(wait, TASK_INTERRUPTIBLE);
> 
> 		PUSH(&wait, state);
> 		mutex_lock();
> 		mutex_unlock();
> 		POP(&wait, state);
> 
> and, ignoring all races, lack of barriers, etc
> 
> 	#define PUSH(w, s)	s = current->state; current->state = RUNNING;
> 
> 	#define POP(w, s)	current->state = WOKEN(w) ? RUNNING : s;
> 
> Probably not... just curious.

Sure we can do a state stack, but I'm not immediately seeing the benefit
of doing so. Also I don't think we want to encourage people to do things
like this.

-rt does something like that for its spinlock->rt_mutex conversion.

In fact, you only need to push/pop around mutex_lock(), unlock will
never change state.
