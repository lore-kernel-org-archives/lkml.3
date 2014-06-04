Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaFDVyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:54:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:41496 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaFDVyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:54:52 -0400
Date: Wed, 4 Jun 2014 23:54:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jason Low <jason.low2@hp.com>
cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, tim.c.chen@linux.intel.com,
        peter@hurleysoftware.com, riel@redhat.com, hpa@zytor.com,
        walken@google.com, davidlohr@hp.com, Waiman.Long@hp.com, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [RFC PATCH 1/3] locking/mutex: Try to acquire mutex only if it
 is unlocked
In-Reply-To: <1401917173.2232.14.camel@j-VirtualBox>
Message-ID: <alpine.DEB.2.10.1406042337110.18296@nanos>
References: <1401908911-8947-1-git-send-email-jason.low2@hp.com>  <1401908911-8947-2-git-send-email-jason.low2@hp.com>  <20140604194322.GN13930@laptop.programming.kicks-ass.net> <1401917173.2232.14.camel@j-VirtualBox>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Jason Low wrote:
> On Wed, 2014-06-04 at 21:43 +0200, Peter Zijlstra wrote:
> > >  /*
> > >   * A negative mutex count indicates that waiters are sleeping waiting for the
> > > - * mutex.
> > > + * mutex, and a count of one indicates the mutex is unlocked.
> > >   */
> > >  #define	MUTEX_SHOW_NO_WAITER(mutex)	(atomic_read(&(mutex)->count) >= 0)
> > > +#define	MUTEX_IS_UNLOCKED(mutex)	(atomic_read(&(mutex)->count) == 1)
> > 
> > So I recently saw that MUTEX_SHOW_NO_WAITER thing and cried a little;
> > and now you're adding more of that same nonsense.
> > 
> > Please make them inline functions, also can we rename the SHOW_NO_WAITER
> > thing, because its not at all clear to me wtf it does; should it be
> > called: mutex_no_waiters() or somesuch?
> 
> Okay, I can make them inline functions. I mainly added the macro to keep
> it consistent with the MUTEX_SHOW_NO_WAITER() check, but we can surely

Consistency with a digusting and nonsensical macro is not really a
good argument.

> make this more clear. mutex_no_waiters() sounds fine, or perhaps
> something like mutex_has_no_waiters()?

Uuurg. So we end up with

       if (!mutex_has_no_waiters(m))

if we check for waiters?

Can we please go with the most intuitive thing:

    mutex_has_waiters()

and have the callsites prepend the '!' in case they want to check
there is no waiter?

For heavens sake, we do not name macros/inlines in a way which fits
the intended use case. We name them so they make sense.

Your change log blurbs about readability. I have no idea what your
understandig of readability is, but neither MUTEX_SHOW_NO_WAITERS nor
mutex_has_no_waiters qualify for me. Ditto for MUTEX_IS_UNLOCKED.

Care to look at the other lock implementations:

     rt_mutex_has_waiters()
     spin_is_locked()
     ....

Why would it make sense to come up with reverse conventions for mutex?

Thanks,

	tglx
