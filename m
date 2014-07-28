Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaG1Qj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:39:56 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:30129 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaG1Qjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:39:52 -0400
Message-ID: <1406565588.2411.8.camel@j-VirtualBox>
Subject: Re: [PATCH -tip/master 4/7] locking/mutex: Refactor optimistic
 spinning code
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Jul 2014 09:39:48 -0700
In-Reply-To: <20140728090821.GO6758@twins.programming.kicks-ass.net>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
	 <1406524724-17946-4-git-send-email-davidlohr@hp.com>
	 <20140728090821.GO6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-28 at 11:08 +0200, Peter Zijlstra wrote:
> On Sun, Jul 27, 2014 at 10:18:41PM -0700, Davidlohr Bueso wrote:
> > +static bool mutex_optimistic_spin(struct mutex *lock,
> > +				  struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
> > +{
> 
> 
> > +	/*
> > +	 * If we fell out of the spin path because of need_resched(),
> > +	 * reschedule now, before we try-lock the mutex. This avoids getting
> > +	 * scheduled out right after we obtained the mutex.
> > +	 */
> > +	if (need_resched())
> > +		schedule_preempt_disabled();
> > +
> > +	return false;
> > +}
> 
> 
> > +	if (mutex_optimistic_spin(lock, ww_ctx, use_ww_ctx)) {
> > +		/* got it, yay! */
> > +		preempt_enable();
> > +		return 0;
> >  	}
> > +
> >  	/*
> >  	 * If we fell out of the spin path because of need_resched(),
> >  	 * reschedule now, before we try-lock the mutex. This avoids getting
> > @@ -475,7 +512,7 @@ slowpath:
> >  	 */
> >  	if (need_resched())
> >  		schedule_preempt_disabled();
> > +
> >  	spin_lock_mutex(&lock->wait_lock, flags);
> 
> We now have two if (need_resched) schedule_preempt_disable() instances,
> was that on purpose?

I think we can delete the extra check in mutex_optimistic_spin(). It is
sufficient to have it here and it also covers the case where the task
need_resched() without attempting to spin.


