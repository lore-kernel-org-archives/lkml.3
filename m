Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaFDVxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:53:51 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:16207 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaFDVxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:53:50 -0400
X-Greylist: delayed 4966 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jun 2014 17:53:50 EDT
Message-ID: <1401918827.2232.37.camel@j-VirtualBox>
Subject: Re: [RFC PATCH 1/3] locking/mutex: Try to acquire mutex only if it
 is unlocked
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        tim.c.chen@linux.intel.com, peter@hurleysoftware.com, riel@redhat.com,
        hpa@zytor.com, walken@google.com, Waiman.Long@hp.com, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Date: Wed, 04 Jun 2014 14:53:47 -0700
In-Reply-To: <1401915420.13877.20.camel@buesod1.americas.hpqcorp.net>
References: <1401908911-8947-1-git-send-email-jason.low2@hp.com>
	 <1401908911-8947-2-git-send-email-jason.low2@hp.com>
	 <20140604194322.GN13930@laptop.programming.kicks-ass.net>
	 <1401915420.13877.20.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-04 at 13:57 -0700, Davidlohr Bueso wrote:
> On Wed, 2014-06-04 at 21:43 +0200, Peter Zijlstra wrote:
> > On Wed, Jun 04, 2014 at 12:08:29PM -0700, Jason Low wrote:
> > > Upon entering the slowpath in __mutex_lock_common(), we try once more
> > > to acquire the mutex. We only try to acquire it if MUTEX_SHOW_NO_WAITER
> > > (lock->count >= 0) is true in order to avoid using the atomic xchg()
> > > operation whenever it is not necessary. However, we really only need
> > > to try to acquire if the mutex is free (lock->count == 1).
> > > 
> > > This patch changes it so that we only try-acquire the mutex upon
> > > entering the slowpath if it is unlocked, rather than if there are
> > > no waiters. This helps further reduce unncessary atomic xchg()
> > > operations. Furthermore, this patch introduces and uses a new
> > > MUTEX_IS_UNLOCKED() macro to improve readbability.
> > > 
> > > Signed-off-by: Jason Low <jason.low2@hp.com>
> > > ---
> > >  kernel/locking/mutex.c |   10 ++++++----
> > >  1 files changed, 6 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> > > index bc73d33..0925968 100644
> > > --- a/kernel/locking/mutex.c
> > > +++ b/kernel/locking/mutex.c
> > > @@ -48,9 +48,10 @@
> > >  
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
> Agreed. 
> 
> In addition, how about the following helpers instead:
> - mutex_is_unlocked() : count > 0
> - mutex_has_waiters() : count < 0, or list_empty(->wait_list)

Sounds good. Likewise, for "mutex_is_unlocked()" I've noticed that there
is a mutex_is_locked() function provided in the linux/mutex.h file.
Perhaps we can just reuse that function and use !mutex_is_locked() for
places where we want to check if unlocked?


