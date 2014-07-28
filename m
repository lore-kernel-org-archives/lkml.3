Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaG1QlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:41:12 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:53598 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaG1QlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:41:11 -0400
Message-ID: <1406565669.25428.2.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH -tip/master 4/7] locking/mutex: Refactor optimistic
 spinning code
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jason Low <jason.low2@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Jul 2014 09:41:09 -0700
In-Reply-To: <1406565588.2411.8.camel@j-VirtualBox>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
	 <1406524724-17946-4-git-send-email-davidlohr@hp.com>
	 <20140728090821.GO6758@twins.programming.kicks-ass.net>
	 <1406565588.2411.8.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-28 at 09:39 -0700, Jason Low wrote:
> On Mon, 2014-07-28 at 11:08 +0200, Peter Zijlstra wrote:
> > On Sun, Jul 27, 2014 at 10:18:41PM -0700, Davidlohr Bueso wrote:
> > > +static bool mutex_optimistic_spin(struct mutex *lock,
> > > +				  struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
> > > +{
> > 
> > 
> > > +	/*
> > > +	 * If we fell out of the spin path because of need_resched(),
> > > +	 * reschedule now, before we try-lock the mutex. This avoids getting
> > > +	 * scheduled out right after we obtained the mutex.
> > > +	 */
> > > +	if (need_resched())
> > > +		schedule_preempt_disabled();
> > > +
> > > +	return false;
> > > +}
> > 
> > 
> > > +	if (mutex_optimistic_spin(lock, ww_ctx, use_ww_ctx)) {
> > > +		/* got it, yay! */
> > > +		preempt_enable();
> > > +		return 0;
> > >  	}
> > > +
> > >  	/*
> > >  	 * If we fell out of the spin path because of need_resched(),
> > >  	 * reschedule now, before we try-lock the mutex. This avoids getting
> > > @@ -475,7 +512,7 @@ slowpath:
> > >  	 */
> > >  	if (need_resched())
> > >  		schedule_preempt_disabled();
> > > +
> > >  	spin_lock_mutex(&lock->wait_lock, flags);
> > 
> > We now have two if (need_resched) schedule_preempt_disable() instances,
> > was that on purpose?
> 
> I think we can delete the extra check in mutex_optimistic_spin(). It is
> sufficient to have it here and it also covers the case where the task
> need_resched() without attempting to spin.

Yes, I need to delete the second check, one is enough.

