Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaKVA4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 19:56:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36313 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbaKVA4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 19:56:47 -0500
Message-ID: <1416617795.17594.14.camel@linux-t7sj.site>
Subject: Re: [PATCH] ipc,sem block sem_lock on sma->lock during sma
 initialization
From: Davidlohr Bueso <dave@stgolabs.net>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Manfred Spraul <manfred@colorfullife.com>,
        Rafael Aquini <aquini@redhat.com>
Date: Fri, 21 Nov 2014 16:56:35 -0800
In-Reply-To: <546FC4D9.6010600@redhat.com>
References: <20141121145226.2ac598af@annuminas.surriel.com>
	 <20141121120930.3cd8d0f233f9670d689de672@linux-foundation.org>
	 <546FA0A7.2010507@redhat.com>
	 <20141121124229.933a9b6ef9725a4032c95d45@linux-foundation.org>
	 <546FC4D9.6010600@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-21 at 18:03 -0500, Rik van Riel wrote:
> On 11/21/2014 03:42 PM, Andrew Morton wrote:
> > On Fri, 21 Nov 2014 15:29:27 -0500 Rik van Riel <riel@redhat.com>
> > wrote:
> > 
> >> On 11/21/2014 03:09 PM, Andrew Morton wrote:
> >>> On Fri, 21 Nov 2014 14:52:26 -0500 Rik van Riel
> >>> <riel@redhat.com> wrote:
> >>> 
> >>>> When manipulating just one semaphore with semop, sem_lock
> >>>> only takes that single semaphore's lock. This creates a
> >>>> problem during initialization of the semaphore array, when
> >>>> the data structures used by sem_lock have not been set up
> >>>> yet. The sma->lock is already held by newary, and we just
> >>>> have to make sure everything else waits on that lock during
> >>>> initialization.
> >>>> 
> >>>> Luckily it is easy to make sem_lock wait on the sma->lock,
> >>>> by pretending there is a complex operation in progress while
> >>>> the sma is being initialized.
> >>>> 
> >>>> The newary function already zeroes sma->complex_count before 
> >>>> unlocking the sma->lock.
> >>> 
> >>> What are the runtime effects of the bug?
> >>> 
> >> 
> >> NULL pointer dereference in spin_lock from sem_lock, if it is
> >> called before sma->sem_base has been pointed somewhere valid.
> > 
> > Help us out here.  People need to use this description to work out 
> > which kernel versions need the patch and whether to backport the
> > fix into their various kernels.  Other people will be starting at
> > this changelog wondering "will this fix the bug my customer has
> > reported".
> > 
> > Is there some bug report people can look at?

This would be nice for the changelog...

> > 
> > What userspace actions trigger this bug?
> 
> The reason the bug took almost two years to get noticed is that
> it takes one task doing a semop on a semaphore in an array that
> is still getting instantiated by newary (getsem) from another
> task.
> 
> In other words, if you try to use a semaphore array before
> getsem returns, you can oops the task that calls semop.

This seems bogus from an application level: how can you call semop if
you don't have the semid yet returned from semget? And the fact that the
race is with newary, means that the call is in fact creating a *new*
set, as opposed to plugging into an already existing set.

The fix in newary() being before the actual creation of the id seems
even stranger:

	sma->complex_count = 1;
	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);

As for semtimedop() before even getting to sem_lock(), we first call:

	sma = sem_obtain_object_check(ns, semid);

So shouldn't that fail anyway before we even consider acquiring the lock?

Thanks,
Davidlohr

