Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965716Ab3E2LO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:14:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51381 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965590Ab3E2LO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:14:56 -0400
Date: Wed, 29 May 2013 13:14:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/9] liblockdep: Add public headers for
 pthread_mutex_t implementation
Message-ID: <20130529111451.GF12193@twins.programming.kicks-ass.net>
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
 <1368674141-10796-4-git-send-email-sasha.levin@oracle.com>
 <20130522092232.GF18810@twins.programming.kicks-ass.net>
 <51A5069F.7050607@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A5069F.7050607@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 03:33:51PM -0400, Sasha Levin wrote:
> On 05/22/2013 05:22 AM, Peter Zijlstra wrote:
> > They will however then also want all the 'normal' lockdep annotations to
> > deal with that like:
> > 
> > liblockdep_pthread_mutex_lock_nested()
> > liblockdep_pthread_mutex_lock_nest_lock()
> > 
> > *phew* and here I always though pthread_mutex_* was a long prefix...
> > 
> > Also, the above doesn't have the full lockstat contention hooks -- not
> > sure that's on purpose or not.
> 
> I was quietly hoping on leaving this out in the initial version of liblockdep
> and start adding this and the rest of the toys that come with lockdep once we
> figure out whether this code will go into the kernel tree or not.
> 
> Should I be adding them now?

I think you'll need them very quicky one you actually start using this
stuff, but sure, add them when you need them.

> >> +
> >> +static inline int liblockdep_pthread_mutex_unlock(liblockdep_pthread_mutex_t *lock)
> >> +{
> >> +	lock_release(&lock->dep_map, 0, (unsigned long)_RET_IP_);
> >> +	return pthread_mutex_unlock(&lock->mutex);
> >> +}
> >> +
> >> +static inline int liblockdep_pthread_mutex_trylock(liblockdep_pthread_mutex_t *lock)
> >> +{
> >> +	lock_acquire(&lock->dep_map, 0, 1, 0, 2, NULL, (unsigned long)_RET_IP_);
> >> +	return pthread_mutex_trylock(&lock->mutex) == 0 ? 1 : 0;
> >> +}
> >> +
> >> +static inline int liblockdep_pthread_mutex_destroy(liblockdep_pthread_mutex_t *lock)
> >> +{
> >> +	return pthread_mutex_destroy(&lock->mutex);
> >> +}
> >> +
> >> +#ifdef __USE_LIBLOCKDEP
> >> +
> >> +#define pthread_mutex_t         liblockdep_pthread_mutex_t
> >> +#define pthread_mutex_init      liblockdep_pthread_mutex_init
> >> +#define pthread_mutex_lock      liblockdep_pthread_mutex_lock
> >> +#define pthread_mutex_unlock    liblockdep_pthread_mutex_unlock
> >> +#define pthread_mutex_trylock   liblockdep_pthread_mutex_trylock
> >> +#define pthread_mutex_destroy   liblockdep_pthread_mutex_destroy
> > 
> > Given the liblockdep_* things use 'proper' classes do you want this
> > mapping? If you do, should we use the same alias nonsense glibc uses or
> > are CPP macros good enough for us?
> > 
> 
> I think that this will be good enough for our purpose, why wouldn't these
> simple macros be enough?

Suppose you have a funny someone who added a function called:
pthread_mutex_lock_obj() or somesuch, imagine what the CPP thing will
make of that :-)

Then again, people doing that might deserve what they get ;-)
