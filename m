Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab3ILXhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 19:37:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:33228 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab3ILXhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 19:37:05 -0400
Date: Fri, 13 Sep 2013 01:36:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhart@linux.intel.com>
cc: Chen Gang <gang.chen@asianux.com>, ccross@android.com,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/futex.c: notice the return value after
 rt_mutex_finish_proxy_lock() fails
In-Reply-To: <1379025421.1285.55.camel@dvhart-mobl4.amr.corp.intel.com>
Message-ID: <alpine.DEB.2.02.1309130040140.4089@ionos.tec.linutronix.de>
References: <5212DD71.7070208@asianux.com>  <alpine.DEB.2.02.1309121627040.4089@ionos.tec.linutronix.de> <1379025421.1285.55.camel@dvhart-mobl4.amr.corp.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Darren Hart wrote:
> On Thu, 2013-09-12 at 16:32 +0200, Thomas Gleixner wrote:
> > On Tue, 20 Aug 2013, Chen Gang wrote:
> > 
> > > rt_mutex_finish_proxy_lock() can return failure code (e.g. -EINTR,
> > > -ETIMEDOUT).
> > > 
> > > Original implementation has already noticed about it, but not check it
> > > before next work.
> > > 
> > > Also let coments within 80 columns to pass "./scripts/checkpatch.pl".
> > > 
> > > 
> > > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> > > ---
> > >  kernel/futex.c |   30 ++++++++++++++++--------------
> > >  1 files changed, 16 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/kernel/futex.c b/kernel/futex.c
> > > index c3a1a55..1a94e7d 100644
> > > --- a/kernel/futex.c
> > > +++ b/kernel/futex.c
> > > @@ -2373,21 +2373,23 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
> > >               ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
> > >               debug_rt_mutex_free_waiter(&rt_waiter);
> > >  
> > > -             spin_lock(q.lock_ptr);
> > > -             /*
> > > -              * Fixup the pi_state owner and possibly acquire the lock if we
> > > -              * haven't already.
> > > -              */
> > > -             res = fixup_owner(uaddr2, &q, !ret);
> > > -             /*
> > > -              * If fixup_owner() returned an error, proprogate that.  If it
> > > -              * acquired the lock, clear -ETIMEDOUT or -EINTR.
> > > -              */
> > > -             if (res)
> > > -                     ret = (res < 0) ? res : 0;
> > > +             if (!ret) {
> > 
> > Again. This is completely wrong!  
> > 
> > We MUST call fixup_owner even if finish_proxy_lock() returned with an
> > error code. Simply because finish_proxy_lock() is called outside of
> > the spin_lock(q.lock_ptr) region and another thread might have
> > modified the futex state. So we need to handle the corner cases
> > otherwise we might leave the futex in some undefined state.
> > 
> > You're reintroducing a hard to decode bug, which got analyzed and
> > fixed in futex_lock_pi() years ago. See the history for the
> > explanation.
> > 
> > Sigh.
> > 
> >         tglx
> 
> Chen, perhaps you can let us know what the failure scenario is that you
> are trying to address with this patch.

No failure scenario at all.

Chen is on a self defined agenda to fix random kernel bugs in random
kernel subdirectories on a given rate by all means. (Google yourself
for the details.)

That crusade does not involve any failure analysis or test cases. It's
just driven by mechanically checking the code for inconsistencies. Now
he tripped over a non obvious return value chain in the futex code. So
instead of figuring out why it is coded this way, he just mechanically
decided that there is a missing check. Though:

The return value is checked and it needs deep understanding of the way
how futexes work to grok why it's necessary to invoke fixup_owner()
independent of the rt_mutex_finish_proxy_lock() return value.

The code in question is:

	ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);

	spin_lock(q.lock_ptr);
	/*
	 * Fixup the pi_state owner and possibly acquire the lock if we
	 * haven't already.
	 */
	res = fixup_owner(uaddr2, &q, !ret);
	/*
	 * If fixup_owner() returned an error, proprogate that.  If it
	 * acquired the lock, clear -ETIMEDOUT or -EINTR. 
	 */
	if (res)
		ret = (res < 0) ? res : 0;

If you can understand the comments in the code and you are able to
follow the implementation of fixup_owner() and the usage of "!ret" as
an argument you really should be able to figure out, why this is
correct.

I'm well aware, as you are, that this code is hard to grok. BUT:

If this code in futex_wait_requeue_pi() is wrong why did Chen's
correctness checker not trigger on the following code in
futex_lock_pi()?:

	if (!trylock)
		ret = rt_mutex_timed_lock(&q.pi_state->pi_mutex, to, 1);
	else {
		ret = rt_mutex_trylock(&q.pi_state->pi_mutex);
		/* Fixup the trylock return value: */
		ret = ret ? 0 : -EWOULDBLOCK;
	}

	spin_lock(q.lock_ptr);
	/*
	 * Fixup the pi_state owner and possibly acquire the lock if we
	 * haven't already.
	 */
	res = fixup_owner(uaddr, &q, !ret);
	/*
	 * If fixup_owner() returned an error, proprogate that.  If it acquired
	 * the lock, clear our -ETIMEDOUT or -EINTR.
	 */
	if (res)
		ret = (res < 0) ? res : 0;

It's the very same pattern and according to Chen's logic broken as
well.

As I recommended to Chen to read the history of futex.c, I just can
recommend the same thing to you to figure out why the heck this is the
correct way to handle it.

Hint: The relevant commit starts with: cdf

The code has changed quite a bit since then, but the issue which is
described quite well in the commit log is still the same.

Just for the record:

     Line 48 of futex.c says: "The futexes are also cursed."

Thanks,

	tglx
