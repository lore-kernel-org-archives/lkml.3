Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964803AbaEQMg2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 08:36:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932389AbaEQMg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 08:36:27 -0400
Date: Sat, 17 May 2014 08:36:02 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mateusz Guzik <mguzik@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH] kref: warn on uninitialized kref
In-Reply-To: <20140517110454.GA1939@mguzik.redhat.com>
Message-ID: <alpine.LRH.2.02.1405170823371.15837@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1405170647430.15837@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1405170650440.15837@file01.intranet.prod.int.rdu2.redhat.com> <20140517110454.GA1939@mguzik.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 17 May 2014, Mateusz Guzik wrote:

> On Sat, May 17, 2014 at 06:53:17AM -0400, Mikulas Patocka wrote:
> > I found a memory leak in iSCSI target that was caused by kref initialized
> > to zero (the memory object was allocated with kzalloc, kref_init was not
> > called and kref_put_spinlock_irqsave was called which changed "0" to "-1"
> > and didn't free the object).
> > 
> > Similar bugs may exist in other kernel areas, so I submit this patch that
> > adds a check to kref.h. If the value is zero or negative, we can assume
> > that it is uninitialized and we warn about it.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > ---
> >  include/linux/kref.h |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > Index: linux-3.15-rc5/include/linux/kref.h
> > ===================================================================
> > --- linux-3.15-rc5.orig/include/linux/kref.h	2013-07-02 22:23:38.000000000 +0200
> > +++ linux-3.15-rc5/include/linux/kref.h	2014-05-16 18:56:18.000000000 +0200
> > @@ -69,7 +69,7 @@ static inline int kref_sub(struct kref *
> >  	     void (*release)(struct kref *kref))
> >  {
> >  	WARN_ON(release == NULL);
> > -
> > +	WARN_ON_ONCE(atomic_read(&kref->refcount) <= 0);
> >  	if (atomic_sub_and_test((int) count, &kref->refcount)) {
> >  		release(kref);
> >  		return 1;
> > @@ -119,6 +119,7 @@ static inline int kref_put_spinlock_irqs
> >  	unsigned long flags;
> >  
> >  	WARN_ON(release == NULL);
> > +	WARN_ON_ONCE(atomic_read(&kref->refcount) <= 0);
> >  	if (atomic_add_unless(&kref->refcount, -1, 1))
> >  		return 0;
> >  	spin_lock_irqsave(lock, flags);
> > @@ -136,6 +137,7 @@ static inline int kref_put_mutex(struct 
> >  				 struct mutex *lock)
> >  {
> >  	WARN_ON(release == NULL);
> > +	WARN_ON_ONCE(atomic_read(&kref->refcount) <= 0);
> >  	if (unlikely(!atomic_add_unless(&kref->refcount, -1, 1))) {
> >  		mutex_lock(lock);
> >  		if (unlikely(!atomic_dec_and_test(&kref->refcount))) {
> 
> This has a side effect of detecting some overputs, which is nice.
> 
> However, could be made better if kref_sub checked that refs you want to
> take don't put the count below 0.
> 
> i.e.
> WARN_ON(count > atomic_read(&kref->refcount));
> 
> this also detects your original problem.
> 
> -- 
> Mateusz Guzik

Good point. I'm sending the updated patch.

Mikulas
